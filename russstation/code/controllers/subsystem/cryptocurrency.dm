// tracks diminishing returns for "computing" more proof-of-work hashes
SUBSYSTEM_DEF(cryptocurrency)
	name = "Cryptocurrency"
	wait = 1 MINUTES // like economy, doesn't need to run frequently - maybe 1 minute?
	runlevels = RUNLEVEL_GAME // doesn't need to run during setup/postgame
	priority = FIRE_PRIORITY_DEFAULT - 1 // this isn't as important as similar subsystems

	// funny name for display
	var/coin_name = "SpaceCoin"
	// the "person" that made the coin, used for some special alerts
	var/nerd_name = "cake" // haha but not really :o)
	// factor to reduce machine performance over time
	var/complexity = 1
	// complexity growth factor, multiplicative
	var/complexity_growth = 1.01
	// how much is payed out for an individual mining operation. scales inversely with complexity
	var/payout = 1000
	// is market trending up or down?
	var/market_trend_up = TRUE
	// how much payout can change by each time multiplicative
	var/market_change_factor = 0.1
	// how much energy has been spent calculating the next payout
	var/progress = 0
	// how many work units are required to compute a hash and get paid
	// does NOT need adjusted normally because we instead tweak the progress generation
	var/progress_required = 30000
	// how many NT credits a single coin of this currency is worth (purely for flavor)
	var/exchange_rate = 1

	// history tracking
	// list of sums for each processing period
	var/list/mining_history = list()
	var/list/payout_history = list()
	// amount processed between SS fires
	var/mining_processed = 0
	var/payout_processed = 0
	// grand totals
	var/total_mined = 0
	var/total_payout = 0

	// market fluctuation and events
	// minimum time between crypto events
	var/event_cooldown = 5 MINUTES
	// time of last event
	var/last_event = 0
	// prob we roll event on an SS fire
	var/event_chance = 10
	// increase chance if we don't proc event
	var/event_chance_growth = 5
	// events that we pick from when there are no "planned" events
	var/list/random_events = list(
		/datum/round_event_control/cryptocurrency/market_crash,
		/datum/round_event_control/cryptocurrency/market_boom,
		/datum/round_event_control/cryptocurrency/card_stock
	)
	// we could just typesof, but this ensures the order is correct
	var/list/card_packs = list(
		/datum/supply_pack/engineering/crypto_mining_card,
		/datum/supply_pack/engineering/crypto_mining_card/two,
		/datum/supply_pack/engineering/crypto_mining_card/three,
		/datum/supply_pack/engineering/crypto_mining_card/four
	)
	// track how many graphics card packs we've unlocked
	var/card_packs_unlocked = 0
	// how much total payout to release next card
	var/list/card_release_thresholds = list(0, 50000, 150000, 400000)
	// if we've paid out this much, crypto is over. go home. stop playing.
	var/market_cap = 1000000 // yeah that's a bicycle

/datum/controller/subsystem/cryptocurrency/Initialize(timeofday)
	// coin of the day
	coin_name = pick(list(
		"SpaceCoin",
		"StarBucks", // this is clearly legally distinct
		"ClownCoin",
		"MimeMoney",
		"FunnyMoney",
		"RussMoney", // haha i referenced the streamer
		"SyndiCoin",
		"BananaBucks",
		))
	// either a fraction or a large number
	exchange_rate = pick(list(rand(), rand(10, 100)))
	// inspired by the bitcoin creator but meme?
	nerd_name = "[pick(list("Satoshi", "Kiryu", "Doraemon", "Greg"))] [pick(list("Naka", "Baka", "Shiba", "Tako"))][pick(list("moto", "mura", "nashi", "bana"))]"
	return ..()

// add mining progress and calculate payouts if qualified
/datum/controller/subsystem/cryptocurrency/proc/mine(power)
	if(!can_fire)
		return
	// *obviously* don't actually do crypto hash calculations, the game lags enough as is
	// just consume power and add it to progress
	progress += power
	mining_processed += power
	total_mined += power
	// complexity already factored into power at machine level
	if(progress >= progress_required)
		progress = 0 // lose excess progress lol
		complexity *= complexity_growth
		// what if we could pay out to other accounts?
		var/datum/bank_account/the_dump = SSeconomy.get_dep_account(ACCOUNT_CAR)
		payout = adjust_payout()
		payout_processed += payout
		total_payout += payout
		the_dump.adjust_money(ROUND_UP(payout)) // don't pay fractions of credits
		// funny payout message for machine to shout
		return "Successfully computed a proof-of-work hash on the blockchain! [payout * exchange_rate] [coin_name] payed to the [ACCOUNT_CAR_NAME] account."

// pick next payout amount slightly randomly
/datum/controller/subsystem/cryptocurrency/proc/adjust_payout()
	// min < 1 means value fluctuates instead of only going in trend direction
	var/min_change = 1 - market_change_factor
	// increased factor by event_chance% so trend direction is more likely, especially just before events
	var/max_change = 1 + market_change_factor + event_chance / 100
	var/change = rand(min_change, max_change)
	if(market_trend_up)
		return payout * change
	else
		return payout / change

/datum/controller/subsystem/cryptocurrency/fire(resumed = 0)
	// add processed amounts from this period to history lists
	mining_history += mining_processed
	payout_history += payout_processed
	// if amounts were 0, don't process anything else
	if(mining_processed == 0 && payout_processed == 0)
		return
	// process events - we don't want them eating up "real" event opportunities so gotta handle manually
	var/now = REALTIMEOFDAY
	if(now > last_event + event_cooldown)
		if(prob(event_chance))
			var/datum/round_event_control/event
			event_chance = initial(event_chance)
			last_event = now
			// check event conditions - either do a priority event or fallback on random ones
			// if we've mined enough, unlock a new card - always first event
			if(card_packs_unlocked < card_packs.len && total_payout >= card_release_thresholds[card_packs_unlocked])
				event = SSevents.control[/datum/round_event_control/cryptocurrency/card_release]
			// if we're mining a whole payout in one period, increase complexity
			else if(mining_processed > progress_required)
				event = SSevents.control[/datum/round_event_control/cryptocurrency/algorithm_change]
			// check if we've paid the market cap (because it's buried here, can pay slightly more than cap)
			else if(total_payout >= market_cap)
				// not an event so admemes can't force this
				priority_announce("The market cap for [coin_name] has been paid. Congratulations! You won crypto! Please touch grass.", "[SScryptocurrency.coin_name] Creator [SScryptocurrency.nerd_name]")
				// idea: destroy all existing crypto machines??
				can_fire = FALSE
			// else do one of the random events
			else
				event = SSevents.control[pickEvent()]
			// finally run the event
			if(event)
				event.runEvent(TRUE)
		else
			// increase chance for next time
			event_chance += event_chance_growth
	// finally reset processed trackers
	mining_processed = 0
	payout_processed = 0

// copied and modified from SSevents so crypto events don't block real events
/datum/controller/subsystem/cryptocurrency/proc/pickEvent()
	// adjust event weights and sum them
	var/sum_of_weights = 0
	for(var/datum/round_event_control/cryptocurrency/E in random_events)
		E.adjust_weight()
		sum_of_weights += E.weight

	sum_of_weights = rand(0,sum_of_weights) //reusing this variable. It now represents the 'weight' we want to select

	// now subtract event weights until we hit our random target
	for(var/datum/round_event_control/cryptocurrency/E in random_events)
		sum_of_weights -= E.weight]
		if(sum_of_weights <= 0) //we've hit our goal
			return E
	// didn't pick an event somehow, this will crash so return *something*. shouldn't occur!
	return pick(random_events)

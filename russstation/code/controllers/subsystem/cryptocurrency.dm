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
	// how much is payed out for an individual mining operation
	var/payout_min = 800
	var/payout_max = 1200
	// how much energy has been spent calculating the next payout
	var/progress = 0
	// how many work units are required to compute a hash and get paid
	var/progress_required = 10000
	// how much required progress grows after each pay
	var/progress_required_growth = 1.01
	// how much coin has been mined and waiting to convert to credits
	var/wallet = 0

	// history tracking
	// list of sums for each processing period
	var/list/mining_history = list()
	var/list/payout_history = list()
	var/list/exchange_rate_history = list()
	// amount processed between SS fires
	var/mining_processed = 0
	var/payout_processed = 0
	// grand totals
	var/total_mined = 0
	var/total_payout = 0

	// market fluctuation and events
	// is market trending up or down?
	var/market_trend_up = TRUE
	// how much payout can change by each time multiplicative
	var/market_change_factor = 0.1
	// how likely to change trend each process
	var/market_change_chance = 10
	// how many NT credits a single coin of this currency is worth
	var/exchange_rate = 0.05
	// minimum time between crypto events
	var/event_cooldown_min = 6 MINUTES
	var/event_cooldown_max = 12 MINUTES
	// time of next event
	var/next_event = 0
	// prob we roll event on an SS fire
	var/event_chance = 10
	// increase chance if we don't proc event
	var/event_chance_growth = 10
	// events that we pick from when there are no "planned" events
	var/list/random_events = list()
	// maps packs to their release payout thresholds
	var/list/card_packs_thresholds = list(
		/datum/supply_pack/engineering/crypto_mining_card/two = 50000,
		/datum/supply_pack/engineering/crypto_mining_card/three = 150000,
		/datum/supply_pack/engineering/crypto_mining_card/four = 400000
	)
	// track released packs count
	var/released_cards_count = 0
	// if we've paid out this much, crypto is over. go home. stop playing.
	var/market_cap = 1000000

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
	// inspired by the bitcoin creator but meme?
	nerd_name = "[pick(list("Satoshi", "Kiryu", "Doraemon", "Greg"))] [pick(list("Naka", "Baka", "Shiba", "Tako"))][pick(list("moto", "mura", "nashi", "bana"))]"
	// initialize event cache - copied from SSevents
	for(var/type in subtypesof(/datum/round_event_control/cryptocurrency))
		var/datum/round_event_control/cryptocurrency/E = new type()
		if(!E.typepath)
			continue // don't want this one!
		random_events += E // add it to the list of crypto events
	return SS_INIT_SUCCESS

// add mining progress and calculate payouts if qualified
/datum/controller/subsystem/cryptocurrency/proc/mine(power)
	if(!can_fire)
		return
	// *obviously* don't actually do crypto hash calculations, the game lags enough as is
	// just consume power and add it to progress
	progress += power
	mining_processed += power
	total_mined += power
	if(progress >= progress_required)
		progress = 0 // lose excess progress lol
		// next payout requires slightly more progress
		progress_required *= progress_required_growth
		var/payout = rand(payout_min, payout_max)
		wallet += payout
		payout_processed += payout
		total_payout += payout
		// funny payout message for machine to shout
		return "Successfully computed a proof-of-work hash on the blockchain! [payout] [coin_name] awarded."

// pick next exchange rate slightly randomly
/datum/controller/subsystem/cryptocurrency/proc/adjust_exchange_rate(rate)
	// min < 1 means value fluctuates instead of only going in trend direction
	var/min_change = 1 - market_change_factor
	// increased factor by event_chance% so trend direction is more likely, especially just before events
	var/max_change = 1 + market_change_factor + event_chance / 100
	var/change = LERP(min_change, max_change, rand())
	if(market_trend_up)
		return rate * change
	else
		return rate / change

// withdraw coin and exchange to credits
/datum/controller/subsystem/cryptocurrency/proc/cash_out(mob/user)
	if(wallet == 0)
		return
	// how much credits we're paying out based on current exchange rate
	var/amount = wallet
	var/credits = amount * exchange_rate
	wallet = 0
	// what if we could pay out to other accounts?
	var/datum/bank_account/the_dump = SSeconomy.get_dep_account(ACCOUNT_CAR)
	the_dump.adjust_money(credits)
	var/blame = "Someone"
	if(user && istype(user))
		blame = user.name
	return "[blame] exchanged [amount] [coin_name] for [credits] Credits, paid to the [ACCOUNT_CAR_NAME] account."

/datum/controller/subsystem/cryptocurrency/fire(resumed = 0)
	// small chance to flip the trend so it's more dynamic between events
	if(prob(market_change_chance))
		market_trend_up = !market_trend_up
	exchange_rate = adjust_exchange_rate(exchange_rate)
	// add processed amounts from this period to history lists
	mining_history += mining_processed
	payout_history += payout_processed
	exchange_rate_history += exchange_rate
	// if amounts were 0, don't process anything else- no events when no one is mining
	if(mining_processed == 0 && payout_processed == 0)
		return
	// process events - we don't want them eating up "real" event opportunities so gotta handle manually
	var/now = REALTIMEOFDAY
	if(now >= next_event)
		if(prob(event_chance))
			var/datum/round_event_control/control
			next_event = now + rand(event_cooldown_min, event_cooldown_max)
			// check if we've paid the market cap (because it waits for event fire, can pay slightly more than cap)
			if(total_payout >= market_cap)
				// not an event so admemes can't force this
				priority_announce("The market cap for [coin_name] has been paid. Congratulations! You won crypto! Please touch grass.", "[SScryptocurrency.coin_name] Creator [SScryptocurrency.nerd_name]")
				// idea: destroy all existing crypto machines??
				can_fire = FALSE
			// else do one of the random events
			else
				control = pickEvent()
			// finally run the event
			if(control)
				control.runEvent(TRUE)
			// else no event, just let the market change up and down naturally
		else
			// increase chance for next time
			event_chance += event_chance_growth
	else
		// "animate" market volatility going down after an event
		if(event_chance > initial(event_chance))
			event_chance -= event_chance_growth
	// finally reset processed trackers
	mining_processed = 0
	payout_processed = 0

// copied and modified from SSevents so crypto events don't block real events
/datum/controller/subsystem/cryptocurrency/proc/pickEvent()
	// adjust event weights and sum them
	var/sum_of_weights = 0
	for(var/datum/round_event_control/cryptocurrency/event in random_events)
		event.adjust_weight()
		sum_of_weights += event.weight

	sum_of_weights = rand(0,sum_of_weights) //reusing this variable. It now represents the 'weight' we want to select

	// now subtract event weights until we hit our random target
	for(var/datum/round_event_control/cryptocurrency/event in random_events)
		// don't pick 0 weight events
		if(event.weight == 0)
			continue
		sum_of_weights -= event.weight
		if(sum_of_weights <= 0) //we've hit our goal
			return event

	return null

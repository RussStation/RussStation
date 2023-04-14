// tracks diminishing returns for "computing" more proof-of-work hashes
SUBSYSTEM_DEF(cryptocurrency)
	name = "Cryptocurrency"
	wait = 1 MINUTES // like economy, doesn't need to run frequently - maybe 1 minute?
	runlevels = RUNLEVEL_GAME // doesn't need to run during setup/postgame
	priority = FIRE_PRIORITY_DEFAULT - 1 // this isn't as important as similar subsystems

	// funny name for display
	var/coin_name = "SpaceCoin"
	// how much is payed out for an individual mining operation
	var/payout_min = 800
	var/payout_max = 1200
	// how much energy has been spent calculating the next payout
	var/progress = 0
	// how many work units are required to compute a hash and get paid
	var/progress_required = 10000
	// how many times a payout has been awarded
	var/payouts_earned = 0
	// how much coin has been mined and waiting to convert to credits
	var/wallet = 0

	// machine tracking
	// list of crypto rigs that exist
	var/list/machines = list()

	// history tracking
	// nothing starts until at least one machine runs
	var/started = FALSE
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
	// how much rate can increase/decrease by
	var/potential_growth_percent = 10
	var/potential_decline_percent = 10
	// how likely to cancel the current event's change rates
	var/trend_reset_chance = 10
	// how many NT credits a single coin of this currency is worth
	var/exchange_rate = 0.1
	// time between crypto events
	var/min_event_cooldown = 3 MINUTES
	var/max_event_cooldown = 6 MINUTES
	// how many events have occurred
	var/event_count = 0
	// time of next event
	var/next_event = 0
	// events that we pick from
	var/list/random_events = list()
	// maps packs to their release payout thresholds
	var/list/card_packs_thresholds = list(
		/datum/supply_pack/engineering/crypto_mining_card/tier2 = 125000, // about 2,291,666 progress
		/datum/supply_pack/engineering/crypto_mining_card/tier3 = 250000, // about 10,833,333 progress
		/datum/supply_pack/engineering/crypto_mining_card/tier4 = 500000 // about 71,666,666 progress
	)
	// track released packs count
	var/released_cards_count = 0

/datum/controller/subsystem/cryptocurrency/Initialize(timeofday)
	// coin of the day
	coin_name = pick(world.file2list("russstation/strings/crypto_names.txt"))
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
	// let market start doing stuff
	if(!started)
		started = TRUE
		// wait a bit before first event
		next_event = REALTIMEOFDAY + min_event_cooldown
	// *obviously* don't actually do crypto hash calculations, the game lags enough as is
	// just consume power and add it to progress
	progress += power
	mining_processed += power
	total_mined += power
	if(progress >= progress_required)
		progress = 0 // lose excess progress lol
		payouts_earned += 1
		// next payout requires more progress
		progress_required = 1000 * (10 + (payouts_earned / 25) ** 2)
		var/payout = rand(payout_min, payout_max)
		wallet += payout
		payout_processed += payout
		total_payout += payout
		// funny payout message for machine to shout
		return "Successfully computed a proof-of-work hash on the blockchain! [payout] [coin_name] awarded."

// pick next exchange rate slightly randomly
/datum/controller/subsystem/cryptocurrency/proc/adjust_exchange_rate(rate)
	// small chance to disrupt the market trend so it's more dynamic between events
	if(prob(trend_reset_chance))
		potential_growth_percent = pick(5, 10, 15)
		potential_decline_percent = pick(5, 10, 15)
	var/min_change_percent = 100 - potential_decline_percent
	var/max_change_percent = 100 + potential_growth_percent
	// get a float in the change range and convert percent to fraction for math
	var/change = LERP(min_change_percent, max_change_percent, rand()) / 100
	return rate * change

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
	if(!started)
		return
	// update exchange rate and determine the next value (the market is controlled!)
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
		var/datum/round_event_control/control
		// increment event counter
		event_count += 1
		// how long until next event
		next_event = now + rand(min_event_cooldown, max_event_cooldown)
		// try to do one of the random events
		control = pickEvent()
		if(control)
			control.runEvent(TRUE)
		// else no event, just let the market change up and down naturally
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

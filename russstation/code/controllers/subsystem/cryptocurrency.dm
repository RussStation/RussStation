// tracks diminishing returns for "computing" more proof-of-work hashes
SUBSYSTEM_DEF(cryptocurrency)
	name = "Cryptocurrency"
	wait = 1 MINUTES // like economy, doesn't need to run frequently - maybe 1 minute?
	runlevels = RUNLEVEL_GAME // doesn't need to run during setup/postgame
	priority = FIRE_PRIORITY_DEFAULT - 1 // this isn't as important as similar subsystems

	// funny name for display
	var/coin_name = "SpaceCoin"
	// how much work is required for mining more money. scales power and time
	var/complexity = 1
	// complexity growth factor, multiplicative
	var/complexity_growth = 1.05
	// how much power is required to compute a hash and get paid
	var/power_usage = 30000
	// how much is payed out for an individual mining operation. scales inversely with complexity
	var/payout = 1000
	// how much energy has been spent calculating the next payout
	var/progress = 0
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
	var/event_cooldown = 20 MINUTES
	// time of last event
	var/last_event = 0
	// prob we roll event on an SS fire
	var/event_chance = 10
	// increase chance if we don't proc event
	var/event_chance_growth = 5
	var/list/event_types = list(
		/datum/round_event_control/crypto_market_crash,
		/datum/round_event_control/crypto_market_boom,
		/datum/round_event_control/crypto_algorithm_change,
	)

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
	// set last_event to now so there's no events in beginning of round
	last_event = REALTIMEOFDAY
	return ..()

/datum/controller/subsystem/cryptocurrency/proc/mine(power)
	// *obviously* don't actually do crypto hash calculations, the game lags enough as is
	// just consume power and add it to progress
	progress += power
	mining_processed += power
	total_mined += power
	if(progress >= power_usage * complexity)
		progress = 0
		complexity *= complexity_growth
		// what if we could pay out to other accounts?
		var/datum/bank_account/the_dump = SSeconomy.get_dep_account(ACCOUNT_CAR)
		var/gains = get_payout()
		payout_processed += gains
		total_payout += gains
		the_dump.adjust_money(ROUND_UP(gains))
		// funny payout message for machine to shout
		return "Successfully computed a proof-of-work hash on the blockchain! [gains * exchange_rate] [coin_name] payed to the [ACCOUNT_CAR_NAME] account."

/datum/controller/subsystem/cryptocurrency/proc/get_payout()
	// payouts slowly diminish
	return payout / complexity

/datum/controller/subsystem/cryptocurrency/fire(resumed = 0)
	// add processed amounts from this period to history lists
	mining_history += mining_processed
	payout_history += payout_processed
	// if amounts were 0, don't process anything else
	if(mining_processed == 0 && payout_processed == 0)
		return
	mining_processed = 0
	payout_processed = 0
	// process events
	var/now = REALTIMEOFDAY
	if(now > last_event + event_cooldown)
		if(prob(event_chance))
			event_chance = initial(event_chance)
			last_event = now
			// do the event
			var/datum/round_event_control/round_event_control_type = pick(event_types)
			var/datum/round_event_control/round_event_control = new round_event_control_type
			round_event_control.runEvent(TRUE)
		else
			// increase chance for next time
			event_chance += event_chance_growth

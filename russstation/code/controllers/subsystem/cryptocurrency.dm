// tracks diminishing returns for "computing" more proof-of-work hashes
SUBSYSTEM_DEF(cryptocurrency)
	name = "Cryptocurrency"
	wait = 5 MINUTES // same as economy, doesn't need to run frequently
	init_order = INIT_ORDER_ECONOMY - 1 // it's basically economy, let's init after it
	runlevels = RUNLEVEL_GAME // doesn't need to run during setup/postgame

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
	return ..()

/datum/controller/subsystem/cryptocurrency/proc/mine(power)
	// *obviously* don't actually do crypto hash calculations, the game lags enough as is
	progress += power
	if(progress >= power_usage * complexity)
		progress = 0
		complexity *= complexity_growth
		// what if we could pay out to other accounts?
		var/datum/bank_account/the_dump = SSeconomy.get_dep_account(ACCOUNT_CAR)
		var/gains = get_payout()
		the_dump.adjust_money(ROUND_UP(gains))
		// funny payout message for machine to shout
		return "Successfully computed a proof-of-work hash on the blockchain! [gains * exchange_rate] [coin_name] payed to the [ACCOUNT_CAR_NAME] account."

/datum/controller/subsystem/cryptocurrency/proc/get_payout()
	// payouts slowly diminish
	return payout / complexity

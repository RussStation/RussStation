// mess with crypto mining and annoy everyone who doesn't care
/datum/round_event_control/crypto_market_crash
	name = "Market Crash (Crypto)"
	typepath = /datum/round_event/crypto_market_crash

/datum/round_event_control/crypto_market_crash/canSpawnEvent(players)
	if(!GLOB.cryptocurrency)
		return FALSE
	// don't run event if no one is mining yet
	if(GLOB.cryptocurrency.complexity < 4)
		return FALSE
	return ..()

/datum/round_event/crypto_market_crash
	// crash comes after announcement as "other people" react
	startWhen = 30 SECONDS
	var/reasons = list(
		"a reddit post",
		"a Melon Tusk tweet",
		"boomers",
		"terrorist hackers",
		"someone sneezing",
		"a star going supernova",
		"yo mama",
		"a funny cat video",
		"cargo bounty volume",
		"unmaxed suit sensors",
		"a crewmember",
	)

/datum/round_event/crypto_market_crash/proc/reason()
	var/reason = pick(reasons)
	if(reason == "a crewmember")
		// blame a real person
		var/mob/living/player = pick(GLOB.player_list)
		if(player)
			reason = player.name
	return reason

/datum/round_event/crypto_market_crash/announce(fake)
	priority_announce("Because of [reason()], the [GLOB.cryptocurrency.name] market has crashed! Cash out before it's too late!", "[GLOB.cryptocurrency.name] Speculative Investment Report")

/datum/round_event/crypto_market_crash/start()
	// crypto wallets don't exist so just tank the mining payout and reported value
	var/dip = pick(list(1.5, 2, 2.5, 3))
	GLOB.cryptocurrency.payout = GLOB.cryptocurrency.payout / dip

// boost the market and tempt people to give a damn
/datum/round_event_control/crypto_market_boom
	name = "Market Boom (Crypto)"
	typepath = /datum/round_event/crypto_market_crash/boom
	// likely to happen and early availability so it gets growing
	weight = 30
	earliest_start = 15 MINUTES

/datum/round_event_control/crypto_market_boom/canSpawnEvent(players)
	if(!GLOB.cryptocurrency)
		return FALSE
	return ..()

// subtype crash event to share reasons and timer
/datum/round_event/crypto_market_crash/boom

/datum/round_event/crypto_market_crash/boom/announce(fake)
	priority_announce("Because of [reason()], the [GLOB.cryptocurrency.name] market is booming! Dump your life savings into [GLOB.cryptocurrency.name]!", "[GLOB.cryptocurrency.name] Speculative Investment Report")

/datum/round_event/crypto_market_crash/boom/start()
	// crypto wallets don't exist so just boost the mining payout and reported value
	var/stonks = pick(list(1.5, 2, 2.5, 3, 5))
	GLOB.cryptocurrency.payout = GLOB.cryptocurrency.payout * stonks

// make payouts harder if players are really taking advantage of crypto
/datum/round_event_control/crypto_algorithm_change
	name = "Algorithm Change (Crypto)"
	typepath = /datum/round_event/crypto_algorithm_change
	// likely to happen if spawn condition met
	weight = 20
	earliest_start = 45 MINUTES

/datum/round_event_control/crypto_algorithm_change/canSpawnEvent(players)
	if(!GLOB.cryptocurrency)
		return FALSE
	// crypto hasn't boomed enough for the invisible hand of the market to step in
	if(GLOB.cryptocurrency.payout < 2 * initial(GLOB.cryptocurrency.payout) || GLOB.cryptocurrency.complexity < 4)
		return FALSE
	return ..()

/datum/round_event/crypto_algorithm_change

/datum/round_event/crypto_algorithm_change/announce(fake)
	var/nerd_name = "[pick(list("Satoshi", "Kiryu", "Doraemon", "Greg"))] [pick(list("Naka", "Baka", "Shiba", "Tako"))][pick(list("moto", "mura", "nashi", "bana"))]"
	priority_announce("Because of aggressive mining, the proof-of-work algorithm for [GLOB.cryptocurrency.name] is being changed to be more difficult.", "[GLOB.cryptocurrency.name] Creator [nerd_name]")

/datum/round_event/crypto_algorithm_change/start()
	GLOB.cryptocurrency.complexity = GLOB.cryptocurrency.complexity * 3

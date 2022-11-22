// crypto events all have 0 occurrences because they are not spawned by the normal event system,
// but implementing them here lets admins fire them for memes. see SScryptocurrency

// mess with crypto mining and annoy everyone who doesn't care
/datum/round_event_control/crypto_market_crash
	name = "Market Crash (Crypto)"
	typepath = /datum/round_event/crypto_market_crash
	max_occurrences = 0

/datum/round_event_control/crypto_market_crash/canSpawnEvent(players)
	// don't run event if no one is mining yet
	if(SScryptocurrency.complexity < 4)
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
	priority_announce("Because of [reason()], the [SScryptocurrency.coin_name] market has crashed! Cash out before it's too late!", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/crypto_market_crash/start()
	// crypto wallets don't exist so just tank the mining payout and reported value
	var/dip = pick(list(1.5, 2, 2.5, 3))
	SScryptocurrency.payout = SScryptocurrency.payout / dip

// boost the market and tempt people to give a damn
/datum/round_event_control/crypto_market_boom
	name = "Market Boom (Crypto)"
	typepath = /datum/round_event/crypto_market_crash/boom
	// likely to happen and early availability so it gets growing
	weight = 30
	earliest_start = 15 MINUTES
	max_occurrences = 0

// subtype crash event to share reasons and timer
/datum/round_event/crypto_market_crash/boom

/datum/round_event/crypto_market_crash/boom/announce(fake)
	priority_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is booming! Dump your life savings into [SScryptocurrency.coin_name]!", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/crypto_market_crash/boom/start()
	// crypto wallets don't exist so just boost the mining payout and reported value
	var/stonks = pick(list(1.5, 2, 2.5, 3, 5))
	SScryptocurrency.payout = SScryptocurrency.payout * stonks

// make payouts harder if players are really taking advantage of crypto
/datum/round_event_control/crypto_algorithm_change
	name = "Algorithm Change (Crypto)"
	typepath = /datum/round_event/crypto_algorithm_change
	// likely to happen if spawn condition met
	weight = 20
	earliest_start = 45 MINUTES
	max_occurrences = 0

/datum/round_event_control/crypto_algorithm_change/canSpawnEvent(players)
	if(!SScryptocurrency)
		return FALSE
	// crypto hasn't boomed enough for the invisible hand of the market to step in
	if(SScryptocurrency.payout < 2 * initial(SScryptocurrency.payout) || SScryptocurrency.complexity < 4)
		return FALSE
	return ..()

/datum/round_event/crypto_algorithm_change

/datum/round_event/crypto_algorithm_change/announce(fake)
	var/nerd_name = "[pick(list("Satoshi", "Kiryu", "Doraemon", "Greg"))] [pick(list("Naka", "Baka", "Shiba", "Tako"))][pick(list("moto", "mura", "nashi", "bana"))]"
	priority_announce("Because of aggressive mining, the proof-of-work algorithm for [SScryptocurrency.coin_name] is being changed to be more difficult.", "[SScryptocurrency.coin_name] Creator [nerd_name]")

/datum/round_event/crypto_algorithm_change/start()
	SScryptocurrency.complexity = SScryptocurrency.complexity * 3

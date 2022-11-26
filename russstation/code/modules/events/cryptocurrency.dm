// events for cryptocurrency module. events are triggered by SScryptocurrency instead of SSevents
// so that these aren't selected over "interesting" events. also allows admeme activation.
/datum/round_event_control/cryptocurrency
	// root type isn't real event plz don't execute this one it does nothing
	name = "--Cryptocurrency Events--"
	// ...but if you do, this should at least not crash
	typepath = /datum/round_event/cryptocurrency
	// bad holiday ID means event will never be selected by the normal event system
	holidayID = "NEVER"

// crypto events change weight depending on how the round is going
/datum/round_event_control/cryptocurrency/proc/adjust_weight()
	return

// event base for shared crypto stuff
/datum/round_event/cryptocurrency
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

/datum/round_event/cryptocurrency/proc/reason()
	var/reason = pick(reasons)
	if(reason == "a crewmember")
		// blame a real person
		var/mob/living/player = pick(GLOB.player_list)
		if(player)
			reason = player.name
	return reason

// tank the market and force people to HODL
/datum/round_event_control/cryptocurrency/market_crash
	name = "Market Crash (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_crash

/datum/round_event_control/cryptocurrency/market_crash/adjust_weight()
	// don't crash below initial payout which already sucks
	if(SScryptocurrency.payout <= initial(SScryptocurrency.payout) * 2)
		weight = 0
	// likely to crash if value has significantly boomed
	else if(SScryptocurrency.payout >= initial(SScryptocurrency.payout) * 10)
		weight = 30
	else
		weight = 10

/datum/round_event/cryptocurrency/market_crash/announce(fake)
	priority_announce("Because of [reason()], the [SScryptocurrency.coin_name] market has crashed! Cash out before it's too late!", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/cryptocurrency/market_crash/start()
	// crypto wallets don't exist so just tank the mining payout and market trend
	var/dip = pick(list(1.5, 2, 2.5, 3))
	SScryptocurrency.payout /= dip
	SScryptocurrency.market_trend_up = FALSE

// boost the market and tempt people to give a damn
/datum/round_event_control/cryptocurrency/market_boom
	name = "Market Boom (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_boom

/datum/round_event_control/cryptocurrency/market_boom/adjust_weight()
	// much more likely to boom at low payouts
	if(SScryptocurrency.payout <= initial(SScryptocurrency.payout) * 3)
		weight = 40
	else
		// twice as likely as crash
		weight = 20

/datum/round_event/cryptocurrency/market_boom/announce(fake)
	priority_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is booming! Dump your life savings into [SScryptocurrency.coin_name]!", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/cryptocurrency/market_boom/start()
	// crypto wallets don't exist so just boost the mining payout and market trend
	var/stonks = pick(list(1.5, 2, 2.5, 3, 5))
	SScryptocurrency.payout *= stonks
	SScryptocurrency.market_trend_up = TRUE

// make payouts harder if players are really taking advantage of crypto
/datum/round_event_control/cryptocurrency/algorithm_change
	name = "Algorithm Change (Crypto)"
	typepath = /datum/round_event/cryptocurrency/algorithm_change

/datum/round_event/cryptocurrency/algorithm_change/announce(fake)
	priority_announce("Because of aggressive mining, the proof-of-work algorithm for [SScryptocurrency.coin_name] is being changed to be more difficult.", "[SScryptocurrency.coin_name] Creator [SScryptocurrency.nerd_name]")

/datum/round_event/cryptocurrency/algorithm_change/start()
	// increase complexity by a lot to slow down payouts
	SScryptocurrency.complexity *= 3

// increase cost of cards because realism fuck you
/datum/round_event_control/cryptocurrency/card_stock
	name = "Silicon Shortage (Crypto)"
	typepath = /datum/round_event/cryptocurrency/card_stock
	max_occurrences = 1

/datum/round_event_control/cryptocurrency/card_stock/adjust_weight()
	// likely to occur ONCE after we've made good progress toward market cap
	if(occurrences < max_occurrences && SScryptocurrency.total_payout >= SScryptocurrency.market_cap / 3)
		weight = 30
	else
		weight = 0

/datum/round_event/cryptocurrency/card_stock/announce(fake)
	priority_announce("Because of [reason()], everyone is buying graphics cards to mine [SScryptocurrency.coin_name]! Cards will now be sourced from scalpers at exorbitant prices.", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/cryptocurrency/card_stock/start()
	. = ..()
	// double the cost of the card supply packs
	for(var/pack_type in typesof(/datum/supply_pack/engineering/crypto_mining_card))
		var/datum/supply_pack/pack = SSshuttle.supply_packs[pack_type]
		pack.cost *= 2

// release a new graphics card
/datum/round_event_control/cryptocurrency/card_release
	name = "Graphics Card Release (Crypto)"
	typepath = /datum/round_event/cryptocurrency/card_release
	max_occurrences = 4

/datum/round_event/cryptocurrency/card_release/announce(fake)
	// limit should be enforced by SScrypto, this prevents admemes messing around releasing non-existing cards
	if(occurrences <= SScryptocurrency.card_packs.len)
		// cringe gamer advertisement - yes that's right, Donk makes the cards
		priority_announce("Gamers rise up! New graphics cards now available. Slot one in your donk socket today!", "Donk Co. Product Release")
	else
		message_admins("Stop pressing buttons, there are no more cards to release!")

/datum/round_event/cryptocurrency/card_release/start()
	// occurrences is already incremented so subtract 1 to index our list
	if(occurrences <= SScryptocurrency.card_packs.len)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[SScryptocurrency.card_packs[occurrences - 1]]
		pack.special_enabled = TRUE
		SScryptocurrency.card_packs_unlocked += 1

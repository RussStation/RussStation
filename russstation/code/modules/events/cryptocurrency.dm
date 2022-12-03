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
	// don't crash below initial exchange rate which already sucks
	if(SScryptocurrency.exchange_rate <= initial(SScryptocurrency.exchange_rate) * 2)
		weight = 0
	else
		weight = 10

/datum/round_event/cryptocurrency/market_crash/announce(fake)
	minor_announce("Because of [reason()], the [SScryptocurrency.coin_name] market has crashed! Cash out before it's too late!", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/cryptocurrency/market_crash/start()
	// tank the mining exchange rate and market trend
	var/dip = pick(list(1.5, 2, 2.5, 3))
	SScryptocurrency.exchange_rate /= dip
	SScryptocurrency.market_trend_up = FALSE

// boost the market and tempt people to give a damn
/datum/round_event_control/cryptocurrency/market_boom
	name = "Market Boom (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_boom
	max_occurrences = 5

/datum/round_event_control/cryptocurrency/market_boom/adjust_weight()
	// can only boom so many times - hope you cashed out!
	if(occurrences >= max_occurrences)
		weight = 0
	else
		weight = 10

/datum/round_event/cryptocurrency/market_boom/announce(fake)
	minor_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is booming! Dump your life savings into [SScryptocurrency.coin_name]!", "[SScryptocurrency.coin_name] Speculative Investment Report")

/datum/round_event/cryptocurrency/market_boom/start()
	// boost the mining exchange rate and market trend
	var/stonks = pick(list(1.5, 2, 2.5, 3, 5))
	SScryptocurrency.exchange_rate *= stonks
	SScryptocurrency.market_trend_up = TRUE

// increase cost of cards because realism fuck you
/datum/round_event_control/cryptocurrency/card_stock
	name = "Silicon Shortage (Crypto)"
	typepath = /datum/round_event/cryptocurrency/card_stock
	max_occurrences = 1

/datum/round_event_control/cryptocurrency/card_stock/adjust_weight()
	// likely to occur ONCE after we've made good progress toward market cap
	if(occurrences < max_occurrences && SScryptocurrency.total_payout >= SScryptocurrency.market_cap / 3)
		weight = 20
	else
		weight = 0

/datum/round_event/cryptocurrency/card_stock/announce(fake)
	minor_announce("Because of [reason()], everyone is buying graphics cards to mine [SScryptocurrency.coin_name]! Cards will now be sourced from scalpers at exorbitant prices.", "[SScryptocurrency.coin_name] Speculative Investment Report")

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

/datum/round_event_control/cryptocurrency/card_release/adjust_weight()
	// extremely likely whenever we pass release thresholds
	// for some reason indexing on this array seems to be 1 based
	if(SScryptocurrency.released_cards_count < SScryptocurrency.card_packs_thresholds.len && SScryptocurrency.total_payout >= SScryptocurrency.card_packs_thresholds[SScryptocurrency.card_packs_thresholds[SScryptocurrency.released_cards_count + 1]])
		weight = 500
	else
		weight = 0

/datum/round_event/cryptocurrency/card_release/announce(fake)
	// cringe gamer advertisement - yes that's right, Donk makes the cards
	minor_announce("Gamers rise up! New graphics cards now available. Slot one in your donk socket today!", "Donk Co. Product Release")

/datum/round_event/cryptocurrency/card_release/start()
	if(SScryptocurrency.released_cards_count < SScryptocurrency.card_packs_thresholds.len)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[SScryptocurrency.card_packs_thresholds[SScryptocurrency.released_cards_count + 1]]
		pack.special_enabled = TRUE
		SScryptocurrency.released_cards_count += 1

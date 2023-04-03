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
		var/mob/living/player = pick(GLOB.alive_player_list)
		if(player)
			reason = player.name
	return reason

// priority_announce and minor_announce are too "loud" for this meme shit
// copied minor_announce and edited the font, now i'm happy :)
/datum/round_event/cryptocurrency/proc/crypto_announce(message, title = "[SScryptocurrency.coin_name] Speculative Investment Report", alert, html_encode = TRUE, list/players, sound_override)
	if(!message)
		return

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	if(!players)
		players = GLOB.player_list

	for(var/mob/target in players)
		if(isnewplayer(target))
			continue
		if(!target.can_hear())
			continue

		to_chat(target, "<span style='font-size: 140%; font-weight: bold;' class='sans'><font color='red'>[title]</font color><BR>[message]</span><BR>")
		if(target.client?.prefs.read_preference(/datum/preference/toggle/sound_announcements))
			var/sound_to_play = sound_override || (alert ? 'sound/misc/notice1.ogg' : 'sound/misc/notice2.ogg')
			SEND_SOUND(target, sound(sound_to_play))

// tank the market and force people to HODL
/datum/round_event_control/cryptocurrency/market_crash
	name = "Market Crash (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_crash

/datum/round_event_control/cryptocurrency/market_crash/adjust_weight()
	// don't crash below initial exchange rate which already sucks
	if(SScryptocurrency.exchange_rate <= initial(SScryptocurrency.exchange_rate))
		weight = 0
	else
		weight = 10

/datum/round_event/cryptocurrency/market_crash
	// oops too late to cash out
	announce_when = 40
	// we don't need to hear this every time; also keeps players on their toes
	announce_chance = 75

/datum/round_event/cryptocurrency/market_crash/announce(fake)
	crypto_announce("Because of [reason()], the [SScryptocurrency.coin_name] market has crashed! Cash out before it's too late!")

/datum/round_event/cryptocurrency/market_crash/start()
	var/dip = 1
	// crash harder when the exchange rate is high
	if(SScryptocurrency.exchange_rate > 1)
		dip = LERP(3, 10, rand())
	else
		dip = LERP(2, 3, rand())
	// tank the mining exchange rate and market trend
	SScryptocurrency.next_exchange_rate /= dip
	SScryptocurrency.market_trend_up = FALSE

// boost the market and tempt people to give a damn
/datum/round_event_control/cryptocurrency/market_boom
	name = "Market Boom (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_boom
	max_occurrences = 8

/datum/round_event_control/cryptocurrency/market_boom/adjust_weight()
	// can only boom so many times - hope you cashed out!
	if(occurrences >= max_occurrences)
		weight = 0
	else
		weight = 10

/datum/round_event/cryptocurrency/market_boom
	announce_when = 40
	// what's that, you didn't see the exchange skyrocket? were you tabbed out?
	announce_chance = 85

/datum/round_event/cryptocurrency/market_boom/announce(fake)
	crypto_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is booming! We're going to the moon!")

/datum/round_event/cryptocurrency/market_boom/start()
	var/stonks = 1
	// boom harder when the exchange rate is smol
	if(SScryptocurrency.exchange_rate < 0.5)
		stonks = LERP(3, 10, rand())
	else
		stonks = LERP(2, 3, rand())
	// boost the mining exchange rate and market trend
	SScryptocurrency.next_exchange_rate *= stonks
	SScryptocurrency.market_trend_up = TRUE

// release a new graphics card
/datum/round_event_control/cryptocurrency/card_release
	name = "Graphics Card Release (Crypto)"
	typepath = /datum/round_event/cryptocurrency/card_release
	max_occurrences = 3

/datum/round_event_control/cryptocurrency/card_release/adjust_weight()
	// extremely likely whenever we pass release thresholds
	// for some reason indexing on this array seems to be 1 based
	if(SScryptocurrency.released_cards_count < SScryptocurrency.card_packs_thresholds.len && SScryptocurrency.total_payout >= SScryptocurrency.card_packs_thresholds[SScryptocurrency.card_packs_thresholds[SScryptocurrency.released_cards_count + 1]])
		weight = 500
	else
		weight = 0

/datum/round_event/cryptocurrency/card_release/announce(fake)
	// cringe gamer advertisement - yes that's right, Donk makes the cards
	crypto_announce("Gamers rise up! New graphics cards now available. Slot one in your donk socket today!", "Donk Co. Product Release")

/datum/round_event/cryptocurrency/card_release/start()
	if(SScryptocurrency.released_cards_count < SScryptocurrency.card_packs_thresholds.len)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[SScryptocurrency.card_packs_thresholds[SScryptocurrency.released_cards_count + 1]]
		pack.special_enabled = TRUE
		SScryptocurrency.released_cards_count += 1

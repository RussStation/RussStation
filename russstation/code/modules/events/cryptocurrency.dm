// events for cryptocurrency module. events are triggered by SScryptocurrency instead of SSevents
// so that these aren't selected over "interesting" events. also allows admeme activation.
/datum/round_event_control/cryptocurrency
	// root type isn't real event plz don't execute this one it does nothing
	name = "--Cryptocurrency Events--"
	// ...but if you do, this should at least not crash
	typepath = /datum/round_event/cryptocurrency
	// bad holiday ID means event will never be selected by the normal event system
	holidayID = "NEVER"
	// these fire a lot, don't spam ghost logs
	alert_observers = FALSE

// crypto events change weight depending on how the round is going
/datum/round_event_control/cryptocurrency/proc/adjust_weight()
	// manual event system? manual occurrence checking
	if(occurrences >= max_occurrences)
		weight = 0

GLOBAL_LIST_INIT(crypto_reasons, world.file2list("russstation/strings/crypto_reasons.txt"))

// event base for shared crypto stuff
/datum/round_event/cryptocurrency
	// we don't need to hear these every time; also keeps players on their toes
	announce_chance = 70
	// change rates to use during event period
	var/growth_percent = 10
	var/decline_percent = 10

/datum/round_event/cryptocurrency/setup()
	// announce a bit after the trend has started and people are reacting
	announce_when = rand(60, 120)

/datum/round_event/cryptocurrency/start()
	// apply new rate change percents
	SScryptocurrency.potential_growth_percent = growth_percent
	SScryptocurrency.potential_decline_percent = decline_percent

/datum/round_event/cryptocurrency/proc/reason()
	var/reason = pick(GLOB.crypto_reasons)
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

// stabilize market for a while
/datum/round_event_control/cryptocurrency/stable
	name = "Stable Market (Crypto)"
	typepath = /datum/round_event/cryptocurrency/stable
	// this is boring, don't do it often
	weight = 4

/datum/round_event/cryptocurrency/stable
	// no announcement
	announce_chance = 0
	// don't change much
	growth_percent = 5
	decline_percent = 5

// tank the market and force people to HODL
/datum/round_event_control/cryptocurrency/market_crash
	name = "Market Crash (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_crash

/datum/round_event_control/cryptocurrency/market_crash/adjust_weight()
	// crash more when the rate is decent
	if(SScryptocurrency.exchange_rate > 0.5)
		weight = 10
	else if(SScryptocurrency.exchange_rate > 0.1)
		weight = 5
	else
		weight = 0
	. = ..()

/datum/round_event/cryptocurrency/market_crash
	decline_percent = 30

/datum/round_event/cryptocurrency/market_crash/announce(fake)
	crypto_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is crashing!")

// crash hard if the rate gets crazy
/datum/round_event_control/cryptocurrency/market_implode
	name = "Market Implosion (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_implode

/datum/round_event_control/cryptocurrency/market_implode/adjust_weight()
	// only if rate is really good
	if(SScryptocurrency.exchange_rate > 10)
		weight = 10
	else
		weight = 0
	. = ..()

/datum/round_event/cryptocurrency/market_implode
	announce_chance = 100
	growth_percent = 0
	decline_percent = 80

/datum/round_event/cryptocurrency/market_implode/announce(fake)
	crypto_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is crashing! Cash out before it's too late!")

// boost the market and tempt people to give a damn
/datum/round_event_control/cryptocurrency/market_boom
	name = "Market Boom (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_boom

/datum/round_event_control/cryptocurrency/market_boom/adjust_weight()
	// boom more when the rate is trash
	if(SScryptocurrency.exchange_rate < 1)
		weight = 10
	else if(SScryptocurrency.exchange_rate < 10)
		weight = 5
	else
		weight = 0
	. = ..()

/datum/round_event/cryptocurrency/market_boom
	growth_percent = 30

/datum/round_event/cryptocurrency/market_boom/announce(fake)
	crypto_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is booming!")

// one really big boom can happen each round
/datum/round_event_control/cryptocurrency/market_explode
	name = "Market Explosion (Crypto)"
	typepath = /datum/round_event/cryptocurrency/market_explode
	weight = 2
	max_occurrences = 1

/datum/round_event/cryptocurrency/market_explode
	announce_chance = 100
	// to the moon!
	growth_percent = 100

/datum/round_event/cryptocurrency/market_explode/announce(fake)
	crypto_announce("Because of [reason()], the [SScryptocurrency.coin_name] market is booming! We're going to the moon!")

// release a new graphics card
/datum/round_event_control/cryptocurrency/card_release
	name = "Graphics Card Release (Crypto)"
	typepath = /datum/round_event/cryptocurrency/card_release
	max_occurrences = 3

/datum/round_event_control/cryptocurrency/card_release/adjust_weight()
	// extremely likely whenever we pass release thresholds
	if(SScryptocurrency.released_cards_count < SScryptocurrency.card_packs_thresholds.len && SScryptocurrency.total_payout >= SScryptocurrency.card_packs_thresholds[SScryptocurrency.card_packs_thresholds[SScryptocurrency.released_cards_count + 1]])
		weight = 500
	else
		weight = 0
	. = ..()

/datum/round_event/cryptocurrency/card_release
	// don't suppress important event announcement
	announce_chance = 100

/datum/round_event/cryptocurrency/card_release/setup()
	// override delayed announce range
	announce_when = 0

/datum/round_event/cryptocurrency/card_release/announce(fake)
	// cringe gamer advertisement - yes that's right, Donk makes the cards
	crypto_announce("Gamers rise up! New graphics cards now available. Slot one in your donk socket today!", "Donk Co. Product Release")

/datum/round_event/cryptocurrency/card_release/start()
	. = ..()
	// unlock next cargo pack (yeah it's complicated)
	if(SScryptocurrency.released_cards_count < SScryptocurrency.card_packs_thresholds.len)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[SScryptocurrency.card_packs_thresholds[SScryptocurrency.released_cards_count + 1]]
		pack.special_enabled = TRUE
		SScryptocurrency.released_cards_count += 1

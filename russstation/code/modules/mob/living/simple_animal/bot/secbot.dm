/mob/living/simple_animal/bot/secbot/bearsky
	name = "Officer Bearsky"
	desc = "Has the right to bear arms."
	icon =  'russstation/icons/mob/aibots.dmi'
	icon_state = "bearsky"
	health = 60 // he's a beefy boy
	maxHealth = 60
	bot_mode_flags = BOT_MODE_ON | BOT_MODE_AUTOPATROL | BOT_MODE_REMOTE_ENABLED
	security_mode_flags = SECBOT_DECLARE_ARRESTS | SECBOT_CHECK_IDS | SECBOT_CHECK_RECORDS | SECBOT_CHECK_WEAPONS

/mob/living/simple_animal/bot/secbot/bearsky/stun_attack(mob/living/carbon/C)
	var/judgement_criteria = judgement_criteria()
	playsound(src, 'sound/weapons/cqchit2.ogg', 50, TRUE, -1)
	addtimer(CALLBACK(src, /atom/.proc/update_icon), 2)
	var/threat = 5
	C.Paralyze(100)
	threat = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

	log_combat(src,C,"tackled")
	if(security_mode_flags & SECBOT_DECLARE_ARRESTS)
		var/area/location = get_area(src)
		speak("[security_mode_flags & SECBOT_HANDCUFF_TARGET ? "Hunting" : "Mauling"] level [threat] scumbag <b>[C]</b> in [location].", radio_channel)
	C.visible_message(
		span_danger("[src] has tackled [C]!"),
		span_userdanger("[src] has tackled you!"),
	)

/mob/living/simple_animal/bot/secbot/bearsky/look_for_perp()
	anchored = FALSE
	var/judgement_criteria = judgement_criteria()
	for(var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		threatlevel = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			playsound(loc, 'russstation/sound/effects/bearhuuu.ogg', 75, FALSE)
			visible_message("<b>[src]</b> growls at [C.name]!")
			mode = BOT_HUNT
			INVOKE_ASYNC(src, .proc/handle_automated_action)
			break
		else
			continue

/mob/living/simple_animal/bot/secbot/bearsky/explode()
	walk_to(src,0)
	visible_message(
		span_boldannounce("[src] blows apart!"),
	)

	var/atom/location = drop_location()
	new /obj/item/clothing/head/costume/bearpelt(location)
	new /obj/effect/decal/cleanable/oil(location)

	do_sparks(8, TRUE, src) // lots of sparks
	qdel(src)

/mob/living/simple_animal/bot/secbot/emag_act(mob/user)
	..()
	if(bot_cover_flags & BOT_COVER_EMAGGED)
		if(user)
			to_chat(user, span_danger("You enrage [src]"))
			oldtarget_name = user.name
		audible_message(span_danger("[src] growls angrily!"))
		security_mode_flags &= ~SECBOT_DECLARE_ARRESTS
		update_icon()

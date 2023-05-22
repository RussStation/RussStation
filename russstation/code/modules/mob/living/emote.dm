/datum/emote/living/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	cooldown = 0.1 SECONDS // the absolute limit of farting

/datum/emote/living/fart/get_sound(mob/living/user)
	return pick(user.fart.sounds)

/datum/emote/living/fart/check_cooldown(mob/user, intentional)
	// store before calling super
	var/previous_usage = user.emotes_used && user.emotes_used[src]
	. = ..() // standard cooldown check
	if(!.)
		return FALSE
	var/mob/living/U = user
	if(!U.fart)
		to_chat(user, span_notice("You try to fart but don't know how!"))
		return FALSE
	var/last_used = world.time - previous_usage
	return U.fart.try_fart(U, last_used)

/datum/emote/living/fart/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if (!.)
		return FALSE
	var/mob/living/U = user
	U.fart.make_gas(U)

/datum/emote/living/spit
	key = "spit"
	key_third_person = "spits"

/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	. = ..()

	if(!.)
		return

	var/datum/action/cooldown/spell/pointed/projectile/spit/spit_action = new(src)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/hasHead = FALSE

		for(var/obj/item/bodypart/parts in H.bodyparts)
			if(istype(parts, /obj/item/bodypart/head))
				hasHead = TRUE

		if(HAS_TRAIT(H, TRAIT_MIMING))//special spit action for mimes
			spit_action = new /datum/action/cooldown/spell/pointed/projectile/spit/mime()

		if(!hasHead)//Aint got no HEAD what da hell
			to_chat(user,"<B>You try to spit but you have no head!</B>")
			return FALSE

	spit_action.Grant(user)

/datum/action/cooldown/spell/pointed/projectile/spit
	name = "Spit"
	desc = "Spit on someone or something."
	button_icon = 'russstation/icons/mob/actions/actions_spit.dmi'
	button_icon_state = "spit"
	spell_requirements = NONE

	active_msg = "You fill your mouth with phlegm, mucus and spit."
	deactive_msg = "You decide to swallow your spit."

	cast_range = 10
	projectile_type = /obj/projectile/spit
	projectile_amount = 1

	var/emote_gurgle_msg = "gurgles their mouth"
	var/emote_spit_msg = "spits"

	var/boolPlaySound = TRUE

/datum/action/cooldown/spell/pointed/projectile/spit/Grant(mob/grant_to)
	. = ..()

	src.set_click_ability(grant_to)

	if(!owner)
		return

/datum/action/cooldown/spell/pointed/projectile/spit/on_activation(mob/on_who)
	SHOULD_CALL_PARENT(FALSE)

	to_chat(on_who, span_notice("[active_msg]"))
	build_all_button_icons()

	var/mob/living/spitter = on_who
	spitter.audible_message("[emote_gurgle_msg].", deaf_message = "<span class='emote'>You see <b>[spitter]</b> gurgle their mouth.</span>", audible_message_flags = EMOTE_MESSAGE)

	if(boolPlaySound)
		playsound(spitter, 'russstation/sound/voice/spit_windup.ogg', 50, TRUE)

	return TRUE

/datum/action/cooldown/spell/pointed/projectile/spit/unset_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	var/mob/living/L = on_who
	src.Remove(L)

/datum/action/cooldown/spell/pointed/projectile/spit/InterceptClickOn(mob/living/caller, params, atom/click_target)
	var/mob/living/spitter = caller

	if(ishuman(spitter))
		var/mob/living/carbon/human/humanoid = caller
		if(humanoid.is_mouth_covered())
			humanoid.audible_message("[emote_spit_msg] in their mask!", deaf_message = "<span class='emote'>You see <b>[spitter]</b> spit in their mask.</span>", audible_message_flags = EMOTE_MESSAGE)
			if(boolPlaySound)
				playsound(spitter, 'russstation/sound/voice/spit_release.ogg', 50, TRUE)
			src.Remove(caller)
			return

	. = ..()
	spitter.audible_message("[emote_spit_msg].", deaf_message = "<span class='emote'>You see <b>[spitter]</b> spit.</span>", audible_message_flags = EMOTE_MESSAGE)
	if(boolPlaySound)
		playsound(spitter, 'russstation/sound/voice/spit_release.ogg', 50, TRUE)
	src.Remove(caller)


/datum/action/cooldown/spell/pointed/projectile/spit/mime
	name = "Silent Spit"
	button_icon = 'russstation/icons/mob/actions/actions_spit.dmi'
	button_icon_state = "mime_spit"
	active_msg = "You silently fill your mouth with phlegm, mucus and spit."
	background_icon_state = "bg_mime"

	emote_gurgle_msg = "silently gurgles their mouth"
	emote_spit_msg = "silently spits"
	boolPlaySound = FALSE

	projectile_type = /obj/projectile/spit/mime

/obj/projectile/spit
	name = "spit"
	icon = 'russstation/icons/obj/spit.dmi'
	icon_state = "spit"
	hitsound = 'russstation/sound/misc/waterbloop1.ogg'
	hitsound_wall = 'russstation/sound/misc/waterbloop2.ogg'
	speed = 3
	range = 5
	damage = 0
	armour_penetration = 0
	sharpness = 0
	damage_type = NONE
	wound_bonus = 0
	pass_flags = PASSTABLE | PASSFLAPS

/obj/projectile/spit/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(istype(target, /obj/item/food))
		var/obj/item/food/F = target
		F.reagents.add_reagent(/datum/reagent/consumable/spit,1) //Yummy

/obj/projectile/spit/mime
	hitsound = NONE
	hitsound_wall = NONE

/datum/reagent/consumable/spit
	name = "Spit"
	description = "Saliva, usually from a creatures mouth."
	color = "#b0eeaa"
	reagent_state = LIQUID
	taste_mult = 1
	taste_description = "metallic saltiness"
	nutriment_factor = 0.5 * REAGENTS_METABOLISM
	penetrates_skin = NONE

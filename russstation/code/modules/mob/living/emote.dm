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

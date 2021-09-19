/datum/emote/living/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	cooldown = 0.1 SECONDS // the absolute limit of farting

/datum/emote/living/fart/get_sound(mob/living/user)
	return pick(user.fart_type.sounds)

/datum/emote/living/fart/check_cooldown(mob/user, intentional)
	var/mob/living/U = user
	if (U.IsStun())
		to_chat(user, span_notice("You cannot fart while stunned!"))
		return FALSE
	if (!U.fart_type)
		to_chat(user, span_notice(">You try to fart but don't know how!"))
		return FALSE

	var/previous_usage = user.emotes_used && user.emotes_used[src] // the base version changes user.emotes_used, so store it for later
	var/time_since_last_usage = world.time - previous_usage;

	. = ..() // standard cooldown check

	if (!. || time_since_last_usage < U.fart_type.hard_cooldown) // if the cooldown check failed or they broke the hard cooldown
		U.fart_type.hard_fail(U)
		return FALSE
	else if (time_since_last_usage < U.fart_type.soft_cooldown && prob(U.fart_type.fail_chance)) // if you're under the safe limit and failed a chance
		U.fart_type.soft_fail(U)

/datum/emote/living/fart/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if (!.)
		return
	var/mob/living/U = user
	U.fart_type.make_gas(U)

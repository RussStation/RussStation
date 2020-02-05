/datum/emote/living/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	cooldown = 0.5 SECONDS
	var/safe_cooldown = 2 SECONDS
	var/fail_chance = 20
	var/fail_damage = 5

/datum/emote/living/fart/check_cooldown(mob/user, intentional)
	var/mob/living/U = user
	if (U.IsStun())
		return FALSE

	var/previous_usage = user.emotes_used && user.emotes_used[src] // the base version changes user.emotes_used, so store it for later

	. = ..() // standard cooldown check

	if (!.) // if the cooldown check failed
		hard_fail(U)
	else if (world.time - previous_usage < safe_cooldown && prob(fail_chance)) // if you're under the safe limit and failed a chance
		soft_fail(U)

/datum/emote/living/fart/run_emote(mob/user, params, type_override, intentional)
	. = ..()

	if (.)
		make_gas(user)

/datum/emote/living/fart/proc/make_gas(mob/living/user)
	return

/datum/emote/living/fart/proc/soft_fail(mob/living/user)
	return

/datum/emote/living/fart/proc/hard_fail(mob/living/user)
	return

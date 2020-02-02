/datum/emote/living/silicon/fart
	key = "fart"
	key_third_person = "emits a synthetic fart"
	message = "emits a synthetic fart."
	emote_type = EMOTE_AUDIBLE
	var/safe_cooldown = 2 SECONDS
	var/fail_chance = 20
	var/burn_damage = 5
	sound = 'russstation/sound/effects/mob_effects/poo_robot.ogg'

/datum/emote/living/silicon/fart/check_cooldown(mob/user, intentional)
	var/mob/living/silicon/U = user
	if (U.IsStun())
		return FALSE

	var/previous_usage = user.emotes_used && user.emotes_used[src] // the base version changes user.emotes_used, so store it for later

	. = ..() // standard cooldown check

	if (!.) // if the cooldown check failed
		U.adjustFireLoss(burn_damage)
		U.Stun(1 SECONDS)
		to_chat(U, "<span class='notice'>You are unable to produce a synthetic fart as your circuitry overheats.</span>")
	else if (world.time - previous_usage < safe_cooldown && prob(fail_chance)) // if you're under the safe limit and failed a chance
		U.adjustFireLoss(burn_damage)
		to_chat(U, "<span class='notice'>A clunk comes from within your shell.</span>")

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams."
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE

/datum/emote/living/scream/get_sound(mob/living/user)
	if(issilicon(user))
		return 'russstation/sound/effects/mob_effects/robot_scream.ogg'
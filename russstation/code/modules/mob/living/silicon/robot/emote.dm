/datum/emote/living/silicon/fart
	key_third_person = "emits a synthetic fart"
	message = "emits a synthetic fart."
	sound = 'russstation/sound/effects/mob_effects/poo_robot.ogg'

/datum/emote/living/silicon/fart/soft_fail(mob/living/user)
	U.adjustFireLoss(fail_damage)
	U.Stun(1 SECONDS)
	to_chat(U, "<span class='notice'>You are unable to produce a synthetic fart as your circuitry overheats.</span>")

/datum/emote/living/silicon/fart/hard_fail(mob/living/user)
	U.adjustFireLoss(fail_damage)
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

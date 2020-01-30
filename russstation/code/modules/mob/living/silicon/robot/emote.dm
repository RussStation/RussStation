/datum/emote/living/silicon/fart
	key = "fart"
	key_third_person = "emits a synthetic fart"
	message = "emits a synthetic fart."
	emote_type = EMOTE_AUDIBLE
	cooldown = 3 SECONDS
	sound = 'russstation/sound/effects/mob_effects/poo_robot.ogg'

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams."
	emote_type = EMOTE_AUDIBLE
	cooldown = 3 SECONDS

/datum/emote/living/scream/get_sound(mob/living/user)
	if(issilicon(user))
		return 'russstation/sound/effects/mob_effects/robot_scream.ogg'
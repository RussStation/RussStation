/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/fart/get_sound(mob/living/user)
	if(ishuman(user))
		return pick('russstation/sound/effects/mob_effects/poo1.ogg',
						'russstation/sound/effects/mob_effects/poo2.ogg',
						'russstation/sound/effects/mob_effects/poo3.ogg',
						'russstation/sound/effects/mob_effects/poo4.ogg')
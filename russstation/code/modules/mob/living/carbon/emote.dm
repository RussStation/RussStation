/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/fart/get_sound(mob/living/user)
	if(ishuman(user))
		if(user.mind.assigned_role == "Clown" && prob(25)) //clowns have a chance to fart confetti
			var/turf/T = get_turf(user)
			new /obj/effect/gibspawner/confetti(T, user)
		return pick('russstation/sound/effects/mob_effects/poo1.ogg',
						'russstation/sound/effects/mob_effects/poo2.ogg',
						'russstation/sound/effects/mob_effects/poo3.ogg',
						'russstation/sound/effects/mob_effects/poo4.ogg')

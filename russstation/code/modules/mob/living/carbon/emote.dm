/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	cooldown = 2 SECONDS

/datum/emote/living/carbon/fart/check_cooldown(mob/user, intentional)
	. = ..()
	if(.) // If the emote is not intentional or off cooldown don't do anything
		return
	if(!can_run_emote(user, intentional=intentional)) // If you can't use the emote there is no effect
		return
	var/mob/living/carbon/U = user
	if(U.IsStun())
		return
	U.adjustToxLoss(5)
	U.Stun(1 SECONDS)
	to_chat(U, "<span class='notice'>You feel a sharp pain in your stomach and fail to produce any flatulence.</span>")


/datum/emote/living/carbon/fart/get_sound(mob/living/user)
	if(ishuman(user))
		if(user.mind.assigned_role == "Clown" && prob(50)) //clowns have a 50% chance to fart confetti
			var/turf/T = get_turf(user)
			new /obj/effect/gibspawner/confetti(T, user)
		return pick('russstation/sound/effects/mob_effects/poo1.ogg',
						'russstation/sound/effects/mob_effects/poo2.ogg',
						'russstation/sound/effects/mob_effects/poo3.ogg',
						'russstation/sound/effects/mob_effects/poo4.ogg')

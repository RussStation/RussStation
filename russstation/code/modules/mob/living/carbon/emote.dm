/datum/emote/living/carbon/fart

/datum/emote/living/carbon/fart/get_sound(mob/living/user)
	return pick('russstation/sound/effects/mob_effects/poo1.ogg',
				'russstation/sound/effects/mob_effects/poo2.ogg',
				'russstation/sound/effects/mob_effects/poo3.ogg',
				'russstation/sound/effects/mob_effects/poo4.ogg')

/datum/emote/living/carbon/fart/make_gas(mob/living/user)
	if(user.mind.assigned_role == "Clown" && prob(25)) //clowns have a chance to fart confetti
		var/turf/T = get_turf(user)
		new /obj/effect/gibspawner/confetti(T, user)

/datum/emote/living/carbon/fart/soft_fail(mob/living/user)
	user.adjustToxLoss(fail_damage)
	user.Stun(1 SECONDS)
	to_chat(user, "<span class='notice'>You feel a sharp pain in your stomach and fail to produce any flatulence.</span>")

/datum/emote/living/carbon/fart/hard_fail(mob/living/user)
	user.adjustToxLoss(fail_damage)
	to_chat(user, "<span class='notice'>You let out some gas, but it felt like something came with it.</span>")


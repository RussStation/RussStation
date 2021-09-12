/datum/fart/living/carbon/human
	gas_id = "miasma"
	sounds = list('russstation/sound/effects/mob_effects/poo1.ogg',
				'russstation/sound/effects/mob_effects/poo2.ogg',
				'russstation/sound/effects/mob_effects/poo3.ogg',
				'russstation/sound/effects/mob_effects/poo4.ogg')

/datum/fart/living/carbon/human/make_gas(mob/living/user)
	. = ..() // returns nothing so collect nothing
	if(HAS_TRAIT(user, TRAIT_NAIVE) && prob(25)) // naive people (like clowns) have a chance to fart confetti
		var/turf/T = get_turf(user)
		new /obj/effect/gibspawner/confetti(T, user)
		user.atmos_spawn_air("n2o=[gas_volume / 5];TEMP=[user.bodytemperature]") // release some laughing gas, but heavily reduce the amount so the clown isn't a walking sleep bomb

/datum/fart/living/carbon/human/soft_fail(mob/living/user)
	user.adjustToxLoss(fail_damage)
	to_chat(user, span_notice("You let out some gas, but it felt like something came with it."))

/datum/fart/living/carbon/human/hard_fail(mob/living/user)
	user.adjustToxLoss(fail_damage)
	user.Stun(1 SECONDS)
	to_chat(user, span_notice("You feel a sharp pain in your stomach and fail to produce any flatulence."))

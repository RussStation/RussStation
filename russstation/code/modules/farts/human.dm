/datum/fart/human
	gas_id = "miasma"
	sounds = list('russstation/sound/effects/mob_effects/poo1.ogg',
				'russstation/sound/effects/mob_effects/poo2.ogg',
				'russstation/sound/effects/mob_effects/poo3.ogg',
				'russstation/sound/effects/mob_effects/poo4.ogg')
	fail_damage_type = TOX
	soft_fail_message = "You let out some gas, but it felt like something came with it."
	hard_fail_message = "You feel a sharp pain in your stomach and fail to produce any flatulence."

/datum/fart/human/make_gas(mob/living/user)
	..()
	if(HAS_TRAIT(user, TRAIT_NAIVE) && prob(25)) // naive people (like clowns) have a chance to fart confetti
		var/turf/T = get_turf(user)
		new /obj/effect/gibspawner/confetti(T, user)
		user.atmos_spawn_air("n2o=[gas_volume / 5];TEMP=[user.bodytemperature]") // release some laughing gas, but heavily reduce the amount so the clown isn't a walking sleep bomb

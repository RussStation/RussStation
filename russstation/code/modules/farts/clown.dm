#define CONFETTI_CHANCE 25

/datum/fart/human/clown
	gas_id = "n2o"
	gas_volume = 0.5

/datum/fart/human/clown/make_gas(mob/living/user)
	..()
	if(prob(CONFETTI_CHANCE))
		var/turf/T = get_turf(user)
		new /obj/effect/gibspawner/confetti(T, user)

#undef CONFETTI_CHANCE

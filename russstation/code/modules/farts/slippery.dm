/datum/fart/human/slippery
	soft_cooldown = 4 SECONDS
	hard_cooldown = 1 SECONDS
	fail_chance = 33

/datum/fart/human/slippery/make_gas(mob/living/user)
	..()
	var/turf/open/OT = get_turf(user)
	if(istype(OT))
		OT.MakeSlippery(TURF_WET_LUBE, 5 SECONDS)

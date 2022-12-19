// IceCube station z, lower level
/datum/map_generator/cave_generator/icemoon
	// only low-chance ores because there's no danger
	weighted_closed_turf_types = list(/turf/closed/mineral/random/snow/low_chance = 1)
	// no mobs, keep station safe-ish
	weighted_mob_spawn_list = null

// IceCube surface z, easy mobs
/datum/map_generator/cave_generator/icemoon/surface
	// more normal ore than low ore
	weighted_closed_turf_types = list(/turf/closed/mineral/random/snow/low_chance = 1, /turf/closed/mineral/random/snow = 4)
	// restore list because surface def is nulled
	weighted_mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/wolf = 50, /obj/structure/spawner/ice_moon = 3, \
						  /mob/living/simple_animal/hostile/asteroid/polarbear = 30, /obj/structure/spawner/ice_moon/polarbear = 3, \
						  /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10, \
						  /mob/living/simple_animal/hostile/asteroid/lobstrosity = 15)

// Ice Moon mining z, hard mobs
/datum/map_generator/cave_generator/icemoon/deep
	// mostly normal ore but moderate chance of the good stuff for the difficulty
	weighted_closed_turf_types = list(/turf/closed/mineral/random/snow = 4, /turf/closed/mineral/random/snow/high_chance = 1)

// IceCube station z, lower level
/datum/map_generator/cave_generator/icemoon
	// no mobs, keep station safe-ish
	mob_spawn_list = null

// IceCube surface z, easy mobs
/datum/map_generator/cave_generator/icemoon/surface
	// restore list because surface def is nulled
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/wolf = 50, /obj/structure/spawner/ice_moon = 3, \
						  /mob/living/simple_animal/hostile/asteroid/polarbear = 30, /obj/structure/spawner/ice_moon/polarbear = 3, \
						  /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10, \
						  /mob/living/simple_animal/hostile/asteroid/lobstrosity = 15)

// Ice Moon mining z, hard mobs
/datum/map_generator/cave_generator/icemoon/deep
	megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/colossus = 1)

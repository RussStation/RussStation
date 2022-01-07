// balance mob lists for ice cube having tougher mobs on surface
/datum/map_generator/cave_generator/icemoon
	// used in lower z near station, use the easy mob list
	mob_spawn_chance = 2
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/wolf = 50, /obj/structure/spawner/ice_moon = 3, \
						  /mob/living/simple_animal/hostile/asteroid/polarbear = 30, /obj/structure/spawner/ice_moon/polarbear = 3, \
						  /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10, \
						  /mob/living/simple_animal/hostile/asteroid/lobstrosity = 15)

/datum/map_generator/cave_generator/icemoon/deep
	// restore mob spawn chance
	mob_spawn_chance = 6
	// repeat the mob list because we have to override defined subtype separately
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/wolf = 50, /obj/structure/spawner/ice_moon = 3, \
						  /mob/living/simple_animal/hostile/asteroid/polarbear = 30, /obj/structure/spawner/ice_moon/polarbear = 3, \
						  /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10, \
						  /mob/living/simple_animal/hostile/asteroid/lobstrosity = 15)
	// denser closed turf ratio
	initial_closed_chance = 33

/datum/map_generator/cave_generator/icemoon/surface
	// open surface has almost normal mob rate, no megafauna
	mob_spawn_chance = 4
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/ice_demon = 50, /obj/structure/spawner/ice_moon/demonic_portal = 3, \
						  /mob/living/simple_animal/hostile/asteroid/ice_whelp = 30, /obj/structure/spawner/ice_moon/demonic_portal/ice_whelp = 3, \
						  /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50, /obj/structure/spawner/ice_moon/demonic_portal/snowlegion = 3)

// new generators for caves on surface (like mountainside)
/datum/map_generator/cave_generator/icemoon/surface/caves
	// restore mob spawn chance and list
	mob_spawn_chance = 6
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/ice_demon = 50, /obj/structure/spawner/ice_moon/demonic_portal = 3, \
						  /mob/living/simple_animal/hostile/asteroid/ice_whelp = 30, /obj/structure/spawner/ice_moon/demonic_portal/ice_whelp = 3, \
						  /mob/living/simple_animal/hostile/asteroid/hivelord/legion/snow = 50, /obj/structure/spawner/ice_moon/demonic_portal/snowlegion = 3, \
						  SPAWN_MEGAFAUNA = 2)
	megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/colossus = 1)
	// restore cave-like turf ratio
	initial_closed_chance = 45
	smoothing_iterations = 20
	birth_limit = 4
	death_limit = 3

/datum/map_generator/cave_generator/icemoon/surface/caves/deep
	// denser closed turf ratio
	initial_closed_chance = 33

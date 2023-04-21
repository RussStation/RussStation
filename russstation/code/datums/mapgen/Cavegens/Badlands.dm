// you thought you could abandon the station and party on lavaland?
/datum/map_generator/cave_generator/badlands
	weighted_open_turf_types = list(/turf/open/misc/asteroid/basalt/wasteland = 1)
	// no, you don't get nice things
	weighted_closed_turf_types = list(/turf/closed/mineral/random/badlands = 40, \
		/turf/closed/mineral/strong = 1, \
		/turf/closed/mineral/strong/wasteland = 1)

	// this hodgepodge of mobs have a lot of conflicting factions so they kinda kill each other...
	mob_spawn_chance = 6
	weighted_mob_spawn_list = list(/mob/living/basic/carp = 20, \
		/mob/living/basic/carp/mega = 8, \
		/mob/living/simple_animal/hostile/space_dragon = 2, \
		/mob/living/basic/carp/magic/chaos = 1, \
		/mob/living/simple_animal/hostile/bear = 18, \
		/mob/living/simple_animal/hostile/skeleton = 15, \
		/obj/structure/spawner/lavaland/badlands/carp = 3, \
		/obj/structure/spawner/lavaland/badlands/bear = 3, \
		/obj/structure/spawner/lavaland/badlands/skeleton = 3, \
		/obj/structure/spawner/lavaland/badlands/chicken = 1, \
		SPAWN_MEGAFAUNA = 6)
	weighted_megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/colossus = 1, \
		/mob/living/simple_animal/hostile/megafauna/bubblegum = 1, \
		/mob/living/simple_animal/hostile/megafauna/sif = 1, \
		/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner = 1, \
		/mob/living/simple_animal/hostile/asteroid/elite/legionnaire = 1, \
		/mob/living/simple_animal/hostile/asteroid/elite/herald = 1, \
		/mob/living/simple_animal/hostile/asteroid/elite/pandora = 1)
	flora_spawn_chance = 0.5
	weighted_flora_spawn_list = list(/obj/structure/flora/ash/leaf_shroom = 1, \
		/obj/structure/flora/ash/cap_shroom = 1, \
		/obj/structure/flora/ash/stem_shroom = 1, \
		/obj/structure/flora/ash/cacti = 12, \
		/obj/structure/flora/ash/tall_shroom = 1, \
		/obj/structure/flora/ash/seraka = 1, \
		/obj/structure/flora/tree/dead = 6)
	weighted_feature_spawn_list = list(/obj/structure/statue/bone/rib = 12, \
		/obj/structure/statue/bone/skull = 5, \
		/obj/structure/statue/bone/skull/half = 5, \
		/obj/effect/decal/remains/human = 3, \
		/obj/structure/punji_sticks/spikes = 10, \
		/obj/structure/geyser/random = 1)
	initial_closed_chance = 42
	smoothing_iterations = 25
	birth_limit = 4
	death_limit = 3

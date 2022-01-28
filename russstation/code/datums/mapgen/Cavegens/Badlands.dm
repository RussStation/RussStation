// you thought you could abandon the station and party on lavaland?
/datum/map_generator/cave_generator/badlands
	open_turf_types = list(/turf/open/floor/plating/asteroid/basalt/wasteland = 40, \
		/turf/open/chasm/lavaland = 1)
	// no, you don't get nice things
	closed_turf_types = list(/turf/closed/mineral/random/low_chance = 20, \
		/turf/closed/mineral/random/high_chance = 1, \
		/turf/closed/mineral/strong = 1, \
		/turf/closed/mineral/strong/wasteland = 1)

	// this hodgepodge of mobs have a lot of conflicting factions so they kinda kill each other...
	mob_spawn_list = list(/mob/living/simple_animal/hostile/skeleton = 6, \
		/mob/living/simple_animal/hostile/carp = 6, \
		/mob/living/simple_animal/hostile/carp/megacarp = 3, \
		/mob/living/simple_animal/hostile/carp/ranged/chaos = 3, \
		/mob/living/simple_animal/hostile/space_dragon = 1, \
		/mob/living/simple_animal/hostile/asteroid/elite/legionnaire = 1, \
		/mob/living/simple_animal/hostile/asteroid/elite/herald = 1, \
		/mob/living/simple_animal/hostile/asteroid/elite/pandora = 1, \
		/mob/living/simple_animal/hostile/retaliate/clown/mutant = 1, \
		/mob/living/simple_animal/hostile/retaliate/clown/clownhulk = 1, \
		/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/honcmunculus = 1, \
		SPAWN_MEGAFAUNA = 3)
	// who needs ruins? just spawn the megas wherever
	megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/colossus = 1, \
		/mob/living/simple_animal/hostile/megafauna/wendigo = 1, \
		/mob/living/simple_animal/hostile/megafauna/sif = 1, \
		/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner = 1, \
		/mob/living/simple_animal/hostile/megafauna/demonic_frost_miner = 1, \
		/mob/living/simple_animal/hostile/megafauna/bubblegum = 1)
	flora_spawn_chance = 0.5
	flora_spawn_list = list(/obj/structure/flora/ash/leaf_shroom = 1, \
		/obj/structure/flora/ash/cap_shroom = 1, \
		/obj/structure/flora/ash/stem_shroom = 1, \
		/obj/structure/flora/ash/cacti = 12, \
		/obj/structure/flora/ash/tall_shroom = 1, \
		/obj/structure/flora/ash/seraka = 1, \
		/obj/structure/flora/tree/dead = 6)
	feature_spawn_list = list(/obj/structure/statue/bone = 60, \
		/obj/structure/statue/bone/rib = 50, \
		/obj/structure/statue/bone/skull = 15, \
		/obj/structure/statue/bone/skull/half = 15, \
		/obj/effect/decal/remains/human = 10, \
		/obj/structure/punji_sticks/spikes = 50, \
		/obj/structure/trap/damage = 15, \
		/obj/structure/trap/fire = 15, \
		/obj/structure/trap/stun = 15, \
		/obj/structure/closet/crate/necropolis/tendril = 1)
	initial_closed_chance = 40
	smoothing_iterations = 30
	birth_limit = 4
	death_limit = 3

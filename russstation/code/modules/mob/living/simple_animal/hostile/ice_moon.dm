// nerf ice moon minor fauna ability to destroy walls
// reduce move force of strong mobs to prevent dislocating windows
// STRONG force is just enough to push windows, so go one less to still push mobs

/mob/living/simple_animal/hostile/asteroid/ice_whelp
	environment_smash = ENVIRONMENT_SMASH_WALLS
	move_force = MOVE_FORCE_STRONG - 1

/mob/living/simple_animal/hostile/asteroid/ice_demon
	environment_smash = ENVIRONMENT_SMASH_WALLS
	move_force = MOVE_FORCE_STRONG - 1

/mob/living/simple_animal/hostile/asteroid/polarbear
	environment_smash = ENVIRONMENT_SMASH_WALLS
	move_force = MOVE_FORCE_STRONG - 1

/mob/living/simple_animal/hostile/asteroid/wolf
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

/mob/living/simple_animal/hostile/asteroid/lobstrosity
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

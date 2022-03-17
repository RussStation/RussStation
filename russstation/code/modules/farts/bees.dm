/datum/fart/human/bee
	soft_cooldown = 4 SECONDS
	hard_cooldown = 1 SECONDS
	fail_chance = 50
	fail_damage = 10
	var/bee_type = /mob/living/simple_animal/hostile/bee
	var/bee_amt = 1

/datum/fart/human/bee/make_gas(mob/living/user)
	..()
	spawn_atom_to_turf(bee_type, get_turf(user), bee_amt)

/datum/fart/human/bee/toxin
	soft_cooldown = 2 SECONDS
	hard_cooldown = 0.5 SECONDS
	bee_type = /mob/living/simple_animal/hostile/bee/toxin

/datum/fart/human/bee/badmin
	soft_cooldown = 1 SECONDS
	hard_cooldown = 0.2 SECONDS
	fail_chance = 20
	fail_damage = 50 // playing a dangerous game
	bee_type = /mob/living/simple_animal/hostile/bee/toxin
	bee_amt = 3

/mob/living/simple_animal/pet/rabbit
	name = "rabbit"
	desc = "A smol bun."
	icon = 'russstation/icons/mob/pets.dmi'
	icon_state = "rabbit"
	icon_living = "rabbit"
	icon_dead = "rabbit_dead"
	speak_emote = list("sniffles","twitches", "chirps")
	emote_hear = list("hops.")
	emote_see = list("hops around","bounces up and down")
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	gold_core_spawnable = FRIENDLY_SPAWN
	health = 15
	maxHealth = 15
	gender = FEMALE
	pass_flags = PASSTABLE | PASSMOB
	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/pet/rabbit/caerby
	name = "Caerby"
	real_name = "Caerby"
	health = 50
	maxHealth = 50
	desc = "He looks like he has bloodlust in his eyes."
	icon_state = "killer_rabbit"
	icon_living = "killer_rabbit"
	icon_dead = "killer_rabbit_dead"
	speak_emote = list("growls","screeches", "barks")
	emote_see = list("hops around", "hunts")
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/retaliation = TRUE

/mob/living/simple_animal/pet/rabbit/caerby/friendly
	retaliation = FALSE

/mob/living/simple_animal/pet/rabbit/caerby/Initialize()
	. = ..()

	if(retaliation)
		new /mob/living/simple_animal/hostile/retaliate/caerby(get_turf(src))
		qdel(src)

/mob/living/simple_animal/hostile/retaliate/caerby
	name = "Caerby"
	real_name = "Caerby"
	desc = "He looks like he has bloodlust in his eyes."
	icon = 'russstation/icons/mob/pets.dmi'
	icon_state = "killer_rabbit"
	icon_living = "killer_rabbit"
	icon_dead = "killer_rabbit_dead"
	speak_emote = list("growls","screeches", "barks")
	emote_see = list("hops around", "hunts")
	emote_hear = list("hops.")
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	gold_core_spawnable = NO_SPAWN
	health = 50
	maxHealth = 50
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	gender = MALE
	pass_flags = PASSTABLE | PASSMOB
	footstep_type = FOOTSTEP_MOB_CLAW
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	environment_smash = ENVIRONMENT_SMASH_NONE


/mob/living/simple_animal/pet/rabbit
    name = "rabbit"
    desc = "A smol bunbun"
    icon = 'russstation/icons/mob/animal.dmi'
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

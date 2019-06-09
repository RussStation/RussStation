/mob/living/simple_animal/hostile/retaliate/clown/russ
	icon = 'russstation/icons/mob/clown_mobs.dmi'


//Goblin
/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin
	name = "clown goblin"
	desc = "A tiny walking mask and clown shoes. You want to honk his nose!"
	icon_state = "clowngoblin"
	icon_living = "clowngoblin"
	icon_dead = null
	response_help = "honks the"
	speak = list("Honk!")
	speak_emote = list("sqeaks")
	emote_see = list("honks")
	maxHealth = 100
	health = 100

	speed = -1
	turns_per_move = 1

	del_on_death = TRUE
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/item/clothing/shoes/clown_shoes)

//Lesser Goblin
/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin/lessergoblin
	name = "clown goblin"
	desc = "A tiny walking mask and clown shoes, kinda looks malnourished. You want to honk his nose!"
	icon_state = "clowngoblin"
	icon_living = "clowngoblin"
	icon_dead = null
	response_help = "honks the"
	speak = list("Honk!")
	speak_emote = list("sqeaks")
	emote_see = list("honks")
	maxHealth = 15
	health = 15
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5

	speed = -1
	turns_per_move = 1

	del_on_death = TRUE
	loot = list(/obj/item/reagent_containers/food/snacks/grown/russ/citrus/white)

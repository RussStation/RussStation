/mob/living/simple_animal/mouse/russ
	icon = 'russstation/icons/mob/animal.dmi'

/mob/living/simple_animal/mouse/russ/clouse
	name = "Clouse"
	desc = "Who in their right mind would train a mouse to be a clown?"
	body_color = "clown"
	response_help = "pats"
	response_disarm = "abuses"
	response_harm = "abuses"
	turns_per_move = 4 // slightly faster
	speak = list("Honk")
	emote_see = list("honks it's tiny nose", "starts making cable ties", "puts something in it's backpack", "pulls out a tiny horn from it's backpack")
	health = 15 // triple mouse health
	maxHealth = 15
	del_on_death = FALSE
	//A great method for clown to start with 4+ slipping items.
	//loot = list(/obj/item/soap, /obj/item/grown/bananapeel)

/mob/living/simple_animal/mouse/russ/clouse/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak/bikehorn, 50)

/mob/living/simple_animal/mouse/russ/clouse/jimmithy
	name = "Jimmithy"
	real_name = "Jimmithy"
	gold_core_spawnable = NO_SPAWN

/obj/item/reagent_containers/food/snacks/deadmouse
	icon = 'russstation/icons/mob/animal.dmi'
	grind_results = list(/datum/reagent/consumable/laughter = 20, /datum/reagent/liquidgibs = 5)
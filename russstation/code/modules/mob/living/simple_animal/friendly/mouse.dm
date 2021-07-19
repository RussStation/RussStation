/mob/living/simple_animal/mouse/russ
	icon = 'russstation/icons/mob/animal.dmi'

/mob/living/simple_animal/mouse/russ/clouse
	name = "Clouse"
	body_color = "clown"
	icon_state = "mouse_clown"
	icon_living = "mouse_clown"
	icon_dead = "mouse_clown_dead"
	desc = "Who in their right mind would train a mouse to be a clown?"
	body_color = "clown"
	response_help_continuous = "pats"
	response_help_simple = "pat"
	response_disarm_continuous = "abuses"
	response_disarm_simple = "abuse"
	response_harm_continuous = "abuses"
	response_harm_simple = "abuse"
	turns_per_move = 4 // slightly faster
	speak = list("Honk")
	emote_see = list("honks it's tiny nose", "starts making cable ties", "puts something in it's backpack", "pulls out a tiny horn from it's backpack")
	health = 15 // triple mouse health
	maxHealth = 15
	del_on_death = FALSE

/mob/living/simple_animal/mouse/russ/clouse/Initialize()
	. = ..()
	RemoveElement(/datum/element/animal_variety)
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg' = 1), 50)

//This is needed for dropping a corpse with proper states and also dropping lootis if there's any
/mob/living/simple_animal/mouse/russ/clouse/death(gibbed,toast)
	if(!gibbed)
		var/obj/item/reagent_containers/food/snacks/deadmouse/russ/deadclouse/M = new(loc)
		if(toast) //had to copy it since we're bypassing the default mouse death proc
			M.add_atom_colour("#3A3A3A", FIXED_COLOUR_PRIORITY)
			M.desc = "It's toast."
	qdel(src)
	..(1)

/mob/living/simple_animal/mouse/russ/clouse/jimmithy
	name = "Jimmithy"
	real_name = "Jimmithy"
	icon_state = "mouse_clown"
	icon_living = "mouse_clown"
	icon_dead = "mouse_clown_dead"
	gold_core_spawnable = NO_SPAWN

// Drops

/obj/item/reagent_containers/food/snacks/deadmouse/russ/deadclouse
	icon = 'russstation/icons/mob/animal.dmi'
	icon_state = "mouse_clown_dead"
	name = "dead clouse"
	grind_results = list(/datum/reagent/consumable/laughter = 20, /datum/reagent/liquidgibs = 5)

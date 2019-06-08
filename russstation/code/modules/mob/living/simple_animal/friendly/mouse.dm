/mob/living/simple_animal/mouse/russ
	icon = 'russstation/icons/mob/animal.dmi'

/mob/living/simple_animal/mouse/russ/clouse
	name = "Clouse"
	desc = "Who in their right mind would train a mouse to be a clown?"
	icon_state = "clown_mouse_brown"
	icon_living = "clown_mouse_brown"
	icon_dead = "clown_mouse_brown_dead"
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
	loot = list(/obj/item/soap, /obj/item/grown/bananapeel)

/mob/living/simple_animal/mouse/russ/clouse/jimmithy
	name = "Jimmithy"
	real_name = "Jimmithy"
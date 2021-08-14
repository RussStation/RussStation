/mob/living/simple_animal/pet/gondola/russ
    icon = 'russstation/icons/mob/gondolas.dmi'

/mob/living/simple_animal/pet/gondola/russ/camdola
    name = "Camdola"
    real_name = "Camdola"
    desc = "The last remnant of an experiment to make a safer breed of gondola. Watches over the station in honor of the CMO who created him."
    turns_per_move = 15 // Extra slow
    icon_state = "camdola"
    icon_living = "camdola"
    loot = list(/obj/effect/decal/cleanable/blood/gibs, /obj/item/stack/sheet/animalhide/gondola = 1, /obj/item/food/meat/slab/gondola/russ/camdola = 1)

// Gondola's Initialize() calls this, which we don't want here, so we return it.
/mob/living/simple_animal/pet/gondola/russ/camdola/CreateGondola()
	return

// Uncomment this to replace Runtime with Camdola on all maps (Including TG ones)
/*
/mob/living/simple_animal/pet/cat/runtime/Initialize()
	. = ..()
	new /mob/living/simple_animal/pet/gondola/russ/camdola(src.loc)
	return INITIALIZE_HINT_QDEL
*/

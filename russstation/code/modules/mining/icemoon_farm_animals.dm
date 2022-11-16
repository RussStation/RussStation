/mob/living/basic/cow/icemoon
	name = "\improper icemoon cow"
	desc = "A very rare species of cow, breed by mountain Dwarf's to withstand harsh winters."
	color = "#0087bd"
	mob_biotypes = MOB_BEAST
	butcher_results = list(
		/obj/item/food/meat/slab = 6,
		/obj/item/stack/sheet/animalhide/generic = 8,
		/obj/item/organ/internal/heart = 1,
		/obj/item/organ/internal/brain = 1,
		/obj/item/organ/internal/lungs = 1,
		/obj/item/organ/internal/liver = 1,
		/obj/item/organ/internal/eyes = 1,
		/obj/item/stack/sheet/bone = 15,
	)
	language_holder = /datum/language_holder/dwarf/lavaland

/mob/living/simple_animal/chicken/icemoon
	name = "\improper icemoon chicken"
	desc = "They know when its morning even when buried under 30 meters of snow. This chicken will eat anything that is edible."
	color = "#003f72"
	mob_biotypes = MOB_BEAST
	butcher_results = list(
		/obj/item/food/meat/slab/chicken = 2,
		/obj/item/stack/sheet/animalhide/generic = 2,
		/obj/item/organ/internal/heart = 1,
		/obj/item/organ/internal/eyes = 1,
		/obj/item/stack/sheet/bone = 2,
		/obj/item/food/egg/iceegg = 1
	)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	language_holder = /datum/language_holder/dwarf/lavaland

/mob/living/simple_animal/chicken/icemoon/Initialize(mapload)
	. = ..()
	chicken_count++
	add_cell_sample()
	AddElement(/datum/element/animal_variety, "chicken", pick("brown","black","white"), TRUE)
	AddComponent(/datum/component/egg_layer,\
		/obj/item/food/egg/iceegg,\
		list(/obj/item/food),\
		feed_messages = list("She clucks happily."),\
		lay_messages = EGG_LAYING_MESSAGES,\
		eggs_left = 0,\
		eggs_added_from_eating = rand(1, 4),\
		max_eggs_held = 8,\
		egg_laid_callback = CALLBACK(src, .proc/egg_laid)\
	)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/chick/icemoon
	name = "\improper icemoon chick"
	desc = "Looks like a walking puddle of water, but loud."
	color = "#216399"
	butcher_results = list(
		/obj/item/food/meat/slab/chicken = 1,
		/obj/item/stack/sheet/bone = 1,
	)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	language_holder = /datum/language_holder/dwarf/lavaland

/mob/living/simple_animal/chick/icemoon/Life(delta_time = SSMOBS_DT, times_fired)
	if(!stat && !ckey)
		amount_grown += rand(0.5 * delta_time, 1 * delta_time)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/chicken/icemoon(src.loc)
			qdel(src)

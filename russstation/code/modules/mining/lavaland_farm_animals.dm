/mob/living/basic/cow/lavaland
	name = "\improper lavaland cow"
	desc = "Milk em or tip em. We don't judge here."
	color = "#CC9900"
	mob_biotypes = MOB_BEAST
	habitable_atmos = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
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

/mob/living/simple_animal/chicken/lavaland
	name = "\improper lavaland chicken"
	desc = "Hopefully the eggs are good this season. Looks like you could feed it anything edible."
	color = "#444444"
	mob_biotypes = MOB_BEAST
	butcher_results = list(
		/obj/item/food/meat/slab/chicken = 2,
		/obj/item/stack/sheet/animalhide/generic = 2,
		/obj/item/organ/internal/heart = 1,
		/obj/item/organ/internal/eyes = 1,
		/obj/item/stack/sheet/bone = 2,
		/obj/item/food/egg/lavaegg = 1
	)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

/mob/living/simple_animal/chicken/lavaland/Initialize(mapload)
	. = ..()
	GLOB.chicken_count++
	AddElement(/datum/element/animal_variety, "chicken", pick("brown","black","white"), TRUE)
	AddComponent(/datum/component/egg_layer,\
		/obj/item/food/egg/lavaegg,\
		list(/obj/item/food),\
		feed_messages = list("She clucks happily."),\
		lay_messages = EGG_LAYING_MESSAGES,\
		eggs_left = 0,\
		eggs_added_from_eating = rand(1, 4),\
		max_eggs_held = 8,\
		egg_laid_callback = CALLBACK(src, .proc/egg_laid)\
	)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/chick/lavaland
	name = "\improper lavaland chick"
	desc = "Looks like a walking puddle of water, but loud."
	color = "#992121"
	butcher_results = list(
		/obj/item/food/meat/slab/chicken = 1,
		/obj/item/stack/sheet/bone = 1,
	)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

/mob/living/simple_animal/chick/lavaland/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	if(!stat && !ckey)
		amount_grown += rand(0.5 * seconds_per_tick, 1 * seconds_per_tick)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/chicken/lavaland(src.loc)
			qdel(src)

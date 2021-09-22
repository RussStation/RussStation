/mob/living/simple_animal/cow/lavaland
	name = "\improper lavaland cow"
	desc = "Milk em or tip em. We don't judge here."
	mob_biotypes = MOB_BEAST
	butcher_results = list(
		/obj/item/food/meat/slab = 6,
		/obj/item/stack/sheet/animalhide/generic = 8,
		/obj/item/organ/heart = 1,
		/obj/item/organ/brain = 1,
		/obj/item/organ/lungs = 1,
		/obj/item/organ/liver = 1,
		/obj/item/organ/eyes = 1,
		/obj/item/stack/sheet/bone = 15,
	)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)

/mob/living/simple_animal/chicken/lavaland
	name = "\improper lavaland chicken"
	desc = "Hopefully the eggs are good this season."
	color = "#444444"
	mob_biotypes = MOB_BEAST
	butcher_results = list(
		/obj/item/food/meat/slab/chicken = 2,
		/obj/item/organ/heart = 1,
		/obj/item/organ/eyes = 1,
		/obj/item/stack/sheet/bone = 2,
		/obj/item/food/egg = 1
	)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)

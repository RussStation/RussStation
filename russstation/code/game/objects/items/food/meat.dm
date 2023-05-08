//Skaven ===============
/obj/item/food/meat/slab/human/mutant/skaven
	icon_state = "goliathmeat"
	desc = "A slab of putrid diseased rat meat."
	tastes = list("rotten meat" = 4, "slime" = 1)
	foodtypes = MEAT | RAW | GROSS
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/steak/plain/human/skaven
	name = "skaven steak"
	icon_state = "rottenmeat"
	tastes = list("meat" = 2, "quail" = 1, "slime" = 1)
	foodtypes = MEAT

//Skaven burgers anyone?
/obj/item/food/meat/slab/human/mutant/skaven/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/skaven, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

//Kobold ===============
/obj/item/food/meat/slab/human/mutant/kobold
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "koboldmeat"
	desc = "Meat from a skulking kobold."
	tastes = list("gamey meat" = 4, "scales" = 1, "cave dirt" = 1)
	foodtypes = MEAT | RAW
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/steak/plain/human/kobold
	name = "kobold steak"
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "koboldsteak"
	tastes = list("veal" = 1, "scales" = 1, "meat" = 1, "dust flakes" = 1)
	foodtypes = MEAT

/obj/item/food/meat/slab/human/mutant/kobold/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/kobold, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)


//Kitsune ===============
/obj/item/food/meat/slab/human/mutant/kitsune
	icon_state = "meat"
	desc = "A slab of fox meat, probably cursed"
	tastes = list("meat" = 4, "fur" = 1)
	foodtypes = MEAT | RAW | GROSS


/obj/item/food/meat/steak/plain/human/kitsune
	name = "kitsune steak"
	icon_state = "meatsteak"
	tastes = list("meat" = 2, "egg?" = 1, "kami" = 1)
	foodtypes = MEAT | GROSS

//kitsune borgor
/obj/item/food/meat/slab/human/mutant/kitsune/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/kitsune, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

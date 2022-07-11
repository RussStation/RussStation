/obj/item/food/meat/slab/human/mutant/skaven
	icon_state = "goliathmeat"
	desc = "A slab of putrid diseased rat meat."
	tastes = list("meat" = 4, "slime" = 1)
	foodtypes = MEAT | RAW | GROSS


/obj/item/food/meat/steak/plain/human/skaven
	name = "skaven steak"
	icon_state = "rottenmeat"
	tastes = list("meat" = 2, "quail" = 1, "slime" = 1)
	foodtypes = MEAT

//Skaven burgers anyone?
/obj/item/food/meat/slab/human/mutant/skaven/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/skaven, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/human/mutant/kitsune
	icon_state = "meat"
	desc = "A slab of fox meat, probably cursed"
	tastes = list("meat" = 4, "fur" = 1)
	foodtypes = MEAT | RAW | GROSS


/obj/item/food/meat/steak/plain/human/kitsune
	name = "kitsune steak"
	icon_state = "meatsteak"
	tastes = list("meat" = 2, "egg?" = 1, "kami" = 1)
	foodtypes = MEAT

//kitsune borgor
/obj/item/food/meat/slab/human/mutant/kitsune/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/kitsune, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

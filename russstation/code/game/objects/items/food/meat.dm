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

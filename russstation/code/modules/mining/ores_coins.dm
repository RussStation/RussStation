/obj/item/stack/ore/on_smelt()
	if(reagent_id)
		return reagent_id

/obj/item/stack/ore/adamantine
	name = "adamantine ore"
	icon_state = "ore"
	item_state = "ore"
	singular_name = "adamantine ore chunk"
	points = 40
	custom_materials = list(MAT_TITANIUM=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/adamantine
	reagent_id = /datum/reagent/adamantine

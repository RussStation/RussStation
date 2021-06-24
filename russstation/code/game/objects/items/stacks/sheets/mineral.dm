/*
 * Clay
 */

GLOBAL_LIST_INIT(clay_recipes, list(
	new /datum/stack_recipe("bar mold", /obj/item/reagent_containers/molten_container/smelt_mold/bar, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("pickaxe mold", /obj/item/reagent_containers/molten_container/smelt_mold/pickaxe, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("sword mold", /obj/item/reagent_containers/molten_container/smelt_mold/sword, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("shovel mold", /obj/item/reagent_containers/molten_container/smelt_mold/shovel, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("knife mold", /obj/item/reagent_containers/molten_container/smelt_mold/knife, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("hammer mold", /obj/item/reagent_containers/molten_container/smelt_mold/war_hammer, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("armour mold", /obj/item/reagent_containers/molten_container/smelt_mold/armour, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("helmet mold", /obj/item/reagent_containers/molten_container/smelt_mold/helmet, req_amount=1, res_amount=1), \
	new /datum/stack_recipe("sand", /obj/item/stack/ore/glass, req_amount=1, one_per_turf = FALSE, on_floor = TRUE) \
	))

/obj/item/stack/sheet/mineral/clay
	name = "clay"
	desc = "Fine soil suitable for molding into desired shapes."
	icon = 'russstation/icons/obj/stack_objects.dmi'
	icon_state = "sheet-clay"
	inhand_icon_state = "Glass ore"
	singular_name = "clay lump"
	layer = LOW_ITEM_LAYER
	merge_type = /obj/item/stack/sheet/mineral/clay
	sheettype = "clay"

/obj/item/stack/sheet/mineral/clay/get_main_recipes()
	. = ..()
	. += GLOB.clay_recipes

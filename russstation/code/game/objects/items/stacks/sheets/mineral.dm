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

/*
 * Rock and Stone
 *
 * recipes typically more expensive than other materials
 */

GLOBAL_LIST_INIT(stone_recipes, list( \
	new /datum/stack_recipe("Stone bed", /obj/structure/bed/stone, 3, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Stone table frame", /obj/structure/table_frame/stone, 4, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Stone throne", /obj/structure/chair/stone, 2, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Stone door", /obj/structure/mineral_door/stone, 20, time = 30, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Stone coffer", /obj/structure/closet/crate/stone, 3, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Stone floor tiles", /obj/item/stack/tile/stone, 1, 4, 20), \
	new /datum/stack_recipe("Stone wall frame", /obj/structure/girder/stone, 4, time = 40, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Stone window", /obj/structure/stone_window, 5, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("Carving block", /obj/structure/carving_block, 5, time = 5, one_per_turf = TRUE, on_floor = TRUE, applies_mats = TRUE) \
	))

/obj/item/stack/sheet/mineral/stone
	name = "smoothed stones"
	desc = "Stone without the rough edges, ready to be worked into something."
	singular_name = "smoothed stone"
	icon = 'russstation/icons/obj/stack_objects.dmi'
	icon_state = "sheet-stone"
	inhand_icon_state = "sheet-sandstone" // close enough
	mats_per_unit = list(/datum/material/stone = MINERAL_MATERIAL_AMOUNT)
	sheettype = "stone"
	merge_type = /obj/item/stack/sheet/mineral/stone
	walltype = /turf/closed/wall/mineral/stone
	material_type = /datum/material/stone
	tableVariant = /obj/structure/table/stone

/obj/item/stack/sheet/mineral/stone/get_main_recipes()
	. = ..()
	. += GLOB.stone_recipes

/obj/item/stack/ore
	// reagent ids for smelted ore
	var/reagent_id = null

/obj/item/stack/ore/uranium
	reagent_id = /datum/reagent/uranium

/obj/item/stack/ore/iron
	reagent_id = /datum/reagent/iron

/obj/item/stack/ore/plasma
	reagent_id = /datum/reagent/dorf_plasma

/obj/item/stack/ore/silver
	reagent_id = /datum/reagent/silver

/obj/item/stack/ore/gold
	reagent_id = /datum/reagent/gold

/obj/item/stack/ore/diamond
	reagent_id = /datum/reagent/diamond

/obj/item/stack/ore/bananium
	reagent_id = /datum/reagent/dorf_bananium

/obj/item/stack/ore/titanium
	reagent_id = /datum/reagent/dorf_titanium

/obj/item/stack/ore/adamantine
	name = "adamantine ore"
	icon_state = "ore"
	inhand_icon_state = "ore"
	singular_name = "adamantine ore chunk"
	points = 40
	mine_experience = 10
	custom_materials = list(/datum/material/adamantine = MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/adamantine
	reagent_id = /datum/reagent/adamantine

/obj/item/stack/ore/stone
	name = "rough stones"
	desc = "Raw stone leftover from smelting ores. Can be smoothed with <b>Dwarven tools</b> for construction use."
	icon = 'russstation/icons/obj/stack_objects.dmi'
	icon_state = "stone"
	inhand_icon_state = "ore"
	singular_name = "rough stone"
	mats_per_unit = list(/datum/material/stone = MINERAL_MATERIAL_AMOUNT)
	// defining refined type allows ORM to suck it up and welders/fire to refine it, we don't want
	//refined_type = /obj/item/stack/sheet/mineral/stone
	mine_experience = 0 // not really gatherable from mining
	scan_state = "" // not on scanners
	merge_type = /obj/item/stack/ore/stone

// handle refining here
/obj/item/stack/ore/stone/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/dwarf_tool) || istype(I, /obj/item/melee/smith_hammer))
		if(I.use_tool(src, user, 1 SECONDS, volume=50))
			new /obj/item/stack/sheet/mineral/stone(drop_location())
			use(1)

	return TRUE

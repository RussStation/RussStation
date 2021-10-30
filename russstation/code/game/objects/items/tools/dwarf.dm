// The dorf's omnitool, because I'm too lazy to make them equivalents of every tool.
// Doesn't replace smithing hammer, just for things where wrench/screwdriver/etc would work.
// When you have a golden hammer, every problem looks like a nail.
/obj/item/dwarf_tool
	name = "gelded knapper-gimlet"
	desc = "A curious tool capable of disassembling almost any structure of Dwarven design."
	icon = 'russstation/icons/obj/tools.dmi'
	icon_state = "dwarf"
	lefthand_file = 'russstation/icons/mob/inhands/item_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/item_righthand.dmi'
	inhand_icon_state = "dwarf_tool"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/gold=150)
	// yeah sounds
	usesound = 'sound/items/ratchet.ogg'
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/weldingtool_pickup.ogg'

	// what even is this thing
	attack_verb_continuous = list("scrapes", "hammers", "cranks", "pries", "gouges")
	attack_verb_simple = list("scrape", "hammer", "crank", "pry", "gouge")
	tool_behaviour = TOOL_DWARF
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

/obj/item/dwarf_tool/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)

/datum/crafting_recipe/dwarf_tool
	name = "Dwarven omnitool"
	result = /obj/item/dwarf_tool
	tool_paths = list(/obj/item/melee/smith_hammer)
	reqs = list(/obj/item/stack/sheet/mineral/gold = 2)
	time = 5 SECONDS
	category = CAT_DWARF
	always_available = FALSE

// let dorfs carve! works same as normal chisel
/obj/item/chisel/stone
	name = "stone chisel"
	desc = "Breaking and making art since the Age of Myth. This one uses Dwarven technology to allow the creation of lifelike moving statues."
	custom_materials = list(/datum/material/stone = 75)
	color = "#555544"

/datum/crafting_recipe/stone_chisel
	name = "stone chisel"
	result = /obj/item/chisel/stone
	tool_paths = list(/obj/item/melee/smith_hammer)
	reqs = list(/obj/item/stack/sheet/mineral/stone = 1)
	time = 1 SECONDS
	category = CAT_DWARF
	always_available = FALSE

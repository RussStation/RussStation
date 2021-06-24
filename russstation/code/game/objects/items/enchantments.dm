/obj/item/dwarf_rune
	name = "Dwarven enchantment rune"
	desc = "A beer-stained sheet of parchment with Dwarven runes inscribed."
	icon = 'russstation/icons/obj/enchantments.dmi'
	icon_state = "dwarf_rune"
	inhand_icon_state = "dwarf_rune"
	// buncha stuff copied from paper, but we do not want to subtype it
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_range = 1
	throw_speed = 1
	resistance_flags = FLAMMABLE
	max_integrity = 100 // slightly more durable paper
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	grind_results = list(/datum/reagent/cellulose = 5, /datum/reagent/consumable/ethanol/beer = 2)
	var/expended = FALSE // only usable once? or should it be more?

/obj/item/dwarf_rune/proc/expend()
	if(!expended)
		expended = TRUE
		desc += " It appears faded from use."
		icon_state = "dwarf_rune_expended"
		update_icon()

/datum/crafting_recipe/dwarf_rune
	name = "Dwarven Enchantment Rune"
	result = /obj/item/dwarf_rune
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1, /obj/item/stack/sheet/mineral/plasma = 1)
	tool_paths = list(/obj/item/melee/smith_hammer)
	time = 100
	category = CAT_DWARF
	always_available = FALSE

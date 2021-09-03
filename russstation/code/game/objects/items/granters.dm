/obj/item/book/granter/crafting_recipe/dwarf
	name = "Getting Started with Craftdwarfship"
	desc = "A peculiar guide for dwarves to learn things they should already know."
	crafting_recipe_types = list(
		/datum/crafting_recipe/broadsword,
		/datum/crafting_recipe/pickaxe,
		/datum/crafting_recipe/shovel,
		/datum/crafting_recipe/knife,
		/datum/crafting_recipe/war_hammer,
		/datum/crafting_recipe/smithed_armour,
		/datum/crafting_recipe/smithed_helmet,
		/datum/crafting_recipe/dwarf_rune,
	)
	icon = 'russstation/icons/obj/library.dmi'
	icon_state = "dwarf"
	oneuse = FALSE
	pages_to_mastery = 1 // don't waste time
	// quotes from here: http://dwarffortresswiki.org/index.php/Main_Page/Quote/list uttered by Toadyone, Dwarf Fortress itself, or anonymous players
	remarks = list(
		"Urist withdraws from society and begins a mysterious construction!",
		"Magma is not a water source.",
		"If cow cheese is made from cow's milk, what is dwarven cheese made of?",
		"The carp has drowned..?",
		"This is a menacing iron spike. This object menaces with spikes of iron.",
		"Fat dwarves eating causes lag.",
		"Who knew the first Dwarf to go to space was a useless fisherdwarf?",
		"In a time before time, somebody attacked somebody.",
	)

/obj/item/book/granter/crafting_recipe/dwarf/attack_self(mob/user)
	if(!is_species(user, /datum/species/dwarf))
		to_chat(user, "The book was written by a particularly inebriated dwarf and doesn't make any sense to you.")
		return FALSE
	return ..()

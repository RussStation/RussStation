//And thus a dwarven age was born

/datum/crafting_recipe/broadsword
	name = "Forged Broadsword"
	result = /obj/item/melee/smithed_sword
	reqs = list(/obj/item/stack/sheet/leather = 1,
				/obj/item/mold_result/blade = 1)
	parts = list(/obj/item/mold_result/blade = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

/datum/crafting_recipe/pickaxe
	name = "Forged Pickaxe"
	result = /obj/item/pickaxe/smithed_pickaxe
	reqs = list(/obj/item/grown/log = 1,
				/obj/item/mold_result/pickaxe_head = 1)
	parts = list(/obj/item/mold_result/pickaxe_head = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

/datum/crafting_recipe/shovel
	name = "Forged Shovel"
	result = /obj/item/shovel/smithed_shovel
	reqs = list(/obj/item/grown/log = 1,
				/obj/item/mold_result/shovel_head = 1)
	parts = list(/obj/item/mold_result/shovel_head = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

/datum/crafting_recipe/knife
	name = "Forged Knife"
	result = /obj/item/kitchen/knife/smithed_knife
	reqs = list(/obj/item/grown/log = 1,
				/obj/item/mold_result/knife_head = 1)
	parts = list(/obj/item/mold_result/knife_head = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

/datum/crafting_recipe/war_hammer
	name = "Forged War Hammer"
	result = /obj/item/smithed_war_hammer
	reqs = list(/obj/item/grown/log = 1,
				/obj/item/mold_result/war_hammer_head = 1)
	parts = list(/obj/item/mold_result/war_hammer_head = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

/datum/crafting_recipe/smithed_armour
	name = "Forged Armour"
	result = /obj/item/clothing/suit/armor/vest/dwarf
	reqs = list(/obj/item/stack/sheet/leather = 4,
				/obj/item/mold_result/armour_plating = 1)
	parts = list(/obj/item/mold_result/armour_plating = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

/datum/crafting_recipe/smithed_helmet
	name = "Forged Helmet"
	result = /obj/item/clothing/head/helmet/dwarf
	reqs = list(/obj/item/stack/sheet/leather = 2,
				/obj/item/mold_result/helmet_plating = 1)
	parts = list(/obj/item/mold_result/helmet_plating = 1)
	time = 40
	category = CAT_DWARF
	always_available = FALSE

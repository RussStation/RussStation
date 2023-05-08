// Mountain dwarf
/obj/item/clothing/suit/hooded/wintercoat/miner/dwarf
	name = "mining winter coat"
	desc = "A winter coat made of animal furs. The zipper tab looks like a tiny hammer and anvil."
	icon = 'russstation/icons/obj/clothing/suits/wintercoat.dmi'
	icon_state = "coatdwarf"
	worn_icon = 'russstation/icons/mob/clothing/suits/wintercoat.dmi'
	inhand_icon_state = "coatdwarf"
	armor_type = /datum/armor/winterdwarf
	hoodtype = /obj/item/clothing/head/hooded/winterhood/miner/dwarf

/obj/item/clothing/head/hooded/winterhood/miner/dwarf
	desc = "A dusty winter coat hood."
	icon = 'russstation/icons/obj/clothing/head/winterhood.dmi'
	icon_state = "hood_dwarf"
	worn_icon = 'russstation/icons/mob/clothing/head/winterhood.dmi'
	armor_type = /datum/armor/winterdwarf

/datum/armor/winterdwarf
	melee = 25
	laser = 10
	bullet = 0
	energy = 10
	bomb = 0
	bio = 0
	fire = 0
	acid = 0

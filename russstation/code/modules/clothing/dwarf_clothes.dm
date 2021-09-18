/datum/outfit/dorf
	name = "Dwarf Standard"
	uniform = /obj/item/clothing/under/dwarf
	shoes = /obj/item/clothing/shoes/dwarf
	back = /obj/item/storage/backpack/satchel/leather
	gloves = /obj/item/clothing/gloves/dwarf

//Dwarf-unique clothes
/obj/item/clothing/under/dwarf
	name = "dwarven tunic"
	desc = "Very hip dwarven uniform."
	icon = 'russstation/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'russstation/icons/mob/uniform.dmi'
	icon_state = "dwarf"
	lefthand_file = 'russstation/icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/clothing_righthand.dmi'
	inhand_icon_state = "dwarf_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	species_exception = list(/datum/species/dwarf)

/obj/item/clothing/gloves/dwarf
	name = "dwarven gloves"
	desc = "Great for pulping people in bar fights."
	worn_icon = 'russstation/icons/mob/hands.dmi'
	icon = 'russstation/icons/obj/clothing/gloves.dmi'
	icon_state = "dwarf"
	inhand_icon_state = "bgloves"
	body_parts_covered = ARMS
	species_exception = list(/datum/species/dwarf)

/obj/item/clothing/shoes/dwarf
	name = "dwarven shoes"
	desc = "Standard issue dwarven mining shoes."
	worn_icon = 'russstation/icons/mob/feet.dmi'
	icon = 'russstation/icons/obj/clothing/shoes.dmi'
	icon_state = "dwarf"
	inhand_icon_state = "jackboots"
	body_parts_covered = FEET
	species_exception = list(/datum/species/dwarf)

//Forged Armour
/obj/item/clothing/suit/armor/vest/dwarf
	name = "dwarven armour"
	desc = "Great for stopping sponges."
	worn_icon = 'russstation/icons/mob/suit.dmi'
	icon = 'russstation/icons/obj/clothing/suits.dmi'
	icon_state = "dwarf"
	inhand_icon_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80)
	strip_delay = 80
	equip_delay_self = 60
	species_exception = list(/datum/species/dwarf)

/obj/item/clothing/suit/armor/vest/dwarf/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/armour_plating/S = locate() in contents
	if(S)
		var/image/Q = image(icon, icon_state)
		Q.color = S.color
		add_overlay(Q)
		smelted_material = new S.smelted_material.type()
		name = "[S.material_type] armour"
		desc += " Armour forged from [S.material_type]."

		armor.melee += S.attack_amt
		armor.bullet += S.attack_amt
		armor.laser += S.attack_amt
		armor.energy += S.attack_amt
		armor.bomb += S.attack_amt
		armor.bio += S.attack_amt
		armor.rad += S.attack_amt
		armor.fire += S.attack_amt
		armor.acid += S.attack_amt

//Forged Helmet
/obj/item/clothing/head/helmet/dwarf
	name = "dwarven helm"
	desc = "Protects the head from tantrums."
	worn_icon= 'russstation/icons/mob/head.dmi'
	icon = 'russstation/icons/obj/clothing/hats.dmi'
	icon_state = "dwarf"
	lefthand_file = 'russstation/icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/clothing_righthand.dmi'
	inhand_icon_state = "dwarf_helm"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR
	species_exception = list(/datum/species/dwarf)

/obj/item/clothing/head/helmet/dwarf/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/helmet_plating/S = locate() in contents
	if(S)
		var/image/Q = image(icon, icon_state)
		Q.color = S.color
		add_overlay(Q)
		smelted_material = new S.smelted_material.type()
		name = "[S.material_type] helmet."
		desc += " Helmet forged from [S.material_type]."

		armor.melee += S.attack_amt
		armor.bullet += S.attack_amt
		armor.laser += S.attack_amt
		armor.energy += S.attack_amt
		armor.bomb += S.attack_amt
		armor.bio += S.attack_amt
		armor.rad += S.attack_amt
		armor.fire += S.attack_amt
		armor.acid += S.attack_amt


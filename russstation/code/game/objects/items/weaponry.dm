/obj/item/melee/skateboard/suicide_act(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		var/obj/vehicle/ridden/scooter/skateboard/S = new board_item_type(get_turf(L))
		S.suicide = TRUE
		S.generate_actions()
		L.visible_message("<span class='warning'>[user] prepares for [L.p_their()] final trick.</span>", "<span class='warning'>You prepare yourself for the ultimate ollie, it shall be your last.</span>")
		S.buckle_mob(L)
		qdel(src)
		return MANUAL_SUICIDE_NONLETHAL
	else
		to_chat(user, "<span class='warning'>You are not capable of doing the ultimate trick!</span>")
		return SHAME

//Forging anvil hammer
/obj/item/melee/smith_hammer
	name = "smith's hammer"
	desc = "BONK."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "hammer"
	lefthand_file = 'russstation/icons/mob/inhands/item_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/item_righthand.dmi'
	inhand_icon_state = "hammer"
	force = 10
	w_class = WEIGHT_CLASS_TINY

/obj/item/melee/smith_hammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)

//Forged Broadsword
/obj/item/melee/smithed_sword
	name = "unobtanium broadsword"
	desc = "A broadsword made of unobtanium, you probably shouldn't be seeing this."
	attack_verb_continuous = list("attacks", "slashs", "stabs", "slices", "tears", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "rip", "dice", "cut")
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "sword_base"
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'

/obj/item/melee/smithed_sword/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)

/obj/item/melee/smithed_sword/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/blade/B = locate() in contents
	if(B)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "sword_blade_overlay")
		I.color = B.color
		smelted_material = new B.smelted_material.type()
		add_overlay(I)
		name = "[B.material_type] broadsword"
		force = B.attack_amt * 2
		desc = "A broadsword made of [B.material_type]."
		armour_penetration = B.armour_penetration
		sharpness = B.sharpness

//Forged Pickaxe
/obj/item/pickaxe/smithed_pickaxe
	name = "unobtanium pickaxe"
	desc = "A pickaxe made of unobtanium, you probably shouldn't be seeing this."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "pickaxe_base"
	inhand_icon_state = "spickaxe"

/obj/item/pickaxe/smithed_pickaxe/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)

/obj/item/pickaxe/smithed_pickaxe/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/pickaxe_head/P = locate() in contents
	if(P)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "pickaxe_head_overlay")
		I.color = P.color
		smelted_material = new P.smelted_material.type()
		add_overlay(I)
		name = "[P.material_type] pickaxe"
		force = P.attack_amt
		toolspeed = P.pickaxe_speed
		desc = "A pickaxe made of [P.material_type] head."
		armour_penetration = P.armour_penetration * 1.25 //if you think about it, pickaxes are the best at piercing armour
		sharpness = P.sharpness

//Forged Shovel
/obj/item/shovel/smithed_shovel
	name = "unobtanium shovel"
	desc = "A shovel made of unobtanium, you probably shouldn't be seeing this."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	inhand_icon_state = "shovel"

/obj/item/shovel/smithed_shovel/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)

/obj/item/shovel/smithed_shovel/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/shovel_head/S = locate() in contents
	if(S)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "shovel_head_overlay")
		I.color = S.color
		add_overlay(I)
		smelted_material = new S.smelted_material.type()
		name = "[S.material_type] shovel"
		if(S.blunt_bonus == TRUE)
			force = S.attack_amt *1.25
		else
			force = S.attack_amt * 0.75
		toolspeed = S.pickaxe_speed * 0.5 // gotta DIG FAST
		desc = "A shovel with a [S.material_type] head."
		armour_penetration = S.armour_penetration * 0.5
		sharpness = S.sharpness

//Forged Knife
/obj/item/kitchen/knife/smithed_knife
	name = "unobtanium knife"
	desc = "A knife made of unobtainum, you probably shouldn't be seeing this."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "knife_base"
	inhand_icon_state = "knife"

/obj/item/kitchen/knife/smithed_knife/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)

/obj/item/kitchen/knife/smithed_knife/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/knife_head/K = locate() in contents
	if(K)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "knife_head_overlay")
		I.color = K.color
		add_overlay(I)
		smelted_material = new K.smelted_material.type()
		name = "[K.material_type] knife"
		force = K.attack_amt * 0.5 //chin choppa, CHIN CHOPPA
		desc = "A knife with a [K.material_type] head."
		armour_penetration = K.armour_penetration * 0.5
		sharpness = K.sharpness

//Forged War Hammer
/obj/item/smithed_war_hammer
	name = "unobtanium warhammer"
	desc = "A warhammer made of unobtainium, you probably shouldn't be seeing this."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "pickaxe_base"
	lefthand_file = 'russstation/icons/mob/inhands/item_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/item_righthand.dmi'
	inhand_icon_state = "warhammer"
	worn_icon = 'russstation/icons/mob/back.dmi'
	worn_icon_state = "warhammer"
	force = 11
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throw_speed = 4
	attack_verb_continuous = list("attacks","bludgeons","pulps","gores","tears")
	attack_verb_simple = list("attack","bludgeon","pulp","gore","tear")

/obj/item/smithed_war_hammer/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/war_hammer_head/W = locate() in contents
	if(W)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "war_hammer_head_overlay")
		I.color = W.color
		add_overlay(I)
		smelted_material = new W.smelted_material.type()
		name = "[W.material_type] warhammer"
		var/mult = W.blunt_bonus ? 2 : 0.75
		force = W.attack_amt * mult
		desc = "A warhammer made of [W.material_type]."
		armour_penetration = W.armour_penetration * 3
		sharpness = W.sharpness

/obj/item/smithed_war_hammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/dwarf_rune)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_multiplier=2)

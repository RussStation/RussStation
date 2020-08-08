/obj/item/toy/gun/bigiron
	name = "Big Iron"
	desc = "Keep it on yer hip."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "russianrevolver"
	inhand_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=10)
	attack_verb = list("struck", "pistol whipped", "hit", "bashed")
	bullets = 8

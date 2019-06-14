//prevents dionae from wearing space suits
/obj/item/clothing/head/helmet/space/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(isdiona(M))
		return 0
	return ..()

/obj/item/clothing/suit/space/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(isdiona(M))
		return 0
	return ..()

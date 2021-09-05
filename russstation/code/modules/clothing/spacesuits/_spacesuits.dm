//prevents dionae from wearing space suits
/obj/item/clothing/head/helmet/space/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(isdiona(M))
		return FALSE
	return ..()

/obj/item/clothing/suit/space/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(isdiona(M))
		return FALSE
	return ..()

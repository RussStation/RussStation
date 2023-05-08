//prevents dionae from wearing space suits
/obj/item/clothing/head/helmet/space/mob_can_equip(mob/living/M, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE)
	if(isdiona(M))
		return FALSE
	return ..()

/obj/item/clothing/suit/space/mob_can_equip(mob/living/M, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE)
	if(isdiona(M))
		return FALSE
	return ..()

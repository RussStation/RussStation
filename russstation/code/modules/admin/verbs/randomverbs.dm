/client/proc/honk_smite(mob/living/target as mob)
	set name = "Honk"
	set category = "Fun"
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return

	var/list/punishment_list = list(ADMIN_PUNISHMENT_SHAMEBRERO, ADMIN_PUNISHMENT_PONCHOSHAME)

	var/punishment = input("Choose a punishment", "BIG GOOFS") as null|anything in punishment_list

	if(QDELETED(target) || !punishment)
		return

	switch(punishment)
		if(ADMIN_PUNISHMENT_SHAMEBRERO)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(H.head)
					var/obj/item/I = H.get_item_by_slot(SLOT_HEAD)
					H.doUnEquip(I, TRUE, H.loc, FALSE)

				var/obj/item/clothing/head/sombrero/shamebrero/S = new /obj/item/clothing/head/sombrero/shamebrero(H.loc)
				H.equip_to_slot_or_del(S, SLOT_HEAD)
				///obj/item/clothing/suit/poncho/ponchoshame
		
		if (ADMIN_PUNISHMENT_PONCHOSHAME)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(H.head)
					var/obj/item/I = H.get_item_by_slot(SLOT_WEAR_SUIT)
					H.doUnEquip(I, TRUE, H.loc, FALSE)

				var/obj/item/clothing/suit/poncho/ponchoshame/S = new /obj/item/clothing/suit/poncho/ponchoshame(H.loc)
				H.equip_to_slot_or_del(S, SLOT_WEAR_SUIT)

	punish_log(target, punishment)
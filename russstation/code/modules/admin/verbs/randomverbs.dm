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
					var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_HEAD)
					H.dropItemToGround(I, force = TRUE)

				var/obj/item/clothing/head/sombrero/shamebrero/S = new /obj/item/clothing/head/sombrero/shamebrero(H.loc)
				H.equip_to_slot_or_del(S, ITEM_SLOT_HEAD)
				///obj/item/clothing/suit/poncho/ponchoshame

		if (ADMIN_PUNISHMENT_PONCHOSHAME)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(H.head)
					var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
					H.dropItemToGround(I, force = TRUE)

				var/obj/item/clothing/suit/poncho/ponchoshame/S = new /obj/item/clothing/suit/poncho/ponchoshame(H.loc)
				H.equip_to_slot_or_del(S, ITEM_SLOT_OCLOTHING)

	punish_log(target, punishment)

/client/proc/admin_force_cancel_shuttle()
	set category = "Admin"
	set name = "Force Cancel Shuttle"
	if(!check_rights(0))
		return
	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	SSshuttle.emergency.forcecancel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Force Cancel Shuttle") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-force-recalled the emergency shuttle.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] admin-force-recalled the emergency shuttle.</span>")

	return

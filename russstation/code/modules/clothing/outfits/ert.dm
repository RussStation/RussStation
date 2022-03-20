// basically a wizard outfit with some CC gear
/datum/outfit/centcom/ert/wizard
	name = "ERT Wizard"

	id = /obj/item/card/id/advanced/centcom/ert
	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/wizrobe
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/spellbook = 1,
	)
	ears = /obj/item/radio/headset/headset_cent
	gloves = null
	head = /obj/item/clothing/head/wizard
	mask = null
	shoes = /obj/item/clothing/shoes/sandal/magic
	l_hand = /obj/item/staff

/datum/outfit/centcom/ert/wizard/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return
	// fix ID: helps distinguish us from a bad wizard
	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
		W.update_icon()
	// lock spellbook to this wiz
	var/obj/item/spellbook/S = locate() in H.back
	if(S)
		S.owner = H
	return ..()

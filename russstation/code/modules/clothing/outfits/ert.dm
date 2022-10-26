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

/datum/outfit/centcom/ert/clown/honk_squad
	name = JOB_ERT_HONK_SQUAD
	id = /obj/item/card/id/advanced/centcom/ert/honk_squad

/datum/outfit/centcom/ert/clown/honk_squad/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return

	H.dna.add_mutation(/datum/mutation/human/clumsy)
	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.mutadone_proof = TRUE

/datum/outfit/centcom/ert/clown/circus_seal
	name = JOB_ERT_CIRCUS_SEAL
	id = /obj/item/card/id/advanced/black/deathsquad/circus_seal
	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/cosmohonk
	internals_slot = ITEM_SLOT_SUITSTORE
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	l_hand = /obj/item/pneumatic_cannon/pie/selfcharge
	r_pocket = /obj/item/melee/energy/sword/bananium
	l_pocket = /obj/item/shield/energy/bananium
	shoes = /obj/item/clothing/shoes/clown_shoes/combat
	backpack_contents = list(
		/obj/item/reagent_containers/spray/waterflower/superlube = 1,
		/obj/item/bikehorn/golden = 1,
	)

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

/datum/outfit/centcom/ert/clown
	id = /obj/item/card/id/advanced/centcom/ert
	id_trim = /datum/id_trim/centcom/ert/clown
	uniform = /obj/item/clothing/under/rank/civilian/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	belt = /obj/item/pda/clown
	box = /obj/item/storage/box/hug/survival
	gloves = null
	shoes = /obj/item/clothing/shoes/clown_shoes
	l_pocket = /obj/item/bikehorn
	backpack_contents = list(
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/instrument/bikehorn = 1,
		)
	back = /obj/item/storage/backpack/clown
	implants = list(/obj/item/implant/sad_trombone)

/datum/outfit/centcom/ert/clown/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return

	// new NtOS setup
	var/obj/item/modular_computer/tablet/pda/clown/pda = H.r_store
	pda.saved_identification = H.real_name
	pda.saved_job = name // TODO: Verify this is working correctly

	H.fart = new /datum/fart/human/clown()
	ADD_TRAIT(H, TRAIT_NAIVE, JOB_TRAIT)

	return

/datum/outfit/centcom/ert/clown/honk_squad
	name = JOB_ERT_HONK_SQUAD
	id = /obj/item/card/id/advanced/centcom/ert/honk_squad
	id_trim = /datum/id_trim/centcom/ert/clown/honk_squad

/datum/outfit/centcom/ert/clown/honk_squad/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return

	H.dna.add_mutation(/datum/mutation/human/clumsy)
	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.mutadone_proof = TRUE

/datum/id_trim/centcom/ert/clown/honk_squad/assignment = JOB_ERT_HONK_SQUAD

/datum/outfit/centcom/ert/clown/circus_seal
	name = JOB_ERT_CIRCUS_SEAL
	id = /obj/item/card/id/advanced/black/deathsquad/circus_seal
	id_trim = /datum/id_trim/centcom/deathsquad/circus_seal
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
		/obj/item/reagent_containers/spray/waterflower/superlube,
		/obj/item/bikehorn/golden,
		)

/datum/id_trim/centcom/deathsquad/circus_seal/assignment = JOB_ERT_CIRCUS_SEAL

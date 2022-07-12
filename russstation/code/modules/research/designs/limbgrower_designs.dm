//// limb grower designs for our maintained races
/// Non-Limb Limb Designs
// Skaven Organ Limb Designs
/datum/design/skaven_lungs
	name = "Skaven Lungs"
	id = "skavenlungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 15, /datum/reagent/toxin/bad_food = 10)
	build_path = /obj/item/organ/lungs/skaven
	category = list(SPECIES_SKAVEN)

/datum/design/skaven_tongue
	name = "Putrid Blistering Tongue"
	id = "skaventongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/bad_food = 10)
	build_path = /obj/item/organ/tongue/skaven
	category = list(SPECIES_SKAVEN)

/datum/design/skaven_ears
	name = "Skaven Ears"
	id = "skavenears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/bad_food = 10)
	build_path = /obj/item/organ/ears/skaven
	category = list(SPECIES_SKAVEN)

/datum/design/skaven_tail
	name = "Skaven Tail"
	id = "skaventail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20, /datum/reagent/toxin/bad_food = 10)
	build_path = /obj/item/organ/tail/skaven
	category = list(SPECIES_SKAVEN)

/// Design disks and designs - for adding limbs and organs to the limbgrower.
// Skaven Limb Design Disk
/obj/item/disk/design_disk/limbs/skaven
	name = "Skaven Organ Design Disk"
	limb_designs = list(/datum/design/skaven_lungs, /datum/design/skaven_tongue, /datum/design/skaven_ears, /datum/design/skaven_tail)

/datum/design/limb_disk/skaven
	name = "Skaven Organ Design Disk"
	desc = "Contains designs for skaven organs for the limbgrower - Skaven ears, tail, lungs, and tongue."
	id = "limbdesign_skaven"
	build_path = /obj/item/disk/design_disk/limbs/skaven


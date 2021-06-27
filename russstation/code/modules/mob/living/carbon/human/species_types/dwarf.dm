//this pleases armoks beard
/datum/species/dwarf
	name = "Dwarf"
	id = "dwarf"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	inherent_traits = list(TRAIT_NOBREATH,TRAIT_ADVANCEDTOOLUSER,TRAIT_CAN_STRIP) // tool use for areaeditor; is this too much power?
	mutant_bodyparts = list("wings" = "None")
	limbs_id = "human"
	use_skintones = 1
	speedmod = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	brutemod = 0.9
	coldmod = 0.85
	punchdamagehigh = 11 //fist fighting with dorfs is very dangerous
	mutanteyes = /obj/item/organ/eyes/night_vision
	species_language_holder = /datum/language_holder/dwarf

/datum/species/dwarf/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	C.dna.add_mutation(DWARFISM)
	C.bubble_file = 'russstation/icons/mob/talk.dmi'
	C.bubble_icon = "dwarf"
	var/dwarf_hair = pick("Beard (Dwarf)", "Beard (Very Long)", "Beard (Full)")
	C.facial_hairstyle = dwarf_hair
	C.update_hair()
	// dwarves can see ghosts! and no putting them to rest with slabs, that would be too much
	C.AddComponent(/datum/component/spookable)

/datum/species/dwarf/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.dna.remove_mutation(DWARFISM)
	C.bubble_file = 'icons/mob/talk.dmi'
	C.bubble_icon = initial(C.bubble_icon)
	C.GetComponent(/datum/component/spookable).RemoveComponent()
	. = ..()

/datum/species/dwarf/random_name(gender, unique, lastname)
	return dwarf_name()

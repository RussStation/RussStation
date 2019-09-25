//this pleases armoks beard
/datum/species/dwarf
	name = "Dwarf"
	id = "dwarf"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	inherent_traits = list(TRAIT_NOBREATH)
	mutant_bodyparts = list("tail_human","ears","wings")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	limbs_id = "dwarf"
	use_skintones = 1
	speedmod = 1
	damage_overlay_type = "monkey" //fits really well, so why add more icons?
	skinned_type = /obj/item/stack/sheet/animalhide/human
	brutemod = 0.9
	coldmod = 0.85
	punchdamagehigh = 11 //fist fighting with dorfs is very dangerous
	mutanteyes = /obj/item/organ/eyes/night_vision

/datum/species/dwarf/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	var/dwarf_hair = pick("Beard (Dwarf)", "Beard (Very Long)", "Beard (Full)")
	var/mob/living/carbon/human/H = C 
	H.grant_language(/datum/language/dwarvish)
	H.facial_hair_style = dwarf_hair
	H.update_hair()

/datum/species/dwarf/random_name(gender, unique, lastname)
	return dwarf_name()

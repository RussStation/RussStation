/datum/preference/choiced/tail_kitsune
	savefile_key = "feature_kitsune_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = TRUE
	relevant_mutant_bodypart = "tail_kitsune"

/datum/preference/choiced/tail_kitsune/init_possible_values()
	return assoc_to_keys(GLOB.tails_list_kitsune)

/datum/preference/choiced/tail_kitsune/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_kitsune"] = value

/datum/preference/choiced/tail_kitsune/create_default_value()
	var/datum/sprite_accessory/tails/kitsune/tail = /datum/sprite_accessory/tails/kitsune
	return initial(tail.name)

// /datum/preference/choiced/ears
// 	savefile_key = "feature_kitsune_ears"
// 	savefile_identifier = PREFERENCE_CHARACTER
// 	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
// 	can_randomize = TRUE
// 	relevant_mutant_bodypart = "ears"

// /datum/preference/choiced/ears/init_possible_values()
// 	return assoc_to_keys(GLOB.ears_list)

// /datum/preference/choiced/ears/apply_to_human(mob/living/carbon/human/target, value)
// 	target.dna.features["ears"] = value

// /datum/preference/choiced/ears/create_default_value()
// 	var/datum/sprite_accessory/ears/kitsune/ears = /datum/sprite_accessory/ears/kitsune
// 	return initial(ears.name)

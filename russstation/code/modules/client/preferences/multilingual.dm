/datum/preference/choiced/multilingual
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "multilingual"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/multilingual/init_possible_values()
	return GLOB.multilingual_languages

/datum/preference/choiced/multilingual/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return "Multilingual" in preferences.all_quirks

/datum/preference/choiced/multilingual/apply_to_human(mob/living/carbon/human/target, value)
	return

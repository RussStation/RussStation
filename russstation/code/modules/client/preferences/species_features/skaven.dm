/proc/generate_skaven_side_shots(list/sprite_accessories, key, include_snout = TRUE)
	var/list/values = list()

	var/icon/skaven = icon('russstation/icons/mob/human_parts_greyscale.dmi', "skaven_head", EAST)

	var/icon/eyes = icon('icons/mob/human_face.dmi', "eyes", EAST)
	eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
	skaven.Blend(eyes, ICON_OVERLAY)

	if (include_snout)
		skaven.Blend(icon('icons/mob/mutant_bodyparts.dmi', "m_snout_round_ADJ", EAST), ICON_OVERLAY)

	for (var/name in sprite_accessories)
		var/datum/sprite_accessory/sprite_accessory = sprite_accessories[name]

		var/icon/final_icon = icon(skaven)

		if (sprite_accessory.icon_state != "none")
			var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", EAST)
			final_icon.Blend(accessory_icon, ICON_OVERLAY)

		final_icon.Crop(11, 20, 23, 32)
		final_icon.Scale(32, 32)
		final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

		values[name] = final_icon

	return values

/datum/preference/choiced/skaven_color
	savefile_key = "feature_skavencolor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Skaven Color"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "skavencolor"

/datum/preference/choiced/skaven_color/init_possible_values()
	return GLOB.color_list_skaven

/datum/preference/choiced/skaven_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["skavencolor"] = value

/datum/preference/choiced/skaven_tail
	savefile_key = "feature_skaven_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_mutant_bodypart = "tail_skaven"

/datum/preference/choiced/skaven_tail/init_possible_values()
	return assoc_to_keys(GLOB.tails_list_skaven)

/datum/preference/choiced/skaven_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_skaven"] = value

/datum/preference/choiced/skaven_tail/create_default_value()
	var/datum/sprite_accessory/tails/skaven/tail = /datum/sprite_accessory/tails/skaven
	return initial(tail.name)

/datum/preference/choiced/skaven_snout
	savefile_key = "feature_skaven_snout"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	main_feature_name = "Snout"
	should_generate_icons = TRUE

/datum/preference/choiced/skaven_snout/init_possible_values()
	return generate_skaven_side_shots(GLOB.snouts_list, "snout", include_snout = FALSE)

/datum/preference/choiced/skaven_snout/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["snout"] = value

/datum/preference/choiced/skaven_horns
	savefile_key = "feature_skaven_horns"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	main_feature_name = "Horns"
	should_generate_icons = TRUE

/datum/preference/choiced/skaven_horns/init_possible_values()
	return generate_skaven_side_shots(GLOB.horns_list, "horns")

/datum/preference/choiced/skaven_horns/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["horns"] = value

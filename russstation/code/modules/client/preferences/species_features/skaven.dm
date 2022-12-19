/datum/preference/choiced/skaven_color
	savefile_key = "feature_skavencolor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Fur Color"
	should_generate_icons = TRUE

/datum/preference/choiced/skaven_color/init_possible_values()
	var/list/values = list()

	var/icon/skaven_base = icon('russstation/icons/mob/human_parts_greyscale.dmi', "skaven_head")
	skaven_base.Blend(icon('russstation/icons/mob/human_parts_greyscale.dmi', "skaven_chest"), ICON_OVERLAY)
	skaven_base.Blend(icon('russstation/icons/mob/human_parts_greyscale.dmi', "skaven_l_arm"), ICON_OVERLAY)
	skaven_base.Blend(icon('russstation/icons/mob/human_parts_greyscale.dmi', "skaven_r_arm"), ICON_OVERLAY)

	var/icon/eyes = icon('icons/mob/species/human/human_face.dmi', "eyes")
	eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
	skaven_base.Blend(eyes, ICON_OVERLAY)
	skaven_base.Blend(icon('icons/mob/species/lizard/lizard_misc.dmi', "m_snout_round_ADJ"), ICON_OVERLAY)

	skaven_base.Scale(64, 64)
	skaven_base.Crop(15, 64, 15 + 31, 64 - 31)

	for (var/name in GLOB.color_list_skaven)
		var/color = GLOB.color_list_skaven[name]

		var/icon/icon = new(skaven_base)
		icon.Blend(color, ICON_MULTIPLY)
		values[name] = icon

	return values

/datum/preference/choiced/skaven_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["skaven_color"] = GLOB.color_list_skaven[value]
	target.dna.features["mcolor"] = GLOB.color_list_skaven[value]

// skaven tail selection not working- there's only one choice though, fix later please
/datum/preference/choiced/skaven_tail
	savefile_key = "feature_skaven_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/tail/skaven

/datum/preference/choiced/skaven_tail/init_possible_values()
	return assoc_to_keys(GLOB.tails_list_skaven)

/datum/preference/choiced/skaven_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_skaven"] = value

/datum/preference/choiced/skaven_tail/create_default_value()
	var/datum/sprite_accessory/tails/skaven/tail = /datum/sprite_accessory/tails/skaven
	return initial(tail.name)

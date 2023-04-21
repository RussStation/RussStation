/obj/item/organ/external/tail/skaven
	name = "skaven tail"
	desc = "A nasty severed skaven tail. They lose these all the time."
	preference = "feature_skaven_tail"
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/skaven
	wag_flags = WAG_ABLE
	dna_block = DNA_SKAVEN_TAIL_BLOCK

/obj/item/organ/external/tail/kitsune
	name = "Fox tail"
	desc = "A severed fox tail. are you sure this isn't cursed..?"
	preference = "feature_kitsune_tail"
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/kitsune
	wag_flags = WAG_ABLE
	dna_block = DNA_KITSUNE_TAIL_BLOCK

/datum/bodypart_overlay/mutant/tail/skaven
	feature_key = "tail_skaven"

/datum/bodypart_overlay/mutant/tail/skaven/get_global_feature_list()
	return GLOB.tails_list_skaven

/datum/bodypart_overlay/mutant/tail/kitsune
	color_source = ORGAN_COLOR_HAIR
	feature_key = "tail_kitsune"

/datum/bodypart_overlay/mutant/tail/kitsune/get_global_feature_list()
	return GLOB.tails_list_kitsune

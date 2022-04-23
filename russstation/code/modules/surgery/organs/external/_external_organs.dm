///Diona hair
/obj/item/organ/external/diona_hair
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_DIONA_HAIR
	layers = EXTERNAL_ADJACENT
	// Sprite name
	feature_key = "diona_hair"
	// `savefile_key` from species_features
	preference = "feature_diona_hair"

	dna_block = DNA_DIONA_HAIR_BLOCK

/obj/item/organ/external/diona_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/external/diona_hair/get_global_feature_list()
	return GLOB.diona_hair_list

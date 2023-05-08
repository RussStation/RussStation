///Diona hair
/obj/item/organ/external/diona_hair
	name = "diona hair"
	desc = "Made of hairlike vines and leaves."

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_DIONA_HAIR

	// `savefile_key` from species_features
	preference = "feature_diona_hair"
	// use_mob_sprite_as_obj_sprite = TRUE

	dna_block = DNA_DIONA_HAIR_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_PLANT

	bodypart_overlay = /datum/bodypart_overlay/mutant/diona_hair

/datum/bodypart_overlay/mutant/diona_hair
	layers = EXTERNAL_ADJACENT
	feature_key = "diona_hair"

/datum/bodypart_overlay/mutant/diona_hair/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/datum/bodypart_overlay/mutant/diona_hair/get_global_feature_list()
	return GLOB.diona_hair_list

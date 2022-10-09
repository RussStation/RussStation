//this pleases armoks beard
/datum/species/dwarf
	name = "\improper Dwarf"
	plural_form = "Dwarves"
	id = SPECIES_DWARF
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH,HAS_BONE)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
	)
	mutant_bodyparts = list("wings" = "None")
	species_cookie = /obj/item/reagent_containers/food/drinks/bottle/ale
	use_skintones = 1
	speedmod = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	brutemod = 0.9
	coldmod = 0.85
	punchdamagehigh = 11 //fist fighting with dorfs is very dangerous
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	mutanteyes = /obj/item/organ/internal/eyes/night_vision
	species_language_holder = /datum/language_holder/dwarf
	disliked_food = GROSS | RAW | CLOTH | BUGS
	liked_food = ALCOHOL
	examine_limb_id = SPECIES_DWARF

/// Returns the species's scream sound. (human screams)
/datum/species/dwarf/get_scream_sound(mob/living/carbon/human/human)
	if(human.gender == MALE)
		if(prob(1))
			return 'sound/voice/human/wilhelm_scream.ogg'
		return pick(
			'sound/voice/human/malescream_1.ogg',
			'sound/voice/human/malescream_2.ogg',
			'sound/voice/human/malescream_3.ogg',
			'sound/voice/human/malescream_4.ogg',
			'sound/voice/human/malescream_5.ogg',
			'sound/voice/human/malescream_6.ogg',
		)

	return pick(
		'sound/voice/human/femalescream_1.ogg',
		'sound/voice/human/femalescream_2.ogg',
		'sound/voice/human/femalescream_3.ogg',
		'sound/voice/human/femalescream_4.ogg',
		'sound/voice/human/femalescream_5.ogg',
	)

/datum/species/dwarf/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	C.dna.add_mutation(/datum/mutation/human/dwarfism)
	for(var/datum/mutation/human/dwarfism/dwarf_mutation in C.dna.mutations)
		dwarf_mutation.mutadone_proof = TRUE
	C.bubble_file = 'russstation/icons/mob/talk.dmi'
	C.bubble_icon = "dwarf"
	var/dwarf_hair = pick("Beard (Dwarf)", "Beard (Very Long)", "Beard (Full)")
	C.facial_hairstyle = dwarf_hair
	C.update_hair(is_creating = TRUE)
	// dwarves can see ghosts! and no putting them to rest with slabs, that would be too much
	C.AddComponent(/datum/component/spookable)

/datum/species/dwarf/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.dna.remove_mutation(/datum/mutation/human/dwarfism)
	C.bubble_file = 'icons/mob/talk.dmi'
	C.bubble_icon = initial(C.bubble_icon)
	qdel(C.GetComponent(/datum/component/spookable))
	. = ..()

/datum/species/dwarf/random_name(gender, unique, lastname)
	return dwarf_name()

/datum/species/dwarf/get_species_description()
	return "Short and sturdy creatures fond \
	of industry and drink."

/datum/species/dwarf/get_species_lore()
	return list(
		"Dwarves are beings who favor crafting with \
	rock and stone and metal. They often have long \
	beards and known to clash with elves.",
	)

/datum/species/dwarf/lavaland
	id = SPECIES_DWARF_LAVA
	inherent_traits = list(
		TRAIT_CAN_STRIP,
		TRAIT_VIRUSIMMUNE, // lavaland has miasma
		TRAIT_LITERATE,  // Required to be able to read the notes and books for crafting
		// TRAIT_CHUNKYFINGERS, // Might add to prevent using guns etc.
		// TRAIT_DISCOORDINATED_TOOL_USER // could be added (prevents advanced tool usage)
	)
	species_language_holder = /datum/language_holder/dwarf/lavaland
	// Lizard lungs (just to avoid needing no breath)
	mutantlungs = /obj/item/organ/internal/lungs/ashwalker
	examine_limb_id = SPECIES_DWARF

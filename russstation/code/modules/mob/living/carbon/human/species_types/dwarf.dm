//this pleases armoks beard
/datum/species/dwarf
	name = "\improper Dwarf"
	plural_form = "Dwarves"
	id = SPECIES_DWARF
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH,HAS_BONE)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_LITERATE,
	)
	mutant_bodyparts = list("wings" = "None")
	species_cookie = /obj/item/reagent_containers/food/drinks/bottle/ale
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	brutemod = 1.15
	coldmod = 1.15
	punchdamagehigh = 11 //fist fighting with dorfs is very dangerous
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
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
	C.dna.add_mutation(/datum/mutation/human/lesser_dwarfism)
	for(var/datum/mutation/human/lesser_dwarfism/dwarf_mutation in C.dna.mutations)
		dwarf_mutation.mutadone_proof = TRUE
	C.bubble_file = 'russstation/icons/mob/talk.dmi'
	C.bubble_icon = "dwarf"

/datum/species/dwarf/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.dna.remove_mutation(/datum/mutation/human/lesser_dwarfism)
	C.bubble_file = 'icons/mob/talk.dmi'
	C.bubble_icon = initial(C.bubble_icon)
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

/datum/species/dwarf/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "band-aid",
			SPECIES_PERK_NAME = "Ethanol Healing",
			SPECIES_PERK_DESC = "Drinking excessive alcohol heals your bruises and burns, \
				but you need to get pretty smashed to heal more severe wounds and burns. ",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "skull",
			SPECIES_PERK_NAME = "Dwarven Wimp",
			SPECIES_PERK_DESC = "Due to being away from the Mountainhomes for so long, \
				your physique has deteriorated and because of this you take 15% more \
				physical damage.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "fist-raised",
			SPECIES_PERK_NAME = "Small",
			SPECIES_PERK_DESC = "Thanks to your Dwarven size you are harder to hit, but \
				you are also easier to knock down.",
		),
	)

	return to_add

/datum/species/dwarf/lavaland
	id = SPECIES_DWARF_LAVA
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_VIRUSIMMUNE, // lavaland has miasma
		TRAIT_LITERATE,  // Required to be able to read the notes and books for crafting
	)
	coldmod = 1.50 // ouch
	heatmod = 0.5
	species_language_holder = /datum/language_holder/dwarf/lavaland
	// Lizard lungs (just to avoid needing no breath)
	mutantlungs = /obj/item/organ/internal/lungs/ashwalker
	mutanteyes = /obj/item/organ/internal/eyes/night_vision
	examine_limb_id = SPECIES_DWARF

/datum/species/dwarf/lavaland/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	// dwarves can see ghosts! and no putting them to rest with slabs, that would be too much
	C.AddComponent(/datum/component/spookable)

/datum/species/dwarf/lavaland/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	qdel(C.GetComponent(/datum/component/spookable))
	. = ..()

/datum/species/dwarf/mountain
	id = SPECIES_DWARF_MOUNTAIN
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_VIRUSIMMUNE,
		TRAIT_LITERATE,
		TRAIT_NOBREATH,
	)
	coldmod = 0.5
	heatmod = 1.5 //youch
	brutemod = 0.4
	punchdamagelow = 5 //Mountain dwarfs pack a meaner punch cause of the local wild life
	species_language_holder = /datum/language_holder/dwarf/lavaland
	mutanteyes = /obj/item/organ/internal/eyes/night_vision

/datum/species/dwarf/mountain/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	// dwarves can see ghosts! and no putting them to rest with slabs, that would be too much
	C.AddComponent(/datum/component/spookable)

/datum/species/dwarf/mountain/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	qdel(C.GetComponent(/datum/component/spookable))
	. = ..()

/datum/species/dwarf/chaos
	id = SPECIES_DWARF_CHAOS
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_VIRUSIMMUNE,
		TRAIT_LITERATE,
		TRAIT_NOBREATH,
	)
	coldmod = 0.9
	heatmod = 0.9
	punchdamagelow = 3 //Pissed off that they are alive
	disliked_food = NONE
	liked_food = BUGS | ALCOHOL | RAW | CLOTH | NUTS | VEGETABLES | SEAFOOD | MEAT
	species_language_holder = /datum/language_holder/dwarf/lavaland
	mutanteyes = /obj/item/organ/internal/eyes/night_vision
	deathsound = 'sound/machines/clockcult/ark_deathrattle.ogg' //spooky
	say_mod = "gurgles"

	//Variables for holding our randomly generated limbs on creation
	var/random_head
	var/random_chest
	var/random_l_arm
	var/random_r_arm
	var/random_l_leg
	var/random_r_leg

/datum/species/dwarf/chaos/spec_life(mob/living/carbon/C, delta_time, times_fired)
	. = ..()
	//Let out a scream of agony once in a while
	if(!HAS_TRAIT(C, TRAIT_CRITICAL_CONDITION) && DT_PROB(0.8, delta_time))
		playsound(C, pick(list('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/wail.ogg')), 50, TRUE, 10)

/datum/species/dwarf/chaos/replace_body(mob/living/carbon/target, datum/species/new_species)
	random_head  = pick(list( /obj/item/bodypart/head/lizard,  /obj/item/bodypart/head/ethereal,  /obj/item/bodypart/head/abductor,  /obj/item/bodypart/head/alien,  /obj/item/bodypart/head/fly,  /obj/item/bodypart/head/golem, /obj/item/bodypart/head/golem/bone, /obj/item/bodypart/head/golem/cardboard, /obj/item/bodypart/head/golem/cloth, /obj/item/bodypart/head/golem/cult, /obj/item/bodypart/head/golem/durathread, /obj/item/bodypart/head/golem/snow, /obj/item/bodypart/head/jelly, /obj/item/bodypart/head/luminescent, /obj/item/bodypart/head/monkey, /obj/item/bodypart/head/moth, /obj/item/bodypart/head/mushroom, /obj/item/bodypart/head/plasmaman, /obj/item/bodypart/head/pod, /obj/item/bodypart/head/robot, /obj/item/bodypart/head/shadow, /obj/item/bodypart/head/skaven, /obj/item/bodypart/head/skeleton, /obj/item/bodypart/head/slime, /obj/item/bodypart/head/snail, /obj/item/bodypart/head/zombie))
	random_chest = pick(list(/obj/item/bodypart/chest/lizard, /obj/item/bodypart/chest/ethereal, /obj/item/bodypart/chest/abductor, /obj/item/bodypart/chest/alien, /obj/item/bodypart/chest/fly, /obj/item/bodypart/chest/golem,/obj/item/bodypart/chest/golem/bone,/obj/item/bodypart/chest/golem/cardboard,/obj/item/bodypart/chest/golem/cloth,/obj/item/bodypart/chest/golem/cult,/obj/item/bodypart/chest/golem/durathread,/obj/item/bodypart/chest/golem/snow,/obj/item/bodypart/chest/jelly,/obj/item/bodypart/chest/luminescent,/obj/item/bodypart/chest/monkey,/obj/item/bodypart/chest/moth,/obj/item/bodypart/chest/mushroom,/obj/item/bodypart/chest/plasmaman,/obj/item/bodypart/chest/pod,/obj/item/bodypart/chest/robot,/obj/item/bodypart/chest/shadow,/obj/item/bodypart/chest/skaven,/obj/item/bodypart/chest/skeleton,/obj/item/bodypart/chest/slime,/obj/item/bodypart/chest/snail,/obj/item/bodypart/chest/zombie))
	random_l_arm = pick(list(/obj/item/bodypart/l_arm/lizard, /obj/item/bodypart/l_arm/ethereal, /obj/item/bodypart/l_arm/abductor, /obj/item/bodypart/l_arm/alien, /obj/item/bodypart/l_arm/fly, /obj/item/bodypart/l_arm/golem,/obj/item/bodypart/l_arm/golem/bone,/obj/item/bodypart/l_arm/golem/cardboard,/obj/item/bodypart/l_arm/golem/cloth,/obj/item/bodypart/l_arm/golem/cult,/obj/item/bodypart/l_arm/golem/durathread,/obj/item/bodypart/l_arm/golem/snow,/obj/item/bodypart/l_arm/jelly,/obj/item/bodypart/l_arm/luminescent,/obj/item/bodypart/l_arm/monkey,/obj/item/bodypart/l_arm/moth,/obj/item/bodypart/l_arm/mushroom,/obj/item/bodypart/l_arm/plasmaman,/obj/item/bodypart/l_arm/pod,/obj/item/bodypart/l_arm/robot,/obj/item/bodypart/l_arm/shadow,/obj/item/bodypart/l_arm/skaven,/obj/item/bodypart/l_arm/skeleton,/obj/item/bodypart/l_arm/slime,/obj/item/bodypart/l_arm/snail,/obj/item/bodypart/l_arm/zombie))
	random_r_arm = pick(list(/obj/item/bodypart/r_arm/lizard, /obj/item/bodypart/r_arm/ethereal, /obj/item/bodypart/r_arm/abductor, /obj/item/bodypart/r_arm/alien, /obj/item/bodypart/r_arm/fly, /obj/item/bodypart/r_arm/golem,/obj/item/bodypart/r_arm/golem/bone,/obj/item/bodypart/r_arm/golem/cardboard,/obj/item/bodypart/r_arm/golem/cloth,/obj/item/bodypart/r_arm/golem/cult,/obj/item/bodypart/r_arm/golem/durathread,/obj/item/bodypart/r_arm/golem/snow,/obj/item/bodypart/r_arm/jelly,/obj/item/bodypart/r_arm/luminescent,/obj/item/bodypart/r_arm/monkey,/obj/item/bodypart/r_arm/moth,/obj/item/bodypart/r_arm/mushroom,/obj/item/bodypart/r_arm/plasmaman,/obj/item/bodypart/r_arm/pod,/obj/item/bodypart/r_arm/robot,/obj/item/bodypart/r_arm/shadow,/obj/item/bodypart/r_arm/skaven,/obj/item/bodypart/r_arm/skeleton,/obj/item/bodypart/r_arm/slime,/obj/item/bodypart/r_arm/snail,/obj/item/bodypart/r_arm/zombie))
	random_l_leg = pick(list(/obj/item/bodypart/l_leg/lizard, /obj/item/bodypart/l_leg/ethereal, /obj/item/bodypart/l_leg/abductor, /obj/item/bodypart/l_leg/alien, /obj/item/bodypart/l_leg/fly, /obj/item/bodypart/l_leg/golem,/obj/item/bodypart/l_leg/golem/bone,/obj/item/bodypart/l_leg/golem/cardboard,/obj/item/bodypart/l_leg/golem/cloth,/obj/item/bodypart/l_leg/golem/cult,/obj/item/bodypart/l_leg/golem/durathread,/obj/item/bodypart/l_leg/golem/snow,/obj/item/bodypart/l_leg/jelly,/obj/item/bodypart/l_leg/luminescent,/obj/item/bodypart/l_leg/monkey,/obj/item/bodypart/l_leg/moth,/obj/item/bodypart/l_leg/mushroom,/obj/item/bodypart/l_leg/plasmaman,/obj/item/bodypart/l_leg/pod,/obj/item/bodypart/l_leg/robot,/obj/item/bodypart/l_leg/shadow,/obj/item/bodypart/l_leg/skaven,/obj/item/bodypart/l_leg/skeleton,/obj/item/bodypart/l_leg/slime,/obj/item/bodypart/l_leg/snail,/obj/item/bodypart/l_leg/zombie))
	random_r_leg = pick(list(/obj/item/bodypart/r_leg/lizard, /obj/item/bodypart/r_leg/ethereal, /obj/item/bodypart/r_leg/abductor, /obj/item/bodypart/r_leg/alien, /obj/item/bodypart/r_leg/fly, /obj/item/bodypart/r_leg/golem,/obj/item/bodypart/r_leg/golem/bone,/obj/item/bodypart/r_leg/golem/cardboard,/obj/item/bodypart/r_leg/golem/cloth,/obj/item/bodypart/r_leg/golem/cult,/obj/item/bodypart/r_leg/golem/durathread,/obj/item/bodypart/r_leg/golem/snow,/obj/item/bodypart/r_leg/jelly,/obj/item/bodypart/r_leg/luminescent,/obj/item/bodypart/r_leg/monkey,/obj/item/bodypart/r_leg/moth,/obj/item/bodypart/r_leg/mushroom,/obj/item/bodypart/r_leg/plasmaman,/obj/item/bodypart/r_leg/pod,/obj/item/bodypart/r_leg/robot,/obj/item/bodypart/r_leg/shadow,/obj/item/bodypart/r_leg/skaven,/obj/item/bodypart/r_leg/skeleton,/obj/item/bodypart/r_leg/slime,/obj/item/bodypart/r_leg/snail,/obj/item/bodypart/r_leg/zombie))

	new_species.bodypart_overrides = list(
		BODY_ZONE_HEAD = random_head,
		BODY_ZONE_CHEST = random_chest,
		BODY_ZONE_L_ARM = random_l_arm,
		BODY_ZONE_R_ARM = random_r_arm,
		BODY_ZONE_L_LEG = random_l_leg,
		BODY_ZONE_R_LEG = random_r_leg,
	)

	. = ..()

/datum/species/dwarf/chaos/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	// dwarves can see ghosts! and no putting them to rest with slabs, that would be too much
	C.AddComponent(/datum/component/spookable)

/datum/species/dwarf/chaos/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	qdel(C.GetComponent(/datum/component/spookable))
	. = ..()

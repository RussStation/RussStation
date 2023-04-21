/datum/species/kobold
	name = "\improper Kobold"
	plural_form = "Kobolds"
	id = SPECIES_KOBOLD
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_LITERATE,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_REPTILE
	mutant_bodyparts = list("body_markings" = "None", "legs" = "Normal Legs")
	external_organs= list(
		/obj/item/organ/external/horns = "None",
		/obj/item/organ/external/frills = "None",
		/obj/item/organ/external/snout = "Round",
		/obj/item/organ/external/spines = "None",
		/obj/item/organ/external/tail/lizard = "Smooth",
	)
	mutanttongue = /obj/item/organ/internal/tongue/lizard
	coldmod = 1.5
	heatmod = 0.67
	payday_modifier = 0.50
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_cookie = /obj/item/food/meat/slab
	meat = /obj/item/food/meat/slab/human/mutant/kobold
	skinned_type = /obj/item/stack/sheet/animalhide/kobold
	exotic_bloodtype = "L"
	disliked_food = DAIRY
	liked_food = GROSS | MEAT | SEAFOOD | NUTS | BUGS | RAW
	inert_mutation = /datum/mutation/human/firebreath
	death_sound = 'sound/voice/lizard/deathsound.ogg'
	wing_types = list(/obj/item/organ/external/wings/functional/dragon)
	species_language_holder = /datum/language_holder/lizard
	digitigrade_customization = DIGITIGRADE_OPTIONAL

	bodytemp_heat_damage_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT + 20)
	bodytemp_cold_damage_limit = (BODYTEMP_COLD_DAMAGE_LIMIT - 10)

	ass_image = 'icons/ass/asslizard.png'

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/lizard,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/lizard,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/lizard,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/lizard,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/lizard,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/lizard,
	)

//Small dudes
/datum/species/kobold/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	. = ..()
	C.dna.add_mutation(/datum/mutation/human/lesser_dwarfism)

	C.bubble_file = 'russstation/icons/mob/talk.dmi'
	C.bubble_icon = "kobold"

	for(var/datum/mutation/human/lesser_dwarfism/dwarf_mutation in C.dna.mutations)
		dwarf_mutation.mutadone_proof = TRUE

/datum/species/kobold/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.dna.remove_mutation(/datum/mutation/human/lesser_dwarfism)
	C.bubble_file = 'icons/mob/effects/talk.dmi'
	C.bubble_icon = initial(C.bubble_icon)
	. = ..()

//Cold blooded
/datum/species/kobold/body_temperature_core(mob/living/carbon/human/humi, seconds_per_tick, times_fired)
	return

/datum/species/kobold/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/kobold/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/tail = pick(GLOB.tails_list_lizard)
	human_mob.dna.features["tail_lizard"] = tail
	mutant_bodyparts["tail_lizard"] = tail
	human_mob.update_body()

/datum/species/kobold/get_scream_sound(mob/living/carbon/human/kobold)
	return pick(
		'sound/voice/lizard/lizard_scream_1.ogg',
		'sound/voice/lizard/lizard_scream_2.ogg',
		'sound/voice/lizard/lizard_scream_3.ogg',
	)

/datum/species/kobold/get_species_description()
	return "A small, squat humanoid with large pointy ears, horns and glowing eyes."

/datum/species/kobold/get_species_lore()
	return list(
		"Kobold's were discovered scattered across various plants and stars close to one another. \
		Not much is known about Kobold history but, it is very apparent that Koboldkind were capable of space travel but and at some point something \
		happened that regressed their race into cave dwelling tribes, with debris of old ships and stations found around their stars.",

		"Despite the state Koboldkind was found in, Humans would use Kobold's as cheap labor especially as miners for their high resistance to \
		harsh enviroments.",

		"It has also been found that Kobold's are very closely related to Drakes who are also found around various planets and stars.",
	)

// Override for the default temperature perks, so we can give our specific "cold blooded" perk.
/datum/species/kobold/create_pref_temperature_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "thermometer-empty",
		SPECIES_PERK_NAME = "Cold-blooded",
		SPECIES_PERK_DESC = "Koboldkind have higher tolerance for hot temperatures, but lower \
			tolerance for cold temperatures. Additionally, they cannot self-regulate their body temperature - \
			they are as cold or as warm as the environment around them is. Stay warm!",
	))

	return to_add


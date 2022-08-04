/datum/species/skaven
	name = "\improper Skaven"
	id = SPECIES_SKAVEN
	say_mod = "jitters"
	species_traits = list(MUTCOLORS, AGENDER, EYECOLOR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	external_organs = list(
		/obj/item/organ/external/horns = "None",
		/obj/item/organ/external/snout = "Round",
		/obj/item/organ/external/tail/skaven = "Skaven",
	)
	mutantears = /obj/item/organ/internal/ears/skaven
	mutantlungs = /obj/item/organ/internal/lungs/skaven
	mutanttongue = /obj/item/organ/internal/tongue/skaven
	payday_modifier = 0.25 //Might as well be a slave
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	// TODO: possibly change cookie to something else
	species_cookie = /obj/item/food/meat/slab
	attack_verb = "claw"
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/food/meat/slab/human/mutant/skaven
	skinned_type = /obj/item/stack/sheet/animalhide/skaven
	disliked_food = NONE
	liked_food = GROSS | MEAT
	outfit_important_for_life = /datum/outfit/skaven
	species_language_holder = /datum/language_holder/skaven
	sexes = FALSE //ever heard of female skaven? didnt think so
	hair_color = "mutcolor"
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/skaven,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/skaven,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/skaven,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/skaven,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/skaven,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/skaven,
	)

/datum/species/skaven/get_features()
	var/list/features = ..()

	features += "feature_skavencolor"

	return features

/datum/species/skaven/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	equipping.equipOutfit(/datum/outfit/skaven, visuals_only)
	equipping.internal = equipping.get_item_for_held_index(2)

/datum/species/skaven/random_name(gender, unique, lastname)
	if(unique)
		return random_unique_skaven_name()

	var/randname = skaven_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/skaven/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/tail = pick(GLOB.tails_list_skaven)
	human_mob.dna.features["tail_skaven"] = tail
	mutant_bodyparts["tail_skaven"] = tail
	human_mob.update_body()

/datum/species/skaven/get_species_description()
	return "The enigmatic Rat-folk, hailing from deep underground on many \
		planets. Having travelled amongst the stars through few feats of their \
		own, yet are industrious enough to have earned a spot among Nanotrasen's \
		less-than-finest."

/datum/species/skaven/get_species_lore()
	return list(
		"The Skaven have made homes and hovels underground on many planets, but poor recordkeeping and countless civil wars between numerous clans have lost their origin planet to time. What little records remain hint of a mysterious substance known as warpstone, but any accounts beyond being a source of great power have been chewed beyond recognition.",
    	"Accustomed to depths far below most races would go, Skaven being among the surface dwellers are a relatively recent development. The clans united in an effort to seek the warpstone once more, so they might one day understand where they came from, and what drove their clans to such violence.",
	)

/datum/species/skaven/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Miasma Breathing",
			SPECIES_PERK_DESC = "Skaven must breathe miasma to survive. You receive a \
				tank when you arrive. Additional miasma can be created via compost \
				bins or ordered from cargo.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "hand-holding-usd",
			SPECIES_PERK_NAME = "Reduced Salary",
			SPECIES_PERK_DESC = "Skaven are not held in high regard. Your salary will be \
        		significantly less than other species.",
		),
	)

	return to_add

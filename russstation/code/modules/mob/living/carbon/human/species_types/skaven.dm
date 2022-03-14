/datum/species/skaven
	name = "Skaven"
	id = "skaven"
	say_mod = "jitters"
	default_color = "2E2E2E"
	species_traits = list(MUTCOLORS, AGENDER, EYECOLOR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list("tail_skaven" = "Skaven")
	external_organs = list(/obj/item/organ/external/horns = "None", /obj/item/organ/external/snout = "Round")
	mutantears = /obj/item/organ/ears/skaven
	mutantlungs = /obj/item/organ/lungs/skaven
	mutanttongue = /obj/item/organ/tongue/skaven
	mutant_organs = list(/obj/item/organ/tail/skaven)
	payday_modifier = 0.25 //Might as well be a slave
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
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

/datum/species/skaven/get_features()
	. = ..()
	// skaven color is a DNA property which get_features doesn't retrieve; add it manually if missing
	if (!("feature_skavencolor" in GLOB.features_by_species[type]))
		GLOB.features_by_species[type] += "feature_skavencolor"
		. += "feature_skavencolor"

/datum/species/skaven/pre_equip_species_outfit(datum/job/J, mob/living/carbon/human/H, visualsOnly = FALSE)
	H.equipOutfit(/datum/outfit/skaven, visualsOnly)
	H.internal = H.get_item_for_held_index(2)
	H.update_internals_hud_icon(1)

/datum/species/skaven/random_name(gender, unique, lastname)
	if(unique)
		return random_unique_skaven_name()

	var/randname = skaven_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/skaven/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/skaven/spec_stun(mob/living/carbon/human/H, amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/skaven/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["tail_skaven"] || mutant_bodyparts["waggingtail_skaven"]

/datum/species/skaven/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["waggingtail_skaven"]

/datum/species/skaven/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["tail_skaven"])
		mutant_bodyparts["waggingtail_skaven"] = mutant_bodyparts["tail_skaven"]
		mutant_bodyparts -= "tail_skaven"
	H.update_body()

/datum/species/skaven/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["waggingtail_skaven"])
		mutant_bodyparts["tail_skaven"] = mutant_bodyparts["waggingtail_skaven"]
		mutant_bodyparts -= "waggingtail_skaven"
	H.update_body()

/datum/species/skaven/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	var/mob/living/carbon/human/skaven = C
	var/real_tail_type = skaven.dna.features["tail_skaven"] // hold onto tail until parent proc finished?

	if(!pref_load)
		if(skaven.dna.features["ears"] == "None")
			skaven.dna.features["ears"] = "Skaven"
	if(skaven.dna.features["ears"] == "Skaven")
		var/obj/item/organ/ears/skaven/ears = new
		ears.Insert(skaven, drop_if_replaced = FALSE)

	. = ..()

	//Loads tail preferences.
	if(pref_load)
		if(!real_tail_type || real_tail_type == "None")
			skaven.dna.features["tail_skaven"] = "Skaven"
		else
			skaven.dna.features["tail_skaven"] = real_tail_type

		var/obj/item/organ/tail/skaven/new_tail = new /obj/item/organ/tail/skaven()

		new_tail.tail_type = skaven.dna.features["tail_skaven"]
		new_tail.Insert(skaven, TRUE, FALSE)

	// ensure colors are synchronized
	default_color = skaven.dna.features["mcolor"] = skaven.dna.features["skaven_color"]

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

//Skaven mob define
/mob/living/carbon/human/species/skaven
	race = /datum/species/skaven

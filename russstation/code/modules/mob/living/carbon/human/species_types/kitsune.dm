/datum/species/human/kitsune
	name = "Kitsune"
	id = "kitsune"
	say_mod = "gekkers"
	// use_skintones = 1
	// species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH,HAS_BONE)

	mutant_bodyparts = list("tail_kitsune" = "kitsune", "ears" = "kitsune", "wings" = "None")

	mutantears = /obj/item/organ/ears/kitsune
	mutant_organs = list(/obj/item/organ/tail/kitsune)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/kitsune
	disliked_food = GROSS | CLOTH | RAW
	liked_food = MEAT | FRUIT
	payday_modifier = 0.75
	ass_image = 'icons/ass/asscat.png'
	family_heirlooms = list(/obj/item/food/egg, /obj/item/gohei)
	examine_limb_id = SPECIES_HUMAN
	meat = /obj/item/food/meat/slab/human/mutant/kitsune
	skinned_type = /obj/item/stack/sheet/animalhide/kitsune

/datum/species/human/kitsune/random_name(gender, unique, lastname)
	if(unique)
		return random_unique_kitsune_name()

	var/randname = kitsune_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/human/kitsune/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/human/kitsune/spec_stun(mob/living/carbon/human/H, amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/human/kitsune/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["tail_kitsune"] || mutant_bodyparts["waggingtail_kitsune"]

/datum/species/human/kitsune/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["waggingtail_kitsune"]

/datum/species/human/kitsune/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["tail_kitsune"])
		mutant_bodyparts["waggingtail_kitsune"] = mutant_bodyparts["tail_kitsune"]
		mutant_bodyparts -= "tail_kitsune"
	H.update_body()

/datum/species/human/kitsune/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["waggingtail_kitsune"])
		mutant_bodyparts["tail_kitsune"] = mutant_bodyparts["waggingtail_kitsune"]
		mutant_bodyparts -= "waggingtail_kitsune"
	H.update_body()

/datum/species/human/kitsune/prepare_human_for_preview(mob/living/carbon/human/human)
	human.hairstyle = "Long Bedhead"
	human.hair_color = "#ffb004" // ORANG
	human.update_hair()

	var/obj/item/organ/ears/kitsune/fox_ears = human.getorgan(/obj/item/organ/ears/kitsune)
	if (fox_ears)
		fox_ears.color = human.hair_color
		human.update_body()

/datum/species/human/kitsune/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!pref_load)
			if(H.dna.features["tail_kitsune"] == "None")
				H.dna.features["tail_kitsune"] = "kitsune"
			if(H.dna.features["ears"] == "None")
				H.dna.features["ears"] = "kitsune"
		if(H.dna.features["ears"] == "kitsune")
			var/obj/item/organ/ears/kitsune/ears = new
			ears.Insert(H, drop_if_replaced = FALSE)
		else
			mutantears = /obj/item/organ/ears
		if(H.dna.features["tail_kitsune"] == "kitsune")
			var/obj/item/organ/tail/kitsune/tail = new
			tail.Insert(H, special = TRUE, drop_if_replaced = FALSE)
		else
			mutant_organs = list()
		// H.dna.features["mcolor"] = H.hair_color
	return ..()

/datum/species/human/kitsune/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/tail = pick(GLOB.tails_list_kitsune)
	human_mob.dna.features["tail_kitsune"] = tail
	mutant_bodyparts["tail_kitsune"] = tail
	var/ears = pick(GLOB.ears_list)
	human_mob.dna.features["ears"] = ears
	human_mob.update_body()

/datum/species/human/kitsune/get_species_description()
	return "Kitsune are one of the many types of genetic \
		modifications to come of humanity's mastery of genetic science, and are \
		a relatively uncommon variant of the animalids"

/datum/species/human/kitsune/get_species_lore()
	return list(
		"Bio-engineering has resulted in many different variants of animalids, some more.. eccentric than others, \
			Kitsune are one such result, being very similar to felinids in that while they mostly just gained a tail and ears \
			there were some more.. unintended effects on their thought process and speech patterns.",

		"Never the less, these variant of animalid is still popular among small groups of frea- of like minded individuals, enjoying \
			the fluffy ears and tails that the procedure gave them, alongside the violent racism and distain from non animalid races.",
	)

/datum/species/human/kitsune/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = "Sensitive Hearing",
			SPECIES_PERK_DESC = "Kitsunes are more sensitive to loud sounds, such as flashbangs, or the sound of a chef cracking \
			an egg",
		),
	)

	return to_add

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
	family_heirlooms = list(/obj/item/food/egg)
	examine_limb_id = SPECIES_HUMAN

/datum/species/kitsune/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/kitsune/spec_stun(mob/living/carbon/human/H, amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/kitsune/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["tail_kitsune"] || mutant_bodyparts["waggingtail_kitsune"]

/datum/species/kitsune/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["waggingtail_kitsune"]

/datum/species/kitsune/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["tail_kitsune"])
		mutant_bodyparts["waggingtail_kitsune"] = mutant_bodyparts["tail_kitsune"]
		mutant_bodyparts -= "tail_kitsune"
	H.update_body()

/datum/species/kitsune/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["waggingtail_kitsune"])
		mutant_bodyparts["tail_kitsune"] = mutant_bodyparts["waggingtail_kitsune"]
		mutant_bodyparts -= "waggingtail_kitsune"
	H.update_body()

/datum/species/kitsune/prepare_human_for_preview(mob/living/carbon/human/human)
	human.hairstyle = "Long Bedhead"
	human.hair_color = "#ffb004" // ORANG
	human.update_hair()

	var/obj/item/organ/ears/kitsune/fox_ears = human.getorgan(/obj/item/organ/ears/kitsune)
	if (fox_ears)
		fox_ears.color = human.hair_color
		human.update_body()

/datum/species/kitsune/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
    var/mob/living/carbon/human/kitsune = C
    var/real_tail_type = kitsune.dna.features["tail_kitsune"] // hold onto tail until parent proc finished?

    if(!pref_load)
        if(kitsune.dna.features["ears"] == "None")
            kitsune.dna.features["ears"] = "kitsune"
    if(kitsune.dna.features["ears"] == "kitsune")
        var/obj/item/organ/ears/kitsune/ears = new
        ears.Insert(kitsune, drop_if_replaced = FALSE)

    . = ..()

    //Loads tail preferences.
    if(pref_load)
        if(!real_tail_type || real_tail_type == "None")
            kitsune.dna.features["tail_kitsune"] = "kitsune"
        else
            kitsune.dna.features["tail_kitsune"] = real_tail_type

        var/obj/item/organ/tail/kitsune/new_tail = new /obj/item/organ/tail/kitsune()

        new_tail.tail_type = kitsune.dna.features["tail_kitsune"]
        new_tail.Insert(kitsune, TRUE, FALSE)

        if(kitsune.dna.features["ears"] == "kitsune")
            var/obj/item/organ/ears/kitsune/ears = new
            ears.Insert(kitsune, drop_if_replaced = FALSE)
        else if (kitsune.dna.features["ears"] == "Cat")
            mutantears = /obj/item/organ/ears/cat
        else
            mutantears = /obj/item/organ/ears

    // ensure colors are synchronized
    default_color = kitsune.dna.features["mcolor"] = kitsune.dna.features["kitsune_color"]

/datum/species/human/kitsune/get_species_description()
	return "Kitsune are one of the many types of bespoke genetic \
		modifications to come of humanity's mastery of genetic science, and are \
		a relatively uncommon variant of the animalids"

/datum/species/human/kitsune/get_species_lore()
	return list(
		"Bio-engineering has resulted in many different variants of animalids, some more.. eccentric than others, \
			Kitsune are one such result, being very similar to felinids in that while they mostly just gained a tail and ears \
			there were some more.. unintended effects on their though process and speech patterns.",

		"Never the less, these variant of animalid is still popular among small groups of frea- of like minded individuals, enjoying \
			the fluffy ears and tails that the procedure gave them, alongside the violent racism and distain from non animalid races.",
	)

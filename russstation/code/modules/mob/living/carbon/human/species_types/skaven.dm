/datum/species/skaven
	name = "Skaven"
	id = "skaven"
	say_mod = "jitters"
	default_color = "2E2E2E"
	species_traits = list(DYNCOLORS,AGENDER,EYECOLOR,LIPS,HAS_FLESH,HAS_BONE)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list("tail_skaven" = "Skaven", "snout" = "Round", "horns" = "None")
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

/datum/species/skaven/before_equip_job(datum/job/J, mob/living/carbon/human/H, visualsOnly = FALSE)
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
	var/real_tail_type = C.dna.features["tail_skaven"]
	var/mob/living/carbon/human/skaven = C

	if(!pref_load)
		if(skaven.dna.features["ears"] == "None")
			skaven.dna.features["ears"] = "Skaven"
	if(skaven.dna.features["ears"] == "Skaven")
		var/obj/item/organ/ears/skaven/ears = new
		ears.Insert(skaven, drop_if_replaced = FALSE)

	. = ..()

	//Loads tail preferences.
	if(pref_load)
		C.dna.features["tail_skaven"] = real_tail_type

		var/obj/item/organ/tail/skaven/new_tail = new /obj/item/organ/tail/skaven()

		new_tail.tail_type = C.dna.features["tail_skaven"]
		new_tail.Insert(C, TRUE, FALSE)

	default_color = "#[skaven.dna.features["skavencolor"]]"

/datum/species/skaven/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/tail = pick(GLOB.tails_list_skaven)
	human_mob.dna.features["tail_skaven"] = tail
	mutant_bodyparts["tail_skaven"] = tail
	human_mob.update_body()

//Skaven mob define
/mob/living/carbon/human/species/skaven
	race = /datum/species/skaven

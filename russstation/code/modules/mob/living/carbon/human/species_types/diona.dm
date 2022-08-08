/datum/species/diona
	// An amalgamation of a number of diona nymphs becomes a gestalt that appears similar to other bipedal organics
	name = "\improper Diona"
	plural_form = "Dionae"
	id = SPECIES_DIONA
	sexes = FALSE
	species_traits = list(NOBLOOD, NOEYESPRITES, NO_UNDERWEAR)
	inherent_traits = list(
		TRAIT_NOBREATH,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTLOWPRESSURE,
		// TRAIT_PLANT_SAFE, // honk -- maybe add this? Podpeople have it
	)
	external_organs = list(
		/obj/item/organ/external/diona_hair = "None",
	)
	inherent_biotypes = MOB_ORGANIC | MOB_PLANT // are we a human? If so add `| MOB_HUMANOID`
	inherent_factions = list("plants", "vines")
	damage_overlay_type = "" // dionas don't have blood
	burnmod = 1.5 // take more damage from lasers
	heatmod = 2 // take more damage from fire
	speedmod = 5 // very slow
	meat = /obj/item/food/meat/slab/human/mutant/plant
	// PodPeople bleed water, we don't
	// exotic_blood = /datum/reagent/water
	disliked_food = MEAT | DAIRY
	liked_food = VEGETABLES | FRUIT | GRAIN
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | ERT_SPAWN

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/diona,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/diona,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/diona,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/diona,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/diona,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/diona,
	)

/datum/species/diona/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_diona_name()
	var/randname = diona_name()
	if(lastname)
		randname += " [lastname]"
	return randname

// Similar to podpeople.dm
/datum/species/diona/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	if(H.stat == DEAD)
		return

	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = min(1, T.get_lumcount()) - 0.5
		// Maybe set to `5 *` like podpeople?
		H.adjust_nutrition(10 * light_amount * delta_time)
		if(H.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
			H.set_nutrition(NUTRITION_LEVEL_ALMOST_FULL)
		if(light_amount > 0.2) //if there's enough light, heal
			// OLD HEAL CODE
			// H.heal_overall_damage(2,1, 0, BODYTYPE_ORGANIC)
			// New Code | Might need to tweak numbers to match podpeople `0.5 * delta_time, 0.5 * delta_time`
			H.heal_overall_damage(2 * delta_time, 1 * delta_time, 0, BODYTYPE_ORGANIC)
			H.adjustToxLoss(-0.5 * delta_time)
			// I assume we don't need this as we have `TRAIT_NOBREATH`
			// H.adjustOxyLoss(-0.5 * delta_time)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		// Possibly reduce to `1 *` similar to podpeople?
		H.take_overall_damage(2 * delta_time, 0)
	..()

/datum/species/diona/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	if(chem.type == /datum/reagent/toxin/plantbgone)
		H.adjustToxLoss(3 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE

/datum/species/diona/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/hairstyle = pick(GLOB.diona_hair_list)
	human_mob.dna.features["diona_hair"] = hairstyle
	mutant_bodyparts["diona_hair"] = hairstyle
	human_mob.update_body()

/datum/species/diona/get_species_description()
	return "An amalgamation of a number of diona nymphs \
	becomes a gestalt that appears similar to other bipedal organics."

/datum/species/diona/get_species_lore()
	return list(
		"The Dionae are a species of plant-like beings, \
	composed of many smaller Nymphs. Their world of \
	origin is unknown.",
	)

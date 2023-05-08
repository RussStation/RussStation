/// A screenshot test for every humanoid species with a handful of jobs.
/datum/unit_test/screenshot_humanoids

/datum/unit_test/screenshot_humanoids/Run()
	// honk start -- ensure no randomization between generation of screenshots for our species
	// Skaven
	var/mob/living/carbon/human/skaven = allocate(/mob/living/carbon/human/dummy/consistent)
	skaven.dna.features["skaven_color"] = "#17241c"
	skaven.dna.features["mcolor"] = "#17241c"
	skaven.dna.features["snout"] = "Round"
	skaven.dna.features["horns"] = "None"
	skaven.set_species(/datum/species/skaven)
	skaven.dna.species.pre_equip_species_outfit(/datum/outfit/job/cargo_tech, skaven, visuals_only = TRUE)
	skaven.equipOutfit(/datum/outfit/job/cargo_tech, visualsOnly = TRUE)
	test_screenshot("[/datum/species/skaven]", get_flat_icon_for_all_directions(skaven))
	// Dwarf
	var/mob/living/carbon/human/dwarf = allocate(/mob/living/carbon/human/dummy/consistent)
	dwarf.set_species(/datum/species/dwarf)
	dwarf.facial_hairstyle = "Beard (Dwarf)"
	dwarf.update_hair()
	dwarf.equipOutfit(/datum/outfit/dorf, visualsOnly = TRUE)
	test_screenshot("[/datum/species/dwarf]", get_flat_icon_for_all_directions(dwarf))
	// honk end
	// Test lizards as their own thing so we can get more coverage on their features
	var/mob/living/carbon/human/lizard = allocate(/mob/living/carbon/human/dummy/consistent)
	lizard.dna.features["mcolor"] = "#099"
	lizard.dna.features["tail_lizard"] = "Light Tiger"
	lizard.dna.features["snout"] = "Sharp + Light"
	lizard.dna.features["horns"] = "Simple"
	lizard.dna.features["frills"] = "Aquatic"
	lizard.dna.features["legs"] = "Normal Legs"
	lizard.set_species(/datum/species/lizard)
	lizard.equipOutfit(/datum/outfit/job/engineer)
	test_screenshot("[/datum/species/lizard]", get_flat_icon_for_all_directions(lizard))

	// let me have this
	var/mob/living/carbon/human/moth = allocate(/mob/living/carbon/human/dummy/consistent)
	moth.dna.features["moth_antennae"] = "Firewatch"
	moth.dna.features["moth_markings"] = "None"
	moth.dna.features["moth_wings"] = "Firewatch"
	moth.set_species(/datum/species/moth)
	moth.equipOutfit(/datum/outfit/job/cmo, visualsOnly = TRUE)
	test_screenshot("[/datum/species/moth]", get_flat_icon_for_all_directions(moth))

	// The rest of the species
	for (var/datum/species/species_type as anything in subtypesof(/datum/species) - /datum/species/moth - /datum/species/lizard - /datum/species/skaven - /datum/species/dwarf - /datum/species/dwarf/lavaland)
		test_screenshot("[species_type]", get_flat_icon_for_all_directions(make_dummy(species_type, /datum/outfit/job/assistant/consistent)))

/datum/unit_test/screenshot_humanoids/proc/make_dummy(species, job_outfit)
	var/mob/living/carbon/human/dummy/consistent/dummy = allocate(/mob/living/carbon/human/dummy/consistent)
	dummy.set_species(species)
	dummy.equipOutfit(job_outfit, visualsOnly = TRUE)
	return dummy

/datum/species/abductor
	name = "Abductor"
	id = SPECIES_ABDUCTOR
	say_mod = "gibbers"
	sexes = FALSE
	species_traits = list(NOBLOOD,NOEYESPRITES)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_VIRUSIMMUNE,
		TRAIT_CHUNKYFINGERS,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
	)
	mutanttongue = /obj/item/organ/tongue/abductor
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	ass_image = 'icons/ass/assgrey.png'

/datum/species/abductor/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.add_hud_to(C)

	C.set_safe_hunger_level()

/datum/species/abductor/on_species_loss(mob/living/carbon/C)
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.remove_hud_from(C)

/datum/species/abductor/get_species_description()
	return "Alien beings sent here to probe the station's crew. \
			These abductors quit their job and started working for \
			Nanotrasen for unknown reasons."

/datum/species/abductor/get_species_lore()
	return list(
		"Obsessed with probing other lifeforms, very little is known about their background as they cannot speak verbally to crewmembers of other species.",
	)

/datum/species/abductor/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "gun",
			SPECIES_PERK_NAME = "Chunky fingers",
			SPECIES_PERK_DESC = "Abductors are unable to use normal (non-abductor) guns"
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "headset",
			SPECIES_PERK_NAME = "Abductor communication",
			SPECIES_PERK_DESC = "Abductors cannot speak normally, \
				however when they do speak all other abductors \
				can hear them regardless of radio status.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bacteria",
			SPECIES_PERK_NAME = "Virus immune",
			SPECIES_PERK_DESC = "Abductors are immune to all forms of disease"
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "utensils",
			SPECIES_PERK_NAME = "Alien stomach",
			SPECIES_PERK_DESC = "Abductors do not need to eat"
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Breathless",
			SPECIES_PERK_DESC = "Abductors do not need to breathe"
		),
	)

	return to_add

/datum/species/abductor
	name = "Abductor"
	id = SPECIES_ABDUCTOR
	sexes = FALSE
	species_traits = list(
		NOEYESPRITES,
		NO_UNDERWEAR,
	)
	inherent_traits = list(
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBLOOD,
	)
	mutanttongue = /obj/item/organ/internal/tongue/abductor
	mutantstomach = null
	mutantheart = null
	mutantlungs = null
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	ass_image = 'icons/ass/assgrey.png'

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/abductor,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/abductor,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/abductor,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/abductor,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/abductor,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/abductor,
	)

/datum/species/abductor/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.show_to(C)

	C.set_safe_hunger_level()

/datum/species/abductor/on_species_loss(mob/living/carbon/C)
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.hide_from(C)

// honk start -- missing in upstream but wasn't marked with a honk
/datum/species/abductor/get_species_description()
	return "These scientifically minded Abductors come \
	from an undiscovered system, where discovery \
	and innovation is the driver of society."

/datum/species/abductor/get_species_lore()
	return list(
		"Not much is known about the enigmatic Abductors; \
		those who deign to work with other groups are often \
		tight lipped about their home system, and no explorer has stumbled upon it yet.",
		"What little is known indicates that their society is driven \
		by the pursuit of knowledge, an endeavor which has taken the \
		Abductors technology several leagues beyond that of the other groups \
		traveling the stars. It is also an endeavor which has led several \
		groups of Abductors to go on �scientific expeditions� where the goal \
		is to experiment on whatever unfortunate organism crosses their path. \
		Why other Abductors seem inclined to work with said organisms remains to be seen�"
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
// honk end

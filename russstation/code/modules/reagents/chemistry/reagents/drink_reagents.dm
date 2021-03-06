//Start reason: fuck you x100, used in bung apples

// White Juice
/datum/reagent/consumable/whitejuice
	name = "White Juice"
	description = "Pucker up buttercup."
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_description = "white juice"
	glass_icon_state = "glass_white"
	glass_name = "glass of white juice"
	glass_desc = "A bright white drink. Smells like heart attacks."

// Bung Water
/datum/reagent/consumable/bungwater
	name = "Bung Water"
	description = "Oh god, it smells so bad."
	color = "#671096" //Dark purple (RGB: 103, 16, 150)
	taste_description = "regret..."
	glass_icon_state = "glass_brown"
	glass_name = "glass of bung water"
	glass_desc = "Why does this even exist?"
	reagent_state = LIQUID

/datum/reagent/consumable/bungwater/on_mob_life(mob/living/M)
	if(prob(70))
		M.fakevomit(1)
		M.fakevomit(0)
	return ..()


/datum/reagent/consumable/superlaughter/traitor_pen
	name = "Super Laughter"
	description = "Funny until you're the one laughing."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#FF4DD2"
	taste_description = "laughter"

/datum/reagent/consumable/superlaughter/traitor_pen/on_mob_life(mob/living/carbon/M)
	if(prob(30))
		M.emote("laugh")
	..()

//end
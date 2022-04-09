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

/datum/reagent/consumable/bungwater/on_mob_life(mob/living/M, delta_time, times_fired)
	if(DT_PROB(70, delta_time))
		M.fakevomit(1)
		M.fakevomit(0)
	..()


/datum/reagent/consumable/superlaughter/traitor_pen
	// Name changed to avoid confusion and fix unit test
	name = "Hysteria"
	// Description updated from underlying `superlaughter`
	description = "Funny until you're the one laughing."

/datum/reagent/consumable/superlaughter/traitor_pen/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(DT_PROB(30, delta_time))
		M.emote("laugh")
	..()

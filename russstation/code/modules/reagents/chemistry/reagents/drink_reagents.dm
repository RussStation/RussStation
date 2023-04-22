//Start reason: fuck you x100, used in bung apples

// White Juice
/datum/reagent/consumable/whitejuice
	name = "White Juice"
	description = "Pucker up buttercup."
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_description = "white juice"
	//glass_icon_state = "glass_white" [REMOVE AFTER BUILD]

/datum/glass_style/drinking_glass_russ/whitejuice
	required_drink_type = /datum/reagent/consumable/whitejuice
	name = "glass of white juice"
	desc = "A bright white drink. Smells like heart attacks."

// Bung Water
/datum/reagent/consumable/bungwater
	name = "Bung Water"
	description = "Oh god, it smells so bad."
	color = "#671096" //Dark purple (RGB: 103, 16, 150)
	taste_description = "regret..."
	reagent_state = LIQUID
	//glass_icon_state = "glass_brown" [REMOVE AFTER BUILD]

/datum/glass_style/drinking_glass_russ/bungwater
	required_drink_type = /datum/reagent/consumable/bungwater
	name = "glass of bung water"
	desc = "Why does this even exist?"

/datum/reagent/consumable/bungwater/on_mob_life(mob/living/M, seconds_per_tick, times_fired)
	if(SPT_PROB(70, seconds_per_tick))
		M.fakevomit(1)
		M.fakevomit(0)
	..()

/datum/reagent/consumable/superlaughter/traitor_pen
	// Name changed to avoid confusion and fix unit test
	name = "Hysteria"
	// Description updated from underlying `superlaughter`
	description = "Funny until you're the one laughing."

/datum/reagent/consumable/superlaughter/traitor_pen/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	if(SPT_PROB(30, seconds_per_tick))
		M.emote("laugh")
	..()

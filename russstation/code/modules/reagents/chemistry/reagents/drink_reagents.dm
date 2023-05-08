//Start reason: fuck you x100, used in bung apples

// White Juice
/datum/reagent/consumable/whitejuice
	name = "White Juice"
	description = "Pucker up buttercup."
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_description = "white juice"

/datum/glass_style/drinking_glass/whitejuice
	required_drink_type = /datum/reagent/consumable/whitejuice
	name = "glass of white juice"
	desc = "A bright white drink. Smells like heart attacks."
	icon_state = "glass_white"

// Bung Water
/datum/reagent/consumable/bungwater
	name = "Bung Water"
	description = "Oh god, it smells so bad."
	color = "#671096" //Dark purple (RGB: 103, 16, 150)
	taste_description = "regret..."
	reagent_state = LIQUID

/datum/glass_style/drinking_glass/bungwater
	required_drink_type = /datum/reagent/consumable/bungwater
	name = "glass of bung water"
	desc = "Why does this even exist?"
	icon_state = "glass_brown"

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

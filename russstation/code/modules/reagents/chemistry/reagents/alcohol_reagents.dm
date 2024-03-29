////////////// I don't know who made this header before I refactored alcohols but I'm going to fucking strangle them because it was so ugly, holy Christ
// ALCOHOLS //
//////////////


/*
Boozepwr Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occassional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - heavy toxin damage, passing out
91-100: Dangerously toxic - swift death
*/

/datum/reagent/consumable/ethanol/badtouch
	name = "Bad Touch"
	description = "A sour and vintage drink. Some say the inventor gets slapped a lot."
	color = "#1FB563" // rgb: 31, 181, 99
	boozepwr = 35
	taste_description = "a slap to the face"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass_russ/badtouch
	required_drink_type = /datum/reagent/consumable/ethanol/badtouch
	name = "glass of Bad Touch"
	desc = "We're nothing but mammals after all."
	icon_state = "bad_touch"

/datum/reagent/consumable/ethanol/cobaltvelvet
	name = "Cobalt Velvet"
	description = "A classy but burning drink that warms the drinker."
	color = "#ACFFD8" // rgb: 172, 255, 216
	boozepwr = 50
	taste_description = "hot blankets"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass_russ/cobaltvelvet
	required_drink_type = /datum/reagent/consumable/ethanol/cobaltvelvet
	name = "glass of Cobalt Velvet"
	desc = "It's like champagne served on a cup that had a bit of cola left."
	icon_state = "cobalt_velvet"

/datum/reagent/consumable/ethanol/cobaltvelvet/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL + 25) //310.15 is the normal bodytemp.
	return ..()

/datum/reagent/consumable/ethanol/marsblast
	name = "Marsblast"
	description = "A spicy and manly drink in honor of the first colonists on Mars"
	color = "#F68F37" // rgb: 246, 143, 55
	boozepwr = 70
	taste_description = "hot red sand"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass_russ/marsblast
	required_drink_type = /datum/reagent/consumable/ethanol/marsblast
	name = "glass of Marsblast"
	desc = "One of these is enough to leave your face as red as the planet."
	icon_state = "marsblast"

/datum/reagent/consumable/ethanol/mercuryblast
	name = "Mercuryblast"
	description = "A sour burningly cold drink that's sure to chill the drinker."
	color = "#1D94D5" // rgb: 29, 148, 213
	boozepwr = 40
	taste_description = "chills down your spine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass_russ/mercuryblast
	required_drink_type = /datum/reagent/consumable/ethanol/mercuryblast
	name = "glass of Mercuryblast"
	desc = "No thermometer was harmed in the creation of this drink"
	icon_state = "mercuryblast"

/datum/reagent/consumable/ethanol/mercuryblast/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-30 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C) //310.15 is the normal bodytemp.
	return ..()

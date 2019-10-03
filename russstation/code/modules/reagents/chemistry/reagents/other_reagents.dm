/datum/reagent/russ/therapy
	name = "Therapy"
	description = "Euphoria in a bottle."
	color = "#d0a6a4" //RGB: 208, 166, 164
	taste_description = "personal progress"
	can_synth = FALSE

/datum/reagent/diamond 
	name = "Diamond"
	description = "Capital One, what's in your wallet?"
	reagent_state = LIQUID
	color = "#00c4d6" // RGB: 0, 196, 214
	taste_description = "your wallet dying inside"
	produce_type = /obj/item/stack/sheet/mineral/diamond
	attack_force = 15
	pick_speed = 0.4
	penetration_value = 25
	sharp_result = TRUE

/datum/reagent/adamantine 
	name = "Adamantine"
	description = "STRIKE THE EARTH"
	reagent_state = LIQUID
	color = "#00fff7" //RGB: 0, 255, 247
	taste_description = "demons"
	produce_type = /obj/item/stack/sheet/mineral/adamantine
	attack_force = 20
	pick_speed = 0.1
	penetration_value = 40
	sharp_result = TRUE

/datum/reagent/dorf_plasma 
	name = "Plasma"
	description = "Dwarven tameable material"
	reagent_state = LIQUID
	color = "#9d03fc" //RGB 157, 3, 252
	taste_description = "plasma"
	produce_type = /obj/item/stack/sheet/mineral/plasma
	attack_force = 15
	pick_speed = 0.6
	sharp_result = TRUE

/datum/reagent/dorf_bananium 
	name = "Bananium"
	description = "Handle with care. Or don't."
	reagent_state = LIQUID
	color = "#ffea00" //RGB 255, 234, 0
	taste_description = "bananium"
	produce_type = /obj/item/stack/sheet/mineral/bananium
	attack_force = 15
	pick_speed = 0.5

/datum/reagent/dorf_titanium 
	name = "Titanium"
	description = "Bootleg adamantine."
	reagent_state = LIQUID
	color = "#bababa" //rgb 186, 186, 186
	taste_description = "titanium"
	produce_type = /obj/item/stack/sheet/mineral/titanium
	attack_force = 20
	pick_speed = 0.2
	sharp_result = TRUE

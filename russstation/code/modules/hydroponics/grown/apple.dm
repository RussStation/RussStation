//Start reason: trogs

// Bung Apple
/obj/item/seeds/russ/bung
	name = "pack of bung apple seeds"
	desc = "These seeds grow into bung apple trees. They have an awful smell to them."
	icon_state = "seed-bungapple"
	species = "bungapple"
	icon_grow = "apple-grow"
	icon_harvest = "bungapple-harvest"
	icon_dead = "apple-dead"
	plantname = "Bung Apple Tree"
	product = /obj/item/food/grown/russ/bung
	mutatelist = list()
	genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/smoke)
	reagents_add = list(/datum/reagent/consumable/bungwater = 0.4)
	rarity = 40

/obj/item/food/grown/russ/bung
	seed = /obj/item/seeds/russ/bung
	name = "bung apple"
	desc = "Smells horrendous. Give it to the clown."
	icon_state = "bungapple"
	filling_color = "#C300FF"
	juice_results = list(/datum/reagent/consumable/bungwater = 0)
	wine_power = 0.4;
	wine_flavor = "miasma"

//end

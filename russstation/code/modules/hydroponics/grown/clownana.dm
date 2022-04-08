// clownana - invisible sprites are totally a feature!
/obj/item/seeds/banana/clownana
	name = "pack of clownana seeds"
	desc = "They're seeds that grow into clownana trees. When grown, keep away from clown."
	icon_state = "seed-clownana"
	species = "clownana"
	plantname = "Clownana Tree"
	product = /obj/item/food/grown/banana/clownana
	growthstages = 4
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/laughter = 0.1, /datum/reagent/consumable/nutriment = 0.02)
	rarity = 15
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/plant_confetti, /datum/plant_gene/trait/repeated_harvest)
	graft_gene = /datum/plant_gene/trait/plant_confetti

/obj/item/food/grown/banana/clownana
	seed = /obj/item/seeds/banana/clownana
	name = "clownana"
	desc = "It's an excellent prop for a clown."
	icon_state = "clownana"
	trash_type = /obj/item/grown/bananapeel/clownanapeel
	distill_reagent = /datum/reagent/consumable/laughter

/obj/item/grown/bananapeel/clownanapeel
	seed = /obj/item/seeds/banana/clownana
	name = "clownana peel"
	desc = "A clownana peel."
	icon_state = "clownana_peel"
	inhand_icon_state = "clownana_peel"

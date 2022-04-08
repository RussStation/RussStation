// banfetti - invisible sprites are totally a feature!
/obj/item/seeds/banana/banfetti
	name = "pack of banfetti seeds"
	desc = "They're seeds that grow into banfetti trees. When grown, keep away from clown."
	icon_state = "seed-banfetti"
	species = "banfetti"
	plantname = "Banfetti Tree"
	icon = 'russstation/icons/obj/hydroponics/seeds.dmi'
	growing_icon = 'russstation/icons/obj/hydroponics/growing_fruits.dmi'
	product = /obj/item/food/grown/banana/banfetti
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/laughter = 0.1, /datum/reagent/consumable/nutriment = 0.02)
	rarity = 15
	icon_grow = "banana-grow"
	icon_harvest = "banfetti-harvest"
	icon_dead = "banana-dead"
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/plant_confetti, /datum/plant_gene/trait/repeated_harvest)
	graft_gene = /datum/plant_gene/trait/plant_confetti

/obj/item/food/grown/banana/banfetti
	seed = /obj/item/seeds/banana/banfetti
	name = "banfetti"
	desc = "It's an excellent prop for a clown."
	icon = 'russstation/icons/obj/hydroponics/harvest.dmi'
	icon_state = "banfetti"
	trash_type = /obj/item/grown/bananapeel/banfettipeel
	distill_reagent = /datum/reagent/consumable/laughter

/obj/item/grown/bananapeel/banfettipeel
	seed = /obj/item/seeds/banana/banfetti
	name = "banfetti peel"
	desc = "A banfetti peel."
	icon = 'russstation/icons/obj/hydroponics/harvest.dmi'
	icon_state = "banfetti_peel"
	inhand_icon_state = "banfetti_peel"

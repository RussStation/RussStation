/obj/item/grenade/chem_grenade/spacelube
	name = "lube grenade"
	desc = "Used for evading shitcurity."
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/spacelube/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/lube, 150)
	B1.reagents.add_reagent(/datum/reagent/water, 150)
	B2.reagents.add_reagent(/datum/reagent/fluorosurfactant, 150)

	beakers += B1
	beakers += B2
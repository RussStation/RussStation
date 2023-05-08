/datum/crafting_recipe/alcohol_shotgun
	name = "SHOTgun"
	result = /obj/item/gun/chem/alcohol_gun
	reqs = list(/obj/item/assembly/igniter = 1,
				/obj/item/gun/ballistic/shotgun = 1,
				/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass = 1,
				/obj/item/reagent_containers/syringe = 1)
	parts = list(/obj/item/gun/ballistic/shotgun = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_RANGED


/datum/uplink_item/role_restricted/lube_clusterbang
	name = "Lubestorm Clusterbang"
	desc = "A clusterbang grenade with unmatched lubrication potential."
	item = /obj/item/grenade/clusterbuster/lube
	cost = 5
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/box_of_Signs
	name = "Box of Wetmore Slippery Signs"
	desc = "A box filled with 4 Waffle Co. modified slippery wet floor signs. When toggled, they will animate and attack anyone who runs past them. \
		Can be used to set up dangerous slipping traps, distractions, or simply to enforce proper safety in the hallways."
	item = /obj/item/storage/box/syndie_kit/box_of_Signs
	cost = 7
	limited_stock = 2
	restricted_roles = list("Janitor")

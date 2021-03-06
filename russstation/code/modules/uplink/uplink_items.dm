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

/datum/uplink_item/role_restricted/laughter_pen
	name = "Deadly Laughter Pen"
	desc = "A syringe disguised as a functional pen, filled with a potent mix of drugs, including a \
			chemical that causes uncontrollable laughter and a toxin that deprives the body of oxygen. \
			The pen holds one dose of the mixture, and can be refilled with any chemicals. Note that before the target \
			falls asleep, they will be able to move and act."
	item =  /obj/item/pen/laughter
	cost = 6
	restricted_roles = list("Clown")
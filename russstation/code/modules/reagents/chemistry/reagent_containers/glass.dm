/obj/item/reagent_containers/glass/mold
	name = "mold"
	desc = "A clay mold."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "mold1"
	volume = 25
	amount_per_transfer_from_this = 25
	reagent_flags = OPENCONTAINER
	var/obj/produce_type = null

//Broadsword mold
/obj/item/reagent_containers/glass/mold/sword
	name = "sword mold"
	desc = "A clay mold of a sword blade."
	icon_state = "mold_blade"
	produce_type = /obj/item/mold_result/blade

//Pickaxe mold
/obj/item/reagent_containers/glass/mold/pickaxe
	name = "pickaxe mold"
	desc = "A clay mold of a pickaxe head."
	icon_state = "mold_pickaxe"
	produce_type = /obj/item/mold_result/pickaxe_head

//Shovel mold
/obj/item/reagent_containers/glass/mold/shovel 
	name = "shovel mold"
	desc = "A clay mold of a shovel head."
	icon_state = "mold_shovel"
	produce_type = /obj/item/mold_result/shovel_head

//Knife mold
/obj/item/reagent_containers/glass/mold/knife 
	name = "knife mold"
	desc = "A clay mold of a knife head."
	icon_state = "mold_knife"
	produce_type = /obj/item/mold_result/knife_head

//War hammer mold
/obj/item/reagent_containers/glass/mold/war_hammer 
	name = "war hammer mold"
	desc = "A clay mold of a war hammer head."
	icon_state = "mold_war_hammer"
	produce_type = /obj/item/mold_result/war_hammer_head

//Bar / Sheet metal mold
/obj/item/reagent_containers/glass/mold/bar 
	name = "bar mold"
	desc = "A clay mold of a bar."

/obj/item/reagent_containers/glass/mold/helmet
	name = "helmet mold"
	desc = "A clay mold of a helmet."
	icon_state = "mold_shovel"
	produce_type = /obj/item/mold_result/helmet_plating

/obj/item/reagent_containers/glass/mold/armour 
	name = "armour mold"
	desc = "A clay mold of armour plating."
	icon_state = "mold_shovel"
	produce_type = /obj/item/mold_result/armour_plating

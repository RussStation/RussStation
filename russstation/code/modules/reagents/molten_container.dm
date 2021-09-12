/obj/item/reagent_containers/molten_container
	name = "molten container"
	desc = "A container for holding molten metal."
	amount_per_transfer_from_this = 25
	volume = 25
	fill_icon_thresholds = list(25)
	reagent_flags = OPENCONTAINER
	spillable = TRUE

/obj/item/reagent_containers/molten_container/Initialize()
	. = ..()
	base_icon_state = icon_state

// reagent_containers hardcodes an icon file; copypaste so we can point at our own file. not necessarily the best long term
/obj/item/reagent_containers/molten_container/update_overlays()
	. = ..()
	if(!fill_icon_thresholds)
		return
	if(!reagents.total_volume)
		return

	var/fill_name = fill_icon_state? fill_icon_state : icon_state
	var/mutable_appearance/filling = mutable_appearance(icon, "[fill_name][fill_icon_thresholds[1]]")

	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/i in 1 to fill_icon_thresholds.len)
		var/threshold = fill_icon_thresholds[i]
		var/threshold_end = (i == fill_icon_thresholds.len)? INFINITY : fill_icon_thresholds[i+1]
		if(threshold <= percent && percent < threshold_end)
			filling.icon_state = "[fill_name][fill_icon_thresholds[i]]"

	. += filling

/obj/item/reagent_containers/molten_container/update_icon_state()
	. = ..()
	if(src.reagents.total_volume > 0)
		src.icon_state = (src.base_icon_state + "25")
	else
		src.icon_state = src.base_icon_state


/obj/item/reagent_containers/molten_container/crucible
	name = "iron crucible"
	desc = "A crucible used to hold smelted ore."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "iron_crucible"
	lefthand_file = 'russstation/icons/mob/inhands/item_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/item_righthand.dmi'
	inhand_icon_state = "crucible"

// Smelting molds - make from clay, pour in molten ore, whack into shape
/obj/item/reagent_containers/molten_container/smelt_mold
	name = "smelting mold"
	desc = "A clay mold for casting metal."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "mold_bar"
	lefthand_file = 'russstation/icons/mob/inhands/item_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/item_righthand.dmi'
	inhand_icon_state = "mold"
	var/obj/produce_type = null

/obj/item/reagent_containers/molten_container/smelt_mold/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/reagent_containers/molten_container/crucible))
		// pour if there's enough in the crucible - easier to handle this as all-or-nothing
		var/obj/item/reagent_containers/molten_container/crucible/crucible = W
		if(reagents.total_volume >= volume)
			to_chat(user, span_notice("[src] is already filled."))
		else if(crucible.reagents.total_volume < volume)
			to_chat(user, span_notice("[crucible] needs [volume] units of molten metal all at once to fill [src]."))
		else if(do_after(user, 10, src))
			crucible.reagents.trans_to(src, volume)
			user.visible_message(
				span_notice("[user] pours the contents of [crucible] into \the [src]."),
				span_notice("You pour the contents of [crucible] into \the [src]."),
				span_hear("You hear a sizzling sound."),
			)
			src.update_appearance()
			crucible.update_appearance()
	else if(istype(W, /obj/item/melee/smith_hammer))
		// mold placed on an anvil becomes "part of" the anvil, so this code only occurs if the mold is elsewhere
		to_chat(user, span_notice("[src] needs to be placed on an anvil to smith it."))
	else
		..()

/obj/item/reagent_containers/molten_container/smelt_mold/sword
	name = "sword mold"
	desc = "A clay mold of a sword blade."
	icon_state = "mold_blade"
	produce_type = /obj/item/mold_result/blade

/obj/item/reagent_containers/molten_container/smelt_mold/pickaxe
	name = "pickaxe mold"
	desc = "A clay mold of a pickaxe head."
	icon_state = "mold_pickaxe"
	produce_type = /obj/item/mold_result/pickaxe_head

/obj/item/reagent_containers/molten_container/smelt_mold/shovel
	name = "shovel mold"
	desc = "A clay mold of a shovel head."
	icon_state = "mold_shovel"
	produce_type = /obj/item/mold_result/shovel_head

/obj/item/reagent_containers/molten_container/smelt_mold/knife
	name = "knife mold"
	desc = "A clay mold of a knife head."
	icon_state = "mold_knife"
	produce_type = /obj/item/mold_result/knife_head

/obj/item/reagent_containers/molten_container/smelt_mold/war_hammer
	name = "war hammer mold"
	desc = "A clay mold of a war hammer head."
	icon_state = "mold_war_hammer"
	produce_type = /obj/item/mold_result/war_hammer_head

//Bar / Sheet metal mold
/obj/item/reagent_containers/molten_container/smelt_mold/bar
	name = "bar mold"
	desc = "A clay mold of a bar."
	icon_state = "mold_bar"
//	produce_type = handled when smithing

/obj/item/reagent_containers/molten_container/smelt_mold/helmet
	name = "helmet mold"
	desc = "A clay mold of a helmet."
	icon_state = "mold_shovel"
	produce_type = /obj/item/mold_result/helmet_plating

// reused shovel mold
/obj/item/reagent_containers/molten_container/smelt_mold/armour
	name = "armour mold"
	desc = "A clay mold of armour plating."
	icon_state = "mold_shovel"
	produce_type = /obj/item/mold_result/armour_plating

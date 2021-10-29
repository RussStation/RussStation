/obj/machinery/smelter
	name = "smelter"
	desc = "A furnace to smelt ores."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "forge"
	base_icon_state = "forge"
	density = TRUE
	anchored = FALSE // why?
	var/obj/item/reagent_containers/molten_container/crucible/crucible = null
	var/fuel = 0
	var/volume = 20
	/// stack/ore includes glass and slag, which we don't want?
	var/list/allowed_ores = list(
		/obj/item/stack/ore/iron,
		/obj/item/stack/ore/adamantine,
		/obj/item/stack/ore/silver,
		/obj/item/stack/ore/gold,
		/obj/item/stack/ore/uranium,
		/obj/item/stack/ore/diamond,
		/obj/item/stack/ore/plasma,
		/obj/item/stack/ore/bananium,
		/obj/item/stack/ore/titanium,
	)
	var/glow_brightness = 4
	var/glow_power = 0.6
	var/glow_color = "#FF5500"

/obj/machinery/smelter/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/grown/log) || istype(W, /obj/item/stack/sheet/mineral/wood))
		if(!(fuel >= volume)) //add fuel
			user.visible_message(
				span_notice("[user] adds \the [W.name] to \the [src.name]."),
				span_notice("You add \the [W.name] to the fuel supply of \the [src.name]."),
				span_hear("You hear the roar of a fire."),
			)
			fuel += 5
			if(fuel > volume) //adjust fuel if it goes over the max
				fuel = volume
			update_desc()
			update_icon()
			user.dropItemToGround(W)
			qdel(W)
		else
			to_chat(user, "No more fuel will fit in \the [src.name].")

	else if(istype(W, /obj/item/stack/sheet/wethide))//you can dry wet hide with the smelter
		if(fuel == 0)
			to_chat(user, "\The [src.name] needs fuel before it can dry hide.")
		else
			var/obj/item/stack/sheet/current_hide = W

			while(fuel > 0 && current_hide.amount > 0 && do_after(user, 5, target = src)) //doesnt use up any fuel but requires there to be fuel
				user.visible_message("[user] puts \the [W] next to \the [src.name] and it dries.", "You put \the [W.name] next to \the [src.name] and it dries.")
				new /obj/item/stack/sheet/leather(user.loc)
				current_hide.amount--

			if(current_hide.amount == 0)
				qdel(W)

	else if(istype(W, /obj/item/reagent_containers/molten_container/crucible))
		if(!crucible) //load in bucket
			crucible = W
			user.visible_message(
				span_notice("[user] loads \the [src.name] with \a [crucible]"),
				span_notice("You load \the [src.name] with \a [crucible]."),
			)
			user.dropItemToGround(W)
			W.loc = src
			update_desc()
		else
			to_chat(user, span_notice("\The [src.name] already has \a [crucible]."))

	else if(istype(W, /obj/item/stack/ore))
		if(!crucible || fuel == 0) //need ore and bucket loaded
			to_chat(user, "\The [src.name] needs fuel and a crucible before it can smelt ore.")
		else if(!is_type_in_list(W, allowed_ores))
			to_chat(user, "[src.name] cannot smelt \the [W.name].")
		else
			if(crucible.reagents.total_volume >= crucible.volume)
				to_chat(user, "\The [crucible] is full.")
			else
				var/obj/item/stack/ore/current_ore = W
				var/smelting_result = current_ore.reagent_id
				// keep adding ore, small do_after so user can stop putting it all in
				while (smelting_result && current_ore.amount > 0 && fuel > 0 && crucible.reagents.total_volume < crucible.volume && do_after(user, 5, target = src))
					user.visible_message(
						span_notice("[user] puts \the [W] in \the [src.name] and it melts."),
						span_notice("You put \the [W.name] in \the [src.name] and it melts."),
						span_notice("You hear a sizzling sound.")
					)
					crucible.reagents.add_reagent(smelting_result, (5))
					crucible.reagents.chem_temp = 1000
					crucible.reagents.handle_reactions()
					current_ore.amount--
					fuel--
					update_desc()
					update_icon()
					new /obj/item/stack/ore/stone(src.loc)

				if(current_ore.amount == 0)
					qdel(W)

/obj/machinery/smelter/attack_hand(mob/user)
	if(crucible)
		crucible.forceMove(drop_location())
		user.visible_message(
			span_notice("[user] takes \the [crucible] out of \the [src.name]."),
			span_notice("You take \the [crucible] out of \the [src.name]."),
		)
		if(Adjacent(user) && !issilicon(user))
			user.put_in_hands(crucible)
		crucible.update_appearance()
		crucible = null
		update_desc()
	else
		..()

/obj/machinery/smelter/update_desc()
	. = ..()
	desc = "A furnace to smelt ores. "
	if(crucible)
		desc += "It is loaded with a crucible. "
	if(fuel > 0)
		desc += "It has [fuel] of [volume] possible units of fuel."

/obj/machinery/smelter/update_icon_state()
	. = ..()
	// also change lighting since it's connected to icon state
	if(fuel > 0)
		icon_state = base_icon_state + "_fueled"
		set_light(glow_brightness, glow_power, glow_color)
	else
		icon_state = base_icon_state
		set_light(0)

/obj/machinery/anvil
	name = "anvil"
	desc = "A large metal surface for working metal."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = FALSE // again why?
	// anvil acts like a table only for molds, so they're handled as overlays
	var/obj/item/reagent_containers/molten_container/smelt_mold/current_mold = null
	var/mutable_appearance/my_mold = null
	var/list/workable_metals = list(
		/datum/reagent/diamond,
		/datum/reagent/adamantine,
		/datum/reagent/dorf_plasma,
		/datum/reagent/dorf_bananium,
		/datum/reagent/dorf_titanium,
		/datum/reagent/silver,
		/datum/reagent/gold,
		/datum/reagent/iron,
		/datum/reagent/uranium,
	)

/obj/machinery/anvil/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/reagent_containers/molten_container) && user.combat_mode)
		var/obj/item/reagent_containers/molten_container/container = W
		container.SplashReagents(src) // you idiot
		if(current_mold)
			cut_overlay(my_mold)
			my_mold = mutable_appearance('russstation/icons/obj/blacksmithing.dmi', current_mold.icon_state)
			add_overlay(my_mold)
	else if(istype(W, /obj/item/reagent_containers/molten_container/smelt_mold))
		if(current_mold)
			to_chat(user, "There's already a mold on the anvil.")
		else
			var/obj/item/reagent_containers/molten_container/smelt_mold/M = W
			user.visible_message(
				span_notice("[user] places [M] on \the [src.name]."),
				span_notice("You place [M] on \the [src.name]."),
				span_hear("You hear something being set on a hard surface."),
			)
			user.dropItemToGround(M)
			M.loc = src
			current_mold = M
			my_mold = mutable_appearance('russstation/icons/obj/blacksmithing.dmi', M.icon_state)
			add_overlay(my_mold)
			update_desc()
	else if(istype(W, /obj/item/melee/smith_hammer))
		if(!current_mold)
			..()
		else if(current_mold.reagents.total_volume < current_mold.volume)
			to_chat(user, span_notice("\The [current_mold] needs to be filled with molten metal first."))
		else if(user.combat_mode)
			current_mold.SplashReagents(user) // splash on self for idiocy
		else
			// if(!(current_mold.reagents.get_master_reagent() in workable_metals))
			// 	to_chat(user, span_notice("\The [current_mold] contains too many non-metal materials that prevent smithing."))
			// 	return
			user.visible_message(
				span_notice("[user] breaks the result out of \the [current_mold] and starts to hammer it into shape."),
				span_notice("You break the result out of \the [current_mold] and start to hammer it into shape."),
				span_hear("You hear the hammering of metal."),
			)
			playsound(loc, 'sound/items/gavel.ogg', 50, TRUE, -1)
			if(do_after(user, 80, target = src))
				var/datum/reagent/R = current_mold.reagents.get_master_reagent() // future idea: check all reagents, make alloys?
				if(!istype(current_mold, /obj/item/reagent_containers/molten_container/smelt_mold/bar))
					var/obj/item/mold_result/I = new current_mold.produce_type(get_turf(src))
					I.smelted_material = new R.type()
					I.post_smithing()
				else
					// makes five of whatever sheet of its type
					var/obj/item/stack/I = new R.produce_type(get_turf(src))
					I.amount = 5
				qdel(current_mold)
				cut_overlay(my_mold)
				my_mold = null
				current_mold = null
				update_desc()
	else if(istype(W, /obj/item/reagent_containers/molten_container/crucible))
		// allow pouring onto a mold on the anvil (copied from smelt_mold's code)
		var/obj/item/reagent_containers/molten_container/crucible/crucible = W
		if(!current_mold)
			to_chat(user, span_notice("Use [crucible] to fill a mold first."))
		else if(current_mold.reagents.total_volume >= current_mold.volume)
			to_chat(user, span_notice("[current_mold] is already filled."))
		else if(crucible.reagents.total_volume < current_mold.volume)
			to_chat(user, span_notice("[crucible] needs [current_mold.volume] units of molten metal all at once to fill [current_mold]."))
		else if(do_after(user, 10, target = src))
			crucible.reagents.trans_to(current_mold, current_mold.volume)
			cut_overlay(my_mold)
			my_mold = mutable_appearance('russstation/icons/obj/blacksmithing.dmi', current_mold.icon_state)
			add_overlay(my_mold)
			user.visible_message(
				span_notice("[user] pours the contents of [crucible] into [current_mold]."),
				span_notice("You pour the contents of [crucible] into [current_mold]."),
				span_hear("You hear a sizzling sound."),
			)
	else
		..()

/obj/machinery/anvil/attack_hand(mob/user)
	if(current_mold)
		current_mold.forceMove(drop_location())
		if(Adjacent(user) && !issilicon(user))
			user.put_in_hands(current_mold)
		cut_overlay(my_mold)
		my_mold = null
		current_mold = null
		update_desc()
	else
		..()

/obj/machinery/anvil/update_desc()
	. = ..()
	desc = "A large metal surface for working metal. "
	if(current_mold)
		desc += "There is \a [current_mold] on its top."

// Mold results, ie. shaped metal that still needs a handle attached
/obj/item/mold_result
	name = "molten blob"
	desc = "A hardened blob of ore. You shouldn't be seeing this..."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "blob_base"
	inhand_icon_state = "sheet-metal" // yeah whatever
	w_class = WEIGHT_CLASS_NORMAL
	var/material_type = "unobtanium"
	var/mold_type = "blob"
	var/pickaxe_speed = 0
	var/metel_force = 0
	var/attack_amt = 0
	var/blunt_bonus = FALSE //determinse if the reagent used for the part has a bonus for blunt materials

/obj/item/mold_result/blade
	name = "blade"
	desc = "A blade made of "
	icon_state = "sword_blade"
	mold_type = "offensive"

/obj/item/mold_result/pickaxe_head
	name = "pickaxe head"
	desc = "A pickaxe head made of "
	icon_state = "pickaxe_head"
	mold_type = "digging"

/obj/item/mold_result/shovel_head
	name = "shovel head"
	desc = "A shovel head made of "
	icon_state = "shovel_head"
	mold_type = "digging"

/obj/item/mold_result/knife_head
	name = "knife head"
	desc = "A butchering knife head made of "
	icon_state = "knife_head"
	mold_type = "offensive"

/obj/item/mold_result/war_hammer_head
	name = "warhammer head"
	desc = "A warhammer head made of "
	icon_state = "war_hammer_head"
	mold_type = "offensive"

/obj/item/mold_result/armour_plating
	name = "armour plating"
	desc = "Armour plating made of"
	icon_state = "armour"
	mold_type = "offensive"

/obj/item/mold_result/helmet_plating
	name = "helmet plating"
	desc = "Helmet plating made of"
	icon_state = "helmet"
	mold_type = "offensive"

/obj/item/mold_result/proc/post_smithing()
	name = "[smelted_material.name] [name]"
	material_type = "[smelted_material.name]"
	color = smelted_material.color
	armour_penetration = smelted_material.penetration_value
	attack_amt = smelted_material.attack_force
	force = smelted_material.attack_force * 0.6 //stabbing people with the resulting piece, build the full tool for full force
	desc += "[smelted_material.name]."
	if(smelted_material.sharp_result)
		sharpness = SHARP_EDGED
	if(mold_type == "digging")
		pickaxe_speed = smelted_material.pick_speed
		sharpness = SHARP_POINTY
	if(smelted_material.blunt_damage)
		blunt_bonus = TRUE

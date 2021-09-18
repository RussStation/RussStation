/obj/machinery/portable_atmospherics/canister/compost_bin
	name = "compost bin"
	desc = "A compost bin that decomposes grown food into miasma."
	icon = 'russstation/icons/obj/atmospherics/canisters.dmi'
	icon_state = "compost"
	anchored = FALSE
	volume = 500
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 100, FIRE = 10, ACID = 0)
	max_integrity = 100
	canister_overlay_file = null //no overlay
	gas_type = /datum/gas/miasma
	filled = 0

/obj/machinery/portable_atmospherics/canister/compost_bin/Initialize()
	//Also can contain compost material that is helpful to botanists (so theres an insentive to use them other then the fact that it creates miasma gas)
	create_reagents(300, DRAINABLE)
	. = ..()

	//these are needed here because canisters override icons on init to default values, this fixes it
	icon = 'russstation/icons/obj/atmospherics/canisters.dmi'
	icon_state = "compost"
	update_icon_state()

/obj/machinery/portable_atmospherics/canister/compost_bin/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/food/grown))
		user.visible_message(
			span_notice("[user] puts \the [W.name] into \the [src.name]."),
			span_notice("You add \the [W.name] to \the [src.name]."),
			span_hear("You hear a plop sound."),
		)
		addtimer(CALLBACK(src, .proc/decompose), rand(100, 150))
		qdel(W)
	else if(istype(W, /obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/bag = W
		if(bag.contents.len > 0)
			user.visible_message(
				span_notice("[user] empties their [W.name] into \the [src.name]."),
				span_notice("You empty \the [W.name] into \the [src.name]."),
				span_hear("You hear a plopping sound."),
			)
		for(var/obj/item/food/grown/food_item in bag.contents)
			addtimer(CALLBACK(src, .proc/decompose), rand(100, 150))
			qdel(food_item)

	. = ..()

/obj/machinery/portable_atmospherics/canister/compost_bin/proc/decompose()
	if(QDELETED(src))
		return
	air_contents.gases[/datum/gas/miasma][MOLES] += 10
	reagents.add_reagent(/datum/reagent/saltpetre, 5)
	reagents.add_reagent(/datum/reagent/diethylamine, 2)
	playsound(src, 'sound/effects/bubbles.ogg', 10, TRUE)
	update_icon_state()

/obj/machinery/portable_atmospherics/canister/compost_bin/update_icon_state()
	if(reagents.total_volume == 0)
		icon_state = "compost"
	else if(reagents.total_volume / reagents.maximum_volume > 0.40 && reagents.total_volume / reagents.maximum_volume < 0.80)
		icon_state = "compost-half"
	else if(reagents.total_volume / reagents.maximum_volume > 0.80)
		icon_state = "compost-full"
	return ..()

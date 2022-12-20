// ripped from roulette beacon, for build-your-own-station atmos
/obj/item/gas_miner_beacon
	name = "gas miner beacon"
	desc = "N.T. approved gas miner beacon, toss it down and you will have a complementary atmospherics gas miner delivered to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"
	var/used
	// which miner to spawn
	var/miner_type

/obj/item/gas_miner_beacon/Initialize(mapload)
	. = ..()
	// use the subtypes
	if(!miner_type)
		qdel(src)

/obj/item/gas_miner_beacon/attack_self()
	if(used)
		return
	loc.visible_message(span_warning("\The [src] begins to beep loudly!"))
	used = TRUE
	addtimer(CALLBACK(src, PROC_REF(launch_payload)), 40)

/obj/item/gas_miner_beacon/proc/launch_payload()
	var/obj/structure/closet/supplypod/centcompod/toLaunch = new()

	new miner_type(toLaunch)

	new /obj/effect/pod_landingzone(drop_location(), toLaunch)
	qdel(src)

/obj/item/gas_miner_beacon/nitrogen
	name = "nitrogen gas miner beacon"
	miner_type = /obj/machinery/atmospherics/miner/nitrogen

/obj/item/gas_miner_beacon/oxygen
	name = "oxygen gas miner beacon"
	miner_type = /obj/machinery/atmospherics/miner/oxygen

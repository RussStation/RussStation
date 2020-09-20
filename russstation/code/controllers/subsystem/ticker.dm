/datum/controller/subsystem/ticker/
	var/initial_delay = 54000
	var/subsequent_delay = 18000
	var/transfer_votes = 0

/datum/controller/subsystem/ticker/proc/votetimer()
	if(world.time - (initial_delay + (subsequent_delay * transfer_votes)) >= 0)
		if(SSshuttle.emergency.timeLeft() >= 6000 || SSshuttle.emergency.mode == SHUTTLE_IDLE || SSshuttle.emergency.mode == SHUTTLE_RECALL)
			SSvote.initiate_vote("crew transfer","the server")
			transfer_votes ++

// ripped from the admin action with minor tweaks
/datum/controller/subsystem/ticker/proc/activate_egalitarian()
	for(var/obj/machinery/door/airlock/W in GLOB.machines)
		if(is_station_level(W.z) && !istype(get_area(W), /area/crew_quarters) && !istype(get_area(W), /area/security) && !istype(get_area(W), /area/ai_monitored))
			W.req_access = list()
			W.req_one_access = list()
	priority_announce("Airlock control override activated due to low staff. Please use this allowance responsibly to set up the station.", "Central Command", 'sound/ai/commandreport.ogg')
	GLOB.egalitarian_mode_active = TRUE

// enough crew has joined, disable egalitarian with a warning time
/datum/controller/subsystem/ticker/proc/deactivate_egalitarian()
	priority_announce("Sufficient crew has joined the station. Airlock control override will deactivate soon. Please return to your assigned work area.", "Central Command", 'sound/ai/commandreport.ogg')
	GLOB.egalitarian_mode_active = FALSE
	addtimer(CALLBACK(src, .proc/finish_deactivate_egalitarian), 1000)

/datum/controller/subsystem/ticker/proc/finish_deactivate_egalitarian()
	// restore access from access_txt which is the map initial setting
	for(var/obj/machinery/door/airlock/W in GLOB.machines)
		if(is_station_level(W.z) && !istype(get_area(W), /area/crew_quarters) && !istype(get_area(W), /area/security) && !istype(get_area(W), /area/ai_monitored))
			W.req_access = W.text2access(W.req_access_txt)
			W.req_one_access = W.text2access(W.req_one_access_txt)
	priority_announce("Airlock control override deactivated.", "Central Command", 'sound/ai/commandreport.ogg')

	// dunk on the tiders
	if(GLOB.captains_spare)
		var/obj/item/card/id/captains_spare/bait = GLOB.captains_spare
		GLOB.captains_spare = null
		if(!istype(get_area(bait), /area/crew_quarters/heads/captain))
			bait.anti_tide()
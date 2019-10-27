/datum/controller/subsystem/ticker/
	var/initial_delay = 54000
	var/subsequent_delay = 18000
	var/transfer_votes = 0

/datum/controller/subsystem/ticker/proc/votetimer()
	if(world.time - (initial_delay + (subsequent_delay * transfer_votes)) >= 0)
		if(SSshuttle.emergency.timeLeft() >= 6000 || SSshuttle.emergency.mode == SHUTTLE_IDLE || SSshuttle.emergency.mode == SHUTTLE_RECALL)
			SSvote.initiate_vote("crew transfer","the server")
			transfer_votes ++

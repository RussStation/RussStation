var/initialdelay = 0
var/subsequentdelay = 0
var/transfervotes = 0

/datum/controller/subsystem/ticker/proc/votetimer()
	initialdelay = CONFIG_GET(number/transfer_delay_initial)
	subsequentdelay = CONFIG_GET(number/transfer_delay_subsequent)
	if(world.time - (initialdelay + (subsequentdelay * transfervotes)) >= 0)
		if(SSshuttle.emergency.timeLeft() >= 6000 || SSshuttle.emergency.mode == SHUTTLE_IDLE || SSshuttle.emergency.mode == SHUTTLE_RECALL)
			SSvote.initiate_vote("crew transfer","the server")
			transfervotes ++

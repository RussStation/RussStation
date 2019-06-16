var/initialtpass = 0

/datum/controller/subsystem/ticker/proc/votetimer()
	var/timerbuffer = 0
	if(initialtpass == 0)
		timerbuffer = CONFIG_GET(number/transfer_delay_initial)
	else
		timerbuffer = CONFIG_GET(number/transfer_delay_interval)
	spawn(timerbuffer)
	if(SSshuttle.emergency.timeLeft() >= 6000 || (SSshuttle.emergency.mode != SHUTTLE_CALL && SSshuttle.emergency.mode != SHUTTLE_DOCKED && SSshuttle.emergency.mode != SHUTTLE_ESCAPE))
		SSvote.initiate_vote("crew transfer","the server")
	initialtpass = 1
	votetimer()

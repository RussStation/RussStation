var/initialtpass = 0

/datum/controller/subsystem/ticker/proc/votetimer()
	var/timerbuffer = 0
	if(initialtpass == 0)
		timerbuffer = CONFIG_GET(number/transfer_delay_initial)
	else
		timerbuffer = CONFIG_GET(number/transfer_delay_interval)
	spawn(timerbuffer)
		SSvote.initiate_vote("crew transfer","the server")
		initialtpass = 1
		votetimer()

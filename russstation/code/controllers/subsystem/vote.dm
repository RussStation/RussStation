/datum/controller/subsystem/vote/var/transit_timer

/datum/controller/subsystem/vote/OnConfigLoad()
	if(CONFIG_GET(flag/transfer_vote))
		var/initial_delay = CONFIG_GET(number/transfer_delay_initial)
		if(initial_delay > world.time)
			set_transfer_timer(initial_delay - world.time)
		else
			set_transfer_timer(CONFIG_GET(number/transfer_delay_subsequent))

/datum/controller/subsystem/vote/proc/set_transfer_timer(timing)
	if(transit_timer)
		deltimer(transit_timer)
	transit_timer = addtimer(CALLBACK(src, .proc/attempt_transfer_vote), timing, TIMER_STOPPABLE)

/datum/controller/subsystem/vote/proc/attempt_transfer_vote()
	if(EMERGENCY_IDLE_OR_RECALLED)
		var/successful = initiate_vote(/datum/vote/crew_transfer_vote,"Automatic Crew Transfer",forced = TRUE)
		// Check if we were successful in creating the vote
		if(successful)
			// We were able to create the vote
			return
	// recheck to see if the shuttle is no longer busy after delay
	set_transfer_timer(10 MINUTES)

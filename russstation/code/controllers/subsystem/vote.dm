/datum/controller/subsystem/vote/
	var/shuttle_refuel_delay = 0
	var/transfer_vote_config = 0
	
/datum/controller/subsystem/vote/proc/shuttlecall()
	var/shuttle_timer = SSshuttle.emergency.timeLeft()
	SSshuttle.block_recall(6000)
	if(shuttle_timer >= 6000 || (SSshuttle.emergency.mode != SHUTTLE_CALL && SSshuttle.emergency.mode != SHUTTLE_DOCKED && SSshuttle.emergency.mode != SHUTTLE_ESCAPE))
		if(SSshuttle.emergency.mode == SHUTTLE_CALL && shuttle_timer >= 6000)	//Apparently doing the emergency request twice cancels the call so these check are just in case
			SSshuttle.emergency.setTimer(6000)
			priority_announce("The emergency shuttle will arrive in [SSshuttle.emergency.timeLeft()/60] minutes.")
		else if (SSshuttle.emergency.mode != SHUTTLE_CALL)
			SSshuttle.emergency.request()
			SSshuttle.emergency.setTimer(6000)
			priority_announce("The emergency shuttle will arrive in [SSshuttle.emergency.timeLeft()/60] minutes.")

		message_admins("The emergency shuttle has been force-called due to a successful crew transfer vote.")
	else
		to_chat(world, "<span style='boldannounce'>Notice: The crew transfer vote has failed because the shuttle has already been called.</span>")

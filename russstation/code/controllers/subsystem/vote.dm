/datum/controller/subsystem/vote/
	var/shuttle_refuel_delay = 0
	var/transfer_vote_config = 0

/datum/controller/subsystem/vote/proc/shuttlecall()
	var/shuttle_timer = SSshuttle.emergency.timeLeft(1)
	SSshuttle.emergency_no_recall = TRUE
	if(SSshuttle.emergency.mode != SHUTTLE_CALL && SSshuttle.emergency.mode != SHUTTLE_DOCKED && SSshuttle.emergency.mode != SHUTTLE_ESCAPE)
		SSshuttle.emergency.request()
		message_admins("The emergency shuttle has been force-called due to a successful crew transfer vote.")
	else
		to_chat(world, span_boldannounce("Notice: The crew transfer vote has failed because the shuttle has already been called."))

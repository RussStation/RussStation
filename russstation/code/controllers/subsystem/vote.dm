/datum/controller/subsystem/vote/
	var/shuttle_refuel_delay = 0
	var/transfer_vote_config = 0

/datum/controller/subsystem/vote/proc/shuttlecall()
	SSshuttle.emergency_no_recall = TRUE
	// check to prevent the vote resetting an already called shuttle
	if(SSshuttle.emergency.mode != SHUTTLE_CALL)
		SSshuttle.emergency.request()
		message_admins("The emergency shuttle has been requested because of a successful transfer vote")
	else
		to_chat(world, span_boldannounce("Notice: The crew transfer vote has failed because the shuttle has already been called."))

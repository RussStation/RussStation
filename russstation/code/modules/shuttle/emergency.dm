/obj/docking_port/mobile/emergency/proc/forcecancel()
	if(mode != SHUTTLE_CALL)
		return

	invertTimer()
	mode = SHUTTLE_RECALL

	priority_announce("The emergency shuttle has been recalled.", null, 'sound/ai/default/shuttlerecalled.ogg', "Priority")

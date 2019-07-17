/obj/machinery/door/airlock/user_allowed(mob/user)
	return (issilicon(user) && canAIControl(user)) || IsAdminGhost(user) || istype(user, /obj/machinery/computer/camera_advanced/camera_advanced_doors)

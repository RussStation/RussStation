///Overloads the tgstation user_allowed adding support for the door control camera
/obj/machinery/door/airlock/user_allowed(mob/user)
	if (istype(user, /mob/camera/aiEye/remote/door_control) && canAIControl(user))
		return TRUE
	return (issilicon(user) && canAIControl(user)) || IsAdminGhost(user)


/obj/machinery/computer/camera_advanced/camera_advanced_doors
	name = "advanced doorknob system"
	desc = "Used to access the various cameras on the station and remotely open doors."
	req_access = list()

	light_color = LIGHT_COLOR_RED

/obj/machinery/computer/camera_advanced/camera_advanced_doors/GrantActions(mob/living/user)
	..()
	RegisterSignal(user, COMSIG_CAMERA_CLICK_CTRL, .proc/DoorBolt)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_ALT, .proc/DoorElectrify)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_SHIFT, .proc/DoorOpen)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT, .proc/DoorEmergencyAccess)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/remove_eye_control(mob/living/user)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_CTRL)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_ALT)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_SHIFT)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT)
	..()

//Bolt door
/obj/machinery/door/airlock/CtrlClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_CTRL, src)
	..()

//Shock door
/obj/machinery/door/airlock/AltClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_ALT, src)
	..()

//Open door
/obj/machinery/door/airlock/ShiftClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_SHIFT, src)
	..()

//Set door emergency access
/obj/machinery/door/airlock/CtrlShiftClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT, src)
	..()

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorBolt(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	if(D.locked)
		D.bolt_raise(src)
	else
		D.bolt_drop(src)
	D.add_hiddenprint(user)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorElectrify(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	if(!D.secondsElectrified)
		D.shock_perm(src)
	else
		D.shock_restore(src)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorOpen(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	D.user_toggle_open(src)
	D.add_hiddenprint(user)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorEmergencyAccess(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	if(!D.emergency)
		D.emergency_on(src)
	else
		D.emergency_off(src)
	D.add_hiddenprint(user)

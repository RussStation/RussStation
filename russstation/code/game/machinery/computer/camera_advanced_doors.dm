
/obj/machinery/computer/camera_advanced/camera_advanced_doors
	name = "advanced doorknob system"
	desc = "Used to access the various cameras on the station and remotely open doors."
	req_access = list()
	light_color = LIGHT_COLOR_RED
	var/hud_type = DATA_HUD_DIAGNOSTIC_BASIC

/mob/camera/aiEye/remote/door_control
	visible_icon = TRUE
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "generic_camera"

/obj/machinery/computer/camera_advanced/camera_advanced_doors/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/door_control(get_turf(src))
	eyeobj.origin = src
	eyeobj.visible_icon = TRUE
	eyeobj.icon = 'icons/mob/cameramob.dmi'
	eyeobj.icon_state = "generic_camera"

/obj/machinery/computer/camera_advanced/camera_advanced_doors/GrantActions(mob/living/user)
	..()
	var/datum/atom_hud/H = GLOB.huds[hud_type]
	H.add_hud_to(user)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_CTRL, .proc/DoorBolt)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_SHIFT, .proc/DoorOpen)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT, .proc/DoorEmergencyAccess)
	if(obj_flags & EMAGGED)
		RegisterSignal(user, COMSIG_CAMERA_CLICK_ALT, .proc/DoorElectrify)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/remove_eye_control(mob/living/user)
	var/datum/atom_hud/H = GLOB.huds[hud_type]
	H.remove_hud_from(user)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_CTRL)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_SHIFT)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT)
	if(obj_flags & EMAGGED)
		UnregisterSignal(user, COMSIG_CAMERA_CLICK_ALT)
	..()

/obj/machinery/computer/camera_advanced/camera_advanced_doors/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='danger'>You overide the door safety system!</span>")
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)

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
		D.bolt_raise(eyeobj)
	else
		D.bolt_drop(eyeobj)
	D.add_hiddenprint(user)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorElectrify(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	if(!D.secondsElectrified)
		D.shock_perm(eyeobj)
	else
		D.shock_restore(eyeobj)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorOpen(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	D.user_toggle_open(eyeobj)
	D.add_hiddenprint(user)

/obj/machinery/computer/camera_advanced/camera_advanced_doors/proc/DoorEmergencyAccess(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	if(!D.emergency)
		D.emergency_on(eyeobj)
	else
		D.emergency_off(eyeobj)
	D.add_hiddenprint(user)

///A camera console to replace AI's doorknob functionalities
/obj/machinery/computer/camera_advanced/doorknob
	name = "advanced doorknob system"
	desc = "Used to access the various cameras on the station and remotely open doors."
	circuit = /obj/item/circuitboard/computer/doorknob
	req_access = list()
	light_color = LIGHT_COLOR_RED
	var/datum/action/innate/doorknob_help/doorknob_help
	var/hud_type = DATA_HUD_DIAGNOSTIC_BASIC ///Having a diagnostic hud allows users to see if doors are shocked

///The subtype of remote eye that has access rights to open doors
/mob/camera/aiEye/remote/door_control
	ai_detector_visible = TRUE
	ai_detector_color = COLOR_RED
	visible_icon = TRUE
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "generic_camera"

///Creates the remote eye mob that the user controls
/obj/machinery/computer/camera_advanced/doorknob/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/door_control()
	eyeobj.origin = src
	eyeobj.visible_icon = TRUE
	eyeobj.icon = 'icons/mob/cameramob.dmi'
	eyeobj.icon_state = "generic_camera"
	doorknob_help = new

///Grants the hotkey interactions with doors to the user
/obj/machinery/computer/camera_advanced/doorknob/GrantActions(mob/living/user)
	..()
	var/datum/atom_hud/H = GLOB.huds[hud_type]
	H.add_hud_to(user)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_CTRL, .proc/DoorBolt)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_SHIFT, .proc/DoorOpen)
	RegisterSignal(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT, .proc/DoorEmergencyAccess)
	if(doorknob_help)
		doorknob_help.target = src
		doorknob_help.Grant(user)
		actions += doorknob_help
	if(obj_flags & EMAGGED)
		doorknob_help.emag = TRUE
		RegisterSignal(user, COMSIG_CAMERA_CLICK_ALT, .proc/DoorElectrify)

///Removes the hotkey interactions from the user
/obj/machinery/computer/camera_advanced/doorknob/remove_eye_control(mob/living/user)
	var/datum/atom_hud/H = GLOB.huds[hud_type]
	H.remove_hud_from(user)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_CTRL)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_SHIFT)
	UnregisterSignal(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT)
	if(obj_flags & EMAGGED)
		UnregisterSignal(user, COMSIG_CAMERA_CLICK_ALT)
	..()

///An action for giving the user hotkey help
/datum/action/innate/doorknob_help
	name = "Hotkey Help"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "hotkey_help"
	var/emag = FALSE

///Triggered by doorknob_help to output the hotkey information to chat
/datum/action/innate/doorknob_help/Activate()
	if(!target || !isliving(owner))
		return
	to_chat(owner, "<b>Hot-keys:</b>")
	to_chat(owner, "Shift-click a door to open/close it.")
	to_chat(owner, "Ctrl-click a door to toggle its bolts.")
	to_chat(owner, "Ctrl-shift-click a door to toggle emergency access.")
	if(emag)
		to_chat(owner, "Alt-click a door to electrify it.")

///Emagging the console allows the user to shock doors
/obj/machinery/computer/camera_advanced/doorknob/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='danger'>You overide the door safety system!</span>")
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)

///Bolt door
/obj/machinery/door/airlock/CtrlClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_CTRL, src)
	..()

///Shock door, only available after emagging
/obj/machinery/door/airlock/AltClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_ALT, src)
	..()

///Open door
/obj/machinery/door/airlock/ShiftClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_SHIFT, src)
	..()

///Set door emergency access
/obj/machinery/door/airlock/CtrlShiftClick(mob/user)
	SEND_SIGNAL(user, COMSIG_CAMERA_CLICK_CTRL_SHIFT, src)
	..()

///Bolts the airlock
/obj/machinery/computer/camera_advanced/doorknob/proc/DoorBolt(mob/living/user, obj/machinery/door/airlock/D)
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

///Electrifies the airlock
/obj/machinery/computer/camera_advanced/doorknob/proc/DoorElectrify(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	if(!D.secondsElectrified)
		D.shock_perm(eyeobj)
	else
		D.shock_restore(eyeobj)

///Opens the airlock
/obj/machinery/computer/camera_advanced/doorknob/proc/DoorOpen(mob/living/user, obj/machinery/door/airlock/D)
	if(!GLOB.cameranet.checkTurfVis(D.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	if(D.obj_flags & EMAGGED)
		return

	D.user_toggle_open(eyeobj)
	D.add_hiddenprint(user)

///Toggles emergency access to the airlock
/obj/machinery/computer/camera_advanced/doorknob/proc/DoorEmergencyAccess(mob/living/user, obj/machinery/door/airlock/D)
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

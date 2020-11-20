/datum/keybinding/human/suicide
	hotkey_keys = list("Unbound")
	name = "suicide"
	full_name = "Suicide"
	description = "Kill yourself, <b style='color:red'>THERE IS NO CONFIRMATION</b>, use at your own risk"
	keybind_signal = COMSIG_KB_HUMAN_SUICIDE_DOWN

/datum/keybinding/human/suicide/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/H = user.mob
	H.suicide(intentional = TRUE)
	return TRUE

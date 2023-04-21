/datum/keybinding/human/suicide
	hotkey_keys = list("Unbound")
	name = "suicide"
	full_name = "Suicide"
	description = "Kills you and makes you unrevivable."
	keybind_signal = COMSIG_KB_HUMAN_SUICIDE_DOWN

/datum/keybinding/human/suicide/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/H = user.mob
	H.suicide()
	return TRUE

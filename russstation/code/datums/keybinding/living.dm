/datum/keybinding/mob/living/suicide
	hotkey_keys = list("Unbound")
	name = "suicide"
	full_name = "Suicide"
	description = "Kills you and blocks revival. THERE IS NO CONFIRMATION, use at your own risk."
	keybind_signal = COMSIG_KB_HUMAN_SUICIDE_DOWN

/datum/keybinding/mob/living/suicide/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/mob = user.mob
	mob.suicide(bypass_prompt = TRUE)
	return TRUE

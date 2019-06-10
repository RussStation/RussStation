/datum/preferences

	var/datum/keybindings/bindings = new

/datum/preferences/proc/update_keybindings(mob/user, action, dir)
	var/keybind = input(user, "Select [action] button", "Keybinding Preference") as null|anything in GLOB.keybinding_validkeys
	if(keybind)
		bindings.key_setbinding(keybind, action, text2num(dir))

/datum/preferences/proc/reset_keybindings()
	bindings.from_list(GLOB.keybinding_default)

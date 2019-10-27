/datum/preferences

	var/datum/keybindings/bindings = new
	features = list("mcolor" = "FFF", "ethcolor" = "9c3030", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "moth_wings" = "Plain", "diona_hair" = "diona_bracket")


/datum/preferences/proc/update_keybindings(mob/user, action, dir)
	var/keybind = input(user, "Select [action] button", "Keybinding Preference") as null|anything in GLOB.keybinding_validkeys
	if(keybind)
		bindings.key_setbinding(keybind, action, text2num(dir))

/datum/preferences/proc/reset_keybindings()
	bindings.from_list(GLOB.keybinding_default)

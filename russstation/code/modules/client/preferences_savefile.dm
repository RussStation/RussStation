/datum/preferences/proc/load_keybindings(var/savefile/S)
	var/list/keybindings
	S["keybindings"] >> keybindings
	if(!islist(keybindings) || !keybindings.len || keybindings.len != GLOB.keybinding_default.len)
		keybindings = GLOB.keybinding_default

	bindings.from_list(keybindings)

/datum/preferences/proc/save_keybindings(var/savefile/S)
	WRITE_FILE(S["keybindings"], bindings.to_list())

/datum/preferences/proc/russ_character_pref_load(savefile/S)  //loads added race's customization options
	//diona
	S["feature_diona_hair"] >> features["diona_hair"]
	features["diona_hair"] 	= sanitize_inlist(features["diona_hair"], GLOB.diona_hair_list)

/datum/preferences/proc/russ_character_pref_save(savefile/S)  //saves added race's customization options
	//diona
	S["feature_diona_hair"] << features["diona_hair"]


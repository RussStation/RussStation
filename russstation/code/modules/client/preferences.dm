/datum/preferences

	var/datum/keybindings/bindings = new
	features = list("mcolor" = "FFF", "ethcolor" = "9c3030", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "moth_wings" = "Plain", "diona_hair" = "diona_bracket")


/datum/preferences/proc/update_keybindings(mob/user, action, dir)
	var/keybind = input(user, "Select [action] button", "Keybinding Preference") as null|anything in GLOB.keybinding_validkeys
	if(keybind)
		bindings.key_setbinding(keybind, action, text2num(dir))

/datum/preferences/proc/reset_keybindings()
	bindings.from_list(GLOB.keybinding_default)

/datum/preferences/proc/add_russ_choices(dat)  //adds a button for customising added race's hair/additional body parts
	if("diona_hair" in pref_species.mutant_bodyparts)
		dat += "<td valign='top' width='7%'>"

		dat += "<h3>Hair</h3>"

		dat += "<a href='?_src_=prefs;preference=diona_hair;task=input'>[features["diona_hair"]]</a><BR>"

		dat += "</td>"
	return dat

/datum/preferences/proc/process_russ_link(mob/user, list/href_list)  //handles added russ station links
	switch(href_list["task"])
		if("input")
			if(href_list["preference"] == "diona_hair")
				var/new_diona_hair
				new_diona_hair = input(user, "Choose your character's hair:", "Character Preference") as null|anything in GLOB.diona_hair_list
				if(new_diona_hair)
					features["diona_hair"] = new_diona_hair

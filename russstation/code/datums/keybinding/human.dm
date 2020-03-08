/datum/keybinding/human/suicide
	hotkey_keys = list("Unbound")
	name = "suicide"
	full_name = "Suicide"
	description = "Kill yourself, <b style='color:red'>THERE IS NO CONFIRMATION</b>, use at your own risk"

/datum/keybinding/human/suicide/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.suicide(intentional = TRUE)
	return TRUE

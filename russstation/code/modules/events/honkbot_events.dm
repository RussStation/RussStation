/client/proc/twitchmeteor()
	set category = "Server"
	set desc = "Twitch Sent a Meteor"
	set name = "Twitch Meteor"

	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		log_admin("[key_name(usr)] attempted to use Twitch Meteor, but doesnt have rights to.")
		message_admins("[key_name_admin(usr)] attempted to use Twitch Meteor, but doesnt have rights to.")
		return

	spawn_meteor(list(/obj/effect/meteor/medium=1))

	log_admin("[key_name(usr)] sent a single meteor to the station.")
	message_admins("[key_name_admin(usr)] sent a single meteor to the station.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Twitch Meteor")


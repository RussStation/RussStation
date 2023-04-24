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

/client/proc/twitch_command_announcement(msg as text)
	set category = "Server"
	set name = "Tsay" //Twitch say
	set hidden = TRUE

	if(!msg)
		log_admin("[key_name(usr)] attempted to use Twitch Announcement, but didnt write anything.")
		message_admins("[key_name_admin(usr)] attempted to use Twitch Announcement, but didnt write anything.")
		return

	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		log_admin("[key_name(usr)] attempted to use Twitch Announcement, but doesnt have rights to.")
		message_admins("[key_name_admin(usr)] attempted to use Twitch Announcement, but doesnt have rights to.")
		return

	priority_announce(msg, "Message From a Central Command Employee.") //Sends the message to everyone

	log_admin("[key_name(usr)] sent a command message to the station.")
	message_admins("[key_name_admin(usr)] sent a command message to the station.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Tsay")

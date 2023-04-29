/client/proc/twitchmeteor(msg as text)
	set category = "Server"
	set desc = "Twitch Sent a Meteor"
	set name = "Twitch Meteor"

	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		log_admin("[key_name(usr)] attempted to use Twitch Meteor, but doesnt have rights to.")
		message_admins("[key_name_admin(usr)] attempted to use Twitch Meteor, but doesnt have rights to.")
		return

	if(!msg)
		log_admin("[key_name(usr)] attempted to use Twitch Meteor, but didnt write anything.")
		message_admins("[key_name_admin(usr)] attempted to use Twitch Meteor, but didnt write anything.")
		return

	if(msg == "dust")
		spawn_meteor(list(/obj/effect/meteor/dust=1))
	else if(msg == "medium")
		spawn_meteor(list(/obj/effect/meteor/medium=1))
	else if(msg == "big")
		spawn_meteor(list(/obj/effect/meteor/big=1))
	else if(msg == "flaming")
		spawn_meteor(list(/obj/effect/meteor/flaming=1))
	else if(msg == "irradiated")
		spawn_meteor(list(/obj/effect/meteor/irradiated=1))
	else if(msg == "cluster")
		spawn_meteor(list(/obj/effect/meteor/cluster=1))
	else if(msg == "cluster fragment")
		spawn_meteor(list(/obj/effect/meteor/cluster_fragment=1))
	else if(msg == "carp")
		spawn_meteor(list(/obj/effect/meteor/carp=1))
	else if(msg == "bluespace")
		spawn_meteor(list(/obj/effect/meteor/bluespace=1))
	else if(msg == "banana")
		spawn_meteor(list(/obj/effect/meteor/banana=1))
	else if(msg == "emp")
		spawn_meteor(list(/obj/effect/meteor/emp=1))
	else if(msg == "meaty")
		spawn_meteor(list(/obj/effect/meteor/meaty=1))
	else if(msg == "meaty xeno")
		spawn_meteor(list(/obj/effect/meteor/meaty/xeno=1))
	else if(msg == "tunguska")
		spawn_meteor(list(/obj/effect/meteor/tunguska=1))
	else if(msg == "pumpkin")
		spawn_meteor(list(/obj/effect/meteor/pumpkin=1))
	else
		log_admin("[key_name(usr)] attempted to use Twitch Meteor, but didnt write anything valid.")
		message_admins("[key_name_admin(usr)] attempted to use Twitch Meteor, but didnt write anything valid.")
		return

	log_admin("[key_name(usr)] sent a [msg] meteor to the station.")
	message_admins("[key_name_admin(usr)] sent a [msg] meteor to the station.")
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

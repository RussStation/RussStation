// /datum/round_event_control/meteor_redemption
// 	name = "Twitch Meteor Redemption"
// 	typepath = /datum/round_event/meteor_redemption
// 	weight = 0
// 	min_players = 1
// 	max_occurrences = 1000
// 	earliest_start = 1 SECONDS
// 	category = EVENT_CATEGORY_SPACE
// 	description = "A regular meteor sent by a twitch viewer."

// /datum/round_event/meteor_redemption
// 	start_when = 0
// 	end_when = 1
// 	announce_when = 1
// 	var/list/wave_type = list(/obj/effect/meteor/medium=1)

// /datum/round_event/meteor_redemption/tick()
// 	if(ISMULTIPLE(activeFor, 3))
		// spawn_meteors(1, wave_type)

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


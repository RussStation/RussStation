#define CHOICE_RESTART "Initiate Crew Transfer"
#define CHOICE_CONTINUE "Continue The Shift"

/datum/vote/crew_transfer_vote
	name = "Crew Transfer"
	default_choices = list(
		CHOICE_RESTART,
		CHOICE_CONTINUE,
	)
	vote_sound = 'russstation/sound/misc/transfer_vote.ogg'

/datum/vote/crew_transfer_vote/toggle_votable(mob/toggler)
	if(!toggler)
		CRASH("[type] wasn't passed a \"toggler\" mob to toggle_votable.")
	if(!check_rights_for(toggler.client, R_ADMIN))
		return FALSE

	CONFIG_SET(flag/transfer_vote, !CONFIG_GET(flag/transfer_vote))
	return TRUE

/datum/vote/crew_transfer_vote/is_config_enabled()
	return CONFIG_GET(flag/transfer_vote)

/datum/vote/crew_transfer_vote/can_be_initiated(mob/by_who, forced)
	. = ..()
	if(!.)
		return FALSE

	// Check if it's a forced vote
	if(!forced)
		// Check if the transfer vote is enabled in the config
		if(!CONFIG_GET(flag/transfer_vote))
			if(by_who)
				to_chat(by_who, span_warning("Transfer voting is disabled."))
			return FALSE

	// TODO: possibly replace with SSshuttle.canEvac(by_who)
	var/srd = CONFIG_GET(number/shuttle_refuel_delay)
	if(world.time - SSticker.round_start_time < srd)
		if(by_who)
			to_chat(by_who, span_warning("Shuttle call can only initiate after [DisplayTimeText(srd - (world.time - SSticker.round_start_time))]."))
		return FALSE

	return TRUE

/datum/vote/crew_transfer_vote/get_vote_result(list/non_voters)
	if(!CONFIG_GET(flag/default_no_vote))
		// Default no votes will add non-voters to "Continue Playing"
		choices[CHOICE_CONTINUE] += length(non_voters)
	return ..()

/datum/vote/crew_transfer_vote/finalize_vote(winning_option)
	if(winning_option == CHOICE_CONTINUE)
		// Set up the next transfer vote timer
		SSvote.set_transfer_timer(CONFIG_GET(number/transfer_delay_subsequent))
		return

	if(winning_option == CHOICE_RESTART)
		// Call the shuttle
		shuttlecall()
		return

	CRASH("[type] wasn't passed a valid winning choice. (Got: [winning_option || "null"])")

/datum/vote/crew_transfer_vote/proc/shuttlecall()
	// check to prevent the vote resetting an already called shuttle
	if(EMERGENCY_IDLE_OR_RECALLED)
		SSshuttle.emergency.request()
		SSshuttle.emergency_no_recall = TRUE
		message_admins("The emergency shuttle has been requested because of a successful transfer vote")
	else
		to_chat(world, span_boldannounce("Notice: The crew transfer vote has failed because the shuttle is unavailable"))

#undef CHOICE_RESTART
#undef CHOICE_CONTINUE

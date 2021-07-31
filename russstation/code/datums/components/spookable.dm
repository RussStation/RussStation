// how often to check for ghosts
#define SPOOK_COOLDOWN 60

/// Spookable: allows a mob to see ghosts, which makes them feel bad
/datum/component/spookable
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/spooked = FALSE

/datum/component/spookable/Initialize()
	// probably doesn't make sense to have spookable silicons
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/C = parent
	C.see_invisible = INVISIBILITY_OBSERVER

/datum/component/spookable/Destroy(force, silent)
	if(iscarbon(parent))
		var/mob/living/carbon/C = parent
		C.see_invisible = initial(C.see_invisible)
	return ..()

/datum/component/spookable/proc/ghost_check()
	if(QDELETED(src))
		return
	// is this the best way to check for a mob in view?
	var/near_ghost = FALSE
	for(var/mob/dead/observer/ghost in view(7, parent))
		if(istype(ghost))
			near_ghost = TRUE
			break
	if(near_ghost && !spooked)
		SEND_SIGNAL(parent, COMSIG_ADD_MOOD_EVENT, "spooked", /datum/mood_event/spooked)
		spooked = TRUE
	else if (!near_ghost && spooked)
		SEND_SIGNAL(parent, COMSIG_CLEAR_MOOD_EVENT, "spooked")
		spooked = FALSE
	// because we're calling expensive `in view`, rate limit checks
	addtimer(CALLBACK(src, .proc/ghost_check, SPOOK_COOLDOWN))

// Spooked: jinkies (todo: new mood icon? adjust mood change?)
/datum/mood_event/spooked
	description = "<span class='warning'>I just saw a ghost!</span>\n"
	mood_change = -3

/* A reinforced floor with no deconstruction methods
 * For use in the SM to prevent players cheesing delaminations
 * by removing tiles to space in order to get rid of fires.
 */

/turf/open/floor/engine/no_decon
	desc = "Very robust."

/turf/open/floor/engine/no_decon/examine(mob/user)
	. = list("[get_examine_string(user, TRUE)].")
	. += desc
	
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) 

/turf/open/floor/engine/no_decon/wrench_act(mob/living/user, obj/item/I)
	return

/turf/open/floor/engine/no_decon/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return

/turf/open/floor/engine/no_decon/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	return

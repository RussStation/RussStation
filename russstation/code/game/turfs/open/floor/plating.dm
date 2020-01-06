/turf/open/floor/plating/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_DECONSTRUCT)
		var/area/arnold = src.loc //The punishment was inspired by the arnold pizza
		if(istype(arnold, /area/engine/supermatter) && isliving(user))
			var/mob/living/loser = user //Yeah that's right
			var/obj/item/bodypart/l_arm = loser.get_bodypart(BODY_ZONE_L_ARM)
			var/obj/item/bodypart/r_arm = loser.get_bodypart(BODY_ZONE_R_ARM)
			if(iscarbon(loser) && (r_arm || l_arm))
				loser.visible_message("<span class='warning'>[loser]'s arms are torn off for their sins!!</span>", "<span class='warning'>You feel a deep sense of shame, consider quitting your job.</span>")
				if(l_arm)
					l_arm.dismember()
				if(r_arm)
					r_arm.dismember()
				playsound(loser, "desceration" ,50, TRUE, -1)
			return FALSE
	..()

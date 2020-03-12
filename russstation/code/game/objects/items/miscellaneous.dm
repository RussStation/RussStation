/obj/item/caution/dangerous
	var/willSlip = 0

obj/item/caution/dangerous/attack_self(mob/user)
	if(user.mind.assigned_role == "Janitor")
		willSlip = !willSlip
		if(willSlip)
			to_chat(user, "<span class='notice'>The sign will now slip anyone moving past.<span>")
		else
			to_chat(user, "<span class='notice'>The sign will no longer slip passerbys.<span>")


/obj/item/caution/dangerous/HasProximity(atom/movable/AM as mob|obj)
	if(willSlip)
		if(istype(AM, /mob/living/carbon))
			src.visible_message("How dare you.")
			var/mob/living/carbon/C = AM
			var/turf/open/T = get_turf(C)
			T.MakeSlippery(TURF_WET_LUBE, 5)

///obj/structure/holosign/wetsign/dangerous

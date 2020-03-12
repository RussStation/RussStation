/obj/item/caution/dangerous
	var/willSlip = 0

/obj/item/caution/dangerous/attack_self(mob/user)
	if(user.mind.assigned_role == "Janitor")
		willSlip = !willSlip
		if(willSlip)
			to_chat(user, "<span class='notice'>The sign will now slip anyone moving past.<span>")
			START_PROCESSING(SSobj, src)
		else
			to_chat(user, "<span class='notice'>The sign will no longer slip passerbys.<span>")

/obj/item/caution/dangerous/process()
	if(!willSlip)
		STOP_PROCESSING(SSobj, src)


/obj/item/caution/dangerous/HasProximity(atom/movable/AM)
	src.visible_message("Checking.")
	if(willSlip)
		src.visible_message("On the prowl.")

		if(istype(AM, /mob/living/carbon))
			src.visible_message("How dare you.")

			var/turf/open/T = get_turf(AM)
			var/list/adjacent_T = get_adjacent_open_turfs(T)

			T.MakeSlippery(TURF_WET_LUBE, 5)
			for(var/turf/open/AT in adjacent_T)
				AT.MakeSlippery(TURF_WET_LUBE, 5)

///obj/structure/holosign/wetsign/dangerous

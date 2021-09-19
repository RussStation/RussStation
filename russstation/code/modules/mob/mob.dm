
//Start Reason: fuck you, used for bung apples

//Fake Vomit
/mob/proc/fakevomit(green = 0, no_text = 0)
	if(stat == DEAD)// Nothing happens if dead
		return
	var/turf/location = loc
	if(!istype(location, /turf/open))
		return
	if(green)
		if(!no_text)
			visible_message(
				span_warning("[src] vomits up some yellow goo!"),
				span_warning("You vomit up some yellow goo!"),
			)
		new /obj/effect/decal/cleanable/vomit(location)
	else
		if(!no_text)
			visible_message(
				span_warning("[src] pukes all over [p_them()]self!"),
				span_warning("You puke all over yourself!"),
			)
		location.add_vomit_floor(src, 1)

	playsound(location, 'sound/effects/splat.ogg', 50, 1)

//end

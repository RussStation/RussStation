
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
			visible_message("<span class='warning'>[src] vomits up some yellow goo!</span>","<span class='warning'>You vomit up some yellow goo!</span>")
		new /obj/effect/decal/cleanable/vomit(location)
	else
		if(!no_text)
			visible_message("<span class='warning'>[src] pukes all over [p_them()]self!</span>","<span class='warning'>You puke all over yourself!</span>")
		location.add_vomit_floor(src, 1)

	playsound(location, 'sound/effects/splat.ogg', 50, 1)

//end

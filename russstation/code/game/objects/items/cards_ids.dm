// for some reason called at round start, so let's grab this ref
/obj/item/card/id/captains_spare/GetID()
	if(GLOB.egalitarian_mode_active)
		GLOB.captains_spare = src
	return ..()

/obj/item/card/id/captains_spare/proc/anti_tide()
	say("Anti-Tide mechanism activating...")
	addtimer(CALLBACK(src, .proc/explode), 50)

/obj/item/card/id/captains_spare/proc/explode()
	explosion(src, 0, 0, 2, 2)
	qdel()
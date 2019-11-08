//makes changes to tg's default confetti
/obj/effect/decal/cleanable/confetti //see 'code\game\objects\effects\decals\cleanable\misc.dm'
	icon = 'russstation/icons/turf/decals.dmi'
	random_icon_states = list("confetti1", "confetti2", "confetti3")
	mergeable_decal = FALSE //allows more than one on a tile at a time, important for the gibspawner
	beauty = 5

//used for the confetti gibspawner, moves in a direction leaving a trail of confetti
/obj/effect/decal/cleanable/confetti/proc/streak(list/directions)
	set waitfor = FALSE
	var/direction = pick(directions)
	for(var/i in 0 to pick(0, 20;1)) //small chance of going farther than 1 tile
		sleep(2) //smooths movement
		if(i > 0)
			new /obj/effect/decal/cleanable/confetti(loc)
		if(!step_to(src, get_step(src, direction), 0))
			break

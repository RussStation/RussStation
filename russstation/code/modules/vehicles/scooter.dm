/obj/vehicle/ridden/wheelchair/russ/sportschair/Initialize()
	. = ..()
	sparks = new
	sparks.set_up(1, 0, src)
	sparks.attach(src)

/obj/vehicle/ridden/wheelchair/russ/sportschair/Destroy()
	if(sparks)
		QDEL_NULL(sparks)
	return ..()

/obj/vehicle/ridden/wheelchair/russ/sportschair/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/ridden/wheelchair/russ/sportschair/ollie, VEHICLE_CONTROL_DRIVE)

//allows skateboards to be non-dense but still allows 2 skateboarders to collide with each other
/obj/vehicle/ridden/wheelchair/russ/sportschair/post_buckle_mob(mob/living/M)
	density = TRUE
	return ..()

/obj/vehicle/ridden/wheelchair/russ/sportschair/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		density = FALSE
	return ..()

/obj/vehicle/ridden/wheelchair/russ/sportschair/Bump(atom/A)
	. = ..()
	if(!A.density || !has_buckled_mobs())
		return

///Moves the vehicle forward and if it lands on a table, repeats
/obj/vehicle/ridden/wheelchair/russ/sportschair/proc/grind()
	step(src, dir)
	if(!has_buckled_mobs() || !(locate(/obj/structure/table) in loc.contents) && !(locate(/obj/structure/fluff/tram_rail) in loc.contents))
		obj_flags = CAN_BE_HIT
		grinding = FALSE
		icon_state = "[initial(icon_state)]"
		return

	var/mob/living/L = buckled_mobs[1]
	L.adjustStaminaLoss(instability*0.5)
	if(L.getStaminaLoss() >= 100)
		obj_flags = CAN_BE_HIT
		playsound(src, 'sound/effects/bang.ogg', 20, TRUE)
		unbuckle_mob(L)
		var/atom/throw_target = get_edge_target_turf(src, pick(GLOB.cardinals))
		L.throw_at(throw_target, 2, 2)
		visible_message("<span class='danger'>[L] loses [L.p_their()] footing and slams on the ground!</span>")
		L.Paralyze(4 SECONDS)
		grinding = FALSE
		icon_state = "[initial(icon_state)]"
		return
	playsound(src, 'sound/vehicles/skateboard_roll.ogg', 50, TRUE)
	if(prob(25))
		var/turf/location = get_turf(src)
		if(location)
			location.hotspot_expose(1000,1000)
		sparks.start() //the most radical way to start plasma fires
	addtimer(CALLBACK(src, .proc/grind), 1)

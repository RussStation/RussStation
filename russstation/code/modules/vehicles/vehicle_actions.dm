/datum/action/vehicle/ridden/scooter/skateboard/ollie/suicide
	name = "The Final Ollie"
	desc = "This may be your last trick, better make it radical."

/datum/action/vehicle/ridden/scooter/skateboard/ollie/suicide/Trigger()
	if(world.time > next_ollie)
		var/obj/vehicle/ridden/scooter/skateboard/V = vehicle_target
		if (V.grinding)
			return
		var/mob/living/L = owner
		var/turf/landing_turf = get_step(V.loc, V.dir)
		if (L.getStaminaLoss() >= 100)
			playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
			V.unbuckle_mob(L)
			L.throw_at(landing_turf, 6, 3)
			L.Paralyze(100)
			V.visible_message(
				span_danger("[L] attempts an incredible trick! Embarassingly [L.p_they()] fail[L.p_s()] miserably and fall on [L.p_their()] face."),
			)
		else
			L.spin(20, 1)
			animate(L, pixel_y = -6, time = 8)
			animate(V, pixel_y = -6, time = 6)
			L.SpinAnimation(5,5)
			V.SpinAnimation(5,5)
			playsound(L, 'sound/magic/ethereal_exit.ogg', 50, TRUE)
			V.unbuckle_mob(L)
			sleep(5)
			V.visible_message(
				span_danger("[L] executes one final trick, as [L.p_they()] flip[L.p_s()] through the air [L.p_their()] body evaporates into dust"),
				span_danger("You have successfully performed the Final Ollie, you phase out of existence with satisfaction"),
			)
			L.dust(drop_items = TRUE)
			V.throw_at(landing_turf, 6, 3)

/datum/action/vehicle/ridden/wheelchair/russ/sportschair/ollie
	name = "Ollie"
	desc = "Get some air! Land on a table to do a gnarly grind."
	button_icon_state = "skateboard_ollie"
	///Cooldown to next jump
	var/next_ollie

/datum/action/vehicle/ridden/wheelchair/russ/sportschair/ollie/Trigger()
	if(world.time > next_ollie)
		var/obj/vehicle/ridden/wheelchair/russ/sportschair/vehicle = vehicle_target
		vehicle.obj_flags |= BLOCK_Z_OUT_DOWN
		if (vehicle.grinding)
			return
		var/mob/living/rider = owner
		var/turf/landing_turf = get_step(vehicle.loc, vehicle.dir)
		rider.adjustStaminaLoss(vehicle.instability*2)
		if (rider.getStaminaLoss() >= 100)
			vehicle.obj_flags &= ~CAN_BE_HIT
			playsound(src, 'sound/effects/bang.ogg', 20, TRUE)
			vehicle.unbuckle_mob(rider)
			rider.throw_at(landing_turf, 2, 2)
			rider.Paralyze(40)
			vehicle.visible_message(
				span_danger("[rider] misses the landing and falls on [rider.p_their()] face!"),
			)
		else
			rider.spin(4, 1)
			animate(rider, pixel_y = -6, time = 4)
			animate(vehicle, pixel_y = -6, time = 3)
			playsound(vehicle, 'sound/vehicles/skateboard_ollie.ogg', 50, TRUE)
			passtable_on(rider, VEHICLE_TRAIT)
			vehicle.pass_flags |= PASSTABLE
			rider.Move(landing_turf, vehicle_target.dir)
			passtable_off(rider, VEHICLE_TRAIT)
			vehicle.pass_flags &= ~PASSTABLE
		if((locate(/obj/structure/table) in vehicle.loc.contents) || (locate(/obj/structure/fluff/tram_rail) in vehicle.loc.contents))
			/*if(locate(/obj/structure/fluff/tram_rail) in vehicle.loc.contents)
				rider.client.give_award(/datum/award/achievement/misc/tram_surfer, rider)*/
			vehicle.grinding = TRUE
			vehicle.icon_state = "[initial(vehicle.icon_state)]-grind"
			addtimer(CALLBACK(vehicle, /obj/vehicle/ridden/wheelchair/russ/sportschair/.proc/grind), 2)

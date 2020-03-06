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
			V.visible_message("<span class='danger'>[L] attempts an incredible trick! Embarassingly [L.p_they()] fail[L.p_s()] miserably and fall on [L.p_their()] face.</span>")
		else
			L.spin(20, 1)
			animate(L, pixel_y = -6, time = 8)
			animate(V, pixel_y = -6, time = 6)
			L.SpinAnimation(5,5)
			V.SpinAnimation(5,5)
			playsound(L, 'sound/magic/ethereal_exit.ogg', 50, TRUE)
			V.unbuckle_mob(L)
			sleep(5)
			V.visible_message("<span class='danger'>[L] executes one final trick, as [L.p_they()] flip[L.p_s()] through the air [L.p_their()] body evaporates into dust</span>", "<span class='danger'>You have successfully performed the Final Ollie, you phase out of existence with satisfaction</span>")
			L.dust(drop_items = TRUE)
			V.throw_at(landing_turf, 6, 3)

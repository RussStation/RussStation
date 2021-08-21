// conveyor that randomly moves objects or not
/obj/machinery/conveyor/auto/random
	// activate often but not constantly
	var/activation_chance = 60

/obj/machinery/conveyor/auto/random/process()
	if(prob(activation_chance))
		. = ..()

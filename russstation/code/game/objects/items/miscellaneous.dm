/obj/item/caution/slippery
	var/willSlip = 0 //0 - disabled || 1 - enabled 
	var/lastSlip = 0 //last time the sign slipped someone
	var/clowningAround = 0 //has a clown somehow gotten their hands on it?

/obj/item/caution/slippery/examine(mob/user)
	. = ..()
	if(isobserver(user) || user.mind.assigned_role == "Janitor") //janitors and ghosts can see that it's a fake sign
		. += "<span class='notice'>This [src.name] is outfitted with an experimental sprayer.</span>"
		if(clowningAround)
			. += "<span class='warning'>It's been tampered with.</span>"
	else if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns know lube when they see it
		. += "<span class='notice'>This [src.name] has great potential for pranks.</span>"


//when used by a janitor: toggles between active and disabled, when used by a clown, pranks ensue
/obj/item/caution/slippery/attack_self(mob/user)
	if(user.mind.assigned_role == "Janitor") //only janitors can interact with it normally
		willSlip = !willSlip
		clowningAround = 0
		if(willSlip)
			to_chat(user, "<span class='notice'>The [src.name] will now slip anyone running past.<span>")
		else
			to_chat(user, "<span class='notice'>The [src.name] will no longer slip passerbys.<span>")
	else if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns and janitors, enemies since the dawn of time
		willSlip = 1 //no going back
		clowningAround = 1
		to_chat(user, "<span class='warning'>The [src.name]'s lube sprayer has been overloaded.<span>")

/obj/item/caution/slippery/Initialize()
	. = ..()
	proximity_monitor = new(src, 1, 1) //initializes the proximity: (source, range, if it needs to be on a turf)

/obj/item/caution/slippery/HasProximity(atom/movable/AM)
	if (world.time < lastSlip + 50 && lastSlip && !clowningAround) //cooldown for slipping - no cooldown for clowns, honk
		return

	if(willSlip) //needs to be enabled, obviously
		if(istype(AM, /mob/living/carbon)) //is it actually a thing we can slip?
			var/mob/living/carbon/C = AM
			var/turf/open/T = get_turf(src)
			var/list/adjacent_T = get_adjacent_open_turfs(T)

			//are they running? & are they not a janitor? & are they not slipped already? & are they not being pulled?
			if((C.m_intent != MOVE_INTENT_WALK) && !(C.mind.assigned_role == "Janitor") && !(C.IsKnockdown()) && !(C.pulledby)) 
				lastSlip = world.time
				if(prob(50))
					src.visible_message(" The [src.name] beeps, <span class='boldwarning'>\"Caution: Wet floor.\" <span>")

				//make own turf and all adjacent turfs lubed for a bit
				if(clowningAround) //clowns mess things up as usual
					playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
					T.MakeSlippery(TURF_WET_SUPERLUBE, 10)
				else
					playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
					T.MakeSlippery(TURF_WET_LUBE, 10)

				for(var/turf/open/AT in adjacent_T)
					AT.MakeSlippery(TURF_WET_LUBE, 10)

/obj/item/storage/box/syndie_kit/boxOfSigns

/obj/item/storage/box/syndie_kit/boxOfSigns/PopulateContents()
	for(var/i = 0, i < 6, i++)
		new /obj/item/caution/slippery(src) 


///obj/structure/holosign/wetsign/dangerous

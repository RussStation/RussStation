//constructing a wetmore slippery sign:
//apply floor buffer to sign (from RND)
//apply prox sensor to sign (from robo/cargo)

/obj/item/clothing/suit/caution/attackby(obj/item/I, mob/living/user)
	. = ..()
	var/atom/L = drop_location()

	if(istype(I, /obj/item/janiupgrade))
		if(name != "wet floor sign") //make sure jannies don't accidentally use their family heirlooms
			to_chat("<span class='warning'>You wouldn't want to tamper with [src.name]!.<span>")
		else
			to_chat(user, "<span class='notice'>You add a [I.name] to the bottom of the [src.name].<span>")
			qdel(I)
			qdel(src)
			new /obj/item/clothing/suit/caution/incomplete(L, 1)

		
/obj/item/clothing/suit/caution/incomplete
	name = "Incomplete wet floor sign"
	slot_flags = null

/obj/item/clothing/suit/caution/incomplete/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The [src.name] has a floor buffer underneath. Perhaps you could <i>attach a sensor</i> to it, or <i>undo the screws</i> to remove it.</span>"

/obj/item/clothing/suit/caution/incomplete/attackby(obj/item/I, mob/living/user)
	. = ..()
	var/atom/L = drop_location()

	if(istype(I, /obj/item/screwdriver))
		to_chat(user, "<span class='notice'>You detatch the floor buffer from the [src.name].<span>")
		qdel(src)
		new /obj/item/clothing/suit/caution(L, 1)
		new /obj/item/janiupgrade(L, 1)

	if(istype(I, /obj/item/assembly/prox_sensor))
		to_chat(user, "<span class='notice'>You add a [Iname] to the floor buffer on the [src.name].<span>")
		qdel(I)
		qdel(src)
		var/obj/item/S = /obj/item/clothing/suit/caution/slippery
		if(prob(1)) //1% chance for a name
			S.name = "Hall Monitor"

		new S(L, 1)

//end of construction code

//Wetmore Slippery Sign
//Constructable by janitors with upgrades from RND and sensors from cargo/robotics
//Slips people who don't heed the warning

//Wetmore Slippery Sign (traitor item)
//purchasable from traitor uplink by janitors (7tc for 4)
//in addition to slipping, also animates and kicks people around

/obj/item/clothing/suit/caution/slippery
	slot_flags = null //cannot be worn- or else it breaks stuff

	var/willSlip = 0 //0 - disabled || 1 - enabled 
	var/lastSlip = 0 //last time the sign slipped someone
	var/clowningAround = 0 //0 - untainted || 1 - clown got it
	var/evilSign = 0 //is the sign a traitor?
	var/mob/living/carbon/boss = null //used so animated signs don't attack the janitor

/obj/item/clothing/suit/caution/slippery/syndicate
	evilSign = 1 //signs purchased from the uplink

/obj/item/clothing/suit/caution/slippery/examine(mob/user)
	. = ..()
	if(isobserver(user) || user.mind.assigned_role == "Janitor") //janitors and ghosts can see that it's a slippery sign
		. += "<span class='notice'>This [src.name] is outfitted with an experimental sprayer.</span>"
		if(clowningAround || evilSign)
			. += "<span class='warning'>It's been tampered with.</span>"
	else if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns know lube when they see it
		. += "<span class='notice'>This [src.name] has great potential for pranks.</span>"


//when used by a janitor: toggles between active and disabled, when used by a clown, pranks ensue
/obj/item/clothing/suit/caution/slippery/attack_self(mob/user)
	if(user.mind.assigned_role == "Janitor") //only janitors can interact with it normally
		boss = user
		willSlip = !willSlip
		clowningAround = 0
		if(willSlip)
			to_chat(user, "<span class='notice'>The [src.name] will now slip anyone running past.<span>")
		else
			to_chat(user, "<span class='notice'>The [src.name] will no longer slip passerbys.<span>")
	else if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns.
		willSlip = 1 
		clowningAround = 1
		to_chat(user, "<span class='warning'>The [src.name]'s lube sprayer has been overloaded.<span>")
	else
		to_chat(user, "<span class = 'notice'>The [src.name] requires a janitor to activate.<span>")

/obj/item/clothing/suit/caution/slippery/Initialize()
	. = ..()
	proximity_monitor = new(src, 1, 1) //initializes the proximity: (source, range, if it needs to be on a turf)

/obj/item/clothing/suit/caution/slippery/HasProximity(atom/movable/AM)
	if (world.time < lastSlip + 50 && lastSlip && !clowningAround) //cooldown for slipping - no cooldown for clowns
		return

	if(!willSlip) //needs to be enabled to slip people obviously
		return

	if(!istype(AM, /mob/living/carbon)) //is it actually a thing we can slip?
		return
	
	var/mob/living/carbon/C = AM
	var/turf/open/T = get_turf(src)
	var/list/adjacent_T = get_adjacent_open_turfs(T)

	//are they not walking? & are they not the janitor? & are they not being pulled? & either [is it evil or are they not already slipped]?
	if((C.m_intent != MOVE_INTENT_WALK) && (C != boss) && !(C.pulledby) && (evilSign || !(C.IsKnockdown()))) 
		lastSlip = world.time
		src.visible_message(" The [src.name] beeps, <span class='boldwarning'>\"Caution: Wet floor.\" <span>")

		//make own turf and all adjacent turfs lubed for a bit
		if(clowningAround) 
			playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
			T.MakeSlippery(TURF_WET_SUPERLUBE, 10)
		else
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
			T.MakeSlippery(TURF_WET_LUBE, 10)

		for(var/turf/open/AT in adjacent_T)
			AT.MakeSlippery(TURF_WET_LUBE, 10)

		//cry havoc and let slip the signs of wet
		if(evilSign)
			willSlip = 0 //this kills the sign
			src.animate_atom_living(boss)

/obj/item/clothing/suit/caution/slippery/emag_act(mob/user) 
	evilSign = 1
	willSlip = 1 //bypasses the janitor requirement
	boss = user	
	to_chat(user, "<span class='boldwarning'>The [src.name] begins to shake violently.<span>")	

//box of 4 slippery signs- for the traitor uplink
/obj/item/storage/box/boxOfSigns

/obj/item/storage/box/boxOfSigns/PopulateContents()
	for(var/i = 0, i < 4, i++)
		new /obj/item/clothing/suit/caution/slippery/syndicate(src) 


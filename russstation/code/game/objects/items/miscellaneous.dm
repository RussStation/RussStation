//constructing a wetmore slippery sign:
//obtain a wet floor sign (from cargo, chemistry(plastic), or your vendor )
//apply floor buffer to sign (from RND)
//apply prox sensor to sign (from robo/cargo)

/obj/item/clothing/suit/caution/attackby(obj/item/I, mob/living/user)
	var/atom/L = drop_location()
	var/datum/quirk/family_heirloom/heirloomCheck 

	if(istype(I, /obj/item/janiupgrade))
		//checks all their quirks for the family heirloom quirk- so we can check if they have a wet floor sign heirloom later 
		for(var/datum/quirk/hasQuirk in user.roundstart_quirks)
			if(istype(hasQuirk, /datum/quirk/family_heirloom))
				heirloomCheck = hasQuirk
				break

		if(src == heirloomCheck.heirloom) //make sure jannies don't accidentally use their family heirlooms
			to_chat(user, "<span class='warning'>You wouldn't want to tamper with your heirloom [src.name]!<span>")
		else
			to_chat(user, "<span class='notice'>You add a [I.name] to the bottom of the [src.name].<span>")
			qdel(I)
			qdel(src)
			new /obj/item/clothing/suit/caution/incomplete(L, 1)

		return

	. = ..()

/obj/item/clothing/suit/caution/incomplete
	name = "\improper incomplete wet floor sign"
	slot_flags = 0

/obj/item/clothing/suit/caution/incomplete/attack_self(mob/user)
	to_chat(user, "<span class='warning'>You spin the buffer on the [src.name] with your finger. It won't activate unless you <i>attach a sensor</i> to it.<span>")

/obj/item/clothing/suit/caution/incomplete/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The [src.name] has a floor buffer underneath. You could <i>attach a sensor</i> to it, or <i>undo the screws</i> to remove it.</span>"

/obj/item/clothing/suit/caution/incomplete/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE

	var/atom/L = drop_location()
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You detatch the floor buffer from the [src.name].<span>")
	qdel(src)
	new /obj/item/clothing/suit/caution(L, 1)
	new /obj/item/janiupgrade(L, 1)
	return TRUE

/obj/item/clothing/suit/caution/incomplete/attackby(obj/item/I, mob/living/user)
	var/atom/L = drop_location()

	if(istype(I, /obj/item/janiupgrade))
		to_chat(user, "<span class='warning'>This [src.name] already has a device attatched to it.<span>")
		return

	if(istype(I, /obj/item/assembly/prox_sensor))
		to_chat(user, "<span class='notice'>You add a [I.name] to the floor buffer on the [src.name].<span>")
		qdel(I)
		qdel(src)
		var/obj/item/S = new /obj/item/clothing/suit/caution/slippery(L,1)
		if(prob(1)) //1% chance for a name
			S.name = pick("Ms. Lippy", "Mr. Walky", "Monitor Hallsky")

		return

	. = ..()

//old signs (only found in maint spawners)
/obj/item/caution/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/janiupgrade))
		to_chat(user, "<span class='warning'>The [src.name] is too antiquated to fit a [I.name], try a newer sign.<span>")
		return

	. = ..()

//end of construction code

//Wetmore Slippery Sign
//Constructable by janitors with upgrades from RND and sensors from cargo/robotics
//Slips people who don't heed the warning

//Wetmore Slippery Sign (traitor item)
//purchasable from traitor uplink by janitors (7tc for 4)
//in addition to slipping, also animates and kicks people around

/obj/item/clothing/suit/caution/slippery
	slot_flags = 0 //cannot be worn- or else it breaks stuff
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"

	var/willSlip = FALSE //false - disabled || true - enabled 
	var/lastSlip = 0 //last time the sign slipped someone (time)
	var/slipCooldown = 50 //cooldown (~5 seconds default)
	var/clowningAround = FALSE //false - untainted || true - clown got it
	var/evilSign = FALSE //false - normal sign || true - emagged or uplink
	var/mob/living/carbon/boss = null //used so animated signs don't attack the janitor

/obj/item/clothing/suit/caution/slippery/syndicate
	evilSign = TRUE //signs purchased from the uplink

/obj/item/clothing/suit/caution/slippery/examine(mob/user)
	. = ..()
	if(isobserver(user) || user.mind.assigned_role == "Janitor") //janitors and ghosts can see that it's a slippery sign
		. += "<span class='notice'>This [src.name] is outfitted with an experimental sprayer.</span>"
		if(clowningAround || evilSign)
			. += "<span class='warning'>It's been tampered with.</span>"
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns know lube when they see it
		. += "<span class='notice'>This [src.name] has great potential for pranks.</span>"

//when used by a janitor: toggles between active and disabled, when used by a clown, pranks ensue
/obj/item/clothing/suit/caution/slippery/attack_self(mob/user)
	if(!proximity_monitor)
		proximity_monitor = new(src, 1) //initializes the proximity: (source, range)

	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns.
		willSlip = TRUE 
		clowningAround = TRUE
		slipCooldown = 0
		to_chat(user, "<span class='warning'>The [src.name]'s lube sprayer has been overloaded.<span>")
	else if(user.mind.assigned_role == "Janitor") //only janitors can interact with it normally
		boss = user
		willSlip = !willSlip
		if(clowningAround) //so you can reset the sign if a clown messes with it
			clowningAround = FALSE
			slipCooldown = 50 

		if(willSlip)
			to_chat(user, "<span class='notice'>The [src.name] will now slip anyone running past.<span>")
		else
			to_chat(user, "<span class='notice'>The [src.name] will no longer slip passerbys.<span>")
	else
		to_chat(user, "<span class = 'notice'>The [src.name] requires a janitor to activate.<span>")

/obj/item/clothing/suit/caution/slippery/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/janiupgrade))
		to_chat(user, "<span class='warning'>This [src.name] already has a device attatched to it.<span>")
		return

	. = ..()

/obj/item/clothing/suit/caution/slippery/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE

	I.play_tool_sound(src)
	if(!evilSign)
		var/atom/L = drop_location()
		to_chat(user, "<span class='notice'>You detatch the device from the [src.name].<span>")
		qdel(src)
		new /obj/item/clothing/suit/caution(L, 1)
		new /obj/item/janiupgrade(L, 1)
		new /obj/item/assembly/prox_sensor(L, 1)
	else
		to_chat(user, "<span class='warning'>You can't seem to detatch the mechanism from the [src.name]...<span>")
		sleep(20)
		to_chat(user, "<span class='boldwarning'>Wait, is it shaking?<span>")
		awakenSign(user)

	return TRUE

/obj/item/clothing/suit/caution/slippery/HasProximity(atom/movable/AM)
	if (world.time < lastSlip + slipCooldown && lastSlip) //cooldown for slipping
		return

	if(!willSlip) //needs to be enabled to slip people obviously
		return

	if(!iscarbon(AM)) //is it actually a thing we can slip?
		return

	var/mob/living/carbon/C = AM
	var/turf/open/T = get_turf(src)

	//are they not walking? & are they not the janitor? & are they not being pulled? & either [is it evil or are they not already slipped]?
	if(C.m_intent != MOVE_INTENT_WALK && C != boss && !(C.pulledby) && (evilSign || !(C.IsKnockdown()))) 
		lastSlip = world.time
		say("Caution, wet floor.")

		//make own turf and all adjacent turfs lubed for a bit
		if(clowningAround) 
			playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
			T.MakeSlippery(TURF_WET_SUPERLUBE, 10)
		else
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
			T.MakeSlippery(TURF_WET_LUBE, 10)

		for(var/turf/open/AT in get_adjacent_open_turfs(T))
			AT.MakeSlippery(TURF_WET_LUBE, 10)

		//cry havoc and let slip the signs of wet
		if(evilSign)
			awakenSign(AM)

/obj/item/clothing/suit/caution/slippery/proc/awakenSign(mob/living/victim) //makes the sign shake a bit, then animate
	willSlip = FALSE //this kills the sign

	if(victim == boss) //if the owner of the sign tries to fuck with it, it'll betray them
		boss = null

	//Shaking animation from His Grace, for effect
	var/static/list/transforms
	if(!transforms)
		var/matrix/M1 = matrix()
		var/matrix/M2 = matrix()
		var/matrix/M3 = matrix()
		var/matrix/M4 = matrix()
		M1.Translate(-1, 0)
		M2.Translate(0, 1)
		M3.Translate(1, 0)
		M4.Translate(0, -1)
		transforms = list(M1, M2, M3, M4)
	animate(src, transform=transforms[1], time=0.2, loop=-1)
	animate(transform=transforms[2], time=0.1)
	animate(transform=transforms[3], time=0.2)
	animate(transform=transforms[4], time=0.3)

	addtimer(CALLBACK(victim, /mob/proc/transferItemToLoc, src, drop_location(), TRUE, FALSE, 10)) //force it out of their bag or hands
	addtimer(CALLBACK(src, /atom/proc/animate_atom_living, boss), 10) //animates after 1 second
	addtimer(CALLBACK(src, .proc/stopShaking), 50) //stops the animation after 5 seconds 

/obj/item/clothing/suit/caution/slippery/proc/stopShaking() //stop the shaking
	animate(src, transform=matrix())

/obj/item/clothing/suit/caution/slippery/emag_act(mob/user) //bypasses the requirement of janitor or clumsy and turns it into an evil sign 
	if(!proximity_monitor)
		proximity_monitor = new(src, 1) 

	willSlip = TRUE //bypasses the janitor requirement
	if(!evilSign)
		evilSign = TRUE
		boss = user	
		to_chat(user, "<span class='boldwarning'>The [src.name] begins to shake subtly.<span>")	
	else
		to_chat(user, "<span class='warning'>The [src.name] is already tampered with.<span>")	


//box of 4 wetmore slippery signs- for the traitor uplink
/obj/item/storage/box/syndie_kit/box_of_Signs

/obj/item/storage/box/syndie_kit/box_of_Signs/PopulateContents()
	for(var/i = 0, i < 4, i++)
		new /obj/item/clothing/suit/caution/slippery/syndicate(src) 

//DIY Slippery sign kit for the janidrobe - instructions on how to build and some example signs, to get janitors started
/obj/item/storage/box/slipperySignKit
	name = "DIY Slippery Sign Kit"
	desc = "Contains everything you need to build (or disassemble) two Wetmore Slippery Signs."
	custom_price = 1000

/obj/item/storage/box/slipperySignKit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/clothing/suit/caution = 2,
		/obj/item/janiupgrade = 2,
		/obj/item/assembly/prox_sensor = 2,
		/obj/item/screwdriver = 1,
		/obj/item/paper/guides/slipperySignDIY = 1)
	generate_items_inside(items_inside,src)

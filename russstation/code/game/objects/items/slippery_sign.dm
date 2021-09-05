/**
 * Construction of a Wetmore slippery sign:
 *
 * 1) Obtain a wet floor sign (Cargo, Plastic [Chemistry/Cargo] or JaniDrobe)
 * 2) Apply floor buffer to sign (Service Techfab)
 * 3) Apply Proximity Sensor to sign (Robotics/Cargo)
 */

/obj/item/clothing/suit/caution/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade))
		var/datum/quirk/item_quirk/family_heirloom/heirloom_check

		//checks all their quirks for the family heirloom quirk- so we can check if they have a wet floor sign heirloom later
		for(var/datum/quirk/has_quirk in user.quirks)
			if(istype(has_quirk, /datum/quirk/item_quirk/family_heirloom))
				heirloom_check = has_quirk
				break

		if(heirloom_check?.heirloom == src) //make sure jannies don't accidentally use their family heirlooms (cause it'll qdel it)
			to_chat(user, "<span class='warning'>You wouldn't want to tamper with your heirloom!</span>")
			return

		user.visible_message("<span class='notice'>[user.name] adds \a [item.name] to the bottom of \the [name].</span>", \
							"<span class='notice'>You add \the [item.name] to the bottom of \the [name].</span>")
		var/obj/item/new_sign = new /obj/item/clothing/suit/caution/incomplete(loc, 1)
		qdel(item)
		qdel(src)
		if(!isturf(new_sign.loc))
			if(!user.put_in_inactive_hand(new_sign)) //tries to put it in the inactive hand first, and if it fails...
				user.put_in_hands(new_sign) //tries to put it in whatever hand it can find, and if that fails, it drops to the ground
		return

	. = ..()

/obj/item/clothing/suit/caution/incomplete
	name = "\improper incomplete wet floor sign"
	slot_flags = 0

/obj/item/clothing/suit/caution/incomplete/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You spin the buffer on the [name] with your finger. It won't activate unless you <i>attach a sensor</i> to it.</span>")

/obj/item/clothing/suit/caution/incomplete/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The [name] has a floor buffer attatched underneath. You could <i>attach a sensor</i> to it, or <i>undo the screws</i> to remove it.</span>"

/obj/item/clothing/suit/caution/incomplete/screwdriver_act(mob/living/user, obj/item/item)
	if(..())
		return TRUE

	var/atom/L = drop_location()
	item.play_tool_sound(src)
	user.visible_message("<span class='notice'>[user.name] detatches the floor buffer from \the [name].</span>", \
						"<span class='notice'>You detatch the floor buffer from \the [name].</span>", \
						"<span class='hear'>You hear a screwdriver and a click.</span>")
	qdel(src)
	new /obj/item/clothing/suit/caution(L, 1)
	new /obj/item/janicart_upgrade(L, 1)
	return TRUE

/obj/item/clothing/suit/caution/incomplete/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade))
		to_chat(user, "<span class='notice'>This [name] already has a floor buffer attatched to it.</span>")
		return

	if(istype(item, /obj/item/assembly/prox_sensor))
		user.visible_message("<span class='notice'>[user.name] adds \a [item.name] to the floor buffer on \the [name].</span>", \
							"<span class='notice'>You add \the [item.name] to the floor buffer on \the [name].</span>")
		var/obj/item/new_sign = new /obj/item/clothing/suit/caution/slippery(loc, 1)
		qdel(item)
		qdel(src)
		if(prob(1)) //1% chance for a name
			new_sign.name = pick("Ms. Lippy", "Mr. Walky", "Monitor Hallsky")
		if(!isturf(new_sign.loc))
			if(!user.put_in_inactive_hand(new_sign))
				user.put_in_hands(new_sign)
		return

	. = ..()

//old signs (only found in maint spawners)
/obj/item/caution/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade))
		to_chat(user, "<span class='warning'>The [name] is too antiquated to fit a [item.name], try a newer model sign.</span>")
		return

	. = ..()

//tablecrafting recipe option
/datum/crafting_recipe/slippery_sign
	name = "Wetmore Slippery Sign"
	result = /obj/item/clothing/suit/caution/slippery
	time = 3 SECONDS
	reqs = list(
		/obj/item/janicart_upgrade = 1,
		/obj/item/assembly/prox_sensor = 1,
		/obj/item/clothing/suit/caution = 1,
	)
	blacklist = list(
		/obj/item/clothing/suit/caution/incomplete,
		/obj/item/clothing/suit/caution/slippery,
	)
	category = CAT_MISC

//end of construction code

/**
 *	Wetmore Slippery Sign
 *
 *	Constructable by janitors with upgrades from RND and sensors from cargo/robotics
 *	Slips people who don't heed the warning
 *
 *	-- Traitor version purchasable from Janitor Traitor uplinks (7 TC for 4)
 *	In addition to slipping, also animates and kicks people around.
 */

/obj/item/clothing/suit/caution/slippery
	slot_flags = 0 //cannot be worn- or else it breaks stuff
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	req_access = list(ACCESS_JANITOR)
	req_access_txt = "26"

	///Will we slip?
	var/will_slip = FALSE
	///Last time the sign slipped someone (time)
	var/last_slip = 0
	///Cooldown timer
	var/slip_cooldown = 5 SECONDS
	///If this is set to True, the clown has gotten their hands on this.
	var/clowning_around = FALSE
	///Are we an evil sign? Emagged/Uplink purchased ones are.
	var/evil_sign = FALSE
	///Used so animated signs don't attack the janitor
	var/mob/living/carbon/boss = null

/obj/item/clothing/suit/caution/slippery/syndicate
	evil_sign = TRUE //signs purchased from the uplink

/obj/item/clothing/suit/caution/slippery/examine(mob/user)
	. = ..()
	if(isobserver(user) || user.mind.assigned_role == "Janitor") //true janitors and ghosts can see that it's a slippery sign
		. += "<span class='notice'>This [name] is outfitted with an experimental lube sprayer. <i>Activate it in your hand to enable it.</i></span>"
		if(clowning_around || evil_sign)
			. += "<span class='warning'>It's been tampered with.</span>"
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns know lube when they see it
		. += "<span class='notice'>This [name] has great potential for pranks.</span>"

//when used by a janitor: toggles between active and disabled, when used by a clown, pranks ensue
/obj/item/clothing/suit/caution/slippery/attack_self(mob/user)
	if(!proximity_monitor)
		proximity_monitor = new(src, 1) //initializes the proximity: (source, range)

	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clumsy people can overload it (clowns, etc)
		will_slip = TRUE
		clowning_around = TRUE
		slip_cooldown = 1 SECONDS
		to_chat(user, "<span class='warning'>\The [name]'s lube sprayer has been overloaded.</span>")
	else if((user.mind.assigned_role == "Janitor") || allowed(user)) //janitors at heart and janitor access can interact wiht it
		boss = user
		will_slip = !will_slip
		if(clowning_around) //so you can reset the sign if a clown messes with it
			to_chat(user, "<span class='notice'>You repair \the [name]'s lube sprayer.</span>")
			clowning_around = FALSE
			slip_cooldown = 5 SECONDS

		to_chat(user, "<span class='notice'>\The [name] will [will_slip? "now" : "no longer"] slip anyone running past.</span>")
	else
		to_chat(user, "<span class = 'notice'>\The [name] requires a janitor to activate.</span>")

/obj/item/clothing/suit/caution/slippery/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade))
		to_chat(user, "<span class='notice'>This [name] already has a device attatched to it.</span>")
		return
	. = ..()

/obj/item/clothing/suit/caution/slippery/screwdriver_act(mob/living/user, obj/item/item)
	. = ..()
	if(.)
		return TRUE

	item.play_tool_sound(src)
	if(!evil_sign)
		var/atom/L = drop_location()
		user.visible_message("<span class='notice'>[user.name] detatches the a device from \the [name].</span>", \
							"<span class='notice'>You detatch the device from \the [name].</span>", \
							"<span class='hear'>You hear a screwdriver and a click.</span>")
		qdel(src)
		new /obj/item/clothing/suit/caution(L, 1)
		new /obj/item/janicart_upgrade(L, 1)
		new /obj/item/assembly/prox_sensor(L, 1)
	else
		to_chat(user, "<span class='warning'>You can't seem to detatch the mechanism from \the [name]...</span>")
		sleep(2 SECONDS)
		awaken_sign(user)
	return TRUE

/obj/item/clothing/suit/caution/slippery/HasProximity(atom/movable/AM)
	if(world.time < last_slip + slip_cooldown) //cooldown for slipping
		return

	if(!will_slip) //needs to be enabled to slip people obviously
		return

	if(!iscarbon(AM)) //is it actually a thing we can slip?
		return

	if(!isturf(loc)) //are we not on the ground?
		return

	if(pulledby) //if we're being pulled, don't slip people (it was funny for a bit)
		return

	var/mob/living/carbon/C = AM
	var/turf/open/T = get_turf(src)

	//are they not walking? & are they not the activator? & are they not being pulled? & either [is it evil or are they not already slipped]?
	if(C.m_intent != MOVE_INTENT_WALK && C != boss && !(C.pulledby) && (evil_sign || !(C.IsKnockdown())))
		last_slip = world.time
		say("Caution, wet floor.")

		//make own turf and all adjacent turfs lubed for a bit
		if(clowning_around)
			playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
			T.MakeSlippery(TURF_WET_SUPERLUBE, 1 SECONDS, 1 SECONDS, 3 SECONDS)
		else
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
			T.MakeSlippery(TURF_WET_LUBE, 1 SECONDS, 1 SECONDS, 3 SECONDS)

		for(var/turf/open/AT in get_adjacent_open_turfs(T))
			AT.MakeSlippery(TURF_WET_LUBE, 1 SECONDS, 1 SECONDS, 3 SECONDS)

		//cry havoc and let slip the signs of wet
		if(evil_sign)
			awaken_sign(C)

/*
 * makes the sign shake a bit, then animate
 * arguments - victim is the mob triggering the sign
 */
/obj/item/clothing/suit/caution/slippery/proc/awaken_sign(mob/living/victim)
	if(victim && victim == boss) //if the owner of the sign tries to fuck with it, it'll betray them
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

	visible_message("<span class='boldwarning'>\The [name] begins to shake violently.</span>", \
					"<span class='boldwarning'>\The [name] begins to shake violently.</span>", \
					"<span class='hear'>You hear mechanical whirring.</span>")
	will_slip = FALSE
	sleep(1 SECONDS)
	stopShaking()
	if(!isturf(loc))
		if(!victim?.temporarilyRemoveItemFromInventory(src) || !forceMove(drop_location())) //forces the sign onto the ground before animating it
			to_chat(victim, "<span class='notice'>I guess it was nothing.</span>")
			return
	src.animate_atom_living(boss)

/*
 * stop the shaking animation
 */
/obj/item/clothing/suit/caution/slippery/proc/stopShaking()
	animate(src, transform=matrix())

/*
 * bypasses the requirement of janitor or clumsy and turns it into an evil sign
 */
/obj/item/clothing/suit/caution/slippery/emag_act(mob/user)
	if(!proximity_monitor)
		proximity_monitor = new(src, 1)

	will_slip = TRUE //bypasses the janitor requirement
	if(!evil_sign)
		evil_sign = TRUE
		boss = user
		visible_message("<span class='warning'>\The [name] begins to shake subtly.</span>", \
						"<span class='warning'>\The [name] begins to shake subtly.</span>", \
						"<span class='hear'>You hear mechanical whirring.</span>")
	else
		to_chat(user, "<span class='warning'>\The [name] is already tampered with.</span>")


//box of 4 wetmore slippery signs- for the traitor uplink
/obj/item/storage/box/syndie_kit/box_of_signs/PopulateContents()
	new /obj/item/book/granter/action/origami(src)
	for(var/i in 1 to 4)
		new /obj/item/clothing/suit/caution/slippery/syndicate(src)

//DIY Slippery sign kit for the janidrobe - instructions on how to build and some example signs, to get janitors started
/obj/item/storage/box/slippery_sign_kit
	name = "\improper DIY Slippery Sign Kit"
	desc = "Contains everything you need to build two Wetmore Slippery Signs."
	custom_premium_price = 1200

/obj/item/storage/box/slippery_sign_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/clothing/suit/caution = 2,
		/obj/item/janicart_upgrade = 2,
		/obj/item/assembly/prox_sensor = 2,
		/obj/item/paper/guides/slippery_sign_DIY = 1)
	generate_items_inside(items_inside,src)

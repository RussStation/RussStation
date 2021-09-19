/**
 * Construction of a Wetmore slippery sign:
 *
 * 1) Obtain a wet floor sign (Cargo, Plastic [Chemistry/Cargo] or JaniDrobe)
 * 2) Apply floor buffer to sign (Service Techfab)
 * 3) Apply Proximity Sensor to sign (Robotics/Cargo)
 */

/obj/item/clothing/suit/caution/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade/buffer))
		var/datum/quirk/item_quirk/family_heirloom/heirloom_check

		//checks all their quirks for the family heirloom quirk- so we can check if they have a wet floor sign heirloom later
		for(var/datum/quirk/has_quirk in user.quirks)
			if(istype(has_quirk, /datum/quirk/item_quirk/family_heirloom))
				heirloom_check = has_quirk
				break

		if(heirloom_check?.heirloom == src) //make sure jannies don't accidentally use their family heirlooms (cause it'll qdel it)
			to_chat(user, span_warning("You wouldn't want to tamper with your heirloom!"))
			return

		user.visible_message(
			span_notice("[user.name] adds \a [item.name] to the bottom of \the [name]."),
			span_notice("You add \the [item.name] to the bottom of \the [name]."),
		)
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
	to_chat(user, span_notice("You spin the buffer on the [name] with your finger. It won't activate unless you <i>attach a sensor</i> to it."))

/obj/item/clothing/suit/caution/incomplete/examine(mob/user)
	. = ..()
	. += span_notice("The [name] has a floor buffer attatched underneath. You could <i>attach a sensor</i> to it, or <i>undo the screws</i> to remove it.")

/obj/item/clothing/suit/caution/incomplete/screwdriver_act(mob/living/user, obj/item/item)
	if(..())
		return TRUE

	var/atom/L = drop_location()
	item.play_tool_sound(src)
	user.visible_message(
		span_notice("[user.name] detatches the floor buffer from \the [name]."),
		span_notice("You detatch the floor buffer from \the [name]."),
		span_hear("You hear a screwdriver and a click."),
	)
	qdel(src)
	new /obj/item/clothing/suit/caution(L, 1)
	new /obj/item/janicart_upgrade/buffer(L, 1)
	return TRUE

/obj/item/clothing/suit/caution/incomplete/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade/buffer))
		to_chat(user, span_notice("This [name] already has a floor buffer attatched to it."))
		return

	if(istype(item, /obj/item/assembly/prox_sensor))
		user.visible_message(
			span_notice("[user.name] adds \a [item.name] to the floor buffer on \the [name]."),
			span_notice("You add \the [item.name] to the floor buffer on \the [name]."),
		)
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
	if(istype(item, /obj/item/janicart_upgrade/buffer))
		to_chat(user, span_warning("The [name] is too antiquated to fit a [item.name], try a newer model sign."))
		return

	. = ..()

//tablecrafting recipe option
/datum/crafting_recipe/slippery_sign
	name = "Wetmore Slippery Sign"
	result = /obj/item/clothing/suit/caution/slippery
	time = 3 SECONDS
	reqs = list(
		/obj/item/janicart_upgrade/buffer = 1,
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
		. += span_notice("This [name] is outfitted with an experimental lube sprayer. <i>Activate it in your hand to enable it.</i>")
		if(clowning_around || evil_sign)
			. += span_warning("It's been tampered with.")
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clowns know lube when they see it
		. += span_notice("This [name] has great potential for pranks.")

//when used by a janitor: toggles between active and disabled, when used by a clown, pranks ensue
/obj/item/clothing/suit/caution/slippery/attack_self(mob/user)
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clumsy people can overload it (clowns, etc)
		will_slip = TRUE
		clowning_around = TRUE
		slip_cooldown = 1 SECONDS
		to_chat(user, span_warning("\The [name]'s lube sprayer has been overloaded."))
	else if((user.mind.assigned_role == "Janitor") || allowed(user)) //janitors at heart and janitor access can interact wiht it
		boss = user
		will_slip = !will_slip
		if(clowning_around) //so you can reset the sign if a clown messes with it
			to_chat(user, span_notice("You repair \the [name]'s lube sprayer."))
			clowning_around = FALSE
			slip_cooldown = 5 SECONDS

		// Check if we're set to slip, if so, make us slippery. If not, remove it.
		if(will_slip)
			AddComponent(/datum/component/slippery, 80, NO_SLIP_WHEN_WALKING, CALLBACK(src, .proc/AfterSlip))
		else
			qdel(GetComponent(/datum/component/slippery))
		to_chat(user, span_notice("\The [name] will [will_slip? "now" : "no longer"] slip anyone running past."))
	else
		to_chat(user, span_notice("\The [name] requires a janitor to activate."))

/obj/item/clothing/suit/caution/slippery/proc/AfterSlip(mob/living/carbon/human/victim)
	if(world.time < last_slip + slip_cooldown) //cooldown for slipping
		return

	last_slip = world.time
	say("Caution, wet floor.")

	var/turf/open/current_turf = get_turf(src)

	//make own turf and all adjacent turfs lubed for a bit
	if(clowning_around)
		playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
		current_turf.MakeSlippery(TURF_WET_SUPERLUBE, 1 SECONDS, 1 SECONDS, 3 SECONDS)
	else
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		current_turf.MakeSlippery(TURF_WET_LUBE, 1 SECONDS, 1 SECONDS, 3 SECONDS)

	for(var/turf/open/adjacent_turfs in get_adjacent_open_turfs(current_turf))
		adjacent_turfs.MakeSlippery(TURF_WET_LUBE, 1 SECONDS, 1 SECONDS, 3 SECONDS)

	//cry havoc and let slip the signs of wet
	if(evil_sign)
		awaken_sign(victim)

/obj/item/clothing/suit/caution/slippery/attackby(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/janicart_upgrade/buffer))
		to_chat(user, span_notice("This [name] already has a device attatched to it."))
		return
	. = ..()

/obj/item/clothing/suit/caution/slippery/screwdriver_act(mob/living/user, obj/item/item)
	. = ..()
	if(.)
		return TRUE

	item.play_tool_sound(src)
	if(!evil_sign)
		var/atom/L = drop_location()
		user.visible_message(
			span_notice("[user.name] detatches the a device from \the [name]."),
			span_notice("You detatch the device from \the [name]."),
			span_hear("You hear a screwdriver and a click."),
		)
		qdel(src)
		new /obj/item/clothing/suit/caution(L, 1)
		new /obj/item/janicart_upgrade/buffer(L, 1)
		new /obj/item/assembly/prox_sensor(L, 1)
	else
		to_chat(user, span_warning("You can't seem to detatch the mechanism from \the [name]..."))
		addtimer(CALLBACK(src, .proc/awaken_sign, user), 2 SECONDS)
	return TRUE

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

	visible_message(
		span_boldwarning("\The [name] begins to shake violently."),
		span_boldwarning("\The [name] begins to shake violently."),
		span_hear("You hear mechanical whirring."),
	)
	will_slip = FALSE
	addtimer(CALLBACK(src, .proc/end_awaken, victim), 1 SECONDS)

/*
 * called at the end of an awakening
 */
/obj/item/clothing/suit/caution/slippery/proc/end_awaken(mob/living/victim)
	stop_shaking()
	if(!isturf(loc))
		if(!victim?.temporarilyRemoveItemFromInventory(src) || !forceMove(drop_location())) //forces the sign onto the ground before animating it
			to_chat(victim, span_notice("I guess it was nothing."))
			return

	src.animate_atom_living(boss)

/*
 * stop the shaking animation
 */
/obj/item/clothing/suit/caution/slippery/proc/stop_shaking()
	animate(src, transform=matrix())

/*
 * bypasses the requirement of janitor or clumsy and turns it into an evil sign
 */
/obj/item/clothing/suit/caution/slippery/emag_act(mob/user)
	// Only add the component if it isn't already set to slip - This bypasses the Janitor requirement.
	if(!will_slip)
		AddComponent(/datum/component/slippery, 80, NO_SLIP_WHEN_WALKING, CALLBACK(src, .proc/AfterSlip))
		will_slip = TRUE
	if(!evil_sign)
		evil_sign = TRUE
		boss = user
		visible_message(
			span_warning("\The [name] begins to shake subtly."),
			span_warning("\The [name] begins to shake subtly."),
			span_hear("You hear mechanical whirring."),
		)
	else
		to_chat(user, span_warning("\The [name] is already tampered with."))


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
		/obj/item/janicart_upgrade/buffer = 2,
		/obj/item/assembly/prox_sensor = 2,
		/obj/item/paper/guides/slippery_sign_DIY = 1)
	generate_items_inside(items_inside,src)

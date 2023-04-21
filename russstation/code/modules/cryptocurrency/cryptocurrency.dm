// Cryptocurrency mining module
// Contains machines and apps for turning power into money

// board for base rig - nothing too bad but you won't get much for spamming these
/obj/item/circuitboard/machine/crypto_mining_rig
	name = "Crypto Mining Rig (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/crypto_mining_rig
	needs_anchored = FALSE
	req_components = list(
		// graphics cards aren't required to construct
		/obj/item/reagent_containers/cup = 1, // for coolant
		/obj/item/pickaxe = 1, // haha mining
		/obj/item/stack/cable_coil = 5)

// design for printing the boards at a lathe once they're researched
/datum/design/board/crypto_mining_rig
	name = "Machine Design (Crypto Mining Rig)"
	desc = "Allows for the construction of circuit boards used to build a crypto mining rig."
	id = "crypto_mining_rig"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 1000)
	build_path = /obj/item/circuitboard/machine/crypto_mining_rig
	category = list ("Engineering Machinery")
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

// a machine for mining them coins. highly derivative of power sinks and space heaters.
// going long with the name to avoid any confusion with normal mining.
/obj/machinery/crypto_mining_rig
	name = "mining rig"
	icon = 'russstation/icons/obj/machines/cryptocurrency.dmi'
	icon_state = "mining_rig_2_off" // for preview in techweb
	base_icon_state = "mining_rig"
	desc = "A computer purpose-built for cryptocurrency mining."
	density = TRUE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION
	use_power = NO_POWER_USE // power use is manually handled
	circuit = /obj/item/circuitboard/machine/crypto_mining_rig
	// how many graphics cards are in the rig
	var/card_count = 0
	// exactly what it says
	var/on = FALSE
	// how much overclock is requested
	var/overclock_amount = 0
	// how much extra power can be requested (on top of active_power_usage)
	var/max_overclock = 0
	// a cable powernet we can pull big power from (APCs why you gotta fail me)
	var/obj/structure/cable/wired_power

	// internal calculation numbers cached for troubleshooting performance
	// how much power is actually used each process
	var/power_consumed = 0
	// how hot the machine was on last process
	var/temperature = 0
	// how much temperature is affecting performance
	var/temperature_index = 0
	// how much we can safely overclock
	var/coolant_factor = 0
	// how much mining progress we produced
	var/progress = 0

	// not-quite-consts are static so you can varedit all machines at once
	// how many cards can be inserted max
	var/static/max_cards = 4
	// if power consumption is below this, we can stop processing it. non-zero to catch fractions sitting around
	var/static/min_power_to_process = 1
	// if progress is less than this, round down to 0 (bad overclock produces tiny fractions)
	var/static/min_progress_to_process = 0.1
	// operating near this temperature provides a very nice bonus
	var/static/ideal_temperature = 69
	// how much coolant used per cycle
	var/static/coolant_consumption = 0.05
	// valid coolants and their bonus factors
	var/static/list/coolants = list(
		/datum/reagent/water = 0.3,
		/datum/reagent/cryostylane = 0.7,
		/datum/reagent/super_coolant = 1.0
	)

/obj/machinery/crypto_mining_rig/Initialize(mapload)
	if(!id_tag)
		id_tag = assign_random_name(8)
	. = ..()
	create_reagents(50, OPENCONTAINER) // size adjusted in RefreshParts
	AddComponent(/datum/component/plumbing/simple_demand)
	AddComponent(/datum/component/simple_rotation)
	SScryptocurrency.machines += src

/obj/machinery/crypto_mining_rig/update_name(updates)
	. = ..()
	name = "\proper [initial(name)] [id_tag]"

/obj/machinery/crypto_mining_rig/examine(mob/user)
	. = ..()
	. += "Its card slots contain:"
	if(card_count > 0)
		for(var/obj/item/electronics/crypto_mining_card/card in contents)
			if(istype(card))
				. += "&bull; \A [card.name]"
		. += span_notice("Use a <b>screwdriver</b> to remove the cards.")
	else
		. += "Nothing."
	if(anchored)
		. += "\The [src] is <b>bolted</b> to the floor and is [on ? "on" : "off"]. [wired_power ? "It is connected to wired power." : ""]"
	if(isobserver(user))
		// for debugging, perform the tool inspections for ghosts
		. += "The temperature of \the [src] reads [temperature]K. Its coolant factor is [coolant_factor] and temperature bonus is [temperature_index]."
		. += "The power usage of \the [src] reads [power_consumed]W. It is contributing [progress] work units per cycle."

/obj/machinery/crypto_mining_rig/Destroy()
	SScryptocurrency.machines.Remove(src)
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/crypto_mining_rig/update_icon_state()
	. = ..()
	// das blinkenlights
	icon_state = "[base_icon_state]_[card_count]_[on ? "on" : "off"]"

// right click shortcut to turn on/off without using UI
/obj/machinery/crypto_mining_rig/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!anchored)
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	change_on(!on)
	user.visible_message( \
		span_notice("[user] switches [on ? "on" : "off"] \the [src]."), \
		span_notice("You switch [on ? "on" : "off"] \the [src]."), \
		span_hear("You hear a click."))
	add_fingerprint(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/crypto_mining_rig/proc/change_on(new_on)
	on = new_on
	update_appearance()
	if (on)
		START_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)
		// zero out some numbers for better display when machine is off
		progress = 0
	// check for cable connection
	var/turf/here = loc
	if(isturf(here) && here.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
		wired_power = locate() in here
	else
		wired_power = null

/obj/machinery/crypto_mining_rig/attackby(obj/item/thing, mob/user, params)
	if(istype(thing, /obj/item/electronics/crypto_mining_card))
		if(on)
			to_chat(user, span_warning("You need to turn \the [src] off to mess with its cards!"))
		else if(card_count < max_cards)
			// add card if there's room
			thing.forceMove(src)
			card_count += 1
			contents += thing
			user.visible_message( \
				span_notice("[user] pops \the [thing] into \the [src]."), \
				span_notice("You pop \the [thing] into \the [src]."), \
				span_hear("You hear the satisfying click of a card popping into a PCIe slot. Nice."))
			update_appearance()
			RefreshParts()
		else
			to_chat(user, span_warning("\The [src] is already full of cards! Remove some first with a screwdriver."))
	else
		return ..()

/obj/machinery/crypto_mining_rig/analyzer_act(mob/living/user, obj/item/tool)
	// get temp and atmos related info
	to_chat(user, span_notice("The temperature of \the [src] reads [temperature]K. Its coolant factor is [coolant_factor] and temperature bonus is [temperature_index]."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/multitool_act(mob/living/user, obj/item/tool)
	// display other info about the machine
	to_chat(user, span_notice("The power usage of \the [src] reads [power_consumed]W. It is contributing [progress] work units per cycle."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/crowbar_act(mob/living/user, obj/item/tool)
	if(on)
		to_chat(user, span_warning("You need to turn \the [src] off to deconstruct it!"))
	else
		tool.play_tool_sound(src, 50)
		deconstruct(TRUE)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/screwdriver_act(mob/living/user, obj/item/tool)
	if(on)
		to_chat(user, span_warning("You need to turn \the [src] off to mess with its cards!"))
	else if(card_count > 0)
		// i don't want to make an interface for removing/replacing individual cards, dump em all
		for(var/obj/item/electronics/crypto_mining_card/card in contents)
			if(istype(card))
				card.forceMove(loc)
		card_count = 0
		user.visible_message( \
			span_notice("[user] pops the cards out of \the [src]."), \
			span_notice("You pop out the cards in \the [src]."), \
			span_hear("You hear expensive hardware falling on the ground."))
		tool.play_tool_sound(src, 50)
		update_appearance()
		RefreshParts()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
	if(isAdminGhostAI(user))
		// admin ghosts can interact
		attack_hand(user, list())

/obj/machinery/crypto_mining_rig/wrench_act(mob/living/user, obj/item/tool)
	if(!anchored)
		if(default_unfasten_wrench(user, tool))
			user.visible_message( \
				span_notice("[user] attaches \the [src] to the floor."), \
				span_notice("You bolt \the [src] into the floor."),
				span_hear("You hear a something stupid being wrenched."))
	else if(default_unfasten_wrench(user, tool))
		change_on(FALSE)
		user.visible_message( \
			"[user] detaches \the [src] from the floor.", \
			span_notice("You unbolt \the [src] from the floor."),
			span_hear("You hear something stupid being wrenched."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

// drain power from the connected powernet and get money
/obj/machinery/crypto_mining_rig/process(seconds_per_tick)
	// if we aren't on and working, obviously stop. also if we're in a no-no area (no free power for you)
	var/area/area = get_area(src)
	if(!on || machine_stat & BROKEN || (!wired_power && !powered(AREA_USAGE_EQUIP, TRUE)) || !area.requires_power || !SScryptocurrency.can_fire)
		change_on(FALSE)
		return PROCESS_KILL

	// check coolant levels and quality (0 to 1)
	coolant_factor = 0
	for(var/coolant in coolants)
		if(reagents.has_reagent(coolant))
			// measure how much of the reagents are our coolant: presence of other stuff impairs function
			var/proportion = reagents.get_reagent_amount(coolant) / reagents.total_volume
			// purity affects performance too
			var/purity = reagents.get_reagent_purity(coolant)
			// combine factors including the coolant's factor
			coolant_factor += proportion * purity * coolants[coolant]
	if(overclock_amount > 0)
		// consume a fraction of coolant from evaporation
		reagents.remove_all(coolant_consumption)

	// coolant factor determines optimal overclock
	var/optimal_overclock = max_overclock * coolant_factor
	// going over optimal wastes power and hampers performance
	var/overclock_penalty = 1
	if(overclock_amount > optimal_overclock)
		var/overclock_diff = overclock_amount - optimal_overclock
		// a number that quickly becomes punishing
		overclock_penalty = (overclock_diff + 1000) / 1000

	// get the ambient gas for processing
	var/datum/gas_mixture/environment = loc.return_air()
	// check temperature to see how efficiently the machine operates in this environment
	temperature = environment.temperature
	// temperature index is (0, 2) with 1 as baseline rate for most temperatures below 100 deg
	if(temperature > 100)
		// approaches 0 as temperature rises, more drastically at first (about 0.5 at 240 deg)
		// sorry for magic numbers; i just plugged numbers until i found a curve i liked
		temperature_index = (NUM_E ** (-0.005 * (temperature - 560))) / 10
	else
		// bonus approaches 2 as temperature approaches ideal, falls off to a flatline within +/- 10 deg
		temperature_index = 1 + NUM_E ** (-(((temperature - ideal_temperature) / 5) ** 2))
	// being near ideal temp can up to double the power usage and consequently progress produced
	power_consumed = (active_power_usage + overclock_amount) * temperature_index
	// draw from wired powernet if connected, otherwise APC
	if(wired_power)
		var/avail = wired_power.surplus()
		if(avail > power_consumed)
			wired_power.add_load(power_consumed)
		else if(avail > 0)
			// eat the scraps
			power_consumed = avail
		else
			// no power, turn off
			change_on(FALSE)
			return
	else
		use_power(power_consumed)

	// progress is how much power was used and not penalized
	var/raw_progress = power_consumed / overclock_penalty
	if(raw_progress < min_progress_to_process)
		raw_progress = 0
	// adjust progress based on an exponent so individual rigs are better than many with the same power draw
	progress = raw_progress / 1.5 + (raw_progress / 500) ** 2
	// mine dat fukken coin
	var/result = SScryptocurrency.mine(progress)
	// announce result when finishing a mining unit
	if(result)
		// don't spam with says because it fills log and assholes will put it on radio
		// ripped out the runechat part of an audible message since it's not standalone
		var/list/hearers = get_hearers_in_view(4, src)
		for(var/mob/M in hearers)
			if(runechat_prefs_check(M) && M.can_hear())
				M.create_chat_message(src, get_selected_language(), result)

	// apply heat to environment
	var/delta_temperature = power_consumed / environment.heat_capacity()
	if(delta_temperature)
		environment.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)

/obj/machinery/crypto_mining_rig/RefreshParts()
	. = ..()
	// graphics cards for real gamer hours
	var/energy_rating = 1
	var/overclock_rating = 0
	for(var/obj/item/electronics/crypto_mining_card/card in contents)
		energy_rating += card.energy_rating
		overclock_rating += card.overclock_rating
	active_power_usage = initial(active_power_usage) * energy_rating
	max_overclock = initial(active_power_usage) * overclock_rating
	if(overclock_rating > max_overclock)
		overclock_rating = max_overclock
	// upgradeable coolant reservoir
	var/volume = 0
	for(var/obj/item/reagent_containers/reservoir in component_parts)
		volume += reservoir.reagents.maximum_volume
	if(!reagents)
		create_reagents(volume, OPENCONTAINER)
	reagents.maximum_volume = volume

// basic UI for rig settings; does *not* include all the data readouts
// think of it like a real simple LCD that can't fit much
/obj/machinery/crypto_mining_rig/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryptoMiningRig", name)
		ui.open()

/obj/machinery/crypto_mining_rig/ui_data()
	var/data = list()
	data["on"] = on
	data["max_coolant"] = round(reagents.maximum_volume)
	data["coolant_amount"] = round(reagents.total_volume)
	data["max_overclock"] = round(max_overclock)
	data["overclock_amount"] = round(overclock_amount)
	return data

/obj/machinery/crypto_mining_rig/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("power")
			change_on(!on)
			user.visible_message( \
				span_notice("[user] switches [on ? "on" : "off"] \the [src]."), \
				span_notice("You switch [on ? "on" : "off"] \the [src]."), \
				span_hear("You hear a click."))
			. = TRUE
		if("purge")
			reagents.clear_reagents()
			user.visible_message( \
				span_notice("[user] empties \the [src]'s reservoir."), \
				span_notice("You empty \the [src]'s reservoir."), \
				span_hear("You hear fluids draining."))
			. = TRUE
		if("overclock")
			var/overclock = params["overclock"]
			if(text2num(overclock) != null)
				overclock = text2num(overclock)
			if(overclock != null)
				overclock_amount = clamp(overclock, 0, max_overclock)
				. = TRUE

// "graphics" cards for shoving into the rig to get the most performance out
/obj/item/electronics/crypto_mining_card
	name = "\improper Brandless graphics card"
	desc = "Only capable of producing the pipe dream screensaver."
	icon = 'russstation/icons/obj/machines/cryptocurrency.dmi'
	icon_state = "graphics_card_1"
	w_class = WEIGHT_CLASS_SMALL
	// these are like stock parts but not so we can have finer control
	var/rating = 1
	// energy rating determines base power consumption
	var/energy_rating = 2
	// overclock rating determines how much extra power can be consumed
	var/overclock_rating = 0

/obj/item/electronics/crypto_mining_card/examine(mob/user)
	. = ..()
	. += "It requires [energy_rating * BASE_MACHINE_ACTIVE_CONSUMPTION]W to use."
	if(overclock_rating > 0)
		. += "It supports overclocking up to [overclock_rating * BASE_MACHINE_ACTIVE_CONSUMPTION]W."
	else
		. += "It does not support overclocking."

/obj/item/electronics/crypto_mining_card/tier2
	name = "\improper Electron 9000 graphics card"
	desc = "A decent graphics card that can play real games like Cargonian Warfare."
	icon_state = "graphics_card_2"
	rating = 2
	energy_rating = 5
	overclock_rating = 1.5

/obj/item/electronics/crypto_mining_card/tier3
	name = "\improper Plastitanium 800 graphics card"
	desc = "A poor gamer out there is suffering without this, but you're going to use it to mine crypto."
	icon_state = "graphics_card_3"
	w_class = WEIGHT_CLASS_NORMAL
	rating = 3
	energy_rating = 8
	overclock_rating = 4

/obj/item/electronics/crypto_mining_card/tier4
	name = "\improper Syndivideo Ruby graphics card"
	desc = "An experimental card using bluespace technology to render frames before they exist."
	icon = 'russstation/icons/obj/machines/crypto_huge.dmi'
	icon_state = "graphics_card_4"
	// pixel offset because the icon is huge; not sure if working
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	w_class = WEIGHT_CLASS_BULKY // they didn't even consider the consumers on this one
	rating = 4
	energy_rating = 12
	overclock_rating = 12 // now that's spicy
	// toolbox-esque combat applications
	force = 10
	throwforce = 10
	throw_speed = 2
	throw_range = 7
	wound_bonus = 7 // sharp edges

// NtOS program for crypto stuff
/datum/computer_file/program/cryptocurrency
	filename = "cryptoass" // hehe ass
	filedesc = "Crypto Assistant"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "generic"
	extended_desc = "This program monitors cryptocurrency markets and mining activity."
	size = 2
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	tgui_id = "NtosCryptocurrency"
	program_icon = "coins"

/datum/computer_file/program/cryptocurrency/ui_data()
	var/list/data = list()

	var/can_cash_out = FALSE
	var/obj/item/card/id/user_id = computer.GetID()
	if(user_id && (ACCESS_COMMAND in user_id.access))
		can_cash_out = TRUE
	data["authenticated"] = can_cash_out
	data["coin_name"] = SScryptocurrency.coin_name
	data["exchange_rate"] = SScryptocurrency.exchange_rate
	data["wallet"] = SScryptocurrency.wallet
	data["progress_required"] = SScryptocurrency.progress_required
	data["exchange_rate_limit"] = initial(SScryptocurrency.exchange_rate) * 2
	data["total_mined"] = SScryptocurrency.total_mined
	data["total_payout"] = SScryptocurrency.total_payout
	data["mining_history"] = SScryptocurrency.mining_history
	data["payout_history"] = SScryptocurrency.payout_history
	data["exchange_rate_history"] = SScryptocurrency.exchange_rate_history
	data["market_closed"] = !SScryptocurrency.can_fire
	var/list/rigs = list()
	for(var/obj/machinery/crypto_mining_rig/rig in SScryptocurrency.machines)
		var/rig_data = list()
		rig_data["name"] = rig.name
		rig_data["on"] = rig.on
		rig_data["progress"] = rig.progress
		rigs += list(rig_data)
	data["machines"] = rigs

	return data

/datum/computer_file/program/cryptocurrency/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("PRG_exchange")
			var/mob/user = usr
			var/message = SScryptocurrency.cash_out(user)
			if(message)
				minor_announce(message, "[SScryptocurrency.coin_name] Exchange Market")

// station goal
/datum/station_goal/cryptocurrency
	name = "Cryptocurrency"
	var/goal_payout = 500000

/datum/station_goal/cryptocurrency/get_report()
	return {"
		The Chief Financial Officer heard about cryptocurrency and we can't convince them it's a bad investment.
		Your station has been selected to research the technology and corner the market before competitors can.

		Mine [goal_payout] [SScryptocurrency.coin_name].

		The base parts are part of your engineering research, and additional components will become available for purchase via cargo.
		-Nanotrasen Financial Office"}

/datum/station_goal/cryptocurrency/check_completion()
	if(..())
		return TRUE
	// check if total payout is more than the goal
	return SScryptocurrency.total_payout >= goal_payout

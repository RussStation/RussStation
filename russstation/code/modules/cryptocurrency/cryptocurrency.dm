// Cryptocurrency mining module
// Contains machines and apps for turning power into money

// board for base rig - nothing too bad but you won't get much for spamming these
/obj/item/circuitboard/machine/crypto_mining_rig
	name = "Crypto Mining Rig (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/crypto_mining_rig
	needs_anchored = FALSE
	req_components = list(
		// graphics cards aren't required
		/obj/item/reagent_containers/glass/beaker = 1, // for coolant
		/obj/item/pickaxe = 1, // haha mining
		/obj/item/stack/cable_coil = 5)

// design for printing the boards at a lathe once they're researched
/datum/design/board/crypto_mining_rig
	name = "Machine Design (Crypto Mining Rig)"
	desc = "Allows for the construction of circuit boards used to build a crypto mining rig."
	id = "crypto_mining_rig"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 1000)
	//reagents_list = list() TBH i love the idea of requiring a stupid chem just for more department involvement
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
	active_power_usage = 500 // more expensive than average, but we're just starting
	circuit = /obj/item/circuitboard/machine/crypto_mining_rig
	// graphics cards in the rig
	var/card_count = 0
	// how many cards can be inserted max
	var/static/cards_max = 4
	// exactly what it says
	var/on = FALSE
	// internal calculation numbers cached for troubleshooting performance
	// how hot the machine was on last atmos process
	var/temperature = 0
	// how much temperature is affecting performance
	var/temperature_index = 1
	// how much power we're dissipating as heat
	var/coolant_factor = 0.1
	// how much mining progress we produced
	var/progress = 0
	// not-quite-consts are static so you can varedit all machines at once
	// when to start on fire
	var/static/combustion_heat = 5000
	// if power consumption is below this, we can stop processing it. non-zero to catch fractions sitting around
	var/static/min_power_to_process = 1
	// ideal temperature in current tile; lower temperature = better performance
	var/static/ideal_temperature = TCMB
	// temperature at which temperature index = 1
	var/static/temperature_index_pivot = 50
	// how much freon reduces power waste at max
	var/static/freon_bonus_max = 0.5
	// how much freon can provide a power bonus
	var/static/freon_max = 100
	// how many moles of freon to consume for the cooling bonus
	var/static/freon_consumption = 1
	// how much coolant used per cycle
	var/static/coolant_consumption = 0.025
	// valid coolants and their bonus factors (1 = max)
	var/static/list/coolants = list(
		/datum/reagent/water = 0.1,
		/datum/reagent/cryostylane = 0.5,
		/datum/reagent/super_coolant = 1
	)

/obj/machinery/crypto_mining_rig/Initialize(mapload)
	. = ..()
	create_reagents(50, OPENCONTAINER) // size adjusted in RefreshParts

/obj/machinery/crypto_mining_rig/examine(mob/user)
	. = ..()
	. += "\The [src] has [card_count] graphics cards installed and the coolant reservoir has [reagents.total_volume]/[reagents.maximum_volume] units."
	if(anchored)
		. += "\The [src] is bolted to the floor and is [on ? "on" : "off"]."
	if(isobserver(user))
		// for debugging, perform the tool inspections for ghosts
		. += "The temperature of \the [src] reads [temperature]K. Its heat dissipation index is [coolant_factor] and temperature performance index is [temperature_index]."
		. += "The power usage of \the [src] reads [active_power_usage]W. It is contributing [progress] work units per cycle."

/obj/machinery/crypto_mining_rig/Destroy()
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/crypto_mining_rig/update_icon_state()
	. = ..()
	// das blinkenlights
	icon_state = "[base_icon_state]_[card_count]_[on ? "on" : "off"]"

/obj/machinery/crypto_mining_rig/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(. || !anchored)
		return
	change_on(!on)
	user.visible_message( \
		span_notice("[usr] switches [on ? "on" : "off"] \the [src]."), \
		span_notice("You switch [on ? "on" : "off"] \the [src]."), \
		span_hear("You hear a click."))

/obj/machinery/crypto_mining_rig/proc/change_on(new_on)
	on = new_on
	update_use_power(on ? ACTIVE_POWER_USE : IDLE_POWER_USE)
	update_appearance()
	if (on)
		START_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)

/obj/machinery/crypto_mining_rig/attackby(obj/item/thing, mob/user, params)
	if(istype(thing, /obj/item/stock_parts/crypto_mining_card))
		if(on)
			to_chat(user, span_warning("You need to turn \the [src] off to mess with its cards!"))
		else if(card_count < cards_max)
			// add card if there's room
			thing.forceMove(src)
			card_count += 1
			component_parts += thing
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
	to_chat(user, span_notice("The temperature of \the [src] reads [temperature]K. Its heat dissipation index is [coolant_factor] and temperature performance index is [temperature_index]."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/multitool_act(mob/living/user, obj/item/tool)
	// display other info about the machine
	to_chat(user, span_notice("The power usage of \the [src] reads [active_power_usage]W. It is contributing [progress] work units per cycle."))
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
		for(var/obj/item/stock_parts/crypto_mining_card/card in component_parts)
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
		// admin ghosts can turn on/off
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
/obj/machinery/crypto_mining_rig/process(delta_time)
	// if we aren't on and working, obviously stop. also if we're in a no-no area (no free power for you)
	var/area/area = get_area(src)
	if(!on || machine_stat & (BROKEN|NOPOWER) || !powered() || !area.requires_power || !SScryptocurrency.can_fire)
		change_on(FALSE)
		return PROCESS_KILL

	// get the ambient gas for processing
	var/datum/gas_mixture/environment = loc.return_air()
	// check temperature to see how efficiently the machine operates in this environment
	temperature = environment.temperature
	// if we're within 1 degree just use 1 to avoid div by zero
	var/temperature_difference = max(abs(temperature - ideal_temperature), 1)
	// index balanced around 1x at 50 deg diff. bigger diff = smaller index (ex: 1000 deg diff = 0.55ish)
	// below 50 diff, index quickly scales up approaching 2.19ish at 1 deg diff
	// about 0.7 at standard atmos
	temperature_index = (temperature_index_pivot / temperature_difference) ** 0.2

	// can consume more power than parts rating with temp bonus
	var/power_consumed = active_power_usage * temperature_index
	use_power(power_consumed)

	// release consumed heat based on coolant content
	// 0.1 to 1.1, meaning you can produce more heat than exists. m a g i c
	coolant_factor = 0.1
	for(var/coolant in coolants)
		if(reagents.has_reagent(coolant))
			// measure how much of the reagents are our coolant: presence of other stuff impairs function
			var/proportion = reagents.get_reagent_amount(coolant) / reagents.total_volume
			// purity affects performance too
			var/purity = reagents.get_reagent_purity(coolant)
			// combine factors including the coolant's factor
			coolant_factor += proportion * purity * coolants[coolant]
	// consume a fraction of coolant from evaporation
	reagents.remove_all(coolant_consumption)

	// coolant determines how much power is released as heat
	var/dissipated_heat = power_consumed * coolant_factor

	// check freon content for bonus because using particular gasses is "cool"
	// haha, cool, because it's a coolant
	var/list/freon_content = environment.gases[/datum/gas/freon]
	var/freon_bonus = 0
	if(freon_content && freon_content[MOLES] > 0)
		// bonus is between 0 and max bonus (0.5) based on content up to freon_max moles
		freon_bonus = min(freon_content[MOLES] / freon_max * freon_bonus_max, freon_bonus_max)
		// consume a tiny amount of freon
		freon_content[MOLES] -= freon_consumption * freon_bonus

	// how much power actually contributed to mining progress? whatever was dissipated + other bonuses
	progress = dissipated_heat * (1 + freon_bonus)
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

	// apply dissipated heat to environment
	var/delta_temperature = dissipated_heat / environment.heat_capacity()
	if(delta_temperature)
		environment.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)

	// combust/explode when running really hot
	if(temperature >= combustion_heat * 2)
		// copied from crab17, should just destroy the rig
		explosion(src, light_impact_range = 1, flame_range = 2)
	else if(temperature >= combustion_heat && prob(1))
		do_sparks(1, FALSE, src)

/obj/machinery/crypto_mining_rig/RefreshParts()
	. = ..()
	// upgradeable coolant reservoir
	var/volume = 0
	for(var/obj/item/reagent_containers/glass/beaker/B in component_parts)
		volume += B.reagents.maximum_volume
	reagents.maximum_volume = volume

// "graphics" cards for shoving into the rig to get the most performance out
/obj/item/stock_parts/crypto_mining_card
	name = "Brandless graphics card"
	desc = "Only capable of producing the pipe dream screensaver."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade2"
	w_class = WEIGHT_CLASS_SMALL
	// TODO make sure these have miserable resale value
	rating = 1
	base_name = "graphics card"
	energy_rating = 2
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

/obj/item/stock_parts/crypto_mining_card/two
	name = "Electron 9000 graphics card"
	desc = "Last year's top-tier card is this year's unwanted garbage."
	icon_state = "std_mod"
	rating = 2
	energy_rating = 5

/obj/item/stock_parts/crypto_mining_card/three
	name = "Plastitanium 800 graphics card"
	desc = "The latest and greatest... that was in stock."
	icon_state = "circuit_map"
	w_class = WEIGHT_CLASS_NORMAL
	rating = 3
	energy_rating = 8

/obj/item/stock_parts/crypto_mining_card/four
	name = "Syndivideo Ruby graphics card"
	desc = "An experimental card using bluespace technology to render frames before they exist."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "circuit_mess"
	w_class = WEIGHT_CLASS_BULKY // they didn't even consider the consumers on this one
	rating = 4
	energy_rating = 12

// NtOS program for crypto stuff
/datum/computer_file/program/cryptocurrency
	filename = "cryptoass"
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
	var/list/data = get_header_data()

	var/can_cash_out = FALSE
	var/obj/item/card/id/user_id = computer.GetID()
	if(user_id && (ACCESS_COMMAND in user_id.access))
		can_cash_out = TRUE
	data["authenticated"] = can_cash_out
	data["coin_name"] = SScryptocurrency.coin_name
	data["exchange_rate"] = SScryptocurrency.exchange_rate
	data["wallet"] = SScryptocurrency.wallet
	data["progress_required"] = SScryptocurrency.progress_required
	data["exchange_rate_limit"] = initial(SScryptocurrency.exchange_rate) * 4
	data["total_mined"] = SScryptocurrency.total_mined
	data["total_payout"] = SScryptocurrency.total_payout
	data["event_chance"] = SScryptocurrency.event_chance
	data["mining_history"] = SScryptocurrency.mining_history
	data["payout_history"] = SScryptocurrency.payout_history
	data["exchange_rate_history"] = SScryptocurrency.exchange_rate_history
	data["market_closed"] = !SScryptocurrency.can_fire

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
	return {"The Chief Financial Officer heard about cryptocurrency and we can't convince them it's a bad investment.
		Your station has been selected to research the technology and corner the market before competitors can.

		Mine [goal_payout] [SScryptocurrency.coin_name].

		The base parts are part of your engineering research, and additional components will become available for shipping via cargo.
		-Nanotrasen Financial Office"}

/datum/station_goal/cryptocurrency/check_completion()
	if(..())
		return TRUE
	// check if total payout is more than the goal
	return SScryptocurrency.total_payout >= goal_payout

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
		/obj/item/pickaxe = 1, // haha mining
		/obj/item/stack/cable_coil = 5)

// design for printing the boards at a lathe once they're researched
/datum/design/crypto_mining_rig
	name = "Machine Design (Crypto Mining Rig)"
	desc = "Allows for the construction of circuit boards used to build a crypto mining rig."
	id = "crypto_mining_rig"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 1000)
	//reagents_list = list() TBH i love the idea of requiring a stupid chem just for more department involvement
	build_path = /obj/item/circuitboard/machine/crypto_mining_rig
	category = list("Misc")
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

// a machine for mining them coins. highly derivative of power sinks and space heaters.
// going long with the name to avoid any confusion with normal mining.
/obj/machinery/crypto_mining_rig
	name = "mining rig"
	icon = 'russstation/icons/obj/machines/cryptocurrency.dmi'
	icon_state = "mining_rig_off"
	base_icon_state = "mining_rig"
	desc = "A computer purpose-built for cryptocurrency mining."
	density = TRUE
	active_power_usage = 500 // more expensive than average, but we're just starting
	circuit = /obj/item/circuitboard/machine/crypto_mining_rig
	// graphics cards in the rig
	var/list/cards = list()
	// how many cards can be inserted max
	var/static/cards_max = 4
	// exactly what it says
	var/on = FALSE
	// internal calculation numbers cached for troubleshooting performance
	// how much power was wasted last process
	var/power_wasted = 0
	// how hot the machine was on last atmos process
	var/temperature = 0
	// how much temperature is affecting performance
	var/temperature_index = 1
	// how much heat we're dissipating in the current environment
	var/dissipation_index = 0.5
	// how much mining progress we produced
	var/progress = 0
	// when to start on fire
	var/static/combustion_heat = 5000
	// if power consumption is below this, we can stop processing it. non-zero to catch fractions sitting around
	var/static/min_power_to_process = 1
	// ideal temperature in current tile; lower temperature = better performance
	var/static/ideal_temperature = TCMB
	// ideal moles in current tile; more gas = more convection?
	// conflicts with ideal_temperature intentionally for more nuance than spacing the rig
	var/static/ideal_moles = MOLES_CELLSTANDARD * 2
	// how much freon reduces power waste at max
	var/static/freon_bonus_max = 0.5
	// how much freon can provide a power bonus
	var/static/freon_max = 20
	// how many moles of freon to consume for the cooling bonus
	var/static/freon_consumption = 1
	// component rating. cool machines have upgradeable components
	var/efficiency = 1

/obj/machinery/crypto_mining_rig/examine(mob/user)
	. = ..()
	if(anchored)
		. += "\The [src] is bolted to the floor and is [on ? "on" : "off"]."
	if((in_range(user, src) || isobserver(user)) && temperature > combustion_heat)
		. += span_danger("The air is warping above it. It must be very hot.")

/obj/machinery/crypto_mining_rig/Destroy()
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/crypto_mining_rig/update_icon_state()
	. = ..()
	// das blinkenlights
	icon_state = "[base_icon_state]_[on ? temperature > combustion_heat ? "hot" : "on" : "off"]"

/obj/machinery/crypto_mining_rig/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(. || !anchored)
		return
	on = !on
	user.visible_message(span_notice("[usr] switches [on ? "on" : "off"] \the [src]."), span_notice("You switch [on ? "on" : "off"] \the [src]."), span_hear("You hear a click."))
	update_appearance()
	if (on)
		START_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)

/obj/machinery/crypto_mining_rig/attackby(obj/item/thing, mob/user, params)
	if(istype(thing, /obj/item/analyzer))
		// get temp and atmos related info
		to_chat(user, span_notice("The temperature of \the [src] reads [temperature]K. Its heat dissipation index is [dissipation_index] and temperature performance index is [temperature_index]."))
	else if(istype(thing, /obj/item/multitool))
		// display other info about the machine
		to_chat(user, span_notice("The power usage of \the [src] reads [active_power_usage]W, [power_wasted]W of which is being wasted due to cooling conditions. It is contributing [progress] work units."))
	else if(default_deconstruction_crowbar(thing))
		return
	else if(istype(thing, /obj/item/crypto_mining_card))
		if(on)
			to_chat(user, span_warning("You need to turn \the [src] off to mess with its cards!"))
		else if(cards.len < cards_max)
			// add card if there's room
			thing.forceMove(src)
			cards += thing
			to_chat(user, span_notice("You pop \the [thing] into \the [src]."))
		else
			to_chat(user, span_notice("\The [src] is already full of cards! Remove some first with a screwdriver!"))
	else if(istype(thing, /obj/item/screwdriver))
		if(on)
			to_chat(user, span_warning("You need to turn \the [src] off to mess with its cards!"))
		else if(cards.len > 0)
			// i don't want to make an interface for removing/replacing individual cards, dump em all
			dump_inventory_contents()
			cards = list()
			to_chat(user, span_notice("You pop out the cards in \the [src]."))
	else
		return ..()

/obj/machinery/crypto_mining_rig/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
	if(isAdminGhostAI(user))
		// for debugging, perform the tool inspections for admins
		to_chat(user, span_notice("The temperature of \the [src] reads [temperature]K. Its heat dissipation index is [dissipation_index] and temperature performance index is [temperature_index]."))
		to_chat(user, span_notice("The power usage of \the [src] reads [active_power_usage]W, [power_wasted]W of which is being wasted due to cooling conditions. It is contributing [progress] work units."))

/obj/machinery/crypto_mining_rig/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(!anchored)
		if(default_unfasten_wrench(user, tool))
			user.visible_message( \
				"[user] attaches \the [src] to the floor.", \
				span_notice("You bolt \the [src] into the floor."),
				span_hear("You hear a something stupid being wrenched."))
	else if(default_unfasten_wrench(user, tool))
		on = FALSE
		user.visible_message( \
			"[user] detaches \the [src] from the floor.", \
			span_notice("You unbolt \the [src] from the floor."),
			span_hear("You hear something stupid being wrenched."))
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	playsound(src, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, span_warning("You short out the power controller."))

/obj/machinery/crypto_mining_rig/emp_act(severity)
	. = ..()
	if(machine_stat & (BROKEN|NOPOWER) || . & EMP_PROTECT_CONTENTS)
		return
	if(on)
		// increase power use on EMP; could be used strategically?
		active_power_usage += severity * 50
		// maybe come up with a better interaction

// drain power from the connected powernet and get money
/obj/machinery/crypto_mining_rig/process(delta_time)
	// if we aren't on and working, obviously stop. also if we're in a no-no area (no free power for you)
	var/area/area = get_area(src)
	if(!on || machine_stat & (BROKEN|NOPOWER) || !powered() || !area.requires_power)
		on = FALSE
		update_appearance()
		return PROCESS_KILL

	var/power_consumed = 0
	if(obj_flags & EMAGGED)
		// consume power from anywhere on the wire if emagged
		power_consumed = use_power_from_net(active_power_usage, take_any = TRUE)
	if(power_consumed == 0)
		use_power(active_power_usage)
		// use_power doesn't tell us how much was actually used, assume it was all
		power_consumed = active_power_usage
	// get the ambient gas for processing
	var/datum/gas_mixture/environment = loc.return_air()

	// first check temperature to see how efficiently the machine operates in this environment
	temperature = environment.temperature
	// if we're within 1 degree just use 1 to avoid div by zero
	var/temperature_difference = max(abs(temperature - ideal_temperature), 1)
	// index balanced around 1x at 50 deg diff. bigger diff = smaller index (ex: 1000 deg diff = 0.55ish)
	// below 50 diff, index quickly scales up approaching 2.19ish at 1 deg diff
	temperature_index = (50 / temperature_difference) ** 0.2

	// next check moles to see how efficiently the machine loses heat to the environment
	// more heat loss = less heat in the machine impairing operation
	var/total_moles = environment.total_moles()
	// heat dissipated is a portion of power consumed between 0.1 and 0.9 (a range of 0.8), more moles = higher dissipated
	dissipation_index = (min(total_moles, ideal_moles) / ideal_moles) * 0.8 + 0.1
	var/dissipated_heat = power_consumed * dissipation_index

	// check freon content for bonus because using particular gasses is "cool"
	// haha, cool, because it's a coolant
	var/list/freon_content = environment.gases[/datum/gas/freon]
	var/freon_bonus = 0
	if(freon_content && freon_content[MOLES] > 0)
		// bonus is between 0 and max bonus (0.5) based on content up to freon_max moles
		freon_bonus = min(freon_content[MOLES] / freon_max * freon_bonus_max, freon_bonus_max)
		// consume a tiny amount of freon
		freon_content[MOLES] -= freon_consumption * freon_bonus

	// how much power did we waste? didn't dissipate or apply to mining progress. freon magically reduces this
	power_wasted = (power_consumed - dissipated_heat) * (1 - freon_bonus)
	// how much power actually contributed to mining progress? whatever wasn't wasted
	// ex: (500W consumed - 200W wasted) * 0.8 index * 0.6 parts = 144 proggers
	progress = (power_consumed - power_wasted) * temperature_index * efficiency / SScryptocurrency.complexity
	// mine dat fukken coin
	var/result = SScryptocurrency.mine(progress)
	// announce result when finishing a mining unit
	if(result)
		say(result)

	// apply dissipated heat to environment
	var/delta_temperature = dissipated_heat / environment.heat_capacity()
	if(delta_temperature)
		environment.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)

	update_appearance()
	// combust/explode when running really hot (cooldown?)
	if(temperature >= combustion_heat * 2)
		// copied from crab17, should just destroy the rig
		explosion(src, light_impact_range = 1, flame_range = 2)
	else if(temperature >= combustion_heat && prob(1))
		do_sparks(1, FALSE, src)

/obj/machinery/crypto_mining_rig/RefreshParts()
	. = ..()
	efficiency = 1
	for(var/obj/item/crypto_mining_card/card in cards)
		efficiency += card.efficiency

// "graphics" cards for shoving into the rig to get the most performance out
/obj/item/crypto_mining_card
	name = "Brandless Graphics Card"
	desc = "Only capable of producing the pipe dream screensaver."
	w_class = WEIGHT_CLASS_SMALL
	// TODO icons
	// TODO make sure these have miserable resale value
	// how much power this card adds to the rig's usage
	var/power_usage = 250
	// efficiency factor for making cards more worthwhile than rigs
	var/efficiency = 1

/obj/item/crypto_mining_card/get_part_rating()
	. = ..()
	// just compare efficiency since it always increases
	return efficiency

/obj/item/crypto_mining_card/two
	name = "Electron 9000 Graphics Card"
	desc = "Last year's top-tier card is this year's unwanted garbage."
	power_usage = 400
	efficiency = 3

/obj/item/crypto_mining_card/three
	name = "Plastitanium 650 Graphics Card"
	desc = "The latest and greatest... that was in stock."
	w_class = WEIGHT_CLASS_NORMAL
	power_usage = 650
	efficiency = 6

/obj/item/crypto_mining_card/four
	name = "Syndivideo Ruby Graphics Card"
	desc = "An experimental card using bluespace technology to render frames before they exist."
	w_class = WEIGHT_CLASS_BULKY // they didn't even consider the consumers on this one
	power_usage = 800
	efficiency = 10

// NTOS program for crypto stuff
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

	data["coin_name"] = SScryptocurrency.coin_name
	data["exchange_rate"] = SScryptocurrency.exchange_rate
	data["complexity"] = SScryptocurrency.complexity
	data["mining_limit"] SScryptocurrency.progress_required
	data["total_mined"] = SScryptocurrency.total_mined
	data["total_payout"] = SScryptocurrency.total_payout
	data["event_chance"] = SScryptocurrency.event_chance
	data["mining_history"] = SScryptocurrency.mining_history
	data["payout_history"] = SScryptocurrency.payout_history

	return data

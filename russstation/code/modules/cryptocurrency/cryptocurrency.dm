GLOBAL_DATUM_INIT(cryptocurrency, /datum/cryptocurrency, new)

// tracks diminishing returns for "computing" more proof-of-work hashes
/datum/cryptocurrency
	// funny name for alerts?
	var/name = "SpaceCoin"
	// how much work is required for mining more money. scales power and time
	var/complexity = 1
	// complexity growth factor, multiplicative
	var/complexity_growth = 1.05
	// how much power is required for one machine to perform one unit of work
	var/power_usage = 10000
	// how much is payed out for an individual mining operation. scales inversely with complexity
	var/payout = 2000
	// how much of a unit of work has been performed
	var/progress = 0
	// how many NT credits a single coin of this currency is worth (purely for flavor)
	var/exchange_rate = 1

/datum/cryptocurrency/New()
	. = ..()
	// coin of the week
	name = pick(list(
		"SpaceCoin",
		"StarBucks", // this is clearly legally distinct
		"ClownCoin",
		"MimeMoney",
		"FunnyMoney",
		"RussMoney", // haha i referenced the streamer
		"SyndiCoin",
		"BananaBucks",
		))
	// either a fraction or a large number
	exchange_rate = pick(list(rand(), rand(10, 1000)))

/datum/cryptocurrency/proc/mine(power)
	// *obviously* don't actually do crypto hash calculations, the game lags enough as is
	progress += power
	if(progress >= power_usage * complexity)
		progress = 0
		complexity *= complexity_growth
		var/datum/bank_account/the_dump = SSeconomy.get_dep_account(ACCOUNT_CAR)
		var/gains = get_payout()
		the_dump.adjust_money(gains)
		// funny payout message for machine to shout
		return "Successfully computed a proof-of-work hash on the blockchain! [gains * exchange_rate] [name] payed to the [ACCOUNT_CAR_NAME] account."

/datum/cryptocurrency/proc/get_payout()
	return payout / complexity

/obj/item/circuitboard/machine/crypto_mining_rig
	name = "Crypto Mining Rig (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/crypto_mining_rig
	needs_anchored = FALSE
	// no graphics cards currently to shove into this so here's some other funny stuff
	req_components = list(
		/obj/item/stock_parts/capacitor = 6, // replace with graphics cards eventually?
		/obj/item/stock_parts/micro_laser = 1, // it does nothing, just like RGBs
		/obj/item/pickaxe = 1, // haha mining
		/obj/item/stack/cable_coil = 3)

// a machine for mining them coins. highly derivative of power sinks and space heaters.
// going long with the name to avoid any confusion with normal mining.
/obj/machinery/crypto_mining_rig
	name = "mining rig"
	icon = 'russstation/icons/obj/machines/cryptocurrency.dmi'
	icon_state = "mining_rig_off"
	base_icon_state = "mining_rig"
	desc = "A computer purpose-built for cryptocurrency mining."
	density = TRUE
	//active_power_usage = 200
	circuit = /obj/item/circuitboard/machine/crypto_mining_rig
	// exactly what it says
	var/on = FALSE
	// the currency we're mining
	var/datum/cryptocurrency/currency
	// literally a space heater
	var/internal_heat = 0
	// when to start on fire
	var/static/combustion_heat = 100000
	// how much heat do we release into the environment
	var/static/dissipation_index = 10
	// our connection to the powernet, were you expecting to mine off wireless electricity?
	var/obj/structure/cable/power_cable
	// component rating. cool machines have upgradeable components
	var/efficiency = 1
	// how much power to drain from the wire (manual active_power_usage)
	var/static/wire_power_usage = 500
	// how much power to drain from APCs when the powernet lacks sufficient power (and emagged)
	var/static/apc_drain = 10

/obj/machinery/crypto_mining_rig/Initialize(mapload)
	. = ..()
	currency = GLOB.cryptocurrency
	if(!power_cable)
		var/turf/local_turf = loc
		if(isturf(local_turf) && local_turf.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
			power_cable = locate() in local_turf

/obj/machinery/crypto_mining_rig/examine(mob/user)
	. = ..()
	if(anchored)
		. += "\The [src] is bolted to the floor and has [power_cable ? "a" : "no"] power cable attached."
		. += "\The [src] is [on ? "on" : "off"]."
	if((in_range(user, src) || isobserver(user)) && internal_heat > combustion_heat * 0.5)
		. += span_danger("The air is warping above it. It must be very hot.")

/obj/machinery/crypto_mining_rig/Destroy()
	SSair.stop_processing_machine(src)
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/crypto_mining_rig/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[on ? internal_heat > combustion_heat * 0.5 ? "hot" : "on" : "off"]"

/obj/machinery/crypto_mining_rig/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!power_cable)
		var/turf/local_turf = loc
		if(isturf(local_turf) && local_turf.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
			power_cable = locate() in local_turf
		// still no cable?
		if(!power_cable)
			to_chat(user, span_warning("\The [src] must be placed over an exposed, powered cable node!"))
			return
	on = !on
	user.visible_message(span_notice("[usr] switches [on ? "on" : "off"] \the [src]."), span_notice("You switch [on ? "on" : "off"] \the [src]."), span_hear("You hear a click."))
	update_appearance()
	if (on)
		START_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)

/obj/machinery/crypto_mining_rig/crowbar_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_crowbar(tool))
		return TRUE

/obj/machinery/crypto_mining_rig/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(!anchored)
		var/turf/local_turf = loc
		if(isturf(local_turf) && local_turf.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
			power_cable = locate() in local_turf
			if(!power_cable)
				to_chat(user, span_warning("\The [src] must be placed over an exposed, powered cable node!"))
				return FALSE
			else if(default_unfasten_wrench(user, tool))
				user.visible_message( \
					"[user] attaches \the [src] to the cable.", \
					span_notice("You bolt \the [src] into the floor and connect it to the cable."),
					span_hear("You hear some wires being connected to something."))
		else
			to_chat(user, span_warning("\The [src] must be placed over an exposed, powered cable node!"))
			return FALSE
	else if(default_unfasten_wrench(user, tool))
		on = FALSE
		user.visible_message( \
			"[user] detaches \the [src] from the cable.", \
			span_notice("You unbolt \the [src] from the floor and detach it from the cable."),
			span_hear("You hear some wires being disconnected from something."))
		update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/crypto_mining_rig/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	playsound(src, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, span_warning("You short out the power controller."))

// remove internal heat and shares it with the atmosphere
/obj/machinery/crypto_mining_rig/process_atmos()
	// no more heat to give? take a break
	if(internal_heat <= 0)
		internal_heat = 0
		return PROCESS_KILL

	var/turf/local_turf = loc
	if(!istype(local_turf))
		// where is it?? space heaters have this check for some reason
		return

	var/datum/gas_mixture/environment = local_turf.return_air()
	var/dissipated_heat = internal_heat / dissipation_index * efficiency
	internal_heat -= dissipated_heat
	var/delta_temperature = dissipated_heat / environment.heat_capacity()
	if(delta_temperature)
		environment.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)

	// combust when running really hot (cooldown?)
	if(internal_heat >= combustion_heat)
		local_turf.hotspot_expose(1000,100) // yoinked from igniters, are these good values?
	update_appearance()

// drain power from the connected powernet and get money
/obj/machinery/crypto_mining_rig/process()
	if(!power_cable || !on || machine_stat & (BROKEN))
		on = FALSE
		update_appearance()
		return PROCESS_KILL

	// consume power on the wire
	var/avail = power_cable.newavail()
	power_cable.add_load(wire_power_usage)
	var/drained = wire_power_usage
	if(drained > avail)
		drained = avail
		if(obj_flags & EMAGGED)
			// if tried to drain more than available on powernet, now look for APCs and drain their cells
			for(var/obj/machinery/power/terminal/terminal in power_cable.powernet.nodes)
				if(istype(terminal.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/apc = terminal.master
					if(wire_power_usage > drained && apc.operating && apc.cell)
						apc.cell.charge = max(0, apc.cell.charge - apc_drain)
						drained += apc_drain
						// set fully charged cell to charging mode (these states are already undefined so here have some magic numbers)
						if(apc.charging == 2)
							apc.charging = 1
	// reactivate air processing if it was off
	if(internal_heat == 0 && drained > 0)
		SSair.start_processing_machine(src)
	// heat decreases with efficiency while mining power increases
	internal_heat += drained / efficiency
	var/result = currency.mine(drained * efficiency)
	if(result)
		say(result)

/obj/machinery/crypto_mining_rig/RefreshParts()
	var/rating = 0
	var/num_components = 0
	for(var/obj/item/stock_parts/capacitor/cappy in component_parts)
		rating += cappy.rating
		num_components += 1
	// efficiency based on average component rating to keep scaling down
	// balanced so tier 3 is "100%" efficiency
	efficiency = rating / num_components / 3

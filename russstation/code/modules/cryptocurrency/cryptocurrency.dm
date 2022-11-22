
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
	active_power_usage = 1500 // drain that APC
	circuit = /obj/item/circuitboard/machine/crypto_mining_rig
	// exactly what it says
	var/on = FALSE
	// literally a space heater
	var/internal_heat = 0
	// when to start on fire
	var/static/combustion_heat = 50000
	// how much heat do we release into the environment
	var/static/dissipation_index = 12
	// component rating. cool machines have upgradeable components
	var/efficiency = 1

/obj/machinery/crypto_mining_rig/examine(mob/user)
	. = ..()
	if(anchored)
		. += "\The [src] is bolted to the floor and is [on ? "on" : "off"]."
	if((in_range(user, src) || isobserver(user)) && internal_heat > combustion_heat)
		. += span_danger("The air is warping above it. It must be very hot.")

/obj/machinery/crypto_mining_rig/Destroy()
	SSair.stop_processing_machine(src)
	STOP_PROCESSING(SSmachines, src)
	// release stored heat (but like a reasonable portion)
	var/datum/gas_mixture/environment = loc.return_air()
	environment.temperature += internal_heat / 500
	air_update_turf(FALSE, FALSE)
	return ..()

/obj/machinery/crypto_mining_rig/update_icon_state()
	. = ..()
	// das blinkenlights
	icon_state = "[base_icon_state]_[on ? internal_heat > combustion_heat ? "hot" : "on" : "off"]"

/obj/machinery/crypto_mining_rig/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	on = !on
	user.visible_message(span_notice("[usr] switches [on ? "on" : "off"] \the [src]."), span_notice("You switch [on ? "on" : "off"] \the [src]."), span_hear("You hear a click."))
	update_appearance()
	if (on)
		START_PROCESSING(SSmachines, src)
	else
		STOP_PROCESSING(SSmachines, src)

/obj/machinery/crypto_mining_rig/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/analyzer))
		// get temperature reading vaguely indicating how hot the expensive space heater is
		var/datum/gas_mixture/environment = loc.return_air()
		// stored units of energy doesn't scale right with expected kelvins for a hot machine,
		// but powersink worked this way so just shrink the displayed number
		var/sane_temp = environment.temperature + internal_heat / 300
		to_chat(user, span_notice("The temperature of \the [src] reads [sane_temp]K. [internal_heat > combustion_heat ? "Dayum." : ""]"))
	else
		return ..()

/obj/machinery/crypto_mining_rig/crowbar_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_crowbar(tool))
		return TRUE

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
		// pump up the heat
		internal_heat += active_power_usage * severity
		// increase power use on EMP; could be used strategically?
		active_power_usage += severity * 50

// remove internal heat and shares it with the atmosphere
/obj/machinery/crypto_mining_rig/process_atmos()
	// no more heat to give? take a break
	if(internal_heat <= 1)
		internal_heat = 0
		return PROCESS_KILL

	var/datum/gas_mixture/environment = loc.return_air()
	var/dissipated_heat = internal_heat / dissipation_index
	// efficient parts will magically remove extra heat
	internal_heat -= dissipated_heat * efficiency
	var/delta_temperature = dissipated_heat / environment.heat_capacity()
	if(delta_temperature)
		environment.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)

	// combust when running really hot (cooldown?)
	if(internal_heat >= combustion_heat && prob(1))
		do_sparks(1, FALSE, src)
	update_appearance()

// drain power from the connected powernet and get money
/obj/machinery/crypto_mining_rig/process(delta_time)
	if(!on || machine_stat & (BROKEN|NOPOWER))
		on = FALSE
		update_appearance()
		return PROCESS_KILL

	// consume power, from anywhere on the wire if emagged
	var/drained = use_power_from_net(active_power_usage * delta_time, take_any = obj_flags & EMAGGED)
	// reactivate air processing if it was off
	if(internal_heat == 0 && drained > 0)
		SSair.start_processing_machine(src)
	// heat decreases with efficiency while mining power increases
	internal_heat += drained / efficiency
	var/result = SScryptocurrency.mine(drained * efficiency)
	// announce result when finishing a mining unit
	if(result)
		say(result)

/obj/machinery/crypto_mining_rig/RefreshParts()
	. = ..()
	var/rating = 0
	var/num_components = 0
	// only count capacitors, lasers are for show
	for(var/obj/item/stock_parts/capacitor/cappy in component_parts)
		rating += cappy.rating
		num_components += 1
	// efficiency based on average component rating to keep scaling down
	// balanced so tier 3 is "100%" efficiency
	efficiency = rating / num_components / 3

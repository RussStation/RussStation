// too lazy to set the right cell sizes, let's automate it
/obj/machinery/power/apc/auto_cell
	auto_name = TRUE

/obj/machinery/power/apc/auto_cell/Initialize(mapload)
	// examine machinery in area
	// (getting auto-area ripped from parent init)
	var/area/A = loc.loc
	if(areastring)
		area = get_area_instance_from_text(areastring)
		if(!area)
			area = A
			stack_trace("Bad areastring path for [src], [areastring]")
	else if(isarea(A) && areastring == null)
		area = A
	var/total_idle_power_usage = 0
	var/total_active_power_usage = 0
	// estoy loopin - hopefully this isn't too costly
	for(var/turf/T in area)
		for(var/obj/machinery/M in T)
			total_idle_power_usage += M.idle_power_usage
			total_active_power_usage += M.active_power_usage
	// naïve estimate based on average instead of checking active states
	var/target_power_usage = (total_idle_power_usage + total_active_power_usage) / 2
	// hopefully good estimates of appropriate cells
	if(target_power_usage < 600)
		cell_type = /obj/item/stock_parts/cell/upgraded
	else if(target_power_usage < 1200)
		cell_type = /obj/item/stock_parts/cell/upgraded/plus
	else if(target_power_usage < 2000)
		cell_type = /obj/item/stock_parts/cell/high
	else
		cell_type = /obj/item/stock_parts/cell/super
	// finally finish init now that cell_type is set
	. = ..()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/power/apc/auto_cell, APC_PIXEL_OFFSET)

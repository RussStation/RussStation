/turf/closed/mineral/random/low_chance/volcanic
	turf_type = /turf/open/misc/asteroid/basalt/lava_land_surface
	baseturfs = /turf/open/misc/asteroid/basalt/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = TRUE
	mineralChance = 13

/turf/closed/mineral/random/low_chance/volcanic/mineral_chances()
	return list(
		/obj/item/stack/ore/uranium = 2,
		/obj/item/stack/ore/diamond = 1,
		/obj/item/stack/ore/gold = 4,
		/obj/item/stack/ore/silver = 6,
		/obj/item/stack/ore/plasma = 15,
		/obj/item/stack/ore/iron = 40,
		/obj/item/stack/ore/titanium = 4,
		/turf/closed/mineral/gibtonite = 2,
		/obj/item/stack/ore/bluespace_crystal = 1
	)

/turf/closed/mineral/adamantine
	mineralType = /obj/item/stack/ore/adamantine
	mineralAmt = 1
	scan_state = "rock_Adamantine"
	turf_type = /turf/open/misc/asteroid/basalt/lava_land_surface
	baseturfs = /turf/open/misc/asteroid/basalt/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = TRUE

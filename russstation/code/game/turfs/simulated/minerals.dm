/turf/closed/mineral/random/low_chance/volcanic
	environment_type = "basalt"
	turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = 1
	mineralSpawnChanceList = list(
		/turf/closed/mineral/uranium/volcanic = 2, /turf/closed/mineral/diamond/volcanic = 1, /turf/closed/mineral/gold/volcanic = 4, /turf/closed/mineral/titanium/volcanic = 4,
		/turf/closed/mineral/silver/volcanic = 6, /turf/closed/mineral/plasma/volcanic = 15, /turf/closed/mineral/iron/volcanic = 40,
		/turf/closed/mineral/gibtonite/volcanic = 2, /turf/closed/mineral/bscrystal/volcanic = 1)

/turf/closed/mineral/adamantine
	mineralType = /obj/item/stack/ore/adamantine
	mineralAmt = 1
	spreadChance = 0
	spread = 0
	scan_state = "rock_Adamantine"
	environment_type = "basalt"
	turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = 1

// snow variant of low_chance minerals
/turf/closed/mineral/random/snow/low_chance
	mineralChance = 6

/turf/closed/mineral/random/snow/low_chance/mineral_chances()
	return list(
		/obj/item/stack/ore/uranium = 2,
		/obj/item/stack/ore/diamond = 1,
		/obj/item/stack/ore/gold = 4,
		/obj/item/stack/ore/titanium = 4,
		/obj/item/stack/ore/silver = 6,
		/obj/item/stack/ore/plasma = 15,
		/obj/item/stack/ore/iron = 40,
		/turf/closed/mineral/gibtonite/ice/icemoon = 2
	)

/turf/closed/mineral/random/labormineral/badlands
	icon_state = "rock_labor"
	turf_type = /turf/open/misc/asteroid/basalt/wasteland
	baseturfs = /turf/open/misc/asteroid/basalt/wasteland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = TRUE

/turf/closed/mineral/gibtonite/badlands
	turf_type = /turf/open/misc/asteroid/basalt/wasteland
	baseturfs = /turf/open/misc/asteroid/basalt/wasteland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = TRUE

/turf/closed/mineral/random/badlands
	turf_type = /turf/open/misc/asteroid/basalt/wasteland
	baseturfs = /turf/open/misc/asteroid/basalt/wasteland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	defer_change = TRUE

	// slightly less good than lavaland
	mineralChance = 9

/turf/closed/mineral/random/badlands/mineral_chances()
	return list(
		/obj/item/stack/ore/uranium = 4,
		/obj/item/stack/ore/diamond = 1,
		/obj/item/stack/ore/gold = 8,
		/obj/item/stack/ore/titanium = 8,
		/obj/item/stack/ore/silver = 10,
		/obj/item/stack/ore/plasma = 17,
		/obj/item/stack/ore/iron = 40,
		/obj/item/stack/ore/bananium = 6,
		/turf/closed/mineral/gibtonite/badlands = 6,
		/obj/item/stack/ore/bluespace_crystal = 1
	)

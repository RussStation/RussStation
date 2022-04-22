// Atmos canister mapping helpers, so you can actually tell what the fuck you're looking at
/obj/effect/spawner/atmos_canister
	name = "canister spawner"
	desc = "Because upstream mappers are insane"
	// yoinked from the grave
	icon = 'russstation/icons/atmos.dmi'
	icon_state = "default"
	// what canister to spawn
	var/can_type = /obj/machinery/portable_atmospherics/canister

/obj/effect/spawner/atmos_canister/Initialize(mapload)
	. = ..()
	new can_type(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/atmos_canister/air
	icon_state = "air"
	can_type = /obj/machinery/portable_atmospherics/canister/air

/obj/effect/spawner/atmos_canister/anesthetic_mix
	icon_state = "anesthetic_mix"
	can_type = /obj/machinery/portable_atmospherics/canister/anesthetic_mix

/obj/effect/spawner/atmos_canister/carbon_dioxide
	icon_state = "carbon_dioxide"
	can_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide

/obj/effect/spawner/atmos_canister/nitrogen
	icon_state = "nitrogen"
	can_type = /obj/machinery/portable_atmospherics/canister/nitrogen

/obj/effect/spawner/atmos_canister/nitrous_oxide
	icon_state = "nitrous_oxide"
	can_type = /obj/machinery/portable_atmospherics/canister/nitrous_oxide

/obj/effect/spawner/atmos_canister/oxygen
	icon_state = "oxygen"
	can_type = /obj/machinery/portable_atmospherics/canister/oxygen

/obj/effect/spawner/atmos_canister/plasma
	icon_state = "plasma"
	can_type = /obj/machinery/portable_atmospherics/canister/plasma

/obj/effect/spawner/atmos_canister/water_vapor
	icon_state = "water_vapor"
	can_type = /obj/machinery/portable_atmospherics/canister/water_vapor

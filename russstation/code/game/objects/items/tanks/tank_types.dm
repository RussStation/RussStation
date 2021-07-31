/*
 * Miasma Portable Tanks
 */

/obj/item/tank/internals/skaven
	name = "miasma internals tank"
	desc = "A tank of miasma gas that was perviously canned garbage but rebranded. Skaven love this stuff."
	icon = 'russstation/icons/obj/tank.dmi'
	icon_state = "skaven_tank"
	lefthand_file = 'russstation/icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/equipment/tanks_righthand.dmi'
	inhand_icon_state = "miasma_tank"
	worn_icon = 'russstation/icons/mob/clothing/belt.dmi'
	worn_icon_state = "skaven_tank"
	tank_holder_icon_state = null
	force = 10
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE //Start with the valve open

/obj/item/tank/internals/skaven/populate_gas()
	air_contents.assert_gas(/datum/gas/miasma)
	air_contents.gases[/datum/gas/miasma][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/skaven/full/populate_gas()
	air_contents.assert_gas(/datum/gas/miasma)
	air_contents.gases[/datum/gas/miasma][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

//Belt version
/obj/item/tank/internals/skaven/belt
	name = "miasma internals belt tank"
	icon_state = "skaven_tank_belt"
	inhand_icon_state = "miasma_tank_belt"
	worn_icon_state = "skaven_tank_belt"
	tank_holder_icon_state = null
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 24
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tank/internals/skaven/belt/full/populate_gas()
	air_contents.assert_gas(/datum/gas/miasma)
	air_contents.gases[/datum/gas/miasma][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/skaven/belt/empty/populate_gas()
	return

/turf/closed/wall/mineral/stone
	name = "stone wall"
	desc = "A wall made of stone, designed to stonewall trespassers."
	icon = 'russstation/icons/turf/walls/stone.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	sheet_type = /obj/item/stack/sheet/mineral/stone
	hardness = 45 // between iron walls and wood walls
	explosion_block = 0
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SANDSTONE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SANDSTONE_WALLS) // pretty much the same thing aesthetically
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	custom_materials = list(/datum/material/stone = 4000)
	girder_type = /obj/structure/girder/stone
	decon_type = /turf/open/floor/stone/russ

/turf/closed/wall/mineral/stone/deconstruction_hints(mob/user)
	return span_notice("The outer stones are firmly attached by <b>Dwarven engineering</b>, although <b>welding</b> could loosen them.")

/turf/closed/wall/mineral/stone/attackby(obj/item/I, mob/user, params)
	// allow some interaction for dorfs
	if(!ISADVANCEDTOOLUSER(user))
		var/turf/T = user.loc
		// no wall mounting for dorfs right now
		if(try_clean(I, user, T) || try_decon(I, user, T))
			return
	return ..()


/turf/closed/wall/mineral/stone/try_clean(obj/item/I, mob/living/user, turf/T)
	// copied from parent, but dwarf tool
	if((user.combat_mode) || !LAZYLEN(dent_decals))
		return FALSE

	if(I.tool_behaviour == TOOL_DWARF)
		if(!I.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, span_notice("You begin fixing chips on the wall..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				to_chat(user, span_notice("You fix some chips on the wall."))
				cut_overlay(dent_decals)
				dent_decals.Cut()
			return TRUE

	return FALSE

/turf/closed/wall/mineral/stone/try_decon(obj/item/I, mob/user, turf/T)
	// copied from parent, but dwarf tool
	if(I.tool_behaviour == TOOL_DWARF)
		if(!I.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, span_notice("You begin dislodging the outer stones..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, slicing_duration, volume=100))
			if(iswallturf(src))
				to_chat(user, span_notice("You remove the outer stones."))
				dismantle_wall()
			return TRUE

	return FALSE

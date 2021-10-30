// All stone variants of structures
// Subtyped when possible, but make sure compatibility issues are handled

/obj/structure/bed/stone
	name = "stone bed"
	desc = "A bed made of stone. Not very comfortable, but dwarves don't mind."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FIRE_PROOF
	max_integrity = 100
	integrity_failure = 0.35
	buildstacktype = /obj/item/stack/sheet/mineral/stone

/obj/structure/bed/stone/examine(mob/user)
	. = ..()
	. += span_notice("A <b>Dwarven tool</b> could easily dismantle it.")

/obj/structure/bed/stone/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_DWARF)
		to_chat(user, span_notice("You start disassembling [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 3 SECONDS))
			deconstruct(TRUE)
			user.visible_message(span_notice("[user] tears apart \the [src]."),
				span_notice("You successfully disassemble \the [src]."),
				span_hear("You hear stones dropping to the ground."))
	else
		return ..()

/obj/structure/table_frame/stone
	name = "stone table frame"
	desc = "A rectangle of stone waiting to be capped with a flat surface material."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "table_frame"
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	max_integrity = 100
	framestack = /obj/item/stack/sheet/mineral/stone
	framestackamount = 2

/obj/structure/table_frame/stone/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_DWARF)
		to_chat(user, span_notice("You start disassembling [src]..."))
		I.play_tool_sound(src)
		if(!I.use_tool(src, user, 3 SECONDS))
			return
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE)
		user.visible_message(span_notice("[user] tears apart \the [src]."),
			span_notice("You successfully disassemble \the [src]."),
			span_hear("You hear stones dropping to the ground."))
	else
		return ..()

/obj/structure/table/stone
	name = "stone table"
	desc = "A table made of smoothed stone. Ready to support feasts and drunken fights."
	icon = 'russstation/icons/obj/smooth_structures/stone_table.dmi'
	icon_state = "table-0"
	base_icon_state = "table"
	pass_flags_self = PASSTABLE | LETPASSTHROW
	frame = /obj/structure/table_frame/stone
	framestack = /obj/item/stack/sheet/mineral/stone
	buildstack = /obj/item/stack/sheet/mineral/stone
	buildstackamount = 1
	framestackamount = 2
	deconstruction_ready = FALSE
	custom_materials = list(/datum/material/stone = 2000)
	max_integrity = 100
	integrity_failure = 0.33
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_TABLES)

/obj/structure/table/stone/deconstruction_hints(mob/user)
	. = ..()
	. += span_notice("Some kind of <b>Dwarven tool</b> could also deconstruct it.")

/obj/structure/table/stone/attackby(obj/item/I, mob/living/user, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if (I.tool_behaviour == TOOL_DWARF)
			to_chat(user, span_notice("You start deconstructing [src]..."))
			I.play_tool_sound(src)
			if(I.use_tool(src, user, 2 SECONDS, volume=50))
				deconstruct(TRUE)
				user.visible_message(span_notice("[user] tears apart \the [src]."),
					span_notice("You successfully disassemble \the [src]."),
					span_hear("You hear stones dropping to the ground."))
			return
	return ..()

/obj/structure/chair/stone
	name = "stone throne"
	desc = "A throne made of stone. Gives your feet a rest while hurting your back."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "chair"
	resistance_flags = FIRE_PROOF
	max_integrity = 250
	integrity_failure = 0.1
	custom_materials = list(/datum/material/stone = 2000)
	layer = OBJ_LAYER
	buildstacktype = /obj/item/stack/sheet/mineral/stone
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_DWARF)
		to_chat(user, span_notice("You begin deconstructing \the [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 1 SECONDS, volume=30))
			deconstruct()
			user.visible_message(span_notice("[user] tears apart \the [src]."),
				span_notice("You successfully disassemble \the [src]."),
				span_hear("You hear stones dropping to the ground."))
	else
		return ..()

/obj/structure/mineral_door/stone
	name = "stone door"
	desc = "An imposing door made of stone. Keeps the beasts out."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "door"
	sheetType = /obj/item/stack/sheet/mineral/stone
	max_integrity = 100

/obj/structure/mineral_door/stone/attackby(obj/item/I, mob/living/user)
	if(I.tool_behaviour == TOOL_DWARF)
		to_chat(user, span_notice("You begin deconstructing \the [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 5 SECONDS, volume=70))
			deconstruct(TRUE)
			user.visible_message(span_notice("[user] tears apart \the [src]."),
				span_notice("You successfully disassemble \the [src]."),
				span_hear("You hear stones dropping to the ground."))
	else
		return ..()

/obj/structure/closet/crate/stone
	name = "stone coffer"
	desc = "A chest made of stone. Stuff goes in, stuff goes out."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "crate"
	delivery_icon = null
	open_sound = 'sound/machines/crate_open.ogg'
	close_sound = 'sound/machines/crate_close.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 1 // heavy
	crate_climb_time = 20
	manifest = null
	material_drop = /obj/item/stack/sheet/mineral/stone
	material_drop_amount = 3

/obj/structure/closet/crate/stone/tool_interact(obj/item/I, mob/living/user)
	// another parent rewrite - return FALSE if we should just hit the crate
	// decon when closed since we can't tell if dwarf tool should be stored when open
	if(!opened && I.tool_behaviour == TOOL_DWARF)
		to_chat(user, span_notice("You begin breaking \the [src] apart..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 2 SECONDS, volume=50))
			if(opened)
				return TRUE
			user.visible_message(span_notice("[user] knaps apart \the [src]."),
				span_notice("You pry \the [src] apart with \the [I]."),
				span_hear("You hear stones grinding."))
			deconstruct(TRUE)
		return TRUE
	else if(opened && user.transferItemToLoc(I, drop_location())) // don't forget to store item!
		return TRUE
	return FALSE

/obj/item/stack/tile/stone
	name = "stone floor tile"
	singular_name = "stone floor tile"
	desc = "Smooth stone floor. Satisfying to walk on."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "tile"
	force = 6
	mats_per_unit = list(/datum/material/stone = 500)
	throwforce = 10
	turf_type = /turf/open/floor/stone/russ
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 70)
	matter_amount = 1
	cost = 125
	source = null
	merge_type = /obj/item/stack/tile/stone
	tile_reskin_types = list()

/obj/structure/girder/stone
	name = "stone wall frame"
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "girder"
	desc = "A partially constructed stone wall. Not very useful until completed."
	max_integrity = 150 // less than iron girders
	var/sheet_amount = 4

/obj/structure/girder/stone/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/S = I
		// skip parent attackby to limit the types of sheet that can be applied
		if(!istype(S, /obj/item/stack/sheet/mineral/stone))
			to_chat(user, span_warning("You can't attach that material to such an outdated wall frame!"))
			return
		if(S.get_amount() < 2)
			to_chat(user, span_warning("You need two blocks of stone to finish a wall!"))
			return
		to_chat(user, span_notice("You start filling in the stone wall..."))
		if (do_after(user, 4 SECONDS, target = src))
			if(S.get_amount() < 2)
				return
			S.use(2)
			user.visible_message(span_notice("[user] fills in a stone wall."),
				span_notice("You finish the stone wall."),
				span_hear("You hear stones piling up."))
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/stone)
			qdel(src)
		return
	else if(I.tool_behaviour == TOOL_DWARF)
		to_chat(user, span_notice("You begin to disassemble [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 3 SECONDS, volume = 75))
			var/obj/item/stack/sheet/mineral/stone/S = new(user.loc, sheet_amount)
			S.add_fingerprint(user)
			playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
			user.visible_message(span_notice("[user] tears apart \the [src]."),
				span_notice("You successfully disassemble \the [src]."),
				span_hear("You hear stones dropping to the ground."))
			qdel(src)
		return
	else
		return ..()

// not a subtype because too many things to override which we don't care about
// and no smoothing because I didn't feel like it
/obj/structure/stone_window
	name = "stone window"
	desc = "A stone wall with a big ol' hole in it."
	icon = 'russstation/icons/obj/stone_structures.dmi'
	icon_state = "window"
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	pressure_resistance = ONE_ATMOSPHERE
	anchored = TRUE
	flags_1 = null
	max_integrity = 70
	can_be_unanchored = FALSE
	resistance_flags = FIRE_PROOF
	CanAtmosPass = ATMOS_PASS_YES
	rad_insulation = RAD_NO_INSULATION
	pass_flags_self = PASSGRILLE
	set_dir_on_move = FALSE
	receive_ricochet_chance_mod = 0
	var/sheet_amount = 2

/obj/structure/stone_window/examine(mob/user)
	. = ..()
	. += span_notice("It is held together by <b>Dwarven engineering</b>, although it could probably be <b>pried</b> apart.")

/obj/structure/stone_window/attackby(obj/item/I, mob/living/user, params)
	add_fingerprint(user)

	if(I.tool_behaviour == TOOL_DWARF || I.tool_behaviour == TOOL_CROWBAR)
		to_chat(user, span_notice("You begin to disassemble [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 3 SECONDS, volume = 75))
			var/obj/item/stack/sheet/mineral/stone/S = new(user.loc, sheet_amount)
			S.add_fingerprint(user)
			playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
			user.visible_message(span_notice("[user] tears apart \the [src]."),
				span_notice("You successfully disassemble \the [src]."),
				span_hear("You hear stones dropping to the ground."))
			qdel(src)
		return
	else
		return ..()

/obj/structure/stone_window/Destroy()
	set_density(FALSE)
	air_update_turf(TRUE, FALSE)
	return ..()

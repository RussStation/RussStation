/obj/item/gun/chem/alcohol_gun
	name = "SHOTgun"
	desc = "a chem gun designed to shoot ethanol based beverages into bar patrons."
	inhand_icon_state = "shotgun"
	time_per_syringe = 200
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'

/obj/item/gun/chem/alcohol_gun/create_reagents(max_vol, flags)
	. = ..()
	RegisterSignal(reagents, COMSIG_REAGENTS_ADD_REAGENT, .proc/on_reagent_change)

/obj/item/gun/chem/alcohol_gun/proc/on_reagent_change(datum/reagents/holder, ...)
	if(obj_flags & EMAGGED)
		return
	for(var/datum/reagent/contents in reagents.reagent_list)
		if(istype(contents, /datum/reagent/consumable/ethanol))
			continue
		reagents.clear_reagents()
		playsound(src,'sound/weapons/sear.ogg', 50)
		loc.visible_message(
			span_warning("The [name] purges the contents of its chamber!"),
			span_warning("The [name] purges the contents of its chamber!"),
			span_hear("You hear a sizzling sound!"),
		)

/obj/item/gun/chem/alcohol_gun/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	playsound(src.loc, "sparks", 100, TRUE)
	loc.visible_message(
		span_notice("You hear a sparking sound"),
		span_warning("You scramble the [name]'s purge sensor"),
	)

// Based of `/obj/item/mod/module/magboot` + `/obj/item/clothing/shoes/winterboots/ice_boots`
/obj/item/mod/module/ice_boots
	name = "MOD frozen stability module"
	desc = "A module made experimentally by Nanotrasen, based off the work of Nakamura \
		Engineering. It changes the boot grip to a special grip pattern which was specifically designed to prevent slipping on frozen surfaces."
	icon = 'russstation/icons/obj/clothing/modsuit/mod_modules.dmi'
	icon_state = "ice_boots_mod"
	module_type = MODULE_TOGGLE
	complexity = 2
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.5
	incompatible_modules = list(/obj/item/mod/module/magboot, /obj/item/mod/module/atrocinator, /obj/item/mod/module/ice_boots)
	cooldown_time = 0.5 SECONDS
	/// Slowdown added onto the suit.
	var/slowdown_active = 0.5

/obj/item/mod/module/ice_boots/on_activation()
	. = ..()
	if(!.)
		return
	mod.slowdown += slowdown_active
	mod.wearer.update_equipment_speed_mods()
	var/list/parts = mod.mod_parts + mod
	for(var/obj/item/part as anything in parts)
		if(!ismodboots(part))
			continue
		var/obj/item/clothing/shoes/mod/clothing_part = part
		clothing_part.clothing_flags |= NOSLIP_ICE
		return

/obj/item/mod/module/ice_boots/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	mod.slowdown -= slowdown_active
	mod.wearer.update_equipment_speed_mods()
	var/list/parts = mod.mod_parts + mod
	for(var/obj/item/part as anything in parts)
		if(!ismodboots(part))
			continue
		var/obj/item/clothing/shoes/mod/clothing_part = part
		if(clothing_part.clothing_flags & NOSLIP_ICE)
			clothing_part.clothing_flags &= ~NOSLIP_ICE
		return

/obj/item/mod/module/ice_boots/advanced
	name = "MOD advanced frozen stability module"
	removable = FALSE
	complexity = 0
	slowdown_active = 0

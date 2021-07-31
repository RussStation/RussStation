#define RUNE_INEFFECTIVE_DROP_CHANCE 20

// Dwarf rune component- makes an item unusable by non-dwarves
/datum/component/dwarf_rune
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/enchanted = FALSE // after enchantment, non-dwarves can use this item

/datum/component/dwarf_rune/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/onAttackBy)
	RegisterSignal(parent, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_OBJ), .proc/onItemAttack)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/examine)
	RegisterSignal(parent, COMSIG_TOOL_START_USE, .proc/toolStartCheck)

/datum/component/dwarf_rune/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_ATTACKBY, COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_OBJ, COMSIG_PARENT_EXAMINE, COMSIG_TOOL_START_USE))

/datum/component/dwarf_rune/proc/onAttackBy(datum/source, obj/item/attacker, mob/user)
	SIGNAL_HANDLER

	// apply rune and expend it
	var/obj/item/dwarf_rune/rune = attacker
	if(!istype(rune))
		return
	if(rune.expended)
		to_chat(user, "<span class='notice'>You rub \the [attacker] on [source] but nothing happens.</span>")
		return
	enchanted = TRUE
	rune.expend()
	to_chat(user, "<span class='notice'>You rub \the [attacker] on [source] and it becomes enchanted.</span>")

/datum/component/dwarf_rune/proc/onItemAttack(datum/source, atom/movable/target, mob/living/user)
	SIGNAL_HANDLER

	return checkAttack(user)

/datum/component/dwarf_rune/proc/checkAttack(mob/living/user)
	// only dwarves can use these effectively, unless enchanted
	if(!enchanted && !is_species(user, /datum/species/dwarf))
		to_chat(user, "<span class='notice'>You can't seem to wield \the [parent] effectively.</span>")
		if(prob(RUNE_INEFFECTIVE_DROP_CHANCE) && user.dropItemToGround(parent))
			to_chat(user, "<span class='warning'>You fumble \the [parent] and drop it!</span>")
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/dwarf_rune/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(enchanted)
		examine_list += "<span class='notice'>It has a faint magical aura, and smells of beer.</span>"

/datum/component/dwarf_rune/proc/toolStartCheck(mob/living/user)
	SIGNAL_HANDLER

	return checkAttack(user)

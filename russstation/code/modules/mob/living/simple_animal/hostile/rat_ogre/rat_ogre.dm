/mob/living/simple_animal/hostile/rat_ogre
	name = "Rat Ogre"
	desc = "An amalgam of mutated muscle created by skaven fleshcrafters. It looks really hungry!"
	icon = 'russstation/icons/mob/rat_ogre.dmi'
	icon_state = "rat_ogre"
	icon_living = "rat_ogre"
	icon_dead = "dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 80
	maxHealth = 525
	health = 525
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/skaven = 6)
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "challenges"
	response_disarm_simple = "challenge"
	response_harm_continuous = "smacks"
	response_harm_simple = "smack"
	initial_language_holder = /datum/language_holder/skaven_only
	speed = 0.5
	pixel_x = -16
	base_pixel_x = -16
	melee_damage_lower = 23
	melee_damage_upper = 29
	damage_coeff = list(BRUTE = 1, BURN = 1.5, TOX = -1, CLONE = 0, STAMINA = 0, OXY = 1.5)
	obj_damage = 35
	environment_smash = ENVIRONMENT_SMASH_WALLS
	attack_verb_continuous = "gores"
	attack_verb_simple = "gore"
	attack_sound = 'sound/weapons/punch1.ogg'
	dextrous = TRUE //Oh shit
	held_items = list(null, null)
	faction = list(FACTION_RAT, "hostile")
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	minbodytemp = 150
	maxbodytemp = 456
	unique_name = TRUE
	footstep_type = FOOTSTEP_MOB_HEAVY

	var/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/warpstone_blade

	var/list/screams = list('russstation/sound/creatures/rat_ogre/scream1.ogg','russstation/sound/creatures/rat_ogre/scream2.ogg', \
							'russstation/sound/creatures/rat_ogre/scream3.ogg','russstation/sound/creatures/rat_ogre/scream4.ogg', \
							'russstation/sound/creatures/rat_ogre/scream5.ogg')

/mob/living/simple_animal/hostile/rat_ogre/Initialize()
	. = ..()
	warpstone_blade = new /datum/action/cooldown/spell/pointed/projectile/warpstone_blade()
	warpstone_blade.Grant(src)

	var/datum/action/small_sprite/rat_ogre/smallsprite = new(src)
	smallsprite.Grant(src)

	var/datum/action/adjust_vision/rat_ogre/adjust_vision = new(src)
	adjust_vision.Grant(src)

	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medsensor.show_to(src)

/mob/living/simple_animal/hostile/rat_ogre/Destroy()
	QDEL_NULL(warpstone_blade)
	return ..()

//Dismember unconcious mobs
/mob/living/simple_animal/hostile/rat_ogre/proc/get_target_bodyparts(atom/hit_target)
	if(!iscarbon(hit_target))
		return

	var/mob/living/carbon/carbon_target = hit_target
	if(carbon_target.stat < UNCONSCIOUS)
		return

	var/list/parts = list()
	for(var/obj/item/bodypart/part as anything in carbon_target.bodyparts)
		if(part.body_part == HEAD || part.body_part == CHEST)
			continue
		if(!(part.bodypart_flags & BODYPART_UNREMOVABLE))
			continue
		parts += part
	return parts

//Throw people around when you hit them
/mob/living/simple_animal/hostile/rat_ogre/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!.)
		return

	if(client)
		if(rand(1,4) == 2)
			playsound(src, pick(screams), 80)

	var/list/parts = get_target_bodyparts(target)
	if(length(parts))
		var/obj/item/bodypart/to_dismember = pick(parts)
		to_dismember.dismember()
		return

	if(isliving(target))
		var/mob/living/living_target = target
		if(prob(80))
			living_target.throw_at(get_edge_target_turf(living_target, dir), rand(1, 2), 7, src)

		else
			living_target.Paralyze(2 SECONDS)
			visible_message(span_danger("[src] knocks [living_target] down!"))

/mob/living/simple_animal/hostile/rat_ogre/CanAttack(atom/the_target)
	var/list/parts = get_target_bodyparts(target)
	return ..() && !ismonkey(the_target) && (!parts || length(parts) > 3)

/mob/living/simple_animal/hostile/rat_ogre/CanSmashTurfs(turf/T)
	return iswallturf(T)

/mob/living/simple_animal/hostile/rat_ogre/gib(no_brain)
	if(!no_brain)
		var/mob/living/brain/brain = new(drop_location())
		brain.name = real_name
		brain.real_name = real_name
		mind?.transfer_to(brain)
	return ..()

/mob/living/simple_animal/hostile/rat_ogre/handle_automated_speech(override)
	if(speak_chance && (override || prob(speak_chance)))
		playsound(src, pick(screams), 80)
	return ..()

/mob/living/simple_animal/hostile/rat_ogre/can_use_guns(obj/item/G)
	to_chat(src, span_warning("Your meaty finger is much too large for the trigger guard!"))
	return FALSE

//Small sprite mode (only controller can see change in sprite)
/datum/action/small_sprite/rat_ogre
	small_icon = 'icons/mob/simple/animal.dmi'
	small_icon_state = "mouse_gray"
	background_icon = 'russstation/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_skaven"
	button_icon = 'russstation/icons/mob/actions/actions_skaven.dmi'
	button_icon_state = "rat"

//Warpstone Daggers Spell
/datum/action/cooldown/spell/pointed/projectile/warpstone_blade
	name = "Warpstone Blade"
	desc = "Summon four warpstone blades to orbit you. \
		While orbiting you, these blades will protect you from from attacks, but will be consumed on use. \
		Additionally, you can click to fire the blades at a target, dealing damage and causing bleeding."

	background_icon = 'russstation/icons/mob/actions/backgrounds.dmi'
	background_icon_state = "bg_skaven"

	button_icon = 'russstation/icons/mob/actions/actions_skaven.dmi'
	button_icon_state = "warpstone_blade0"
	base_icon_state = "warpstone_blade"

	sound = 'sound/weapons/guillotine.ogg'

	cooldown_time = 20 SECONDS
	invocation = "Vreet'ka'rankka!"
	invocation_type = INVOCATION_SHOUT

	spell_requirements = NONE

	active_msg = "You summon forth three warpstone daggers of putrid filth."
	deactive_msg = "You conceal the warpstone daggers of putrid filth."

	cast_range = 20
	projectile_type = /obj/projectile/warpstone
	projectile_amount = 3

	var/datum/status_effect/warpstone_blade/blade_effect

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return

	if(IS_HERETIC(owner))
		RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_ALLOW_HERETIC_CASTING), .proc/on_focus_lost)

/datum/action/cooldown/spell/pointed/projectile/furious_steel/Remove(mob/remove_from)
	UnregisterSignal(remove_from, SIGNAL_REMOVETRAIT(TRAIT_ALLOW_HERETIC_CASTING))
	return ..()

/// Signal proc for [SIGNAL_REMOVETRAIT], via [TRAIT_ALLOW_HERETIC_CASTING], to remove the effect when we lose the focus trait
/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/proc/on_focus_lost(mob/source)
	SIGNAL_HANDLER

	unset_click_ability(source, refund_cooldown = TRUE)

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/InterceptClickOn(mob/living/caller, params, atom/click_target)
	// Let the caster prioritize using items like guns over blade casts
	if(caller.get_active_held_item())
		return FALSE
	// Let the caster prioritize melee attacks like punches and shoves over blade casts
	if(get_dist(caller, click_target) <= 1)
		return FALSE

	return ..()

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/on_activation(mob/on_who)
	. = ..()
	if(!.)
		return

	if(!isliving(on_who))
		return
	// Delete existing
	if(blade_effect)
		stack_trace("[type] had an existing blade effect in on_activation. This might be an exploit, and should be investigated.")
		UnregisterSignal(blade_effect, COMSIG_PARENT_QDELETING)
		QDEL_NULL(blade_effect)

	var/mob/living/living_user = on_who
	blade_effect = living_user.apply_status_effect(/datum/status_effect/warpstone_blade, null, projectile_amount, 25, 0.66 SECONDS)
	RegisterSignal(blade_effect, COMSIG_PARENT_QDELETING, .proc/on_status_effect_deleted)

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	QDEL_NULL(blade_effect)

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/before_cast(atom/cast_on)
	if(isnull(blade_effect) || !length(blade_effect.warpstone_blades))
		unset_click_ability(owner, refund_cooldown = TRUE)
		return SPELL_CANCEL_CAST

	return ..()

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/fire_projectile(mob/living/user, atom/target)
	. = ..()
	qdel(blade_effect.warpstone_blades[1])

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/ready_projectile(obj/projectile/to_launch, atom/target, mob/user, iteration)
	. = ..()
	to_launch.def_zone = check_zone(user.zone_selected)

/datum/action/cooldown/spell/pointed/projectile/warpstone_blade/proc/on_status_effect_deleted(datum/status_effect/warpstone_blade/source)
	SIGNAL_HANDLER

	blade_effect = null
	on_deactivation()

//Warpstone Dagger Status Effect
/datum/status_effect/warpstone_blade
	id = "Warpstone Dagger"
	alert_type = null
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = -1
	/// The number of blades we summon up to.
	var/max_num_blades = 4
	/// The radius of the blade's orbit.
	var/blade_orbit_radius = 30
	/// The time between spawning blades.
	var/time_between_initial_blades = 0.15 SECONDS
	/// If TRUE, we self-delete our status effect after all the blades are deleted.
	var/delete_on_blades_gone = TRUE
	/// A list of blade effects orbiting / protecting our owner
	var/list/obj/effect/warpstone_dagger/warpstone_blades = list()

/datum/status_effect/warpstone_blade/on_creation(
	mob/living/new_owner,
	new_duration = -1,
	max_num_blades = 4,
	blade_orbit_radius = 30,
	time_between_initial_blades = 0.15 SECONDS,
)

	src.duration = new_duration
	src.max_num_blades = max_num_blades
	src.blade_orbit_radius = blade_orbit_radius
	src.time_between_initial_blades = time_between_initial_blades
	return ..()

/datum/status_effect/warpstone_blade/on_apply()
	RegisterSignal(owner, COMSIG_HUMAN_CHECK_SHIELDS, .proc/on_warpstone_shield_reaction)
	for(var/blade_num in 1 to max_num_blades)
		var/time_until_created = (blade_num - 1) * time_between_initial_blades
		if(time_until_created <= 0)
			create_warpstone_blade()
		else
			addtimer(CALLBACK(src, .proc/create_warpstone_blade), time_until_created)

	return TRUE

/datum/status_effect/warpstone_blade/on_remove()
	UnregisterSignal(owner, COMSIG_HUMAN_CHECK_SHIELDS)
	QDEL_LIST(warpstone_blades)

	return ..()

/datum/status_effect/warpstone_blade/proc/create_warpstone_blade()
	if(QDELETED(src) || QDELETED(owner))
		return

	var/obj/effect/warpstone_dagger/blade = new(get_turf(owner))
	warpstone_blades += blade
	blade.orbit(owner, blade_orbit_radius)
	RegisterSignal(blade, COMSIG_PARENT_QDELETING, .proc/remove_warpstone_blade)
	playsound(get_turf(owner), 'sound/items/unsheath.ogg', 33, TRUE)

/datum/status_effect/warpstone_blade/proc/on_warpstone_shield_reaction(
	mob/living/carbon/human/source,
	atom/movable/hitby,
	damage = 0,
	attack_text = "the attack",
	attack_type = MELEE_ATTACK,
	armour_penetration = 0,
)
	SIGNAL_HANDLER

	if(!length(warpstone_blades))
		return

	if(HAS_TRAIT(source, TRAIT_BEING_BLADE_SHIELDED))
		return

	ADD_TRAIT(source, TRAIT_BEING_BLADE_SHIELDED, type)

	var/obj/effect/warpstone_dagger/to_remove = warpstone_blades[1]

	playsound(get_turf(source), 'sound/weapons/parry.ogg', 100, TRUE)
	source.visible_message(
		span_warning("[to_remove] orbiting [source] snaps in front of [attack_text], blocking it before vanishing!"),
		span_warning("[to_remove] orbiting you snaps in front of [attack_text], blocking it before vanishing!"),
		span_hear("You hear a clink."),
	)

	qdel(to_remove)

	addtimer(TRAIT_CALLBACK_REMOVE(source, TRAIT_BEING_BLADE_SHIELDED, type), 1)

	return SHIELD_BLOCK

/datum/status_effect/warpstone_blade/proc/remove_warpstone_blade(obj/effect/warpstone_dagger/to_remove)
	SIGNAL_HANDLER

	if(!(to_remove in warpstone_blades))
		CRASH("[type] called remove_warpstone_blade() with a blade that was not in its blades list.")

	to_remove.stop_orbit(owner.orbiters)
	warpstone_blades -= to_remove

	if(!length(warpstone_blades) && !QDELETED(src) && delete_on_blades_gone)
		qdel(src)

	return TRUE

//Warpstone Dagger Orbit Effect
/obj/effect/warpstone_dagger
	name = "warpstone dagger"
	icon = 'russstation/icons/obj/skaven.dmi'
	icon_state = "skaven_dagger"
	plane = GAME_PLANE_FOV_HIDDEN
	var/glow_color = "#a7ffc4"

/obj/effect/warpstone_dagger/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/movetype_handler)
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	add_filter("warpstone_dagger", 2, list("type" = "outline", "color" = glow_color, "size" = 1))

//Warpstone Dagger Projectile
/obj/projectile/warpstone
	name = "warpstone dagger"
	icon = 'russstation/icons/obj/skaven.dmi'
	icon_state = "skaven_dagger"
	hitsound = 'sound/weapons/pierce_slow.ogg'
	hitsound_wall = 'sound/weapons/plasma_cutter.ogg'
	speed = 2
	damage = 20
	armour_penetration = 75
	sharpness = SHARP_EDGED
	damage_type = TOX
	wound_bonus = 10
	pass_flags = PASSTABLE | PASSFLAPS

/obj/projectile/warpstone/Initialize(mapload)
	. = ..()
	add_filter("skaven_dagger", 2, list("type" = "outline", "color" = "#60ff95", "size" = 1))

/obj/projectile/warpstone/prehit_pierce(atom/hit)
	if(isliving(hit) && isliving(firer))
		var/mob/living/caster = firer
		var/mob/living/victim = hit
		if(caster == victim)
			return PROJECTILE_PIERCE_PHASE

		if(caster.mind)
			var/datum/antagonist/heretic_monster/monster = victim.mind?.has_antag_datum(/datum/antagonist/heretic_monster)
			if(monster?.master == caster.mind)
				return PROJECTILE_PIERCE_PHASE

	return ..()

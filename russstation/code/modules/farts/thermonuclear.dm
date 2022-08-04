/datum/fart/human/thermonuclear
	gas_id = "bz"
	gas_volume = 10
	hard_cooldown = 0.2 SECONDS
	/// has the explosion been triggered
	var/armed = FALSE

/datum/fart/human/thermonuclear/soft_fail(mob/living/user)
	user.visible_message(
		span_notice("[user] [pick("is letting out some serious heat!", "is blowing it up!")]"),
	)
	user.atmos_spawn_air("no2=[gas_volume];TEMP=[user.bodytemperature]")
	explosion(user, flame_range = 2)

/datum/fart/human/thermonuclear/hard_fail(mob/living/user)
	if(armed)
		return
	user.visible_message(
		span_danger("[user]'s ass is going supercritical!"),
	)
	user.set_timed_status_effect(2.8 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	user.Knockdown(2.8 SECONDS)
	playsound(user, 'sound/effects/huuu.ogg', 75)
	addtimer(CALLBACK(src, .proc/hard_fail_sound, user), 2.4 SECONDS)
	armed = TRUE;

/**
 * Trigger the sound before queuing the explosion
 */
/datum/fart/human/thermonuclear/proc/hard_fail_sound(mob/living/user)
	playsound(user, 'russstation/sound/effects/poo_thermonuclear.ogg', 75)
	addtimer(CALLBACK(src, .proc/end_hard_fail, user), 0.4 SECONDS)

/**
 * Boom!
 */
/datum/fart/human/thermonuclear/proc/end_hard_fail(mob/living/user)
	user.visible_message(
		span_userdanger("[user] rips a thermonuclear fart!"),
	)
	explosion(user, 0, 0, 4, 2, flame_range = 5, silent = TRUE)
	user.atmos_spawn_air("miasma=[1000];TEMP=[user.bodytemperature]")
	user.gib(TRUE, FALSE, FALSE)

/datum/fart/living/carbon/human/species/corporate
	gas_id = "bz"
	gas_volume = 10
	hard_cooldown = 0.2 SECONDS

/datum/fart/living/carbon/human/species/corporate/soft_fail(mob/living/user)
	user.visible_message(
		span_notice("[user] [pick("is letting out some serious heat!", "is blowing it up!")]"),
	)
	user.atmos_spawn_air("no2=[gas_volume];TEMP=[user.bodytemperature]")
	explosion(user, flame_range = 2)

/datum/fart/living/carbon/human/species/corporate/hard_fail(mob/living/user)
	user.visible_message(
		span_danger("[user]'s ass is going supercritical!"),
	)
	user.Jitter(2.8 SECONDS)
	user.Knockdown(2.8 SECONDS)
	playsound(user, 'sound/effects/huuu.ogg', 75)
	addtimer(CALLBACK(src, .proc/hard_fail_timer, user), 2.4 SECONDS)

/datum/fart/living/carbon/human/species/corporate/proc/hard_fail_timer(mob/living/user)
	playsound(user, 'russstation/sound/effects/poo_thermonuclear.ogg', 75)
	addtimer(CALLBACK(src, .proc/end_hard_fail, user), 0.4 SECONDS)

/datum/fart/living/carbon/human/species/corporate/proc/end_hard_fail(mob/living/user)
	user.visible_message(
		span_userdanger("[user] rips a thermonuclear fart!"),
	)
	explosion(user, 0, 0, 4, 2, flame_range = 5, silent = TRUE)
	user.atmos_spawn_air("miasma=[1000];TEMP=[user.bodytemperature]") // This shouldn't be making that much Miasma, otherwise the server will cry.
	user.gib(TRUE, FALSE, FALSE)

/datum/fart/living/carbon/human/species/corporate
	gas_id = "bz"
	gas_volume = 10
	hard_cooldown = 0.2 SECONDS

/datum/fart/living/carbon/human/soft_fail(mob/living/user)
	user.visible_message("<span class='notice'>[user] [pick("is letting out some serious heat!", "is blowing it up!")]</span>")
	user.atmos_spawn_air("no2=[gas_volume];TEMP=[user.bodytemperature]")
	explosion(user, flame_range = 2)

/datum/fart/living/carbon/human/hard_fail(mob/living/user)
	user.visible_message("<span class='danger'>[user]'s ass is going supercritical!</span>")
	user.Jitter(15)
	user.Knockdown(15)
	sleep(1 SECONDS)
	user.visible_message("<span class='userdanger'>[user] rips a thermonuclear fart!</span>")
	explosion(user, 0, 0, 4, 2, flame_range = 5)
	user.atmos_spawn_air("miasma=[gas_volume * 1000];TEMP=[user.bodytemperature]")
	user.gib(TRUE)

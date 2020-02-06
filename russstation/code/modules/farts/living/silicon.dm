/datum/fart/living/silicon
	sounds = list('russstation/sound/effects/mob_effects/poo_robot.ogg')

/datum/fart/living/silicon/soft_fail(mob/living/user)
	user.adjustFireLoss(fail_damage)
	to_chat(user, "<span class='notice'>A clunk comes from within your shell.</span>")

/datum/fart/living/silicon/hard_fail(mob/living/user)
	user.adjustFireLoss(fail_damage)
	user.Stun(1 SECONDS)
	to_chat(user, "<span class='notice'>You are unable to produce a synthetic fart as your circuitry overheats.</span>")

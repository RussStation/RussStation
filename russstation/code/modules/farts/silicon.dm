#define OIL_SPILL_CHANCE 50

/datum/fart/silicon
	sounds = list('russstation/sound/effects/mob_effects/poo_robot.ogg')
	fail_damage_type = FIRE
	soft_fail_message = "A clunk comes from within your shell."
	hard_fail_message = "You are unable to produce a synthetic fart as your circuitry overheats."

/datum/fart/silicon/hard_fail(mob/living/user)
	..()
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(R.emagged)
			new /obj/effect/decal/cleanable/oil/slippery(user.loc)
	if(prob(OIL_SPILL_CHANCE))
		new /obj/effect/decal/cleanable/oil(user.loc)

#undef OIL_SPILL_CHANCE

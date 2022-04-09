/// Confetti around the target
/datum/smite/confetti
	name = "Confetti"

/datum/smite/confetti/effect(client/user, mob/living/target)
	. = ..()
	var/turf/T = get_turf(target)
	new /obj/effect/gibspawner/confetti(T, target)

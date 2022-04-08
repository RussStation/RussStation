// Confetti + Gib smites combined
/datum/smite/confetti_gib
	name = "Confetti Gib"

/datum/smite/confetti_gib/effect(client/user, mob/living/target)
	. = ..()
	var/turf/T = get_turf(target)
	new /obj/effect/gibspawner/confetti(T, target)
	target.gib(/* no_brain = */ FALSE)

//a small confetti explosion, used for clown farts
/obj/effect/gibspawner/confetti
	gibtypes = list(/obj/effect/decal/cleanable/confetti, /obj/effect/decal/cleanable/confetti)
	gibamounts = list(3, 1) //seperated to leave one in place
	gib_mob_type = /mob/living/simple_animal/mouse/russ/clouse
	sound_to_play = 'russstation/sound/effects/confetti_partywhistle.ogg'
	sound_vol = 30

/obj/effect/gibspawner/confetti/Initialize()
	if(!gibdirections.len)
		gibdirections = list(GLOB.alldirs, list()) //3 will go in any direction one will not move
	return ..()

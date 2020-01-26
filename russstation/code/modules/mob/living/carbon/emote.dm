/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	cooldown = 0.5 SECONDS
	var/safe_cooldown = 2 SECONDS
	var/fail_chance = 20
	var/stink_damage = 5

/datum/emote/living/carbon/fart/get_sound(mob/living/user)
	if(ishuman(user))
		if(user.mind.assigned_role == "Clown" && prob(25)) //clowns have a chance to fart confetti
			var/turf/T = get_turf(user)
			new /obj/effect/gibspawner/confetti(T, user)
		return pick('russstation/sound/effects/mob_effects/poo1.ogg',
						'russstation/sound/effects/mob_effects/poo2.ogg',
						'russstation/sound/effects/mob_effects/poo3.ogg',
						'russstation/sound/effects/mob_effects/poo4.ogg')

/datum/emote/living/carbon/fart/check_cooldown(mob/user, intentional)
	var/mob/living/carbon/U = user
	if (U.IsStun())
		return FALSE

	var/previous_usage = user.emotes_used && user.emotes_used[src] // the base version changes user.emotes_used, so store it for later

	. = ..() // standard cooldown check

	if (!.) // if the cooldown check failed
		U.adjustToxLoss(stink_damage)
		U.Stun(1 SECONDS)
		to_chat(U, "<span class='notice'>You feel a sharp pain in your stomach and fail to produce any flatulence.</span>")
	else if (world.time - previous_usage < safe_cooldown && prob(fail_chance)) // if you're under the safe limit and failed a chance
		U.adjustToxLoss(stink_damage)
		to_chat(U, "<span class='notice'>You let out some gas, but it felt like something came with it.</span>")

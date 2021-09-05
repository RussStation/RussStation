/datum/round_event_control/portal_storm_honk
	name = "Portal Storm: Honk"
	typepath = /datum/round_event/portal_storm/portal_storm_honk
	weight = 5 // Same as aliums
	min_players = 10 // this can be a fairly dangerous event, but they also aren't hostile by default
	earliest_start = 30 MINUTES

/datum/round_event/portal_storm/portal_storm_honk
	boss_types = list(
		/mob/living/simple_animal/hostile/retaliate/clown/clownhulk = 1, \
		/mob/living/simple_animal/hostile/retaliate/clown/lube = 1, \
		/mob/living/simple_animal/hostile/retaliate/clown/banana = 1,
	)
	hostile_types = list(
		/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin = 6, \
		/mob/living/simple_animal/hostile/retaliate/clown = 4,
	)

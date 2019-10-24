//Default Clowns

/mob/living/simple_animal/hostile/retaliate/clown
	var/small_sprite_type

/mob/living/simple_animal/hostile/retaliate/clown/Initialize(mapload)
	. = ..()
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)


//Clown Hulk
/mob/living/simple_animal/hostile/retaliate/clown/clownhulk
	harm_intent_damage = 20
	melee_damage_lower = 20
	melee_damage_upper = 25
	small_sprite_type = /datum/action/small_sprite/clown/hulk

/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/proc/target_bodyparts(atom/the_target)
	var/list/parts = list()
	if(iscarbon(the_target))
		var/mob/living/carbon/C = the_target
		if(C.stat >= UNCONSCIOUS)
			for(var/X in C.bodyparts)
				var/obj/item/bodypart/BP = X
				if(BP.body_part != HEAD && BP.body_part != CHEST)
					if(BP.dismemberable)
						parts += BP
			return parts

/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/AttackingTarget()
	var/list/parts = target_bodyparts(target)
	if(parts)
		if(!parts.len)
			return FALSE
		var/obj/item/bodypart/BP = pick(parts)
		BP.dismember()
		return ..()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(prob(80))
			var/atom/throw_target = get_edge_target_turf(L, dir)
			L.throw_at(throw_target, rand(1,2), 7, src)
		else
			L.Paralyze(20)
			visible_message("<span class='danger'>[src] knocks [L] down!</span>")

//Chlown
/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/chlown
	small_sprite_type = /datum/action/small_sprite/clown/chlown

//Honcmunculus
/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/honcmunculus
	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 15
	environment_smash = ENVIRONMENT_SMASH_WALLS
	small_sprite_type = /datum/action/small_sprite/clown/honcmunculus

/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/honcmunculus/AttackingTarget()
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	return target.attack_animal(src)

//The Destroyer
/mob/living/simple_animal/hostile/retaliate/clown/clownhulk/destroyer
	small_sprite_type = /datum/action/small_sprite/clown/destroyer

//Russ Station Clowns

/mob/living/simple_animal/hostile/retaliate/clown/russ
	icon = 'russstation/icons/mob/clown_mobs.dmi'

//Goblin
/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin
	name = "clown goblin"
	desc = "A tiny walking mask and clown shoes. You want to honk his nose!"
	icon_state = "clowngoblin"
	icon_living = "clowngoblin"
	icon_dead = null
	response_help_simple = "honks the"
	response_help_continuous = "honks the"
	speak = list("Honk!")
	speak_emote = list("sqeaks")
	emote_see = list("honks")
	maxHealth = 100
	health = 100

	speed = -1
	turns_per_move = 1

	del_on_death = TRUE
	loot = list(/obj/item/clothing/mask/gas/clown_hat, /obj/item/clothing/shoes/clown_shoes)

//Lesser Goblin
/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin/lessergoblin
	name = "clown goblin"
	desc = "A tiny walking mask and clown shoes, kinda looks malnourished. You want to honk his nose!"
	icon_state = "clowngoblin"
	icon_living = "clowngoblin"
	icon_dead = null
	response_help_simple = "honks the"
	response_help_continuous = "honks the"
	speak = list("Honk!")
	speak_emote = list("sqeaks")
	emote_see = list("honks")
	maxHealth = 15
	health = 15
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5

	speed = -1
	turns_per_move = 1

	del_on_death = TRUE
	loot = list(/obj/item/reagent_containers/food/snacks/grown/russ/citrus/white)

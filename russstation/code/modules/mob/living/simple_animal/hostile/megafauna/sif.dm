/*
SIF (Sprites and ideas by MetalGearMan)

Sif spawns randomly in lavaland when it can, in the form of a sword which the user needs to interact with in order to summon Sif.

Speical attacks:
	- When Sif's able to he will charge his current target with 200% increased speed for 1 second, getting right next to his target.
	- Sif can also do an AOE spin attack.

	Links for videos on all of Sif's modes and attacks:

	Summon:			  https://bungdeep.com/Sif/Sif_Summon.mp4
	Angered Stage:	  https://bungdeep.com/Sif/Sif_Angered.mp4
	Enraged Stage:	  https://bungdeep.com/Sif/Sif_Enraged.mp4

	Projectile Dodge: https://bungdeep.com/Sif/Sif_Dodge.mp4

	AOE Spin:		  https://bungdeep.com/Sif/Sif_Spin.mp4
	Charge: 		  https://bungdeep.com/Sif/Sif_Charge.mp4
	Spin and Charge:  https://bungdeep.com/Sif/Sif_Spin_and_charge.mp4

	Death:			  https://bungdeep.com/Sif/Sif_Death.mp4

Sif has three stages:
 1. Normal state when it has health above 50%.
 2. When Sif reaches below 50% health it enters a angered state, which makes Sif's movement speed faster and attack speed slower,
 	with increased usage of specials.
 3. At 20% health Sif is significantly slowed but constantly doing special attacks.

WHEN SIF IS ANGERED (Stage 2):
	- Sif's specials take 50% less time to recharge from (Normal = 100) to (Angered = 50)
	- Sif's attack speed decreased by 30% and movement speed increased by 50%

WHEN SIF IS ENRAGED (Stage 3):
	- Sif's specials take 60% less time to recharge from (Angered = 50) to (Enraged = 30)
	- Sif is way slower but does more damage, as well as chances to dodge projectiles and melee attacks more often.

When Sif dies, it leaves behind a:
	!! Sword Of The Forsaken !! -> Giant ass sword that does damage. Small chance of blocking hits and almost no chance to block projectiles.
	!! Necklace Of The Forsaken !! -> Works by instantly reviving or fully healing the user at their discretion (one time use and can be used when dead, knocked out or alive)
	!! Dark Energy !! (If killed with a kinetic crusher) -> A Kinetic Crusher attachment which performs a bash attack for 100 damage (only works on big boy mobs like megafaunas)
Difficulty: Medium
*/

/mob/living/simple_animal/hostile/megafauna/sif
	name = "Great Brown Wolf Sif"
	desc = "Guardian of the abyss. Looks pretty pissed that you're here."
	health = 2000
	maxHealth = 2000
	movement_type = GROUND
	attacktext = "slashes"
	attack_sound = 'russstation/sound/effects/sif_slash.ogg'
	icon_state = "Great_Brown_Wolf"
	icon_living = "Great_Brown_Wolf"
	icon_dead = ""
	friendly = "stares down"
	icon = 'russstation/icons/mob/lavaland/sif.dmi'
	speak_emote = list("growls")
	armour_penetration = 50
	melee_damage_lower = 35
	melee_damage_upper = 35
	speed = 2
	pixel_x = -32 //Hit box perfectly centered
	move_to_delay = 3
	rapid_melee = 4
	melee_queue_distance = 10
	ranged = FALSE
	del_on_death = 1
	loot = list(/obj/structure/closet/crate/necropolis/sif)
	crusher_loot = list(/obj/structure/closet/crate/necropolis/sif/crusher)
	internal_type = /obj/item/gps/internal/sif
	medal_type = BOSS_MEDAL_SIF
	score_type = SIF_SCORE
	deathmessage = "falls into the abyss."
	deathsound = 'russstation/sound/effects/death_howl.ogg'
	var/can_special = 1 //Enables sif to do what he does best, spin and charge
	var/spinIntervals = 0 //Counts how many spins Sif does before setting spinning status to false
	var/spinning = FALSE //AOE spin special attack status
	var/charging = FALSE //dashing special attack status
	var/angered = FALSE //active at < 50% health
	var/enraged = FALSE //active at < 20% health
	var/stageTwo = FALSE
	var/stageThree = FALSE
	var/currentPower = 0 //Every few seconds this variable gets higher, when it gets high
						 //enough it will use a special attack then reset the variable to 0

//A living beacon for the sif ruins (hard to find sif considering the GPS only shows when sif is summoned)
//Spawns on a really small enclosed lava island that is hard to reach in Sifs ruins
/mob/living/simple_animal/hostile/megafauna/sif/living_beacon
	name = "Beacon"
	desc = "A robot that has a beacon on its back as well as tiny legs and muscular arms that it uses to walk with."
	health = 75
	maxHealth = 75
	movement_type = GROUND
	attacktext = "punches"
	attack_sound = 'sound/items/sheath.ogg'
	icon_state = "beacon"
	icon_living = "beacon"
	icon = 'russstation/icons/mob/lavaland/beacon.dmi'
	icon_dead = "beacon_dead"
	friendly = "pokes"
	speak_emote = list("mechanically moans")
	melee_damage_lower = 5
	melee_damage_upper = 5
	speed = 5
	pixel_x = 0 //reset hitbox from original
	move_to_delay = 4
	del_on_death = 0
	loot = list()
	crusher_loot = list()
	internal_type = /obj/item/gps/internal/sif
	deathmessage = "moans as the sound of its power begins to wind down."
	deathsound = 'sound/voice/borg_deathsound.ogg' 
	can_special = 0
	true_spawn = TRUE
	environment_smash = ENVIRONMENT_SMASH_NONE
	sentience_type = SENTIENCE_ARTIFICIAL
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK
	faction = list("mining")
	layer = MOB_LAYER

//no medals rewarded for killing the beacon
/mob/living/simple_animal/hostile/megafauna/sif/living_beacon/grant_achievement(medaltype, scoretype, crusher_kill, list/grant_achievement)
	return

//With a GPS sif can be identified by the "Infinity Signal".
/obj/item/gps/internal/sif
	icon_state = null
	gpstag = "Infinity Signal"
	desc = "The message keeps overflowing."
	invisibility = 100

//Sword structure, used to summon sif.
/obj/structure/sword/sif
	name = "Massive Glowing Sword"
	desc = "Sweet! A free sword!"
	max_integrity = 10000
	icon = 'russstation/icons/mob/lavaland/sif_sword.dmi'
	icon_state = "Idle_Sword"
	layer = HIGH_OBJ_LAYER //Looks better when its over everything... cause its huge

//When the sword is touched it will spawn sif.
/obj/structure/sword/sif/attack_hand(mob/user)
	icon_state = "Interact_Sword"
	playsound(get_turf(src.loc), 'sound/effects/curse1.ogg', 100, 1)
	spawn(30)
		if(!QDELETED(src))
			new /mob/living/simple_animal/hostile/megafauna/sif(get_turf(src.loc))
			visible_message("<span class='notice'>The ground shakes.</span>")
			playsound(get_turf(src.loc), 'sound/effects/curse3.ogg', 100, 1)
			playsound(get_turf(src.loc), 'sound/effects/meteorimpact.ogg', 100, 1)
			qdel(src)

//Sif's charge attack
/mob/living/simple_animal/hostile/megafauna/sif/proc/rush()

	//Target
	if(!target)
		return //Exit porc

	var/chargeturf = get_turf(target)

	//Targets turf
	if(!chargeturf)
		return //Exit proc

	var/dir = get_dir(src, chargeturf)
	var/turf/T = get_ranged_target_turf(chargeturf, dir, 2)

	//Turfs area
	if(!T)
		return //Exit proc

	//Start charging
	charging = TRUE
	DestroySurroundings()
	walk(src, 0)
	setDir(dir)
	var/movespeed = 0.7
	walk_to(src, T, movespeed)
	var/atom/prevLoc = target.loc
	sleep((get_dist(src, T) * movespeed) + 1)
	src.loc = prevLoc
	walk(src, 0)
	charging = FALSE
	//Stop charging

/mob/living/simple_animal/hostile/megafauna/sif/Move()
	//Move
	..()

	//Can they perform these tasks?
	if(can_special == 1)

		//Charging currentPower every step
		if(!charging || !spinning)
			src.currentPower += 2

		//Sets sif's anger status.
		if(src.health <= 1000 && src.stageTwo == FALSE)
			angered()

		//Sets sifs enrage status.
		if(src.health <= 400 && src.stageThree == FALSE)
			enraged()

		//Whenever Sif moves he destroys walls in his way.
		if(src.angered == TRUE || src.enraged == TRUE)
			DestroySurroundings()

		//Normally Sif will do a special when he has 100 currentPower.
		if(src.angered == FALSE && src.currentPower >= 100)
			special()

		//Now requires 50 power when angery
		if(src.angered == TRUE && src.currentPower >= 50 && src.enraged == FALSE)
			special()

		//Now requires 30 power when enraged
		if(src.enraged == TRUE && src.currentPower >= 30)
			special()

		//visual effect
		if(src.charging == TRUE)
			new /obj/effect/temp_visual/decoy/fading(loc,src)
			DestroySurroundings()

//Sif's AOE spin attack
/mob/living/simple_animal/hostile/megafauna/sif/proc/spinAttack()
	src.spinning = TRUE
	spin(5,2)// Spin me boi

//Chance to dodge projectiles when angered or enraged
/mob/living/simple_animal/hostile/megafauna/sif/bullet_act(obj/item/projectile/P)
	var/passed = 0

	if(angered)
		switch(rand(0,100))
			if(0 to 1)
				passed = 1

	if(enraged)
		switch(rand(0,100))
			if(0 to 5)
				passed = 1

	if(passed == 1)
		visible_message("<span class='danger'>[src] dodged the projectile!</span>", "<span class='userdanger'>You dodge the projectile!</span>")
		playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 300, 1)
		return 0

	return ..()

//Sets Sif's angered stats
/mob/living/simple_animal/hostile/megafauna/sif/proc/angered()
	src.angered = TRUE
	src.stageTwo = TRUE
	src.visible_message("<span class='userdanger'>[src] lets out a ear ripping howl!</span>", "<span class='userdanger'>[src] lets out an ear ripping roar!</span>")
	playsound(src, 'russstation/sound/effects/howl.ogg', 100, 1)
	var/mob/living/L = target
	shake_camera(L, 4, 3)
	src.speed = 10
	src.move_to_delay = 2
	src.melee_damage_lower = 25
	src.melee_damage_upper = 25
	src.rapid_melee = 6

//Sets Sif's enraged stats
/mob/living/simple_animal/hostile/megafauna/sif/proc/enraged()
	src.stageThree = TRUE
	src.enraged = TRUE
	src.visible_message("<span class='userdanger'>[src] lets out a ear ripping yelp!</span>", "<span class='userdanger'>[src] lets out an ear ripping yelp!</span>")
	playsound(src, 'russstation/sound/effects/howl.ogg', 100, 1)
	var/mob/living/L = target
	shake_camera(L, 8, 6)
	src.speed = 4
	src.move_to_delay = 4
	src.melee_damage_lower = 30
	src.melee_damage_upper = 30
	src.rapid_melee = 8
	src.dodge_prob = 65

//Chooses a random special
/mob/living/simple_animal/hostile/megafauna/sif/proc/special()
	src.currentPower = 0
	switch(rand(1,2))
		if(1)
			rush()
		if(2)
			spinAttack()

/mob/living/simple_animal/hostile/megafauna/sif/proc/default_attackspeed()
	if(stageTwo)
		src.move_to_delay = 2
		return 10
	if(stageThree)
		src.move_to_delay = 4
		return 4

	src.move_to_delay = 3
	return 2

/mob/living/simple_animal/hostile/megafauna/sif/do_attack_animation(atom/A, visual_effect_icon)
	if(charging == FALSE)
		..()

//Attack speed delay
/mob/living/simple_animal/hostile/megafauna/sif/AttackingTarget()
	if(charging == FALSE)
		. = ..()
		if(.)
			recovery_time = world.time + 7

/mob/living/simple_animal/hostile/megafauna/sif/Goto(target, delay, minimum_distance)
	if(charging == FALSE)
		..()

/mob/living/simple_animal/hostile/megafauna/sif/MoveToTarget(list/possible_targets)
	if(charging == FALSE)
		..()

//Immune to explosions when spinning or charging
/mob/living/simple_animal/hostile/megafauna/sif/ex_act(severity, target)
	return 0

//stop spinning if you lose the target
/mob/living/simple_animal/hostile/megafauna/sif/LoseTarget()
	. = ..()
	if(spinning)
		icon_state = "Great_Brown_Wolf"
		src.spinIntervals = 0
		spinning = FALSE
		src.speed = default_attackspeed()

/mob/living/simple_animal/hostile/megafauna/sif/Moved()

	if(can_special == 1)

		if(charging == TRUE)
			DestroySurroundings()

		//Stop spinning 
		if(src.spinIntervals == 5)
			icon_state = "Great_Brown_Wolf"
			src.spinIntervals = 0
			spinning = FALSE
			src.speed = default_attackspeed()

		//Start spinning
		if(spinning == TRUE)
			icon_state = "Great_Brown_Wolf_Spin"
			src.spinIntervals += 1
			if(isturf(src.loc) || isobj(src.loc) && src.loc.density)
				src.ex_act(EXPLODE_HEAVY)
				explosion(get_turf(src), 0, 0, 4, 0, adminlog = FALSE, ignorecap = FALSE, flame_range = 0, silent = TRUE, smoke = FALSE)
				playsound(src, pick('russstation/sound/effects/whoosh1.ogg', 'russstation/sound/effects/whoosh2.ogg', 'russstation/sound/effects/whoosh3.ogg'), 300, 1)
				playsound(src, 'russstation/sound/effects/blade_spin.ogg', 400, 1)
				if(angered)
					src.speed = 8
					src.move_to_delay = 2

	playsound(src, 'sound/effects/meteorimpact.ogg', 200, 1, 2, 1)
	..()

//Activated when sif collides with target when charging.
/mob/living/simple_animal/hostile/megafauna/sif/Bump(atom/A)
	if(charging == TRUE)
		if(isturf(A) || isobj(A) && A.density)
			A.ex_act(EXPLODE_HEAVY)
		DestroySurroundings()
		if(isliving(A))
			var/mob/living/L = A
			L.visible_message("<span class='danger'>[src] stomps on [L]!</span>", "<span class='userdanger'>[src] stomps on you!</span>")
			src.forceMove(get_turf(L))
			L.apply_damage(20, BRUTE)
			playsound(get_turf(L), 'russstation/sound/effects/sif_stomp.ogg', 400, 1)
			shake_camera(L, 4, 3)
			shake_camera(src, 2, 3)
	..()

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=Sword Of The Forsaken=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//

/*Videos on what the sword can do:
**
**Attacking: ----------	https://bungdeep.com/Sif/Sword_of_the_Forsaken_Attack.mp4
**Butchering: --------- https://bungdeep.com/Sif/Sword_of_the_Forsaken_Butcher.mp4
**Dodging: ------------ https://bungdeep.com/Sif/Sword_of_the_Forsaken_Block_Melee.png
**Projectile Dodging: - https://bungdeep.com/Sif/Sword_of_the_Forsaken_Block.png
**
*/
/obj/item/melee/sword_of_the_forsaken
	name = "Sword of the Forsaken"
	desc = "A glowing giant heavy blade that grows and slightly shrinks in size depending on the wielder's strength."
	icon = 'russstation/icons/obj/items_and_weapons.dmi'
	icon_state = "sword_of_the_forsaken"
	item_state = "sword_of_the_forsaken"
	lefthand_file = 'russstation/icons/mob/inhands/item_lefthand.dmi'
	righthand_file = 'russstation/icons/mob/inhands/item_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 15
	throwforce = 10
	block_chance = 10
	armour_penetration = 80
	hitsound = 'russstation/sound/effects/sif_slash.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut", "gutted", "gored")
	sharpness = IS_SHARP
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

//Enables the sword to butcher bodies
/obj/item/melee/sword_of_the_forsaken/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 50, 100, 10)

//Sword blocking attacks, really hard to block projectiles but still possible.
/obj/item/melee/sword_of_the_forsaken/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 5
	return ..()

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=End of Sworf Of The Forsaken=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=Necklace Of The Forsaken=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//

/*Videos on what the necklace can do:
**
**Binding the necklace to yourself: ------- https://bungdeep.com/Sif/Necklace_of_the_Forsaken_Binding.mp4
**Reviving when died: --------------------- https://bungdeep.com/Sif/Necklace_of_the_Forsaken_Death_Revive.mp4
**Becomes a cosmetic item after it is used: https://bungdeep.com/Sif/Necklace_of_the_Forsaken_Revive_Used.png
**
*/
/obj/item/clothing/neck/necklace/necklace_of_the_forsaken
	name = "Necklace of the Forsaken"
	desc = "A rose gold necklace with a small static ember that burns inside of the black gem stone, making it warm to the touch."
	icon = 'russstation/icons/obj/lavaland/artefacts.dmi'
	icon_state = "necklace_forsaken_active"
	actions_types = list(/datum/action/item_action/hands_free/necklace_of_the_forsaken)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/carbon/human/active_owner
	var/numUses = 1

/obj/item/clothing/neck/necklace/necklace_of_the_forsaken/item_action_slot_check(slot)
	return slot == SLOT_NECK

/obj/item/clothing/neck/necklace/necklace_of_the_forsaken/dropped(mob/user)
	..()
	if(active_owner)
		remove_necklace()

//Apply a temp buff until the necklace is used
/obj/item/clothing/neck/necklace/necklace_of_the_forsaken/proc/temp_buff(mob/living/carbon/human/user)
	to_chat(user, "<span class='warning'>You feel as if you have a second chance at something, but you're not sure what.</span>")
	if(do_after(user, 40, target = user))
		to_chat(user, "<span class='notice'>The ember warms you...</span>")
		ADD_TRAIT(user, TRAIT_NOHARDCRIT, "necklace_of_the_forsaken")//less chance of being gibbed
		active_owner = user

//Revive the user and remove buffs
/obj/item/clothing/neck/necklace/necklace_of_the_forsaken/proc/second_chance()
	icon_state = "necklace_forsaken_active"
	if(!active_owner)
		return
	var/mob/living/carbon/human/H = active_owner
	active_owner = null
	to_chat(H, "<span class='userdanger'>You feel a scorching burn fill your body and limbs!</span>")
	H.revive(TRUE, FALSE)
	remove_necklace() //remove buffs

//Remove buffs
/obj/item/clothing/neck/necklace/necklace_of_the_forsaken/proc/remove_necklace()
	icon_state = "necklace_forsaken_active"
	if(!active_owner)
		return
	REMOVE_TRAIT(active_owner, TRAIT_NOHARDCRIT, "necklace_of_the_forsaken")
	active_owner = null //just in case

//Add action
/datum/action/item_action/hands_free/necklace_of_the_forsaken
	check_flags = NONE
	name = "Necklace of the Forsaken"
	desc = "Bind the necklaces ember to yourself, so that next time you activate it, it will revive or fully heal you whether dead or knocked out. (Beware of being gibbed)"

//What happens when the user clicks on datum
/datum/action/item_action/hands_free/necklace_of_the_forsaken/Trigger()
	var/obj/item/clothing/neck/necklace/necklace_of_the_forsaken/MM = target
	if(MM.numUses == 0)//skip if it has already been used up
		return
	if(!MM.active_owner)//apply bind if there is no active owner
		if(ishuman(owner))
			MM.temp_buff(owner)
		src.desc = "Revive or fully heal yourself, but you can only do this once! Can be used when knocked out or dead."
		to_chat(MM.active_owner, "<span class='userdanger'>You have binded the ember to yourself! The next time you use the necklace it will heal you!</span>")
	else if(MM.numUses == 1 && MM.active_owner)//revive / heal then remove usage
		MM.second_chance()
		MM.numUses = 0
		MM.icon_state = "necklace_forsaken"
		MM.desc = "A rose gold necklace that used to have a bright burning ember inside of it."
		src.desc = "The necklaces ember has already been used..."
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=End of Necklace of The Forsaken=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//


//Sifs loot chest
/obj/structure/closet/crate/necropolis/sif
	name = "Great Brown Wolf Sif's chest"

/obj/structure/closet/crate/necropolis/sif/PopulateContents()
	var/loot = rand(1,2)
	switch(loot)
		if(1)
			new /obj/item/melee/sword_of_the_forsaken(src)
		if(2)
			new /obj/item/clothing/neck/necklace/necklace_of_the_forsaken(src)

/obj/structure/closet/crate/necropolis/sif/crusher
	name = "Great Brown Wolf Sif's crusher chest"

/obj/structure/closet/crate/necropolis/sif/crusher/PopulateContents()
	new /obj/item/melee/sword_of_the_forsaken(src)
	new /obj/item/clothing/neck/necklace/necklace_of_the_forsaken(src)
	new /obj/item/crusher_trophy/dark_energy(src)

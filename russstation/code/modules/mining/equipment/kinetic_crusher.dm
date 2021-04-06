//Great brown wolf sif
/obj/item/crusher_trophy/dark_energy
	name = "dark energy"
	desc = "A black ball of energy that was formed when Sif miraculously imploded. Suitable as a trophy for a kinetic crusher."
	icon = 'russstation/icons/obj/lavaland/artefacts.dmi'
	icon_state = "sif_energy"
	denied_type = /obj/item/crusher_trophy/dark_energy
	bonus_value = 30

/obj/item/crusher_trophy/dark_energy/effect_desc()
	return "mark detonation to perform a bash dealing <b>[bonus_value]</b> damage"

/obj/item/crusher_trophy/dark_energy/on_mark_detonation(mob/living/target, mob/living/user)
	if(!target)
		return
	var/chargeturf = get_turf(target) //get target turf
	if(!chargeturf)
		return
	var/dir = get_dir(user, chargeturf)//get direction
	var/turf/T = get_ranged_target_turf(chargeturf,dir,2)//get range of the turf
	if(!T)
		return 
	playsound(user, pick('russstation/sound/effects/whoosh1.ogg', 'russstation/sound/effects/whoosh2.ogg', 'russstation/sound/effects/whoosh3.ogg'), 300, 1)
	new /obj/effect/temp_visual/decoy/fading(loc,user)
	//Start bashing
	walk(user,0)
	setDir(dir)
	var/movespeed = 0.7
	walk_to(user, T, movespeed)
	target.apply_damage(bonus_value, BRUTE) // Damage
	var/atom/prevLoc = target.loc
	user.loc = prevLoc
	walk(user, 0) 
	//Stop bashing
	new /obj/effect/temp_visual/decoy/fading(loc,user)
	playsound(user, 'sound/effects/meteorimpact.ogg', 200, 1, 2, 1)

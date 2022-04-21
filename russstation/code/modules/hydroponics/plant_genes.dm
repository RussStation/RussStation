
/**
 * Spawns a confetti gib when someone slips on it.
 * Because it's funny :)
 * Just like slippery skin, if we have a trash type this only functions on that. (Banana peels)
 */
/datum/plant_gene/trait/plant_confetti
	name = "Farceur Emission"
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE

/datum/plant_gene/trait/plant_confetti/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(grown_plant) && ispath(grown_plant.trash_type, /obj/item/grown))
		return

	RegisterSignal(our_plant, COMSIG_PLANT_ON_SLIP, .proc/confetti)

/*
 * Spawn the confetti!
 *
 * our_plant - the source plant that was slipped on
 * target - the atom that slipped on the plant
 */
/datum/plant_gene/trait/plant_confetti/proc/confetti(obj/item/our_plant, atom/target)
	SIGNAL_HANDLER

	if(isliving(target))
		var/mob/living/source_mob = target
		var/turf/T = get_turf(source_mob)
		new /obj/effect/gibspawner/confetti(T, source_mob)

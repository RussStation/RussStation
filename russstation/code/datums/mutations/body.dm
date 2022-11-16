//Lesser Dwarfism only shrinks you.
/datum/mutation/human/lesser_dwarfism
	name = "Dwarfism"
	desc = "A mutation believed to be the cause of dwarfism."
	quality = POSITIVE
	difficulty = 16
	instability = 5
	conflicts = list(/datum/mutation/human/gigantism)//not adding dwarfism to list cause it would be funny to see a dwarf get dwarfism
	locked = TRUE  // Default intert species for now, so locked from regular pool.

/datum/mutation/human/lesser_dwarfism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_LESSER_DWARFISM, GENETIC_MUTATION)
	var/matrix/new_transform = matrix()
	new_transform.Scale(1, 0.8)
	owner.transform = new_transform.Multiply(owner.transform)
	owner.visible_message(span_danger("[owner] suddenly shrinks!"), span_notice("Everything around you seems to grow.."))

/datum/mutation/human/lesser_dwarfism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_LESSER_DWARFISM, GENETIC_MUTATION)
	var/matrix/new_transform = matrix()
	new_transform.Scale(1, 1.25)
	owner.transform = new_transform.Multiply(owner.transform)
	owner.visible_message(span_danger("[owner] suddenly grows!"), span_notice("Everything around you seems to shrink.."))

/obj/item/organ/tail/skaven
	name = "skaven tail"
	desc = "A nasty severed skaven tail. They lose these all the time."
	color = "#2e2e2e"
	tail_type = "Skaven"

/obj/item/organ/tail/skaven/Insert(mob/living/carbon/human/tail_owner, special, drop_if_replaced)
	..()
	if(istype(tail_owner))
		var/default_part = tail_owner.dna.species.mutant_bodyparts["tail_skaven"]
		if(!default_part || default_part == "None")
			tail_owner.dna.features["tail_skaven"] = tail_owner.dna.species.mutant_bodyparts["tail_skaven"] = tail_type

		tail_owner.update_body()

/obj/item/organ/tail/skaven/Remove(mob/living/carbon/human/tail_owner, special = FALSE)
	..()
	if(istype(tail_owner))
		tail_owner.dna.species.mutant_bodyparts -= "tail_skaven"
		tail_type = tail_owner.dna.features["tail_skaven"]
		color = "#dec9b4"
		tail_owner.update_body()

/obj/item/organ/tail/skaven/before_organ_replacement(obj/item/organ/replacement)
	. = ..()
	var/obj/item/organ/tail/skaven/new_tail = replacement

	if(!istype(new_tail))
		return

	new_tail.tail_type = tail_type


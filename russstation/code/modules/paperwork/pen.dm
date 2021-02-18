
/obj/item/pen/laughter/attack(mob/living/M, mob/user)
	if(!istype(M))
		return

	if(..())
		if(reagents.total_volume)
			if(M.reagents)

				reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = INJECT)


/obj/item/pen/laughter/Initialize()
	. = ..()
	create_reagents(25, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/toxin/lexorin, 5)
	reagents.add_reagent(/datum/reagent/consumable/superlaughter/traitor_pen, 20)
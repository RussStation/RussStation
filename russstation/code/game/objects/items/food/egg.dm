/obj/item/food/egg/iceegg
	name = "Ice Egg"
	desc = "Can withstand the coldest of temperatures so the chicks can survive."
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "ice-egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 4, /datum/reagent/consumable/eggwhite = 6)
	decomp_type = /obj/item/food/egg/rotten/iceegg
	decomp_req_handle = TRUE //Eggs will become icemoon chicks

/obj/item/food/egg/iceegg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)

	if(prob(13) && chick_count < MAX_CHICKENS)
		new /mob/living/simple_animal/chick/icemoon(hit_turf)
		chick_count++

	reagents.expose(hit_atom, TOUCH)
	qdel(src)

/obj/item/food/egg/iceegg/process(delta_time)
	if(isturf(loc))
		amount_grown += rand(1,2) * delta_time
		if(amount_grown >= 200)
			visible_message(span_notice("[src] hatches with a quiet cracking sound."))
			new /mob/living/simple_animal/chick/icemoon(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/food/egg/lavaegg
	name = "Lava Egg"
	desc = "Encased in a hard obsidian like material."
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "lava-egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 4, /datum/reagent/consumable/eggwhite = 6)
	decomp_type = /obj/item/food/egg/rotten/lavaegg
	decomp_req_handle = TRUE //Eggs will become lavaland chicks

/obj/item/food/egg/lavaegg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)

	if(prob(13) && chick_count < MAX_CHICKENS)
		new /mob/living/simple_animal/chick/lavaland(hit_turf)
		chick_count++

	reagents.expose(hit_atom, TOUCH)
	qdel(src)

/obj/item/food/egg/lavaegg/process(delta_time)
	if(isturf(loc))
		amount_grown += rand(1,2) * delta_time
		if(amount_grown >= 200)
			visible_message(span_notice("[src] hatches with a quiet cracking sound."))
			new /mob/living/simple_animal/chick/lavaland(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/food/egg/rotten/iceegg
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "ice-egg"

/obj/item/food/egg/rotten/lavaegg
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "lava-egg"

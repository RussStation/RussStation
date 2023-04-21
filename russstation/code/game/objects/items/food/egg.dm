/obj/item/food/egg/iceegg
	name = "Ice Egg"
	desc = "Can withstand the coldest of temperatures so the chicks can survive."
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "ice-egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 4, /datum/reagent/consumable/eggwhite = 6)
	decomp_type = /obj/item/food/egg/rotten/iceegg
	decomp_req_handle = TRUE //Eggs will become icemoon chicks
	var/fertile = TRUE

/obj/item/food/egg/iceegg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)

	if(GLOB.chicks_from_eggs < MAX_CHICKENS)
		var/chance = rand(0, 255)
		switch(chance)
			if(0 to 30)
				new /mob/living/simple_animal/chick/icemoon(hit_turf)
				GLOB.chicks_from_eggs++
				visible_message(span_notice("A chick comes out of the cracked egg!"))
			if(31)
				var/spawned_chickens = min(4, MAX_CHICKENS - GLOB.chicks_from_eggs) // We don't want to go over the limit
				visible_message(span_notice("[spawned_chickens] chicks come out of the egg! Jackpot!"))
				for(var/i in 1 to spawned_chickens)
					new /mob/living/simple_animal/chick/icemoon(hit_turf)
					GLOB.chicks_from_eggs++
	qdel(src)

/obj/item/food/egg/iceegg/Initialize(mapload, loc)
	. = ..()

	AddComponent(/datum/component/fertile_egg,\
		embryo_type = /mob/living/simple_animal/chick/icemoon,\
		minimum_growth_rate = 1,\
		maximum_growth_rate = 2,\
		total_growth_required = 200,\
		current_growth = 0,\
		location_allowlist = typecacheof(list(/turf)),\
		spoilable = FALSE,\
	)

/obj/item/food/egg/lavaegg
	name = "Lava Egg"
	desc = "Encased in a hard obsidian like material."
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "lava-egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 4, /datum/reagent/consumable/eggwhite = 6)
	decomp_type = /obj/item/food/egg/rotten/lavaegg
	decomp_req_handle = TRUE //Eggs will become lavaland chicks
	var/fertile = TRUE

/obj/item/food/egg/lavaegg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)

	if(GLOB.chicks_from_eggs < MAX_CHICKENS)
		var/chance = rand(0, 255)
		switch(chance)
			if(0 to 30)
				new /mob/living/simple_animal/chick/lavaland(hit_turf)
				GLOB.chicks_from_eggs++
				visible_message(span_notice("A chick comes out of the cracked egg!"))
			if(31)
				var/spawned_chickens = min(4, MAX_CHICKENS - GLOB.chicks_from_eggs) // We don't want to go over the limit
				visible_message(span_notice("[spawned_chickens] chicks come out of the egg! Jackpot!"))
				for(var/i in 1 to spawned_chickens)
					new /mob/living/simple_animal/chick/lavaland(hit_turf)
					GLOB.chicks_from_eggs++
	qdel(src)

/obj/item/food/egg/lavaegg/Initialize(mapload, loc)
	. = ..()

	AddComponent(/datum/component/fertile_egg,\
		embryo_type = /mob/living/simple_animal/chick/lavaland,\
		minimum_growth_rate = 1,\
		maximum_growth_rate = 2,\
		total_growth_required = 200,\
		current_growth = 0,\
		location_allowlist = typecacheof(list(/turf)),\
		spoilable = FALSE,\
	)

/obj/item/food/egg/rotten/iceegg
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "ice-egg"

/obj/item/food/egg/rotten/lavaegg
	icon = 'russstation/icons/obj/food/food.dmi'
	icon_state = "lava-egg"

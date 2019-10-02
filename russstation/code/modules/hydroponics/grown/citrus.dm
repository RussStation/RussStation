//Start Reason: fuck you, goblins

//White
/obj/item/seeds/russ/white
	name = "pack of white seeds"
	desc = "Sweet seeds."
	icon_state = "seed-white"
	species = "white"
	plantname = "White Tree"
	product = /obj/item/reagent_containers/food/snacks/grown/russ/citrus/white
	lifespan = 70
	endurance = 20
	potency = 40
	icon_grow = "lime-grow"
	icon_harvest = "white-harvest"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/slip)
	mutatelist = list(/obj/item/seeds/russ/goblin)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/sodium = 0.5, /datum/reagent/consumable/sugar = 0.1)

/obj/item/reagent_containers/food/snacks/grown/russ/citrus/white
	seed = /obj/item/seeds/russ/white
	name = "white"
	desc = "It's a very sweet fruit. The color white was named after the fruit of this tree."
	icon_state = "white"
	juice_results = list(/datum/reagent/consumable/whitejuice = 0)
	filling_color = "#FFFFFF"

//Gnorange
/obj/item/seeds/russ/goblin
	name = "pack of gnorange seeds"
	desc = "These seeds have a funny feeling to them."
	icon_state = "seed-goblin"
	species = "gnorange"
	plantname = "Gnorange Tree"
	product = /obj/item/reagent_containers/food/snacks/grown/russ/citrus/goblin
	lifespan = 70
	endurance = 20
	icon_grow = "lime-grow"
	icon_harvest = "white-harvest"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/squash, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/potassium = 0.1, /datum/reagent/consumable/sugar = 0.3, /datum/reagent/sodium = 0.4, /datum/reagent/toxin/cyanide = 0.1, /datum/reagent/blood/ = 0.1)
	rarity = 50

/obj/item/reagent_containers/food/snacks/grown/russ/citrus/goblin
	seed = /obj/item/seeds/russ/goblin
	name = "gnorange"
	desc = "You think you hear a faint honk coming from within the fruit. That or the clown is stuck in the vents again."
	icon_state = "gnorange"
	var/awakening = 0
	filling_color = "#FFFFFF"
	distill_reagent = "demonsblood"

/obj/item/reagent_containers/food/snacks/grown/russ/citrus/goblin/attack(mob/M, mob/user, def_zone)
	if(awakening)
		to_chat(user, "<span class='warning'>The goblin is twitching and shaking, preventing you from eating it.</span>")
		return
	..()

/obj/item/reagent_containers/food/snacks/grown/russ/citrus/goblin/attack_self(mob/user)
	if(awakening || istype(user.loc, /turf/open/space))
		return
	to_chat(user, "<span class='notice'>You begin to awaken the goblin...</span>")
	awakening = 1

	spawn(30)
		if(!QDELETED(src))
			var/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin/lessergoblin/G = new /mob/living/simple_animal/hostile/retaliate/clown/russ/goblin/lessergoblin(get_turf(loc))
			G.maxHealth += round(seed.endurance / 4)
			G.melee_damage_lower += round(seed.potency / 15)
			G.melee_damage_upper += round(seed.potency / 15)
			G.move_to_delay -= round(seed.production / 35)
			G.health = G.maxHealth
			G.visible_message("<span class='notice'>The goblin starts shaking it's feet viciously as it opens it's eyes.</span>")
			qdel(src)

//slime limes!
/obj/item/seeds/russ/slimelime
	name = "pack of slime lime seeds"
	desc = "Almost seems like a pack of gummy candy"
	icon_state = "seed-slimelime"
	species = "slimelime"
	plantname = "Slime Lime Tree"
	product = /obj/item/reagent_containers/food/snacks/grown/russ/citrus/slimelime
	lifespan = 25
	endurance = 25
	production = 2
	icon_grow = "slimelime-grow"
	icon_harvest = "slimelime-harvest"
	icon_dead = "slimelime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/squash)
	reagents_add = list(/datum/reagent/toxin/slimejelly = 0.05, /datum/reagent/consumable/nutriment/vitamin = 0.09, /datum/reagent/consumable/limejuice = 0.1)
	rarity = 80

/obj/item/reagent_containers/food/snacks/grown/russ/citrus/slimelime
	seed = /obj/item/seeds/russ/slimelime
	name = "slime lime"
	desc = "A sticky and transparent lime, made of slime!."
	icon_state = "slimelime"
	filling_color = "#00FF00"
	juice_results = list(/datum/reagent/consumable/limejuice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/booger




//end

//Mystery Pod
/obj/item/seeds/russ/mystery
	name = "pack of mystery pod seeds"
	desc = "These seeds grow into mystery pods. These seeds are said to have come from a dead singuloth."
	growing_icon = 'russstation/icons/obj/hydroponics/growing.dmi'
	icon_state = "seed-mysterypod"
	species = "mysterypod"
	plantname = "Mystery Pod"
	product = /obj/item/reagent_containers/food/snacks/grown/russ/mystery_pod
	lifespan = 40
	endurance = 20
	production = 1
	yield = 2
	icon_grow = "mysterypod-grow"
	icon_dead = "mysterypod-dead"
	reagents_add = list(/datum/reagent/consumable/nothing = 0.5)

/obj/item/reagent_containers/food/snacks/grown/russ/mystery_pod
	seed = /obj/item/seeds/russ/mystery
	name = "mystery pod"
	desc = "Feels extremely heavy. Whats inside this thing?"
	icon_state = "mystery"
	filling_color = "#000000"


/obj/item/reagent_containers/food/snacks/grown/russ/mystery_pod/attack_self(mob/user)
	var/B
	var/num = 25


	if(seed.potency > 90)//speshal things when the potency is really high
		switch(rand(0,106))
			if(0 to 70)
				B = get_random_thing(user)
			if(71)
				B = /obj/machinery/chem_master
			if(72 to 77)
				B = pick(/obj/item/grenade/chem_grenade,
				/obj/item/grenade/chem_grenade/large,
				/obj/item/grenade/chem_grenade/cryo,
				/obj/item/grenade/chem_grenade/pyro,
				/obj/item/grenade/chem_grenade/adv_release)

			if(78) B = pick(/obj/machinery/computer/arcade/amputation,
			    /obj/machinery/computer/arcade/orion_trail,
			    /obj/machinery/computer/arcade/orion_trail/kobayashi,
			    /obj/machinery/computer/arcade/battle)
			if(79)
				B = /obj/machinery/vending/donksofttoyvendor
			if(80 to 85)
				B = /obj/effect/spawner/lootdrop/maintenance/eight
			if(86 to 88)
				B = /obj/effect/spawner/lootdrop/snowdin/dungeonlite
			if(89)
				B = /obj/item/toy/windupToolbox
			if(90 to 94)
				B = /obj/structure/closet/crate/secure/loot
			if(95)
				B = /obj/effect/spawner/lootdrop/seed_vault
			if(96)
				B = /obj/effect/spawner/lootdrop/organ_spawner
			if(97 to 99)
				B = /obj/item/gun/energy/laser/retro/old
			if(100 to 103)
				B = pick(/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot,
				/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot,
				/obj/item/gun/ballistic/automatic/toy/pistol/riot/unrestricted)
			if(104)
				B = /obj/item/storage/box/syndie_kit/chemical
			if(105)
				B = /obj/item/kitchen/knife/rainbowknife
			if(106)
				B = /obj/machinery/autolathe/hacked
	else
		B = get_random_thing(user)

	to_chat(user, "<span class='notice'>You forcefully crack open the purple pod.</span>")
	new B(get_turf(user), num)
	qdel(src)

//Get a random item
/obj/item/proc/get_random_thing(mob/user)
	var/B
	var/num = 1

	switch(rand(0,213))
		if(0 to 19)
			B = pick(/obj/item/seeds/ambrosia,
			/obj/item/seeds/ambrosia/deus,
			/obj/item/seeds/ambrosia/gaia,
			/obj/item/seeds/russ/bung,
			/obj/item/seeds/apple/gold,
			/obj/item/seeds/apple,
			/obj/item/seeds/banana,
			/obj/item/seeds/banana/mime,
			/obj/item/seeds/banana/bluespace,
			/obj/item/seeds/soya/koi,
			/obj/item/seeds/soya,
			/obj/item/seeds/berry,
			/obj/item/seeds/berry/poison,
			/obj/item/seeds/berry,
			/obj/item/seeds/berry/death,
			/obj/item/seeds/berry/glow,
			/obj/item/seeds/cherry/blue,
			/obj/item/seeds/cherry/bomb,
			/obj/item/seeds/cherry,
			/obj/item/seeds/grape,
			/obj/item/seeds/grape/green,
			/obj/item/seeds/cannabis/rainbow,
			/obj/item/seeds/cannabis,
			/obj/item/seeds/cannabis/death,
			/obj/item/seeds/cannabis/white,
			/obj/item/seeds/cannabis/ultimate,
			/obj/item/seeds/wheat,
			/obj/item/seeds/wheat/oat,
			/obj/item/seeds/wheat/rice,
			/obj/item/seeds/wheat/meat,
			/obj/item/seeds/chili,
			/obj/item/seeds/chili/ice,
			/obj/item/seeds/chili/ghost,
			/obj/item/seeds/lime,
			/obj/item/seeds/orange,
			/obj/item/seeds/russ/white,
			/obj/item/seeds/russ/goblin,
			/obj/item/seeds/lemon,
			/obj/item/seeds/firelemon,
			/obj/item/seeds/cocoapod,
			/obj/item/seeds/cocoapod/vanillapod,
			/obj/item/seeds/corn,
			/obj/item/seeds/corn/snapcorn,
			/obj/item/seeds/eggplant,
			/obj/item/seeds/eggplant/eggy,
			/obj/item/seeds/poppy,
			/obj/item/seeds/poppy/lily,
			/obj/item/seeds/poppy/geranium,
			/obj/item/seeds/harebell,
			/obj/item/seeds/sunflower,
			/obj/item/seeds/sunflower/moonflower,
			/obj/item/seeds/sunflower/novaflower,
			/obj/item/seeds/grass,
			/obj/item/seeds/grass/carpet,
			/obj/item/seeds/watermelon,
			/obj/item/seeds/glowshroom/shadowshroom,
			/obj/item/seeds/glowshroom,
			/obj/item/seeds/watermelon/holy,
			/obj/item/seeds/starthistle,
			/obj/item/seeds/cabbage,
			/obj/item/seeds/sugarcane,
			/obj/item/seeds/reishi,
			/obj/item/seeds/amanita,
			/obj/item/seeds/angel,
			/obj/item/seeds/liberty,
			/obj/item/seeds/plump/walkingmushroom,
			/obj/item/seeds/plump,
			/obj/item/seeds/chanter,
			/obj/item/seeds/glowshroom/glowcap,
			/obj/item/seeds/nettle,
			/obj/item/seeds/nettle/death,
			/obj/item/seeds/russ/mystery,
			/obj/item/seeds/onion,
			/obj/item/seeds/onion/red,
			/obj/item/seeds/pineapple,
			/obj/item/seeds/potato,
			/obj/item/seeds/potato/sweet,
			/obj/item/seeds/pumpkin,
			/obj/item/seeds/pumpkin/blumpkin,
			/obj/item/seeds/replicapod,
			/obj/item/seeds/carrot,
			/obj/item/seeds/carrot/parsnip,
			/obj/item/seeds/whitebeet,
			/obj/item/seeds/redbeet,
			/obj/item/seeds/tea/astra,
			/obj/item/seeds/tea,
			/obj/item/seeds/coffee/robusta,
			/obj/item/seeds/coffee,
			/obj/item/seeds/tobacco/space,
			/obj/item/seeds/tobacco,
			/obj/item/seeds/tomato/blue,
			/obj/item/seeds/tomato/blood,
			/obj/item/seeds/tomato/blue/bluespace,
			/obj/item/seeds/tomato/killer,
			/obj/item/seeds/tomato,
			/obj/item/seeds/tower,
			/obj/item/seeds/tower/steel,
			/obj/item/seeds/ambrosia,
			/obj/item/seeds/ambrosia/deus,
			/obj/item/seeds/ambrosia/gaia,
			/obj/item/seeds/russ/bung,
			/obj/item/seeds/apple/gold,
			/obj/item/seeds/apple,
			/obj/item/seeds/banana,
			/obj/item/seeds/banana/mime,
			/obj/item/seeds/banana/bluespace,
			/obj/item/seeds/soya/koi,
			/obj/item/seeds/soya,
			/obj/item/seeds/berry,
			/obj/item/seeds/berry/poison,
			/obj/item/seeds/berry,
			/obj/item/seeds/berry/death,
			/obj/item/seeds/berry/glow,
			/obj/item/seeds/cherry/blue,
			/obj/item/seeds/cherry/bomb,
			/obj/item/seeds/cherry,
			/obj/item/seeds/grape,
			/obj/item/seeds/grape/green,
			/obj/item/seeds/cannabis/rainbow,
			/obj/item/seeds/cannabis,
			/obj/item/seeds/cannabis/death,
			/obj/item/seeds/cannabis/white,
			/obj/item/seeds/cannabis/ultimate,
			/obj/item/seeds/wheat,
			/obj/item/seeds/wheat/oat,
			/obj/item/seeds/wheat/rice,
			/obj/item/seeds/wheat/meat,
			/obj/item/seeds/chili,
			/obj/item/seeds/chili/ice,
			/obj/item/seeds/chili/ghost,
			/obj/item/seeds/lime,
			/obj/item/seeds/orange,
			/obj/item/seeds/russ/white,
			/obj/item/seeds/russ/goblin,
			/obj/item/seeds/lemon,
			/obj/item/seeds/firelemon,
			/obj/item/seeds/cocoapod,
			/obj/item/seeds/cocoapod/vanillapod,
			/obj/item/seeds/corn,
			/obj/item/seeds/corn/snapcorn,
			/obj/item/seeds/eggplant,
			/obj/item/seeds/eggplant/eggy,
			/obj/item/seeds/poppy,
			/obj/item/seeds/poppy/lily,
			/obj/item/seeds/poppy/geranium,
			/obj/item/seeds/harebell,
			/obj/item/seeds/sunflower,
			/obj/item/seeds/sunflower/moonflower,
			/obj/item/seeds/sunflower/novaflower,
			/obj/item/seeds/grass,
			/obj/item/seeds/grass/carpet,
			/obj/item/seeds/watermelon,
			/obj/item/seeds/glowshroom/shadowshroom,
			/obj/item/seeds/glowshroom,
			/obj/item/seeds/watermelon/holy,
			/obj/item/seeds/starthistle,
			/obj/item/seeds/cabbage,
			/obj/item/seeds/sugarcane,
			/obj/item/seeds/reishi,
			/obj/item/seeds/amanita,
			/obj/item/seeds/angel,
			/obj/item/seeds/liberty,
			/obj/item/seeds/plump/walkingmushroom,
			/obj/item/seeds/plump,
			/obj/item/seeds/chanter,
			/obj/item/seeds/glowshroom/glowcap,
			/obj/item/seeds/nettle,
			/obj/item/seeds/nettle/death,
			/obj/item/seeds/russ/mystery,
			/obj/item/seeds/onion,
			/obj/item/seeds/onion/red,
			/obj/item/seeds/pineapple,
			/obj/item/seeds/potato,
			/obj/item/seeds/potato/sweet,
			/obj/item/seeds/pumpkin,
			/obj/item/seeds/pumpkin/blumpkin,
			/obj/item/seeds/replicapod,
			/obj/item/seeds/carrot,
			/obj/item/seeds/carrot/parsnip,
			/obj/item/seeds/whitebeet,
			/obj/item/seeds/redbeet,
			/obj/item/seeds/tea/astra,
			/obj/item/seeds/tea,
			/obj/item/seeds/coffee/robusta,
			/obj/item/seeds/coffee,
			/obj/item/seeds/tobacco/space,
			/obj/item/seeds/tobacco,
			/obj/item/seeds/tomato/blue,
			/obj/item/seeds/tomato/blood,
			/obj/item/seeds/tomato/blue/bluespace,
			/obj/item/seeds/tomato/killer,
			/obj/item/seeds/tomato,
			/obj/item/seeds/tower,
			/obj/item/seeds/tower/steel)
		if(20 to 50)
			B = pick(/obj/item/seeds/random)

		if(51)
			B = /obj/item/seeds/gatfruit

		if(52 to 62)
			B = pick(/obj/item/wrench,
			/obj/item/weldingtool,
			/obj/item/screwdriver,
			/obj/item/crowbar,
			/obj/item/wirecutters,
			/obj/item/multitool,
			/obj/item/stack/cable_coil)

		if(63 to 93)
			B = pick(/mob/living/simple_animal/butterfly,
			/mob/living/simple_animal/cockroach,
			/mob/living/simple_animal/pet/dog/corgi/puppy,
			/mob/living/simple_animal/pet/dog/corgi,
			/mob/living/simple_animal/crab,
			/mob/living/simple_animal/cow,
			/mob/living/simple_animal/chicken,
			/mob/living/simple_animal/hostile/retaliate/goat,
			/mob/living/simple_animal/pet/fox,
			/mob/living/simple_animal/hostile/lizard,
			/mob/living/simple_animal/mouse,
			/mob/living/simple_animal/pet/penguin/baby,
			/mob/living/simple_animal/pet/penguin/emperor,
			/mob/living/simple_animal/pet/penguin/emperor/shamebrero,
			/mob/living/simple_animal/sloth,
			/mob/living/simple_animal/pet/dog/pug)

		if(93 to 102)
			B = pick(/mob/living/simple_animal/hostile/retaliate/bat,
			/mob/living/simple_animal/hostile/carp,
			/mob/living/simple_animal/hostile/hivebot,
			/mob/living/simple_animal/hostile/poison/giant_spider/nurse,
			/mob/living/simple_animal/hostile/illusion/escape,
			/mob/living/simple_animal/hostile/retaliate/poison/snake,
			/mob/living/simple_animal/hostile/killertomato,
			/mob/living/simple_animal/hostile/viscerator,
			/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin/)

		if(103 to 109)
			B = pick(/mob/living/simple_animal/hostile/carp/megacarp,
			/mob/living/simple_animal/hostile/faithless,
			/mob/living/simple_animal/hostile/bear,
			/mob/living/simple_animal/hostile/poison/giant_spider,
			/mob/living/simple_animal/hostile/hivebot/range,
			/mob/living/simple_animal/hostile/mimic/copy,
			/mob/living/simple_animal/hostile/retaliate/clown/russ/goblin,
			/mob/living/simple_animal/hostile/venus_human_trap,
			/mob/living/simple_animal/hostile/bear/snow)

		if (110 to 120)
			B = /obj/item/storage/pill_bottle/floorpill/full

		if (121 to 148)
			B = pick(/obj/item/reagent_containers/food/drinks/bottle/gin,
			/obj/item/reagent_containers/food/drinks/bottle/whiskey,
			/obj/item/reagent_containers/food/drinks/bottle/vodka,
			/obj/item/reagent_containers/food/drinks/bottle/tequila,
			/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
			/obj/item/reagent_containers/food/drinks/bottle/patron,
			/obj/item/reagent_containers/food/drinks/bottle/rum,
			/obj/item/reagent_containers/food/drinks/bottle/holywater,
			/obj/item/reagent_containers/food/drinks/bottle/vermouth,
			/obj/item/reagent_containers/food/drinks/bottle/kahlua,
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/reagent_containers/food/drinks/bottle/cognac,
			/obj/item/reagent_containers/food/drinks/bottle/wine,
			/obj/item/reagent_containers/food/drinks/bottle/absinthe,
			/obj/item/reagent_containers/food/drinks/bottle/lizardwine,
			/obj/item/reagent_containers/food/drinks/bottle/hcider,
			/obj/item/reagent_containers/food/drinks/bottle/grappa,
			/obj/item/reagent_containers/food/drinks/bottle/sake,
			/obj/item/reagent_containers/food/drinks/bottle/fernet,
			/obj/item/reagent_containers/food/drinks/bottle/orangejuice,
			/obj/item/reagent_containers/food/drinks/bottle/limejuice,
			/obj/item/reagent_containers/food/drinks/bottle/menthol,
			/obj/item/reagent_containers/food/drinks/bottle/grenadine,
			/obj/item/reagent_containers/food/drinks/bottle/applejack,
			/obj/item/reagent_containers/food/drinks/bottle/champagne,
			/obj/item/reagent_containers/food/drinks/bottle/blazaam,
			/obj/item/reagent_containers/food/drinks/bottle/trappist,
			/obj/item/reagent_containers/food/drinks/bottle/molotov)

		if (149 to 159)
			B = pick(/obj/item/reagent_containers/glass/bottle/nutrient/ez,
			/obj/item/reagent_containers/glass/bottle/nutrient/l4z,
			/obj/item/reagent_containers/glass/bottle/nutrient/rh,
			/obj/item/reagent_containers/glass/bottle/killer/weedkiller,
			/obj/item/reagent_containers/glass/bottle/killer/pestkiller,
			/obj/item/reagent_containers/glass/bottle/potion/flight,
			/obj/item/reagent_containers/glass/bottle/epinephrine,
			/obj/item/reagent_containers/glass/bottle/toxin,
			/obj/item/reagent_containers/glass/bottle/cyanide,
			/obj/item/reagent_containers/glass/bottle/spewium,
			/obj/item/reagent_containers/glass/bottle/morphine,
			/obj/item/reagent_containers/glass/bottle/chloralhydrate,
			/obj/item/reagent_containers/glass/bottle/mannitol,
			/obj/item/reagent_containers/glass/bottle/mutagen,
			/obj/item/reagent_containers/glass/bottle/plasma,
			/obj/item/reagent_containers/glass/bottle/synaptizine,
			/obj/item/reagent_containers/glass/bottle/formaldehyde,
			/obj/item/reagent_containers/glass/bottle/ammonia,
			/obj/item/reagent_containers/glass/bottle/diethylamine,
			/obj/item/reagent_containers/glass/bottle/facid,
			/obj/item/reagent_containers/glass/bottle/adminordrazine,
			/obj/item/reagent_containers/glass/bottle/capsaicin,
			/obj/item/reagent_containers/glass/bottle/frostoil,
			/obj/item/reagent_containers/glass/bottle/traitor,
			/obj/item/reagent_containers/glass/bottle/polonium,
			/obj/item/reagent_containers/glass/bottle/magillitis,
			/obj/item/reagent_containers/glass/bottle/venom,
			/obj/item/reagent_containers/glass/bottle/fentanyl,
			/obj/item/reagent_containers/glass/bottle/initropidril,
			/obj/item/reagent_containers/glass/bottle/pancuronium,
			/obj/item/reagent_containers/glass/bottle/sodium_thiopental,
			/obj/item/reagent_containers/glass/bottle/coniine,
			/obj/item/reagent_containers/glass/bottle/curare,
			/obj/item/reagent_containers/glass/bottle/amanitin,
			/obj/item/reagent_containers/glass/bottle/histamine,
			/obj/item/reagent_containers/glass/bottle/diphenhydramine,
			/obj/item/reagent_containers/glass/bottle/potass_iodide,
			/obj/item/reagent_containers/glass/bottle/salglu_solution,
			/obj/item/reagent_containers/glass/bottle/atropine,
			/obj/item/reagent_containers/glass/bottle/romerol,
			/obj/item/reagent_containers/glass/bottle/random_virus,
			/obj/item/reagent_containers/glass/bottle/pierrot_throat,
			/obj/item/reagent_containers/glass/bottle/cold,
			/obj/item/reagent_containers/glass/bottle/flu_virion,
			/obj/item/reagent_containers/glass/bottle/retrovirus,
			/obj/item/reagent_containers/glass/bottle/gbs,
			/obj/item/reagent_containers/glass/bottle/fake_gbs,
			/obj/item/reagent_containers/glass/bottle/brainrot,
			/obj/item/reagent_containers/glass/bottle/magnitis,
			/obj/item/reagent_containers/glass/bottle/wizarditis,
			/obj/item/reagent_containers/glass/bottle/anxiety,
			/obj/item/reagent_containers/glass/bottle/beesease,
			/obj/item/reagent_containers/glass/bottle/fluspanish,
			/obj/item/reagent_containers/glass/bottle/tuberculosis,
			/obj/item/reagent_containers/glass/bottle/tuberculosiscure,
			/obj/item/reagent_containers/glass/bottle/hydrogen,
			/obj/item/reagent_containers/glass/bottle/lithium,
			/obj/item/reagent_containers/glass/bottle/carbon,
			/obj/item/reagent_containers/glass/bottle/nitrogen,
			/obj/item/reagent_containers/glass/bottle/oxygen,
			/obj/item/reagent_containers/glass/bottle/fluorine,
			/obj/item/reagent_containers/glass/bottle/sodium,
			/obj/item/reagent_containers/glass/bottle/aluminium,
			/obj/item/reagent_containers/glass/bottle/iron,
			/obj/item/reagent_containers/glass/bottle/copper,
			/obj/item/reagent_containers/glass/bottle/mercury,
			/obj/item/reagent_containers/glass/bottle/radium,
			/obj/item/reagent_containers/glass/bottle/water,
			/obj/item/reagent_containers/glass/bottle/ethanol,
			/obj/item/reagent_containers/glass/bottle/sugar,
			/obj/item/reagent_containers/glass/bottle/sacid,
			/obj/item/reagent_containers/glass/bottle/welding_fuel,
			/obj/item/reagent_containers/glass/bottle/silver,
			/obj/item/reagent_containers/glass/bottle/iodine,
			/obj/item/reagent_containers/glass/bottle/bromine)

		if (160 to 185)
			B = pick(/obj/item/stack/sheet/animalhide/human,
			/obj/item/stack/sheet/animalhide/generic,
			/obj/item/stack/sheet/animalhide/corgi,
			/obj/item/stack/sheet/animalhide/gondola,
			/obj/item/stack/sheet/animalhide/cat,
			/obj/item/stack/sheet/animalhide/monkey,
			/obj/item/stack/sheet/animalhide/lizard,
			/obj/item/stack/sheet/animalhide/xeno,
			/obj/item/stack/sheet/animalhide/goliath_hide,
			/obj/item/stack/sheet/animalhide/ashdrake,
			/obj/machinery/vending/donksofttoyvendor,
			/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted,
			/obj/item/gun/ballistic/automatic/toy/pistol/unrestricted,
			/obj/item/gun/ballistic/automatic/toy/unrestricted,
			/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted,
			/obj/item/toy/crayon/rainbow,
			/obj/item/lighter,
			/obj/item/flashlight/glowstick/red,
			/obj/item/flashlight/glowstick/blue,
			/obj/item/flashlight/glowstick/cyan,
			/obj/item/flashlight/glowstick/orange,
			/obj/item/flashlight/glowstick/yellow,
			/obj/item/flashlight/glowstick/pink,
			/obj/effect/decal/cleanable/blood/gibs,
			/obj/item/toy/plush/carpplushie,
			/obj/item/toy/plush/bubbleplush,
			/obj/item/toy/plush/plushvar,
			/obj/item/toy/plush/narplush,
			/obj/item/toy/plush/lizardplushie,
			/obj/item/toy/plush/snakeplushie,
			/obj/item/toy/plush/nukeplushie,
			/obj/item/toy/plush/slimeplushie,
			/obj/item/toy/plush/awakenedplushie,
			/obj/item/toy/figure/cmo,
			/obj/item/toy/figure/assistant,
			/obj/item/toy/figure/atmos,
			/obj/item/toy/figure/bartender,
			/obj/item/toy/figure/borg,
			/obj/item/toy/figure/botanist,
			/obj/item/toy/figure/captain,
			/obj/item/toy/figure/cargotech,
			/obj/item/toy/figure/ce,
			/obj/item/toy/figure/chaplain,
			/obj/item/toy/figure/chef,
			/obj/item/toy/figure/chemist,
			/obj/item/toy/figure/clown,
			/obj/item/toy/figure/ian,
			/obj/item/toy/figure/detective,
			/obj/item/toy/figure/dsquad,
			/obj/item/toy/figure/engineer,
			/obj/item/toy/figure/geneticist,
			/obj/item/toy/figure/hop,
			/obj/item/toy/figure/hos,
			/obj/item/toy/figure/qm,
			/obj/item/toy/figure/janitor,
			/obj/item/toy/figure/lawyer,
			/obj/item/toy/figure/curator,
			/obj/item/toy/figure/md,
			/obj/item/toy/figure/mime,
			/obj/item/toy/figure/miner,
			/obj/item/toy/figure/ninja,
			/obj/item/toy/figure/wizard,
			/obj/item/toy/figure/rd,
			/obj/item/toy/figure/roboticist,
			/obj/item/toy/figure/scientist,
			/obj/item/toy/figure/syndie,
			/obj/item/toy/figure/secofficer,
			/obj/item/toy/figure/virologist,
			/obj/item/toy/figure/warden)

		if (186 to 206)
			B = pick(/obj/item/stack/sheet/mineral/sandstone,
			/obj/item/stack/sheet/mineral/diamond,
			/obj/item/stack/sheet/mineral/uranium,
			/obj/item/stack/sheet/mineral/plasma,
			/obj/item/stack/sheet/mineral/gold,
			/obj/item/stack/sheet/mineral/silver,
			/obj/item/stack/sheet/mineral/bananium,
			/obj/item/stack/sheet/mineral/titanium,
			/obj/item/stack/sheet/mineral/plastitanium,
			/obj/item/stack/sheet/mineral/abductor,
			/obj/item/stack/sheet/mineral/adamantine)

		if (207 to 213)
			new /obj/item/clothing/mask/gas/clown_hat(get_turf(user), num)
			new /obj/item/clothing/shoes/clown_shoes(get_turf(user), num)
			new /obj/item/toy/crayon/rainbow(get_turf(user), num)
			new /obj/item/bikehorn(get_turf(user), num)
			new /obj/structure/statue/bananium/clown(get_turf(user), num)
			new /obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter(get_turf(user), num)
			new /obj/item/reagent_containers/food/snacks/pie/cream(get_turf(user), num)
			new /obj/item/reagent_containers/food/snacks/pie/cream(get_turf(user), num)
			new /obj/item/reagent_containers/food/snacks/pie/cream(get_turf(user), num)
			new /obj/item/reagent_containers/food/snacks/pie/cream(get_turf(user), num)
			new /obj/item/reagent_containers/food/snacks/pie/cream(get_turf(user), num)
			new /obj/item/reagent_containers/spray/waterflower(get_turf(user), num)
			new /obj/item/storage/backpack/clown(get_turf(user), num)
			new /obj/item/seeds/banana(get_turf(user), num)
			new /obj/item/stamp/clown(get_turf(user), num)
			B = /obj/item/restraints/handcuffs

	return B

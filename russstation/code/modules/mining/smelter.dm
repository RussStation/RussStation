/obj/item/reagent_containers/glass/bucket/iron_crucible_bucket
	name = "cast iron crucible"
	desc = "A crucible used to smelt ore down inside a smelter."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "iron_crucible"
	amount_per_transfer_from_this = 25
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	volume = 100
	slot_flags = NONE

/obj/item/crucible_tongs
	name = "crucible tongs"
	desc = "Used to take hot crucibles out of smelters"
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "tong"

/obj/machinery/smelter
	name = "smelter"
	desc = "An old Sendarian tool. Fuel: (0/20)"
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "forge"
	density = TRUE
	anchored = FALSE
	var/obj/item/reagent_containers/glass/bucket/iron_crucible_bucket/crucible = null
	var/mutable_appearance/my_bucket = null
	var/bucket_loaded = FALSE
	var/fuel = 0
	var/fuel_max = 20

/obj/machinery/smelter/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/grown/log) && !(fuel >= fuel_max)) //add fuel
		to_chat(user, "You add the [W.name] to the fuel supply of the smelter.")
		fuel += 5
		desc = "An old Sendarian tool. Fuel: ([fuel]/20)" //update
		if(fuel > fuel_max) //adjust fuel if it goes over the max
			fuel = fuel_max
		user.dropItemToGround(W)
		qdel(W)

	if(istype(W, /obj/item/reagent_containers/glass/bucket/iron_crucible_bucket) && bucket_loaded == FALSE) //load in bucket
		to_chat(user, "You load the smelter with a crucible. It is now ready to smelt ore.")
		crucible = W
		bucket_loaded = TRUE
		user.dropItemToGround(W)
		W.loc = src
		my_bucket = mutable_appearance('russstation/icons/obj/blacksmithing.dmi', W.icon_state)
		add_overlay(my_bucket)
		return

	if(istype(W, /obj/item/crucible_tongs) && bucket_loaded == TRUE) //take out bucket
		to_chat(user, "You take the crucible out of the smelter.")
		var/obj/item/reagent_containers/glass/bucket/iron_crucible_bucket/C = new(get_turf(src))
		C.reagents = crucible.reagents
		C.volume = 100
		cut_overlay(my_bucket)
		bucket_loaded = FALSE
		my_bucket = null
		crucible = null
		return

	if(istype(W, /obj/item/stack/ore) && bucket_loaded == TRUE && fuel != 0) //ore and bucket loaded
		var/obj/item/stack/ore/current_ore = W
		var/smelting_result = W.on_smelt() //reagent id
		if(!smelting_result)
			return ..()

		while(crucible.reagents.total_volume != 100 && current_ore.amount != 0 && fuel != 0) //keep adding ore until you run out or fill the crucible
			to_chat(user, "The [W] melts.")
			crucible.reagents.add_reagent(smelting_result, (5)) //crucible.reagents.get_master_reagent() == smelting_result
			crucible.reagents.chem_temp = 1000
			crucible.reagents.handle_reactions()
			current_ore.amount--
			fuel--

		desc = "An old Sendarian tool. Fuel: ([fuel]/20)" //update

		if(current_ore.amount == 0)
			qdel(W)

/obj/machinery/anvil
	name = "anvil"
	desc = "Goodman Durnik, is that you?"
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = FALSE
	var/obj/item/reagent_containers/glass/mold/current_mold = null
	var/mutable_appearance/my_mold = null

/obj/machinery/anvil/attackby(obj/item/W, mob/living/user, params)
	if(!istype(W, /obj/item/melee/smith_hammer))
		..()
	if(user.a_intent == INTENT_HARM)
		to_chat(user, "Be careful! You'll spill hot metal on the anvil with that intent!")
		return //spill that shit if it has reagents in it
	if(!current_mold && istype(W, /obj/item/reagent_containers/glass/mold))
		var/obj/item/reagent_containers/glass/mold/M = W
		var/datum/reagent/R = M.reagents.get_master_reagent()
		if(R && R.volume >= 25)
			if(R.name != "Iron" && R.name != "Adamantine" && R.name != "Silver" && R.name != "Gold" && R.name != "Uranium" && R.name != "Diamond" && R.name != "Plasma" && R.name != "Bananium" && R.name != "Titanium" )
				return //get out of here if its not ore tdogTrigger (stops things like water pickaxe heads and such)
			to_chat(user, "you place [M] on [src].")
			user.dropItemToGround(M)
			M.loc = src
			current_mold = M
			my_mold = mutable_appearance('russstation/icons/obj/blacksmithing.dmi', M.icon_state)
			add_overlay(my_mold)
			return
		if(R && R.volume)
			to_chat(user, "There's not enough in the mold to make a full cast!")
		else
			to_chat(name, "There's nothing in the mold!")
			return
	if(istype(W, /obj/item/melee/smith_hammer))
		if(current_mold)
			to_chat(user, "You break the result out of [current_mold] and start to hammer it into shape.")
			if(do_after(user, 80, target = src))
				new current_mold.type(get_turf(src))
				var/datum/reagent/R = current_mold.reagents.get_master_reagent()
				var/obj/item/I
				if(!istype(current_mold, /obj/item/reagent_containers/glass/mold/bar))
					I = new current_mold.produce_type(get_turf(src))
					I.smelted_material = new R.type()
					I.post_smithing()
				else
					for(var/i, i <= 4, i++) // makes five of whatever sheet of its type
						I = new R.produce_type(get_turf(src))
				qdel(current_mold)
				cut_overlay(my_mold)
				my_mold = null
				current_mold = null
				return
		else
			to_chat(user, "There's nothing in [current_mold]!")
			return

//Molds
/obj/item/mold_result
	name = "molten blob"
	desc = "A hardened blob of ore. You shouldn't be seeing this..."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "blob_base"
	w_class = WEIGHT_CLASS_NORMAL
	var/material_type = "unobtanium"
	var/mold_type = "blob"
	var/pickaxe_speed = 0
	var/metel_force = 0
	var/attack_amt = 0
	var/blunt_bonus = FALSE //determinse if the reagent used for the part has a bonus for blunt materials

/obj/item/mold_result/blade
	name = "blade"
	desc = "A blade made of "
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "sword_blade"
	mold_type = "offensive"

/obj/item/mold_result/pickaxe_head
	name = "pickaxe head"
	desc = "A pickaxe head made of "
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "pickaxe_head"
	mold_type = "digging"

/obj/item/mold_result/shovel_head
	name = "shovel head"
	desc = "A shovel head made of "
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "shovel_head"
	mold_type = "digging"

/obj/item/mold_result/knife_head
	name = "knife head"
	desc = "A butchering knife head made of "
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "knife_head"
	mold_type = "offensive"

/obj/item/mold_result/war_hammer_head
	name = "warhammer head"
	desc = "A warhammer head made of "
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "war_hammer_head"
	mold_type = "offensive"

/obj/item/mold_result/armour_plating
	name = "armour plating"
	desc = "Armour plating made of"
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "armour"
	mold_type = "offensive"

/obj/item/mold_result/helmet_plating
	name = "helmet plating"
	desc = "Helmet plating made of"
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "helmet"
	mold_type = "offensive"

/obj/item/mold_result/post_smithing()
	name = "[smelted_material.name] [name]"
	material_type = "[smelted_material.name]"
	color = smelted_material.color
	armour_penetration = smelted_material.penetration_value
	attack_amt = smelted_material.attack_force
	force = smelted_material.attack_force * 0.6 //stabbing people with the resulting piece, build the full tool for full force
	desc += "[smelted_material.name]."
	if(mold_type == "digging")
		pickaxe_speed = smelted_material.pick_speed
	if(smelted_material.sharp_result)
		sharpness = IS_SHARP
	if(smelted_material.blunt_damage)
		blunt_bonus = TRUE

//Forging anvil hammer
/obj/item/melee/smith_hammer
	name = "smith's hammer"
	desc = "BONK."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "hammer"
	item_state = "sledgehammer"
	force = 10
	w_class = WEIGHT_CLASS_TINY

//Forged Broadsword
/obj/item/melee/smithed_sword
	name = "unobtanium broadsword"
	desc = "A broadsword made of unobtanium, you probably shouldn't be seeing this."
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "claymore"
	item_state = "claymore"

/obj/item/melee/smithed_sword/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/blade/B = locate() in contents
	if(B)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "sword_blade")
		I.color = B.color
		smelted_material = new B.smelted_material.type()
		add_overlay(I)
		name = "[B.material_type] broadsword"
		force = B.attack_amt * 2
		desc = "A broadsword made of [B.material_type]."
		armour_penetration = B.armour_penetration
		sharpness = B.sharpness

//Forged Pickaxe
/obj/item/pickaxe/smithed_pickaxe
	name = "unobtanium pickaxe"
	desc = "A pickaxe made of unobtanium, you probably shouldn't be seeing this."
	icon = 'icons/obj/mining.dmi'
	icon_state = "spickaxe"
	item_state = "spickaxe"

/obj/item/pickaxe/smithed_pickaxe/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/pickaxe_head/P = locate() in contents
	if(P)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "pickaxe_head")
		I.color = P.color
		smelted_material = new P.smelted_material.type()
		add_overlay(I)
		name = "[P.material_type] pickaxe"
		force = P.attack_amt
		toolspeed = P.pickaxe_speed
		desc = "A pickaxe made of [P.material_type] head."
		armour_penetration = P.armour_penetration * 1.25 //if you think about it, pickaxes are the best at piercing armour
		sharpness = P.sharpness

//Forged Shovel
/obj/item/shovel/smelted_shovel
	name = "unobtanium shovel"
	desc = "A shovel made of unobtanium, you probably shouldn't be seeing this."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	item_state = "shovel"

/obj/item/shovel/smithed_shovel/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/shovel_head/S = locate() in contents
	if(S)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "shovel_head")
		I.color = S.color
		add_overlay(I)
		smelted_material = new S.smelted_material.type()
		name = "[S.material_type] shovel"
		if(S.blunt_bonus == TRUE)
			force = S.attack_amt *1.25
		else
			force = S.attack_amt * 0.75
		toolspeed = S.pickaxe_speed * 0.5 // gotta DIG FAST
		desc = "A shovel with a [S.material_type] head."
		armour_penetration = S.armour_penetration * 0.5
		sharpness = S.sharpness

//Forged Knife
/obj/item/kitchen/knife/smelted_knife
	name = "unobtanium knife"
	desc = "A knife made of unobtainum, you probably shouldn't be seeing this."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "knife_base"
	item_state = "knife"

/obj/item/kitchen/knife/smelted_knife/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/knife_head/K = locate() in contents
	if(K)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "knife_head")
		I.color = K.color
		add_overlay(I)
		smelted_material = new K.smelted_material.type()
		name = "[K.material_type] knife"
		force = K.attack_amt * 0.5 //chin choppa, CHIN CHOPPA
		desc = "A knife with a [K.material_type] head."
		armour_penetration = K.armour_penetration * 0.5
		sharpness = K.sharpness * 1

//Forged War Hammer
/obj/item/twohanded/smithed_war_hammer
	name = "unobtanium warhammer"
	desc = "A warhammer made of unobtainium, you probably shouldn't be seeing this."
	icon = 'russstation/icons/obj/blacksmithing.dmi'
	icon_state = "pickaxe_base"
	item_state = "spickaxe"
	force = 11
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	throw_speed = 4
	attack_verb = list("attacked","bludgeoned","pulped","gored","torn")

/obj/item/twohanded/smithed_war_hammer/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/war_hammer_head/W = locate() in contents
	if(W)
		var/image/I = image('russstation/icons/obj/blacksmithing.dmi', "war_hammer_head")
		I.color = W.color
		add_overlay(I)
		smelted_material = new W.smelted_material.type()
		name = "[W.material_type] warhammer"
		if(W.blunt_bonus == TRUE)
			force = W.attack_amt * 2
			force_unwielded = W.attack_amt * 2
			force_wielded = W.attack_amt * 4
		else
			force = W.attack_amt * 0.75
			force_unwielded = W.attack_amt * 0.75
			force_wielded = W.attack_amt * 2
		desc = "A warhammer made of [W.material_type]."
		armour_penetration = W.armour_penetration * 3
		sharpness = W.sharpness

//Forged Armour
/obj/item/clothing/suit/armor/vest/dwarf
	name = "dwarfven armour"
	desc = "Great for stopping sponges."
	mob_overlay_icon = 'russstation/icons/mob/suit.dmi'
	icon = 'russstation/icons/obj/clothing/suits.dmi'
	icon_state = "dwarf"
	item_state = "dwarf"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor = list(melee = 50, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0, fire = 80, acid = 80)
	strip_delay = 80
	equip_delay_self = 60
	species_exception = list(/datum/species/dwarf)

/obj/item/clothing/suit/armor/vest/dwarf/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/armour_plating/S = locate() in contents
	if(S)
		var/image/Q = image(icon, icon_state)
		Q.color = S.color
		add_overlay(Q)
		smelted_material = new S.smelted_material.type()
		name = "[S.material_type] armour"
		desc = "Armour forged from [S.material_type]."
		for(var/A in armor)
			A = S.attack_amt/100

//Forged Helmet
/obj/item/clothing/head/helmet/dwarf
	name = "dwarven helm"
	desc = "Protects the head from tantrums."
	mob_overlay_icon = 'russstation/icons/mob/head.dmi'
	icon = 'russstation/icons/obj/clothing/hats.dmi'
	icon_state = "dwarf"
	item_state = "dwarf"
	body_parts_covered = HEAD
	species_exception = list(/datum/species/dwarf)

/obj/item/clothing/head/helmet/dwarf/CheckParts(list/parts_list)
	..()
	var/obj/item/mold_result/helmet_plating/S = locate() in contents
	if(S)
		var/image/Q = image(icon, icon_state)
		Q.color = S.color
		add_overlay(Q)
		smelted_material = new S.smelted_material.type()
		name = "[S.material_type] helmet."
		desc = "Helmet forged from [S.material_type]"
		for(var/A in armor)
			A = S.attack_amt/100

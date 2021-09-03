//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/emergency/hotrod
    name = "The Hotrod"
    desc = "High quality American steel from the ruins of Detroit, Earth. Made in the Space Republic of China."
    cost = 1500
    contains = list(/obj/vehicle/ridden/wheelchair/russ/hotrod)
    crate_name = "The Hotrod"
    crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/emergency/sportschair
    name = "Sportschair"
    desc = "A lightweight model wheelchair."
    cost = 1500
    contains = list(/obj/vehicle/ridden/wheelchair/russ/sportschair)
    crate_name = "Sportschair"
    crate_type = /obj/structure/closet/crate/large

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/bearsky
    name = "Officer Bearsky Crate"
    desc = "Hunts the Syndicate like wild terrestrial salmon"
    cost = 5000
    contains = list(/mob/living/simple_animal/bot/secbot/bearsky)
    crate_name = "officer bearsky crate"
    crate_type = /obj/structure/closet/crate/critter

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Costumes & Toys /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/costumes_toys/cowboy
	name = "Wild West Crate"
	desc = "Yeehaw pardner!"
	cost = 4000
	contains = list(
		/obj/item/clothing/head/cowboyhat,
    	/obj/item/clothing/head/cowboyhat/tan,
    	/obj/item/clothing/head/cowboyhat/white,
    	/obj/item/clothing/head/cowboyhat/black,
    	/obj/item/clothing/head/cowboyhat/pink,
    	/obj/item/clothing/shoes/cowboy,
    	/obj/item/clothing/shoes/cowboy,
    	/obj/item/clothing/shoes/cowboy/white,
    	/obj/item/clothing/shoes/cowboy/black,
    	/obj/item/clothing/shoes/cowboy/pink,
    	/obj/item/clothing/accessory/medal/russ/deputy,
    	/obj/item/clothing/accessory/medal/russ/deputy,
    	/obj/item/toy/gun,
    	/obj/item/toy/gun,
    	/obj/item/toy/gun,
    	/obj/item/toy/gun,
    	/obj/item/toy/gun,
    	/obj/item/toy/gun/bigiron,
	)
	crate_name = "wild west crate"
	crate_type = /obj/structure/closet/crate/wooden

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Vending /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending/monkey
	name = "Monkey Supply Crate"
	desc = "There's always more science to be done!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/vending_refill/monkey,
		/obj/item/circuitboard/machine/vending/monkey
	)
	crate_name = "monkey supply crate"

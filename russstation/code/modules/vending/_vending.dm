/*
 *	This file adds our items to already existing vending machines, by adding them during its /Initialize()
 *
*/

/obj/machinery/vending/clothing/Initialize()
	products += list(
		/obj/item/clothing/shoes/cowboy/pink = 2,
		/obj/item/clothing/head/cowboyhat = 2,
		/obj/item/clothing/head/cowboyhat/tan = 2,
		/obj/item/clothing/head/cowboyhat/black = 2,
		/obj/item/clothing/head/cowboyhat/white = 2,
		/obj/item/clothing/head/cowboyhat/pink = 2,
	)
	. = ..()

/obj/machinery/vending/autodrobe/Initialize()
	premium += list(
		/obj/item/clothing/accessory/medal/russ/deputy = 2,
		/obj/item/clothing/head/cowboyhat/clown = 2,
		/obj/item/clothing/shoes/cowboy/clown = 2,
	)
	. = ..()

/obj/machinery/vending/wardrobe/jani_wardrobe/Initialize()
	premium += list(/obj/item/storage/box/slippery_sign_kit = 1)
	. = ..()

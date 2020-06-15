/*
	This file adds some vars that make adding and managing vending machine content's much less obtrusive.
	russ_products contains the normal items available, and generally are free for members of that department if it's a job-drobe.
	russ_contraband contains the items you need to hack to acquire.
	russ_premium contains the items which are priced higher on average, and aren't free for members of that department if it's a job-drobe.
*/

/obj/machinery/vending
//	icon_russ = 'russstation/icons/obj/vending.dmi'
	var/russ_products = list()
	var/russ_contraband = list()
	var/russ_premium = list()

/obj/machinery/vending/Initialize()
	// Add our items to the list
	// If the item is already a product then add items to it
	if (products && LAZYLEN(russ_products))
		for (var/i in russ_products)
			if (products[i])
				if (products[i] + russ_products[i] <= 0)
					LAZYREMOVE(products, i)
				else
					products[i] = products[i] + russ_products[i]
			else
				products[i] = russ_products[i]

	if (contraband && LAZYLEN(russ_contraband))
		for (var/i in russ_contraband)
			if (contraband[i])
				if (contraband[i] + russ_contraband[i] <= 0)
					LAZYREMOVE(contraband, i)
				else
					contraband[i] = contraband[i] + russ_contraband[i]
			else
				contraband[i] = russ_contraband[i]

	if (premium && LAZYLEN(russ_premium))
		for (var/i in russ_premium)
			if (premium[i])
				if (premium[i] + russ_premium[i] <= 0)
					LAZYREMOVE(premium, i)
				else
					premium[i] = premium[i] + russ_premium[i]
			else
				premium[i] = russ_premium[i]

	return ..()

/*
	Follow this format if you want to add items to previous existing vending machines.

/obj/machinery/vending/...
	russ_products = list(/obj/item/... = 1,
						/obj/item/... = 1)

	russ_contraband = list(/obj/item/... = 1,
						/obj/item/... = 1)

	russ_premium = list(/obj/item/... = 1,
						/obj/item/... = 1)

	The number following the item is the amount of stock.
	If the number is negative, it will instead remove items from a vending machine. 
	If the sum of the item and the russ_item is less than 0,
	it will be removed entirely (so -100 will completely remove any item)

*/

/obj/machinery/vending/clothing
	russ_products = list(/obj/item/clothing/shoes/cowboy/pink = 2,
						/obj/item/clothing/head/cowboyhat = 2,
						/obj/item/clothing/head/cowboyhat/tan = 2,
						/obj/item/clothing/head/cowboyhat/black = 2,
						/obj/item/clothing/head/cowboyhat/white = 2,
						/obj/item/clothing/head/cowboyhat/pink = 2)

/obj/machinery/vending/autodrobe
	russ_premium = list(/obj/item/clothing/accessory/medal/russ/deputy = 2,
						/obj/item/clothing/head/cowboyhat/clown = 2,
						/obj/item/clothing/shoes/cowboy/clown = 2)

/obj/machinery/vending/wardrobe/jani_wardrobe
	russ_premium = list(/obj/item/storage/box/slippery_sign_kit = 1)

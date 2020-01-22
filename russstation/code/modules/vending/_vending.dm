/*
	There's some Hippie-related vars here that help us unobtrusively manage the products/contraband/premium
	hippie_products contains the normal items available
	hippie_contraband contains the items you need to hack to acquire
	hippie_premium contains the items which require a coin to acquire
	Add items to these lists if you want them to appear in their respective lists
	You can also take away items by using a negative value. If the sum of products + hippie_products
	is less than 0 then the item is taken out altogether (so use -100 to completely remove an item)
*/

/obj/machinery/vending
//	icon_russ = 'russstation/icons/obj/vending.dmi'
	var/russ_products = list()
	var/russ_contraband = list()
	var/russ_premium = list()

/obj/machinery/vending/Initialize()
	// Add our items to the list
	// If the item is already a product then add items to it
	if (LAZYLEN(products) && LAZYLEN(russ_products))
		for (var/i in russ_products)
			if (products[i])
				if (products[i] + russ_products[i] <= 0)
					LAZYREMOVE(products, i)
				else
					products[i] = products[i] + russ_products[i]
			else
				products[i] = russ_products[i]

	if (LAZYLEN(contraband) && LAZYLEN(russ_contraband))
		for (var/i in russ_contraband)
			if (contraband[i])
				if (contraband[i] + russ_contraband[i] <= 0)
					LAZYREMOVE(contraband, i)
				else
					contraband[i] = contraband[i] + russ_contraband[i]
			else
				contraband[i] = russ_contraband[i]

	if (LAZYLEN(premium) && LAZYLEN(russ_premium))
		for (var/i in russ_premium)
			if (premium[i])
				if (premium[i] + russ_premium[i] <= 0)
					LAZYREMOVE(premium, i)
				else
					premium[i] = premium[i] + russ_premium[i]
			else
				premium[i] = russ_premium[i]

	return ..()

/obj/machinery/vending/clothing
	russ_products = list(/obj/item/clothing/shoes/cowboy/pink = 2,
					/obj/item/clothing/head/cowboyhat = 2,
					/obj/item/clothing/head/cowboyhat/tan = 2,
					/obj/item/clothing/head/cowboyhat/black = 2,
					/obj/item/clothing/head/cowboyhat/white = 2,
					/obj/item/clothing/head/cowboyhat/pink = 2,)

/obj/machinery/vending/autodrobe
	russ_premium = list(/obj/item/clothing/accessory/medal/russ/deputy = 2,
						/obj/item/clothing/head/cowboyhat/clown = 2,
						/obj/item/clothing/shoes/cowboy/clown = 2)
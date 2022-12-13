/obj/machinery/vending/monkey
	name = "\improper MonkeeVendr"
	desc = "Test monkey dispenser."
	icon = 'russstation/icons/obj/vending.dmi'
	icon_state = "monkey"
	product_slogans = "Now only slightly unethical;Don't run out of test subjects!;Not responsible for monkey bites"
	product_ads = "Ooh ooh ooh!;Smell the science;Water not included"
	req_access = list(ACCESS_GENETICS,ACCESS_VIROLOGY,ACCESS_XENOBIOLOGY)
	products = list(/obj/item/food/monkeycube = 30,
					/obj/item/reagent_containers/cup/glass/waterbottle = 5,
					/obj/item/food/grown/banana = 8)
	contraband = list(/obj/item/food/monkeycube/gorilla = 1,
					/obj/item/dnainjector/h2m = 1)
	premium = list(/obj/item/storage/box/monkeycubes = 2)
	refill_canister = /obj/item/vending_refill/monkey
	circuit = /obj/item/circuitboard/machine/vending/monkey
	payment_department = ACCOUNT_SCI
	light_mask = "monkey-light-mask"

/obj/item/vending_refill/monkey
	machine_name = "MonkeeVendr"
	icon = 'russstation/icons/obj/vending_restock.dmi'
	icon_state = "refill_monkey"

/obj/item/circuitboard/machine/vending/monkey
	name = "\improper MonkeeVendr (Machine Board)"
	build_path = /obj/machinery/vending/monkey
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/monkey = 1)

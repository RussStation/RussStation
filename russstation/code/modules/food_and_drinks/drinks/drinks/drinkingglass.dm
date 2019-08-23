/obj/item/reagent_containers/food/drinks/drinkingglass/proc/check_full_icon_state(datum/reagent/R)
	if(R.glass_icon_state in GLOB.drinkingglassrussicons)
		icon = 'russstation/icons/obj/drinks.dmi'
	else
		icon = initial(icon)
	icon_state = R.glass_icon_state
	return

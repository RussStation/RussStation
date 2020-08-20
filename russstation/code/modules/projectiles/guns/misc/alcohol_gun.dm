/obj/item/gun/chem/alcohol_gun
	name = "SHOTgun"
	desc = "a chem gun designed to shoot ethanol based beverages into bar patrons."
	icon_state = "shotgun"
	item_state = "shotgun"
	time_per_syringe = 200
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'


/obj/item/gun/chem/alcohol_gun/process()
	..()
	if(reagents)
		for(var/datum/reagent/contents in reagents.reagent_list)
			if(!istype(contents, /datum/reagent/consumable/ethanol))
				reagents.clear_reagents()
				playsound(src,'sound/weapons/sear.ogg',50)
				visible_message("<span class='warning'>The [name] purges the contents of its chamber!</span>")
				return

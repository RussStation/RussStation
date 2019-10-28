/obj/structure/sink/attackby(obj/item/O, mob/user, params)
	
	if(istype(O, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/glass/G = O
		if(G.use(1))
			var/obj/item/C = new /obj/item/stack/sheet/mineral/clay(user.drop_location())
			to_chat(user, "<span class='notice'> You soak the sand in water making some moldable clay</span>")
			C.add_fingerprint(user)
		else
			to_chat(user, "<span class='warning'> You don't have enough sand to make clay</span>")
	else
		return ..()

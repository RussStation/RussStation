/obj/item/melee/skateboard/suicide_act(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		var/obj/vehicle/ridden/scooter/skateboard/S = new board_item_type(get_turf(L))
		S.suicide = TRUE
		S.generate_actions()
		L.visible_message("<span class='warning'>[user] prepares for [L.p_their()] final trick.</span>", "<span class='warning'>You prepare yourself for the ultimate ollie, it shall be your last.</span>")
		S.buckle_mob(L)
		qdel(src)
		return MANUAL_SUICIDE_NONLETHAL
	else
		to_chat(user, "<span class='warning'>You are not capable of doing the ultimate trick!</span>")
		return SHAME

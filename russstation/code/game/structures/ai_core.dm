/obj/structure/AIcore/attackby(obj/item/P, mob/user, params)
	if (state != CABLED_CORE)
		return ..()
	if(istype(P, /obj/item/mmi) && !brain)
		var/obj/item/mmi/M = P
		if(!M.brain_check(user))
			return

		var/mob/living/brain/B = M.brainmob
		if((is_banned_from(B.ckey, "AI") && !QDELETED(src) && !QDELETED(user) && !QDELETED(M) && !QDELETED(user) && Adjacent(user))) //overwrote this check (removed !CONFIG_GET(flag/allow_ai))
			if(!QDELETED(M))
				to_chat(user, "<span class='warning'>This [M.name] does not seem to fit!</span>")
			return
		if(!user.transferItemToLoc(M,src))
			return

		brain = M
		to_chat(user, "<span class='notice'>You add [M.name] to the frame.</span>")
		update_icon()
		return
	else
		return ..()
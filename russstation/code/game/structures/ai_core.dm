// honk start -- Modified the MMI check when building an AI core so that it doesn't check the ai_allowed flag.
/obj/structure/AIcore/attackby(obj/item/P, mob/user, params)
	if (state != CABLED_CORE)
		return ..()
	if(istype(P, /obj/item/mmi) && !brain)
		var/obj/item/mmi/M = P
		if(!M.brain_check(user))
			return

		var/mob/living/brain/B = M.brainmob
		if((is_banned_from(B.ckey, "AI") && !QDELETED(src) && !QDELETED(user) && !QDELETED(M) && !QDELETED(user) && Adjacent(user))) //honk -- modified check here
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
// honk end
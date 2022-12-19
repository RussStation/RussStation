/obj/item/food/bread
	var/googly_eyes

/obj/item/food/bread/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is becoming one with \the [src]! It looks like [user.p_theyre()] trying to commit breadicide!"))
	new /obj/effect/temp_visual/wizard/out(user.loc, user.dir)
	// join the bread, dummy mob so you can only talk
	var/atom/movable/breaded = user.change_mob_type(/mob/living/simple_animal, delete_old_mob = TRUE)
	breaded.forceMove(src)
	if(googly_eyes == null)
		googly_eyes = mutable_appearance('icons/mob/simple/mob.dmi', "googly_eyes")
		add_overlay(googly_eyes)
	// doesn't actually kill, but bread ain't lasting long
	return SHAME

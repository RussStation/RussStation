#define BREADIFY_TIME (1 SECONDS)
// shorter breadify time than smite

/obj/item/food/bread/suicide_act(mob/user)
	// remove the held bread so there's not two of em
	qdel(src)
	user.visible_message(span_suicide("[user] is becoming one with the [src]! It looks like [user.p_theyre()] trying to commit breadicide!"))
	// copied from admin smite
	var/mutable_appearance/bread_appearance = mutable_appearance('icons/obj/food/burgerbread.dmi', "bread")
	var/mutable_appearance/transform_scanline = mutable_appearance('icons/effects/effects.dmi', "transform_effect")
	user.transformation_animation(bread_appearance,time = BREADIFY_TIME, transform_overlay=transform_scanline, reset_after=TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/breadify, user), BREADIFY_TIME)
	// doesn't actually kill, but bread ain't lasting long
	return SHAME

#undef BREADIFY_TIME

////////////////////
/////BODYPARTS/////
////////////////////


/obj/item/bodypart/var/should_draw_russ = FALSE  //gives all body parts a should_draw_russ var to check if they should use russ station icons

/mob/living/carbon/proc/draw_russ_parts(undo = FALSE)
	if(!undo)  //bodyparts will use russ station icons
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_russ = TRUE
	else  //disables russ station icons for bodyparts
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_russ = FALSE	

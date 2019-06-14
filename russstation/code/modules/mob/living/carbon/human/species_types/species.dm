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

/datum/species/proc/russ_mutant_bodyparts(bodypart, mob/living/carbon/human/H)
	switch(bodypart)
		if("diona_hair")
			return GLOB.diona_hair_list[H.dna.features["diona_hair"]]

/datum/species/proc/russ_handle_hiding_bodyparts(list/bodyparts_adding, obj/item/bodypart/head/head, mob/living/carbon/human/human)
	if("diona_hair" in mutant_bodyparts)
		if((human.wear_mask && (human.wear_mask.flags_inv & HIDEFACE)) || (human.head && (human.head.flags_inv & HIDEFACE)) || !head || head.status == BODYPART_ROBOTIC)
			bodyparts_adding -= "diona_hair"

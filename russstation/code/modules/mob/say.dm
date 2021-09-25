//Credit to Yozr for his work on the old version of typing indicators

/mob/verb/say_wrapper()
	set name = ".say"
	set hidden = TRUE

	var/image/typing_indicator = image('icons/mob/talk.dmi', src, "default0", ABOVE_HUD_PLANE)
	if(isliving(src)) //only living mobs have the bubble_icon var
		var/mob/living/L = src
		//get unique speech bubble icons for different species
		typing_indicator = image(L.bubble_file, src, L.bubble_icon + "0", ABOVE_HUD_PLANE)

	typing_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	overlays += typing_indicator

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(H.dna.check_mutation(MUT_MUTE) || H.silent) //Check for mute or silent, remove the overlay if true
			overlays -= typing_indicator
			return

	if(client)
		if(stat != CONSCIOUS || is_muzzled())
			overlays -= typing_indicator

	var/message = input("", "Say \"text\"") as null|text

	overlays -= typing_indicator

	say_verb(message)

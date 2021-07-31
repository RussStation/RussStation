/obj/item/organ/tongue/skaven
	name = "putrid blistering tongue"
	desc = "The decayed tongue of a Skaven."
	icon_state = "tonguezombie"
	say_mod = "chitters"
	modifies_speech = TRUE

/obj/item/organ/tongue/skaven/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 4, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(prob(30))
			message_list[insertpos] = inserttext + "-" + inserttext
		else if(prob(15) && message_list.len > 3)
			message_list[insertpos] = inserttext[1] + "-" + inserttext

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

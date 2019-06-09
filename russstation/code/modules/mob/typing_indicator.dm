#define TYPING_INDICATOR_LIFETIME 30 * 10	//grace period after which typing indicator disappears regardless of text in chatbar

mob/var/hud_typing = 0 //set when typing in an input window instead of chatline
mob/var/typing

var/global/image/typing_indicator

/mob/proc/set_typing_indicator(var/state)

	if(!typing_indicator)
		typing_indicator = image('russstation/icons/mob/talk.dmi', null, "paradise_typing", MOB_LAYER + 1)
		typing_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(H.dna.check_mutation(MUT_MUTE) || H.silent) //Check for mute or silent, remove the overlay if true
			overlays -= typing_indicator
			return

	if(client)
		if((client.prefs.toggles & SHOW_TYPING) || stat != CONSCIOUS || is_muzzled())
			overlays -= typing_indicator
		else
			if(state)
				if(!typing)
					overlays += typing_indicator
					typing = 1
			else
				if(typing)
					overlays -= typing_indicator
					typing = 0
			return state

/mob/verb/say_wrapper() //We use this verb in the keybinds to change the typing state instead of the regular verb
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(1)
	hud_typing = 1
	var/message = typing_input(src, "", "say (text)") //This proc is what actually changes the typing state while returning a message
	hud_typing = 0
	set_typing_indicator(0)
	if(message)
		say_verb(message)

/mob/verb/me_wrapper() //Same as above but for Me verb
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(1)
	hud_typing = 1
	var/message = typing_input(src, "", "me (text)")
	hud_typing = 0
	set_typing_indicator(0)
	if(message)
		me_verb(message)

/client/verb/typing_indicator() //Typing indicator toggle
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles showing an indicator when you are typing emote or say message."
	prefs.toggles ^= SHOW_TYPING
	prefs.save_preferences(src)
	to_chat(src, "You will [(prefs.toggles & SHOW_TYPING) ? "no longer" : "now"] display a typing indicator.")

	// Clear out any existing typing indicator.
	if(prefs.toggles & SHOW_TYPING)
		if(istype(mob)) mob.set_typing_indicator(0)

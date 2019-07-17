


/obj/machinery/computer/vox
	name = "vox announcement system"
	desc = "A console for making high priority announcements"
	icon = 'russstation/icons/obj/machinery/computer.dmi'
	icon_screen = "vox_system"
	icon_keyboard = "tech_key"
	req_access = list(ACCESS_HEADS)
	circuit = /obj/item/circuitboard/computer/vox
	var/authenticated = 0
	var/auth_id = "Unknown" //Who is currently logged in?
	var/state = STATE_DEFAULT
	var/last_announcement = ""
	var/const/STATE_DEFAULT = 1
	light_color = LIGHT_COLOR_BLUE

#ifdef AI_VOX
#define VOX_DELAY 600

/obj/machinery/computer/vox/Topic(href, href_list)
	if(..())
		return
	if(!href_list["operation"])
		if(href_list["say_word"])
			play_vox_word(href_list["say_word"], null, usr)
		return
	switch(href_list["operation"])
		// main interface
		if("main")
			state = STATE_DEFAULT
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		if("login")
			var/mob/M = usr

			var/obj/item/card/id/I = M.get_idcard(TRUE)

			if(I && istype(I))
				if(check_access(I))
					authenticated = 1
					auth_id = "[I.registered_name] ([I.assignment])"
					if((20 in I.access))
						authenticated = 2
					playsound(src, 'sound/machines/terminal_on.ogg', 50, 0)
			if(obj_flags & EMAGGED)
				authenticated = 2
				auth_id = "Unknown"
				to_chat(M, "<span class='warning'>[src] lets out a quiet alarm as its login is overridden.</span>")
				playsound(src, 'sound/machines/terminal_on.ogg', 50, 0)
				playsound(src, 'sound/machines/terminal_alert.ogg', 25, 0)
			if(authenticated == 0)
				to_chat(usr, "<span class='warning'>Access Denied</span>")
		if("logout")
			authenticated = 0
			playsound(src, 'sound/machines/terminal_off.ogg', 50, 0)

		if("announce")
			state = STATE_DEFAULT
			if(authenticated)
				playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
				announce(usr)
		if("help")
			state = STATE_DEFAULT
			if(authenticated)
				announce_help(usr)

	updateUsrDialog()

/obj/machinery/computer/vox/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	if(authenticated == 1)
		authenticated = 2
	to_chat(user, "<span class='danger'>You bypass the console's authentication system!</span>")
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)


/obj/machinery/computer/vox/proc/announce(mob/living/user)
	var/static/announcing_vox = 0 // Stores the time of the last announcement
	if(announcing_vox > world.time)
		to_chat(user, "<span class='notice'>Please wait [DisplayTimeText(announcing_vox - world.time)].</span>")
		return

	var/message = stripped_input(user, "WARNING: Misuse of this system can result in you being job banned. More help is available in 'Announcement Help'", "What?")

	last_announcement = message

	if(!message || announcing_vox > world.time || !user.canUseTopic(src, !issilicon(usr)))
		return

	if(user.incapacitated())
		return

	var/list/words = splittext(trim(message), " ")
	var/list/incorrect_words = list()

	if(words.len > 30)
		words.len = 30

	for(var/word in words)
		word = lowertext(trim(word))
		if(!word)
			words -= word
			continue
		if(!GLOB.vox_sounds[word])
			incorrect_words += word

	if(incorrect_words.len)
		to_chat(user, "<span class='notice'>These words are not available on the announcement system: [english_list(incorrect_words)].</span>")
		return

	announcing_vox = world.time + VOX_DELAY

	log_game("[key_name(user)] made a vocal announcement with the following message: [message].")

	for(var/word in words)
		play_vox_word(word, z, null)
	deadchat_broadcast(" made a vox announcement from <span class='name'>[get_area_name(usr, TRUE)]</span>.", "<span class='name'>[user.real_name]</span>", user)

/obj/machinery/computer/vox/proc/announce_help(mob/living/user)
	if(user.incapacitated())
		return

	var/dat = {"
	<font class='bad'>WARNING:</font> Misuse of the announcement system will get you job banned.<BR><BR>
	Here is a list of words you can type into the 'Announcement' button to create sentences to vocally announce to everyone on the same level at you.<BR>
	<UL><LI>You can also click on the word to PREVIEW it.</LI>
	<LI>You can only say 30 words for every announcement.</LI>
	<LI>Do not use punctuation as you would normally, if you want a pause you can use the full stop and comma characters by separating them with spaces, like so: 'Alpha . Test , Bravo'.</LI>
	<LI>Numbers are in word format, e.g. eight, sixty, etc </LI>
	<LI>Sound effects begin with an 's' before the actual word, e.g. scensor</LI>
	<LI>Use Ctrl+F to see if a word exists in the list.</LI></UL><HR>
	"}

	var/index = 0
	for(var/word in GLOB.vox_sounds)
		index++
		dat += "<A href='?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
		if(index != GLOB.vox_sounds.len)
			dat += " / "

	var/datum/browser/popup = new(user, "announce_help", "Announcement Help", 500, 400)
	popup.set_content(dat)
	popup.open()

#undef VOX_DELAY
#endif

/obj/machinery/computer/vox/ui_interact(mob/user)
	. = ..()
	var/dat = ""
	
	var/datum/browser/popup = new(user, "vox", "Vox Console", 400, 500)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))

	switch(state)
		if(STATE_DEFAULT)
			if (authenticated)
				dat += "Logged in as: [auth_id]"
				dat += "<BR>"
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=logout'>Log Out</A> \]<BR>"
				dat += "<BR><B>General Functions</B>"
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=announce'>Make Announcement</A> \]"
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=help'>Help</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=login'>Log In</A> \]"


	dat += "<BR><BR>\[ [(state != STATE_DEFAULT) ? "<A HREF='?src=[REF(src)];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=[REF(user)];mach_close=vox'>Close</A> \]"

	popup.set_content(dat)
	popup.open()

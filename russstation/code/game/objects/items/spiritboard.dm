/**
  * Spirit Board
  *
  * Allows Ghosts to spell words out, starting a cooldown.
  * In the future, it might be good to move this into a component given to the spiritboard.
  */

/obj/item/spiritboard
	name = "Spirit board"
	desc = "A wooden board that allows for communication with spirits and such things. Or that's what the company that makes them claims, at least."
	icon = 'russstation/icons/obj/spiritboard.dmi'
	icon_state = "lboard"
	inhand_icon_state = "clipboard"
	w_class = WEIGHT_CLASS_NORMAL
	///Is the board ready for use? - Unused.
	var/ready = TRUE
	///How many users are nearby?
	var/list/users = list()
	///Delay between each use
	var/use_delay = 3 SECONDS

/obj/item/spiritboard/attack_ghost(mob/dead/observer/user)
	if(!isobserver(user))
		return

	if(!users.Find(usr))
		users[usr] = 0

	if((world.time - users[usr]) < use_delay)
		to_chat(user, span_notice("Please wait a moment before using the board again."))
		return

	var/list/words = list()
	for(var/i = 0, i < rand(5, 10), i++)
		var/picked = pick(world.file2list("russstation/strings/spirit_board.txt"))
		if(!words.Find(picked)) words.Add(picked)

	if(words.len)
		var/selected = input(usr, "Select a word:", src.name) as null|anything in words
		if(!selected) return
		if((world.time - users[usr]) < use_delay)
			to_chat(user, span_notice("Please wait a moment before using the board again."))
			return

		users[usr] = world.time
		if(src && selected)
			for(var/mob/M in view(7, src))
				if(M.client)
					// display descriptive message in chat, but just the selected word in runechat
					to_chat(M, span_blue("<B>The board spells out a message ... \"[selected]\"</B>"))
					M.create_chat_message(src, raw_message = selected)

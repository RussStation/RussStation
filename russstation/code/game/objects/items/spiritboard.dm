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
	w_class = 3.0
	///Is the board ready for use? - Unused.
	var/ready = TRUE
	///How many users are nearby?
	var/list/users = list()
	///Delay between each use
	var/use_delay = 30

/obj/item/spiritboard/attack_ghost(mob/dead/observer/user)
	if(!isobserver(user))
		return

	if(!users.Find(usr))
		users[usr] = 0

	if((world.time - users[usr]) < use_delay)
		to_chat(user, "<span class='notice'>Please wait a moment before using the board again.</span>")
		return

	var/list/words = list()
	for(var/i = 0, i < rand(5, 10), i++)
		var/picked = pick(world.file2list("russstation/strings/spirit_board.txt"))
		if(!words.Find(picked)) words.Add(picked)

	if(words.len)
		var/selected = input(usr, "Select a word:", src.name) as null|anything in words
		if(!selected) return
		if((world.time - users[usr]) < use_delay)
			to_chat(user, "<span class='notice'>Please wait a moment before using the board again.</span>")
			return

		users[usr] = world.time
		if(src && selected)
			for(var/mob/O in range(7, src))
				visible_message("<B><span style=\"color:blue font-family:Impact\">The board spells out a message ... \"[selected]\"</span></B>")

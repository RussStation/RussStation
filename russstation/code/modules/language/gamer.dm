/datum/language/gamer
	name = "Gamer Lingo"
	desc = "The language of gamers who have transcended to the legendary peak of gaming."
	key = "r"
	space_chance = 90 // occasional compound word is funny
	default_priority = 69 // nice
	// gamers really like using the G word
	var/list/gamer_syllables = list("game", "gamer", "gaming")
	var/gamer_word_chance = 35
	syllables = list(
		// kinda sorta organized by very vague categories of similarity
		"pogchamp", "poggers", "combo", "wavedash", "ezclap",
		"no-scope", "headshot", "kill-streak", "wallhacks", "sniped",
		"level-up", "points", "craft", "grind", "dungeon", "guild", "raid", "party",
		"win", "winner", "achievement", "victory royale", "leaderboard",
		"replay", "play", "highlight", "clip",
		"button", "mash", "stick", "pad", "controller", "PC", "console", "arcade",
		"tilt", "salt", "cry", "loser", "throw", "baby", "cheat", "dirty", "gank",
		"early-access", "loot", "lootbox", "preorder",
		"boritos", "pizza", "Pwr Game", "Space Mountain Wind",
		"internet", "connection", "wifi", "multiplayer", "co-op", "lag",
		"couch", "basement", "Mom",
		"MMO", "KDA", "APM", "DPS", "MOBA", "EXP", "LAN", "FPS",
		"69", "360", "420", "1337")
	icon = 'russstation/icons/misc/language.dmi'
	icon_state = "gamer"

// duped from base class so we can inject gamer words often
/datum/language/gamer/scramble(input)
	if(!syllables || !syllables.len)
		return stars(input)

	var/lookup = check_cache(input)
	if(lookup)
		return lookup

	var/input_size = length_char(input)
	var/scrambled_text = ""
	var/capitalize = TRUE

	while(length_char(scrambled_text) < input_size)
		var/next
		var/chance = rand(100)
		// G A M E R
		if(chance <= gamer_word_chance)
			next = pick(gamer_syllables)
		else
			next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = FALSE
		scrambled_text += next
		chance = rand(100)
		if(chance <= sentence_chance)
			scrambled_text += ". "
			capitalize = TRUE
		else if(chance > sentence_chance && chance <= space_chance)
			scrambled_text += " "

	scrambled_text = trim(scrambled_text)
	var/ending = copytext_char(scrambled_text, -1)
	if(ending == ".")
		scrambled_text = copytext_char(scrambled_text, 1, -2)
	var/input_ending = copytext_char(input, -1)
	if(input_ending in list("!","?","."))
		scrambled_text += input_ending

	add_to_cache(input, scrambled_text)

	return scrambled_text

//Original code from Hippie Station with some edits to allow TG emoji
///Checks text for emoji icon names between two ':' characters
/proc/emoji_parse(text)
	. = text
	if(!CONFIG_GET(flag/emojis))
		return
	var/static/list/emojis = icon_states(icon('icons/emoji.dmi'))
	var/static/list/russemojis = icon_states(icon('russstation/icons/emoji.dmi'))
	var/parsed = ""
	var/pos = 1
	var/search = 0
	var/emoji = ""
	while(1)
		search = findtext(text, ":", pos)
		parsed += copytext(text, pos, search)
		if(search)
			pos = search
			search = findtext(text, ":", pos+1)
			if(search)
				emoji = lowertext(copytext(text, pos+1, search))
				if(emoji in emojis)
					parsed += icon2html('icons/emoji.dmi', world, emoji)
					pos = search + 1
				else if(emoji in russemojis)
					parsed += icon2html('russstation/icons/emoji.dmi', world, emoji)
					pos = search + 1
				else
					parsed += copytext(text, pos, search)
					pos = search
				emoji = ""
				continue
			else
				parsed += copytext(text, pos, search)
		break
	return parsed

/datum/asset/simple/icon_states/emojis
	icon = 'icons/emoji.dmi'

/datum/asset/simple/icon_states/russemojis
	icon = 'russstation/icons/emoji.dmi'

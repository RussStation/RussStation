//Adds russstation emoji to the chat sprite sheet
/datum/asset/spritesheet/chat/create_spritesheets()
	InsertAll("emoji", 'russstation/icons/emoji.dmi')
	. = ..()

/datum/quirk/multilingual
	name = "Multilingual"
	desc = "You speak another language, useful for when you're speaking to foreign exchange interns!"
	icon = FA_ICON_COMMENTS
	value = 4
	gain_text = "<span class='notice'>You've developed fluency in another language."
	lose_text = "<span class='notice'>Some words being spoken around you don't make any sense anymore."
	medical_record_text = "Patient spent time learning another language, what a nerd."
	var/multilingual

// Utilizing post_add here to ensure that we have a valid client with preferences loaded
/datum/quirk/multilingual/post_add()
	// Get the mutilingual stored or in preferences
	multilingual = multilingual || quirk_holder.client?.prefs?.read_preference(/datum/preference/choiced/multilingual)
	switch(multilingual) // honk -- there's probably a better way for this but I couldnt figure it out without breaking everything. credit to the nearsighted perk giving me the precedent to make these if statements :)
		if ("uncommon")
			multilingual = /datum/language/uncommon
		if ("draconic")
			multilingual = /datum/language/draconic
		if ("moffic")
			multilingual = /datum/language/moffic
		if ("nekomimetic")
			multilingual = /datum/language/nekomimetic
		if ("queekish")
			multilingual = /datum/language/queekish
		if ("kitsumimetic")
			multilingual = /datum/language/kitsumimetic
	quirk_holder.grant_language(multilingual)

/datum/quirk/multilingual/remove()
	quirk_holder.remove_language(multilingual)

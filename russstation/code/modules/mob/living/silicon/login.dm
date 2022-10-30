/mob/living/silicon/Login()
	// warn silicon players to not be shitty
	to_chat(src, span_boldwarning("Due to the nature of silicon roles your actions will be under more scrutiny, keep this in mind when following server rules and AI laws."))
	return ..()

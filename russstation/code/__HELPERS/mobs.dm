/proc/random_unique_diona_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.diona_first)) + " " + capitalize(pick(GLOB.diona_last))

		if(!findname(.))
			break

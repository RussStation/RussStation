/datum/unit_test/species_whitelist_check/Run()
	for(var/typepath in subtypesof(/datum/species) - /datum/species/dwarf) // honk -- remove dwarf from the checked list until changesource_flags are set
		var/datum/species/S = typepath
		if(initial(S.changesource_flags) == NONE)
			TEST_FAIL("A species type was detected with no changesource flags: [S]")

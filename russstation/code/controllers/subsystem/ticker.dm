// do more stuff during station setup without editing tg files
/datum/controller/subsystem/ticker/setup()
	. = ..()
	if(!.)
		return FALSE
	// apply shitstation's extra fun station trait(s)
	if(SSmapping.config.map_file == "ShitStation.dmm")
		SSstation.station_traits += new /datum/station_trait/frequency_change()

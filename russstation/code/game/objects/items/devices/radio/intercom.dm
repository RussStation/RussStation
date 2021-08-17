// track intercoms for easier traversal
/obj/item/radio/intercom/Initialize(mapload, ndir, building)
	. = ..()
	GLOB.intercom_list += src

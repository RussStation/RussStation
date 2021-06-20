/obj/item/areaeditor/dwarf
	name = "embarkment claim"
	desc = "A land grant from the nobles for claiming Dwarven land."
	color = "#aa7c5a"
	fluffnotice = "For dwarves only. Use to embark further into this strange land. Strike the earth!"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF // it's like station blueprints, important

/obj/item/areaeditor/dwarf/attack_self(mob/user)
	add_fingerprint(user)
	// only dwarves can use them
	if(!is_species(usr, /datum/species/dwarf))
		to_chat(usr, "You can't seem to make sense of the dwarven property laws or their handwriting.")
	else
		// don't call ..() as it inserts information the dwarves won't know.
		. = "<BODY><HTML><head><title>[src]</title></head> \
					<h2>Dwarven Enbarkment Claim</h2><hr> \
					<small>[fluffnotice]</small><hr>"
		var/area/A = get_area(src)
		// dwarfprints only work on lavaland
		if(!is_mining_level(A.z))
			. += "<p>According to \the [src.name], this place is too far from the mountainhomes.</p>"
		else
			if(A.outdoors)
				. += "<p>According to \the [src.name], you are now in an unclaimed territory.</p>"
			else
				. += "<p>According to \the [src.name], you are now in <b>\"[html_encode(A.name)]\"</b>.</p>"
			. += "<p><a href='?src=[REF(src)];create_area=1'>Create or modify an existing area</a></p>"

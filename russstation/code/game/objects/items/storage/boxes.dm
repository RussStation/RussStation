// easy hack for survival box, replace the vars that it instantiates.
// tried making custom box type and it was a PAIN don't do it,
// you'd have to assign new box on every outfit
/obj/item/storage/box/survival/wardrobe_removal()
	// if not skaven, do the normal logic
	if(!isskaven(loc))
		return ..()
	name = "skaven survival box"
	desc = "A box with the bare essentials of ensuring the survival of you and others. This one is labelled to contain supplies for Skavens."
	// copied from parent func for plasmamen internals
	var/obj/item/mask = locate(mask_type) in src
	var/obj/item/internals = locate(internal_type) in src
	new /obj/item/tank/internals/skaven/belt/full(src)
	new /obj/item/clothing/mask/gas/skaven(src)
	qdel(mask)
	qdel(internals)

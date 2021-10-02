// easy hack for survival box, replace the vars that it instantiates.
// tried making custom box type and it was a PAIN don't do it,
// you'd have to assign new box on every outfit
/obj/item/storage/box/survival/PopulateContents()
	if(isskaven(loc))
		name = "skaven survival box"
		desc = "A box with the bare essentials of ensuring the survival of you and others. This one is labelled to contain supplies for Skavens."
		mask_type = /obj/item/clothing/mask/gas/skaven
		internal_type = /obj/item/tank/internals/skaven/belt/full
	..()

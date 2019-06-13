//This is the Russ Station init file, here we will initialize everything Russ Station where possible.
//Create a proc to load something in the appropriate module file and call the proc here.

/proc/russ_initialize()
	init_sprite_accessory_subtypes(/datum/sprite_accessory/diona_hair, GLOB.diona_hair_list, roundstart = TRUE)

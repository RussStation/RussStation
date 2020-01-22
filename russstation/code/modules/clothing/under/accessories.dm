/obj/item/clothing/accessory
	var/icon_attached = 'icons/mob/clothing/accessories.dmi' // the file that has the version of the sprite used when attached

/obj/item/clothing/accessory/medal/russ
	icon = 'russstation/icons/obj/clothing/accessories.dmi'
	icon_attached = 'russstation/icons/mob/clothing/accessories.dmi'

/obj/item/clothing/accessory/medal/russ/deputy
	name = "deputy star"
	desc = "A star symbolizing authority."
	icon_state = "deputy"
	medaltype = "medal-gold"
	custom_materials = list(/datum/material/gold=1000)
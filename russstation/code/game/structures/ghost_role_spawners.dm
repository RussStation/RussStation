/obj/effect/mob_spawn/human/dwarf_dorm
	name = "dwarven dorm"
	desc = "A dorm fit for a dwarf to claim or use."
	mob_name = "dwarf"
	icon = 'russstation/icons/obj/device.dmi'
	icon_state = "migrant_portal"
	density = TRUE 
	anchored = TRUE 
	roundstart = FALSE
	death = FALSE 
	move_resist = MOVE_FORCE_NORMAL
	mob_species = /datum/species/dwarf
	outfit = /datum/outfit/dorf
	flavour_text = "<span class='big bold'>You are a dwarf.</span><b> You have arrived. After a journey from the Mountainhomes into the forbidding wilderness beyond, \
	your harsh trek has finally ended. Whether by bolt, plow or hook, provide for youselves, ere the local fauna get hungry. A new chapter of dwarven history begins here \
	at this place, \"Hammerflames\". Strike the earth!</b>"
	assignedrole = "Dwarf"

/obj/effect/mob_spawn/human/dwarf_dorm/special(mob/living/carbon/human/new_spawn)
	new_spawn.fully_replace_character_name(null,dwarf_name())
	new_spawn.gender = MALE // no wahmen allowed yet
	to_chat(new_spawn, "<b>Claim these lands to the dwarven race and purge the hostile creatures of these lands, all the while encouraging migrants with dorm rooms!</b>")

/obj/effect/mob_spawn/human/dwarf_dorm/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A dwarven dorm was made and ready to use in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_DWARF)

/datum/outfit/dorf
	name = "Dwarf Standard"
	uniform = /obj/item/clothing/under/dwarf
	shoes = /obj/item/clothing/shoes/dwarf
	back = /obj/item/storage/backpack/satchel/leather
	gloves = /obj/item/clothing/gloves/dwarf

/obj/item/reagent_containers/food/drinks/wooden_mug
	name = "wooden mug"
	desc = "A mug for serving hearty brews."
	icon_state = "manlydorfglass"
	item_state = "coffee"
	spillable = 1
	isGlass = FALSE


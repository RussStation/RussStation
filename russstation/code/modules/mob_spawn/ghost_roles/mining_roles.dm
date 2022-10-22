/obj/effect/mob_spawn/ghost_role/human/dwarf_dorm
	name = "dwarven dorm"
	desc = "A dorm fit for a dwarf to claim or use."
	prompt_name = "a dwarf"
	icon = 'russstation/icons/obj/device.dmi'
	icon_state = "migrant_portal"
	density = TRUE
	anchored = TRUE
	move_resist = MOVE_FORCE_NORMAL
	mob_species = /datum/species/dwarf/lavaland
	outfit = /datum/outfit/dorf
	you_are_text = "You are a dwarf."
	flavour_text = "You have arrived. After a journey from the Mountainhomes into the forbidding wilderness beyond, \
	your harsh trek has finally ended. Whether by bolt, plow or hook, provide for youselves, ere the local fauna get hungry. A new chapter of dwarven history begins here \
	at this place, \"Hammerflames\". Strike the earth!"
	important_text = "Do not leave Lavaland or sabotage the mining base."
	spawner_job_path = /datum/job/dwarf

/obj/effect/mob_spawn/ghost_role/human/dwarf_dorm/special(mob/living/carbon/human/new_spawn)
	. = ..()
	new_spawn.fully_replace_character_name(null,dwarf_name())
	new_spawn.gender = pick(list(MALE, FEMALE))
	to_chat(new_spawn, span_notice("<b>Claim these lands to the dwarven race and purge the hostile creatures of these lands, all the while encouraging migrants with dorm rooms!</b>"))

/obj/effect/mob_spawn/ghost_role/human/dwarf_dorm/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A dwarven dorm was made and ready to use in \the [A.name].", source = src, action = NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_DWARF)

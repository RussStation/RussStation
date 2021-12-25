// convenience mapping spawners that upstream doesn't have for some raisin
// spawn desired container and then carry on as usual with the maint loot

/obj/effect/spawner/random/maintenance/closet
	icon_state = "locker"
	spawn_loot_count = 3

/obj/effect/spawner/random/maintenance/closet/Initialize(mapload)
	new /obj/effect/spawner/random/structure/closet_empty(loc)
	. = ..()

/obj/effect/spawner/random/maintenance/crate
	icon_state = "crate"
	spawn_loot_count = 3

/obj/effect/spawner/random/maintenance/crate/Initialize(mapload)
	new /obj/effect/spawner/random/structure/crate_empty(loc)
	. = ..()

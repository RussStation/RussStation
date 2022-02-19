// area adjustments from icebox to icecube to account for main station being on the bottom

// no-monster area for lower station level
/area/icemoon/underground/unexplored/rivers/no_monsters
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | CAVES_ALLOWED | NO_ALERTS

// areas for the bad version of lavaland

/area/badlands
	name = "Badlands"
	icon_state = "mining"
	outdoors = TRUE
	mood_bonus = -3
	mood_message = "<span class='boldwarning'>This place gives me the creeps!</span>"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_CREEPY
	sound_environment = SOUND_AREA_ASTEROID
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | NO_ALERTS
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS
	base_lighting_color = COLOR_ORANGE

/area/badlands/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | NO_ALERTS
	map_generator = /datum/map_generator/cave_generator/badlands

/area/badlands/unexplored/danger //megafauna will also spawn here
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS

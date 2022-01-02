// area adjustments from icebox to icecube to account for main station being on the bottom

// megafauna moved to upper level
/area/icemoon/surface/outdoors/unexplored
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS

// cave generator options for surface for more interest
/area/icemoon/surface/outdoors/unexplored/caves
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/surface/outdoors/unexplored/caves/deep
	map_generator = /datum/map_generator/cave_generator/icemoon/deep

// no megafauna on lower level
/area/icemoon/underground/unexplored
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | NO_ALERTS

// no-monster area for lower station level
/area/icemoon/underground/unexplored/rivers/no_monsters
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | CAVES_ALLOWED | NO_ALERTS

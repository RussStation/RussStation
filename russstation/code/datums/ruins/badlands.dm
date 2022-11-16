// badlands ruins - mostly just reusing fun ones from elsewhere
/datum/map_template/ruin/badlands
	ruin_type = ZTRAIT_BADLANDS_RUINS
	prefix = "_maps/RandomRuins/LavaRuins/"
	default_area = /area/badlands/unexplored
	always_place = TRUE
	allow_duplicates = FALSE

/datum/map_template/ruin/badlands/dwarf
	name = "Dorf Colony"
	id = "dorf-man"
	description = "A shitty chapter of dwarven history starts here."
	suffix = "lavaland_surface_dwarf.dmm"

/datum/map_template/ruin/badlands/hierophant
	name = "Hierophant's Arena"
	id = "hierophant"
	description = "A strange, square chunk of metal of massive size. Inside awaits only death and many, many squares."
	suffix = "lavaland_surface_hierophant.dmm"

/datum/map_template/ruin/badlands/wendigo_cave
	name = "Wendigo Cave"
	id = "wendigocave"
	description = "Into the jaws of the beast."
	prefix = "_maps/RandomRuins/IceRuins/"
	suffix = "icemoon_underground_wendigo_cave.dmm"

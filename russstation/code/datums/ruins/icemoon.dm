// ensure free golems always available for ghost roles
/datum/map_template/ruin/icemoon/underground/free_golem
	always_place = TRUE

// hiero on icemoon
/datum/map_template/ruin/icemoon/underground/hierophant
	name = "Hierophant's Arena"
	id = "hierophant"
	description = "A strange, square chunk of metal of massive size. Inside awaits only death and many, many squares."
	suffix = "icemoon_underground_hierophant.dmm"
	always_place = TRUE

//dorfs in da mountains????
/datum/map_template/ruin/icemoon/underground/dwarf
	name = "Dwarf Colony"
	id = "dorf-man"
	description = "A new chapter of dwarven history starts here."
	suffix = "icemoon_underground_dwarf.dmm"
	always_place = TRUE
	cost = 10
	allow_duplicates = FALSE

/datum/map_template/ruin/icemoon/underground/chaos_dwarf
	name = "Chaos Dwarf Tribe"
	id = "chaos-dwarfs"
	description = "A handful of Dwarf's dug too deep..."
	suffix = "icemoon_underground_chaos_dwarf.dmm"
	always_place = TRUE
	allow_duplicates = FALSE

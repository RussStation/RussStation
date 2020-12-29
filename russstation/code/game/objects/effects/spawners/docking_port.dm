/obj/effect/spawner/docking_port
	icon = 'icons/obj/device.dmi'
	icon_state = "pinonfar"
	name = "docking port randomized spawner"
	var/list/static/spawners = list()
	var/selected = FALSE // indicate the selected spawner, useful if it's not the one that ran first
	// docking_port passthrough vars
	var/id = ""
	var/width = 0
	var/height = 0
	var/dwidth = 0
	var/dheight = 0

/obj/effect/spawner/docking_port/Initialize()
	..()
	spawners |= src
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/docking_port/LateInitialize()
	..()
	// try to run this once only
	if(spawners && spawners.len)
		world.log << "Selecting among [spawners.len] dock spawners"
		var/obj/effect/spawner/docking_port/winner = pick(spawners)
		winner.selected = TRUE
		world.log << "Randomly selected docking port [winner] at [winner.loc.x],[winner.loc.y]"
		// cease this picking from happening again
		spawners = list()
	if(selected)
		// spawn and copy over the vars
		var/obj/docking_port/stationary/dock = new /obj/docking_port/stationary(loc)
		dock.id = id
		dock.width = width
		dock.height = height
		dock.dwidth = dwidth
		dock.dheight = dheight
		dock.dir = dir
	qdel(src)
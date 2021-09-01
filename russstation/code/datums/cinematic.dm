// execute with Cinematic(CINEMATIC_SHITTY,world) or admin menu
/datum/cinematic/shitty
	id = CINEMATIC_SHITTY
	cleanup_time = 70

/datum/cinematic/shitty/content()
	screen.icon = 'russstation/icons/effects/station_explosion.dmi'
	flick("shitty_explosion",screen)
	sleep(30)
	cinematic_sound(sound('russstation/sound/effects/toot.ogg'))
	special()


/**
 * Plays a cinematic. Can be to a select few people, or everyone.
 *
 * cinematic_type - datum typepath to what cinematic you wish to play.
 * watchers - a list of all mobs you are playing the cinematic to. If world, the cinematical will play globally to all players.
 * special_callback - optional callback to be invoked mid-cinematic.
 *
 * /proc/play_cinematic(datum/cinematic/cinematic_type, watchers, datum/callback/special_callback)
 * `code/datums/cinematics/_cinematic.dm`
 */

/datum/cinematic/shitty
	cleanup_time = 70

/datum/cinematic/shitty/play_cinematic()
	screen.icon = 'russstation/icons/effects/station_explosion.dmi'
	flick("shitty_explosion",screen)
	sleep(30)
	play_cinematic_sound(sound('russstation/sound/effects/toot.ogg'))
	special_callback?.Invoke()

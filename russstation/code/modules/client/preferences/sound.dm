/datum/preference/numeric/lobby_music_volume
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "lobby_music_volume"
	savefile_identifier = PREFERENCE_PLAYER

	minimum = 0
	maximum = 100

/datum/preference/numeric/lobby_music_volume/create_default_value()
	return 85

/datum/preference/numeric/lobby_music_volume/apply_to_client_updated(client/client, value)
	if(client.mob)
		client.mob.set_sound_channel_volume(CHANNEL_LOBBYMUSIC, value)

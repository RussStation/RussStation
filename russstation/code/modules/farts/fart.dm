/** A datum representing customizable farts */
/datum/fart

	/** possible fart sounds */
	var/list/sounds = list()
	/** time to wait to fart without risk */
	var/soft_cooldown = 2 SECONDS
	/** minimum wait time for farting */
	var/hard_cooldown = 0.5 SECONDS
	/** chance of triggering a soft fail when under the safe cooldown */
	var/fail_chance = 20
	/** the damage to be taken when failing */
	var/fail_damage = 5
	/** volume of gas to spawn in make_gas */
	var/gas_volume = 2.5
	/** gas id as defined in code\modules\atmospherics\gasmixtures\gas_types.dm */
	var/gas_id = null

/**
  * Produce side effects when a fart successfully happens
  */
/datum/fart/proc/make_gas(mob/living/user)
	if(gas_id) // by deafult is null and therefore no gas is spawned
		user.atmos_spawn_air("[gas_id]=[gas_volume];TEMP=[user.bodytemperature]") // spawn the defined gas at it's defined volume at the temperature of the user

/**
  * Gets called when the user is under the safe cooldown and failed the chance
  */
/datum/fart/proc/soft_fail(mob/living/user)
	return

/**
  * Gets called when the user goes under the hard cooldown
  */
/datum/fart/proc/hard_fail(mob/living/user)
	return

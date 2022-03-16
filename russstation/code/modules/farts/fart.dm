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
	var/gas_id
	/** type of damage to do when the fart fails */
	var/fail_damage_type
	/** message to send to user on soft fails */
	var/soft_fail_message
	/** message to send to user on hard fails */
	var/hard_fail_message

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
	if(prob(fail_chance))
		user.apply_damage_type(damage = fail_damage, damagetype = fail_damage_type)
		if(soft_fail_message)
			to_chat(user, span_notice(soft_fail_message))

/**
  * Gets called when the user goes under the hard cooldown
  */
/datum/fart/proc/hard_fail(mob/living/user)
	user.apply_damage_type(damage = fail_damage, damagetype = fail_damage_type)
	user.Stun(1 SECONDS)
	if(hard_fail_message)
		to_chat(user, span_notice(hard_fail_message))

/**
 * Attempt to fart, possibly causing a fail
 */
/datum/fart/proc/try_fart(mob/living/user, last_used)
	if(user.IsStun())
		to_chat(user, span_notice("You cannot fart while stunned!"))
	else if(last_used < hard_cooldown)
		hard_fail(user)
	else if(last_used < soft_cooldown)
		soft_fail(user)
		return TRUE
	else
		return TRUE

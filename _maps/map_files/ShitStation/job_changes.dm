#define JOB_MODIFICATION_MAP_NAME "ShitStation"

/datum/job/captain/New()
	..()
	MAP_JOB_CHECK
	total_positions = 2
	spawn_positions = 2
	paycheck = 25
/datum/job/clown/New()
	..()
	MAP_JOB_CHECK
	total_positions = 4
	spawn_positions = 3
/datum/job/prisoner/New()
	..()
	MAP_JOB_CHECK
	total_positions = 5
	spawn_positions = 3

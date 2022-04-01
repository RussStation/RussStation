// for situations that require a fun chaotic response
/datum/ert/wizard
	roles = list(/datum/antagonist/ert/wizard)
	leader_role = /datum/antagonist/ert/wizard
	// default to 1, that's already a lot of wizard
	teamsize = 1
	opendoors = FALSE
	rename_team = "Wizard Response Team"
	polldesc = "a contracted Wizard Federation Emergency Response Team"

// for no good reason in particular
/datum/ert/honk_squad
	roles = list(/datum/antagonist/ert/clown/honk_squad)
	leader_role = /datum/antagonist/ert/clown/honk_squad
	teamsize = 5
	opendoors = FALSE
	rename_team = "Honk Squad"
	polldesc = "a Nanotrasen Clown Conscript Team"
	mission = "Clown around."

/datum/ert/circus_seal
	roles = list(/datum/antagonist/ert/clown/circus_seal)
	leader_role = /datum/antagonist/ert/clown/circus_seal
	teamsize = 5
	opendoors = TRUE
	rename_team = "CIRCUS-SEALs"
	polldesc = "a contracted Clownian Navy CIRCUS-SEAL Team"
	mission = "Honk up the station."

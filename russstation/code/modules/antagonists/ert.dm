/datum/antagonist/ert/wizard
	role = "Wizard"
	suicide_cry = "FOR THE FEDERATION!!"
	outfit = /datum/outfit/centcom/ert/wizard

/datum/antagonist/ert/wizard/New()
	. = ..()
	name_source = GLOB.wizard_first

/datum/antagonist/ert/clown/New()
	. = ..()
	name_source = GLOB.clown_names

/datum/antagonist/ert/clown/honk_squad
	role = JOB_ERT_HONK_SQUAD
	suicide_cry = "Hjonk.."
	outfit = /datum/outfit/centcom/ert/clown/honk_squad

/datum/antagonist/ert/clown/circus_seal
	role = JOB_ERT_CIRCUS_SEAL
	suicide_cry = "Get honked, assholes"
	outfit = /datum/outfit/centcom/ert/clown/circus_seal

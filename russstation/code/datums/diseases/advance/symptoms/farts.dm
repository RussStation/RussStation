/datum/symptom/farts
	name = "Gastric distress"
	desc = "The virus upsets the host's gastrointestinal tract, forcing the host to fart."
	stealth = -1
	resistance = 1
	stage_speed = 2
	transmittable = 2
	level = 2
	severity = 2
	symptom_delay_min = 20
	symptom_delay_max = 50
	var/infective = FALSE
	threshold_descs = list(
		"Transmission 8" = "The virus will spread itself through farts.",
	)

/datum/symptom/farts/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalTransmittable() >= 8) //infective farts
		infective = TRUE

/datum/symptom/farts/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/M = A.affected_mob
	if(A.stage < 3)
		to_chat(M, span_warning("[pick("You feel constipated.", "You feel bloated.")]"))
	else
		if (M.fart)
			M.visible_message("[span_warning("[M] farts forcefully.")]", span_warning("[pick("You relieve some abdominal stress", "You couldn't contain your fart.", "You can't contain your gas any longer.")]"))
			M.fart.make_gas(M)
			if (infective)
				A.spread(2)
	return 1

/datum/disease/covid13
	name = "COVID-13"
	max_stages = 4
	stage_prob = 2
	spread_text = "Airborne"
	cure_text = "Spaceacillin"
	cures = list(/datum/reagent/medicine/spaceacillin)
	cure_chance = 2
	agent = "Delicious space bats"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	infectivity = 90
	desc = "A extraplanetary variant of an ancient coronavirus. If left untreated, the patients lungs will fail."
	severity = DISEASE_SEVERITY_DANGEROUS

/datum/disease/covid13/stage_act()
	..()
	switch(stage) // cut me a break, I only had half an hour
		if(3)
			if(prob(5))
				affected_mob.emote("cough")
			if(prob(5))
				to_chat(affected_mob, span_danger("Your muscles ache."))
				if(prob(20))
					affected_mob.take_bodypart_damage(1)
			if(prob(5))
				to_chat(affected_mob, span_danger("Your feel hot."))
				if(prob(20))
					affected_mob.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT)
		if(4)
			if(prob(10))
				affected_mob.emote("cough")
			if(prob(5))
				to_chat(affected_mob, span_danger("Your muscles ache."))
				if(prob(30))
					affected_mob.take_bodypart_damage(1)
			if(prob(5))
				to_chat(affected_mob, span_danger("Your feel hot."))
				if(prob(20))
					affected_mob.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT)
			if(prob(3))
				to_chat(affected_mob, span_danger("You have a hard time exhaling."))
				if(prob(20))
					affected_mob.adjustOrganLoss(ORGAN_SLOT_LUNGS, 2)
					affected_mob.updatehealth()
	return

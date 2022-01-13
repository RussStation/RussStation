#define FREQ_CHANGE_COOLDOWN_LENGTH_MIN 15 MINUTES
#define FREQ_CHANGE_COOLDOWN_LENGTH_MAX 25 MINUTES

/datum/station_trait/frequency_change
	name = "Radio frequency change"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 1
	show_in_report = TRUE
	report_message = "Your station is located in known syndicate territory. To ensure the protection of Nanotrasen brand secrets, the common radio frequency shall be changed periodically."
	trait_processes = TRUE
	// other announcers obscure the announcement text, and we kinda need to see the new freq
	blacklist = list(
		/datum/station_trait/announcement_medbot,
		/datum/station_trait/announcement_intern,
	)
	COOLDOWN_DECLARE(change_cooldown)
	var/last_frequency = FREQ_COMMON

/datum/station_trait/frequency_change/on_round_start()
	. = ..()
	COOLDOWN_START(src, change_cooldown, rand(FREQ_CHANGE_COOLDOWN_LENGTH_MIN, FREQ_CHANGE_COOLDOWN_LENGTH_MAX))

/datum/station_trait/frequency_change/process(delta_time)
	if(!COOLDOWN_FINISHED(src, change_cooldown))
		return

	COOLDOWN_START(src, change_cooldown, rand(FREQ_CHANGE_COOLDOWN_LENGTH_MIN, FREQ_CHANGE_COOLDOWN_LENGTH_MAX))

	// radio freqs must be odd and within a range
	var/new_frequency = rand(MIN_FREQ, MAX_FREQ)
	while(new_frequency == last_frequency || new_frequency % 2 == 0)
		new_frequency = rand(MIN_FREQ, MAX_FREQ)
	// absolutely devious
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		if(istype(T) && (last_frequency in T.freq_listening))
			T.freq_listening -= last_frequency
			// remove new freq too so it's not duped
			T.freq_listening -= new_frequency
			T.freq_listening += new_frequency
			// update the unique common frequency receiver
			var/obj/machinery/telecomms/receiver/force_common/R = T
			if(istype(R))
				R.common_frequency = new_frequency
	// update intercoms as well since they're wired
	// (mostly to keep the parrot room active)
	for(var/obj/item/radio/intercom/I in GLOB.intercom_list)
		if(istype(I) && I.frequency == last_frequency)
			I.set_frequency(new_frequency)
	// other machines and bots speak through internal radios that don't get caught by the intercom check,
	// only need to correct those that speak over common freq.
	// update bank machine so crew is helplessly aware of vault siphons
	for(var/obj/machinery/computer/bank_machine/M in GLOB.machines)
		if(istype(M) && M.radio_channel == last_frequency)
			M.radio_channel = new_frequency
	last_frequency = new_frequency
	priority_announce("The common radio frequency has been changed to [format_frequency(new_frequency)] for security purposes. Please adjust your headsets accordingly.", "Radio Frequency Change", SSstation.announcer.get_rand_report_sound())

#define FREQ_CHANGE_COOLDOWN_LENGTH_MIN 20 MINUTES
#define FREQ_CHANGE_COOLDOWN_LENGTH_MAX 30 MINUTES
#define FREQ_CHANGE_COOLDOWN_MULTIPLIER_INCREMENT 2.5

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
	// cooldown should get longer so long rounds aren't punished as badly
	var/cooldown_multiplier = 1
	var/last_frequency = FREQ_COMMON

/datum/station_trait/frequency_change/on_round_start()
	. = ..()
	COOLDOWN_START(src, change_cooldown, rand(FREQ_CHANGE_COOLDOWN_LENGTH_MIN, FREQ_CHANGE_COOLDOWN_LENGTH_MAX))

/datum/station_trait/frequency_change/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, change_cooldown))
		return

	cooldown_multiplier *= FREQ_CHANGE_COOLDOWN_MULTIPLIER_INCREMENT
	var/cooldown_time = cooldown_multiplier * rand(FREQ_CHANGE_COOLDOWN_LENGTH_MIN, FREQ_CHANGE_COOLDOWN_LENGTH_MAX)
	COOLDOWN_START(src, change_cooldown, cooldown_time)

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
		if(istype(I) && I.get_frequency() == last_frequency)
			I.set_frequency(new_frequency)
	// other machines and bots speak through internal radios that don't get caught by the intercom check,
	// only need to correct those that speak over common freq.
	// update bank machine so crew is helplessly aware of vault siphons
	for(var/obj/machinery/computer/bank_machine/M in GLOB.machines)
		if(istype(M) && M.radio_channel == last_frequency)
			M.radio_channel = new_frequency
	last_frequency = new_frequency
	var/msg = "The common radio frequency has been changed to [format_frequency(new_frequency)] for security purposes. Please adjust your headsets accordingly."
	priority_announce(msg, "Radio Frequency Change", SSstation.announcer.get_rand_report_sound())
	// send report since there's otherwise no record of this event occurring
	print_command_report(msg, "Radio Frequency Change", FALSE)

// special receiver for shitstation to facilitate all chatter on Common
/obj/machinery/telecomms/receiver/force_common
	id = "Receiver"
	network = "tcommsat"
	autolinkers = list("receiver")
	// listens to all department channels
	// radio scramble will reset freq_listening so we need a separate list
	var/department_channels = list(FREQ_SCIENCE, FREQ_MEDICAL, FREQ_SUPPLY, FREQ_SERVICE, FREQ_COMMAND, FREQ_ENGINEERING, FREQ_SECURITY, FREQ_COMMON)
	// track replacement frequency during scrambles
	var/common_frequency = FREQ_COMMON

/obj/machinery/telecomms/receiver/force_common/receive_signal(datum/signal/subspace/signal)
	// if the signal is on a department channel, change it to common
	if(signal.frequency in department_channels)
		signal.frequency = common_frequency
	. = ..()

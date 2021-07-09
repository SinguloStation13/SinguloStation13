//
// Solar Control Computer that automatically connects to solar panels roundstart
//

/obj/machinery/power/solar_control/auto_connect/Initialize(mapload)
	. = ..()
	if(connected_tracker)
		track = SOLAR_TRACK_AUTO
	if(mapload)
		RegisterSignal(src, COMSIG_MACHINE_POWERNET_ROUNDSTART_INIT, .proc/auto_connect)

/obj/machinery/power/solar_control/auto_connect/proc/auto_connect()
	SIGNAL_HANDLER
	search_for_connected()
	if(connected_tracker)
		track = SOLAR_TRACK_AUTO

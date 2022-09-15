/datum/wires/mass_driver
	holder_type = /obj/machinery/mass_driver
	proper_name = "Mass Driver"

/datum/wires/mass_driver/New(atom/holder)
	wires = list(WIRE_LAUNCH, WIRE_INTERFACE)
	..()

/datum/wires/mass_driver/on_pulse(wire)
	var/obj/machinery/mass_driver/M = holder
//Singulo start - diagonal mass drivers
	if(M.stat & (NOPOWER|BROKEN))
		return

	switch(wire)
		if(WIRE_LAUNCH)
			M.drive()
		if(WIRE_INTERFACE)
			M.setDir(turn(M.dir, -45))
			M.transform = matrix().Turn(dir2angle(M.dir))

	M.use_power(M.active_power_usage)
//Singulo end

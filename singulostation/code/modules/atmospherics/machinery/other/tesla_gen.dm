/obj/machinery/atmospherics/components/unary/teslagen
	name = "experimental gas generator"
	desc = "Generates gasses from the electrical shock of a tesla."
	icon = 'singulostation/icons/obj/tesla_engine/tesla_gas_gen.dmi'
	icon_state = "closed"
	density = TRUE
	resistance_flags = ACID_PROOF|FIRE_PROOF
	interacts_with_air = TRUE
	circuit = /obj/item/circuitboard/machine/thermomachine/teslagen

	var/static/list/possible_gases = list(
		GAS_PLASMA = list(
			"o2=22;TEMP=293.15"		= 2,
			"n2=82;TEMP=293.15"		= 3,
			"plasma=22;TEMP=293.15"	= 1
		)
	)
//	var/spawn_temp = T20C
	/// Moles of gas to spawn per second
//	var/spawn_mol = MOLES_CELLSTANDARD * 5
//	var/max_ext_mol = INFINITY
//	var/max_ext_kpa = 6500
	var/overlay_color = "#FFFFFF"

	var/obj/machinery/teslagen_coil/coil = null

/obj/machinery/atmospherics/components/unary/teslagen/Initialize(mapload)
	. = ..()

	initialize_directions = dir
	coil = new /obj/machinery/teslagen_coil(loc)
	coil.gas_generator = src

	update_icon()

/obj/machinery/atmospherics/components/unary/teslagen/Destroy()
	qdel(coil)

	return ..()

/obj/machinery/atmospherics/components/unary/teslagen/on_construction()
	var/obj/item/circuitboard/machine/thermomachine/board = circuit
	if(board)
		piping_layer = board.pipe_layer
	return ..(dir, piping_layer)

/obj/machinery/atmospherics/components/unary/teslagen/default_change_direction_wrench(mob/user, obj/item/I)
	if(!..())
		return FALSE
	SetInitDirections()
	var/obj/machinery/atmospherics/node = nodes[1]
	if(node)
		node.disconnect(src)
		nodes[1] = null
	//Sometimes this gets called more than once per atmos tick; i.e. before the incoming build_network call by SSAIR_REBUILD_PIPENETS, so we check this here.
	if(parents[1])
		nullifyPipenet(parents[1])

	atmosinit()
	node = nodes[1]
	if(node)
		node.atmosinit()
		node.addMember(src)
	SSair.add_to_rebuild_queue(src)
	return TRUE

/obj/machinery/atmospherics/components/unary/teslagen/attackby(obj/item/I, mob/user, params)
	if(!on)
		if(default_deconstruction_screwdriver(user, "open", "closed", I))
			return
	if(default_change_direction_wrench(user, I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/atmospherics/components/unary/teslagen/update_icon()
	cut_overlays()

	if(panel_open)
		icon_state = "open"
	else
		icon_state = "closed"

	add_overlay(getpipeimage(icon, "pipe", dir, , piping_layer))

/obj/machinery/atmospherics/components/unary/teslagen/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		add_overlay(getpipeimage(icon, "scrub_cap", initialize_directions))

/obj/machinery/atmospherics/components/unary/teslagen/tesla_act(power, tesla_flags, shocked_targets)
	if(!panel_open)
		obj_flags |= BEING_SHOCKED
		playsound(src.loc, 'sound/magic/lightningshock.ogg', 100, 1, extrarange = 5)

		var/datum/gas_mixture/air_contents = airs[1]
		if(!air_contents)
			flick("fail", src)
			return

		if(air_contents.get_moles(GAS_PLASMA) < 5)
			flick("fail", src)
			return

		air_contents.adjust_moles(GAS_PLASMA, -5)
		flick("hit", src)
		release_gas(power)
	else
		..()

/obj/machinery/atmospherics/components/unary/teslagen/proc/release_gas(power)
	var/turf/open/O = get_turf(src)
	if(!isopenturf(O))
		return FALSE
	var/datum/gas_mixture/merger = new
	merger.parse_gas_string(pickweight(possible_gases[GAS_PLASMA]));
	O.assume_air(merger)
	O.air_update_turf(TRUE)
	return TRUE

/obj/machinery/teslagen_coil
	layer = CLICKCATCHER_PLANE
	invisibility = INVISIBILITY_MAXIMUM

	var/obj/machinery/atmospherics/components/unary/teslagen/gas_generator

/obj/machinery/teslagen_coil/Destroy()
	gas_generator = null

	return ..()

/obj/machinery/teslagen_coil/tesla_act(power)
	if(!gas_generator)
		qdel(src)
		CRASH("an /obj/machinery/teslagen_coil didn't have an attached teslagen. This should not be possible")

	gas_generator.tesla_act(power)

/obj/machinery/atmospherics/teslagen
	name = "experimental gas generator"
	desc = "Generates gasses from the electrical shock of a tesla."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "grounding_rod0"
	density = TRUE
	resistance_flags = ACID_PROOF|FIRE_PROOF
	interacts_with_air = TRUE
	var/static/list/possible_gases = list(
		"o2=22;TEMP=293.15"		= 2,
		"n2=82;TEMP=293.15"		= 3,
		"plasma=22;TEMP=293.15"	= 1
	)
//	var/spawn_temp = T20C
	/// Moles of gas to spawn per second
//	var/spawn_mol = MOLES_CELLSTANDARD * 5
//	var/max_ext_mol = INFINITY
//	var/max_ext_kpa = 6500
	var/overlay_color = "#FFFFFF"
	var/active = TRUE
	var/broken = FALSE
	var/broken_message = "ERROR"

/obj/machinery/atmospherics/teslagen/Initialize(mapload)
	. = ..()
	set_active(active)				//Force overlay update.

/obj/machinery/atmospherics/teslagen/examine(mob/user)
	. = ..()
	if(broken)
		. += {"Its debug output is printing "[broken_message]"."}

/obj/machinery/atmospherics/teslagen/proc/check_operation()
	if(!active)
		return FALSE
	var/turf/T = get_turf(src)
	if(!isopenturf(T))
		broken_message = "<span class='boldnotice'>VENT BLOCKED</span>"
		set_broken(TRUE)
		return FALSE
	var/turf/open/OT = T
	if(OT.planetary_atmos)
		broken_message = "<span class='boldwarning'>DEVICE NOT ENCLOSED IN A PRESSURIZED ENVIRONMENT</span>"
		set_broken(TRUE)
		return FALSE
	if(isspaceturf(T))
		broken_message = "<span class='boldnotice'>AIR VENTING TO SPACE</span>"
		set_broken(TRUE)
		return FALSE
	var/datum/gas_mixture/G = OT.return_air()
// TODO: readd something to do this sort of check
//	if(G.return_pressure() > (max_ext_kpa - ((spawn_mol*spawn_temp*R_IDEAL_GAS_EQUATION)/(CELL_VOLUME))))
//		broken_message = "<span class='boldwarning'>EXTERNAL PRESSURE OVER THRESHOLD</span>"
//		set_broken(TRUE)
//		return FALSE
//	if(G.total_moles() > max_ext_mol)
//		broken_message = "<span class='boldwarning'>EXTERNAL AIR CONCENTRATION OVER THRESHOLD</span>"
//		set_broken(TRUE)
//		return FALSE
	if(broken)
		set_broken(FALSE)
		broken_message = ""
	return TRUE

/obj/machinery/atmospherics/teslagen/tesla_act(var/power)
	if(!broken)
		obj_flags |= BEING_SHOCKED
		flick("grounding_rodhit", src)
		playsound(src.loc, 'sound/magic/lightningshock.ogg', 100, 1, extrarange = 5)
		release_gas(power)
	else
		return ..()

/obj/machinery/atmospherics/teslagen/proc/set_active(setting)
	if(active != setting)
		active = setting
		update_icon()

/obj/machinery/atmospherics/teslagen/proc/set_broken(setting)
	if(broken != setting)
		broken = setting
		update_icon()

/obj/machinery/atmospherics/teslagen/update_icon()
	cut_overlays()
	if(broken)
		add_overlay("broken")
	else if(active)
		var/mutable_appearance/on_overlay = mutable_appearance(icon, "on")
		on_overlay.color = overlay_color
		add_overlay(on_overlay)

/obj/machinery/atmospherics/teslagen/proc/release_gas(power)
	var/turf/open/O = get_turf(src)
	if(!isopenturf(O))
		return FALSE
	var/datum/gas_mixture/merger = new
	merger.parse_gas_string(pickweight(possible_gases));
	O.assume_air(merger)
	O.air_update_turf(TRUE)
	return TRUE

/obj/machinery/atmospherics/teslagen/attack_ai(mob/living/silicon/user)
	if(broken)
		to_chat(user, "[src] seems to be broken. Its debug interface outputs: [broken_message]")
	..()

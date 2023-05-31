/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/computer/stationalert
<<<<<<< HEAD

=======
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))
	light_color = LIGHT_COLOR_CYAN
	/// Station alert datum for showing alerts UI
	var/datum/station_alert/alert_control

/obj/machinery/computer/station_alert/Initialize(mapload)
<<<<<<< HEAD
	. = ..()
	GLOB.alert_consoles += src

/obj/machinery/computer/station_alert/Destroy()
	GLOB.alert_consoles -= src
=======
	alert_control = new(src, list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER), list(z), title = name)
	RegisterSignal(alert_control.listener, list(COMSIG_ALARM_TRIGGERED, COMSIG_ALARM_CLEARED), PROC_REF(update_alarm_display))
	return ..()

/obj/machinery/computer/station_alert/Destroy()
	QDEL_NULL(alert_control)
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))
	return ..()


/obj/machinery/computer/station_alert/ui_state(mob/user)
	return GLOB.default_state

<<<<<<< HEAD
/obj/machinery/computer/station_alert/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StationAlertConsole")
		ui.open()

/obj/machinery/computer/station_alert/ui_data(mob/user)
	var/list/data = list()

	data["alarms"] = list()
	for(var/class in GLOB.alarms)
		data["alarms"][class] = list()
		for(var/area in GLOB.alarms[class])
			data["alarms"][class] += area

	return data

/obj/machinery/computer/station_alert/proc/triggerAlarm(class, area/home, cameras, obj/source)
	if(source.get_virtual_z_level() != get_virtual_z_level())
		return
	if(machine_stat & (BROKEN))
		return
=======
/obj/machinery/computer/station_alert/ui_interact(mob/user)
	alert_control.ui_interact(user)

/obj/machinery/computer/station_alert/on_set_machine_stat(old_value)
	if(machine_stat & BROKEN)
		alert_control.listener.prevent_alarm_changes()
	else
		alert_control.listener.allow_alarm_changes()
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))

	var/list/our_sort = GLOB.alarms[class]
	for(var/areaname in our_sort)
		if (areaname == home.name)
			var/list/alarm = our_sort[areaname]
			var/list/sources = alarm[3]
			if (!(source in sources))
				sources += source
			ui_update()
			return TRUE

	var/obj/machinery/camera/cam = null
	var/list/our_cams = null
	if(cameras && islist(cameras))
		our_cams = cameras
		if (our_cams.len == 1)
			cam = our_cams[1]
	else if(cameras && istype(cameras, /obj/machinery/camera))
		cam = cameras
	our_sort[home.name] = list(home, (cam ? cam : cameras), list(source))
	ui_update()
	return TRUE

/obj/machinery/computer/station_alert/proc/freeCamera(area/home, obj/machinery/camera/cam)
	for(var/class in GLOB.alarms)
		var/our_area = GLOB.alarms[class][home.name]
		if(!our_area)
			continue
		var/cams = our_area[2] //Get the cameras
		if(!cams)
			continue
		if(islist(cams))
			cams -= cam
			if(length(cams) == 1)
				our_area[2] = cams[1]
		else
			our_area[2] = null
	ui_update()

/obj/machinery/computer/station_alert/proc/cancelAlarm(class, area/A, obj/origin)
	if(machine_stat & (BROKEN))
		return
	var/list/L = GLOB.alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	ui_update()
	return !cleared

/obj/machinery/computer/station_alert/update_icon()
	..()
	if(machine_stat & (NOPOWER|BROKEN))
		return
<<<<<<< HEAD
	var/active_alarms = FALSE
	for(var/cat in GLOB.alarms)
		var/list/L = GLOB.alarms[cat]
		if(L.len)
			active_alarms = TRUE
	if(active_alarms)
		add_overlay("alert:2")
=======
	if(length(alert_control.listener.alarms))
		. += "alert:2"

/**
 * Signal handler for calling an icon update in case an alarm is added or cleared
 *
 * Arguments:
 * * source The datum source of the signal
 */
/obj/machinery/computer/station_alert/proc/update_alarm_display(datum/source)
	SIGNAL_HANDLER
	update_icon()
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))

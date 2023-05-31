/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitor"
	ui_header = "alarm_green.gif"
	category = PROGRAM_CATEGORY_ENGI
	program_icon_state = "alert-green"
	extended_desc = "This program provides visual interface for station's alarm system."
	requires_ntnet = 1
	network_destination = "alarm monitoring network"
	size = 5
	tgui_id = "NtosStationAlertConsole"
	program_icon = "bell"
<<<<<<< HEAD
	var/has_alert = 0
=======
	/// If there is any station alert
	var/has_alert = FALSE
	/// Station alert datum for showing alerts UI
	var/datum/station_alert/alert_control

/datum/computer_file/program/alarm_monitor/New()
	//We want to send an alarm if we're in one of the mining home areas
	//Or if we're on station. Otherwise, die.
	var/list/allowed_areas = GLOB.the_station_areas + typesof(/area/mine)
	alert_control = new(computer, list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER), listener_areas = allowed_areas)
	RegisterSignal(alert_control.listener, list(COMSIG_ALARM_TRIGGERED, COMSIG_ALARM_CLEARED), PROC_REF(update_alarm_display))
	return ..()

/datum/computer_file/program/alarm_monitor/Destroy()
	QDEL_NULL(alert_control)
	return ..()
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))

/datum/computer_file/program/alarm_monitor/process_tick()
	..()

	if(has_alert)
		program_icon_state = "alert-red"
		ui_header = "alarm_red.gif"
		update_computer_icon()
	else
		if(!has_alert)
			program_icon_state = "alert-green"
			ui_header = "alarm_green.gif"
			update_computer_icon()
	return 1

/datum/computer_file/program/alarm_monitor/ui_data(mob/user)
<<<<<<< HEAD
	var/list/data = get_header_data()

	data["alarms"] = list()
	for(var/class in GLOB.alarms)
		data["alarms"][class] = list()
		for(var/area in GLOB.alarms[class])
			data["alarms"][class] += area

=======
	var/list/data = list()
	data += alert_control.ui_data(user)
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))
	return data

/datum/computer_file/program/alarm_monitor/proc/triggerAlarm(class, area/home, cameras, obj/source)
	if(is_station_level(source.z))
		if(!(home.type in GLOB.the_station_areas))
			return
	else if(!is_mining_level(source.z) || istype(home, /area/ruin))
		return

	var/list/our_sort = GLOB.alarms[class]
	for(var/areaname in our_sort)
		if (areaname == home.name)
			var/list/alarm = our_sort[areaname]
			var/list/sources = alarm[3]
			if (!(source in sources))
				sources += source
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

	update_alarm_display()
	return TRUE

/datum/computer_file/program/alarm_monitor/proc/freeCamera(area/home, obj/machinery/camera/cam)
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

/datum/computer_file/program/alarm_monitor/proc/cancelAlarm(class, area/A, obj/origin)
	var/list/L = GLOB.alarms[class]
	var/cleared = 0
	var/arealevelalarm = FALSE // set to TRUE for alarms that set/clear whole areas
	if (class=="Fire")
		arealevelalarm = TRUE
	for (var/I in L)
		if (I == A.name)
			if (!arealevelalarm) // the traditional behaviour
				var/list/alarm = L[I]
				var/list/srcs  = alarm[3]
				if (origin in srcs)
					srcs -= origin
				if (srcs.len == 0)
					cleared = 1
					L -= I
			else
				L -= I // wipe the instances entirely
				cleared = 1


	update_alarm_display()
	return !cleared

/datum/computer_file/program/alarm_monitor/proc/update_alarm_display()
	has_alert = FALSE
<<<<<<< HEAD
	for(var/cat in GLOB.alarms)
		var/list/L = GLOB.alarms[cat]
		if(L.len)
			has_alert = TRUE
=======
	if(length(alert_control.listener.alarms))
		has_alert = TRUE
>>>>>>> 9c6117fddd ([PORT] Silicon Station Alert TGUI and minor fixes! (#9117))

/datum/computer_file/program/alarm_monitor/on_start(mob/user)
	. = ..(user)
	if(!.)
		return
	GLOB.alarmdisplay += src

/datum/computer_file/program/alarm_monitor/kill_program(forced = FALSE)
	GLOB.alarmdisplay -= src
	..()

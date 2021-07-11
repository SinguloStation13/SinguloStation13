/mob/living/gib(no_brain, no_organs, no_bodyparts)
	var/prev_lying = lying_angle
	if(stat != DEAD)
		death(TRUE)

	if(!prev_lying)
		gib_animation()

	spill_organs(no_brain, no_organs, no_bodyparts)

	if(!no_bodyparts)
		spread_bodyparts(no_brain, no_organs)

	spawn_gibs(no_bodyparts)
	qdel(src)

/mob/living/proc/gib_animation()
	return

/mob/living/proc/spawn_gibs()
	new /obj/effect/gibspawner/generic(drop_location(), src, get_static_viruses())

/mob/living/proc/spill_organs()
	return

/mob/living/proc/spread_bodyparts()
	return

/mob/living/dust(just_ash, drop_items, force)
	// Singulo edit begin - Dust animation
	if(HAS_TRAIT(src, TRAIT_DUSTING))
		return
	Stun(100, ignore_canstun=TRUE)
	anchored = TRUE
	density = FALSE
	ADD_TRAIT(src, TRAIT_DUSTING, "living_dust")
	// Singulo end - Dust animation

	if(drop_items)
		unequip_everything()

	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)

	var/dust_time = dust_animation() // Singulo edit - Dust animation
	spawn_dust(just_ash)
	addtimer(CALLBACK(src, .proc/after_dust), dust_time) // Singulo edit - Dust animation

/mob/living/proc/dust_animation() //Singulo edit - Dust animation
	var/icon/I = new(icon)
	if(I.Width() > 32 || I.Height() > 32)
		return 5
	var/obj/effect/abstract/displacement/dust/D = new(loc, src)
	return D.duration

/mob/living/proc/spawn_dust(just_ash = FALSE)
	new /obj/effect/decal/cleanable/ash(loc)


/mob/living/death(gibbed)
	var/was_dead_before = stat == DEAD
	set_stat(DEAD)
	unset_machine()
	timeofdeath = world.time
	tod = station_time_timestamp()
	var/turf/T = get_turf(src)
	for(var/obj/item/I in contents)
		I.on_mob_death(src, gibbed)
	if(mind && mind.name && mind.active && !istype(T.loc, /area/ctf))
		deadchat_broadcast(" has died at <b>[get_area_name(T)]</b>.", "<b>[mind.name]</b>", follow_target = src, turf_target = T, message_type=DEADCHAT_DEATHRATTLE)
	if(mind)
		mind.store_memory("Time of death: [tod]", 0)
	remove_from_alive_mob_list()
	if(!gibbed && !was_dead_before)
		add_to_dead_mob_list()
	set_drugginess(0)
	set_disgust(0)
	SetSleeping(0, 0)
	reset_perspective(null)
	reload_fullscreen()
	update_action_buttons_icon()
	update_damage_hud()
	update_health_hud()
	med_hud_set_health()
	med_hud_set_status()
	stop_pulling()

	. = ..()

	if (client)
		client.move_delay = initial(client.move_delay)

	for(var/s in ownedSoullinks)
		var/datum/soullink/S = s
		S.ownerDies(gibbed)
	for(var/s in sharedSoullinks)
		var/datum/soullink/S = s
		S.sharerDies(gibbed)

	return TRUE

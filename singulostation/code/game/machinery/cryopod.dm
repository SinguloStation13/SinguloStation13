/*
 * Cryogenic refrigeration unit.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_storage ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

 //ORIGINAL FILE belonging to the WaspStation codebase. waspstation/code/game/machinery/cryopod.dm
 //Major alterations in cryopod.dm by SinguloStation13 prompting relocation

GLOBAL_LIST_EMPTY(cryopod_computers)

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface for the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole_1"
	circuit = /obj/item/circuitboard/computer/cryogenicpodcontrol
	density = FALSE
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_SET_MACHINE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mode = null

	//Used for logging people entering cryogenic freeze.
	var/list/frozen_crew = list()
	//All cryopods linked to the oversight console
	var/list/cryopods = list()

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/highlighted_item_inside = FALSE

	// These items will mark them with an exclamation mark as well as a yellow color tag in the computer
	var/static/list/highlighted_items = list(
		/obj/item/card/id/captains_spare,
		/obj/item/areaeditor/blueprints,
		/obj/item/card/id/departmental_budget,
		/obj/item/nullrod,
	)
	// For stuff that is a subtype of a highlighted_items item that is should not be highlighted.
	var/static/list/unhighlighted_items = list (

	)

/obj/item/circuitboard/computer/cryogenicpodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod

/obj/machinery/computer/cryopod/Initialize()
	. = ..()
	GLOB.cryopod_computers += src

/obj/machinery/computer/cryopod/Destroy()
	GLOB.cryopod_computers -= src
	for (var/obj/machinery/cryopod/X in cryopods)
		X.control_computer = null //Dereference the computer from all linked cryopods
	..()

/obj/machinery/computer/cryopod/process()

	if(machine_stat & (BROKEN)) //Eject everyone if the console gets borked
		for (var/mob/living/L in frozen_crew)
			eject_from_storage(L)

	if (frozen_crew.len != 0)
		flags_1 |= NODECONSTRUCT_1 //Don't deconstruct terminals with people in em
		resistance_flags |= INDESTRUCTIBLE //Don't destroy terminals with people in em. Supposed to be a safe place to SSD
	else
		flags_1 &= ~NODECONSTRUCT_1
		resistance_flags &= ~INDESTRUCTIBLE

	//Check if all inhabitants are still inside
	var/skip = FALSE //if person has been found then skip
	for (var/mob/living/L in frozen_crew)
		skip = FALSE
		for (var/mob/living/C in contents)
			if (C == L) //Person still inside
				skip = TRUE
		if (!skip)
			remove_from_record(L)

	//TODO: make this cleaner
	pixel_x = 0
	pixel_y = 0
	if(dir == NORTH)
		pixel_y = -32
	if(dir == SOUTH)
		pixel_y = 32
	if(dir == EAST)
		pixel_x = -32
	if(dir == WEST)
		pixel_x = 32

/obj/machinery/computer/cryopod/update_icon_state()
	icon = 'icons/obj/Cryogenic2.dmi'
	if(machine_stat & (NOPOWER|BROKEN))
		icon_state = "cellconsole"
		return
	if(highlighted_item_inside)
		icon = 'singulostation/icons/obj/Cryogenic2.dmi'
		icon_state = "cryogenic_console_highlight"
	else
		icon_state = "cellconsole_1"

/obj/machinery/computer/cryopod/proc/remove_from_record(mob/living/M)
	frozen_crew -= M
	check_highlighted_item_in_record()

/obj/machinery/computer/cryopod/proc/add_to_record(mob/living/M)
	frozen_crew += M
	has_highlighted_items(M, TRUE)

/obj/machinery/computer/cryopod/proc/check_highlighted_item_in_record()
	highlighted_item_inside = FALSE
	for(var/mob/living/L in frozen_crew)
		if(has_highlighted_items(L, FALSE))
			break
	update_icon_state()

/*public
 *
 *Checks and updates on the availability of linked cryopods.
 *Cryopods missing go off the list.
 */
/obj/machinery/computer/cryopod/proc/check_cryopods()
	for(var/X in cryopods)
		if(!X)
			cryopods -= X

/*public
 *
 *Compares all contents of the mob being moved to cryo against highlighted_items and unhighlighted_items.
 *If a highlighted item is within the mob, return TRUE, otherwise FALSE
 */
/obj/machinery/computer/cryopod/proc/has_highlighted_items(var/mob/living/O, var/announce = FALSE)
	var/mob/living/mob_occupant = O
	if (issilicon(mob_occupant))
		return FALSE //We let borgos cryo without checks since noone really plays them right now
	var/list/bad_items = list()
	var/plural_items = "item"
	var/skip = FALSE //If item is in unhighlighted_items
	for(var/obj/item/T in mob_occupant.GetAllContents())
		for(var/B in highlighted_items) //No nasty items in my cryo storage
			if(istype(T, B))
				for(var/W in unhighlighted_items) //Yes nasty items in my cryo storage
					if(istype(T, W))
						skip = TRUE //If it's in the unhighlighted_items then it may pass
						break //Item redeemed itself
				if(!skip) //If item is in highlighted_items but not in unhighlighted_items
					bad_items += T.name //Log all illegal items

	if(bad_items.len > 0)
		if(announce)
			if (bad_items.len > 1)
				plural_items = "items" //Please make this more pretty
			say("[O.real_name] cryo'ed with the following [plural_items]:")
			for (var/S in bad_items) //List all of the items on the naughty list
				say("Item: [S]")
		highlighted_item_inside = TRUE
		update_icon_state()
		return TRUE //Occupant has blacklisted items
	else
		return FALSE //Occupant is clean of blacklisted items

/*public
 *
 *Ejects the Mob specified in the parameter from the cryogenic console
 *First tries to find an available cryopod to insert the Mob into
 *If that fails, picks a random cryopod and awkwardly just teleports it onto it's turf
 *As a last resort, if no cryopods exist, eject onto the same turf as the cryopod console itself
 *Return is TRUE if successfully ejects, FALSE otherwise
 */
/obj/machinery/computer/cryopod/proc/eject_from_storage(mob/living/M)
	check_cryopods()
	for (var/mob/living/O in frozen_crew) //We do another check just in case
		if (O == M) //We got our boy
			for(var/obj/machinery/cryopod/C in cryopods)
				if (!(C.occupant)) //Get a cryopod that is not occupied
					C.close_machine(O, TRUE)
					remove_from_record(O)
					return TRUE

			//Doing the deed quick and dirty, force eject onto a random cryopod's turf
			if(cryopods.len!=0)
				var/obj/machinery/cryopod/CR = pick(cryopods)
				if (CR) //We got ANY cryopod
					O.forceMove(CR.loc)
					O.remove_status_effect(STATUS_EFFECT_CRYOPROTECTION) //Backup statuseffect removal
					remove_from_record(O)
					return TRUE
			// There are no cryopods linked to the console
			O.forceMove(src.loc)
			O.remove_status_effect(STATUS_EFFECT_CRYOPROTECTION) //Backup statuseffect removal
			remove_from_record(O)
			return TRUE
	return FALSE

/*public
 *
 *Ejects everyone from cryogenic storage
 */
/obj/machinery/computer/cryopod/proc/eject_all_from_storage()
	for (var/X in frozen_crew)
		eject_from_storage(X)

/obj/machinery/computer/cryopod/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryogenicStorage")
		ui.open()
	ui.update_static_data(user)

/obj/machinery/computer/cryopod/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("eject_occupant")
			var/ref = params["ref"]
			var/mob/living/L = (locate(ref) in GLOB.mob_list)
			if (L) //Mob exists
				for(var/mob/living/O in frozen_crew)
					if (O == L) //We got the person
						eject_from_storage(O)
						break
			. = TRUE
		if("eject_all")
			eject_all_from_storage()
			. = TRUE

/obj/machinery/computer/cryopod/ui_data(mob/user)
	var/list/data = list() // X amount of 4-index arrays in data array.
	for (var/mob/living/L in frozen_crew)
		var/list/data_set = list() // 4-index based array with name, rank, species and highlight
		data_set["name"] = L.real_name
		data_set["Oref"] = REF(L)
		data_set["rank"] = "Unassigned"
		for(var/datum/data/record/G in GLOB.data_core.general) // Get the rank the dude
			if((G.fields["name"] == L.real_name))
				data_set["rank"] = G.fields["rank"]
		var/mob/living/carbon/human/H = L
		if (ishuman(L))
			if (H.dna)
				data_set["species"] = H.dna.species.name
		else if (issilicon(L))
			data_set["species"] = "Silicon"
		else
			data_set["species"] = "Unknown"
		if(has_highlighted_items(L, FALSE))
			data_set["highlight"] = TRUE
		else
			data_set["highlight"] = FALSE
		data["occupants"] += list(data_set)
	return data

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "cryopod-open"
	circuit = /obj/item/circuitboard/machine/cryogenicpod
	density = TRUE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	state_open = TRUE
	var/active = TRUE //Used to distinguish bodies entering and exiting the cryopod

	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"

	// 5 minutes-ish safe period before being despawned.
	var/time_till_storage = 5 MINUTES // This is reduced to 30 seconds if a player manually enters cryo
	var/storage_world_time = null   // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0

/obj/item/circuitboard/machine/cryogenicpod
	name = "Cryogenic freezer (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/cryopod
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stack/sheet/glass = 2)

/obj/machinery/cryopod/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD //Gotta populate the cryopod computer GLOB first

/obj/machinery/cryopod/LateInitialize()
	update_icon()
	check_control_computer(TRUE)

/obj/machinery/cryopod/Destroy()
	if(check_control_computer(FALSE))
		control_computer.cryopods -= src
	. = ..()


/obj/machinery/cryopod/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The display on the side reads '<b>[time_till_storage/10]</b> seconds for cryogenic storage'</span>"

/obj/machinery/cryopod/RefreshParts() //If all 6 parts are upgraded to tier 4 the time_till_storage is reduced to 1 minute
	time_till_storage = 5 MINUTES
	for(var/obj/item/stock_parts/C in component_parts)
		time_till_storage -= 10 SECONDS * C.rating

//Searches for a control computer and links it.
//Checks whether the linked control computer is functional
//Returns TRUE is the
/obj/machinery/cryopod/proc/check_control_computer(var/announce = FALSE)
	if(control_computer) //we got a linked one
		if(machine_stat & (NOPOWER|BROKEN)) //It's unusable right now.
			if(announce)
				say("Warning: Linked cryogenic console at ([control_computer.x] : [control_computer.y]) is unavailable! Cryogenic freezer inoperable!")
			return FALSE //We do not spontaniously relink the cryopods to a new console because of a power outage.
		return TRUE
	for(var/M in GLOB.cryopod_computers)
		var/obj/machinery/computer/cryopod/C = M
		if(get_area(C) == get_area(src))
			if(!(machine_stat & (NOPOWER|BROKEN))) //This one is usable
				control_computer = C
				control_computer.cryopods += src
				return TRUE
	if(announce)
		say("Warning: Cannot find operable cryogenic console in this area! Cryogenic freezer inoperable!")
	control_computer = null
	return FALSE

/obj/machinery/cryopod/JoinPlayerHere(mob/M, buckle)
	var/mob/living/L = M
	if (ishuman(L))
		L.SetSleeping(5 SECONDS)
	M.forceMove(get_turf(src))
	if(icon_state == "cryopod-open") //Don't stack people inside cryopods
		close_machine(M, TRUE)

/obj/machinery/cryopod/latejoin/Initialize()
	. = ..()
	new /obj/effect/landmark/latejoin(src)

/obj/machinery/cryopod/latejoin/Destroy()
	SSjob.latejoin_trackers -= src
	. = ..()

/obj/machinery/cryopod/close_machine(mob/user, exiting = FALSE)
	active = !exiting //If we exit, don't immediately try to put us into cryo thanks.
	if(!check_control_computer(TRUE)) //Unusable control computer
		return
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		user.drop_all_held_items()
		..(user)
		if(exiting && istype(user, /mob/living))
			var/mob/living/L = user
			L.remove_status_effect(STATUS_EFFECT_CRYOPROTECTION)
			icon_state = "cryopod"
			say("Cryogenic revival of [user.real_name] successful. Have a pleasant and productive day!")
			return
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			say("Cryogenic storage in <b>[time_till_storage/10]</b> seconds.")
			storage_world_time = world.time + time_till_storage
			name = initial(name) + " ([mob_occupant.real_name])"
			to_chat(mob_occupant, "<span class='boldnotice'>You do not need to ghost!</span>")
			to_chat(mob_occupant, "<span class='notice'>Your character will be put into cryo storage in a short amount of time.\nTo get out of storage on your own, click the cryo status alert!</span>")
			to_chat(occupant, "<span class='notice'>You feel cool air surround you. You go numb as your senses turn inward.</span>")

	icon_state = "cryopod"

/obj/machinery/cryopod/open_machine()
	..()
	icon_state = "cryopod-open"
	density = TRUE
	name = initial(name)

/obj/machinery/cryopod/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist(user)

/obj/machinery/cryopod/process()

	if(!occupant)
		return

	if (!active) //Person is exiting cryostorage and shouldn't get cryo'ed
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		// Eject dead people
		if(mob_occupant.stat == DEAD)
			open_machine()

		if(!(world.time > storage_world_time))
			return

		if(mob_occupant.stat <= 2) //Occupant is living and has no client.

			if(!check_control_computer(TRUE))
				storage_world_time = world.time + 30 SECONDS
				return
			//is_clean(mob_occupant, FALSE)
			store_occupant()

//Puts the occupant into storage
/obj/machinery/cryopod/proc/store_occupant()
	var/mob/living/mob_occupant = occupant
	var/announce_rank = null

	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["name"] == mob_occupant.real_name))
			announce_rank = G.fields["rank"]

	//Make an announcement and log the person entering storage.
	if(check_control_computer(TRUE))
		control_computer.add_to_record(mob_occupant)
		mob_occupant.forceMove(control_computer)
	else
		return

	if(GLOB.announcement_systems.len)
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("CRYOSTORAGE", mob_occupant.real_name, announce_rank, list())
		visible_message("<span class='notice'>\The [src] hums and hisses as it moves [mob_occupant.real_name] into storage.</span>")

	mob_occupant.apply_status_effect(STATUS_EFFECT_CRYOPROTECTION)// Gives them godmode
	log_admin("<span class='notice'>[key_name(mob_occupant)] entered a stasis pod.</span>")
	message_admins("[key_name_admin(mob_occupant)] entered a stasis pod. (<A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	open_machine()

/obj/machinery/cryopod/attack_hand(mob/living/user)
	. = ..()
	open_machine() //Open the cryopod to get SSD people out of it

/obj/machinery/cryopod/attack_robot(mob/living/user)
	. = ..()
	open_machine() //Open the cryopod to get SSD people out of it

/obj/machinery/cryopod/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, W))
		return
	if(default_deconstruction_crowbar(W))
		return
	return ..()


/obj/machinery/cryopod/MouseDrop_T(mob/living/target, mob/user)
	if(!istype(target) || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || !ismob(target) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return

	if(occupant)
		to_chat(user, "<span class='boldnotice'>The cryo pod is already occupied!</span>")
		return

	if(target.stat == DEAD)
		to_chat(user, "<span class='notice'>Dead people can not be put into cryo.</span>")
		return

	if(target.client && user != target)
		if(iscyborg(target))
			to_chat(user, "<span class='danger'>You can't put [target] into [src]. They're online.</span>")
		else
			to_chat(user, "<span class='danger'>You can't put [target] into [src]. They're conscious.</span>")
		return

	else if(target.client)
		if(alert(target, "Would you like to enter cryogenic freeze?", "Cryopod", "Yes", "No") != "Yes")
			return

	if(!target || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return
		//rerun the checks in case of shenanigans

	if(target == user)
		visible_message("[user] starts climbing into the cryo pod.")
	else
		visible_message("[user] starts putting [target] into the cryo pod.")

	if(occupant)
		to_chat(user, "<span class='boldnotice'>\The [src] is in use.</span>")
		return
	close_machine(target)
	add_fingerprint(target)

//Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return //Sorta gamey, but we don't really want these to be destroyed.

/obj/item/multitool/advanced
	name = "advanced multitool"
	desc = "Used for pulsing wires to test which to cut. This one can be switched between 6 buffers for device linkage."
	icon = 'singulostation/icons/obj/tools.dmi'
	icon_state = "multitool_advanced" // Codersprite
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=30, /datum/material/gold=20, /datum/material/silver=20)
	material_flags = MATERIAL_NO_COLOR
	usesound = 'sound/weapons/empty.ogg'
	var/list/buffer_list[6] // list of buffers that can be switched between
	var/buffer_index = 1

/obj/item/multitool/advanced/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The memory dial is turned to [buffer_index]</span>"

/obj/item/multitool/advanced/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/multitool/advanced/attack_self(mob/user)
	buffer_list[buffer_index] = buffer
	var/list/choices = list()
	var/list/choice_index_lookup = list()
	for(var/i = 1, i<=buffer_list.len, i++)
		var/buffer_entry = buffer_list[i]
		var/entry_name = null
		var/entry_image = null

		if(istype(buffer_entry, /datum/dcm_net)) //Special case for deepcore mining network, since it stuffs a datum into the buffer
			var/datum/dcm_net/buffer_network = buffer_entry
			var/obj/machinery/machine = buffer_network.netHub
			entry_name = "Deepcore Mining Network ([length(buffer_network.connected)] machines)"
			entry_image = image(icon = machine.icon, icon_state = machine.icon_state)

		if(istype(buffer_entry, /obj/machinery)) //Default handling for machines
			var/obj/machinery/buffer_machine = buffer_entry
			entry_name = buffer_machine.name
			entry_image = image(icon = buffer_machine.icon, icon_state = buffer_machine.icon_state)

		if(entry_name == null)
			if(buffer_entry)
				entry_name = buffer_entry //Fallback for unhandled cases
			else
				entry_name = "Empty"      //And the behavior for null

		var/label = "[num2text(i)]: [entry_name]"
		choices[label] = entry_image
		choice_index_lookup[label] = i

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return
	
	var/selected_index = choice_index_lookup[choice]
	if(selected_index)
		buffer_index = selected_index
		buffer = buffer_list[selected_index]

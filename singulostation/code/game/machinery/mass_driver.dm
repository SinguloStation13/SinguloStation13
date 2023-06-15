/obj/machinery/mass_driver/default_change_direction_wrench(mob/user, obj/item/I)
	if(panel_open && I.tool_behaviour == TOOL_WRENCH)
		I.play_tool_sound(src, 50)
		setDir(turn(dir,-45))
		update_icon()
		to_chat(user, "<span class='notice'>You rotate [src].</span>")
		return 1
	return 0

/obj/machinery/mass_driver/update_icon()
	cut_overlays()

	var/mutable_appearance/overlay = mutable_appearance('singulostation/icons/obj/mass_driver.dmi', "mass_driver")
	overlay.transform = matrix().Turn(dir2angle(dir))
	overlays += overlay

	return ..()

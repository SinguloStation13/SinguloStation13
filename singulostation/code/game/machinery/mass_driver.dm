/obj/machinery/mass_driver/default_change_direction_wrench(mob/user, obj/item/I)
	if(panel_open && I.tool_behaviour == TOOL_WRENCH)
		I.play_tool_sound(src, 50)
		setDir(turn(dir,-45))
		update_icon()
		to_chat(user, "<span class='notice'>You rotate [src].</span>")
		return 1
	return 0

/obj/machinery/mass_driver/update_icon()
	driver_overlay.icon_state = panel_open?"mass_driver_o":"mass_driver"
	driver_overlay.transform = matrix().Turn(dir2angle(dir))

	return ..()

/obj/effect/overlay/driver_overlay
	icon = 'singulostation/icons/obj/mass_driver.dmi'
	icon_state = "mass_driver"
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PIXEL_SCALE

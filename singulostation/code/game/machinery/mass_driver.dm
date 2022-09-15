/obj/machinery/mass_driver/default_change_direction_wrench(mob/user, obj/item/I)
	if(panel_open && I.tool_behaviour == TOOL_WRENCH)
		I.play_tool_sound(src, 50)
		setDir(turn(dir,-45))
		transform = matrix().Turn(dir2angle(dir))
		to_chat(user, "<span class='notice'>You rotate [src].</span>")
		return 1
	return 0

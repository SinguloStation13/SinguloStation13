/obj/structure/mirror_frame
	name = "mirror frame"
	desc = "Add a sheet of glass first to see yourself in this mirror."
	icon = 'singulostation/icons/obj/mirror.dmi'
	icon_state = "mirror_frame"

/obj/structure/mirror_frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/stack = I
		if(stack.amount < 1)
			to_chat(user, "<span class='warning'>There aren't enough sheets in the stack!</span>")
			return
		to_chat(user, "<span class='notice'>You begin adding a glass pane to [src]...</span>")
		if(do_after(user, 20, target = src))
			if(!stack.use(1))
				to_chat(user, "<span class='warning'>There aren't enough sheets in the stack!</span>")
				return
			user.visible_message("<span class='notice'>[user.name] adds a glass pane to [src].</span>", \
							"<span class='notice'>You add a glass pane to [src].</span>", "<span class='hear'>You hear a click.</span>")
			playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
			var/obj/structure/mirror/mirror = new(loc)
			mirror.pixel_x = pixel_x
			mirror.pixel_y = pixel_y
			qdel(src)

/obj/structure/mirror_frame/wrench_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	. = TRUE
	to_chat(user, "<span class='notice'>You begin deconstructing [src]...</span>")
	I.play_tool_sound(src)
	if(I.use_tool(src, user, 20))
		user.visible_message("<span class='notice'>[user.name] deconstructs [src].</span>", \
							"<span class='notice'>You deconstruct [src].</span>", "<span class='hear'>You hear a ratchet.</span>")
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		new /obj/item/wallframe/mirror(drop_location())
		qdel(src)

/obj/structure/mirror/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	. = TRUE
	if(!deconstructable)
		to_chat(user, "<span class='warning'>You can't figure out how to deconstruct [src]!</span>")
		return
	to_chat(user, "<span class='notice'>You begin removing the glass from [src]...</span>")
	I.play_tool_sound(src)
	if(I.use_tool(src, user, 20))
		user.visible_message("<span class='notice'>[user.name] removes the [broken? "shattered ":""]glass pane.</span>", \
							"<span class='notice'>You remove the [broken? "shattered ":""]glass pane.</span>", "<span class='hear'>You hear a click.</span>")
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
		var/obj/structure/mirror_frame/frame = new(loc)
		frame.pixel_x = pixel_x
		frame.pixel_y = pixel_y
		if(broken)
			new /obj/item/shard(drop_location())
		else
			new /obj/item/stack/sheet/glass(drop_location())
		qdel(src)

/obj/item/wallframe/mirror
	name = "mirror frame"
	desc = "Has a mounting point on the back to be attached to walls."
	icon = 'singulostation/icons/obj/mirror.dmi'
	icon_state = "mirror_frame"
	custom_materials = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT)
	result_path = /obj/structure/mirror_frame
	pixel_shift = -28

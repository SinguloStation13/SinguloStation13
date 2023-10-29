/obj/item/electronics/airlock/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/electronics/airlock))
		var/obj/item/electronics/airlock/orig_electronics = I
		accesses = orig_electronics.accesses.Copy()
		one_access = orig_electronics.one_access
		unres_sides = orig_electronics.unres_sides
		to_chat(user, "<span class='notice'>You copy the access settings over to [orig_electronics]</span>")
	. = ..()

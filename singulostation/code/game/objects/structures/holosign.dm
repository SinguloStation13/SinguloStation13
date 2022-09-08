/obj/structure/holosign/barrier/atmos
	var/timerid
	var/duration = 90 MINUTES

/obj/structure/holosign/barrier/atmos/Destroy()
	. = ..()
	deltimer(timerid)

/obj/structure/holosign/barrier/atmos/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The holofan will decay in [timeleft(timerid)/600] minutes.</span>"

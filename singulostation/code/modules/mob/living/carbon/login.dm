/mob/living/carbon/Login()
	. = ..()

	if(IsSSDSleeping())
		SetSSDSleeping(0)

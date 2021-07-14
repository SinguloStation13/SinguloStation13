/mob/living/Logout()
	. = ..()

	if(!has_status_effect(STATUS_EFFECT_CRYOPROTECTION))
		PermaSSDSleeping()

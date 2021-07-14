///Allows us to set a permanent sleep on a player (use with caution and remember to unset it with SetSleeping() after the effect is over)
/mob/living/proc/PermaSleeping()
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, -1) & COMPONENT_NO_STUN)
		return
	if(status_flags & GODMODE)
		return
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		S.duration = -1
	else
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, -1, FALSE)
		START_PROCESSING(SSfastprocess, S) // Force the sleep to process, even though it has infinite duration and no tick interval
	return S
/////////////////////////////////// CRYO SLEEPING ////////////////////////////////////
// Puts you to sleep without the snoring/healing part of sleeping

/mob/living/proc/IsCryoSleeping() //If we're asleep in cryo
	return has_status_effect(STATUS_EFFECT_CRYOSLEEPING)

/mob/living/proc/SetCryoSleeping(amount) //Sets remaining duration
	SEND_SIGNAL(src, COMSIG_LIVING_STATUS_CRYOSLEEP, amount)
	var/datum/status_effect/incapacitating/cryosleeping/S = IsCryoSleeping()
	if(amount <= 0)
		if(S)
			qdel(S)
	else if(S)
		S.duration = world.time + amount
	else
		S = apply_status_effect(STATUS_EFFECT_CRYOSLEEPING, amount)
	return S

///Allows us to set a permanent cryo sleep on a player (use with caution and remember to unset it with SetCryoSleeping() after the effect is over)
/mob/living/proc/PermaCryoSleeping()
	SEND_SIGNAL(src, COMSIG_LIVING_STATUS_CRYOSLEEP, -1)
	var/datum/status_effect/incapacitating/cryosleeping/S = IsCryoSleeping()
	if(S)
		S.duration = -1
	else
		S = apply_status_effect(STATUS_EFFECT_CRYOSLEEPING, -1)
	return S

/////////////////////////////////// SSD SLEEPING ////////////////////////////////////
// Puts you to sleep with a status effect distinct from normal sleeping to avoid collision

/mob/living/proc/IsSSDSleeping() //If we're asleep SSD
	return has_status_effect(STATUS_EFFECT_SSD_SLEEPING)

/mob/living/proc/SetSSDSleeping(amount) //Sets remaining duration
	SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SSD_SLEEP, amount)
	var/datum/status_effect/incapacitating/sleeping/ssd/S = IsSSDSleeping()
	if(amount <= 0)
		if(S)
			qdel(S)
	else if(S)
		S.duration = world.time + amount
	else
		S = apply_status_effect(STATUS_EFFECT_SSD_SLEEPING, amount)
	return S

///Allows us to set a permanent SSD sleep on a player (use with caution and remember to unset it with SetSSDSleeping() after the effect is over)
/mob/living/proc/PermaSSDSleeping()
	SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SSD_SLEEP, -1)
	var/datum/status_effect/incapacitating/sleeping/ssd/S = IsSSDSleeping()
	if(S)
		S.duration = -1
	else
		S = apply_status_effect(STATUS_EFFECT_SSD_SLEEPING, -1)
	return S

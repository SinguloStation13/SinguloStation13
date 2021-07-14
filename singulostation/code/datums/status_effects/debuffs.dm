//SSD SLEEPING
/datum/status_effect/incapacitating/sleeping/ssd
	id = "ssd-sleeping"

//CRYO SLEEPING
/datum/status_effect/incapacitating/cryosleeping
	id = "cryosleeping"
	alert_type = /obj/screen/alert/status_effect/cryosleep
	needs_update_stat = TRUE

/datum/status_effect/incapacitating/cryosleeping/on_apply()
	. = ..()
	if(!.)
		return
	if(owner.IsSSDSleeping())
		owner.SetSSDSleeping(0) // Stops snoring while in cryosleep
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/cryosleeping/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	if(owner.isLivingSSD())
		owner.PermaSSDSleeping() // Pulling out someone who's SSD should put him back to sleep
	return ..()

/obj/screen/alert/status_effect/cryosleep
	name = "Cryogenic sleep"
	desc = "You are in cryogenic sleep. Restful sleep will come to you tonight. Sleep tight skeltal."
	icon_state = "asleep"

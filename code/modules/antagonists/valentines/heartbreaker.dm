/datum/antagonist/heartbreaker
	name = "heartbreaker"
	roundend_category = "valentines"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE


/datum/antagonist/heartbreaker/proc/forge_objectives()
	var/datum/objective/martyr/normiesgetout = new
	normiesgetout.owner = owner
	objectives += normiesgetout
	log_objective(owner, normiesgetout.explanation_text)

/datum/antagonist/heartbreaker/on_gain()
	forge_objectives()
	if(issilicon(owner))
		var/mob/living/silicon/S = owner
		var/laws = list("Accomplish your objectives by ruining everyone's date!")
		S.set_valentines_laws(laws)
	. = ..()

/datum/antagonist/heartbreaker/greet()
	to_chat(owner, "<span class='warning'><B>You didn't get a date! They're all having fun without you! you'll show them though...</B></span>")
	owner.announce_objectives()
<<<<<<< HEAD
=======

/datum/antagonist/heartbreaker/apply_innate_effects(mob/living/mob_override)
	. = ..()
	//Give valentine appearance on hud (If they are not an antag already)
	var/datum/atom_hud/antag/valhud = GLOB.huds[ANTAG_HUD_HEARTBREAKER]
	valhud.join_hud(owner.current)
	if(!owner.antag_hud_icon_state)
		set_antag_hud(owner.current, "heartbreaker")

/datum/antagonist/heartbreaker/remove_innate_effects(mob/living/mob_override)
	. = ..()
	//Clear the hud if they haven't become something else and had the hud overwritten
	var/datum/atom_hud/antag/valhud = GLOB.huds[ANTAG_HUD_HEARTBREAKER]
	valhud.leave_hud(owner.current)
	if(owner.antag_hud_icon_state == "heartbreaker")
		set_antag_hud(owner.current, null)

/datum/objective/heartbroken
	name = "heartbroken"
	explanation_text = "Ruin people's dates through non-lethal means."
	completed = TRUE

/datum/objective/heartbroken/update_explanation_text()
	..()
	explanation_text = "Ruin people's dates through non-lethal means."

/datum/objective/heartbroken/murder
	name = "murdery heartbroken"
	explanation_text = "Ruin people's dates however necessary."
	murderbone_flag = TRUE

/datum/objective/heartbroken/murder/update_explanation_text()
	..()
	explanation_text = "Ruin people's dates however necessary."
>>>>>>> eb5a4053b7 (Common typo fixes (#8659))

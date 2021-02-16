/mob/living/carbon/slip(knockdown_amount, obj/O, lube, paralyze, force_drop)
	if(movement_type & FLYING)
		return FALSE
	if((lube & NO_SLIP_ON_CATWALK) && (locate(/obj/structure/lattice/catwalk) in get_turf(src)))
		return FALSE
	if(!(lube & SLIDE_ICE))
		log_combat(src, (O ? O : get_turf(src)), "slipped on the", null, ((lube & SLIDE) ? "(LUBE)" : null))
	return loc.handle_slip(src, knockdown_amount, O, lube, paralyze, force_drop)

/mob/living/carbon/Process_Spacemove(movement_dir = FALSE)
	if(..())
		return TRUE
	if(!isturf(loc))
		return FALSE

	// Do we have a jetpack implant (and is it on)?
	if(has_jetpack_power(movement_dir))
		return TRUE

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(. && !(movement_type & FLOATING)) //floating is easy
		if(HAS_TRAIT(src, TRAIT_NOHUNGER))
			set_nutrition(NUTRITION_LEVEL_FED - 1)	//just less than feeling vigorous
		else if(nutrition && stat != DEAD)
			adjust_nutrition(-(HUNGER_FACTOR/10))
			if(m_intent == MOVE_INTENT_RUN)
				adjust_nutrition(-(HUNGER_FACTOR/10))
		if(mobility_flags & MOBILITY_STAND) //singulo start - Tripping
			var/trip_chance
			var/turf/T = get_turf(NewLoc)
			for(var/obj/item/I in T.contents)
				trip_chance += (I.w_class/4)-0.25
			if(prob(20*log(trip_chance+0.5)))
				Knockdown(3 SECONDS)
				to_chat(src, "<span class='warning'>You trip over all the items on the ground.</span>") //singulo end - Tripping

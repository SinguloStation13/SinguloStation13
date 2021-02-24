//Checks if the living mob having this item has Godmode
//Returns true if yes, no otherwise
/obj/proc/CheckGodmode()
	var/mob/living/wielder
	var/atom/parent = src.loc
	var/iterations
	for (iterations=0, iterations<10, iterations++) // 10 iterations meaning 10 nested parent checks (ID in PDA in Box in Backpack in Bag of Holding in /mob/living/)
		if (isliving(parent))
			break
		if (isturf(parent))
			return FALSE
		if (isarea(parent))
			return FALSE
		if (parent.loc) // Just in case
			parent = parent.loc
		else
			return FALSE

	if (isliving(parent))
		wielder = parent
		if (wielder.status_flags & GODMODE)
			return TRUE
	return FALSE

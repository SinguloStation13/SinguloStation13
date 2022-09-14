/datum/map_generator/cave_generator/asteroidmining
	open_turf_types = list(/turf/open/floor/plating/asteroid/airless = 1)
	closed_turf_types =  list(/turf/closed/mineral/random = 1)

	feature_spawn_chance = 1
	feature_spawn_list = list(/obj/structure/geyser/random = 1, /obj/effect/landmark/ore_vein = 2)
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 20, \
		/mob/living/simple_animal/hostile/asteroid/basilisk = 20, \
		/mob/living/simple_animal/hostile/asteroid/hivelord = 20, \
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 10)
	flora_spawn_list = list(/obj/structure/flora/rock = 6, /obj/structure/flora/rock/pile = 6, /obj/effect/decal/cleanable/blood = 1, /obj/effect/decal/cleanable/blood/splatter = 1, /obj/effect/decal/cleanable/blood/drip = 2)

	initial_closed_chance = 45
	smoothing_iterations = 20
	birth_limit = 4
	death_limit = 3

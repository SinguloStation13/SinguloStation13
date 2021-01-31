/area/asteroid/mining //Asteroid without any power jankies
	icon = 'singulostation/icons/turf/areas.dmi'
	icon_state = "asteroidmining"
	requires_power = TRUE
	always_unpowered = TRUE
	outdoors = TRUE
	area_flags = UNIQUE_AREA

/area/asteroid/mining/cavegen //Asteroid with cavegen
	icon = 'singulostation/icons/turf/areas.dmi'
	icon_state = "asteroidmininggen"
	area_flags = UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/asteroidmining

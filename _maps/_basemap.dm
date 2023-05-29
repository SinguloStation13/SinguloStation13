//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\debug\runtimestation.dmm"
<<<<<<< HEAD
		#include "map_files\ConstructionStation\ConstructionStation.dmm"
		#include "map_files\CryoStation\CryoStation.dmm"
=======
		#include "map_files\CorgStation\CorgStation.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\MetaStation\MetaStation.dmm"
		#include "map_files\BoxStation\BoxStation.dmm"
		#include "map_files\KiloStation\KiloStation.dmm"
		#include "map_files\flandstation\flandstation.dmm"
		#include "map_files\RadStation\RadStation.dmm"

>>>>>>> d59b5aec43 (The end of Pubbystation (and Glowstation aswell) (#9065))
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif

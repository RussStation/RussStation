//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\debug\runtimestation.dmm"
<<<<<<< HEAD
		#include "map_files\debug\multiz.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\KiloStation\KiloStation.dmm"
=======
		#include "map_files\Deltastation\DeltaStation2.dmm"
>>>>>>> readd _basemap.dm
		#include "map_files\MetaStation\MetaStation.dmm"
		#include "map_files\PubbyStation\PubbyStation.dmm"
		#include "map_files\BoxStation\BoxStation.dmm"
		#include "map_files\Donutstation\Donutstation.dmm"
<<<<<<< HEAD
=======
		#include "map_files\KiloStation\KiloStation.dmm"
		#include "map_files\LimaStation\Lima.dmm"
>>>>>>> readd _basemap.dm

		#ifdef TRAVISBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif

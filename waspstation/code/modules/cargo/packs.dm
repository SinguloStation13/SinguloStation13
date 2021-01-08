//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Deepcore /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials/deepcore_drill
	name = "Deep Core Mining Drill Crate"
	desc = "Contains three Deep Core Mining Drills to boost your productivity."
	cost = 3000
	contains = list(/obj/item/deepcorecapsule,
					/obj/item/deepcorecapsule,
					/obj/item/deepcorecapsule)
	crate_name = "deep core drill crate"

/datum/supply_pack/materials/deepcore_logi
	name = "Deep Core Mining Logistics Crate"
	desc = "Contains the logistics systems needed to run your Deep Core Mining Drills. Some assembly required."
	cost = 5000
	contains = list(/obj/machinery/deepcore/hopper,
					/obj/item/multitool,
					/obj/item/circuitboard/machine/deepcore/hub,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/scanning_module)
	crate_name = "deep core logi crate"

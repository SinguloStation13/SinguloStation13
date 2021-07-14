/datum/supply_pack/security/hardsuit
	name = "Security Hardsuit Crate"
	desc = "Contains a security hardsuit for catching criminals in space! Requires Security access to open."
	cost = 4500
	contains = list(/obj/item/clothing/suit/space/hardsuit/security)
	crate_name = "security hardsuit crate"

/datum/supply_pack/security/hardsuit3
	name = "Bulk Security Hardsuit Crate"
	desc = "Contains three security hardsuits for catching criminals in space! Requires Security access to open."
	cost = 11000
	contains = list(/obj/item/clothing/suit/space/hardsuit/security,
					/obj/item/clothing/suit/space/hardsuit/security,
					/obj/item/clothing/suit/space/hardsuit/security)
	crate_name = "bulk security hardsuit crate"

/datum/supply_pack/engineering/hardsuit
	name = "Engineering Hardsuit Crate"
	desc = "Who took all the damn hardsuits? Not a problem, for some money, we can hook you up with another hardsuit!"
	cost = 3500
	access = ACCESS_ENGINE
	contains = list(/obj/item/clothing/suit/space/hardsuit/engine)
	crate_name = "engineering hardsuit crate"

/datum/supply_pack/engineering/hardsuit3
	name = "Bulk Engineering Hardsuit Crate"
	desc = "All the engineers with hardsuits walk into the SM or die to space carp? Not a problem! For a small fee we can hook you up with more hardsuits!"
	cost = 10000
	access = ACCESS_ENGINE
	contains = list(/obj/item/clothing/suit/space/hardsuit/engine,
					/obj/item/clothing/suit/space/hardsuit/engine,
					/obj/item/clothing/suit/space/hardsuit/engine)
	crate_name = "bulk engineering hardsuit crate"

/datum/supply_pack/engineering/atmossuit
	name = "Atmospherics Hardsuit Crate"
	desc = "Atmospherics hardsuit suspiciously missing with multiple plasma fires throughout the station?, This hardsuit can help with that! They do cost a fair bit because of the materials required to insulate them. Requires engineering access to open."
	cost = 12000
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/clothing/suit/space/hardsuit/engine/atmos)
	crate_name = "atmospherics hardsuit crate"

/datum/supply_pack/engineering/jetpack
	name = "Jetpack Crate"
	desc = "For when you need to go fast in space."
	cost = 2000
	contains = list(/obj/item/tank/jetpack/carbondioxide)
	crate_name = "jetpack crate"

/datum/supply_pack/materials/plasma20
	name = "20 Plasma Sheets"
	desc = "You're supposed to be mining this, not buying it."
	cost = 6000
	contains = list(/obj/item/stack/sheet/mineral/plasma/twenty)
	crate_name = "plasma sheets crate"

/datum/supply_pack/materials/plasma50
	name = "50 Plasma Sheets"
	desc = "You're supposed to be mining this, not buying it."
	cost = 25000
	contains = list(/obj/item/stack/sheet/mineral/plasma/fifty)
	crate_name = "bulk plasma sheets crate"

/datum/supply_pack/materials/silver20
	name = "20 Silver Sheets"
	desc = "Somewhat less shiny."
	cost = 3000
	contains = list(/obj/item/stack/sheet/mineral/silver/twenty)
	crate_name = "silver sheets crate"

/datum/supply_pack/materials/silver50
	name = "50 Silver Sheets"
	desc = "Somewhat less shiny."
	cost = 7500
	contains = list(/obj/item/stack/sheet/mineral/silver/fifty)
	crate_name = "bulk silver sheets crate"

/datum/supply_pack/materials/gold20
	name = "20 Gold Sheets"
	desc = "Shiny."
	cost = 4000
	contains = list(/obj/item/stack/sheet/mineral/gold/twenty)
	crate_name = "gold sheets crate"

/datum/supply_pack/materials/gold50
	name = "50 Gold Sheets"
	desc = "Shiny."
	cost = 10000
	contains = list(/obj/item/stack/sheet/mineral/gold/fifty)
	crate_name = "bulk gold sheets crate"

/datum/supply_pack/materials/uranium20
	name = "20 Uranium Sheets"
	desc = "Green rock make thog puke red."
	cost = 4000
	contains = list(/obj/item/stack/sheet/mineral/uranium/twenty)
	crate_name = "uranium sheets crate"

/datum/supply_pack/materials/uranium50
	name = "50 Uranium Sheets"
	desc = "Green rock make thog puke red."
	cost = 10000
	contains = list(/obj/item/stack/sheet/mineral/uranium/fifty)
	crate_name = "bulk uranium sheets crate"

/datum/supply_pack/materials/titanium20
	name = "20 Titanium Sheets"
	desc = "Used for making big boy tanks and tools."
	cost = 4000
	contains = list(/obj/item/stack/sheet/mineral/titanium/twenty)
	crate_name = "titanium sheets crate"

/datum/supply_pack/materials/titanium50
	name = "50 Titanium Sheets"
	desc = "Used for making big boy tanks and tools."
	cost = 10000
	contains = list(/obj/item/stack/sheet/mineral/titanium/fifty)
	crate_name = "titanium sheets crate"

/datum/supply_pack/materials/diamond
	name = "A Diamond"
	desc = "Impress your girl with this one!"
	cost = 3500
	contains = list(/obj/item/stack/sheet/mineral/diamond)
	crate_name = "diamond sheet crate"

/datum/supply_pack/materials/diamond5
	name = "5 Diamonds"
	desc = "If you like nice technology, this can help as well!"
	cost = 17500
	contains = list(/obj/item/stack/sheet/mineral/diamond/five)
	crate_name = "bulk diamond sheets crate"

/datum/supply_pack/medical/hardsuit
	name = "Medical Hardsuit Crate"
	desc = "A medical hardsuit resistant to diseases and useful for retrieving patients in space! Requires medical access to open."
	cost = 4000
	access = ACCESS_MEDICAL
	contains = list(/obj/item/clothing/suit/space/hardsuit/medical)
	crate_name = "medical hardsuit crate"

/datum/supply_pack/science/hardsuit
	name = "Science Hardsuit Crate"
	desc = "A science hardsuit for added safety during explosives test or for scientific activies outside of the station! Requires science access to open."
	cost = 7500
	access = ACCESS_RESEARCH
	contains = list(/obj/item/clothing/suit/space/hardsuit/rd)
	crate_name = "science hardsuit crate"

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

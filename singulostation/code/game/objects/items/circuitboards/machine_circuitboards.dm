/obj/item/circuitboard/machine/autodoc
	name = "Autodoc (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/autodoc
	req_components = list(/obj/item/scalpel/advanced = 1,
		/obj/item/retractor/advanced = 1,
		/obj/item/surgicaldrill/advanced = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/thermomachine/teslagen
	name = "tesla gas generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/atmospherics/components/unary/teslagen
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

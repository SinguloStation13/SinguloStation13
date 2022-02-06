////////////////////// Deepcore ///////////////////////

//Singulostation begin - Technology tweaks
/datum/techweb_node/deepcore
	id = "deepcore"
	tech_tier = 2
	display_name = "Deepcore Mining"
	description = "Mining, but automated."
	prereq_ids = list("basic_mining", "adv_engi")
	design_ids = list("deepcore_drill", "deepcore_hopper", "deepcore_hub")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 2500
//Singulostation end

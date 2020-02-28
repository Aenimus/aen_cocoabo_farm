script "aen_legion.ash";

boolean legion_absent() {
	return get_property("aen_no_legion").to_boolean();
}

boolean legion_have(item llk) {
	if (legion_absent()) return false;
	if (llk.fetch()) return true;
	item_group ig_legion = ig_legion();
	foreach fold in ig_legion.items {
		if (ig_legion.items[fold].fetch()) {
			cli_execute("try; fold " + llk.to_string());
			break;
		}
	}
	if (!llk.have() && user_confirm("You do not appear to have a Loathing Legion Knife. Please confirm to stop future searches.")) {
		set_property("aen_no_llk", "true");
	}
	return llk.have();
}

boolean legion_equip(item llk) {
	if (llk.try_equip()) return true;
	if (llk.legion_have()) return llk.equip();
	return false;
}
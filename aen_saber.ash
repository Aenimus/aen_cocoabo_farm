script "aen_saber.ash";

import "aen_utils.ash";

boolean saber_have() {
	return saber.avail();
}

boolean saber_can_upgrade() {
	return saber_have() && !get_property("_saberMod").to_boolean();
}

boolean saber_upgrade(int upgrade) {
	if (!saber_can_upgrade()) return false;
	visit_url("main.php?action=may4");
	run_choice(upgrade);
	return get_property("_saberMod").to_boolean();
}

boolean saber_upgrade() {
	return saber_upgrade(4); // +fam weight
}
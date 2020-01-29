script "aen_comma.ash";

import "aen_utils.ash";

boolean comma_have() {
	return comma.have();
}

int comma_fights() {
	return get_property("aen_commaFights").to_int();
}

boolean comma_fights_check() {
	if (my_familiar() != comma) return false;
	int fights = comma_fights();
	return (fights > 38 || fights == 0);
}

boolean comma_change(string target) {
	if (my_familiar() != comma) return false;
	int fights = comma_fights();
	if (fights > 38) {
		string comma_fam = get_property("commaFamiliar");
		familiar target_fam = target.to_familiar();
		item eqp = target_fam.familiar_equipment();
		if (!eqp.have()) abort("You have run out of " + eqp + ".");
		print("Changing the Comma Chameleon into a " + target_fam + ".", "purple");
		visit_url("/inv_equip.php?pwd=" + my_hash() + "&which=2&action=equip&whichitem=" + eqp.to_int());
		set_property("aen_commaFights", 0);
		visit_url("charpane.php");
	}
	return get_property("commaFamiliar") == target;
}

boolean comma_refresh() {
	if (comma_fights_check()) {
		visit_url("charpane.php");
		return true;
	}
	return false;
}

boolean comma_run(string target) {
	string comma_fam = get_property("commaFamiliar");
	if (comma_fam != target) {
		familiar target_fam = target.to_familiar();
		item eqp = target_fam.familiar_equipment();
		if (!eqp.have()) abort("You have run out of " + eqp + ".");
		print("Changing the Comma Chameleon into a " + target_fam + ".", "purple");
		visit_url("/inv_equip.php?pwd=" + my_hash() + "&which=2&action=equip&whichitem=" + eqp.to_int());
		set_property("aen_commaFights", 0);
		comma_refresh();
	}
	return get_property("commaFamiliar") == target;
}

/*
if (my_familiar() == $familiar[Comma Chameleon]) {
	// Checking whether a self-incremented counter can cause us only to refresh at 40+
	if (get_property("aen_commaFights").to_int() > 39) visit_url("charpane.php");
	if (get_property("commaFamiliar").to_string() != "Feather Boa Constrictor") {
		if (!$item[velvet choker].have()) abort("You have run out of chokers.");
		print("Boa-fying the comma chameleon.");
		visit_url("/inv_equip.php?pwd="+my_hash()+"&which=2&action=equip&whichitem=962");
		visit_url("charpane.php");
		set_property("aen_commaFights", 0);
	}
}
*/
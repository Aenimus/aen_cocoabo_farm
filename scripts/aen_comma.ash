script "aen_comma.ash";

boolean comma_have() {
	return comma.have();
}

int comma_fights() {
	return get_property("aen_comma_fights").to_int();
}

string comma_familiar() {
	return get_property("commaFamiliar");
}

boolean comma_fights_check() {
	if (my_familiar() != comma) return false;
	int fights = comma_fights();
	return (fights > 38 || fights == 0);
}

void comma_fights_increment() {
	if (my_familiar() == comma) set_property("aen_comma_fights", comma_fights() + 1);
}

boolean comma_change(string target) {
	if (my_familiar() != comma) return false;
	int fights = comma_fights();
	string comma_fam = comma_familiar();
	if (target != comma_fam || fights > 38) {
		familiar target_fam = target.to_familiar();
		item eqp = target_fam.familiar_equipment();
		if (!eqp.have()) abort("You have run out of " + eqp.plural + ".");
		print("Changing the Comma Chameleon into a " + target_fam + ".", "purple");
		visit_url("/inv_equip.php?pwd=" + my_hash() + "&which=2&action=equip&whichitem=" + eqp.to_int());
		set_property("aen_comma_fights", 0);
		visit_url("charpane.php");
	}
	return comma_familiar() == target;
}

boolean comma_refresh() {
	if (comma_fights_check()) {
		visit_url("charpane.php");
		return true;
	}
	return false;
}

boolean comma_run(string target) {
	if (!comma_change(target)) abort("Something went wrong with changing the Comma Chameleon.");
	return comma_familiar() == target;
}
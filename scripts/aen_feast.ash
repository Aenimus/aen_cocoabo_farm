script "aen_feast.ash";

boolean feast_have() {
	return feast.fetch();
}

int feast_uses() {
	return get_property("_feastUsed").to_int();
}

boolean feast_use_can() {
	return feast_uses() < 5;
}

string feast_fams() {
	return get_property("_feastedFamiliars");
}

boolean feast_fam_check(familiar fam) {
	string str = fam.to_string();
	return contains_text(feast_fams(), str);
}

boolean feast_fam_can(familiar fam) {
	if (!fam.use()) return false;
	return !fam.feast_fam_check();
}

boolean feast_can(familiar fam) {
	return feast_have() && fam.feast_fam_can() && feast_use_can();
}

boolean feast_run(familiar fam) {
	if (!fam.feast_can()) return false;
	feast.use();
	return fam.feast_fam_check();
}
script "aen_snojo.ash";

boolean snojo_have() {
	return get_property("snojoAvailable").to_boolean();
}

int snojo_free_fights() {
	return get_property("_snojoFreeFights").to_int();
}

string snojo_setting() {
	return get_property("snojoSetting");
}

boolean snojo_free_fight_can() {
	return snojo_have() && snojo_free_fights() < 10;
}

boolean snojo_free_fight_run(boolean rest) {
	int fights = snojo_free_fights();
	if (snojo_setting() == "NONE") {
		print("Setting the control console from NONE to MOXIE.", "green");
		visit_url("place.php?whichplace=snojo&action=snojo_controller");
		run_choice(3);
	}
	print("Spending a free combat in the snojo.", "green");
	adv1($location[The X-32-F Combat Training Snowman], -1, "");
	if (rest && snojo_free_fights() > 9) visit_url("clan_viplounge.php?action=hottub"); //Because of the debuffs
	return fights < snojo_free_fights();
}

boolean snojo_free_fight_run() {
	return snojo_free_fight_run(false);
}
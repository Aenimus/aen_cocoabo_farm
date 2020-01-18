script "aen_snojo.ash";

import "aen_utils.ash";

boolean snojo_have() {
	return get_property("snojoAvailable").to_boolean();
}

int snojo_fights() {
	return get_property("_snojoFreeFights").to_int();
}

string snojo_setting() {
	return get_property("snojoSetting");
}

boolean snojo_free_can() {
	return snojo_have() && snojo_fights() < 10;
}

boolean snojo_free_run() {
	if (!snojo_free_can()) return false;
	int fights = snojo_fights();
	if (snojo_setting() == "NONE") {
		print("Setting the control console from NONE to MOXIE.", "green");
		visit_url("place.php?whichplace=snojo&action=snojo_controller");
		run_choice(3);
	}
	print("Spending a free combat in the snojo.", "green");
	adv1($location[The X-32-F Combat Training Snowman], -1, "");
	return fights + 1 == snojo_fights();
}

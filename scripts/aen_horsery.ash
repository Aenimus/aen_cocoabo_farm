script "aen_horsery.ash";

int [string] horsery_horses = {
	$string[normal]: 1,
	$string[dark]: 2,
	$string[crazy]: 3,
	$string[pale]: 4
};

boolean horsery_have() {
	return get_property("horseryAvailable").to_boolean();
}

string horsery_horse() {
	string horse = get_property("_horsery");
	if (horse == "") return "";
	return horse.substring(0, horse.length() - 6);
}

boolean horsery_run(string horse) {
	string horsery_horse = horsery_horse();
	if (!(horsery_horses contains horse)) abort("Invalid horse in horsery_run().");
	if (horse == horsery_horse) return true;
	print("Taking the " + horse + " horse with us.", "purple");
	visit_url("place.php?whichplace=town_right&action=town_horsery");
	visit_url("choice.php?pwd=&whichchoice=1266&option=" + horsery_horses[horse]);
	return horse == horsery_horse;
}
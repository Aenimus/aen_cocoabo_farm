script "aen_mushgarden";

boolean mushgarden_have() {
	return get_campground() contains $item[packet of mushroom spores];
}

int mushgarden_fights() {
	return get_property("_mushroomGardenFights").to_int();
}

boolean mushgarden_visit() {
	return get_property("_mushroomGardenVisited").to_boolean();
}

int mushgarden_growth() {
	return get_property("mushroomGardenCropLevel").to_int();
}

boolean mushgarden_growth_check(int target) {
	return mushgarden_growth() >= target;
}

boolean mushgarden_fight_can() {
	return mushgarden_have() && mushgarden_fights() < ((my_path() == "Path of the Plumber") ? 5 : 1);
}

boolean mushgarden_fight_run() {
	int fights = mushgarden_fights();
	print("Preparing to fight Mushroom Garden free fight #" + (fights + 1) + ".", "purple");
	adv1($location[Your Mushroom Garden], -1, "");
	return mushgarden_fights() > fights;
}

boolean mushgarden_visit_can() {
	return mushgarden_have() && !mushgarden_visit() && !mushgarden_fight_can();
}

void mushgarden_pick(int target) {
	if (mushgarden_visit_can()) {
		print("Assessing whether to fertilize or pick the current mushroom.", "purple");
		visit_url("adventure.php?snarfblat=543");
		run_choice((mushgarden_growth_check(target)) ? 2 : 1);
	}
}
script "aen_cartographer.ash";

boolean cartographer_have() {
	return $item[Comprehensive Cartographic Compendium (well-read)].have();
}

int cartographer_maps() {
	return get_property("_placeholder").to_int();
}

boolean cartographer_map_can() {
	return cartographer_have() && cartographer_maps() < 3;
}

boolean cartographer_map_run() {
    int fights = cartographer_maps();
    // Cannot Map the Monsters if you have already fought the piranha plant
	if (!mushgarden_fight_can()) abort("ABORT: aen_cartographer.ash does not handle maps outside of the mushroom garden.");
	print("Preparing to fight Map the Monsters fight #" + (fights + 1) + ".", "purple");
    $skill[Map the Monsters].use();
	adv1($location[Your Mushroom Garden], -1, "");
    run_choice(1);
    run_combat();
	return cartographer_fights() > fights;
}

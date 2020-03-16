script "aen_tentacle.ash";

boolean tentacle_skill_have() {
	return $skill[Evoke Eldritch Horror].have();
}

boolean tentacle_skill_can() {
	return !get_property("_eldritchHorrorEvoked").to_boolean();
}

boolean tentacle_skill_fight_can() {
	return tentacle_skill_have() && tentacle_skill_can();
}

boolean tentacle_skill_fight_run() {
	print("Casting Evoke Eldritch Horror to fight a free tentacle.", "purple");
	$skill[Evoke Eldritch Horror].use();
	if (my_hp() < 100) visit_url("clan_viplounge.php?action=hottub"); //Because the big eye ball beats us up
	return !tentacle_skill_can();
}

boolean tentacle_fight_can() {
	return !get_property("_eldritchTentacleFought").to_boolean();
}

boolean tentacle_fight_run() {
	print("Preparing to fight the free science tent tentacle.", "purple");
	visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
	run_choice($item[eldritch essence].have() ? 2 : 1);
	return !tentacle_fight_can();
}
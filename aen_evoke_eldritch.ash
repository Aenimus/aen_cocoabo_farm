script "aen_evoke_eldritch.ash";

boolean evoke_eldritch_have() {
	return $skill[Evoke Eldritch Horror].have();
}

boolean evoke_eldritch_fight_can() {
	return !get_property("_eldritchHorrorEvoked").to_boolean();
}

boolean evoke_eldritch_can() {
	return evoke_eldritch_have() && evoke_eldritch_fight_can();
}

boolean evoke_eldritch_run() {
	print("Casting Evoke Eldritch Horror to fight a free tentacle.", "purple");
	$skill[Evoke Eldritch Horror].use();
	if (my_hp() < 100) visit_url("clan_viplounge.php?action=hottub"); //Because the big eye ball beats us up
	return !evoke_eldritch_fight_can();
}
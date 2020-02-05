script "aen_pygmy.ash";

int pygmy_free_banishes() { 
	return get_property("_drunkPygmyBanishes").to_int();
}

boolean pygmy_free_banish_can(int target) {
	int banishes = pygmy_free_banishes();
	if (banishes >= target) return false;
	if (!juggle_scorpions(target - banishes)) abort("Could not acquire enough Bowls of Scorpions.");
	print("We have not yet met our banish threshold.", "purple");
	return true;
}

boolean pygmy_free_banish_run() {
	if (!bworps.have()) abort("Acquire a Bowl of Scorpions.");
	print("Fighting a drunk pygmy with a Bowl of Scorpions.", "purple");
	int banishes = pygmy_free_banishes();
	if (kramco.try_equip()) print("Wearing the Kramco grinder in a goblin friendly zone.", "purple");
	if (my_familiar() == $familiar[Comma Chameleon]) set_property("aen_commaFights", get_property("aen_commaFights").to_int() + 1);
	adv1($location[The Hidden Bowling Alley], -1, "");
	return banishes + 1 == pygmy_free_banishes();
}
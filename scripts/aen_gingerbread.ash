script "aen_gingerbread.ash";

boolean gingerbread_have() {
	return (get_property("gingerbreadCityAvailable").to_boolean() || get_property("_gingerbreadCityToday").to_boolean());
}

int gingerbread_turns() {
	return get_property("_gingerbreadCityTurns").to_int();
}

boolean gingerbread_turns(int turn) {
	return get_property("_gingerbreadCityTurns").to_int() == turn;
}

boolean gingerbread_reward() {
	return (get_property("_gingerbreadCityTurns").to_int() == 19 || get_property("_gingerbreadCityTurns").to_int() == 9);
}

boolean gingerbread_retail_can() {
	return get_property("gingerRetailUnlocked").to_boolean();
}

boolean gingerbread_extra_can() {
	return get_property("gingerExtraAdventures").to_boolean();
}

boolean gingerbread_turn_can() {
	if (gingerbread_extra_can()) return gingerbread_turns() < 30;
	else return gingerbread_turns() < 20;
}

boolean gingerbread_can() {
	return (gingerbread_have() && gingerbread_turn_can());
}

boolean gingerbread_free_turn_can() {
	if (!get_property("_aen_gingerbread_today").to_boolean()) return false;
	if (!get_property("gingerSewersUnlocked").to_boolean()) abort("Open the Gingercity sewers to banish pigeons and rats first.");
	if (!$item[gingerbread cigarette].have()) abort("Acquire more gingerbread cigarettes.");
	return (gingerbread_can());
}

boolean gingerbread_free_turn_run() {
	int turns = gingerbread_turns();
	if (gingerbread_turns(19) || !gingerbread_retail_can()) adv1($location[Gingerbread Civic Center], -1, "");
	else adv1($location[Gingerbread Upscale Retail District], -1, "");
	return turns + 1 == gingerbread_turns();
}

//@TODO non-free fights, if anyone would ever do that
	
script "aen_peeper.ash";

boolean peeper_have() {
	return peeper.fetch();
}

boolean peeper_free_used() {
	return get_property("_freePillKeeperUsed").to_boolean();
}

boolean peeper_free_can() {
	return !peeper_free_used();
}

boolean peeper_can(boolean cocoabo) {
	if (cocoabo && get_property("_aen_adv_today").to_int() > 4) return false;
	return peeper_have() && (peeper_free_can() || spleen_remaining() > 2);
}

boolean peeper_run(int option) {
	int spleen = my_spleen_use();
	boolean free = peeper_free_used();
	visit_url("main.php?eowkeeper=1", false);
	visit_url("choice.php?whichchoice=1395&option=" + option + "&pwd=" + my_hash(), true);
	if (spleen < my_spleen_use() || !free == peeper_free_used()) return true;
	return false;
}
		
boolean peeper_embezzler_run() {
	if (peeper_run(7)) {
		embezzler_prep();
		adv1($location[Cobb\'s Knob Treasury], 0, "");
		return last_monster() == embezzler;
	}
	abort("Something went wrong with the pill keeper.");
	return false;
}
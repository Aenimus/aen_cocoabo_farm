script "aen_saber.ash";

boolean saber_have() {
	return saber.fetch();
}

int saber_forces() {
	return get_property("_saberForceUses").to_int();
}

boolean saber_force_can() {
	return saber_forces() < 5;
}

boolean saber_upgrade_can() {
	return saber_have() && !get_property("_saberMod").to_boolean();
}

boolean saber_upgrade_run(int upgrade) {
	if (!saber_upgrade_can()) return false;
	visit_url("main.php?action=may4");
	run_choice(upgrade);
	return get_property("_saberMod").to_int() == upgrade;
}

boolean saber_upgrade_run() {
	return saber_upgrade_run(4); // +fam weight
}

boolean saber_pygmy_can() {
	return get_property("_aen_can_force_pygmy").to_boolean();
}

boolean saber_force_pygmy_should(int banishes, int forces) {
	if (!saber_force_can()) return false;
	return banishes == (10 + (forces * 2));
}

boolean saber_force_pygmy_run(int forces) {
	if (kramco.try_equip()) print("Wearing the Kramco grinder in a goblin friendly zone.", "purple");
	if (bworps.have()) juggle_scorpions(0);
	print("We are preparing to use the force on a drunk pygmy.", "purple");
	set_property("aen_use_force", "true"); // For combat script @TODO String for monstername
	adv1($location[The Hidden Bowling Alley], -1, ""); // Use the force
	return forces < saber_forces();
}

boolean saber_pygmy_run() {
	if (!saber_pygmy_can()) abort("Fewer than 5 starting forces is not currently supported.");
	int banishes = pygmy_free_banishes();
	int forces = saber_forces();
	if (saber_force_pygmy_should(banishes, forces)) return saber_force_pygmy_run(forces);
	if (banishes > 17 && forces == 5) juggle_scorpions(21 - banishes);
	else if ((banishes - (forces * 2)) == 9) juggle_scorpions(1);
	else juggle_scorpions(2);
	comma_fights_increment();
	print("We are fighting the forced drunk pygmies.", "purple");
	if (!bworps.have() & !bworps.fetch()) buy_until(1, bworps, 500);
	adv1($location[The Hidden Bowling Alley], -1, "");
	return banishes < pygmy_free_banishes();
}
script "aen_bricko.ash";

int bricko_fights() {
	return get_property("_brickoFights").to_int();
}

boolean bricko_fight_can(item it) {
	return bricko_fights() < 10 && it.fetch();
}

boolean bricko_fight_can(monster mob) {
	string str = mob.to_string();
	item it = str.to_item();
	return bricko_fights() < 10 && it.fetch();
}

boolean bricko_fight_can() {
	return bricko_fight_can($item[BRICKO ooze]);
}

boolean bricko_fight_run(item it) {
	string str = it.to_string();
	monster mob = str.to_monster();
	int fights = bricko_fights();
	print("Preparing to fight a " + str + " for free fight #" + (fights + 1) + ".", "purple");
	it.use();
	return bricko_fights() > fights;
}

boolean bricko_fight_run(monster mob) {
	string str = mob.to_string();
	item it = str.to_item();
	int fights = bricko_fights();
	print("Preparing to fight a " + str + " for free fight #" + (fights + 1) + ".", "purple");
	it.use();
	return bricko_fights() > fights;
}

boolean bricko_fight_run() {
	return bricko_fight_run($item[BRICKO ooze]);
}
script "aen_lynyrd.ash";

int lynyrd_fights() {
	return get_property("_lynyrdSnareUses").to_int();
}

boolean lynyrd_fight_can() {
	return lynyrd_fights() < 3 && $item[lynyrd snare].have();
}

boolean lynyrd_fight_run() {
	int fights = lynyrd_fights();
	print("Fighting lynyrd fight #" + (fights + 1) + ".", "purple");
	$item[lynyrd snare].use();
	return lynyrd_fights() > fights;
}
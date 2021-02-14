script "aen_witchess.ash";

boolean witchess_have() {
	return get_campground() contains $item[Witchess Set];
}

int witchess_fights() {
	return get_property("_witchessFights").to_int();
}

boolean witchess_check_piece(monster mob) {
	boolean [monster] pieces = $monsters[
		Witchess Pawn, Witchess Knight, Witchess Ox,
		Witchess Rook, Witchess Queen, Witchess King,
		Witchess Witch, Witchess Bishop
	];

	return pieces contains mob;
}

boolean witchess_fight_can() {
	return witchess_have() && witchess_fights() < 5;
}

boolean witchess_fight_run(monster piece) {
	if (!witchess_fight_can()) return false;
	if (!witchess_check_piece(piece)) abort("Cannot fight " + piece.to_string() + " using the Witchess Set.");
	int fights = witchess_fights();
	print("Fighting a " + piece.to_string() + " for Witchess free fight #" + (fights + 1) + ".", "purple");
	visit_url("campground.php?action=witchess");
	run_choice(1);
	visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=" + piece.id, false);
	run_combat(1);
	return witchess_fights() > fights;
}

boolean witchess_fight_run(int piece) {
	if (!witchess_fight_can()) return false;
	monster mob = piece.to_monster();
	if (!witchess_check_piece(mob)) abort("Cannot fight " + mob.to_string() + " using the Witchess Set.");
	int fights = witchess_fights();
	print("Fighting a " + mob.to_string() + " for Witchess free fight #" + (fights + 1) + ".", "purple");
	visit_url("campground.php?action=witchess");
	run_choice(1);
	visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=" + piece, false);
	run_combat(1);
	return witchess_fights() > fights;
}

boolean witchess_fight_run() {
	return witchess_fight_run(1942); // Bishop
}
	
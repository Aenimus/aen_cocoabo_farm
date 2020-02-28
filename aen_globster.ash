script "aen_globster.ash";

boolean globster_have() {
	return $familiar[God Lobster].have();
}

int globster_fights() {
	return get_property("_godLobsterFights").to_int();
}

boolean globster_can() {
	return globster_have() && globster_fights() < 3;
}

item [int] globster_equipment = {
	0: $item[None],
	1: $item[God Lobster\'s Scepter],
	2: $item[God Lobster\'s Ring],
	3: $item[God Lobster\'s Rod],
	4: $item[God Lobster\'s Robe],
	5: $item[God Lobster\'s Crown]
};

item globster_closest(item desired) {
	if (desired.available_amount() > 0) return desired;

	boolean [item] regalia = $items[
		God Lobster's Crown,God Lobster's Robe,God Lobster's Rod,
		God Lobster's Ring,God Lobster's Scepter
	];

	// Since they are quest items so you can't get rid of one;
	// if you don't have one, you also can't have any later down the line.
	foreach it in regalia {
		if (it.available_amount() > 0) return it;
	}

	return $item[none];
}

boolean globster_run(string eqp, int option) {
	int fights = globster_fights();
	item desired = ("God Lobster's " + eqp).to_item();

	if (desired == $item[none]) abort("God Lobster cannot be adorned with " + eqp + ".");
	$familiar[God Lobster].use();

	item regalis = desired.globster_closest();

	// If we can't equip what we wanted, work towards it.
	if (regalis != desired) option = 1;
	regalis.equip();

	visit_url("main.php?fightgodlobster=1");
	run_combat();
	visit_url("choice.php");
	run_choice(option);
	return fights < globster_fights();
}

boolean globster_run(int eqp, int option) {
	if (eqp < 0 || eqp > 5) abort("Equipment specification out of bounds.");
	if (eqp == 5 && option > 2) option = 2;
	int fights = globster_fights();
	$familiar[God Lobster].use();
	repeat {
		if (globster_equipment[eqp].try_equip()) break;
		eqp--;
		option = 1;
	} until (eqp == 0);
	visit_url("main.php?fightgodlobster=1");
	run_combat();
	visit_url("choice.php", false);
	run_choice(option);
	visit_url("main.php", false);
	return fights + 1 == globster_fights();
}

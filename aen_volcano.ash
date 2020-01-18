script "aen_volcano.ash";

import "aen_utils.ash";

boolean volcano_have() {
	return get_property("hotAirportAlways").to_boolean() || get_property("_hotAirportToday").to_boolean();
}

boolean volcano_can_tower() {
	return volcano_have() && !get_property("_infernoDiscoVisited").to_boolean();
}

boolean volcano_tower(int style) {
	if (!volcano_can_tower()) return false;
	if (style == 5 && my_inebriety() == 0) abort("No drunkenness to remove at the Towering Inferno.");
	cli_execute("checkpoint");
	int smooth;
	foreach it in $items[smooth velvet hat, smooth velvet shirt, smooth velvet pants] {
		if (it.fetch()) {
			it.equip();
			smooth++;
			if (smooth == (style - 1)) break;
		}
	}
	if (smooth < (style - 1)) {
		print("Accquiring additional style.", "purple");
		int i = 0;
		slot [3] sl = {0: acc1, 1: acc2, 2: acc3};
		foreach it in $items[smooth velvet hanky, smooth velvet socks, smooth velvet pocket square] {
			if (it.fetch()) {
				equip(sl[i], it);
				i++;
				smooth++;
				if (smooth == (style - 1)) break;
			}
		}
	}
	if (smooth == (style - 1)) {
		print("Using option " + style + " at the Inferno Disco Tower.", "purple");
		visit_url("place.php?whichplace=airport_hot&action=airport4_zone1");
		visit_url("choice.php?pwd=&whichchoice=1090&option=" + style);
	} else {
		print("Could not acquire enough Disco Style.", "red");
	}
	cli_execute("outfit checkpoint");
	return get_property("_infernoDiscoVisited").to_boolean();
}

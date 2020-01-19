script "aen_love.ash";

import "aen_utils.ash";

boolean lov_have() {
	return get_property("loveTunnelAvailable").to_boolean();
}

boolean lov_can() {
	return lov_have() && !get_property("_loveTunnelUsed").to_boolean();
}

int [item] lov_equipment = {
	$item[LOV Eardigan]: 1,
	$item[LOV Epaulettes]: 2,
	$item[LOV Earrings]: 3,
};

int [effect] lov_effects = {
	$effect[Lovebotamy]: 1,
	$effect[Open Heart Surgery]: 2,
	$effect[Wandering Eye Surgery]: 3,
};

int [item] lov_gifts = {
	enamorang: 1,
	$item[LOV Emotionizer]: 2,
	$item[LOV Extraterrestrial Chocolate]: 3,
	$item[LOV Echinacea Bouquet]: 4,
	$item[LOV Elephant]: 5,
	$item[toast]: 6,
};

void lov_round(int option) {
	run_choice(1);
	run_combat();
	visit_url("choice.php");
	run_choice(option);
}

boolean lov_run(int eqp, int eff, int gift) {
	familiar prev = my_familiar();
	if (eqp == 0) {
	print(eqp + " is equip before");
		switch (my_primestat()) {
			case	mus:	eqp = 1;	break;
			case	mys:	eqp = 2;	break;
			case	mox:	eqp = 3;	break;
			default: 		eqp = -1;
		}
	print(eqp + " is equip after");
	}
	if (eqp < 0 || eqp > 3) abort("First (equipment) argument out of bounds.");
	if (eff < 1 || eff > 3) abort("Second (buff) argument out of bounds.");
	if (gift < 1 || gift > 6) abort("Third (gift) argument out of bounds.");
	if (gift == 6 && !$familiar[Space Jellyfish].use()) abort("You need a Space Jellyfish to get toast.");
	visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel");
	run_choice(1);
	lov_round(eqp);
	lov_round(eff);
	lov_round(gift);
	if (gift == 6) prev.use();
	return get_property("_loveTunnelUsed").to_boolean();
}
	
boolean lov_run(item eqp, effect eff, item gift) {
	if (!(lov_equipment contains eqp)) abort("Can't get " + eqp.to_string() + " from the Tunnel of L.O.V.E.");
	if (!(lov_effects contains eff)) abort("Can't get " + eff.to_string() + " from the Tunnel of L.O.V.E.");
	if (!(lov_gifts contains gift)) abort("Can't get " + gift.to_string() + " from the Tunnel of L.O.V.E.");
	familiar prev = my_familiar();
	if (gift == $item[toast] && !$familiar[Space Jellyfish].use()) abort("You need a Space Jellyfish to get toast.");
	visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel");
	run_choice(1);
	lov_round(lov_equipment[eqp]);
	lov_round(lov_effects[eff]);
	lov_round(lov_gifts[gift]);
	if (gift == $item[toast]) prev.use();
	return get_property("_loveTunnelUsed").to_boolean();
}

boolean lov_run() {
	return lov_run($item[LOV Earrings], $effect[Open Heart Surgery], enamorang);
}

int lov_enamorangs_max = 5;

int lov_enamorangs() {
	// @TODO https://kolmafia.us/showthread.php?23563
	return 0;
}

string lov_enamorang_monster() {
	return get_property("enamorangMonster");
}

boolean lov_could_enamorang() {
	return (
		enamorang.have() &&
		lov_enamorang_monster() != "" &&
		lov_enamorangs() < lov_enamorangs_max
	);
}
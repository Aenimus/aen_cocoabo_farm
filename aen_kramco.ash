script "aen_kramco.ash";

import "aen_utils.ash";

boolean kramco_have() {
	return kramco.avail();
}

int kramco_made() {
	return get_property("_sausagesMade").to_int();
}

boolean kramco_can_grind_until(int amt) {
	return kramco_have() && kramco_made() < amt;
}

boolean kramco_grind_until(int amt) {
	if (!kramco_can_grind_until(amt)) return false;
		int made = kramco_made();
		int cases = $item[magical sausage casing].item_amount();
		int total;
		amt = amt - made;
		if (cases > amt) total = amt;
		else total = cases;
		cli_execute("make " + total + " magical sausage");
		return true;
}
script "aen_monster.ash";

boolean is_free(monster mob) {
  foreach i, attribute in mob.attributes.split_string(" ") {
    if (attribute == "FREE") return true;
  }
  return false;
}

int get_worth(monster mob) {
	int item_worth;
	foreach index, rec in mob.item_drops_array() {
		item_worth = item_worth + rec.drop.mall_price();
	}
	int low = mob.min_meat;
	int high = mob.max_meat;
	int base_meat = low + ((high - low) / 2);
	if (get_property("boomBoxSong") != "Total Eclipse of my Meat") base_meat = base_meat + 25;
	if ($effect[Covetous Robbery].have() && base_meat < 300) {
		if (base_meat == 0) base_meat = 100;
		else base_meat = base_meat + (75 - (floor(base_meat / 100) * 25));
	}
	int adv_worth = (cocoabo_farm()) ? (data_cocoabo_combat_worth() - 1000) : data_combat_worth();
	float meat_mod = ((meat_drop_modifier() / 100) + 1);
	int modded_meat = base_meat * meat_mod;
	int uncapped_meat = modded_meat + adv_worth;
	int capped_meat = 1000 + adv_worth;
	int grand_total;
	if (mob.is_free()) {
		if (modded_meat > 1000) grand_total = capped_meat;
		else grand_total = uncapped_meat;
	} else grand_total = modded_meat - adv_worth;
	grand_total = grand_total + item_worth;
	if (attunement.have()) grand_total = grand_total + (capped_meat + 400);
	return grand_total;
}

int get_worth(string str) {
	monster mob = str.to_monster();
	int item_worth;
	foreach index, rec in mob.item_drops_array() {
		item_worth = item_worth + rec.drop.mall_price();
	}
	int low = mob.min_meat;
	int high = mob.max_meat;
	int base_meat = low + ((high - low) / 2);
	if (get_property("boomBoxSong") != "Total Eclipse of my Meat") base_meat = base_meat + 25;
	if ($effect[Covetous Robbery].have() && base_meat < 300) {
		if (base_meat == 0) base_meat = 100;
		else base_meat = base_meat + (75 - (floor(base_meat / 100) * 25));
	}
	int adv_worth = (cocoabo_farm()) ? (data_cocoabo_combat_worth() - 1000) : data_combat_worth();
	float meat_mod = ((meat_drop_modifier() / 100) + 1);
	int modded_meat = base_meat * meat_mod;
	int uncapped_meat = modded_meat + adv_worth;
	int capped_meat = 1000 + adv_worth;
	int grand_total;
	if (mob.is_free()) {
		if (modded_meat > 1000) grand_total = capped_meat;
		else grand_total = uncapped_meat;
	} else grand_total = modded_meat - adv_worth;
	grand_total = grand_total + item_worth;
	if (attunement.have()) grand_total = grand_total + (capped_meat + 400);
	return grand_total;
}
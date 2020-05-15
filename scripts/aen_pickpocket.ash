script "aen_pickpocket.ash";

record monster_worth {
	string mob;
	int worth;
};

boolean pickpocket_have() {
	return (my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief]) || $effect[Riboflavin\'].have();
}

string pickpocket_location_today_get() {
	return get_property("_aen_pickpocket_location_today");
}

location pickpocket_location_today() {
	return pickpocket_location_today_get().to_location();
}

void pickpocket_location_today_set(string loc) {
	set_property("_aen_pickpocket_location_today", loc);
}

void pickpocket_location_today_set(location loc) {
	string str = loc.to_string();
	set_property("_aen_pickpocket_location_today", loc);
}

string pickpocket_target_today_get() {
	return get_property("_aen_pickpocket_target_today");
}

monster pickpocket_target_today() {
	return pickpocket_target_today_get().to_monster();
}

void pickpocket_target_today_set(string mob) {
	set_property("_aen_pickpocket_target_today", mob);
}

string pickpocket_item_today_get() {
	return get_property("_aen_pickpocket_item_today");
}

void pickpocket_item_today_set(item it) {
	set_property("_aen_pickpocket_item_today", it.to_string());
}

string pickpocket_banishes_today() {
	return get_property("_aen_pickpocket_banishes_today");
}

void pickpocket_banishes_today_set(string mob) {
	if (pickpocket_banishes_today() == "") set_property("_aen_pickpocket_banishes_today", mob);
	else set_property("_aen_pickpocket_banishes_today", pickpocket_banishes_today() + ", " + mob);
}

void pickpocket_banishes_today_reset() {
	set_property("_aen_pickpocket_banishes_today", "");
}

void pickpocket_today_prep() {
	pickpocket_banishes_today_reset();
	int worth;
	int check;
	int best = 0;
	item pp_item;
	monster [int] loc_mobs = pickpocket_location_today().get_monsters(); //pickpocket_location().get_monsters();
	monster_worth [int] pp_mobs;
	foreach index, mob in loc_mobs {
		if (mob.is_ur()) continue;
		monster_worth mw;
		worth = 0;
		check = 0;
		foreach index, rec in mob.item_drops_array() {
			item it = rec.drop;
			check = it.mall_price();
			if (it == $item[blue-frosted astral cupcake]) check = check + 10000;
			if (check > worth) worth = check;
			if (worth > best) {
				best = worth;
				pp_item = it;
			}
		}
		mw.mob = mob.to_string();
		mw.worth = worth;
		pp_mobs[index] = mw;
		pp_item.pickpocket_item_today_set();
	}
	sort pp_mobs by value.worth;
	int target = count(pp_mobs) - 1;
	foreach index, rec in pp_mobs {
		print(rec.mob + ": " + rec.worth, "purple");
		if (index == target) pickpocket_target_today_set(rec.mob);
		else pickpocket_banishes_today_set(rec.mob);
	}
	if ($effect[On the Trail].have() && get_property("olfactedMonster") != pickpocket_target_today_get()) cli_execute("uneffect On the Trail");
	print("Today\'s pickpocket item is the " + pickpocket_item_today_get() + " from the " + pickpocket_target_today_get() + "!", "green");
}

boolean pickpocket_today_run(location loc ) {
	if (!pickpocket_have()) return false;
	pickpocket_location_today_set(loc);
	pickpocket_today_prep();
	return pickpocket_target_today_get() != "";
}

boolean pickpocket_banish_can(monster mob) {
	foreach index, str in pickpocket_banishes_today().split_string(", ") {
		monster banish = str.to_monster();
		if (mob == banish) return true;
	}
	return false;
}

boolean pickpocket_banish_can(string mob) {
	foreach index, banish in pickpocket_banishes_today().split_string(", ") {
		if (mob == banish) return true;
	}
	return false;
}
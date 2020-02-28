script "aen_nep.ash";

boolean nep_have() {
	return get_property("neverendingPartyAlways").to_boolean() || get_property("_neverendingPartyToday").to_boolean();
}

int nep_free_turns() {
	return get_property("_neverendingPartyFreeTurns").to_int();
}

boolean nep_free_turn_can() {
	return nep_have() && nep_free_turns() < 10;
}

boolean nep_free_turn_run() {
	int turns = nep_free_turns();
	print("Spending a free turn in the Neverending Party.", "purple");
	if (kramco.try_equip()) print("Wearing the Kramco grinder in a goblin friendly zone.", "purple");
	adv1($location[The Neverending Party], -1, "");
	return turns < nep_free_turns();
}

/*
string nep_status() {
	return get_property("_questPartyFair");
}

string nep_progress() {
	return get_property("_questPartyFairProgress");
}

string nep_quest(boolean peep) {
	if (!nep_have()) return "";
	string quest = get_property("_questPartyFairQuest");
	if (quest != "") return quest;
	if (peep && nep_status() == "unstarted") {
		// Peep the party to find the quest
		nep.to_url().visit_url();
		run_choice(3);
		return nep_quest(false);
	}
	return "";
}

string nep_quest() {
	return nep_quest(true);
}

boolean nep_collection() {
	return $string[booze, food] contains nep_quest();
}

int [item] nep_items() {
	int [item] its;
	string progress = nep_progress();
	if (!nep_collection() || progress == "") return { $item[none]: 0 };
	string [int] parts = progress.split_string(" ");
	its[parts[0].to_int()] = parts[1].to_item();
	return its;
}

item nep_item() {
	int [item] its = nep_items();
	foreach it in its return it;
}

item nep_container() {
	switch (nep_quest()) {
		case "food": return $item[van key];
		case "booze": return $item[unremarkable duffel bag];
		default: return $item[none];
	}
}

int [int] nep_choices() {
	string quest = nep_quest();
	switch (quest) {
		case "booze": return {
			1322: 2, // Accept the quest
			1324: 3, // Go to the back yard
			1327: 4, // Gerald
		};
		case "food": return {
			1322: 2, // Accept the quest
			1324: 2, // Go to the kitchen
			1327: 3, // Geraldine
		};
		default:
			int [int] choices;
			return choices;
	}
}

int nep_profit() {
	item it = nep_item();
	if (it == $item[none]) return 0;
	return (it.mall_price() * 3) - nep_container().mall_price();
}*/

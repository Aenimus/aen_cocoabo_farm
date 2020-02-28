script "aen_bastille.ash";

import "aen_utils.ash";

boolean bastille_have() {
	return $item[Bastille Battalion control rig].fetch();
}

int bastille_games() {
	return get_property("_bastilleGames").to_int();
}

boolean bastille_can(boolean rewards) {
	int target;
	if (rewards) target = 1;
	else target = 5;
	return bastille_have() && bastille_games() < target;
}

boolean bastille_can() {
	return bastille_can(true);
}

item bastille_potion_select() {
	item [int] bastille_potions;
	bastille_potions[0] = $item[sharkfin gumbo];
	bastille_potions[1] = $item[boiling broth];
	bastille_potions[2] = $item[interrogative elixir];
	sort bastille_potions by value.item_amount();
	return bastille_potions[0];
}
	

int bastille_stat(stat subs) {
	if (subs == $stat[none]) subs = my_primestat();
	switch(subs) {
		case $stat[Muscle]: return 2;
		case $stat[Mysticality]: return 1;
		case $stat[Moxie]: return 3;
		default: return 0;
	}
}

int bastille_item(item it) {
	switch(it) {
		case $item[Brutal brogues]: return 1;
		case $item[Draftsman's driving gloves]: return 2;
		case $item[Nouveau nosering]: return 3;
		case $item[none]: return my_primestat().to_int() + 1;
		default: return 0;
	}
}

int bastille_buff(effect buff) {
	switch(buff) {
		case $effect[Bastille Budgeteer]: return 1;
		case $effect[Bastille Bourgeoisie]: return 2;
		case $effect[Bastille Braggadocio]: return 3;
		case $effect[none]: return my_primestat().to_int() + 1;
		default: return 0;
	}
}

int bastille_potion(item potion) {
	if (potion == $item[none]) potion = bastille_potion_select();
	switch (potion) {
		case $item[sharkfin gumbo]: return 1;
		case $item[boiling broth]: return 2;
		case $item[interrogative elixir]: return 3;
		default: return 0;
	}
}

void bastille_set(string pattern, int aim, int option, string page) {
	matcher first = create_matcher("/bbatt/" + pattern + "(\\d).png", page);
	if(first.find()) {
		int setting = first.group(1).to_int();
		while(setting != aim) {
			string temp = visit_url("choice.php?whichchoice=1313&option=" + option.to_string() + "&pwd=" + my_hash(), false);
			setting++;
			if(setting > 3) setting = 1;
		}
	}
}

boolean bastille_run(stat subs, item it, effect buff, item potion) {
	int games = bastille_games();
	int s = bastille_stat(subs);
	int e = bastille_item(it);
	int b = bastille_buff(buff);
	int p = bastille_potion(potion);

	if (s == 0 || e == 0 || b == 0 || p == 0) return false;

	string page = visit_url("inv_use.php?&whichitem=9928&which=3&pwd=" + my_hash(), false);

	bastille_set("barb", s, 1, page);
	bastille_set("bridge", e, 2, page);
	bastille_set("holes", b, 3, page);
	bastille_set("moat", p, 4, page);

	string temp = visit_url("choice.php?whichchoice=1313&option=5&pwd=" + my_hash(), false);

	for(int i=0; i<5; i++){
		visit_url("choice.php?whichchoice=1314&option=3&pwd=" + my_hash());
		visit_url("choice.php?whichchoice=1319&option=3&pwd=" + my_hash());
		visit_url("choice.php?whichchoice=1314&option=3&pwd=" + my_hash());
		visit_url("choice.php?whichchoice=1319&option=3&pwd=" + my_hash());
		visit_url("choice.php?whichchoice=1315&option=3&pwd=" + my_hash());
		if(last_choice() == 1316) break;
	}

	visit_url("choice.php?whichchoice=1316&option=3&pwd=" + my_hash());
	return games < bastille_games();
}

boolean bastille_run(stat subs, item it, effect buff) {
	return bastille_run(subs, it, buff, $item[none]);
}

boolean bastille_run(item it, effect buff) {
	return bastille_run($stat[none], it, buff, $item[none]);
}

boolean bastille_run(item it) {
	return bastille_run($stat[none], it, $effect[none], $item[none]);
}

boolean bastille_run(effect buff) {
	return bastille_run($stat[none], $item[none], buff, $item[none]);
}

boolean bastille_run() {
	return bastille_run($stat[none], $item[none], $effect[none], $item[none]);
}
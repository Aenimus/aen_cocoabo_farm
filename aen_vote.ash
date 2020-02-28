script "aen_vote.ash";

boolean vote_have() {
	return get_property("voteAlways").to_boolean() || get_property("_voteToday").to_boolean();
}

boolean vote_can() {
	return vote_have() && !vote_sticker.have();
}

int [int] vote_choose(int [string] options, string [int] prefs, int qty) {
	foreach rank, option in prefs {
		if (!(options contains option)) {
			remove prefs[rank];
		}
	}

	int [int] chosen;
	int i = 0;
	foreach rank, option in prefs {
		chosen[i] = options[option];
		i++;
		if (count(chosen) >= qty) break;
	}
	return chosen;
}

string [int] vote_monster_prefs() {
	string [int] vote_monster_prefs;
	vote_monster_prefs[0] = "slime blob";
	vote_monster_prefs[1] = "angry ghost";
	vote_monster_prefs[2] = "terrible mutant";
	vote_monster_prefs[3] = "government bureaucrat";
	vote_monster_prefs[4] = "annoyed snake";
	return vote_monster_prefs;
}

int vote_monster_select() {
	string [int] vote_monster_prefs = vote_monster_prefs();
	foreach vote_monster in vote_monster_prefs() {
		if (get_property("_voteMonster1") == vote_monster_prefs[vote_monster]) return 1;
		else if (get_property("_voteMonster2") == vote_monster_prefs[vote_monster]) return 2;
	}
	return -1;
}

string [int] vote_initiative_prefs() {
	string [int] vote_initiative_prefs;
	vote_initiative_prefs[0] = "Maximum MP Percent: +30";
	vote_initiative_prefs[1] = "Meat Drop Percent: +30";
	vote_initiative_prefs[2] = "Mysticality Percent: +25";
	vote_initiative_prefs[3] = "Monster Level: +10";
	vote_initiative_prefs[4] = "Muscle Percent: +25";
	vote_initiative_prefs[5] = "Adventures: +1";
	vote_initiative_prefs[6] = "Experience (Mysticality): +4";
	vote_initiative_prefs[7] = "Experience (Muscle): +4";
	vote_initiative_prefs[8] = "Experience (Moxie): +4";
	vote_initiative_prefs[9] = "Experience: +3";
	vote_initiative_prefs[10] = "Item Drop Percent: +20";
	vote_initiative_prefs[11] = "Moxie Percent: +25";
	vote_initiative_prefs[12] = "Initiative: +30";
	vote_initiative_prefs[13] = "Experience (familiar): +2";
	vote_initiative_prefs[14] = "Food Drop: +30";
	vote_initiative_prefs[15] = "Booze Drop: +30";
	vote_initiative_prefs[16] = "Pants Drop: +30";
	vote_initiative_prefs[17] = "Candy Drop: +30";
	vote_initiative_prefs[18] = "Damage: +10";
	
	//@TODO others
	return vote_initiative_prefs;
}

int [int] vote_choose_initiatives() {
	int [string] vote_initiatives = {
		get_property("_voteLocal1"): 0,
		get_property("_voteLocal2"): 1,
		get_property("_voteLocal3"): 2,
		get_property("_voteLocal4"): 3,
	};

	return vote_choose(vote_initiatives, vote_initiative_prefs(), 2);
}

boolean vote_run() {
	string vote_booth = visit_url("place.php?whichplace=town_right&action=townright_vote");
	int vote_monster = vote_monster_select();
	int [int] vote_locals = vote_choose_initiatives();
	visit_url("choice.php?option=1&whichchoice=1331&g=" + vote_monster + "&local[]=" + vote_locals[0] + "&local[]=" + vote_locals[1]);
	return vote_sticker.have();
}
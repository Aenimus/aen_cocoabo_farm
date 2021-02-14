script "aen_vote.ash";

boolean vote_have() {
	return get_property("voteAlways").to_boolean() || get_property("_voteToday").to_boolean();
}

boolean vote_can() {
	return vote_have() && !vote_sticker.fetch();
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
	vote_initiative_prefs[5] = "Maximum HP Percent: +30";
	vote_initiative_prefs[6] = "Adventures: +1";
	vote_initiative_prefs[7] = "Experience (Mysticality): +4";
	vote_initiative_prefs[8] = "Experience (Muscle): +4";
	vote_initiative_prefs[9] = "Experience (Moxie): +4";
	vote_initiative_prefs[10] = "Experience: +3";
	vote_initiative_prefs[11] = "Item Drop Percent: +20";
	vote_initiative_prefs[12] = "Moxie Percent: +25";
	vote_initiative_prefs[13] = "Initiative: +25";
	vote_initiative_prefs[14] = "Experience (familiar): +2";
	vote_initiative_prefs[15] = "Food Drop: +30";
	vote_initiative_prefs[16] = "Booze Drop: +30";
	vote_initiative_prefs[17] = "Pants Drop: +30";
	vote_initiative_prefs[18] = "Candy Drop: +30";
	vote_initiative_prefs[19] = "Cold Resistance: +3";
	vote_initiative_prefs[20] = "Hot Resistance: +3";
	vote_initiative_prefs[21] = "Sleaze Resistance: +3";
	vote_initiative_prefs[22] = "Spooky Resistance: +3";
	vote_initiative_prefs[23] = "Stench Resistance: +3";
	vote_initiative_prefs[24] = "Cold Damage: +10";
	vote_initiative_prefs[25] = "Hot Damage: +10";
	vote_initiative_prefs[26] = "Sleaze Damage: +10";
	vote_initiative_prefs[27] = "Spooky Damage: +10";
	vote_initiative_prefs[28] = "Stench Damage: +10";
	vote_initiative_prefs[29] = "Weapon Damage Percent: +100";
	vote_initiative_prefs[30] = "Ranged Damage Percent: +100";
	
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
	print("Preparing to vote.", "purple");
	string vote_booth = visit_url("place.php?whichplace=town_right&action=townright_vote");
	int vote_monster = vote_monster_select();
	int [int] vote_locals = vote_choose_initiatives();
	visit_url("choice.php?option=1&whichchoice=1331&g=" + vote_monster + "&local[]=" + vote_locals[0] + "&local[]=" + vote_locals[1]);
	return vote_sticker.have();
}

int vote_free_fights() {
	return get_property("_voteFreeFights").to_int();
}

boolean vote_fight_turn_check() {
	return total_turns_played() % 11 == 1;
}

int vote_fight_last() {
	return get_property("lastVoteMonsterTurn").to_int();
}

boolean vote_fight_last_check() {
	return total_turns_played() != vote_fight_last();
}

boolean vote_sticker() {
	if (!try_equip(acc3, vote_sticker)) abort("You should have your I voted sticker.");
	return true;
}

boolean vote_fight_can() {
	return  vote_have() && vote_fight_turn_check() && vote_fight_last_check() && vote_sticker();
}

boolean vote_free_fight_can() {
	return vote_fight_can() && vote_free_fights() < 3;
}
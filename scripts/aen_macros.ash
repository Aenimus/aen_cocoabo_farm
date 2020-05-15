script "aen_macros.ash";

/*
	149 Shattering Punch
	163 Gingerbread Mob Hit
	3004 Entangling Noodles
	4034 Curse of Weaksauce
	7286 Asdon Missile Launcher
	7170 Pocket Crumbs
	7265 Fire the Jokester's Gun
	7273 Extract
	7289 Micrometeorite
	7291 Meteor Shower
	7297 Sing Along
	7247 Summon Love Gnats
	7307 Chest X-Ray
*/

string macro_stasis(int rnd, int hp_threshold, boolean meteor) {
	string macro_begin;
	if (meteor) {
		macro_begin =
			"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
				"if hasskill 7291;" + // Meteor Shower
					"skill 7291;" +
				"endif;" +
			"endif;";
	} else macro_begin = "pickpocket;";
	string macro_stasis =
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 7297;" + // Sing Along
				"skill 7297;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 7273;" + // Extract
				"skill 7273;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 7170;" + // Pocket Crumbs
				"skill 7170;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 4034;" + // Curse of Weaksauce
				"skill 4034;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 7289;" + // Micrometeorite
				"skill 7289;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 7247;" + // Summon Love Gnats
				"skill 7247;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hasskill 3004;" + // Entangling Noodles
				"skill 3004;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hascombatitem little red book;" +
				"use little red book;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hascombatitem Time-Spinner;" +
				"use Time-Spinner;" +
			"endif;" +
		"endif;" +
		"if (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if hascombatitem Rain-Doh blue balls;" +
				"use Rain-Doh blue balls;" +
			"endif;" +
		"endif;" +
		"while (!pastround " + rnd + " && monsterhpabove " + hp_threshold + ");" +
			"if !hascombatitem seal tooth;" +
				"abort;" +
			"endif;" +
			"if hascombatitem seal tooth;" +
				"use seal tooth;" +
			"endif;" +
		"endwhile;";
	return macro_begin + macro_stasis;
}

string macro_stasis_scaler(int rnd) {
	string macro_stasis_scaler =
		"pickpocket;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 7297;" + // Sing Along
				"skill 7297;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 7273;" + // Extract
				"skill 7273;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 7170;" + // Pocket Crumbs
				"skill 7170;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 4034;" + // Curse of Weaksauce
				"skill 4034;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 7289;" + // Micrometeorite
				"skill 7289;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 7247;" + // Summon Love Gnats
				"skill 7247;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hasskill 3004;" + // Entangling Noodles
				"skill 3004;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hascombatitem little red book;" +
				"use little red book;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hascombatitem Time-Spinner;" +
				"use Time-Spinner;" +
			"endif;" +
		"endif;" +
		"if !pastround " + rnd + ";" +
			"if hascombatitem Rain-Doh blue balls;" +
				"use Rain-Doh blue balls;" +
			"endif;" +
		"endif;" +
		"while !pastround " + rnd + ";" +
			"if !hascombatitem seal tooth;" +
				"abort;" +
			"endif;" +
			"if hascombatitem seal tooth;" +
				"use seal tooth;" +
			"endif;" +
		"endwhile;";
	return macro_stasis_scaler;
}

string macro_stasis(int rnd, int hp_threshold) {
	return macro_stasis(rnd, hp_threshold, false);
}

string macro_finish() {
	string macro_finish =
		"while !pastround 29;" +
			"attack;" +
		"endwhile;" +
		"abort;";
	return macro_finish;
}

string macro_stasis_finish(int rnd, int hp_threshold, boolean meteor) {
	return macro_stasis(rnd, hp_threshold, meteor) + macro_finish();
}

string macro_stasis_finish(int rnd, int hp_threshold) {
	return macro_stasis_finish(rnd, hp_threshold, false);
}

string macro_stasis_scaler_finish(int rnd) {
	return macro_stasis_scaler(rnd) + macro_finish();
}

string macro_gingerbread_stasis(int rnd, int hp_threshold, boolean meteor) {
	string macro_gingerbread_stasis =
		macro_stasis(rnd, hp_threshold, meteor) +
		"use gingerbread cigarette;" +
		"abort;";
	return macro_gingerbread_stasis;
}

string macro_zeppelin_stasis(int rnd, int hp_threshold, boolean meteor) {
	if (my_location() == $location[The Red Zeppelin]) hp_threshold = hp_threshold + 50;
	string macro_zeppelin_stasis =
	macro_stasis(rnd, hp_threshold, meteor) +
	"use glark cable;" +
	"abort;";
	return macro_zeppelin_stasis;
}

string macro_zeppelin_stasis(int rnd, int hp_threshold) {
	return macro_zeppelin_stasis(rnd, hp_threshold, false);
}

string macro_essentials() {
	string macro_essentials =
		"pickpocket;" +
		"if !pastround 29;" +
			"if hasskill 7297;" +
				"skill 7297;" +
			"endif;" +
		"endif;" +
		"if !pastround 29;" +
			"if hasskill 7273;" +
				"skill 7273;" +
			"endif;" +
		"endif;" +
		"if !pastround 29;" +
			"if hasskill 7170;" +
				"skill 7170;" +
			"endif;" +
		"endif;";
	return macro_essentials;
}

string macro_essentials_finish() {
	return macro_essentials() + macro_finish();
}
	
string macro_freekill() {
	string macro_freekills =
		"if hasskill 7265;" + // Fire the Jokester's Gun
			"skill 7265;" +
		"endif;" +
		"if hasskill 7307;" + // Chest X-Ray
			"skill 7307;" +
		"endif;" +
		"if hasskill 149;" + // Shattering Punch
			"skill 149;" +
		"endif;" +
		"if hasskill 163;" + // Gingerbread Mob Hit
			"skill 163;" +
		"endif;" +
		"if hasskill 7286;" + //  Asdon Missile Launcher
			"skill 7286;" +
		"endif;";
	return macro_freekills;
}

string macro_stasis_freekill(int rnd, int hp_threshold, boolean meteor) {
	return macro_stasis(rnd, hp_threshold, meteor) + macro_freekill();
}

string macro_stasis_freekill(int rnd, int hp_threshold) {
	return macro_stasis_freekill(rnd, hp_threshold, false);
}
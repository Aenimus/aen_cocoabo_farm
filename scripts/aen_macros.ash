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

string macro_finish =
	"pickpocket;" +
	"while !pastround 10;" +
		"if hasskill 7297;" +
			"skill 7297;" +
		"endif;" +
		"if hasskill 7273;" +
			"skill 7273;" +
		"endif;" +
		"if hasskill 7170;" +
			"skill 7170;" +
		"endif;" +
		"if hasskill 4034;" +
			"skill 4034;" +
		"endif;" +
		"if hasskill 3004;" +
			"skill 3004;" +
		"endif;" +
		"if hasskill 7289;" +
			"skill 7289;" +
		"endif;" +
		"if hasskill 7247;" +
			"skill 7247;" +
		"endif;" +
		"use seal tooth;" +
	"endwhile;" +
	"while !pastround 29;" +
		"attack;" +
	"endwhile;" +
	"abort;";

string macro_stasis =
	"pickpocket;" +
	"while !pastround 10;" +
		"if hasskill 7291;" +
			"skill 7291;" +
		"endif;" +
		"if hasskill 7297;" +
			"skill 7297;" +
		"endif;" +
		"if hasskill 7273;" +
			"skill 7273;" +
		"endif;" +
		"if hasskill 7170;" +
			"skill 7170;" +
		"endif;" +
		"use seal tooth;" +
	"endwhile;";

string macro_essentials_finish =
	"pickpocket;" +
	"if hasskill 7297;" +
		"skill 7297;" +
	"endif;" +
	"if hasskill 7273;" +
		"skill 7273;" +
	"endif;" +
	"if hasskill 7170;" +
		"skill 7170;" +
	"endif;" +
	"while !pastround 29;" +
		"attack;" +
	"endwhile;";
	
string macro_essentials =
	"pickpocket;" +
	"while !pastround 10;" +
		"if hasskill 7297;" +
			"skill 7297;" +
		"endif;" +
		"if hasskill 7273;" +
			"skill 7273;" +
		"endif;" +
		"if hasskill 7170;" +
			"skill 7170;" +
		"endif;" +
	"endwhile;";
	
string macro_free_kills =
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

string macro_no_meteor_finish =
	"pickpocket;" +
	"while !pastround 10;" +
		"if hasskill 7297;" +
			"skill 7297;" +
		"endif;" +
		"if hasskill 7273;" +
			"skill 7273;" +
		"endif;" +
		"if hasskill 7170;" +
			"skill 7170;" +
		"endif;" +
		"use seal tooth;" +
	"endwhile;" +
	"while !pastround 29;" +
		"attack;" +
	"endwhile;" +
	"abort;";

boolean macro_condition(int rnd, int rnd_threshold, int hp_threshold) {
	return rnd < rnd_threshold && monster_hp() > hp_threshold;
}

void macro_stasis(int hp_threshold, int rnd, int rnd_threshold) {
	if (my_location() == $location[The Red Zeppelin]) hp_threshold = hp_threshold + 50;
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $skill[Curse of Weaksauce].try_use()) rnd++;
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $skill[Micrometeorite].try_use()) rnd++;
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $skill[Summon Love Gnats].try_use()) rnd++;
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $skill[Entangling Noodles].try_use()) rnd++;
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $item[little red book].have()) {
		$item[little red book].throw_item();
		rnd++;
	}
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $item[Rain-Doh blue balls].have()) {
		$item[Rain-Doh blue balls].throw_item();
		rnd++;
	}
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $item[Time-Spinner].have()) {
		$item[Time-Spinner].throw_item();
		rnd++;
	}
	if (macro_condition(rnd, rnd_threshold, hp_threshold) && $item[seal tooth].have()) {
		$item[seal tooth].throw_item();
		rnd++;
	} else if (!$item[seal tooth].have()) abort("We need to acquire a seal tooth for stasis.");
}
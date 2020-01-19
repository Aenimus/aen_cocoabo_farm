script "aen_macros.ash";

/*
	149 Shattering Punch
	163 Gingerbread Mob Hit
	7286 Asdon Missile Launcher
	7170 Pocket Crumbs
	7265 Fire the Jokester's Gun
	7273 Extract
	7291 Meteor Shower
	7297 Sing Along
	7307 Chest X-Ray
*/

string macro_finish =
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
	"while !pastround 29;" +
		"attack;" +
	"endwhile;";
	
string macro_essentials =
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
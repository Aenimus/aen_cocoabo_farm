script "aen_mumming";

import "aen_utils.ash";

string [string] mumming_costumes = {
	$string[beelzebub]: $string[mp],
	$string[miss funny]: $string[moxie],
	$string[myst]: $string[mysticality],
	$string[oliver cromwell]: $string[mysticality],
	$string[Prince george]: $string[\item],
	$string[Saint patrick]: $string[muscle],
	$string[the captain]: $string[meat],
	$string[the doctor]: $string[hp],
};

string [string] mumming_text = {
	$string[hp]: $string[HP Regen],
	$string[\item]: $string[\Item Drop],
	$string[meat]: $string[Meat Drop],
	$string[moxie]: $string[(Moxie)],
	$string[mp]: $string[MP Regen],
	$string[muscle]: $string[(Muscle)],
	$string[myst]: $string[(Mysticality)]
};

boolean mumming_have() {
	return $item[mumming trunk].fetch();
}

string mumming_mods() {
	return get_property("_mummeryMods").to_lower_case();
}

boolean mumming_mod_have(string mod_text) {
	return contains_text(mumming_mods(), mod_text);
}

boolean mumming_can(string mod_text) {
	return mumming_have() && !mumming_mod_have(mod_text);
}

boolean mumming_run(string mod) {
	mod = mod.to_lower_case();
	string mod_text;
	foreach costume in mumming_costumes {
		if (mod == costume) {
			mod = mumming_costumes[mod];
			break;
		}
	}
	foreach str in mumming_text {
		if (mod == str) {
			mod_text = mumming_text[str];
			break;
		}
	}
	if (!mumming_can(mod_text)) return false;
	if (!($strings[hp, \item, meat, mp, muscle, moxie, myst] contains mod)) abort(mod + " is not a correct mumming buff. Enter a buff type or costume name.");
	cli_execute("mummery " + mod);
	return mumming_mod_have(mod_text);
}
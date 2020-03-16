script "aen_romantic.ash";

string romantic_fam_today_get() {
	return get_property("_aen_romantic_fam_today");
}

string romantic_skill_today_get() {
	return get_property("_aen_romantic_skill_today");
}

skill romantic_skill_today() {
	return romantic_skill_today_get().to_skill();
}

familiar romantic_fam_today_run() {
	familiar mator = $familiar[Reanimated Reanimator];
	familiar angel = $familiar[Obtuse Angel];
	if (mator.have()) return mator;
	if (angel.have()) return angel;
	return $familiar[none];
}

void romantic_fam_today_set(familiar fam) {
	string str = fam.to_string();
	if (str == "Reanimated Reanimator") set_property("_aen_romantic_skill_today", "Wink At");
	else if (str == "Obtuse Angel") set_property("_aen_romantic_skill_today", "Fire a badly romantic arrow");
	set_property("_aen_romantic_fam_today", str);
}

familiar romantic_fam_today() {
	if (romantic_fam_today_get() == "") romantic_fam_today_set(romantic_fam_today_run());
	return romantic_fam_today_get().to_familiar();
}

// @TODO skill selection
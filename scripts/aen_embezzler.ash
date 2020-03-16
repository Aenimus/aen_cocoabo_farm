script "aen_embezzler.ash";

int embezzlers_today() {
	return get_property("_aen_embezzlers_today").to_int();
}

void embezzlers_today_increment() {
	set_property("_aen_embezzlers_today", embezzlers_today() + 1);
}

boolean embezzler_prep() {
	if (embezzler_outfit() == "") abort("Set a value for aen_embezzler_outfit.");
	$skill[Disco Leer].try_use();
	return embezzler_outfit().change_outfit();
}
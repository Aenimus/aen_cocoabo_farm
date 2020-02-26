script "aen_embezzler.ash";

boolean embezzler_prep() {
	if (embezzler_outfit() == "") abort("Set a value for aen_embezzler_outfit.");
	$skill[Disco Leer].try_use();
	return embezzler_outfit().change_outfit();
}
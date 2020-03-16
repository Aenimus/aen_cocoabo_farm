script "aen_sandworm.ash";

int sandworm_fights() {
	return get_property("_aen_sandworm_fights").to_int();
}

void sandworm_fights_increment() {
	set_property("_aen_sandworm_fights", sandworm_fights() + 1);
}

int sandworm_melange() {
	return get_property("_aen_sandworm_melange").to_int();
}

void sandworm_melange_increment() {
	set_property("_aen_sandworm_melange", sandworm_melange() + 1);
}

boolean sandworm_can() {
	if ($item[drum machine].have())	return freekill_powerpill_can();
	else abort("Acquire more drum machines.");
	return false;
}

boolean sandworm_run() {
	int fights = sandworm_fights();
	print("Fighting giant sandworm #" + (fights + 1) + ".", "purple");
	if (freekill_jokester_can()) freekill_jokester_run();
	else if (freekill_docbag_can()) freekill_docbag_run();
	$item[drum machine].use();
	return sandworm_fights() > fights;
}
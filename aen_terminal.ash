script "aen_terminal.ash";

skill terminal_digitize = $skill[Digitize];

boolean terminal_have() {
	return get_campground() contains terminal;
}

boolean [string] terminal_education() {
	boolean [string] r = {
		get_property("sourceTerminalEducate1"): true,
		get_property("sourceTerminalEducate2"): true,
	};
	return r;
}

boolean [string] terminal_educate(boolean [string] skills) {
	boolean [string] prev = terminal_education();
	foreach sk in skills {
		cli_execute("terminal educate " + sk);
	}
	return prev;
}

boolean [string] terminal_educate(string skill1) {
	boolean [string] prev = terminal_education();
	if (prev contains skill1) return prev;
	boolean [string] skills = $strings[extract];
	skills[skill1] = true;
	terminal_educate(skills);
	return prev;
}

int terminal_digitizes() {
	return get_property("_sourceTerminalDigitizeUses").to_int();
}

int terminal_digitizee() {
	return get_property("_sourceTerminalDigitizeMonsterCount").to_int();
}

boolean terminal_digitize_can() {
	return terminal_have() && terminal_digitize.have();
}

boolean terminal_digitize_should() {
	if (!terminal_digitize_can()) return false;
	if (terminal_digitizes() == 0) return true;
	if (terminal_digitizes() < 3 && terminal_digitizee() > 5) return true;
	return false;
}

void terminal_use_digitize() {
	terminal_digitize.use_skill();
	set_property("_assJustDigitized", true);
}

boolean terminal_duplicate_can() {
	if (!terminal_have()) return false;
	return get_property("_sourceTerminalDuplicateUses").to_int() < 1;
}

boolean terminal_duplicate_prepare() {
	if (!terminal_duplicate_can()) return false;
	print("Preparing to duplicate a monster.", "green");
	if (!get_property("_eternalCarBatteryUsed").to_boolean() && $item[Eternal Car Battery].fetch()) $item[Eternal Car Battery].use();
	cli_execute("terminal educate duplicate");
	cli_execute("terminal educate extract");
	return get_property("_sourceTerminalDuplicateUses").to_int() > 0;
}
	

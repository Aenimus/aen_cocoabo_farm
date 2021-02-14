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

int terminal_portscans() {
	return get_property("_sourceTerminalPortscanUses").to_int();
}

boolean terminal_portscan_can() {
	if (terminal_have()) return terminal_portscans() < 3;
	return false;
}

void terminal_portscan_prepare(boolean macro_check) {
	if (!terminal_portscan_can()) return;
	if (macro_check && (get_property("_macrometeoriteUses").to_int() > 9 || !$skill[Macrometeorite].have())) {
		if (get_property("_powerfulGloveBatteryPowerUsed").to_int() > 90 || !$item[Powerful Glove].fetch()) abort("ABORT: No macrometeorite-like options to use.");
	}
	print("Preparing to portscan a monster.", "green");
	cli_execute("terminal educate portscan");
	cli_execute("terminal educate extract");
	set_property("aen_use_portscan", true);
	/*if () set_property("aen_use_portscan", true);
	else print("Could not prepare portscan.", "red");*/
}

void terminal_portscan_prepare() {
	terminal_portscan_prepare(true);
}

void terminal_portscan_use(boolean macro_check) {
	if (!get_property("aen_use_portscan").to_boolean() || !$skill[portscan].have()) return;
	if (macro_check && (get_property("_macrometeoriteUses").to_int() > 9 || !$skill[Macrometeorite].have()) // @TODO meteorite file
	&& !$skill[CHEAT CODE: Replace Enemy].have()) {
		abort("ABORT: No Macrometeorite-like options to use.");
	}
	$skill[portscan].use();
	set_property("aen_use_portscan", false);
}

void terminal_portscan_use() {
	terminal_portscan_use(true);
}

boolean terminal_duplicate_can() {
	if (terminal_have()) return get_property("_sourceTerminalDuplicateUses").to_int() < 1;
	return false;
}

void terminal_digitize_use() {
	terminal_digitize.use_skill();
	set_property("_assJustDigitized", true);
}


void terminal_duplicate_prepare() {
	if (!terminal_duplicate_can()) return;
	print("Preparing to duplicate a monster.", "green");
	if (!get_property("_eternalCarBatteryUsed").to_boolean() && $item[Eternal Car Battery].fetch()) $item[Eternal Car Battery].use();
	cli_execute("terminal educate duplicate");
	cli_execute("terminal educate extract");
}
	

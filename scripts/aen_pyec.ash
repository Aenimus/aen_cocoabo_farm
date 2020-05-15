script "aen_pyec.ash";

boolean pyec_absent() {
	return get_property("aen_no_PYEC").to_boolean();
}

boolean pyec_today() {
	return get_property("_aen_have_PYEC").to_boolean();
}

boolean pyec_have() {
	if (pyec_absent()) {
		set_property("_aen_have_PYEC", "false");
		return false;
	}
	set_property("_aen_have_PYEC", pyec.fetch());
	if (!pyec_today() && user_confirm("Do you have access to a PYEC?")) set_property("_aen_have_PYEC", "true");
	if (!pyec_today() && user_confirm("Do you have want to stop all further PYEC prompts?")) set_property("aen_no_PYEC", "true");
	return pyec_today();
}

boolean pyec_used() {
	return get_property("expressCardUsed").to_boolean();
}

boolean pyec_can() {
	return !pyec_used() && pyec_have();
}

boolean pyec_run() {
	if (!pyec_can()) return false;
	if (!pyec.have()) abort("Acquire your PYEC.");
	print("Maximising MP and using a PYEC.", "purple");
	if (!$familiar[Left-Hand Man].use()) $familiar[Disembodied Hand].use();
	maximize("MP", false);
	cli_execute("/cast * " + libram_today());
	print("Second cast check in pyec_run().", "red");
	cli_execute("/cast * " + libram_today());
	return pyec.use();
}
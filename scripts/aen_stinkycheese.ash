script "aen_stinkycheese.ash";

boolean stinkycheese_banish_can() {
	return !get_property("_stinkyCheeseBanisherUsed").to_boolean();
}
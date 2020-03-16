script "aen_workshed.ash";

boolean workshed_used() {
	return get_property("_workshedItemUsed").to_boolean();
}

boolean workshed_query(item it) {
	return get_campground() contains it;
}

boolean workshed_can(item it) {
	return !workshed_used() && !workshed_query(it) && it.fetch();
}

boolean workshed_run(item it) {
	if (workshed_can(it) && user_confirm("Change your workshed item to " + it.to_string() + "?")) {
		print("Changing your workshed item to " + it.to_string() + ".", "purple");
		return it.use();
	}
	print("Not changing workshed items.");
	return false;
}
script "aen_pantsgiving.ash";

boolean pantsgiving_have() {
	return pantsgiving.fetch();
}

boolean pantsgiving_can() {
	return get_property("aen_pantsgiving_can").to_boolean();
}

void pantsgiving_can_set(boolean can) {
	set_property("aen_pantsgiving_can", can.to_string());
}

int pantsgiving_turns() {
	return get_property("_pantsgivingCount").to_int();
}

boolean pantsgiving_threshold(int fullness) {
	int threshold = (10 ** fullness)/2;
	return pantsgiving_turns() >= threshold;
}

boolean pantsgiving_threshold_run(int num) {
	if (pantsgiving_can() && !pantsgiving_threshold(num)) return !pantsgiving.try_equip();
	return true;
}

int pantsgiving_fullness() {
	return get_property("_pantsgivingFullness").to_int();
}

boolean pantsgiving_fullness_can(int fullness) {
	if (!pantsgiving_can() || stomach_remaining() < 1) return false;
	return fullness > pantsgiving_fullness();
}

void pantsgiving_prompt() {
	if (pantsgiving.fetch()) pantsgiving_can_set(true);
	else if (user_confirm("Do you have access to some Pantsgiving?")) abort("Retrieve your Pantsgiving and rerun.");
	else if (user_confirm("Do you wish to prevent all future Pantsgiving prompts?")) pantsgiving_can_set(false);
}
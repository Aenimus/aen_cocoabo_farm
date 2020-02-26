script "aen_data.ash";

int data_session_adv() {
	return get_property("_aen_sess_adv").to_int();
}

void data_session_adv_reset() {
	if (data_session_adv() != 0) set_property("_aen_sess_adv", 0);
}

void data_session_adv_set(int num) {
	set_property("_aen_sess_adv", num);
}

int data_session_adv_difference() {
	return my_session_adv() - data_session_adv();
}

int data_adv_today() {
	return get_property("_aen_adv_today").to_int();
}

void data_adv_today_update() {
	set_property("_aen_adv_today", data_adv_today() + data_session_adv_difference());
}

int data_adv_threshold() {
	return get_property("_aen_adv_threshold").to_int();
}

boolean data_adv_threshold_exceeded(int num) {
	return data_adv_today() > num;
}

boolean data_adv_threshold_exceeded() {
	int today = data_adv_today();
	if (today > 5) abort("We've spent more 5 adventures. Manually override data_adv_threshold_compare.");
	return today > data_adv_threshold();
}

void data_adv_threshold_set(int num) {
	set_property("_aen_adv_threshold", num);
}

void data_session_adv_update() {
	if (my_session_adv() == 0) data_session_adv_reset();
	else if (my_session_adv() > data_session_adv()) {
		data_adv_today_update();
		data_session_adv_set(my_session_adv());
	}
}

void data_adv_threshold_check(int num) {
	if (data_adv_threshold_exceeded(num)) {
		if (user_confirm("We have exceeded our adventure threshold. Is something awry?")) abort("Ceasing.");
		else data_adv_threshold_set(data_adv_today());
	}
}

void data_adv_threshold_check() {
	if (data_adv_threshold_exceeded()) {
		if (user_confirm("We have exceeded our adventure threshold. Is something awry?")) abort("Ceasing.");
		else data_adv_threshold_set(data_adv_today());
	}
}

int data_session_meat() {
	return get_property("_aen_sess_meat").to_int();
}

void data_session_meat_reset() {
	if (data_session_meat() != 0) set_property("_aen_sess_meat", 0);
}

void data_session_meat_set(int num) {
	set_property("_aen_sess_meat", num);
}

int data_session_meat_difference() {
	return my_session_meat() - data_session_meat();
}

int data_meat_today() {
	return get_property("_aen_meat_today").to_int();
}

void data_meat_today_update() {
	set_property("_aen_meat_today", data_meat_today() + data_session_meat_difference());
}

void data_session_meat_update() {
	if (my_session_meat() == 0) data_session_meat_reset();
	else if (my_session_meat() > data_session_meat()) {
		data_meat_today_update();
		data_session_meat_set(my_session_meat());
	}
}

int data_costs_today() {
	return get_property("_aen_costs_today").to_int();
}

void data_costs_today_set(int num) {
	set_property("_aen_costs_today", num);
}

int data_fights_today() {
	return get_property("_aen_fights_today").to_int();
}

void data_fights_today_increment() {
	if (my_familiar() == cocoabo_today()) set_property("_aen_fights_today", data_fights_today() + 1);
}

void data_tp_rares() {
	foreach it in $items[tiny plastic Naughty Sorceress, tiny plastic Susie, tiny plastic Boris, tiny plastic Jarlsberg, tiny plastic Sneaky Pete,
		tiny plastic Ed the Undying, tiny plastic Lord Spookyraven, tiny plastic Dr. Awkward, tiny plastic protector spectre] {
		if (it.have()) print("Congratulations! You obtained " + it.item_amount() + " " + it.to_string() + "!", "green");
	}
}
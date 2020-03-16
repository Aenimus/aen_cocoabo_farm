script "aen_counter.ash";

boolean counter_have(string counter_name) {
	counter_name = counter_name + " Monster";
	return get_counters(counter_name, 0, 500) == counter_name;
}

boolean counter_now(string counter_name) {
	counter_name = counter_name + " Monster";
	return get_counters(counter_name, 0, 0) == counter_name;
}

boolean counter_window_have(string counter_name) {
	string begin = counter_name + " Monster window begin";
	string finish = counter_name + " Monster window end";
	return counter_have(begin) || counter_have(finish);
}

boolean counter_window_now(string counter_name) {
	string begin = counter_name + " Monster window begin";
	string finish = counter_name + " Monster window end";
	return get_counters(begin, 1, 500) != begin && counter_have(finish);
}
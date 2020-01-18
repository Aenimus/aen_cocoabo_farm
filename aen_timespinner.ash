script "aen_timespinner.ash";

import "aen_utils.ash";

boolean timespinner_have() {
	return timespinner.fetch();
}

int timespinner_mins_left() {
	return 10 - get_property("_timeSpinnerMinutesUsed").to_int();
}

boolean [item] timespinner_eaten() {
	string [int] food_strings = get_property("_timeSpinnerFoodAvailable").split_string(",");
	boolean [item] eaten;

	foreach i, food_string in food_strings {
		eaten[food_string.to_item()] = true;
	}

	return eaten;
}

boolean timespinner_can(int mins) {
	if (my_adventures() < 1) return false;
	return timespinner_have() && timespinner_mins_left() >= mins;
}

boolean timespinner_can() {
	return timespinner_can(3);
}

boolean timespinner_can_eat(item food) {
	return timespinner_can() && timespinner_eaten() contains food;
}

boolean timespinner_eat(item food) {
	if (!timespinner_can_eat(food)) return false;
	if (food.fullness == 0) abort("Cannot timespin " + food.to_string() + ".");
	cli_execute("timespinner eat " + food.to_string());
	return true;
}

boolean timespinner_fight(monster mob) {
	if (!timespinner_can()) return false;
	if (mob.id == 1431 && !bworps.have() & !bworps.fetch()) buy_until(1, bworps, 500);
	visit_url("inv_use.php?whichitem=9104&pwd=" + my_hash(), true);
	run_choice(1);
	visit_url("choice.php?whichchoice=1196&monid=" + mob.id + "&option=1&pwd=" + my_hash(), true);
	run_combat();
	return true;
}

boolean timespinner_fight(int mob_id) {
	if (!timespinner_can()) return false;
	if (mob_id == 1431 && !bworps.have() & !bworps.fetch()) buy_until(1, bworps, 500);
	visit_url("inv_use.php?whichitem=9104&pwd=" + my_hash(), true);
	run_choice(1);
	visit_url("choice.php?whichchoice=1196&monid=" + mob_id + "&option=1&pwd=" + my_hash(), true);
	run_combat();
	return true;
}

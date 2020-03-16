script "aen_wanderer.ash";

location wanderer_location(copier wanderer) {
	copier taffy = c_taffy();
	if (wanderer.mob == taffy.target && taffy.combat_could && (fishy_have() || fishy_pipe_run())) return $location[The Briny Deeps];
	return $location[The Haunted Kitchen];
}

location wanderer_location() { //@TODO
	return $location[The Haunted Kitchen];
}

boolean wanderer_now_run(copier wanderer) {
	adv1(wanderer_location(wanderer), 0, "");
	return !counter_now(wanderer.counter);
}

void wanderer_now_run() {
	adv1(wanderer_location(), 0, "");
}
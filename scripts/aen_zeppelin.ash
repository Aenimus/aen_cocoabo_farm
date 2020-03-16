script "aen_zeppelin.ash";

boolean zeppelin_complete() {
	return get_property("questL11Ron") == "finished";
}

boolean zeppelin_free_can() {
	return zeppelin_complete() && freekill_glark() < 5 && $item[glark cable].fetch();
}

boolean zeppelin_free_run() {
	int fights = freekill_glark();
	print("Preparing to use a glark cable for free fight #" + (fights + 1) + ".", "purple");
	adv1($location[The Red Zeppelin], -1, "");
	return freekill_glark() > fights;
}
	
	
script "aen_proto.ash";

location proto_location() {
	return get_property("ghostLocation").to_location();
}

boolean proto_available() {
	return get_property("nextParanormalActivity").to_int() == total_turns_played();
}

boolean proto_have() {
	return $item[protonic accelerator pack].fetch();
}

boolean proto_can() {
	return proto_location() != $location[none];
}

boolean proto_run() {
	// questM23Meatsmith unstarted --> started
	adv1(proto_location(), 0, "");
	return proto_location() == $location[none];
}
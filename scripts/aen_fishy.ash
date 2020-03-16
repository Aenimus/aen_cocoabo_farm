script "aen_fishy.ash";

boolean fishy_have() {
	return $effect[fishy].have();
}

boolean fishy_pipe_used() {
	return get_property("_fishyPipeUsed").to_boolean();
}

boolean fishy_pipe_can() {
	return !fishy_have() && !fishy_pipe_used() && $item[fishy pipe].fetch();
}

boolean fishy_pipe_run() {
	if (!fishy_pipe_can()) return false;
	return $item[fishy pipe].use();
}
	
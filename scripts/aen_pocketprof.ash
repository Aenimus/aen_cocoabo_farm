script "aen_pocketprof";

boolean pocketprof_have() {
	return pocket_prof.have();
}

boolean pocketprof_prep(boolean terminate) {
	if (pocket_prof.use()) {
		pocket_prof.feast_run();
		if (!$item[Pocket Professor memory chip].try_equip() && terminate) abort("Acquire Pocket Professor memory chip.");
		return true;
	}
	return false;
}
		
boolean pocketprof_prep() {
	return pocketprof_prep(true);
}
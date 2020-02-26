script "aen_freerun.ash";

familiar freerun_fam_select() {
	familiar [int] poss;
	if (stomp_boots.have()) poss[count(poss)] = stomp_boots;
	if (bander.have()) poss[count(poss)] = bander;

	if (count(poss) == 0) return $familiar[None];

	// If any are the same weight, they retain their relative order
	sort poss by -value.familiar_weight();

	return poss[0];
}

familiar freerun_fam() {
	return freerun_fam_select();
}

int freerun_fam_used() {
	return get_property("_banderRunaways").to_int();
}

int freerun_fam_max(int extra) {
	int weight = freerun_fam().familiar_weight();
	return floor((weight + extra) / 5);
}

int freerun_fam_max() {
	return freerun_fam_max(weight_adjustment());
}

int freerun_fam_remain(int extra) {
	return freerun_fam_max(extra) - freerun_fam_used();
}

int freerun_fam_remain() {
	return freerun_fam_remain(weight_adjustment());
}
	return freerun_familiar_runs_remain() > 0;
}

boolean freerun_fam_could() {
	if (freerun_fam() == $familiar[none]) return false;

boolean freerun_fam_prep() {
	if (!freerun_fam_could()) return false;
	familiar fam = freerun_fam();
	print("Preparing to use " + fam + " to free run.", "orange");
	if (fam == bandersnatch && !ode.effect_active()) {
		if (!ode.atbuff_run()) abort("Could not acquire Ode to Booze for runaways.");
	}
	return fam.use();
}

boolean freerun_fam_can() {
	return freerun_fam_could() && my_familiar() == freerun_fam();
}

boolean freerun_fam_run() {
	if (freerun_fam_can()) {
	// once per combat stuff here
		return runaway();
	}
}

// Needs combat stuff

// @TODO From here

boolean freerun_could_kgb() {
	return kgb_could_banish();
}

void freerun_prep_kgb() {
	print("Preparing to use KGB to free run");
	kgb.smart_equip();
}

boolean freerun_can_kgb() {
	return kgb_can_banish();
}

void freerun_use_kgb() {
	kgb_banish();
}

boolean freerun_could_stinky() {
	return stinky_could_banish();
}

void freerun_prep_stinky() {
	print("Preparing to use Stink Eye to free run");
	stinky_get(stinky_eye);
	smart_equip(stinky_eye);
}

boolean freerun_can_stinky() {
	return stinky_can_banish();
}

void freerun_use_stinky() {
	stinky_banish();
}

boolean freerun_could(boolean allowBanish) {
	return (
		freerun_could_familiar() ||
		(freerun_could_kgb() && allowBanish) ||
		(freerun_could_stinky() && allowBanish) ||
	false);
}

boolean freerun_could() {
	return freerun_could(true);
}

void freerun_prep(boolean allowBanish) {
	if (freerun_could_familiar()) freerun_prep_familiar();
	if (freerun_could_kgb() && allowBanish) freerun_prep_kgb();
	if (freerun_could_stinky() && allowBanish) freerun_prep_stinky();
}

void freerun_prep() {
	freerun_prep(true);
}

void freerun_use(boolean allowBanish) {
	if (freerun_can_familiar()) {
		freerun_use_familiar();
		return;
	}

	if (freerun_can_kgb() && allowBanish) {
		freerun_use_kgb();
		return;
	}

	if (freerun_can_stinky() && allowBanish) {
		freerun_use_stinky();
		return;
	}

	abort("Tried to free run but couldn't");
}

void freerun_use() {
	freerun_use(true);
}

location freerun_location() {
	if (doctorbag_quest() && freerun_could()) {
		return doctorbag_location_prep();
	}

	// @TODO Dinseyland keycards

	return $location[none];
}

boolean freerun_should() {
	return freerun_location() != $location[none];
}

void freerun_run() {
	location loc = freerun_location();
	freerun_prep();
	adv1(loc, -1, "");
}

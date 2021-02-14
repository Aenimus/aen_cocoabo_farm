script "aen_freerun.ash";

string freerun_fam_today_get() {
	return get_property("_aen_freerun_fam_today");
}

familiar freerun_fam_today() {
	return freerun_fam_today_get().to_familiar();
}

void freerun_fam_today_set(familiar fam) {
	string str = fam.to_string();
	set_property("_aen_freerun_fam_today", str);
}

familiar freerun_fam_select() {
	if (stomp_boots.have()) return stomp_boots;
	else if (bander.have()) return bander;
	return $familiar[none];
}

int freerun_fam_used() {
	return get_property("_banderRunaways").to_int();
}

boolean freerun_fam_could() { //@TODO MAX WEIGHT WITH FEAST
	return (my_familiar() == stomp_boots || (my_familiar() == bander && $effect[Ode to Booze].have()));
}

int freerun_fam_available() {
	int total_weight = freerun_fam_today().total_weight();
	return floor(total_weight/5);
}

int freerun_fam_remain() {
	return freerun_fam_available() - freerun_fam_used();
}

boolean freerun_fam_have() {
	return freerun_fam_today() != $familiar[none];
}

boolean freerun_fam_can(int max_runs) {
	return freerun_fam_used() < max_runs;
}

int freerun_fam_max() {
	return get_property("aen_freerun_fam_max").to_int();
}

void freerun_fam_max_set(int num) {
	set_property("aen_freerun_fam_max", num);
}

void freerun_fam_max_reset() {
	set_property("aen_freerun_fam_max", freerun_fam_available());
}

void freerun_fam_max_check() {
	if (freerun_fam_max() < 1) {
		max_weight_outfit().change_outfit();
		set_property("aen_freerun_fam_max", freerun_fam_available());
	}
}

void freerun_fam_today_prep(familiar fam) {
	if (fam.use()) fam.feast_run();
	if (freerun_fam_today().feast_fam_check()) freerun_fam_max_set(freerun_fam_max() + 2);
	if (freerun_fam_max() > 117) abort("Check freerun_fam_max() in _prep");
}

void freerun_fam_today_run() {
	freerun_fam_select().freerun_fam_today_set();
	freerun_fam_today().freerun_fam_today_prep();
}

boolean freerun_max_weight_run() {
	freerun_fam_today().use();
	while (freerun_fam_used() >= freerun_fam_available()) {
		if (!max_weight_outfit_acc1.worn() && try_equip(acc1, max_weight_outfit_acc1)) continue;
		if (!max_weight_outfit_acc2.worn() && try_equip(acc2, max_weight_outfit_acc2)) continue;
		if (!max_weight_outfit_acc3.worn() && try_equip(acc3, max_weight_outfit_acc3)) continue;
		if (!max_weight_outfit_pants.worn() && try_equip(pants, max_weight_outfit_pants)) continue;
		if (!max_weight_outfit_weapon.worn() && try_equip(weapon, max_weight_outfit_weapon)) continue;
		if (!max_weight_outfit_off.worn() && try_equip(off, max_weight_outfit_off)) continue;
		if (!max_weight_outfit_shirt.worn() && try_equip(shirt, max_weight_outfit_shirt)) continue;
		if (!max_weight_outfit_back.worn() && try_equip(back, max_weight_outfit_back)) continue;
		if (!max_weight_outfit_hat.worn() && try_equip(hat, max_weight_outfit_hat)) continue;
		if (!max_weight_outfit_fam_equip.worn() && try_equip(fam, max_weight_outfit_fam_equip)) continue;
		break;
	}
	if (freerun_fam_used() < freerun_fam_max()) return false;
	freerun_fam_max_reset();
	return true;
}

boolean freerun_blankout_used() {
	return get_property("_blankoutUsed").to_boolean();
}

int freerun_blankouts() {
	return get_property("blankOutUsed").to_int();
}

boolean freerun_blankout_can() {
	return freerun_blankouts() < 5 && $item[glob of Blank-Out].have();
}

//&TODO
/*boolean freerun_fam_prep() {
	if (!freerun_fam_could()) continue;
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
*/
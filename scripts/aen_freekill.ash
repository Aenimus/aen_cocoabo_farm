script "aen_freekill.ash";

int freekill_batrang_uses() {
	return get_property("_usedReplicaBatoomerang").to_int();
}

boolean freekill_batrang_used() {
	return freekill_batrang_uses() > 2;
}

boolean freekill_batrang_can() {
	return !freekill_batrang_used() && $item[replica bat-oomerang].have();
}

int freekill_docbag_uses() {
	return get_property("_chestXRayUsed").to_int();
}

boolean freekill_docbag_used() {
	return freekill_docbag_uses() > 2;
}

boolean freekill_docbag_can() {
	return !freekill_docbag_used() && docbag.fetch();
}

boolean freekill_docbag_run() {
	print("Wearing the " + docbag.to_string() + " for Chest X-Ray #" + (freekill_docbag_uses() + 1) + ".", "purple");
	return try_equip(acc1, docbag);
}

int freekill_glark() {
	return get_property("_glarkCableUses").to_int();
}

boolean freekill_jokester_used() {
	return get_property("_firedJokestersGun").to_boolean();
}

boolean freekill_jokester_can() {
	return !freekill_jokester_used() && $item[The Jokester\'s gun].fetch();
}

boolean freekill_jokester_run() {
	print("Wearing the The Jokester\'s gun for a free kill.", "purple");
	return $item[The Jokester\'s gun].try_equip();
}

int freekill_madness_uses() {
	return get_property("_powderedMadnessUses").to_int();
}

boolean freekill_madness_used() {
	return freekill_madness_uses() > 4;
}

boolean freekill_madness_can() {
	return !freekill_madness_used() && $item[powdered madness].have();
}

int freekill_powerpill_uses() {
	return get_property("_powerPillUses").to_int();
}

boolean freekill_powerpill_used() {
	return freekill_powerpill_uses() > 19;
}

boolean freekill_powerpill_can() {
	return !freekill_powerpill_used() && $item[power pill].have();
}

int freekill_shattering_uses() {
	return get_property("_shatteringPunchUsed").to_int();
}

boolean freekill_shattering_used() {
	return freekill_shattering_uses() > 2;
}

boolean freekill_shattering_can() {
	return !freekill_shattering_used() && $skill[shattering punch].have();
}
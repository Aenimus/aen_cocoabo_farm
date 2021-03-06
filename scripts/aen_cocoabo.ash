script "aen_cocoabo.ash";

string cocoabo_today_get() {
	return get_property("_aen_cocoabo_today");
}

familiar cocoabo_today() {
	return cocoabo_today_get().to_familiar();
}

void cocoabo_today_set(familiar fam) {
	string str = fam.to_string();
	set_property("_aen_cocoabo_today", str);
}

boolean cocoabo_exception() {
	return cocoabo_today() == comma;
}

boolean cocoabo_today_prep(familiar fam) {
	if (fam.use()) {
		mumming_run("meat");
		if (fam == comma) return true;
		fam.feast_run();
		helicopter.legion_equip();
		return true;
	}
	return false;	
}
	
void cocoabo_today_run() {
	if (cocoabo_today_get() != "") return;
	foreach fam in $familiars[
		Feather Boa Constrictor,
		Comma Chameleon,
		Ninja Pirate Zombie Robot,
		Stocking Mimic,
		Cocoabo
	] {
		if (fam.have()) {
			fam.cocoabo_today_set();
			fam.cocoabo_today_prep();
			return;
		}
	}
	abort("You do not have a suitable familiar for this script.");
}

void cocoabo_run() {
	cocoabo_today().use();
	if ( !cocoabo_exception() )
	{
		if ( $item[miniature crystal ball].worn() && get_property( "crystalBallMonster" ) == "drunk pygmy" ) return;
		helicopter.legion_equip();
	}
	else comma_run("Feather Boa Constrictor");
}
	
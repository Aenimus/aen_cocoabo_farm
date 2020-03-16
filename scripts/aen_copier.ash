script "aen_copier.ash";

record copier {
	string counter;
	string type;
	string source;
	item copier;
	boolean have;
	string property;
	boolean used;
	string target;
	string mob;
	boolean mob_check;
	int cost;
	boolean worth;
	string prep;
	boolean source_condition;
	boolean combat_could;
	boolean combat_can;
	boolean can;
	string run;
};

copier c_4d_camera() {
	copier c_4d_camera;
	c_4d_camera.type = "item";
	c_4d_camera.source = "4-d camera";
	c_4d_camera.copier = $item[shaking 4-d camera];
	c_4d_camera.have = convert_have(c_4d_camera.type, c_4d_camera.source);
	c_4d_camera.property = get_property("_cameraUsed");
	c_4d_camera.used = c_4d_camera.property.to_boolean();
	c_4d_camera.mob = get_property("cameraMonster");
	c_4d_camera.target = camera_monster_string();
	c_4d_camera.mob_check = c_4d_camera.target == c_4d_camera.mob;
	c_4d_camera.cost = $item[4-d camera].mall_price();
	c_4d_camera.worth = c_4d_camera.cost < c_4d_camera.target.get_worth();
	c_4d_camera.source_condition = !c_4d_camera.used;
	c_4d_camera.combat_could = !c_4d_camera.copier.have() && c_4d_camera.worth && c_4d_camera.have;
	c_4d_camera.combat_can = c_4d_camera.source_condition && c_4d_camera.combat_could;
	c_4d_camera.can = !c_4d_camera.used && c_4d_camera.mob_check;
	return c_4d_camera;
}

copier c_digitize() {
	copier c_digitize;
	c_digitize.counter = "Digitize";
	c_digitize.type = "skill";
	c_digitize.source = "digitize";
	c_digitize.copier = $item[none];
	c_digitize.have = convert_have(c_digitize.type, c_digitize.source);
	c_digitize.property = get_property("romanticTarget");
	c_digitize.used = c_digitize.property != "";
	c_digitize.mob = get_property("_sourceTerminalDigitizeMonster");
	c_digitize.target = camera_monster_string();
	c_digitize.mob_check = c_digitize.target == c_digitize.mob;
	c_digitize.source_condition = !c_digitize.used; //@TODO with the day's adventures
	c_digitize.cost = 0;
	c_digitize.worth = true;
	c_digitize.prep = "c_digitize_prep";
	c_digitize.combat_could = false; //c_digitize.source_condition;
	c_digitize.combat_can = false;
	c_digitize.can = counter_now("Digitize");
	c_digitize.run = "wanderer_now_run";
	return c_digitize;
}

copier c_enamorang() {
	copier c_enamorang;
	c_enamorang.counter = "Enamorang";
	c_enamorang.type = "item";
	c_enamorang.source = "LOV Enamorang";
	c_enamorang.copier = $item[none];
	c_enamorang.have = convert_have(c_enamorang.type, c_enamorang.source);
	c_enamorang.property = get_property("_enamorangs");
	c_enamorang.used = c_enamorang.property.to_int() > 2;
	c_enamorang.mob = get_property("enamorangMonster");
	c_enamorang.target = camera_monster_string();
	c_enamorang.mob_check = c_enamorang.target == c_enamorang.mob;
	c_enamorang.cost = 25000;
	c_enamorang.worth = c_enamorang.cost < c_enamorang.target.get_worth();
	c_enamorang.source_condition = !c_enamorang.used && !counter_have(c_enamorang.counter);
	c_enamorang.combat_could = c_enamorang.worth && c_enamorang.have;
	c_enamorang.combat_can = c_enamorang.source_condition && c_enamorang.combat_could;
	c_enamorang.can = counter_now("Enamorang");
	c_enamorang.run = "wanderer_now_run";
	return c_enamorang;
}

copier c_fax() {
	copier c_fax;
	c_fax.type = "other";
	c_fax.source = "Clan VIP Lounge key";
	c_fax.copier = $item[photocopied \monster];
	c_fax.have = $item[Clan VIP Lounge key].have();
	c_fax.property = get_property("_photocopyUsed");
	c_fax.used = c_fax.property.to_boolean();
	c_fax.mob = get_property("photocopyMonster");
	c_fax.target = camera_monster_string();
	c_fax.mob_check = c_fax.target == c_fax.mob;
	c_fax.source_condition = !c_fax.used && c_fax.have;
	c_fax.cost = 0;
	c_fax.worth = true;
	c_fax.prep = "c_fax_prep";
	c_fax.combat_could = false;
	c_fax.combat_can = false;
	c_fax.can = !c_fax.used && c_fax.mob_check;
	return c_fax;
}

copier c_painting() {
	copier c_painting;
	c_painting.type = "item";
	c_painting.source = "alpine watercolor set";
	c_painting.copier = $item[none];
	c_painting.have = convert_have(c_painting.type, c_painting.source);
	c_painting.property = get_property("_chateauMonsterFought");
	c_painting.used =  c_painting.property.to_boolean();
	c_painting.mob = get_property("chateauMonster");
	c_painting.target = "Black Crayon Crimbo Elf";
	c_painting.mob_check = c_painting.target == c_painting.mob;
	c_painting.source_condition = !c_painting.used && !c_painting.mob_check;
	c_painting.cost = 5000;
	c_painting.worth = true;
	c_painting.combat_could = c_painting.have;
	c_painting.combat_can = !c_painting.mob_check && c_painting.combat_could; // Not condition because we can set up for next day
	c_painting.can = !c_painting.used && c_painting.mob_check;
	c_painting.run = "c_painting_run";
	return c_painting;
}

copier c_photocopier() {
	copier c_photocopier;
	c_photocopier.type = "item";
	c_photocopier.source = "portable photocopier";
	c_photocopier.copier = $item[photocopied \monster];
	c_photocopier.have = convert_have(c_photocopier.type, c_photocopier.source);
	c_photocopier.property = get_property("_photocopyUsed");
	c_photocopier.used = c_photocopier.property.to_boolean();
	c_photocopier.mob = get_property("photocopyMonster");
	c_photocopier.target = camera_monster_string();
	c_photocopier.mob_check = c_photocopier.target == c_photocopier.mob;
	c_photocopier.source_condition = !c_photocopier.used && !$item[Clan VIP Lounge key].have();
	c_photocopier.cost = $item[portable photocopier].mall_price();
	c_photocopier.worth = c_photocopier.cost < c_photocopier.target.get_worth();
	c_photocopier.combat_could = !c_photocopier.copier.have() && c_photocopier.worth && c_photocopier.have;
	c_photocopier.combat_can = c_photocopier.source_condition && c_photocopier.combat_could;
	c_photocopier.can = !c_photocopier.used && c_photocopier.mob_check;
	return c_photocopier;
}

copier c_printscreen() {
	copier c_printscreen;
	c_printscreen.type = "item";
	c_printscreen.source = "print screen button";
	c_printscreen.copier = $item[screencapped \monster];
	c_printscreen.have = convert_have(c_printscreen.type, c_printscreen.source);
	c_printscreen.property = "none";
	c_printscreen.used = false;
	c_printscreen.mob = get_property("screencappedMonster");
	c_printscreen.target = camera_monster_string();
	c_printscreen.mob_check = c_printscreen.target == c_printscreen.mob;
	c_printscreen.source_condition = convert_amount(c_printscreen.type, c_printscreen.source) > 0;
	c_printscreen.cost = $item[\print screen button].mall_price();
	c_printscreen.worth = c_printscreen.cost < c_printscreen.target.get_worth();
	c_printscreen.combat_could = !c_printscreen.copier.have() && c_printscreen.worth && c_printscreen.have;
	c_printscreen.combat_can = c_printscreen.source_condition && c_printscreen.combat_could;
	c_printscreen.can = c_printscreen.mob_check;
	return c_printscreen;
}

copier c_putty() {
	copier c_putty;
	c_putty.type = "item";
	c_putty.source = "Spooky Putty Sheet";
	c_putty.copier = $item[Spooky Putty \Monster];
	c_putty.have = convert_have(c_putty.type, c_putty.source);
	c_putty.property = get_property("spookyPuttyCopiesMade");
	int used = c_putty.property.to_int();
	int used_ext = get_property("_raindohCopiesMade").to_int();
	int total = used + used_ext;
	c_putty.used = used > 4;
	c_putty.mob = get_property("spookyPuttyMonster");
	c_putty.target = camera_monster_string();
	c_putty.mob_check = c_putty.target == c_putty.mob;
	c_putty.source_condition = !c_putty.used && total < 6;
	c_putty.cost = 0;
	c_putty.worth = true;
	c_putty.combat_could = !c_putty.copier.have() && c_putty.have;
	c_putty.combat_can = c_putty.source_condition && c_putty.combat_could;
	c_putty.can = c_putty.source_condition && c_putty.mob_check;
	return c_putty;
}

copier c_raindoh() {
	copier c_raindoh;
	c_raindoh.type = "item";
	c_raindoh.source = "Rain-Doh black box";
	c_raindoh.copier = $item[Rain-Doh box full of \monster];
	c_raindoh.have = convert_have(c_raindoh.type, c_raindoh.source);
	c_raindoh.property = get_property("_raindohCopiesMade");
	int used = c_raindoh.property.to_int();
	int used_ext = get_property("spookyPuttyCopiesMade").to_int();
	int total = used + used_ext;
	c_raindoh.used = used > 4;
	c_raindoh.mob = get_property("rainDohMonster");
	c_raindoh.target = camera_monster_string();
	c_raindoh.mob_check = c_raindoh.target == c_raindoh.mob;
	c_raindoh.source_condition = !c_raindoh.used && total < 6;
	c_raindoh.cost = 0;
	c_raindoh.worth = true;
	c_raindoh.combat_could = !c_raindoh.copier.have() && c_raindoh.have;
	c_raindoh.combat_can = c_raindoh.source_condition && c_raindoh.combat_could;
	c_raindoh.can = c_raindoh.source_condition && c_raindoh.mob_check;
	return c_raindoh;
}

copier c_romantic() {
	copier c_romantic;
	c_romantic.counter = "Romantic";
	c_romantic.type = "skill";
	c_romantic.source = romantic_skill_today_get();
	c_romantic.copier = $item[none];
	c_romantic.have = convert_have(c_romantic.type, c_romantic.source);
	c_romantic.property = get_property("romanticTarget");
	c_romantic.used = c_romantic.property != "";
	c_romantic.mob = get_property("romanticTarget");
	c_romantic.target = camera_monster_string();
	c_romantic.mob_check = c_romantic.target == c_romantic.mob;
	c_romantic.source_condition = !c_romantic.used;
	c_romantic.cost = 0;
	c_romantic.worth = true;
	// c_romantic.prep = romantic_fam_today().use();
	c_romantic.combat_could = false; // c_romantic.source_condition;
	c_romantic.combat_can = false;
	c_romantic.can = false; // c_romantic.source_condition;
	c_romantic.run = ""; //convert_use(c_romantic.type, c_romantic.source);
	return c_romantic;
}

copier c_sculpture() {
	copier c_sculpture;
	c_sculpture.type = "item";
	c_sculpture.source = "unfinished ice sculpture";
	c_sculpture.copier = $item[ice sculpture];
	c_sculpture.have = convert_have(c_sculpture.type, c_sculpture.source);
	c_sculpture.property = get_property("_iceSculptureUsed");
	c_sculpture.used = c_sculpture.property.to_boolean();
	c_sculpture.mob = get_property("iceSculptureMonster");
	c_sculpture.target = camera_monster_string();
	c_sculpture.mob_check = c_sculpture.target == c_sculpture.mob;
	c_sculpture.source_condition = !c_sculpture.used;
	c_sculpture.cost = ($item[snow berries].mall_price() * 3) + ($item[ice harvest].mall_price() * 3);
	c_sculpture.worth = c_sculpture.cost < c_sculpture.target.get_worth();
	c_sculpture.combat_could = !c_sculpture.copier.have() && c_sculpture.worth && c_sculpture.have;
	c_sculpture.combat_can = c_sculpture.source_condition && c_sculpture.combat_could;
	c_sculpture.can = !c_sculpture.used && c_sculpture.mob_check;
	return c_sculpture;
}

copier c_taffy() {
	copier c_taffy;
	c_taffy.type = "item";
	c_taffy.source = "pulled green taffy";
	c_taffy.copier = $item[envyfish egg];
	c_taffy.have = convert_have(c_taffy.type, c_taffy.source);
	c_taffy.property = get_property("_envyfishEggUsed");
	c_taffy.used = c_taffy.property.to_boolean();
	c_taffy.mob = get_property("envyfishMonster");
	c_taffy.target = camera_monster_string();
	c_taffy.mob_check = c_taffy.target == c_taffy.mob;
	c_taffy.source_condition = my_location().environment == "underwater" && !c_taffy.used;
	c_taffy.cost = $item[pulled green taffy].mall_price();
	c_taffy.worth = c_taffy.cost < c_taffy.target.get_worth();
	c_taffy.combat_could = !c_taffy.copier.have() && c_taffy.worth && c_taffy.have;
	c_taffy.combat_can = c_taffy.source_condition && c_taffy.combat_could;
	c_taffy.can = !c_taffy.used && c_taffy.mob_check;
	return c_taffy;
}

copier [int] copiers() {
	copier [int] copiers;
	copiers[0] = c_digitize();
	copiers[1] = c_enamorang();
	copiers[2] = c_romantic();
	copiers[3] = c_taffy();
	copiers[4] = c_putty();
	copiers[5] = c_raindoh();
	copiers[6] = c_4d_camera();
	copiers[7] = c_painting();
	copiers[8] = c_printscreen();
	copiers[9] = c_sculpture();
	copiers[10] = c_fax();
	copiers[11] = c_photocopier();
	return copiers;
}

boolean	c_digitize_prep(copier c) {
	return false;
}

boolean	c_fax_prep(copier c) {
	return c.source_condition && faxbot(c.target.to_monster(), "CheeseFax");
}

boolean c_painting_run(copier c) {
	if (c.mob == "Black Crayon Crimbo Elf" && $familiar[Robortender].try_equip()) alternative_outfit().change_outfit();
	visit_url("place.php?whichplace=chateau&action=chateau_painting");
	run_combat();
	return get_property("_chateauMonsterFought").to_boolean();
}

boolean prep(copier c) {
	if (c.type == "item") return !c.copier.have() && c.worth && convert_fetch(c.type, c.source);
	if (c.type == "other") {
		string prep = c.prep;
		return call boolean prep(c);
	}
	return false;
}

void copier_prep() {
	foreach i, c in copiers() {
		print("Copier " + c.to_string() + " prep = " + c.prep(), "purple");
	}
}

item [int] copier_combat_items(monster mob) {
	item [int] copier_combat_items;
	foreach i, c in copiers() {
		if (c.type == "item" && c.target.to_monster() == mob && c.combat_can) copier_combat_items[copier_combat_items.count()] = c.source.convert_item();
	}
	return copier_combat_items;
}

void copier_combat_item_run(int rnd, monster mob, int hp_threshold) {
	item [int] funks;
	foreach i, c in copier_combat_items(mob) {
		if (monster_hp() < hp_threshold) return;
		if ($skill[Ambidextrous Funkslinging].have()) {
			funks[funks.count()] = c;
			if (funks.count() == 2) {
				print("Throwing a " + funks[0].to_string() + " and a " + funks[1].to_string() + ".", "purple");
				throw_items(funks[0], funks[1]);
				funks.clear();
				rnd++;
			}
		} else { // No funkslinging
			funks[funks.count()] = c;
			print("Throwing a " + funks[0].to_string() + ".", "purple");
			throw_item(funks[0]);
			rnd++;
		}
	}
	if (funks.count() == 1) { // One item left in the queue
		print("Throwing a " + funks[0].to_string() + ".", "purple");
		throw_item(funks[0]);
		rnd++;
	}
}

boolean run(copier c) {
	if (c.copier != $item[none]) {
		print("Using a " + c.copier.to_string() + " to fight a " + c.mob + "!", "purple");
		return c.copier.use();
	}
	string run = c.run;
	return call boolean run(c);
}

boolean copier_run() {
	foreach i, c in copiers() {
		if (c.can) return c.run();
	}
	return false;
}
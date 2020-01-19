script "aen_utils.ash";

import "aen_shortcuts.ash";

void smart_equip(item it) {
	slot sl = it.to_slot();
	if (sl != $slot[acc1]) equip(it);

	// We could do something smart here but I don't know what!
	// For now we'll try to juggle acc3 all the time
	equip($slot[acc3], it);

	if (!have_equipped(it)) abort("Could not equip " + it.to_string() + " for some reason");
}

boolean buy_until(int amt, item it, int maxprice) {
	amt -= item_amount(it);
	if(amt > 0) {
		return buy(amt, it, maxprice) < amt;
	}
	return true;
}

boolean buy_until(int amt, item it) {
	return buy_until(amt, it, 500);
}

// TODO needs categorisation 
/*boolean use(item it) {
	return use(1, it);
}*/

boolean use(int amt, skill skl) {
	return(use_skill(amt, skl));
}

boolean use(skill skl) {
	return(use_skill(1, skl));
}

boolean have(item it) {
	return it.item_amount() > 0;
}

boolean have(familiar fam) {
	return fam.have_familiar();
}

boolean have(skill skl) {
	return skl.have_skill();
}

boolean have(effect eff) {
	return eff.have_effect() > 0;
}

boolean avail(item it) {
	return it.available_amount() > 0;
}

boolean equipped(item it) {
	return it.have_equipped();
}

int amt(item it) {
	return item_amount(it);
}

boolean wield(slot sl, item it) {
	if (it.available_amount() > 0) equip(sl, it);
	return it.equipped_amount() > 0;
}

boolean wield(item it) {
	if (it.available_amount() > 0) equip(it);
	return it.equipped_amount() > 0;
}

// @TODO is this awful?

slot equipped_slot(item it) {
	if (!it.equipped()) return $slot[none];
	if (it.to_slot() == acc1) {
		foreach sl in $slots[acc1, acc2, acc3] {
			if (equipped_item(sl) == it) return sl;
		}
	}
	if (it.to_slot() == weapon) {
		foreach sl in $slots[weapon, off-hand] {
			if (equipped_item(sl) == it) return sl;
		}
	}
	return it.to_slot();
}

void juggle_scorpions(int b) {
	int a = $item[bowl of scorpions].item_amount();
	int c = b - a;
	if(a > b) {
		c = -c;
		put_closet(c, $item[bowl of scorpions]);
	} else if(a < b) {
		take_closet(c, $item[bowl of scorpions]);
	}
}

void juggle_scorpions() {
	int a = $item[bowl of scorpions].item_amount();
	int b = get_property("_drunkPygmyBanishes").to_int();
	int c = b - a;
	if(a > b) {
		c = -c;
		put_closet(c, $item[bowl of scorpions]);
	} else if(a < b) {
		take_closet(c, $item[bowl of scorpions]);
	}
}

boolean fetch(item it) {
	if (!it.have()) {
		if (it.shop_amount() > 0) return take_shop(1, it);
		if (!it.avail()) return false;
		if (it.closet_amount() > 0) return take_closet(1, it);
		if (it.display_amount() > 0) return take_display(1, it);
		if (it.storage_amount() > 0) return take_storage(1, it);
		if (it.equipped()) {
			slot it_slot = it.equipped_slot();
			return equip(it_slot, $item[none]);
		}
	}
	return it.have();
}

boolean try_equip(slot sl, item it) {
	if(it.equipped()) {
		slot where = it.equipped_slot();
		if(where != sl) {
			equip(sl, $item[None]);
		} else {
			return true;
		}
	} else if(!it.have()) {
		if (it.shop_amount() > 0) {
			take_shop(1, it);
		} else if (!it.avail()) {
			return false;
		} else if (it.closet_amount() > 0) {
			take_closet(1, it);
		} else if (it.display_amount() > 0) {
			take_display(1, it);
		} else if (it.storage_amount() > 0) {
			take_storage(1, it);
		}
	}
	return equip(sl, it);
}

boolean try_equip(item it) {
	if(it.have_equipped()) return true;
	if(!it.have()) {
		if (it.shop_amount() > 0) {
			take_shop(1, it);
		} else if (!it.avail()) {
			return false;
		} else if (it.closet_amount() > 0) {
			take_closet(1, it);
		} else if (it.display_amount() > 0) {
			take_display(1, it);
		} else if (it.storage_amount() > 0) {
			take_storage(1, it);
		}
	}
	return it.equip();
}

boolean try_equip(familiar fam) {
	if(!fam.have_familiar()) return false;
	if(my_familiar() == fam) return true;
	return fam.use_familiar();
}

boolean try_use(int amt, item it) {
	if(!it.have()) {
		if (it.shop_amount() > 0) {
			take_shop(1, it);
		}	else if (!it.avail()) {
			return false;
		} else if (it.closet_amount() > 0) {
			take_closet(1, it);
		} else if (it.display_amount() > 0) {
			take_display(1, it);
		} else if (it.storage_amount() > 0) {
			take_storage(1, it);
		}
	} 
	return use(amt, it);
}

boolean try_use(item it) {
	return try_use(1, it);
}

boolean use(familiar fam) {
	return fam.use_familiar();
}

int total_weight(familiar fam) {
	int a = fam.familiar_weight();
	int b = weight_adjustment();
	int c = a + b;
	return c;
}

int max_age_price(item it) {
    if (it.historical_age() > 3) return it.mall_price();
    return it.historical_price();
}

boolean effect_active(effect eff) {
	return eff.have_effect() > 0;
}

boolean can_skill(int amt, skill skl) {
	return (skl.have() && have_effect(skl.to_effect()) < amt && mp_cost(skl) < my_mp());
}

boolean can_skill(skill skl) {
	return (can_skill(1, skl));
}

boolean rebalance(int amt, int casts, skill skl) {
	if (can_skill(amt, skl)) return use_skill(casts, skl);
	return false;
}

boolean rebalance(int casts, skill skl) {
	if (can_skill(skl)) return use_skill(casts, skl);
	return false;
}

boolean rebalance(skill skl) {
	if (can_skill(skl)) return use_skill(1, skl);
	return false;
}

string plural(item it, int q) {
	if (q == 1) return "1 " + it.to_string();
	return q + " " + it.plural;
}

string temp_prefix = "aen_";

void set_temp_property(string prop, string value) {
	string backup_prop = temp_prefix + prop;
	if (!property_exists(backup_prop)) {
		string backup = get_property(prop);
		set_property(backup_prop, backup);
	}
	set_property(prop, value);
}

void set_temp_properties(string [string] propValues) {
	foreach prop, value in propValues {
		set_temp_property(prop, value);
	}
}

void restore_temp_property(string prop) {
	string backup_prop = temp_prefix + prop;
	string backup = get_property(backup_prop);
	set_property(prop, backup);
	remove_property(backup_prop);
}

void restore_temp_properties(boolean [string] props, boolean includes_prefix) {
	foreach prop in props {
		if (includes_prefix) prop = prop.substring(temp_prefix.length());
		restore_temp_property(prop);
	}
}

void restore_temp_properties(boolean [string] props) {
	restore_temp_properties(props, false);
}

void restore_temp_properties() {
	restore_temp_properties(get_all_properties(temp_prefix, false), true);
}

void set_temp_choice(int choice, int value) {
    set_temp_property("choiceAdventure" + choice, value.to_string());
}

void set_temp_choices(int [int] choiceValues) {
    foreach choice, value in choiceValues {
        set_temp_choice(choice, value);
    }
}

void restore_temp_choice(int choice) {
	restore_temp_property("choiceAdventure" + choice);
}

void try_skill(skill sk, int times) {
	if (!sk.have_skill()) return;
	use_skill(times, sk);
}

void try_skill(skill sk) {
	sk.try_skill(1);
}

//Consumption
int stomach_remaining() {
	return fullness_limit() - my_fullness();
}

int liver_remaining() {
	return inebriety_limit() - my_inebriety();
}

int spleen_remaining() {
	return spleen_limit() - my_spleen_use();
}

int to_int(stat s) {
	switch (s) {
		case $stat[Muscle]: return 0;
		case $stat[Mysticality]: return 1;
		case $stat[Moxie]: return 2;
		default: return -1;
	}
}

void optimal_consumption() {
	if (get_campground() contains mayo_clinic) {
		buy_until(inebriety_limit() + 2, $item[Mayodiol]);
		while (liver_remaining() > 0) {
			if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
				&& reverse_numberology(0,0) contains 14) {
				cli_execute("numberology 14");
				continue;
			}
			$item[Mayodiol].use();
			$item[Lucky Surprise Egg].eatsilent();
		}
	}
	if(pantsgiving.avail() && get_property("_pantsgivingFullness").to_int() <= 1) {
		while (stomach_remaining() > 0) {
			if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
				&& reverse_numberology(0,0) contains 14) {
				cli_execute("numberology 14");
				continue;
			}
			$item[Lucky Surprise Egg].eatsilent();
		}
	} else {
		while (stomach_remaining() > 1) {
			if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
				&& reverse_numberology(0,0) contains 14) {
				cli_execute("numberology 14");
				continue;
			}
			$item[Lucky Surprise Egg].eatsilent();
		}
	}
}
	
void optimal_stooper() {
	if(!$familiar[stooper].have()) abort("Acquire a stooper.");
	$familiar[stooper].use();
	while(my_inebriety() < inebriety_limit() + 1) {
		if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
		&& reverse_numberology(0,0) contains 14) cli_execute("numberology 14");
		use(1, $item[Mayodiol]);
		eatsilent(1, $item[Lucky Surprise Egg]);
	}
	eatsilent(1, $item[Lucky Surprise Egg]);
}

void drone() {
	if (have_equipped($item[Crown of Thrones]) && my_enthroned_familiar() != $familiar[Warbear Drone]) {
		enthrone_familiar($familiar[Warbear Drone]);
	} else if (have_equipped($item[Buddy Bjorn]) && my_bjorned_familiar() != $familiar[Warbear Drone]) {
		bjornify_familiar($familiar[Warbear Drone]);
	}
}

void set_choices() {

	int [int] setChoice;
	setChoice[163] = 4; // Melvil Dewey Would Be Ashamed
	setChoice[201] = 2; // Home, Home in the Range
	setChoice[205] = 2; // Van, Damn
	setChoice[291] = 1; // A Tight Squeeze
	setChoice[294] = 1; // Maybe It's a Sexy Snake!
	setChoice[781] = 6; // Earthbound and Down
	setChoice[888] = 4; // Take a Look, it's in a Book! (Rise)
	setChoice[889] = 5; // Take a Look, it's in a Book! (Fall)
	setChoice[1203] = 4; // Midnight in the Civic Center;
	setChoice[1208] = -1; // Upscale Noon; 9 is quit
	setChoice[1209] = 1; // Upscale Midnight
	setChoice[1222] = 0; // The Tunnel of L.O.V.E.
	setChoice[1223] = 0; // L.O.V. Entrance
	setChoice[1224] = 0; // L.O.V. Equipment Room
	setChoice[1225] = 0; // L.O.V. Engine Room
	setChoice[1226] = 0; // L.O.V. Emergency Room
	setChoice[1227] = 0; // L.O.V. Elbow Room
	setChoice[1228] = 0; // L.O.V. Emporium
	setChoice[1236] = 6; // Space Cave
	setChoice[1237] = 6; // A Simple Plant
	setChoice[1238] = 6; // A Complicated Plant
	setChoice[1239] = 6; // What a Plant!
	setChoice[1240] = 6; // The Animals, The Animals
	setChoice[1241] = 6; // Buffalo-Like Animal, Won't You Come Out Tonight
	setChoice[1242] = 6; // House-Sized Animal
	setChoice[1243] = 1; // Interstellar Trade
	setChoice[1244] = 1; // Here There Be No Spants
	setChoice[1245] = 1; // Recovering the Satellite
	setChoice[1246] = 6; // Land Ho
	setChoice[1247] = 6; // Half The Ship it Used to Be
	setChoice[1248] = 6; // Paradise Under a Strange Sun
	setChoice[1249] = 6; // That's No Moonlith, it's a Monolith!
	setChoice[1250] = 6; // I'm Afraid It's Terminal
	setChoice[1251] = 6; // Curses, a Hex
	setChoice[1252] = 6; // Time Enough at Last
	setChoice[1253] = 6; // Mother May I
	setChoice[1254] = 6; // Please Baby Baby Please
	setChoice[1255] = 1; // Cool Space Rocks
	setChoice[1256] = 1; // Wide Open Spaces
	setChoice[1310] = 0; // Granted a Boon
	setChoice[1322] = 2; // The Beginning of the Neverend
	setChoice[1324] = 5; // It Hasn't Ended, It's Just Paused
	setChoice[1340] = 1; // Is There A Doctor In The House?
	setChoice[1341] = 1; // A Pound of Cure

	foreach choice_number, value in setChoice {
		set_property("choiceAdventure" + choice_number, value);
	}

}

boolean change_outfit(string outfitName) { // @TODO: Clean up; possibly add familiar and bjorn/throne stuff here
	boolean success = cli_execute("outfit " + outfitName);
	if (success) return true;

	foreach ix, it in outfit_pieces(outfitName) {
    if (it.equipped_amount() + it.item_amount() > 0) continue;
		cli_execute("try; fold " + it.name);
    cli_execute("try; acquire " + it.name);
		if (!it.have()) abort("Couldn't get " + it.name);
	}
  return cli_execute("outfit " + outfitName);
}

void multi_fight() {
    while(in_multi_fight()) run_combat();
    if(choice_follows_fight()) run_choice(-1);
}
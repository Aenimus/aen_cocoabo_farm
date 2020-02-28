script "aen_utils.ash";

import "aen_shortcuts.ash";
import "aen_item_groups.ash";

buffer get_funky(item [int] funks, item it) {
	buffer b;
	if  (item_amount(it) == 0) return b;
	funks[count(funks)] = it;
	if  (count(funks) == 2) {
		b = throw_items(funks[0], funks[1]);
		clear(funks);
	}
	return b;
}

string plural(item it, int qty) {
	if (qty == 1) return "1 " + it.to_string();
	return qty + " " + it.plural;
}

boolean use(int amt, skill skl) {
	return(use_skill(amt, skl));
}

boolean use(skill skl) {
	return(use_skill(1, skl));
}

boolean use(familiar fam) {
	return fam.use_familiar();
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

void smart_equip(item it) {
	slot sl = it.to_slot();
	if (sl != $slot[acc1]) equip(it);

	// We could do something smart here but I don't know what!
	// For now we'll try to juggle acc3 all the time
	equip($slot[acc3], it);

	if (!it.equipped()) abort("Could not equip " + it.to_string() + " for some reason");
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

boolean closet_until(int target, item it) {
	int current = it.item_amount();
	if (current == target) return true;
	if (target < 0) target = (current + it.closet_amount());
	int to_move = target - current;
	if (to_move < 0) return put_closet(-to_move, it);
	if (to_move > it.closet_amount()) return false;
	return take_closet(to_move, it);
}

boolean juggle_scorpions(int target) {
	return closet_until(target, $item[bowl of scorpions]);
}

boolean juggle_scorpions() {
	return closet_until(get_property("_drunkPygmyBanishes").to_int(), $item[bowl of scorpions]);
}

boolean fetch(item it, boolean store) {
	cli_execute("try; fold " + it.to_string());
	if (it.have()) return true;
	if (store && it.shop_amount() > 0) return take_shop(1, it);
	if (it.closet_amount() > 0) return take_closet(1, it);
	if (it.display_amount() > 0) return take_display(1, it);
	if (it.storage_amount() > 0) return take_storage(1, it);
	if (it.equipped()) {
		slot it_slot = it.equipped_slot();
		return equip(it_slot, $item[none]);
	}
	print("Could not fetch: " + it.to_string() + ".", "red");
	return false;
}

boolean fetch(item it) {
	cli_execute("try; fold " + it.to_string());
	if (it.have()) return true;
	if (it.shop_amount() > 0) return take_shop(1, it);
	if (it.closet_amount() > 0) return take_closet(1, it);
	if (it.display_amount() > 0) return take_display(1, it);
	if (it.storage_amount() > 0) return take_storage(1, it);
	if (it.equipped()) {
		slot it_slot = it.equipped_slot();
		return equip(it_slot, $item[none]);
	}
	print("Could not fetch: " + it.to_string() + ".", "red");
	return false;
}

boolean try_equip(slot sl, item it) {
	if (it.equipped()) {
		slot where = it.equipped_slot();
		if(where == sl) return true;
		equip(sl, $item[None]);
	}
	cli_execute("try; fold " + it.to_string());
	if (!it.have()) {
		if (it.shop_amount() > 0) take_shop(1, it);
		else if (it.closet_amount() > 0) take_closet(1, it);
		else if (it.display_amount() > 0) take_display(1, it);
		else if (it.storage_amount() > 0) take_storage(1, it);
		else {
			print("You do not have: " + it.to_string() + ".", "red");
			return false;
		}
	}
	return equip(sl, it);
}

boolean try_equip(item it) {
	if (it.equipped()) return true;
	cli_execute("try; fold " + it.to_string());
	if (!it.have()) {
		if (it.shop_amount() > 0) take_shop(1, it);
		else if (it.closet_amount() > 0) take_closet(1, it);
		else if (it.display_amount() > 0) take_display(1, it);
		else if (it.storage_amount() > 0) take_storage(1, it);
		else {
			print("You do not have: " + it.to_string() + ".", "red");
			return false;
		}
	}
	return it.equip();
}

boolean try_equip(familiar fam) {
	if(!fam.have_familiar()) return false;
	if(my_familiar() == fam) return true;
	return fam.use();
}

boolean try_use(int amt, item it) {
	if(!it.have()) {
		if (it.shop_amount() > 0) take_shop(1, it);
		else if (it.closet_amount() > 0) take_closet(1, it);
		else if (it.display_amount() > 0) take_display(1, it);
		else if (it.storage_amount() > 0) take_storage(1, it);
		else {
			print("You do not have: " + it.to_string() + ".", "red");
			return false;
		}
	}
	return use(amt, it);
}

boolean try_use(item it) {
	return try_use(1, it);
}

boolean try_use(skill skl) {
	if (skl.have()) return skl.use();
	return false;
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

void optimal_eat() {
	while (stomach_remaining() > 1) {
		if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
			&& reverse_numberology(0,0) contains 14) {
			cli_execute("numberology 14");
			continue;
		}
		if (!$effect[Thanksgetting].have()) $item[green bean casserole].eatsilent();
		$item[Spooky Surprise Egg].eatsilent();
	}
}

void optimal_consumption() {
	if (get_campground() contains mayo_clinic) {
		buy_until(inebriety_limit() + 2, $item[Mayodiol], 1000);
		while (liver_remaining() > 0 && stomach_remaining() > 0) {
			if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
				&& reverse_numberology(0,0) contains 14) {
				cli_execute("numberology 14");
				continue;
			}
			$item[Mayodiol].use();
			$item[Spooky Surprise Egg].eatsilent();
		}
		if (my_fullness() == 17 && liver_remaining() > 0) abort("Something went wrong with Mayodiol.");
	}
	if(pantsgiving.avail() && get_property("_pantsgivingFullness").to_int() <= 1) {
		while (stomach_remaining() > 0) {
			if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
				&& reverse_numberology(0,0) contains 14) {
				cli_execute("numberology 14");
				continue;
			}
			$item[Spooky Surprise Egg].eatsilent();
		}
	} else {
		while (stomach_remaining() > 1) {
			if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
				&& reverse_numberology(0,0) contains 14) {
				cli_execute("numberology 14");
				continue;
			}
			$item[Spooky Surprise Egg].eatsilent();
		}
	}
}
	
void optimal_stooper() {
	if(!$familiar[stooper].have()) abort("Acquire a stooper.");
	$familiar[stooper].use();
	while (stomach_remaining() > 0 && my_inebriety() < inebriety_limit() + 1) {
		if (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()
		&& reverse_numberology(0,0) contains 14) cli_execute("numberology 14");
		use(1, $item[Mayodiol]);
		eatsilent(1, $item[Spooky Surprise Egg]);
	}
	while (stomach_remaining() > 0) eatsilent(1, $item[Spooky Surprise Egg]);
}

void drone() {
	if ($item[Crown of Thrones].equipped() && my_enthroned_familiar() != $familiar[Warbear Drone]) {
		$familiar[Warbear Drone].enthrone_familiar();
	} else if ($item[Buddy Bjorn].equipped() && my_bjorned_familiar() != $familiar[Warbear Drone]) {
		$familiar[Warbear Drone].bjornify_familiar();
	}
}

void set_choices() {

	int [int] set_choice;
	set_choice[163] = 4; // Melvil Dewey Would Be Ashamed
	set_choice[201] = 2; // Home, Home in the Range
	set_choice[205] = 2; // Van, Damn
	set_choice[291] = 1; // A Tight Squeeze
	set_choice[294] = 1; // Maybe It's a Sexy Snake!
	set_choice[781] = 6; // Earthbound and Down
	set_choice[888] = 4; // Take a Look, it's in a Book! (Rise)
	set_choice[889] = 5; // Take a Look, it's in a Book! (Fall)
	set_choice[1202] = 2; // Noon in the Civic Center
	set_choice[1203] = 4; // Midnight in the Civic Center;
	if ($item[sprinkles].item_amount() > 49) set_choice[1208] = 3; // Upscale Noon; 3 is gingerbread spice latte
	else set_choice[1208] = 9; // Upscale Noon; 9 is quit
	if ($item[sprinkles].item_amount() > 49) {
		set_choice[1209] = 2;
		set_choice[1214] = 0; // &TODO Assess this
	} else set_choice[1209] = 1; // Upscale Midnight
	set_choice[1222] = 0; // The Tunnel of L.O.V.E.
	set_choice[1223] = 0; // L.O.V. Entrance
	set_choice[1224] = 0; // L.O.V. Equipment Room
	set_choice[1225] = 0; // L.O.V. Engine Room
	set_choice[1226] = 0; // L.O.V. Emergency Room
	set_choice[1227] = 0; // L.O.V. Elbow Room
	set_choice[1228] = 0; // L.O.V. Emporium
	set_choice[1236] = 6; // Space Cave
	set_choice[1237] = 6; // A Simple Plant
	set_choice[1238] = 6; // A Complicated Plant
	set_choice[1239] = 6; // What a Plant!
	set_choice[1240] = 6; // The Animals, The Animals
	set_choice[1241] = 6; // Buffalo-Like Animal, Won't You Come Out Tonight
	set_choice[1242] = 6; // House-Sized Animal
	set_choice[1243] = 1; // Interstellar Trade
	set_choice[1244] = 1; // Here There Be No Spants
	set_choice[1245] = 1; // Recovering the Satellite
	set_choice[1246] = 6; // Land Ho
	set_choice[1247] = 6; // Half The Ship it Used to Be
	set_choice[1248] = 6; // Paradise Under a Strange Sun
	set_choice[1249] = 6; // That's No Moonlith, it's a Monolith!
	set_choice[1250] = 6; // I'm Afraid It's Terminal
	set_choice[1251] = 6; // Curses, a Hex
	set_choice[1252] = 6; // Time Enough at Last
	set_choice[1253] = 6; // Mother May I
	set_choice[1254] = 6; // Please Baby Baby Please
	set_choice[1255] = 1; // Cool Space Rocks
	set_choice[1256] = 1; // Wide Open Spaces
	set_choice[1310] = 0; // Granted a Boon
	set_choice[1322] = 2; // The Beginning of the Neverend
	set_choice[1324] = 5; // It Hasn't Ended, It's Just Paused
	set_choice[1340] = 1; // Is There A Doctor In The House?
	set_choice[1341] = 1; // A Pound of Cure

	foreach choice_number, value in set_choice {
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

int get_summons(item_group ig) {
	string summons = ig.summons;
	return call int summons();
}

int ig_libram_brick_summons() {
	return get_property("_brickoEyeSummons").to_int();
}

int ig_libram_favor_summons() {
	return get_property("_favorRareSummons").to_int();
}

int ig_libram_taffy_summons() {
	return get_property("_taffyRareSummons").to_int();
}

void multi_fight() {
    while (in_multi_fight()) run_combat();
    if (choice_follows_fight()) run_choice(-1);
}

void closet_stuff() {
	closet_until(0, $item[bowling ball]);
	closet_until(0, $item[sand dollar]);
	closet_until(0, $item[Special Seasoning]);
	closet_until(0, $item[ten-leaf clover]);
}

void escape_choice() {
	if (get_property("loveTunnelAvailable").to_boolean()) {
		visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel", false);
		run_choice(2);
		visit_url("main.php");
	} else {
		print("Need to think of a way to escape choices if one doesn't have Love Tunnel...");
	}
}

void initial_prompt() {
	foreach str in $strings[
		embezzler_outfit,
		cocoabo_outfit,
		alternative_outfit,
		pickpocket_outfit,
		max_weight_outfit,
		day_clan,
		rollover_clan,
		copy_monster,
		camera_monster,
	] {
		if (get_property("aen_" + str) == "") abort("Read and then run aen_initial.ash to set your outfits and other variables, first.");
	}
}

string alternative_outfit() {
	string check = get_property("aen_alternative_outfit");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string cocoabo_outfit() {
	string check = get_property("aen_cocoabo_outfit");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string embezzler_outfit() {
	string check = get_property("aen_embezzler_outfit");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string max_weight_outfit() {
	string check = get_property("aen_max_weight_outfit");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string pickpocket_outfit() {
	string check = get_property("aen_pickpocket_outfit");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string day_clan() {
	string check = get_property("aen_day_clan");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string camera_monster() {
	string check = get_property("aen_camera_monster");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string rollover_clan() {
	string check = get_property("aen_rollover_clan");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}

string copy_monster() {
	string check = get_property("aen_copy_monster");
	if (check == "") abort("Read and run aen_inital.ash first.");
	return check;
}
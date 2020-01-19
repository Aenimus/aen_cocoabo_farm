script "aen_optimalFarm.ash";

import "aen_utils.ash";
import "aen_bastille.ash";
import "aen_lov.ash";
import "aen_kramco.ash";
import "aen_nep.ash";
import "aen_saber.ash";
import "aen_snojo.ash";
import "aen_timespinner.ash";
import "aen_terminal.ash";
import "aen_volcano.ash";
import "aen_witchess.ash";

familiar optimal_familiar;
familiar run_familiar;
string copy_target = "Witchess Knight";
string camera_monster = "Knob Goblin Embezzler";
string copy_outfit = "Embezzler"; // What you would wear vs. the above
string chosen_libram = "Summon Dice";
string day_clan = "Piglets of Fate";
string roll_clan = "KirbyLlama's Private Dungeon Clan";
string farm_outfit = "OptimalFarm"; // Should be max weight with screege
string ff_outfit = "Free Fights";
string run_outfit = "Pickpocket"; // Should be max pickpocket chance

if ($familiar[Comma Chameleon].have()) {
	optimal_familiar = $familiar[Comma Chameleon];
} else { 
	optimal_familiar = $familiar[Ninja Pirate Zombie Robot];
}

if (stomp_boots.have()) {
	run_familiar = stomp_boots;
} else { 
	run_familiar = bander; // @TODO Handling if neither
}

if (!get_property("_aen_optimalSetup").to_boolean()) {

	set_property("_aen_optimalFarm", "true");
	print("Setting choice adventure values.", "green");
	set_choices();
	set_auto_attack(0);
	boolean did_loop = false;
	// set_property("_aen_optimalTurns", my_adventures());

	set_property("dontStopForCounters", "true");
	if(!vote_sticker.have() && !get_property("voteAlways").to_boolean()) abort("Go get your vote intrinsics, first.");
	
	if(get_property("horseryAvailable").to_boolean()) {
		if(get_property("_horsery") != "dark horse") {
			print("Setting the meat horse.", "green");
			string temp = visit_url("place.php?whichplace=town_right&action=town_horsery");
			temp = visit_url("choice.php?pwd=&whichchoice=1266&option=2");
		}
	}

	saber_upgrade();
	
	// Check state of copiers
	print("Checking that our copiers are primed.", "green");
	// @TODO Handling for people without
	if (get_property("spookyPuttyMonster") != copy_target && !sheet.fetch()) {
		abort("Check Spooky Putty sheet");
	}
	if (get_property("rainDohMonster") != copy_target && !b_box.fetch()) {
		abort("Check Rain-Doh black box");
	}
	
	cli_execute("/whitelist " + day_clan);
	
	if (vip_key.have() && !get_property("_aprilShower").to_boolean()) cli_execute("shower ice");
	
	while (kgb.have() && get_property("_kgbClicksUsed").to_int() < 22) cli_execute("briefcase b meat");
	
	if (get_property("_saberForceUses").to_int() != 0) set_property("_aen_PygmyAbort", "true");
	
	if ($familiar[Pocket Professor].have()) {
		$familiar[Pocket Professor].use();
		if (!$item[Pocket Professor memory chip].try_equip()) abort("Acquire Pocket Professor memory chip.");
		if (feast.fetch() && !contains_text(get_property("_feastedFamiliars"), "Pocket Professor")
			&& get_property("_feastUsed").to_int() < 5) {
			feast.try_use();
		}
	}
	
	optimal_familiar.use();
	if (my_familiar() == optimal_familiar && !contains_text(get_property("_mummeryMods"), "Meat")) {
		cli_execute("mummery meat");
	}
	
	// Asking whether the user has access to a PYEC
	if (pyec.fetch()) {
		set_property("_aen_havePYEC", "true");
	} else if (!get_property("_aen_havePYEC").to_boolean() && user_confirm("Do you have access to a PYEC?")) {
		set_property("_aen_havePYEC", "true");
	}
	
	if (get_property("_aen_havePYEC").to_boolean() && !get_property("expressCardUsed").to_boolean()) {
		maximize("MP, switch " + optimal_familiar, false);
		cli_execute("/cast * " + chosen_libram);
		if (!pyec.try_use()) abort("Missing PYEC.");
	}
	
	cli_execute("/cast * " + chosen_libram);

	optimal_consumption();

	if (!$item[burning paper crane].fetch()) cli_execute("create burning paper crane");
	if (get_property("_bastilleGames").to_int() < 1) bastille_batallion(3, 1, 3, 0);
	set_property("_aen_optimalSetup", "true");
	print("Checkpoint reached: _aen_optimalSetup is true.", "blue");
	
	// Volcoino
	volcano_tower(7);

}

// Stocking up on stuff here
if (!get_property("_aen_optimalStock").to_boolean()) {
	print("Buying supplies.", "green");
	if (!trav_trous.try_equip() && my_id() == 2273519) abort("Where are your damn trousers!?");
	
	take_closet(bworps.closet_amount(), bworps);
	
	// Copiers
	buy_until(1, $item[pulled green taffy], 1000);
	if (!$item[unfinished ice sculpture].avail()) {
		buy_until(3, $item[snow berries],3000);
		buy_until(3, $item[ice harvest], 3000);
		cli_execute("create unfinished ice sculpture");
	}

	// Misc
	buy_until(40, $item[Lucky Surprise Egg], 5000);
	buy_until(10, $item[BRICKO eye brick], 3000);
	buy_until(20, $item[BRICKO brick], 500);
	buy_until(3, $item[lynyrd snare], 1000);
	buy_until(40, $item[drum machine], 4000);
	buy_until(30, $item[gingerbread cigarette], 15000);
	buy_until(23, $item[bowl of scorpions], 500);
	buy_until(1, $item[burning newspaper], 9000);
	buy_until(1, $item[alpine watercolor set], 5000);
	buy_until(8, $item[4-d camera], 10000);
	
	cli_execute("create 10 BRICKO ooze");
	set_property("_aen_optimalStock", "true");
	print("Checkpoint reached: _aen_optimalStock is true.", "blue");
}

if (!get_property("_aen_optimalRuns").to_boolean()) {

	// Free run loop
	run_outfit.change_outfit();
	if (pantsgiving.avail() && !pantsgiving.have_equipped() && get_property("_pantsgivingCount").to_int() < 50) pantsgiving.try_equip();
	run_familiar.use();
	drone();
	hookah.try_equip();
	cli_execute("/cast * " + chosen_libram);
	boolean max_weight = false;
	while (!max_weight || get_property("_banderRunaways").to_int() < floor(run_familiar.total_weight()/5)) {
		if (get_property("_pantsgivingCount").to_int() < 50 &&get_property("_pantsgivingCount").to_int() > 4 
			&& stomach_remaining() > 0) $item[Lucky Surprise Egg].eatsilent();
		if (pantsgiving.equipped() && get_property("_pantsgivingCount").to_int() > 49) $item[wooly loincloth].try_equip();
		if (my_inebriety() > inebriety_limit()) abort("You are overdrunk.");
		if ($item[ten-leaf clover].have()) use($item[ten-leaf clover].item_amount(), $item[ten-leaf clover]);
		if ($item[sand dollar].have()) put_closet($item[sand dollar].item_amount(), $item[sand dollar]);
		if ($item[Special Seasoning].have()) put_closet($item[Special Seasoning].item_amount(), $item[Special Seasoning]);

		if (cracker.item_amount() < 10) abort("Acquire more divine crackers.");
		while (!max_weight && get_property("_banderRunaways").to_int() >= floor(run_familiar.total_weight()/5)) {
			if (!brogues.have_equipped() && try_equip(acc1, brogues)) continue;
			else if (!$item[recovered cufflinks].have_equipped() && try_equip(acc2, $item[recovered cufflinks])) continue;
			else if (!$item[Belt of Loathing].have_equipped() && try_equip(acc3, $item[Belt of Loathing])) continue;
			else if (!$item[repaid diaper].have_equipped() && try_equip(pants, $item[repaid diaper])) continue;
			else if (!saber.have_equipped() && try_equip(weapon, saber)) continue;
			else if (!$item[burning paper crane].have_equipped() && try_equip(off, $item[burning paper crane])) continue;
			else if (!$item[Stephen's lab coat].have_equipped() && try_equip(shirt, $item[Stephen's lab coat])) continue;
			else if (!$item[buddy bjorn].have_equipped() && try_equip(back, $item[buddy bjorn])) continue;
			else if (!$item[crumpled felt fedora].have_equipped() && try_equip(hat, $item[crumpled felt fedora])) continue;
			else if (!contains_text(get_property("_feastedFamiliars"), run_familiar) && feast.try_use()) continue;
			else if (!$item[snow suit].have_equipped() && try_equip(fam, $item[snow suit])) continue;
			max_weight = true;
		}
		
		if (get_property("_reflexHammerUsed").to_int() < 1) try_equip(acc1, doc_bag);
		else if (doc_bag.have_equipped() && get_property("_reflexHammerUsed").to_int() > 0) try_equip(acc1, $item[mime army infiltration glove]);
		if (get_property("_banderRunaways").to_int() >= floor(run_familiar.total_weight()/5)) continue;
		adv1($location[The Haunted Library], -1, "");
	}
	if (get_property("_banderRunaways").to_int() < 113) abort("Use 2 remaining runs."); // Questionable but OK for now
	set_property("_aen_optimalRuns", "true");
}

// Main fight Loop
while (get_property("_aen_optimalFarm").to_boolean() && my_inebriety() < inebriety_limit() + 1) {
	print("Initiating start of loop.", "purple");
	cli_execute("/cast * " + chosen_libram);
	farm_outfit.change_outfit();
	if ($item[buddy bjorn].have_equipped() && my_bjorned_familiar() != $familiar[misshapen animal skeleton]) $familiar[misshapen animal skeleton].bjornify_familiar();
	optimal_familiar.use();
	if (my_familiar() == $familiar[Comma Chameleon]) {
		// Checking whether a self-incremented counter can cause us only to refresh at 40+
		if (get_property("aen_commaFights").to_int() > 39) visit_url("charpane.php");
		if (get_property("commaFamiliar").to_string() != "Feather Boa Constrictor") {
			if (!$item[velvet choker].have()) abort("You have run out of chokers.");
			print("Boa-fying the comma chameleon.");
			visit_url("/inv_equip.php?pwd="+my_hash()+"&which=2&action=equip&whichitem=962");
			visit_url("charpane.php");
			set_property("aen_commaFights", 0);
		}
	}
	if ($item[ten-leaf clover].have()) use($item[ten-leaf clover].item_amount(), $item[ten-leaf clover]);
	if ($item[sand dollar].have()) put_closet($item[sand dollar].item_amount(), $item[sand dollar]);
	if ($item[bowling ball].have()) put_closet($item[bowling ball].item_amount(), $item[bowling ball]);
	if ($item[Special Seasoning].have()) put_closet($item[Special Seasoning].item_amount(), $item[Special Seasoning]);
	if (!$effect[Inscrutable Gaze].have()) $skill[Inscrutable Gaze].use();

	// LOVE Tunnel
	if (lov_can()) {
		lov_run();
		continue;
	}

	if (!get_property("_photocopyUsed").to_boolean()) {
		if (vip_key.have() && !$item[photocopied monster].have()) faxbot(camera_monster.to_monster(), "CheeseFax");
	
		if ($item[photocopied monster].have() && get_property("photocopyMonster") == camera_monster) {
			if (camera_monster == "Knob Goblin Embezzler") {
				copy_outfit.change_outfit();
				$skill[disco leer].use();
			}
			$item[photocopied monster].use();
			continue;
		}
	}
	
	if (get_property("rainDohMonster") == copy_target || get_property("spookyPuttyMonster") == copy_target) {
		if (get_property("_pocketProfessorLectures").to_int() < floor(square_root($familiar[Pocket Professor].total_weight())) + 2) $familiar[Pocket Professor].try_equip();
		if (my_familiar() == $familiar[Pocket Professor] && !$item[Pocket Professor memory chip].have_equipped()
			&& !$item[Pocket Professor memory chip].try_equip()) {
				abort("Missing Pocket Professor memory chip.");
		}
		if (get_property("spookyPuttyMonster") == copy_target) {
			$item[Spooky Putty Monster].use();
			continue;
		} else if (get_property("rainDohMonster") == copy_target) {
			$item[Rain-Doh box full of monster].use();
			continue;
		}
	}
	
	if (witchess_can()) {
		terminal_duplicate_prepare();
		witchess_run();
		cli_execute("terminal educate digitize");
		cli_execute("terminal educate extract");
		continue;
	}

	if (get_property("chateauMonster") == "Black Crayon Crimbo Elf" && !get_property("_chateauMonsterFought").to_boolean()
		&& $familiar[Robortender].try_equip()) {
		change_outfit(ff_outfit);
		visit_url("/place.php?whichplace=chateau&action=chateau_painting", false);
		run_combat();
		continue;
	}

	// Lynyrds; aenimusUseCCS == false
	if (get_property("_lynyrdSnareUses").to_int() < 3) {
		print("Fighting free lynyrd.", "green");
		$item[lynyrd snare].use();
		continue;
	}

	// God Lobster; aenimusUseCCS == false
	if (have($familiar[God Lobster]) && get_property("_godLobsterFights").to_int() < 3) {
		print("Fighting the God Lobster.", "green");
		change_outfit(ff_outfit);
		$familiar[God Lobster].use();
		$item[God Lobster's Crown].try_equip();
		visit_url("main.php?fightgodlobster=1");
		run_combat();
		visit_url("main.php");
		run_choice(2);
		continue;
	}

	// Eldritch Tentacles; aenimusUseCCS == false
	if (!get_property("_eldritchTentacleFought").to_boolean()) {
		print("Completing eldritch tentacle fights.", "green");
		visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
		if ($item[eldritch essence].have()) {
			run_choice(2);
		} else {
			run_choice(1);
		}
		run_combat();
		continue;
	}

	if ($skill[Evoke Eldritch Horror].have_skill() && !get_property("_eldritchHorrorEvoked").to_boolean()) {
		$skill[Evoke Eldritch Horror].use_skill();
		continue;
	}
	
	if (get_property("_brickoFights").to_int() < 10) {
		$item[BRICKO ooze].use();
		continue;
	}

	// Snojo
	if (snojo_free_can()) {
		snojo_free_run();
		if (snojo_fights() > 9) cli_execute("hottub");
		continue;
	}

	// Neverending Party
	if (nep_free_can()) {
		kramco.try_equip();
		nep_free_run();
		continue;
	}

	// DMT
	if ($familiar[Machine Elf].have() && get_property("_machineTunnelsAdv").to_int() < 5) {
		print("Completing Machine Tunnel fights.", "green");
		$familiar[Machine Elf].use();
		hookah.equip();
		adv1($location[The Deep Machine Tunnels], -1, "");
		continue;
	}

	if ($item[[glitch season reward name]].have() && get_property("_glitchMonsterFights").to_int() < 1) {
		visit_url("inv_eat.php?&which=1&whichitem=10207&pwd=" + my_hash());
		run_combat();
		continue;
	}

	if (get_property("_powerPillUses").to_int() < 20) {
		if ($item[The Jokester's gun].avail() && !get_property("_firedJokestersGun").to_boolean()) {
			$item[The Jokester's gun].try_equip();
		} else if (doc_bag.avail() && get_property("_chestXRayUsed").to_int() < 3) {
			try_equip(acc1, doc_bag);
		}
		$item[drum machine].use();
		continue;
	}

	if (get_property("_drunkPygmyBanishes").to_int() < 10) {
		if (!$item[bowl of scorpions].have()) juggle_scorpions();
		$item[Kramco Sausage-o-Matic&trade;].try_equip();
		// Needs an ice house check
		adv1($location[The Hidden Bowling Alley], -1, "");
		continue;
	}

	if (saber.avail()) {
		int banishes = get_property("_drunkPygmyBanishes").to_int();
		int forces = get_property("_saberForceUses").to_int();
		if (forces < 5) {
			if (get_property("_aen_pygmyAbort").to_boolean()) abort("Fewer than 5 forces is not currently supported.");
			if ((banishes == 10 && forces == 0) || (banishes == 12 && forces == 1) || (banishes == 14 && forces == 2)
				|| (banishes == 16 && forces == 3) || (banishes == 18 && forces == 4)) {
				saber.try_equip();
				if ($item[bowl of scorpions].have()) juggle_scorpions(0);
				set_property("aen_useForce", "true");
				adv1($location[The Hidden Bowling Alley], -1, ""); // Use the force
				continue;
			} else if ((banishes == 10 && forces == 1) || (banishes == 12 && forces == 2) || (banishes == 14 && forces == 3)
				|| (banishes == 16 && forces == 4)) {
				juggle_scorpions(2);
				adv1($location[The Hidden Bowling Alley], -1, ""); // First of three
				continue;
			} else if ((banishes == 11 && forces == 1) || (banishes == 13 && forces == 2) || (banishes == 15 && forces == 3)
				|| (banishes == 17 && forces == 4)) {
				juggle_scorpions(1);
				adv1($location[The Hidden Bowling Alley], -1, ""); // Second of three
				continue;
			} else if (banishes == 18 && forces == 5) {
				juggle_scorpions(3);
				adv1($location[The Hidden Bowling Alley], -1, "");
				continue;
			}
		} else if (banishes < 21) {
			if (!$item[bowl of scorpions].have()) juggle_scorpions(1);
			adv1($location[The Hidden Bowling Alley], -1, "");
			continue;
		}
	} else if (get_property("_drunkPygmyBanishes").to_int() < 11) {
		if (!$item[bowl of scorpions].have()) juggle_scorpions(1);
		adv1($location[The Hidden Bowling Alley], -1, "");
		continue;
	}
	
	// Gingerbread Upscale Retail District
	if ((get_property("gingerbreadCityAvailable").to_boolean() || get_property("_gingerbreadCityToday").to_boolean())
		&& get_property("_gingerbreadCityTurns").to_int() < 30) {
		if (!$item[gingerbread cigarette].have()) abort("Acquire some gingerbread cigarettes.");
		if (get_property("_gingerbreadCityTurns").to_int() == 19) {
			adv1($location[Gingerbread Civic Center], -1, "");
			continue;
		}
		if (get_property("gingerRetailUnlocked").to_boolean()) {
			adv1($location[Gingerbread Upscale Retail District], -1, "");
		} else {
			adv1($location[Gingerbread Civic Center], -1, "");
		}
		
		continue;
	}

	if (timespinner_can()) {
		timespinner_fight(1431);
		continue;
	}
	
	if (!get_property("_freePillKeeperUsed").to_boolean()) {
		visit_url("main.php?eowkeeper=1", false);
		visit_url("choice.php?whichchoice=1395&option=7&pwd=" + my_hash(), true);
		$skill[Disco Leer].use();
		copy_outfit.change_outfit();
		adv1($location[Cobb\'s Knob Treasury], -1, "");
	}

	if (!user_confirm("Have you fought 6 time pranks?")) abort("Acquire 6 time pranks.");
	
	if (kramco_can_grind_until(20));
	
	if ($item[Beach Comb].avail() && get_property("_freeBeachWalksUsed") < 11) {
		abort("Use your free beach walks.");
	}
	
	
	if (!get_property("_workshedItemUsed").to_boolean() && $item[portable Mayo Clinic].have()
		&& user_confirm("Change your workshed to the Mayo Clinic?")) {
			use(1, $item[portable Mayo Clinic]);
			
	}

	while (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()) {
		int check = get_property("_universeCalculated").to_int();
		cli_execute("numberology 14");
		if (check == get_property("_universeCalculated").to_int()) break;
	}

	if (stomach_remaining() > 0) {
		trav_trous.try_equip();
		optimal_consumption();
	}
	
	// optimal_stooper();

	foreach it in $items[tiny plastic Naughty Sorceress, tiny plastic Susie , tiny plastic Boris, tiny plastic Jarlsberg, tiny plastic Sneaky Pete] {
		if (it.have()) print("Congratulations! You obtained " + it.item_amount() + " " + it.to_string() + "!", "green");
	}
	
	while (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()) {
		int check = get_property("_universeCalculated").to_int();
		cli_execute("numberology 14");
		if (check == get_property("_universeCalculated").to_int()) abort("Stuck in the numberology loop.");
	}
	
	set_property("dontStopForCounters", "false");
	cli_execute("/whitelist " + roll_clan);
	set_property("_aen_optimalFarm", "false");
	print("Checkpoint reached: _aen_optimalFarm is false.", "blue");

}
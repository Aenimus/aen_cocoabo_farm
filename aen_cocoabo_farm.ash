script "aen_cocoabo_farm.ash";

import "aen_resources.ash";

// @TODO Property handling for these
string chosen_libram = libram_today();

// @TODO file
if (!get_property("_aen_run_familiar").to_boolean()) {
	if (stomp_boots.have()) set_property("_aen_run_familiar", stomp_boots.to_string());
	else set_property("_aen_run_familiar", bander.to_string());
}

familiar run_familiar = get_property("_aen_run_familiar").to_familiar();


// Stocking up on stuff here
if (!get_property("_aen_cocoabo_stock").to_boolean()) {
	print("Buying supplies.", "green");
	if (!trav_trous.try_equip() && my_id() == 2273519) abort("Where are your damn trousers!?");
	
	closet_until(-1, bworps);
	
	// Copiers
	if (!$item[unfinished ice sculpture].avail()) {
		buy_until(3, $item[snow berries], 3334);
		buy_until(3, $item[ice harvest], 3334);
		cli_execute("create unfinished ice sculpture");
	}

	// Misc
	buy_until(40, $item[Lucky Surprise Egg], 5000);
	buy_until(40, $item[Spooky Surprise Egg], 5000);
	buy_until(10, $item[BRICKO eye brick], 3000);
	buy_until(20, $item[BRICKO brick], 500);
	buy_until(3, $item[lynyrd snare], 1000);
	buy_until(40, $item[drum machine], 4000);
	buy_until(30, $item[gingerbread cigarette], 15000);
	buy_until(23, $item[bowl of scorpions], 500);
	buy_until(1, $item[burning newspaper], 15000);
	buy_until(1, $item[alpine watercolor set], 5000);
	buy_until(8, $item[4-d camera], 10000);
	buy_until(10, sgeea, 1000);
	
	if ($item[Spooky Surprise Egg].item_amount() < 40) {
		int eggs = $item[Spooky Surprise Egg].item_amount();
		cli_execute("acquire " + (40 - eggs) + " Spooky Surprise Egg");
	}
	
	cli_execute("create 10 BRICKO ooze");
	set_property("_aen_cocoabo_stock", "true");
	print("Checkpoint reached: _aen_cocoabo_stock is true.", "blue");
}

// Set Up
if (!get_property("_aen_cocoabo_setup").to_boolean()) {
	initial_prompt();
	set_property("_aen_cocoabo_farm", "true");
	print("Setting choice adventure values.", "purple");
	set_choices();
	set_auto_attack(0);
	
	cocoabo_today_run();
	libram_rare_run();
	chosen_libram = libram_today(true);
	
	// @TODO Automation for this
	if (vote_can()) vote_run();
	if(!vote_sticker.have() && get_property("voteAlways").to_boolean()) abort("Go get your vote intrinsics, first.");
	
	if (horsery_have()) horsery_run("dark");

	escape_choice();

	if (!saber_upgrade_run()) abort("Something went wrong when upgrading the saber.");
	
	optimal_eat(); //Eats to fullness -1.
	
	if (!pantsgiving.fetch() && user_confirm("Do you have access to some Pantsgiving?")) abort("Retrieve your Pantsgiving and rerun.");
	else if (!pantsgiving.have() && user_confirm("Do you wish to prevent all future Pantsgiving prompts?")) set_property("aen_no_pantsgiving", "true");
	
	// Check state of copiers
	print("Checking that our copiers are primed.", "green");
	// @TODO Handling for people without
	if (get_property("spookyPuttyMonster") != copy_monster() && !sheet.fetch()) {
		abort("Check Spooky Putty sheet");
	}
	if (get_property("rainDohMonster") != copy_monster() && !b_box.fetch()) {
		abort("Check Rain-Doh black box");
	}
	
	cli_execute("/whitelist " + day_clan());
	cli_execute("breakfast");
	
	if (get_property("_saberForceUses").to_int() != 0) set_property("_aen_pygmy_abort", "true");
	
	if ($familiar[Pocket Professor].use()) {
		if (!$item[Pocket Professor memory chip].try_equip()) abort("Acquire Pocket Professor memory chip.");
		$familiar[Pocket Professor].feast_run();
	}

	daily_aftercore();

	pyec_run();
			
	cli_execute("/cast * " + chosen_libram);
	
	if (get_property("getawayCampsiteUnlocked").to_boolean()) {
		while (get_property("timesRested").to_int() < total_free_rests()) visit_url("place.php?whichplace=campaway&action=campaway_tentclick");
	}

	if (!$item[burning paper crane].fetch()) cli_execute("create burning paper crane");
	if (bastille_can()) bastille_run($stat[Mysticality], $item[Brutal brogues], $effect[Bastille Braggadocio]);

	// Volcoino
	volcano_tower(7);
	
	data_costs_today_set(my_session_meat());
	set_property("_aen_cocoabo_setup", "true");
	print("Checkpoint reached: _aen_cocoabo_setup is true.", "blue");
}

if (!get_property("_aen_free_runs").to_boolean()) {
	if (!get_property("_aen_bander_runs").to_boolean()) {
		boolean max_weight = false;
		int max_runs;
		
		if (get_property("aen_max_runs").to_int() < 1) {
			max_weight_outfit().change_outfit();
			set_property("aen_max_runs", floor(run_familiar.total_weight()/5));
		}
		if (feast.fetch()) max_runs = get_property("aen_max_runs").to_int() + 2; // This value is saved from the previous day.
		else max_runs = get_property("aen_max_runs").to_int();
		run_familiar.use();
		hookah.try_equip();
		
		// Free run loop
		pickpocket_outfit().change_outfit();
		if (!get_property("aen_no_pantsgiving").to_boolean() && get_property("_pantsgivingCount").to_int() < 50) pantsgiving.try_equip();
		cli_execute("/cast * " + chosen_libram);
		while (get_property("_banderRunaways").to_int() < max_runs) {
			hookah_uneffect();
		
			if (get_property("_pantsgivingCount").to_int() < 50 &&  get_property("_pantsgivingCount").to_int() > 4 
				&& stomach_remaining() > 0) $item[Spooky Surprise Egg].eatsilent();
			if (pantsgiving.equipped() && get_property("_pantsgivingCount").to_int() > 49) $item[wooly loincloth].try_equip();
			if (my_inebriety() > inebriety_limit()) abort("You are overdrunk.");
			
			data_session_adv_update();
			data_adv_threshold_check();
			closet_stuff();

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
				set_property("aen_max_runs", floor(run_familiar.total_weight()/5));
			}
			
			if (!get_property("_stinkyCheeseBanisherUsed").to_boolean()) try_equip(acc1, $item[stinky cheese eye]);
			else if ($item[stinky cheese eye].equipped() && get_property("_stinkyCheeseBanisherUsed").to_boolean()) try_equip(acc1, $item[mime army infiltration glove]);
			adv1($location[The Haunted Library], -1, "");
			continue;
		}
		set_property("_aen_bander_runs", "true");
	}
	
	//banishes w/ sniff
	boolean all_runs = false;
	while (!all_runs) {
		data_session_adv_update();
		data_adv_threshold_check();
		cli_execute("/cast * " + chosen_libram);
		if (get_property("_latteBanishUsed").to_boolean() && get_property("_latteRefillsUsed").to_int() < 3) cli_execute("latte refill cajun pumpkin rawhide");
		pickpocket_outfit().change_outfit();
		if (!get_property("_vmaskBanisherUsed").to_boolean()) try_equip(acc1, $item[V for Vivala mask]);
		else if (get_property("_kgbTranquilizerDartUses").to_int() < 3) try_equip(acc1, kgb);
		else if (get_property("_reflexHammerUsed").to_int() < 3) try_equip(acc1, doc_bag);
		else if (!get_property("_latteBanishUsed").to_boolean()) $item[latte lovers member\'s mug].try_equip();
		else if (get_property("_navelRunaways").to_int() < 3) try_equip(acc1, navel);
		else if (get_property("_snokebombUsed").to_int() > 1) {
			all_runs = true;
			continue;
		}
		if (get_property("shrubGifts") == "meat" && !$effect[Everything Looks Red].have() && $familiar[Crimbo Shrub].have()) $familiar[Crimbo Shrub].use();
		else if (!$familiar[Artistic Goth Kid].use()) $familiar[none].use();
		adv1($location[The Haunted Library], -1, "");
		continue;
	}
		
	optimal_consumption();
	
	if (!get_property("_workshedItemUsed").to_boolean() && asdon.have() && user_confirm("Change your workshed to the Asdon Martin?")) {
		$item[Mayodiol].use(); // For later when we eat again
		asdon.use();
	}

	set_property("_aen_free_runs", "true");
}

// Main fight Loop
while (get_property("_aen_cocoabo_farm").to_boolean() && my_inebriety() < inebriety_limit() + 1) {

	print("Initiating start of loop.", "purple");
	cli_execute("/cast * " + chosen_libram);
	cocoabo_outfit().change_outfit();
	if ($item[buddy bjorn].have_equipped() && my_bjorned_familiar() != $familiar[misshapen animal skeleton]) $familiar[misshapen animal skeleton].bjornify_familiar();
	
	// Familiar Stuff
	cocoabo_today().use();
	comma_run("Feather Boa Constrictor");
	if (!cocoabo_exception()) helicopter.legion_equip();
	hookah_uneffect();
	
	// Adventure tracking and protection; meat tracking
	data_session_adv_update();
	data_session_meat_update();
	if (embezzlers_today() > 0) data_adv_threshold_check(5);
	else data_adv_threshold_check();

	if (!$effect[Inscrutable Gaze].have()) $skill[Inscrutable Gaze].use();
	closet_stuff();
		
	// Vote monster
	if(total_turns_played() % 11 == 1 && get_property("_voteFreeFights").to_int() < 3 && total_turns_played() != get_property("lastVoteMonsterTurn").to_int()) {
		if (try_equip(acc1, $item[&quot;I voted!&quot; sticker])) {
			adv1($location[The Haunted Kitchen], -1, "");
			continue;
		}
	}
	
	// LOVE Tunnel
	if (lov_can()) {
		lov_run();
		continue;
	}
	
	// @TODO file
	if (!get_property("_photocopyUsed").to_boolean()) {
		if (vip_key.have() && !$item[photocopied \monster].have()) faxbot(camera_monster().to_monster(), "CheeseFax");
		if ($item[photocopied monster].have() && get_property("photocopyMonster") == camera_monster()) {
			if (camera_monster() == "Knob Goblin Embezzler") embezzler_prep(); // @TODO handle this for all copiers
			$item[photocopied monster].use();
			continue;
		}
	}
		
	// @TODO file
	if (get_property("rainDohMonster") == copy_monster() || get_property("spookyPuttyMonster") == copy_monster()) {
		if (get_property("_pocketProfessorLectures").to_int() < floor(square_root($familiar[Pocket Professor].total_weight())) + 2) $familiar[Pocket Professor].try_equip();
		if (my_familiar() == $familiar[Pocket Professor] && !$item[Pocket Professor memory chip].have_equipped()
			&& !$item[Pocket Professor memory chip].try_equip()) {
				abort("Missing Pocket Professor memory chip.");
		}
		if (get_property("spookyPuttyMonster") == copy_monster()) {
			$item[Spooky Putty Monster].use();
			continue;
		} else if (get_property("rainDohMonster") == copy_monster()) {
			$item[Rain-Doh box full of monster].use();
			continue;
		}
	}
	
	// @TODO file
	if (!get_property("_cameraUsed").to_boolean()) {
		if ($item[shaking 4-d camera].have() && get_property("cameraMonster") == camera_monster()) {
			$item[shaking 4-d camera].use();
			continue;
		}
	}
	
	// @TODO file
	if (!get_property("_iceSculptureUsed").to_boolean()) {
		if ($item[ice sculpture].have() && get_property("iceSculptureMonster") == camera_monster()) {
			$item[ice sculpture].use();
			continue;
		}
	}
	
	// @TODO file clean up for skill juggling
	if (witchess_fight_can()) {
		terminal_duplicate_prepare();
		witchess_fight_run();
		cli_execute("terminal educate digitize");
		cli_execute("terminal educate extract");
		escape_choice(); // This is to resuscitate Mafia's realisation of "non-trapping choice.php"
		continue;
	}
	
	// @TODO file
	if (get_property("chateauMonster") == "Black Crayon Crimbo Elf" && !get_property("_chateauMonsterFought").to_boolean()
		&& $familiar[Robortender].try_equip()) {
		alternative_outfit().change_outfit();
		visit_url("/place.php?whichplace=chateau&action=chateau_painting", false);
		run_combat();
		continue;
	}

	// Lynyrds @TODO file
	if (get_property("_lynyrdSnareUses").to_int() < 3) {
		print("Fighting free lynyrd.", "green");
		$item[lynyrd snare].use();
		continue;
	}

	// God Lobster
	if (globster_can()) {
		globster_run(5, 2);
		continue;
	}

	// Eldritch Tentacles
	if (!get_property("_eldritchTentacleFought").to_boolean()) {
		print("Completing eldritch tentacle fights.", "green");
		visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
		if ($item[eldritch essence].have()) run_choice(2);
		else run_choice(1);
		run_combat();
		continue;
	}

	if (evoke_eldritch_can()) {
		evoke_eldritch_run();
		continue;
	}
	
	// BRICKOs @TODO file
	if (get_property("_brickoFights").to_int() < 10) {
		$item[BRICKO ooze].use();
		continue;
	}

	// Snojo
	if (snojo_free_fight_can()) {
		snojo_free_fight_run(true); // Boolean is for resting after the 10th fight
		continue;
	}

	// Neverending Party
	if (nep_free_turn_can()) {
		nep_free_turn_run();
		continue;
	}

	// DMT @TODO file
	if ($familiar[Machine Elf].have() && get_property("_machineTunnelsAdv").to_int() < 5) {
		print("Completing Machine Tunnel fights.", "green");
		$familiar[Machine Elf].use();
		hookah.try_equip();
		adv1($location[The Deep Machine Tunnels], -1, "");
		if (get_property("_machineTunnelsAdv").to_int() > 4 && hookah.have_equipped()) equip(fam, $item[None]);
		continue;
	}

	if (glitch_reward_fight_can()) {
		glitch_reward_fight_run();
		continue;
	}
	
	// @TODO file
	if (get_property("_powerPillUses").to_int() < 20) {
		if ($item[The Jokester's gun].avail() && !get_property("_firedJokestersGun").to_boolean()) $item[The Jokester's gun].try_equip();
		else if (get_property("_chestXRayUsed").to_int() < 3) try_equip(acc1, doc_bag);
		$item[drum machine].use();
		continue;
	}
	
	// Drunk pygmies
	if (get_property("_snokebombUsed").to_int() == 2) {
		pygmy_free_banish_prep();
		continue;
	}
	
	if (pygmy_free_banish_can(10)) {
		pygmy_free_banish_run();
		continue;
	}
	
	if (pygmy_free_banishes() < 21 && saber.try_equip()) { // People with Saber get 21 banishes
		saber_pygmy_run();
		continue;
	} else 	if (pygmy_free_banish_can(11)) { // People without get 11
		pygmy_free_banish_run();
		continue;
	}
	
	// Gingerbread Upscale Retail District
	if (gingerbread_free_turn_can()) {
		gingerbread_free_turn_run();
		continue;
	}

	if (timespinner_can()) {
		timespinner_fight(1431); // Drunk Pygmies
		continue;
	}
	
	// Pill Keeper and Embezzlers
	if (peeper_can(true)) {
		peeper_embezzler_run();
		continue;
	}

	timespinner_pranks_check();
	
	kramco_grind_until(20);
	
	if ($item[Beach Comb].avail() && get_property("_freeBeachWalksUsed") < 11) abort("Use your free beach walks.");
	
	if (!get_property("_workshedItemUsed").to_boolean() && mayo_clinic.have()
		&& user_confirm("Change your workshed to the Mayo Clinic?")) {
		mayo_clinic.use();
	}

	if (stomach_remaining() > 0) optimal_consumption();
	
	optimal_stooper();
	
	data_tp_rares();
	
	foreach it in $items[meat stack, 1952 Mickey Mantle card, massive gemstone, dollar-sign bag, half of a gold tooth, decomposed boot, leather bookmark, huge gold coin, moxie weed] {
		if (it.have()) autosell(it.item_amount(), it);
	}
	
	foreach it in $items[solid gold jewel, ancient vinyl coin purse, duct tape wallet, old coin purse, old leather wallet, pixel coin, shiny stones, Gathered Meat-Clip] {
		if (it.have()) use(it.item_amount(), it);
	}

	cli_execute("/whitelist " + rollover_clan());
	int meat_today = data_meat_today();
	int total_meat_today = data_meat_today() - data_costs_today();
	int fights_today = data_fights_today();
		
	print("You earned " + meat_today + " net meat this session over " + fights_today + " fights with your " + cocoabo_today_get() + ".", "purple");
	print("That calculates to " + total_meat_today/fights_today + " meat per fight on average.", "purple");
	set_property("_aen_cocoabo_farm", "false");
	print("Checkpoint reached: _aen_cocoabo_farm is false.", "blue");
}
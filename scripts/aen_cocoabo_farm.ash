script "aen_cocoabo_farm.ash";

import "aen_resources.ash";

if (!cocoabo_farm()) {
	initial_cocoabo_prompt();
	cocoabo_today_run();
	freerun_fam_today_run();
	great_trip.pickpocket_today_run();
	cocoabo_farm_set("true");
}

// Stocking up on stuff here
if (!cocoabo_stock()) {
	print("Buying supplies.", "purple");
	if (!trav_trous.try_equip() && my_id() == 2273519) abort("Where are your damn trousers!?");

	// Copiers
	if (!$item[unfinished ice sculpture].available()) {
		buy_until(3, $item[snow berries], 3334);
		buy_until(3, $item[ice harvest], 3334);
		cli_execute("create unfinished ice sculpture");
	}

	// Misc
	buy_until(5, $item[glark cable], 5000);
	buy_until(40, $item[Lucky Surprise Egg], 5000);
	buy_until(40, $item[Spooky Surprise Egg], 5000);
	buy_until(10, $item[BRICKO eye brick], 3000);
	buy_until(20, $item[BRICKO brick], 500);
	buy_until(3, $item[lynyrd snare], 1000);
	buy_until(40, $item[drum machine], 6000);
	buy_until(20, $item[Power Pill], 20000);
	buy_until(30, $item[gingerbread cigarette], 25000);
	if ($item[gingerbread cigarette].amt() > 29) set_property("_aen_gingerbread_today", "true");
	if (!juggle_scorpions(23)) buy_until(23 - bworps.amt(), bworps, 500);
	//buy_until(1, $item[burning newspaper], 15000);
	buy_until(1, $item[alpine watercolor set], 5000);
	retrieve_item($item[4-d camera]);
	buy_until(10, sgeea, 1000);
	buy_until(5, $item[powdered madness], 40000);
	
	if ($item[Spooky Surprise Egg].item_amount() < 40) {
		int eggs = $item[Spooky Surprise Egg].item_amount();
		cli_execute("acquire " + (40 - eggs) + " Spooky Surprise Egg");
	}
	
	cli_execute("acquire Louder Than Bomb");
	cli_execute("create 10 BRICKO ooze");
	cocoabo_stock_set("true");
}

// Set Up
if (!cocoabo_setup()) {
	print("Setting choice adventure values.", "purple");
	set_choices();
	set_auto_attack("Pick Pocket");
	set_property("customCombatScript", "aen_combat");

	pocketprof_prep();
	summon_libram();
	
	if (vote_can()) vote_run();
	
	if (horsery_have()) horsery_run("dark");

	if ( !CosplaySaber.upgrade() ) abort( "Something went wrong when upgrading the saber." );
	
	optimal_eat(); //Eats to (fullness -1).
	
	pantsgiving_prompt();
	
	cli_execute("/whitelist " + day_clan());
	cli_execute("breakfast");
	
	CosplaySaber.set_previous_forces_today();

	daily_aftercore();

	pyec_run();
			
	summon_libram();
	
	if (get_property("getawayCampsiteUnlocked").to_boolean()) {
		while (get_property("timesRested").to_int() < total_free_rests()) visit_url("place.php?whichplace=campaway&action=campaway_tentclick");
	}

	//if (!$item[burning paper crane].fetch()) cli_execute("create burning paper crane");
	if (bastille_can()) bastille_run($stat[Mysticality], $item[Brutal brogues], $effect[Bastille Braggadocio]);

	// Volcoino
	volcano_tower(7);
	copier_prep();
	data_costs_today_set(my_session_meat());
	
	// Stray catcher
	print("Spending a free turn in the NEP to check for stray time pranks or spiders.", "purple");
	summon_libram();
	inebriety_check();
	cocoabo_outfit().change_outfit();
	if ($item[buddy bjorn].have_equipped() && my_bjorned_familiar() != $familiar[misshapen animal skeleton]) $familiar[misshapen animal skeleton].bjornify_familiar();
	if (nep_free_turn_can()) {
		cocoabo_run();
		nep_free_turn_run();
		nep_free_turn_run(); // Needs to be twice to counteract the intro superlikely.
	}

	if (pickpocket_location_today_get() == great_trip && !cocoabo_free_runs() && !$effect[Half-Astral].have()) {
		$item[astral mushroom].use();
	}

	cocoabo_setup_set("true");
}

// Free Runs
if (!cocoabo_free_runs()) {
	if (freerun_fam_have() && !cocoabo_bander_runs()) {
		freerun_fam_max_check();
		
		pickpocket_outfit().change_outfit();
		pantsgiving_threshold_run(2);
		freerun_fam_today().use();
		hookah.try_equip();
		
		// Free run loop
		summon_libram();
		while (!freerun_max_weight_run()) {
			hookah_uneffect();
			inebriety_check();
			if (pantsgiving_fullness_can(2)) $item[Spooky Surprise Egg].eatsilent();
			
			data_session_adv_update();
			data_adv_threshold_check();
			closet_stuff();
			
			if (stinkycheese_banish_can()) try_equip(acc1, $item[stinky cheese eye]);
			else if ($item[stinky cheese eye].worn() && !stinkycheese_banish_can()) try_equip(acc1, pickpocket_outfit_acc1);
			adv1(pickpocket_location_today(), 0, "");
			if (pantsgiving_threshold_run(2)) pickpocket_outfit_pants.try_equip();
			continue;
		}
		cocoabo_bander_runs_set("true");
	} else if (!freerun_fam_have()) cocoabo_bander_runs_set("true");

	// Banishes w/ sniff
	boolean all_runs = false;
	while (!all_runs) {
		data_session_adv_update();
		data_adv_threshold_check();
		summon_libram();
		if (get_property("_latteBanishUsed").to_boolean() && get_property("_latteRefillsUsed").to_int() < 3) cli_execute("latte refill cajun pumpkin rawhide");
		pickpocket_outfit().change_outfit();
		if (!get_property("_vmaskBanisherUsed").to_boolean()) try_equip(acc1, $item[V for Vivala mask]);
		else if (get_property("_kgbTranquilizerDartUses").to_int() < 3) try_equip(acc1, kgb);
		else if (get_property("_reflexHammerUsed").to_int() < 3) try_equip(acc1, docbag);
		else if (!get_property("_latteBanishUsed").to_boolean()) $item[latte lovers member\'s mug].try_equip();
		else if (get_property("_navelRunaways").to_int() < 3) try_equip(acc1, navel);
		else if (!freerun_blankout_used()) $item[bottle of Blank-Out].try_use();
		if (get_property("_snokebombUsed").to_int() > 1) {
			all_runs = true;
			continue;
		}
		if (get_property("shrubGifts") == "meat" && !$effect[Everything Looks Red].have() && $familiar[Crimbo Shrub].have()) $familiar[Crimbo Shrub].use();
		//else if (get_property("_spaceJellyfishDrops") < 6 && $familiar[Space Jellyfish].have()) $familiar[Space Jellyfish].use();
		else if (!$familiar[Artistic Goth Kid].use()) $familiar[none].use();
		// if (my_familiar() == $familiar[Space Jellyfish]) {
		// 	if ($effect[Half-Astral].have()) cli_execute("uneffect Half-Astral");
		// 	equip($slot[familiar], $item[none]);
		// 	adv1($location[The Hole in the Sky], 0, "");
		// } else {
		// 	if (my_familiar() != $familiar[Crimbo Shrub]) abort("Jellies exhausted and now goth kid?");
		adv1(pickpocket_location_today(), 0, "");
		// }
		continue;
	}
		
	optimal_consumption();
	
	if (workshed_can(asdon)) {
		if (workshed_query(mayo_clinic)) $item[Mayodiol].use(); // For later when we eat again
		if (workshed_run(asdon)) fill_asdon_martin_to(150);
	} else if (workshed_query(asdon)) fill_asdon_martin_to(150);
	if ($effect[Half-Astral].have()) cli_execute("uneffect Half-Astral");
	cocoabo_free_runs_set("true");
}

// Main fight Loop
while (cocoabo_farm()) {

	print("Initiating start of loop.", "purple");
	summon_libram();
	inebriety_check();
	cocoabo_outfit().change_outfit();
	if ($item[buddy bjorn].have_equipped() && my_bjorned_familiar() != $familiar[misshapen animal skeleton]) $familiar[misshapen animal skeleton].bjornify_familiar();

	// Adventure tracking and protection; meat tracking
	data_session_adv_update();
	data_session_meat_update();
	if (embezzlers_today() > 0) data_adv_threshold_check(6);
	else data_adv_threshold_check();

	if (!$effect[Inscrutable Gaze].have() && (embezzlers_today() < 1 || embezzlers_today() > 5)) $skill[Inscrutable Gaze].use();
	hookah_uneffect();
	closet_stuff();

	// Portscan into macro
	if (counter_now("portscan.edu")) {
		cocoabo_run();
		if (get_property("_macrometeoriteUses").to_int() > 9 || !$skill[Macrometeorite].have()) {
			print("We cannot use Macrometeorite, so we'll use CHEAT CODE: Replace Enemy.");
			$item[Powerful Glove].equip(); // Only gets here if we have one
		}
		if (terminal_portscan_can()) terminal_portscan_prepare();
		mushgarden_fight_run();
		continue;
	}

	// Vote monster
	if (vote_free_fight_can()) {
		cocoabo_run();
		wanderer_now_run();
		continue;
	}

	// LOVE Tunnel
	if (lov_can()) {
		cocoabo_run();
		lov_run();
		continue;
	}

	// Proto ghost
	if (proto_can()) {
		cocoabo_run();
		proto_run();
		continue;
	}
	//abort("moto");
	if (copier_run()) {
		cocoabo_run();
		continue;
	}

	// @TODO file
	/*if (!get_property("_photocopyUsed").to_boolean()) {
		if (vip_key.have() && !$item[photocopied \monster].have()) faxbot(camera_monster(), "CheeseFax");
		if ($item[photocopied \monster].have() && get_property("photocopyMonster") == camera_monster_string()) {
			if (camera_monster_string() == "Knob Goblin Embezzler") embezzler_prep(); // @TODO handle this for all copiers
			$item[photocopied \monster].use();
			continue;
		}
	}*/
	
	// @TODO file clean up for skill juggling
	if (witchess_fight_can()) {
		cocoabo_run();
		if (get_property("_pocketProfessorLectures").to_int() < floor(square_root($familiar[Pocket Professor].total_weight())) + 2) $familiar[Pocket Professor].try_equip();
		if (my_familiar() == $familiar[Pocket Professor] && !$item[Pocket Professor memory chip].have_equipped()
			&& !$item[Pocket Professor memory chip].try_equip()) {
				abort("Missing Pocket Professor memory chip.");
		}
		terminal_duplicate_prepare();
		witchess_fight_run();
		cli_execute("terminal educate digitize");
		cli_execute("terminal educate extract");
		continue;
	}

	// Lynyrds
	if (lynyrd_fight_can()) {
		cocoabo_run();
		lynyrd_fight_run();
		continue;
	}
	
	// Glark cables
	if (zeppelin_free_can()) {
		cocoabo_run();
		zeppelin_free_run();
		continue;
	}

	// God Lobster
	if (globster_can()) {
		globster_run(5, 2);
		continue;
	}

	// Eldritch Tentacles
	if (tentacle_fight_can()) {
		cocoabo_run();
		tentacle_fight_run();
		continue;
	}

	if (tentacle_skill_fight_can()) {
		cocoabo_run();
		tentacle_skill_fight_run();
		continue;
	}

		// Mushroom Garden
	if (mushgarden_fight_can()) {
		cocoabo_run();
		mushgarden_fight_run();
		mushgarden_pick(11);
		continue;
	}
	
	// BRICKO oozes
	if (bricko_fight_can()) {
		cocoabo_run();
		if (terminal_portscan_can()) terminal_portscan_prepare();
		bricko_fight_run();
		continue;
	}

	// Snojo
	if (snojo_free_fight_can()) {
		cocoabo_run();
		snojo_free_fight_run(true); // Boolean is for resting after the 10th fight
		continue;
	}

	// DMT
	if (melf_free_fight_can()) {
		melf_free_fight_run();
		continue;
	}
	
	// % Monster %
	if (glitch_reward_fight_can()) {
		cocoabo_run();
		glitch_reward_fight_run();
		continue;
	}

	// Giant sandworms
	if (sandworm_can()) {
		cocoabo_run();
		sandworm_run();
		continue;
	}
	
	// Neverending Party
	if ($effect[Meteor Showered].have() && nep_free_turn_can()) { // Showered from pygmy sabers
		cocoabo_run();
		nep_free_turn_run();
		continue;
	}

	// Drunk pygmies
    if ( DrunkPygmy.can_free_fight() )
    {
        if ( !DrunkPygmy.location_prepared() ) DrunkPygmy.prepare_location();
        else DrunkPygmy.run_free_fight();
        continue;
    }
    else if ( DrunkPygmy.can_forced_friends_free_fight() )
    {
        DrunkPygmy.run_forced_friends_free_fight();
        continue;
    }

	// Neverending Party
	if (nep_free_turn_can()) {
		cocoabo_run();
		nep_free_turn_run();
		continue;
	}
	
	if (timespinner_can()) {
		cocoabo_run();
		timespinner_fight(1431); // Drunk Pygmies
		continue;
	}
	
	// Gingerbread Upscale Retail District
	if (gingerbread_free_turn_can()) {
		cocoabo_run();
		gingerbread_free_turn_run();
		continue;
	}
	
	// Pill Keeper and Embezzlers
	if (peeper_can(true)) {
		cocoabo_run();
		peeper_embezzler_run();
		timespinner_pranks_check();
		continue;
	}
	
	timespinner_pranks_check();

	kramco_grind_until(20);
	
	if ($item[Beach Comb].available() && get_property("_freeBeachWalksUsed") < 11) abort("Use your free beach walks.");
	
	workshed_run(mayo_clinic);

	if (stomach_remaining() > 0) optimal_consumption();
	
	optimal_stooper();
	
	//@TODO file
	foreach it in $items[meat stack, 1952 Mickey Mantle card, massive gemstone, dollar-sign bag, half of a gold tooth, decomposed boot, leather bookmark, huge gold coin, moxie weed] {
		if (it.have()) autosell(it.item_amount(), it);
	}
	
	foreach it in $items[ancient vinyl coin purse, duct tape wallet, old coin purse, old leather wallet, pixel coin, shiny stones, Gathered Meat-Clip] {
		if (it.have()) it.use_all();
	}
	
	data_tp_rares();

	cli_execute("/whitelist " + rollover_clan());
	int meat_today = data_meat_today();
	int total_meat_today = data_meat_today() - data_costs_today();
	int fights_today = data_fights_today();
	int avg_adv = total_meat_today/fights_today;
	data_cocoabo_combat_worth_today_set(avg_adv);
	int melange_worth = melange.mall_price() * sandworm_melange();
		
	print("You earned " + meat_today + " net meat this session over " + fights_today + " fights with your " + cocoabo_today_get() + ".", "purple");
	print("Including costs of " + data_costs_today() + ", that calculates to " + avg_adv + " meat per fight on average.", "purple");
	print("You also acquired " + sandworm_melange() + " spice melange, which are worth approximately " + melange_worth + " total meat.", "purple");
	cocoabo_farm_set("false");
}
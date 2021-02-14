script "aen_combat.ash";

import "aen_resources.ash";
import "aen_macros.ash";

void main(int rnd, monster mob, string pg) {
	if ((can_interact() && get_property("_aen_cocoabo_farm").to_boolean()) || my_name() == "devster4") {
		print("Using consult script aen_combat.ash for aen_cocoabo_farm.ash.", "blue");
		comma_fights_increment();
		data_fights_today_increment();

		location loc = my_location();
		string mob_str = mob.to_string();
		int boa_hp_threshold = 327;
		int boots_hp_threshold = 310;
		boolean sing_along = false;
		boolean extracted = false;
		boolean siesta = false;
		boolean weaksauce = false;
		boolean mShower = false;
		boolean cloake = false;
		int digitizes = get_property("_sourceTerminalDigitizeUses").to_int();
		int digiNo = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
		
		if (mob_str == get_property( "aen_copy_monster" ))
		{
			set_property( "_aen_use_nostalgia", true );
		}
		if (mob.id == 1965) set_property("_aen_pranks_today", get_property("_aen_pranks_today").to_int() + 1);
		if (mob == $monster[giant rubber spider]) {
			set_property("aen_giant_rubber_spider", "true");
			set_property("aen_expect_prank", "false");
		} else if (get_property("aen_expect_prank").to_boolean()) {
			string pranker = get_property("_aen_pranker_today");
			matcher prank = create_matcher(pranker, pg.to_lower_case());
			if (prank.find()) {
				if (pranker == "mistress of the obvious") {
					set_property("aen_moto_pranks", get_property("aen_moto_pranks").to_int() + 1);
					if (get_property("_aen_pranks_today") > 5) {
						chat_private(pranker, "Thank you for today's pranks! That's " + get_property("aen_moto_pranks").to_int() + " pranks out of 54!");
					}
				} else if (pranker == "the erosionseeker") {
					set_property("aen_ero_pranks", get_property("aen_ero_pranks").to_int() + 1);
					if (get_property("_aen_pranks_today") > 5) {
						chat_private(pranker, "Thank you for today's pranks! That's " + get_property("aen_ero_pranks").to_int() + " pranks out of 54!");
					}
				}
				set_property("aen_expect_prank", "false");
			} else if (mob.id == 1965) {
				print("Fought a time prank.", "purple");
				set_property("aen_expect_prank", "false");
			} else {
				//chat_private("anng", "Oh no! Looks like I received a " + mob_str + " instead. :( Try again?");
				abort("Unexpected encounter.");
			}
		}

		if (mob_str == get_property("aen_copy_monster")) {
			
			if ($skill[Duplicate].have()) $skill[Duplicate].use();
			
			copier_combat_item_run(rnd, mob, 317);
			
			if (my_familiar() == $familiar[Pocket Professor] && have_skill(7319.to_skill())) {
				use_skill(1, 7319.to_skill());
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish().url_encode(), true, true);
			} else {
				visit_url("fight.php?action=macro&macrotext=" + macro_stasis_finish(10, 1).url_encode(), true, true);
			}
		}
		
		if (mob == $monster[Knob Goblin Embezzler]) {
			embezzlers_today_increment();
		
			if (get_property("_sourceTerminalDigitizeUses").to_int() < 1 && $skill[Digitize].have()) {
				use_skill(1, $skill[Digitize]);
				rnd++;
			}
			
			visit_url("fight.php?action=macro&macrotext=" + macro_hpless_stasis_finish(10).url_encode(), true, true);
			
			$skill[Summer Siesta].try_use();
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis_finish(10, boa_hp_threshold).url_encode(), true, true);
			int pranks = get_property("_aen_pranks_today").to_int();
			if (pranks > 0 && pranks < 6) {
				chat_private(get_property("_aen_pranker_today"), "Thanks; I'm ready for prank number " + (get_property("_aen_pranks_today").to_int() + 1) + "!");
			}
		}

		if (mob == $monster[government agent]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			terminal_portscan_use();
			if (my_location() != $location[Your Mushroom Garden]) abort( "Encountered a government agent in the wrong location." );
			if ($skill[Macrometeorite].try_use() || $skill[CHEAT CODE: Replace Enemy]. try_use()) {
				rnd = 0;
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			}
		}
		
		if (mob == $monster[giant sandworm]) {
			sandworm_fights_increment();
			string page = visit_url("fight.php?action=macro&macrotext=" + macro_stasis_freekill(10, boa_hp_threshold).url_encode(), true, true);
			if (!page.contains_text("FREEFREEFREE") ){
				if (freekill_batrang_can()) page = $item[replica bat-oomerang].throw_item();
				else if (freekill_madness_can()) page = $item[powdered madness].throw_item();
				else if (freekill_powerpill_can()) page = $item[power pill].throw_item();
				else abort("You have run out of power pills.");
			}
			if (page.contains_text("spice melange")) sandworm_melange_increment();
		}
		
		// The Hidden Bowling Alley
		if (mob == $monster[pygmy bowler]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			$skill[Snokebomb].try_use();
		}

		if (mob == $monster[pygmy orderlies]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			$skill[Reflex Hammer].try_use();
			if (!$skill[Snokebomb].try_use()) abort("Banish the pygmy orderlies, somehow.");
		}
		
		if (mob == $monster[pygmy janitor]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			abort("Banish the janitors in the park.");
		}
		
		if (mob == $monster[drunk pygmy])
		{
			if (!bworps.have())
			{
				if ( CosplaySaber.get_copy_target() == mob.id && shower.have() ) shower.use(); //We get the most of meteor shower this way
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
				if ( !DrunkPygmy.location_prepared() )
				{
					$skill[Macrometeorite].try_use();
					if (!$skill[Snokebomb].try_use()) abort("Shouldn't get here: Line 107 of combat.ash.");
				}
				visit_url("fight.php?action=macro&macrotext=" + macro_stasis(10, boa_hp_threshold).url_encode(), true, true);

				CosplaySaber.use_copier( mob );
			}
		}
		
		if (mob == $monster[gingerbread convict] || mob == $monster[gingerbread finance bro] || mob == $monster[gingerbread gentrifier]
			|| mob == $monster[gingerbread lawyer] || mob == $monster[gingerbread tech bro]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_gingerbread_stasis(10, boa_hp_threshold).url_encode(), true, true);
		}
		
		if (mob == $monster[gingerbread rat] || mob == $monster[gingerbread pigeon]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			if (get_property("_snokebombUsed").to_int() > 1) $skill[Snokebomb].use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].use();
		}
		
		// Pickpocket
		if (mob_str == pickpocket_target_today()) {
			print("This monster is our pickpocket target.", "green");
			string pickpocket = visit_url("fight.php?action=steal", true);
			matcher picks = create_matcher("You acquire an item: <b>" + pickpocket_item_today_get() + "</b>", pickpocket);
			rnd++;

			if (monster_hp() > boots_hp_threshold && rnd < 30) {
				extract.use();
				rnd++;
			}
			
			if (get_property("_pantsgivingCrumbs").to_int() < 10 && monster_hp() > boots_hp_threshold && rnd < 30) {
				crumbs.try_use();
				rnd++;
			}
			
			if (monster_hp() > boots_hp_threshold && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].worn()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			
			while (!picks.find() && monster_hp() > boots_hp_threshold && rnd < 30 && cracker.have()) {
				pickpocket  = cracker.throw_item();
				picks = create_matcher("You acquire an item: <b>" + pickpocket_item_today_get() + "</b>", pickpocket);
				rnd++;
			}
		
			if ($item[stinky cheese eye].worn() && $skill[Macrometeorite].try_use()) $skill[Give Your Opponent the Stinkeye].use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have() && $skill[Macrometeorite].try_use()) $skill[Snokebomb].use();
						
			if (my_familiar() == $familiar[Crimbo Shrub] && !$effect[Everything Looks Red].have()) {
				$skill[Open a Big Red Present].use();
				rnd++;
			}
			
			if (monster_hp() > boots_hp_threshold && get_property("_gallapagosMonster") != mob_str) $skill[Gallapagosian Mating Call].try_use();
			
			if (monster_hp() > boots_hp_threshold && !$effect[On the Trail].have()) $skill[Transcendent Olfaction].try_use();
			
			while (monster_hp() > boots_hp_threshold && rnd < 3) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			if (navel.worn() || freerun_fam_could()) {
				if (navel.worn() && freerun_fam_could()) abort("We shouldn't have two simultaneous runaways methods.");
				runaway();
			} else if (blankout.have()) blankout.throw_item();
			else {
				if (my_familiar() == $familiar[Artistic Goth Kid] || my_familiar() == $familiar[Crimbo Shrub] || my_familiar() == $familiar[Space Jellyfish] || my_familiar() == $familiar[none]) {
					$skill[Creepy Grin].try_use();
					$skill[KGB tranquilizer dart].try_use();
					$skill[Reflex Hammer].try_use();
					$skill[Gulp Latte].try_use();
					$skill[Throw Latte On Opponent].try_use();
					$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
					if (get_property("_snokebombUsed").to_int() == 1) $skill[Snokebomb].try_use();
				} else abort("Wrong " + pickpocket_location_today_get() + " runaway familiar.");
			}
		}

		if (my_location() == $location[The Hole in the Sky]) {
			if (!cocoabo_free_runs() && my_familiar() == $familiar[Space Jellyfish]) {
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
				rnd = 3;
				$skill[Extract Jelly].use();
				$skill[Creepy Grin].try_use();
				$skill[KGB tranquilizer dart].try_use();
				$skill[Reflex Hammer].try_use();
				$skill[Gulp Latte].try_use();
				$skill[Throw Latte On Opponent].try_use();
				$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
				if (get_property("_snokebombUsed").to_int() == 1) $skill[Snokebomb].try_use();
			} else {
				abort("Something went wrong with the Space Jellyfish.");
			}
		}

		if (!cocoabo_bander_runs() && pickpocket_banish_can(mob_str)) {
		
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			rnd = 3;
			
			if (monster_hp() > boots_hp_threshold && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].worn()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			
			if (get_property("banishedMonsters").contains_text(mob_str)) abort("There appear to be multiple copies of an unexpected monster.");
			$skill[Give Your Opponent the Stinkeye].try_use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have()) $skill[Snokebomb].use();
			else if (!get_property("banishedMonsters").contains_text("louder than bomb")) $item[Louder Than Bomb].throw_item();
			else if (!get_property("banishedMonsters").contains_text("tennis ball")) $item[Tennis Ball].throw_item();
		}
		
		if (mob == $monster[Eldritch Tentacle]) {
			if ($item[haiku katana].have_equipped()) {
				visit_url("fight.php?action=macro&macrotext=" + macro_stasis(10, boa_hp_threshold).url_encode(), true, true);
				$skill[Summer Siesta].try_use();
				visit_url("fight.php?action=macro&macrotext=" + macro_stasis_finish(10, boa_hp_threshold).url_encode(), true, true);
			}

			if ( get_property( "_aen_use_nostalgia" ).to_boolean() )
			{
				string nostalgia = "if hasskill 7365;skill 7365;endif;";
				visit_url("fight.php?action=macro&macrotext=" + nostalgia.url_encode(), true, true);
				set_property( "_aen_use_nostalgia", false );
			}
		}
		
		if (mob == $monster[Candied Yam Golem] || mob == $monster[Malevolent Tofurkey]
			|| mob == $monster[Possessed Can of Cranberry Sauce] || mob == $monster[Stuffing Golem]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			abort("Encountered a Feast of Boris monster.");
		}
			
		if (mob == $monster[Novia Cad&aacute;ver] || mob == $monster[Novio Cad&aacute;ver] || mob == $monster[Padre Cad&aacute;ver]
			|| mob == $monster[Persona Inocente Cad&aacute;ver]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			abort("Encountered a Muertos Borrachos monster.");
		}
			
		if (mob == $monster[tumbleweed]) {
			abort("We should never be fighting tumbleweeds.");
		}

		if (my_familiar() == $familiar[Machine Elf]) visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish().url_encode(), true, true);
		
		if (mob == $monster[man with the red buttons] || mob == $monster[red butler] || mob == $monster[Red Snapper]
			|| mob == $monster[Red Herring] || mob == $monster[red skeleton]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_zeppelin_stasis(10, boa_hp_threshold).url_encode(), true, true);
		}
		
		if (mob == $monster[Red Fox]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			abort("Received a Red Fox semi-rare, somehow.");
		}

		if (get_property("aen_use_portscan").to_boolean() && $skill[portscan].have()) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			terminal_portscan_use();
		}

		if ( mob == $monster[X-32-F Combat Training Snowman] )
		{
			visit_url( "fight.php?action=macro&macrotext=" + macro_hpless_stasis_finish( 10 ).url_encode(), true, true );
		}

		visit_url("fight.php?action=macro&macrotext=" + macro_stasis_scaler_finish(10, 1).url_encode(), true, true);
		
		if (mob == $monster[God Lobster]) multi_fight();
		
		if (my_location() != $location[The Tunnel of L.O.V.E.]) multi_fight();
		
		if (get_property("aen_giant_rubber_spider").to_boolean()) {
			cli_execute("send rubber spider to cookiebot || spider");
			set_property("aen_giant_rubber_spider", "false");
		}

		if (get_property("aen_moto_pranks").to_int() == 54) {
			set_property("aen_moto_pranks", 0);
			cli_execute("send spice melange to Mistress of the Obvious || Thanks for 54 pranks! Here's the payment for the next 54!");
		}
		
		if (get_property("aen_ero_pranks").to_int() == 54) {
			set_property("aen_ero_pranks", 0);
			cli_execute("send spice melange to the erosionseeker || Thanks for 54 pranks! Here's the payment!");
		}
	} 
}

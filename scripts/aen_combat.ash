script "aen_combat.ash";

import "aen_resources.ash";
import "aen_macros.ash";

void main(int rnd, monster mob, string pg) {
	if ((can_interact() && get_property("_aen_cocoabo_farm").to_boolean()) || my_name() == "devster4") {
		print("Using consult script aen_combat.ash for aen_cocoabo_farm.ash.", "blue");
		comma_fights_increment();
		data_fights_today_increment();

		location loc = my_location();
		string foe = mob.to_string();
		boolean sing_along = false;
		boolean extracted = false;
		boolean siesta = false;
		boolean weaksauce = false;
		boolean mShower = false;
		boolean cloake = false;
		int digitizes = get_property("_sourceTerminalDigitizeUses").to_int();
		int digiNo = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
		
		if (mob.id == 1965) set_property("_aen_pranks_today", get_property("_aen_pranks_today").to_int() + 1);
		if (get_property("aen_expect_prank").to_boolean()) {
			matcher prank = create_matcher("anng", pg);
			if (prank.find()) {
				set_property("aen_anng_pranks", get_property("aen_anng_pranks").to_int() + 1);
				if (get_property("_aen_pranks_today").to_int() < 6) chat_private("anng", "Thanks; I'm ready for prank number " + (get_property("_aen_pranks_today").to_int() + 1) + "!");
				else chat_private("anng", "Thank you for today's pranks! That's " + get_property("aen_anng_pranks").to_int() + " pranks out of 54!");
				set_property("aen_expect_prank", "false");
			} else {
				chat_private("anng", "Oh no! Looks like I received a " + foe + " instead. :( Try again?");
				abort("Unexpected encounter.");
			}
		}
		
		if (mob == $monster[Witchess Knight]) { // @TODO Not necessarily the copy target.
			
			if ($skill[Duplicate].have_skill()) {
				use_skill(1, $skill[Duplicate]);
			}
			
			copier_combat_item_run(rnd, mob, 317);
			
			if (my_familiar() == $familiar[Pocket Professor] && have_skill(7319.to_skill())) {
				use_skill(1, 7319.to_skill());
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish.url_encode(), true, true);
			} else {
				visit_url("fight.php?action=macro&macrotext=" + macro_no_meteor_finish.url_encode(), true, true);
			}
		}
		
		if (mob == $monster[Knob Goblin Embezzler]) {
			embezzlers_today_increment();
		
			if (get_property("_sourceTerminalDigitizeUses").to_int() < 1 && $skill[Digitize].have_skill()) {
				use_skill(1, $skill[Digitize]);
				rnd++;
			}

			while (rnd < 10) {
				if (!extracted) {
					extract.use();
					extracted = true;
					rnd++;
				}
				if (!sing_along) {
					slong.use();
					sing_along = true;
					rnd++;
				}
				$item[seal tooth].throw_item();
				rnd++;
			}
			
			$skill[Summer Siesta].try_use();
			visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		}
		
		if (mob == $monster[giant sandworm]) {
			sandworm_fights_increment();
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			rnd++;
			while(monster_hp() > 318 && rnd < 9) {
				$item[seal tooth].throw_item();
				rnd++;
			}

			string page = visit_url("fight.php?action=macro&macrotext=" + macro_free_kills.url_encode(), true, true);
			if ($item[replica bat-oomerang].have() && get_property("_usedReplicaBatoomerang").to_int() < 3) page = $item[replica bat-oomerang].throw_item();
			else if ($item[power pill].have() && get_property("_powerPillUses").to_int() < 20) page = $item[power pill].throw_item();
			else abort("You have run out of power pills.");
			matcher melange = create_matcher("You acquire an item: <b>spice melange</b>", page);
			if (melange.find()) {
				sandworm_melange_increment();
				print("We acquired melange #" + sandworm_melange() + "!", "green");
			}
		}
		
		// The Hidden Bowling Alley
		if (mob == $monster[pygmy bowler]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			$skill[Snokebomb].try_use();
		}

		if (mob == $monster[pygmy orderlies]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			$skill[Reflex Hammer].try_use();
			if (!$skill[Snokebomb].try_use()) abort("Banish the pygmy orderlies, somehow.");
		}
		
		if (mob == $monster[pygmy janitor]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			abort("Banish the janitors in the park.");
		}
		
		if (mob == $monster[drunk pygmy]) {
			if (!bworps.have()) {
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
				if (get_property("_snokebombUsed").to_int() == 2 && $skill[Macrometeorite].try_use()) $skill[Snokebomb].use();

				while(monster_hp() > 318 && rnd < 9) {
					$item[seal tooth].throw_item();
					rnd++;
				}

				if (get_property("aen_use_force").to_boolean()) { //@TODO ID matching
					use_skill(1, 7311.to_skill());
					set_property("aen_use_force", "false");
					run_choice(2);
				}
			}
		}
		
		if (mob == $monster[gingerbread convict] || mob == $monster[gingerbread finance bro] || mob == $monster[gingerbread gentrifier]
			|| mob == $monster[gingerbread lawyer] || mob == $monster[gingerbread tech bro]) {
			if (shower.have()) shower.use();
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 318 && rnd < 9) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			$item[gingerbread cigarette].throw_item();
		}
		
		if (mob == $monster[gingerbread rat] || mob == $monster[gingerbread pigeon]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			if (get_property("_snokebombUsed").to_int() > 1) $skill[Snokebomb].use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].use();
		}
		
		// Great Trip
		if (mob == $monster[Angels of Avalon]) {
			string pickpocket = visit_url("fight.php?action=steal", true);
			matcher picks = create_matcher("You acquire an item: <b>blue-frosted astral cupcake</b>", pickpocket);
			rnd++;

			if (monster_hp() > 310 && rnd < 30) {
				extract.use();
				rnd++;
			}
			
			if (get_property("_pantsgivingCrumbs").to_int() < 10 && monster_hp() > 310 && rnd < 30) {
				crumbs.try_use();
				rnd++;
			}
			
			if (monster_hp() > 310 && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].equipped()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			
			while (!picks.find() && monster_hp() > 310 && rnd < 30 && cracker.have()) {
				pickpocket  = throw_item(cracker);
				picks = create_matcher("You acquire an item: <b>blue-frosted astral cupcake</b>", pickpocket);
				rnd++;
			}
		
			if ($item[stinky cheese eye].equipped() && $skill[Macrometeorite].try_use()) $skill[Give Your Opponent the Stinkeye].use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have() && $skill[Macrometeorite].try_use()) $skill[Snokebomb].use();
						
			if (my_familiar() == $familiar[Crimbo Shrub] && !$effect[Everything Looks Red].have()) {
				$skill[Open a Big Red Present].use();
				rnd++;
			}
			
			if (monster_hp() > 310 && get_property("_gallapagosMonster") != foe) $skill[Gallapagosian Mating Call].try_use();
			
			if (monster_hp() > 310 && !$effect[On the Trail].have()) $skill[Transcendent Olfaction].try_use();
			
			while (monster_hp() > 310 && rnd < 3) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			if (navel.equipped() || freerun_fam_could()) {
				if (navel.equipped() && freerun_fam_could()) abort("We shouldn't have two simultaneous runaways methods.");
				runaway();
			} else if (blankout.have()) blankout.throw_item();
			else {
				if (my_familiar() == $familiar[Artistic Goth Kid] || my_familiar() == $familiar[Crimbo Shrub] || my_familiar() == $familiar[none]) {
					$skill[Creepy Grin].try_use();
					$skill[KGB tranquilizer dart].try_use();
					$skill[Reflex Hammer].try_use();
					$skill[Gulp Latte].try_use();
					$skill[Throw Latte On Opponent].try_use();
					$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
					if (get_property("_snokebombUsed").to_int() == 1) $skill[Snokebomb].try_use();
				} else abort("Wrong astral runaway familiar.");
			}
		}
		
		if (mob == $monster[Bustle in the Hedgerow] || mob == $monster[Elders of the Gentle Race] || mob == $monster[Gathering of Angels?]
			|| mob == $monster[Higher Plane Serpents]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			
			if (monster_hp() > 310 && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].equipped()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			
			$skill[Give Your Opponent the Stinkeye].try_use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
			$skill[Breathe Out].try_use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have()) $skill[Snokebomb].use();
			// else if (!$item[Louder Than Bomb].throw_item()) abort("Something went wrong with banishing in the astral zone.");
		}

		// The Haunted Library
		if (mob == $monster[banshee librarian] || mob == $monster[writing desk]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			$skill[Give Your Opponent the Stinkeye].try_use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have()) $skill[Snokebomb].use();
			else abort("Something went wrong with banishing in the library.");
		}

		if (mob == $monster[bookbat]) {
		
			string pickpocket = visit_url("fight.php?action=steal", true);
			matcher picks = create_matcher("You acquire an item: <b>tattered scrap of paper</b>", pickpocket);
			rnd++;
			

			if (monster_hp() > 310 && rnd < 30) {
				extract.use();
				rnd++;
			}
			
			if (get_property("_pantsgivingCrumbs").to_int() < 10 && monster_hp() > 310 && rnd < 30) {
				crumbs.try_use();
				rnd++;
			}
			
			if (monster_hp() > 310 && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].equipped()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			
			while (!picks.find() && monster_hp() > 310 && rnd < 30 && cracker.have()) {
				pickpocket  = throw_item(cracker);
				picks = create_matcher("You acquire an item: <b>tattered scrap of paper</b>", pickpocket);
				rnd++;
			}
			
			if ($item[stinky cheese eye].equipped() && $skill[Macrometeorite].try_use()) $skill[Give Your Opponent the Stinkeye].use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have() && $skill[Macrometeorite].try_use()) $skill[Snokebomb].use();
						
			if (my_familiar() == $familiar[Crimbo Shrub] && !$effect[Everything Looks Red].have()) {
				$skill[Open a Big Red Present].use();
				rnd++;
			}
			
			if (monster_hp() > 310 && get_property("_gallapagosMonster") != foe) $skill[Gallapagosian Mating Call].try_use();
			
			if (monster_hp() > 310 && !$effect[On the Trail].have()) $skill[Transcendent Olfaction].try_use();
			
			while (monster_hp() > 310 && rnd < 3) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			if (navel.equipped() || freerun_fam_could()) {
				if (navel.equipped() && freerun_fam_could()) abort("We shouldn't have two simultaneous runaways methods.");
				runaway();
			} else if (blankout.have()) blankout.throw_item();
			else {
				if (my_familiar() == $familiar[Artistic Goth Kid] || my_familiar() == $familiar[Crimbo Shrub] || my_familiar() == $familiar[none]) {
					$skill[Creepy Grin].try_use();
					$skill[KGB tranquilizer dart].try_use();
					$skill[Reflex Hammer].try_use();
					$skill[Gulp Latte].try_use();
					$skill[Throw Latte On Opponent].try_use();
					$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
					if (get_property("_snokebombUsed").to_int() == 1) $skill[Snokebomb].try_use();
				} else abort("Wrong library runaway familiar.");
			}
		}
		
		if (mob == $monster[Eldritch Tentacle] && $item[haiku katana].have_equipped()) {
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis.url_encode(), true, true);
			$skill[Summer Siesta].try_use();
			visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		}
		
		if (mob == $monster[Candied Yam Golem] || mob == $monster[Malevolent Tofurkey]
			|| mob == $monster[Possessed Can of Cranberry Sauce] || mob == $monster[Stuffing Golem]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			abort("Encountered a Feast of Boris monster.");
		}
			
		if (mob == $monster[Novia Cad&aacute;ver] || mob == $monster[Novio Cad&aacute;ver] || mob == $monster[Padre Cad&aacute;ver]
			|| mob == $monster[Persona Inocente Cad&aacute;ver]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			abort("Encountered a Muertos Borrachos monster.");
		}
			
		if (mob == $monster[tumbleweed]) {
			abort("We should never be fighting tumbleweeds.");
		}

		if (my_familiar() == $familiar[Machine Elf]) visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish.url_encode(), true, true);
		
		if (mob == $monster[man with the red buttons] || mob == $monster[red butler] || mob == $monster[Red Snapper]
			|| mob == $monster[Red Herring] || mob == $monster[red skeleton]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			rnd++;
			while(monster_hp() > 343 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			$item[glark cable].throw_item();
		}
		
		if (mob == $monster[Red Fox]) abort("Received a Red Fox semi-rare, somehow.");

		visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		
		if (mob == $monster[God Lobster]) multi_fight();
		
		if (my_location() != $location[The Tunnel of L.O.V.E.]) multi_fight();
		if (get_property("aen_anng_pranks").to_int() == 54) {
			set_property("aen_anng_pranks", 0);
			cli_execute("send spice melange to anng || Thanks for 54 pranks! Here's the payment for the next 54!");
		}
	} 
}

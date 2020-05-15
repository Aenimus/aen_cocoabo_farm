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
		boolean sing_along = false;
		boolean extracted = false;
		boolean siesta = false;
		boolean weaksauce = false;
		boolean mShower = false;
		boolean cloake = false;
		int digitizes = get_property("_sourceTerminalDigitizeUses").to_int();
		int digiNo = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
		
		if (mob.id == 1965) set_property("_aen_pranks_today", get_property("_aen_pranks_today").to_int() + 1);
		if (mob == $monster[giant rubber spider]) {
			set_property("aen_giant_rubber_spider", "true");
			set_property("aen_expect_prank", "false");
		} else if (get_property("aen_expect_prank").to_boolean()) {
			matcher prank = create_matcher("anng", pg);
			if (prank.find()) {
				set_property("aen_anng_pranks", get_property("aen_anng_pranks").to_int() + 1);
				if (get_property("_aen_pranks_today").to_int() < 6) chat_private("anng", "Thanks; I'm ready for prank number " + (get_property("_aen_pranks_today").to_int() + 1) + "!");
				else chat_private("anng", "Thank you for today's pranks! That's " + get_property("aen_anng_pranks").to_int() + " pranks out of 54!");
				set_property("aen_expect_prank", "false");
			} else {
				chat_private("anng", "Oh no! Looks like I received a " + mob_str + " instead. :( Try again?");
				abort("Unexpected encounter.");
			}
		}

		if (mob == $monster[Witchess Knight]) { // @TODO Not necessarily the copy target.
			
			if ($skill[Duplicate].have()) $skill[Duplicate].use();
			
			copier_combat_item_run(rnd, mob, 317);
			
			if (my_familiar() == $familiar[Pocket Professor] && have_skill(7319.to_skill())) {
				use_skill(1, 7319.to_skill());
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish().url_encode(), true, true);
			} else {
				visit_url("fight.php?action=macro&macrotext=" + macro_stasis_finish(10, 317).url_encode(), true, true);
			}
		}
		
		if (mob == $monster[Knob Goblin Embezzler]) {
			embezzlers_today_increment();
		
			if (get_property("_sourceTerminalDigitizeUses").to_int() < 1 && $skill[Digitize].have_skill()) {
				use_skill(1, $skill[Digitize]);
				rnd++;
			}
			
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis(10, 317).url_encode(), true, true);
			
			$skill[Summer Siesta].try_use();
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis_finish(10, 317).url_encode(), true, true);
		}
		
		if (mob == $monster[giant sandworm]) {
			sandworm_fights_increment();
			string page = visit_url("fight.php?action=macro&macrotext=" + macro_stasis_freekill(10, 317).url_encode(), true, true);
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
		
		if (mob == $monster[drunk pygmy]) {
			if (!bworps.have()) {
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
				if (get_property("_snokebombUsed").to_int() == 2 && $skill[Macrometeorite].try_use()) $skill[Snokebomb].use();

				visit_url("fight.php?action=macro&macrotext=" + macro_stasis(10, 317).url_encode(), true, true);

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
			visit_url("fight.php?action=macro&macrotext=" + macro_gingerbread_stasis(10, 317, true).url_encode(), true, true);
		}
		
		if (mob == $monster[gingerbread rat] || mob == $monster[gingerbread pigeon]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			if (get_property("_snokebombUsed").to_int() > 1) $skill[Snokebomb].use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].use();
		}
		
		// Pickpocket
		if (mob == pickpocket_target_today()) {
			string pickpocket = visit_url("fight.php?action=steal", true);
			matcher picks = create_matcher("You acquire an item: <b>" + pickpocket_item_today_get() + "</b>", pickpocket);
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
				pickpocket  = cracker.throw_item();
				picks = create_matcher("You acquire an item: <b>" + pickpocket_item_today_get() + "</b>", pickpocket);
				rnd++;
			}
		
			if ($item[stinky cheese eye].equipped() && $skill[Macrometeorite].try_use()) $skill[Give Your Opponent the Stinkeye].use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have() && $skill[Macrometeorite].try_use()) $skill[Snokebomb].use();
						
			if (my_familiar() == $familiar[Crimbo Shrub] && !$effect[Everything Looks Red].have()) {
				$skill[Open a Big Red Present].use();
				rnd++;
			}
			
			if (monster_hp() > 310 && get_property("_gallapagosMonster") != mob_str) $skill[Gallapagosian Mating Call].try_use();
			
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
				} else abort("Wrong " + pickpocket_location_today_get() + " runaway familiar.");
			}
		}
		
		if (!cocoabo_bander_runs() && pickpocket_banish_can(mob_str)) {
		
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			rnd = 3;
			
			if (monster_hp() > 310 && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].equipped()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			
			if (get_property("banishedMonsters").contains_text(mob_str)) abort("There appear to be multiple copies of an unexpected monster.");
			$skill[Give Your Opponent the Stinkeye].try_use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].try_use();
			$skill[Breathe Out].try_use();
			if (get_property("_snokebombUsed").to_int() < 1 && $skill[Snokebomb].have()) $skill[Snokebomb].use();
			else if (!get_property("banishedMonsters").contains_text(mob_str)) $item[Louder Than Bomb].throw_item();
		}
		
		if (mob == $monster[Eldritch Tentacle] && $item[haiku katana].have_equipped()) {
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis(10, 317).url_encode(), true, true);
			$skill[Summer Siesta].try_use();
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis_finish(10, 317).url_encode(), true, true);
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
			visit_url("fight.php?action=macro&macrotext=" + macro_zeppelin_stasis(10, 317).url_encode(), true, true);
		}
		
		if (mob == $monster[Red Fox]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials().url_encode(), true, true);
			abort("Received a Red Fox semi-rare, somehow.");
		}

		visit_url("fight.php?action=macro&macrotext=" + macro_stasis_scaler_finish(10).url_encode(), true, true);
		
		if (mob == $monster[God Lobster]) multi_fight();
		
		if (my_location() != $location[The Tunnel of L.O.V.E.]) multi_fight();
		
		if (get_property("aen_giant_rubber_spider").to_boolean()) {
			cli_execute("send rubber spider to anng || Please use this on me--thanks!");
			set_property("aen_giant_rubber_spider", "false");
		}

		if (get_property("aen_anng_pranks").to_int() == 54) {
			set_property("aen_anng_pranks", 0);
			cli_execute("send spice melange to anng || Thanks for 54 pranks! Here's the payment for the next 54!");
		}
	} 
}

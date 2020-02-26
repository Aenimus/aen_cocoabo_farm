script "aen_combat.ash";

import "aen_resources.ash";
import "aen_macros.ash";

void main(int rnd, monster mob, string pg) {
	if (can_interact() && get_property("_aen_cocoabo_farm").to_boolean()) {
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
		
		if (mob == $monster[Witchess Knight]) { // @TODO Not necessarily the copy target.
			item [int] funks;

			int spookies = get_property("spookyPuttyCopiesMade").to_int();
			int rainies = get_property("_raindohCopiesMade").to_int();

			if  (spookies + rainies < 6) {
				if  (spookies < 5) get_funky(funks, $item[Spooky Putty sheet]);
				if  (rainies < 5) get_funky(funks, $item[Rain-Doh black box]);
			}

			if (!get_property("_cameraUsed").to_boolean() && !$item[shaking 4-d camera].have()) {
				get_funky(funks, $item[4-d camera]);
				get_funky(funks, $item[unfinished ice sculpture]);
			}
			
			if (get_property("enamorangMonster") == "") get_funky(funks, enamorang);
			if  (count(funks) == 1) throw_item(funks[0]);
			
			if ($skill[Duplicate].have_skill()) {
				use_skill(1, $skill[Duplicate]);
			}
			
			if (my_familiar() == $familiar[Pocket Professor] && have_skill(7319.to_skill())) {
				use_skill(1, 7319.to_skill());
				visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish.url_encode(), true, true);
			} else {
				visit_url("fight.php?action=macro&macrotext=" + macro_no_meteor_finish.url_encode(), true, true);
			}
		}
		
		if (mob == $monster[Knob Goblin Embezzler]) {
			item [int] funks;
		
			if (get_property("_sourceTerminalDigitizeUses").to_int() < 1 && $skill[Digitize].have_skill()) {
				use_skill(1, $skill[Digitize]);
				rnd++;
			}
			
			/*while(!get_property("_cameraUsed").to_boolean() && !$item[shaking 4-d camera].have()) {
				get_funky(funks, $item[4-d camera]);
				get_funky(funks, $item[4-d camera]);
				if  (count(funks) == 1) throw_item(funks[0]);
				rnd++;
			} */ // removed because pill keeper is just cheaper.
			
			while(monster_hp() > 310 && rnd < 10) {
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
			
			if($skill[Summer Siesta].have()) $skill[Summer Siesta].use();
			visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		}
		
		if (mob == $monster[giant sandworm]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 310 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}

			visit_url("fight.php?action=macro&macrotext=" + macro_free_kills.url_encode(), true, true);
			if ($item[replica bat-oomerang].have() && get_property("_usedReplicaBatoomerang").to_int() < 3) $item[replica bat-oomerang].throw_item();
			if ($item[power pill].have() && get_property("_powerPillUses").to_int() < 20) $item[power pill].throw_item();
			else abort("You have run out of power pills.");
			// if (monster_hp() > 0) abort("Something went wrong while fighting a giant sandworm.");
		}
		
		if (mob == $monster[pygmy bowler]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			use_skill(1, $skill[Snokebomb]);
		}

		if (mob == $monster[pygmy orderlies]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			if ($skill[reflex hammer].have()) $skill[reflex hammer].use();
			else abort("Banish the pygmy orderlies, somehow.");
		}
		
		if (mob == $monster[pygmy janitor]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			abort("Banish the janitors in the park.");
		}
		
		if (mob == $monster[drunk pygmy] && get_property("_drunkPygmyBanishes").to_int() > 9) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 310 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}

			if (get_property("aen_use_force").to_boolean()) {
				use_skill(1, 7311.to_skill());
				set_property("aen_use_force", "false");
				run_choice(2);
			}
		}
		
		if (mob == $monster[gingerbread convict] || mob == $monster[gingerbread finance bro] || mob == $monster[gingerbread gentrifier]
			|| mob == $monster[gingerbread lawyer] || mob == $monster[gingerbread tech bro]) {
			if (shower.have()) shower.use();
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			while(monster_hp() > 310 && rnd < 8) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			$item[gingerbread cigarette].throw_item();
		}
		
		if (mob == $monster[tumbleweed]) {
			abort();
		}
		
		if (mob == $monster[gingerbread rat] || mob == $monster[gingerbread pigeon]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			if (get_property("_snokebombUsed").to_int() > 1) $skill[Snokebomb].use();
			$skill[Asdon Martin: Spring-Loaded Front Bumper].use();
		}
		
		if (mob == $monster[banshee librarian] || mob == $monster[writing desk]) {
			visit_url("fight.php?action=macro&macrotext=" + macro_essentials.url_encode(), true, true);
			if ($skill[Reflex Hammer].have()) $skill[Reflex Hammer].use();
			if ($skill[Snokebomb].have()) $skill[Snokebomb].use();
		}

		if (mob == $monster[bookbat]) {
		
			string pickpocket = visit_url("fight.php?action=steal", true);
			matcher picks = create_matcher("You acquire an item: <b>tattered scrap of paper</b>", pickpocket);
			rnd++;
			
			while (!picks.find() && monster_hp() > 310 && rnd < 30 && cracker.have()) {
				pickpocket  = throw_item(cracker);
				picks = create_matcher("You acquire an item: <b>tattered scrap of paper</b>", pickpocket);
				rnd++;
			}
			
			if (my_familiar() == $familiar[Crimbo Shrub] && !$effect[Everything Looks Red].have()) {
				$skill[Open a Big Red Present].use();
				rnd++;
			}
			
			if (monster_hp() > 310 && rnd < 30) {
				extract.use();
				rnd++;
			}
			
			if (get_property("_pantsgivingCrumbs").to_int() < 10 && monster_hp() > 310 && rnd < 30) {
				crumbs.try_use();
				rnd++;
			}
			
			if (monster_hp() > 310 && rnd < 30 && get_property("_vampyreCloakeFormUses").to_int() < 10 && $item[vampyric cloake].have_equipped()) {
				$skill[Become a Wolf].use();
				rnd++;
			}
			while (monster_hp() > 310 && rnd < 3) {
				$item[seal tooth].throw_item();
				rnd++;
			}
			
			if (navel.have_equipped() || (my_familiar() == stomp_boots || (my_familiar() == bander && $effect[Ode to Booze].have()))) {
				if (navel.have_equipped() && (my_familiar() == stomp_boots || (my_familiar() == bander && $effect[Ode to Booze].have()))) {
					abort("Check two simultaneous runaways methods.");
				}
				runaway();
			} else {
				if (get_property("_gallapagosMonster") != "bookbat") $skill[Gallapagosian Mating Call].try_use();
				$skill[Give Your Opponent the Stinkeye].try_use();
				$skill[Creepy Grin].try_use();
				$skill[KGB tranquilizer dart].try_use();
				$skill[Gulp Latte].try_use();
				$skill[Throw Latte On Opponent].try_use();
			}
		}
		
		if (mob == $monster[Eldritch Tentacle] && $item[haiku katana].have_equipped()) {
			visit_url("fight.php?action=macro&macrotext=" + macro_stasis.url_encode(), true, true);
			if($skill[Summer Siesta].have()) $skill[Summer Siesta].use();
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
		
		if (my_familiar() == $familiar[Machine Elf]) visit_url("fight.php?action=macro&macrotext=" + macro_essentials_finish.url_encode(), true, true);
		
		visit_url("fight.php?action=macro&macrotext=" + macro_finish.url_encode(), true, true);
		
		if (my_location() != $location[The Tunnel of L.O.V.E.]) multi_fight();

	} 
}

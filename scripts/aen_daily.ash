script "aen_daily.ash";

void daily_aftercore() {
	if (vip_key.have()) {
		if (!get_property("_aprilShower").to_boolean()) cli_execute("shower ice");
		if (!get_property("_olympicSwimmingPool").to_boolean()) visit_url("clan_viplounge.php?whichfloor=2&preaction=goswimming&subaction=laps&pwd=" + my_hash());
		while (get_property("_poolGames").to_int() < 3) visit_url("clan_viplounge.php?whichfloor=2&preaction=poolgame&stance=1&pwd=" + my_hash());
		if (!get_property("_clanFortuneBuffUsed").to_boolean()) {
			int roll = random(2);
			if (roll == 1) roll = 2;
			roll = roll + 1;
			visit_url("clan_viplounge.php?preaction=lovetester");
			visit_url("choice.php?whichchoice=1278&option=1&which=-" + roll + "&pwd=" + my_hash());
		}
	}
	if (kgb.fetch()) {
		while (get_property("_kgbClicksUsed").to_int() < 22) cli_execute("briefcase b items");
	}
		
	if (get_property("getawayCampsiteUnlocked").to_boolean()) {
		while (get_property("_campAwaySmileBuffs").to_int() < 3) visit_url("place.php?whichplace=campaway&action=campaway_sky");
	}
	if (!get_property("_lyleFavored").to_boolean()) visit_url("place.php?whichplace=monorail&action=monorail_lyle");
	visit_url("choice.php");
	if (!get_property("_allYearSucker").to_boolean()) $item[all-year sucker].try_use();
	if (get_property("timesRested").to_int() < 1 && total_free_rests() > 0) visit_url("campground.php?action=rest");
	if (!get_property("_daycareSpa").to_boolean()) cli_execute("daycare mysticality");
	if (!get_property("oscusSodaUsed").to_boolean()) $item[Oscus\'s neverending soda].try_use();
	if (!get_property("_perfectlyFairCoinUsed").to_boolean()) $item[perfectly fair coin].try_use();
	if (!get_property("_incredibleSelfEsteemCast").to_boolean()) $skill[Incredible Self-Esteem].try_use();
	if (!get_property("_bowleggedSwaggerUsed").to_boolean()) $skill[Bow-Legged Swagger].try_use();
	if (!get_property("_bendHellUsed").to_boolean()) $skill[Bend Hell].try_use();
	if (!get_property("_steelyEyedSquintUsed").to_boolean()) $skill[Steely-Eyed Squint].try_use();
	if (!get_property("_glennGoldenDiceUsed").to_boolean()) $item[Glenn\'s golden dice].try_use(); // There comes a point where this is just yielding passive damage
	if (!get_property("_defectiveTokenUsed").to_boolean()) $item[defective Game Grid token].try_use();
	if (!get_property("_legendaryBeat").to_boolean()) $item[The Legendary Beat].try_use();
	if (!get_property("_fishyPipeUsed").to_boolean()) $item[fishy pipe].try_use();
	if (!get_property("telescopeLookedHigh").to_boolean()) visit_url("campground.php?action=telescopehigh&pwd=" + my_hash());
	if (!get_property("_ballpit").to_boolean()) visit_url("clan_rumpus.php?preaction=ballpit&pwd=" + my_hash());
	if (get_property("questL06Friar") == "finished" && !get_property("friarsBlessingReceived").to_boolean()) visit_url("friars.php?action=buffs&bro=1&pwd=" + my_hash());
	if (!get_property("_favoriteBirdVisited").to_boolean()) $skill[\Visit your Favorite Bird].try_use();
	if (get_campground() contains $item[Witchess Set] && !get_property("_witchessBuff").to_boolean()) {
		visit_url("campground.php?action=witchess");
		run_choice(3);
		run_choice(2);
	}
	while (get_campground() contains $item[Source Terminal] && get_property("_sourceTerminalEnhanceUses").to_int() < 3) cli_execute("terminal enhance meat");
	visit_url("choice.php");
	if (!get_property("_bagOTricksUsed").to_boolean()) $item[Bag o\' Tricks].try_use();
}
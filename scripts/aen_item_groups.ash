script "aen_item_groups.ash";

boolean untinker_can = get_property("_aen_untinker_can").to_boolean();

record item_group {
	boolean paste_group;
	skill source;
	boolean can;
	item [int] items;
	int surplus;
	boolean rare_diminish;
	string summons;
	int max_rares;
	float rate;
	item [int] rares;
	item product;
};

item_group ig_etched() {
	item_group ig_etched;
	ig_etched.paste_group = true;
	ig_etched.items[0] = $item[hourglass];
	ig_etched.items[1] = $item[pile of sand];
	if (ig_etched.paste_group && !untinker_can) ig_etched.items[count(ig_etched.items)] = $item[Loathing Legion knife];
	ig_etched.product = $item[etched hourglass];
	return ig_etched;
}


// Elemental foldables
item_group ig_stinky() {
	item_group ig_stinky;
	
	ig_stinky.items[0] = $item[stinky cheese sword];
	ig_stinky.items[1] = $item[stinky cheese diaper];
	ig_stinky.items[2] = $item[stinky cheese wheel];
	ig_stinky.items[3] = $item[stinky cheese eye];
	ig_stinky.items[4] = $item[Staff of Queso Escusado];
	return ig_stinky;
}

item_group ig_legion() {
	item_group ig_legion;
	
	ig_legion.items[0] = $item[Loathing Legion helicopter];
	ig_legion.items[1] = $item[Loathing Legion universal screwdriver];
	ig_legion.items[2] = $item[Loathing Legion knife];
	ig_legion.items[3] = $item[Loathing Legion abacus];
	ig_legion.items[4] = $item[Loathing Legion can opener];
	ig_legion.items[5] = $item[Loathing Legion chainsaw];
	ig_legion.items[6] = $item[Loathing Legion corkscrew];
	ig_legion.items[7] = $item[Loathing Legion defibrillator];
	ig_legion.items[8] = $item[Loathing Legion double prism];
	ig_legion.items[9] = $item[Loathing Legion electric knife];
	ig_legion.items[10] = $item[Loathing Legion flamethrower];
	ig_legion.items[11] = $item[Loathing Legion hammer];
	ig_legion.items[12] = $item[Loathing Legion jackhammer];
	ig_legion.items[13] = $item[Loathing Legion kitchen sink];
	ig_legion.items[14] = $item[Loathing Legion many-purpose hook];
	ig_legion.items[15] = $item[Loathing Legion moondial];
	ig_legion.items[16] = $item[Loathing Legion necktie];
	ig_legion.items[17] = $item[Loathing Legion pizza stone];
	ig_legion.items[18] = $item[Loathing Legion rollerblades];
	ig_legion.items[19] = $item[Loathing Legion tape measure];
	ig_legion.items[20] = $item[Loathing Legion tattoo needle];
	return ig_legion;
}


// Libram summons
item_group ig_libram_brick() {
	item_group ig_libram_brick;
	
	ig_libram_brick.source = $skill[Summon BRICKOs];
	ig_libram_brick.can = ig_libram_brick.source.have_skill();
	
	ig_libram_brick.items[0] = $item[BRICKO brick];
	ig_libram_brick.surplus = $item[BRICKO brick].mall_price() * 2;
	
	ig_libram_brick.rare_diminish = true;
	ig_libram_brick.summons = "ig_libram_brick_summons";
	int summons = get_property("_brickoEyeSummons").to_int();
	ig_libram_brick.max_rares = 3;
	if (summons < 3) {
		ig_libram_brick.rate = 0.5 ** (summons + 1);
		ig_libram_brick.rares[0] = $item[BRICKO eye brick];
	}
	return ig_libram_brick;
}

item_group ig_libram_dice() {
	item_group ig_libram_dice;

	ig_libram_dice.source = $skill[Summon Dice];
	ig_libram_dice.can = ig_libram_dice.source.have_skill();

	ig_libram_dice.items[0] = $item[d4];
	ig_libram_dice.items[1] = $item[d6];
	ig_libram_dice.items[2] = $item[d8];
	ig_libram_dice.items[3] = $item[d10];
	ig_libram_dice.items[4] = $item[d12];
	ig_libram_dice.items[5] = $item[d20];
	return ig_libram_dice;
}

item_group ig_libram_favor() {
	item_group ig_libram_favor;
	
	ig_libram_favor.source = $skill[Summon Party Favor];
	ig_libram_favor.can = ig_libram_favor.source.have_skill();
	
	ig_libram_favor.items[0] = $item[divine blowout];
	ig_libram_favor.items[1] = $item[divine can of silly \string];
	ig_libram_favor.items[2] = $item[divine noisemaker];
	
	ig_libram_favor.rare_diminish = true;
	ig_libram_favor.summons = "ig_libram_favor_summons";
	int summons = get_property("_favorRareSummons").to_int();
	ig_libram_favor.rate = 0.5 ** (summons + 1);
	
	// Handling for 4 poppers this day
	ig_libram_favor.rares[0] = $item[divine champagne popper];
	ig_libram_favor.rares[1] = $item[divine champagne flute];
	ig_libram_favor.rares[2] = $item[divine cracker];
	return ig_libram_favor;
}

item_group ig_libram_heart() {
	item_group ig_libram_heart;

	ig_libram_heart.source = $skill[Summon Candy Heart];
	ig_libram_heart.can = ig_libram_heart.source.have_skill();

	ig_libram_heart.items[0] = $item[green candy heart];
	ig_libram_heart.items[1] = $item[lavender candy heart];
	ig_libram_heart.items[2] = $item[orange candy heart];
	ig_libram_heart.items[3] = $item[pink candy heart];
	ig_libram_heart.items[4] = $item[white candy heart];
	ig_libram_heart.items[5] = $item[yellow candy heart];
	return ig_libram_heart;
}

item_group ig_libram_reso() {
	item_group ig_libram_reso;

	ig_libram_reso.source = $skill[Summon Resolutions];
	ig_libram_reso.can = ig_libram_reso.source.have_skill();

	ig_libram_reso.items[0] = $item[resolution: be feistier];
	ig_libram_reso.items[1] = $item[resolution: be happier];
	ig_libram_reso.items[2] = $item[resolution: be sexier];
	ig_libram_reso.items[3] = $item[resolution: be smarter];
	ig_libram_reso.items[4] = $item[resolution: be stronger];
	ig_libram_reso.items[5] = $item[resolution: be wealthier];
	
	ig_libram_reso.rate = 0.02;
	
	ig_libram_reso.rares[0] = $item[resolution: be more adventurous];
	ig_libram_reso.rares[1] = $item[resolution: be kinder];
	ig_libram_reso.rares[2] = $item[resolution: be luckier];
	return ig_libram_reso;
}

item_group ig_libram_song() {
	item_group ig_libram_song;

	ig_libram_song.source = $skill[Summon Love Song];
	ig_libram_song.can = ig_libram_song.source.have_skill();

	ig_libram_song.items[0] = $item[love song of disturbing obsession];
	ig_libram_song.items[1] = $item[love song of icy revenge];
	ig_libram_song.items[2] = $item[love song of naughty innuendo];
	ig_libram_song.items[3] = $item[love song of smoldering passion];
	ig_libram_song.items[4] = $item[love song of sugary cuteness];
	ig_libram_song.items[5] = $item[love song of vague ambiguity];
	return ig_libram_song;
}

item_group ig_libram_taffy() {
	item_group ig_libram_taffy;

	ig_libram_taffy.source = $skill[Summon Taffy];
	ig_libram_taffy.can = ig_libram_taffy.source.have_skill();

	ig_libram_taffy.items[0] = $item[pulled blue taffy];
	ig_libram_taffy.items[1] = $item[pulled orange taffy];
	ig_libram_taffy.items[2] = $item[pulled red taffy];
	ig_libram_taffy.items[3] = $item[pulled violet taffy];
	
	ig_libram_taffy.rare_diminish = true;
	ig_libram_taffy.summons = "ig_libram_taffy_summons";
	int summons = get_property("_taffyRareSummons").to_int();
	int yellow = get_property("_taffyYellowSummons").to_int();
	ig_libram_taffy.max_rares = 4;
	ig_libram_taffy.rate = 0.5 ** (summons +1);
	if (summons - yellow < 3) {
		ig_libram_taffy.rares[0] = $item[pulled green taffy];
		ig_libram_taffy.rares[1] = $item[pulled indigo taffy];
	}
	
	if (yellow < 1) ig_libram_taffy.rares[2] = $item[pulled yellow taffy];
	return ig_libram_taffy;
}
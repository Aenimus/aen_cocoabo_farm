script "aen_libram.ash";

item_group [int] libram_get() {
	item_group [int] librams = {
		0: ig_libram_brick(),
		1: ig_libram_dice(),
		2: ig_libram_favor(),
		3: ig_libram_heart(),
		4: ig_libram_reso(),
		5: ig_libram_song(),
		6: ig_libram_taffy()
	};
	return librams;
}

item_group libram_worth() {
	item_group [int] librams = libram_get();
	item_group [float] worth;
	foreach lib in librams {
		item_group ig_lib = librams[lib];
		if (ig_lib.can) {
			float total = 0;
			float c_total = 0;
			float r_total = 0;
			float value = 0;
			int rares = count(ig_lib.rares);
			foreach it in ig_lib.items {
				value = ig_lib.items[it].mall_price();
				value += ig_lib.surplus; // For BRICKOs
				c_total += value;
				value = 0;
			}
			c_total = c_total/count(ig_lib.items);
			if (rares > 0) {
				foreach it in ig_lib.rares {
					value = ig_lib.rares[it].mall_price();
					value += ig_lib.surplus;
					r_total += value;
					value = 0;
				}
				float rate = ig_lib.rate;
				r_total = (r_total/rares) * rate;
				rate = 1 - rate; // Reverses the rate to get the common rate.
				c_total = c_total * rate;
			}
			total = c_total + r_total;
			worth[total] = ig_lib;
		}
	}
	foreach ig_lib in worth
		print(worth[ig_lib].source.to_string() + ": " + ig_lib, "purple");
	float best = 0;
	float current;
	item_group chosen;
	foreach ig_lib in worth {
		current = ig_lib;
		if (current > best) {
			best = current;
			chosen = worth[ig_lib];
		}
	}
	print("The most economic libram skill is " + chosen.source + " at " + best + " meat per cast.");
	return chosen;
}

string libram_today(boolean assess) {
	if (assess) {
		string libram = libram_worth().source.to_string();
		set_property("_aen_libram_today", libram);
	}
	return get_property("_aen_libram_today");
}

string libram_today() {
	return libram_today(false);
}

boolean libram_rare_run() {
	boolean stop = false;
	while (true) {
		item_group ig_lib = libram_worth();
		if (!ig_lib.rare_diminish) return true;
		skill source = ig_lib.source;
		int summons = ig_lib.get_summons();
		if (ig_lib.max_rares <= summons) return true;
		while (summons + 1 > ig_lib.get_summons()) {
			source.use(); //@TODO Check for MP
		}
		print("Successfully received a " + ig_lib.source.to_string() + " rare.", "green");
	}
}
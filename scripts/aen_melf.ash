script "aen_melf.ash";

boolean melf_have() {
	return $familiar[Machine Elf].have();
}

int melf_fights() {
	return get_property("_machineTunnelsAdv").to_int();
}

boolean melf_free_fight_can() {
	return melf_have() && melf_fights() < 5;
}

boolean melf_free_fight_run() {
	int fights = melf_fights();
	$familiar[Machine Elf].use();
	hookah.try_equip();
	print("Preparing to fight Machine Elf free fight #" + (fights + 1) + ".", "purple");
	adv1($location[The Deep Machine Tunnels], -1, "");
	if (melf_fights() > 4 && hookah.equipped()) equip(fam, $item[None]);
	return melf_fights() > fights;
}
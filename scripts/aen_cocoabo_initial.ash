script "aen_cocoabo_initial.ash";

import "aen_utils.ash";

void main(string alternative_outfit, // Name of the outfit to use without your cocoabo; free stuff like screege and cheeng's.
	string cocoabo_outfit, // Name of the outfit to use with your cocoabo; +weight and screege.
	string embezzler_outfit, // Name of the outfit to use vs. Embezzlers; +meat and +weight.
	string pickpocket_outfit, // Name of the outfit with max +pickpocket chance; for free runs to steal tattered scraps.
	string max_weight_outfit, // Name of the outfit that is absolute max familiar weight.
	string day_clan, // Name of the clan during the day; should have a full VIP lounge.
	string rollover_clan, // Name of the clan you use during rollover; ideally +meat and buffs.
	string copy_monster, // Name of the monster you'll copy where possible; usually Witchess Knight.
	string camera_monster // Name of the monster you'll photocopy and camera copy; usually Witchess Knight or Embezzler (without pill keeper).
	) {
	if (embezzler_outfit != "") set_property("aen_embezzler_outfit", embezzler_outfit);
	if (cocoabo_outfit != "") set_property("aen_cocoabo_outfit", cocoabo_outfit);
	if (alternative_outfit != "") set_property("aen_alternative_outfit", alternative_outfit);
	if (pickpocket_outfit != "") set_property("aen_pickpocket_outfit", pickpocket_outfit);
	if (max_weight_outfit != "") set_property("aen_max_weight_outfit", max_weight_outfit);
	if (day_clan != "") set_property("aen_day_clan", day_clan);
	if (rollover_clan != "") set_property("aen_rollover_clan", rollover_clan);
	if (copy_monster != "") set_property("aen_copy_monster", copy_monster);
	if (camera_monster != "") set_property("aen_camera_monster", camera_monster);
	
	foreach kit in $strings[max_weight_outfit,
		pickpocket_outfit
	] {
		call string kit().change_outfit();
		foreach sl in $slots[hat,
			back,
			shirt,
			weapon,
			off-hand,
			pants,
			acc1,
			acc2,
			acc3] {
			set_property("aen_" + kit + "_" + sl.to_string(), sl.equipped_item());
		}
		if ($item[snow suit].fetch()) set_property("aen_max_weight_outfit_fam_equip", $item[Snow Suit].to_string());
		else set_property("aen_max_weight_outfit_fam_equip", $item[sugar shield].to_string());
	}
}
script "aen_hookah.ash";
import "aen_utils.ash";

void hookah_uneffect() {
	if (hookah.have_equipped()) {
		foreach eff in $effects[
			Apoplectic with Rage,
			Barfpits,
			Berry Thorny,
			Biologically Shocked,
			Bone Homie,
			Boner Battalion,
			Burning\, Man,
			Coal-Powered,
			Curse of the Black Pearl Onion,
			Dizzy with Rage,
			Drenched With Filth,
			EVISCERATE\!,
			Fangs and Pangs,
			Frigidalmatian,
			Gummi Badass,
			Haiku State of Mind,
			It's Electric!,
			Jaba&ntilde;ero Saucesphere,
			Jalape&ntilde;o Saucesphere,
			Little Mouse Skull Buddy,
			Long Live GORF,
			Mayeaugh,
			Permanent Halloween,
			Psalm of Pointiness,
			Pygmy Drinking Buddy,
			Quivering with Rage,
			Scarysauce,
			Skeletal Cleric,
			Skeletal Rogue,
			Skeletal Warrior,
			Skeletal Wizard,
			Smokin\',
			Soul Funk,
			Spiky Frozen Hair,
			Stinkybeard,
			Stuck-Up Hair,
			Can Has Cyborger,
			Yes\, Can Haz
		 ] {
			if (!sgeea.have()) abort("Acquire more soft green echo eyedrop antidotes.");
			if (eff.have()) cli_execute("uneffect " + eff.to_string());
		}
	}
}
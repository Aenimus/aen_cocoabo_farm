script "aen_post.ash";

import "aen_utils.ash";

if (my_location() == $location[The Hidden Bowling Alley] && can_interact()) {
	multi_fight();
}

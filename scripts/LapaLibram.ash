script <LapaLibram.ash>;

import "aen_utils.ash";

record LibramResource
{
	skill source;
	boolean [item] commons;
	boolean [item] rares;
	string rare_rate;
	string diminishing;
};

LibramResource [int] librams = {
	0: new LibramResource(
		$skill[Summon BRICKOs],
		$items[BRICKO brick],
		$items[BRICKO eye brick],
		"(pref(_brickoEyeSummons,0)*0.5)+(pref(_brickoEyeSummons,1)*0.33)+(pref(_brickoEyeSummons,2)*0.33)",
		"1"
	),
	1: new LibramResource(
		$skill[Summon Dice],
		$items[d4, d6, d8, d10, d12, d20],
		$items[none],
		"",
		"0"
	),
	2: new LibramResource(
		$skill[Summon Party Favor],
		$items[divine noisemaker, divine can of silly string, divine blowout],
		$items[divine champagne flute, divine champagne popper, divine cracker],
		"0.5^(pref(_favorRareSummons)+1)"
		"1"
	),
	3: new LibramResource(
		$skill[Summon Candy Heart],
		$items[white candy heart, pink candy heart, orange candy heart, lavender candy heart, yellow candy heart, green candy heart],
		$items[none],
		"",
		"0"
	),
	4: new LibramResource(
		$skill[Summon Resolutions],
		$items[resolution: be feistier, resolution: be happier, resolution: be sexier, resolution: be smarter, resolution: be stronger, resolution: be wealthier],
		$items[resolution: be more adventurous, resolution: be kinder, resolution: be luckier],
		"((pref(_resolutionRareSummons,0)+pref(_resolutionRareSummons,1)+pref(_resolutionRareSummons,2))*0.12)+0.02",
		"pref(_resolutionRareSummons,0)+pref(_resolutionRareSummons,1)+pref(_resolutionRareSummons,2)"
	),
	5: new LibramResource(
		$skill[Summon Love Song],
		$items[love song of disturbing obsession, love song of icy revenge, love song of naughty innuendo, love song of smoldering passion, love song of sugary cuteness, love song of vague ambiguity],
		$items[none],
		"",
		"0"
	),
	6: new LibramResource(
		$skill[Summon Taffy],
		$items[pulled blue taffy, pulled orange taffy, pulled red taffy, pulled violet taffy],
		get_int( "_taffyYellowSummons" ) > 0 ? $items[pulled green taffy, pulled indigo taffy] : $items[pulled green taffy, pulled indigo taffy, pulled yellow taffy],
		"(pref(_taffyRareSummons,0)*0.5^1)+(pref(_taffyRareSummons,1)*0.5^2)+(pref(_taffyRareSummons,2)*0.5^3)+(pref(_taffyRareSummons,3)*0.5^4)",
		"pref(_taffyRareSummons,0)+pref(_taffyRareSummons,1)+pref(_taffyRareSummons,2)+pref(_taffyRareSummons,3)"
	),
};

boolean is_usable( LibramResource libram )
{
    return libram.source.have_skill();
}

boolean is_diminishing( LibramResource libram )
{
	return ( libram.diminishing.modifier_eval() == 1 );
}

float get_average_value( boolean [item] items )
{
    if ( count( items ) == 0 )
    {
        return 0;
    }

    float total;

    foreach it in items
    {
        total += it.mall_price();
    }
    return total / count( items );
}

float get_rare_rate( LibramResource libram )
{
    if ( libram.rare_rate == "" )
    {
        return 0;
    }
    return libram.rare_rate.modifier_eval();
}

float get_value( LibramResource libram, boolean only_usable )
{
    if ( only_usable && !libram.is_usable() )
    {
        return 0;
    }

    // BRICKOs are like a regular libram except they always give an additional 2 BRICKO bricks
    int additional_commons = ( libram.source == $skill[Summon BRICKOs] ) ? 2 : 0;

    float rare_rate = libram.get_rare_rate();

    float common_value = libram.commons.get_average_value();

    float rare_value = libram.rares.get_average_value();

    return ( rare_rate * ( rare_value - common_value ) ) + ( ( additional_commons + 1 ) * common_value );
}

float get_value( LibramResource libram )
{
    return libram.get_value( false );
}

void summon_libram()
{
	skill libram_skill;

	if ( get_property( "_lapaLibram") != "" )
	{
		libram_skill = get_property( "_lapaLibram" ).to_skill();
		print( `Attempting to cast {libram_skill}.`, "purple" );
		cli_execute( `cast * {libram_skill}` ); // 3 times to counteract the 200 limit per asterisk
		cli_execute( `cast * {libram_skill}` );
		cli_execute( `cast * {libram_skill}` );
		return;
	}

    while ( true )
    {
		sort librams by -value.get_value( true );

		LibramResource libram = librams[0];

		libram_skill = libram.source;

		print(libram_skill);

		if ( libram_skill.mp_cost() > my_mp() )
		{
			return;
		}

		if ( !libram.is_diminishing() || libram.get_rare_rate() == 0 )
		{
			set_property( "_lapaLibram", libram_skill );
			summon_libram();
			return;
		}

		print( `Attempting collect a {libram_skill} rare.`, "purple" );
        libram_skill.use();
    }
}

LibramResource get_most_profitable_libram( boolean only_usable )
{
    sort librams by -value.get_value( only_usable );
	LibramResource libram = librams[0];

	if ( libram.is_diminishing() )
	{
		set_property( "_lapaLibramToday", libram.source );
	}

    return libram;
}

LibramResource get_most_profitable_libram()
{
    return get_most_profitable_libram( true );
}

void explain()
{
    sort librams by -value.get_value( true );
    foreach i, libram in librams if ( libram.is_usable() )
    {
        print( `{i}: {libram.source} @ {libram.get_value()} per cast.` );
    }
}

void main()
{
	explain();
}
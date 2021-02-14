import <canadv.ash>;

boolean _outfit( string outfit_name )
{
	if ( outfit( outfit_name ) )
    {
        return true;
    }

	foreach i, it in outfit_pieces( outfit_name ) if ( it.equipped_amount() + it.item_amount() == 0 )
    {
        if ( count( it.get_related( "fold") ) > 0 )
        {
		    cli_execute( `try; fold {it.name}` );
        }

        cli_execute( `try; acquire {it.name}` );
	}
    
    return outfit( outfit_name );
}


monster _get_current_fax()
{
	string logs = visit_url("clan_log.php");
	matcher last_fax = "(\\d{2}\/\\d{2}\/\\d{2}, \\d{2}:\\d{2}(?:AM|PM): )<a [^>]+>([^<]+)<\/a>( faxed in a (.*?))<br>".create_matcher(logs);

	if ( !last_fax.find() )
    {
        return $monster[none];
    }

	return last_fax.group(4).to_monster();
}

location _get_monster_location( monster target, boolean check_can_adv )
{
	foreach loc in $locations[] if ( !check_can_adv || loc.can_adv() )
    {
		foreach m, ar in loc.appearance_rates() if ( m == target )
        {
			return loc;
		}
	}

	return $location[none];
}

location _get_monster_location( monster target )
{
    return _get_monster_location( target, false );
}

record TypeThing
{
    string type;
    string thing;
};

TypeThing to_type_thing( string value )
{
    int first_space = value.index_of(" ");

    if ( first_space < 0 )
    {
        return new TypeThing( value, "" );
    }

    string type = value.substring( 0, first_space );
    string thing = value.substring( type.length() + 1 );

    return new TypeThing( type, thing );
}

string table_to_html( string [int, int] table )
{
    string output;

    foreach i in table {
        string row = "";
        foreach j, cell in table[i]
        {
            row += `<td>{cell}</td>`;
        }
        output += `<tr>{row}</tr>`;
    }

    return `<table border=1>{output}</table>`;
}

int _increment_property( string prop, int amount )
{
    int value = get_property( prop ).to_int() + amount;
    set_property( prop, value );
    return value;
}

int _increment_property( string prop )
{
    return _increment_property( prop, 1 );
}

string _pluralize(item it, int quantity)
{
	return quantity + " " + (quantity == 1 ? it.name : it.plural);
}

int _occurrences( string haystack, string needle )
{
    int cursor = -1;
    int count = 0;
    while ( true )
    {
        cursor = haystack.index_of( needle, cursor + 1 );

        if ( cursor < 0 )
        {
            break;
        }

        count++;
    }

    return count;
}

string ADVENTURE_PATTERN = "(-?[0-9]+)-(-?[0-9]+)";

float _average_adventures ( item it )
{
    string adv = it.adventures;

    if ( adv.index_of( "-" ) < 0 )
    {
        return adv.to_float();
    }
    else
    {
        matcher m = ADVENTURE_PATTERN.create_matcher( adv );
        if ( !m.find() )
        {
            abort( `Cannot parse {adv}` );
        }

        return ( m.group( 1 ).to_int() + m.group( 2 ).to_int() ) / 2;
    }
}

string _image( string path, int size )
{
    return `<img src="https://s3.amazonaws.com/images.kingdomofloathing.com/{path}" height={size} />`;
}

string _image( string path )
{
    return _image( path, 12 );
}

string _commas( int number )
{
    string n = number.to_string();
    string result;
    int last_char = n.length() - 1;
    for i from 0 to last_char
    {
        if ( i > 0 && ( i % 3 == 0 ) )
        {
            result = "," + result;
        }
        result = n.char_at( last_char - i ) + result;
    }
    return result;
}

int _max_at_songs() {
	return ( boolean_modifier( "Four Songs" ) ? 4 : 3 ) + numeric_modifier( "Additional Song" );
}

int _at_songs() {
	int songs;

	foreach eff in my_effects()
    {
        skill sk = eff.to_skill();
        songs += ( sk.class == $class[Accordion Thief] && sk.buff ) ? 1 : 0;
	}

	return songs;
}

effect _current_song()
{
    foreach eff in my_effects() if ( eff.to_skill().song )
    {
        return eff;
    }

    return $effect[none];
}

effect _current_expression()
{
    foreach eff in my_effects() if ( eff.to_skill().expression )
    {
        return eff;
    }

    return $effect[none];
}

effect _current_walk()
{
    foreach eff in my_effects() if ( eff.to_skill().walk )
    {
        return eff;
    }

    return $effect[none];
}

boolean _can_cast( skill sk )
{
    if ( !sk.have_skill() || ( !can_interact() && !sk.is_unrestricted() ) )
    {
        return false;
    }
    
    if ( sk.mp_cost() > my_mp() || sk.hp_cost() > my_hp() || sk.adv_cost() > my_adventures() )
    {
        return false;
    }

    if ( sk.dailylimit >= 0 && sk.timescast > sk.dailylimit )
    {
        return false;
    }

    if ( sk.combat && current_round() == 0 )
    {
        return false;
    }

    if ( sk.buff && sk.class == $class[Accordion Thief] && _at_songs() >= _max_at_songs() )
    {
        return false;
    }

    return true;
}
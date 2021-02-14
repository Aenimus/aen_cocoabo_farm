import <lod.ash>;

boolean [item] fuel_blacklist = $items[cup of &quot;tea&quot;, thermos of &quot;whiskey&quot;, Lucky Lindy, Bee's Knees, Sockdollager, Ish Kabibble, Hot Socks, Phonus Balonus, Flivver, Sloppy Jalopy, glass of &quot;milk&quot;];

float calculate_fuel_efficiency( item it, int target_units )
{
    int units = it._average_adventures();
    return it.historical_price() / min( target_units, units );
}

boolean is_fuel_item( item it )
{
    return (
        !it.is_npc_item() &&
        it.fullness + it.inebriety > 0 &&
        it._average_adventures() > 0 &&
        it.tradeable && it.discardable &&
        !(fuel_blacklist contains it) &&
        it.historical_price() != 0
    );
}

item get_best_fuel( int target_units )
{
    item [int] potential_fuel;

    foreach it in $items[] if ( it.is_fuel_item() )
    {
        potential_fuel[count(potential_fuel)] = it;
    }

    sort potential_fuel by -value._average_adventures();
    sort potential_fuel by value.calculate_fuel_efficiency( target_units );

    return potential_fuel[ 0 ];
}

boolean insert_fuel( item it, int quantity )
{
    string result = visit_url( `campground.php?action=fuelconvertor&pwd&qty={quantity}&iid={it.to_int()}&go=Convert%21` );
    return result.contains_text( "The display updates with a" );
}

boolean insert_fuel( item it )
{
    return insert_fuel( it, 1 );
}

void fill_asdon_martin_to( int target_units )
{
    while ( get_fuel() < target_units )
    {
        int remaining = target_units - get_fuel();

        item fuel = get_best_fuel( remaining );
        
        fuel.retrieve_item();

        if ( !fuel.insert_fuel() )
        {
            abort( "Fuelling failed" );
        }
    }
}

void main()
{
    fill_asdon_martin_to( 30 );
}
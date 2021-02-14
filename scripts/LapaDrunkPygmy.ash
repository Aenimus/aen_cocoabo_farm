script <LapaDrunkPygmy.ash>;


record DrunkPygmyRec
{
    string ignore;
};


int free_fights( DrunkPygmyRec self )
{ 
	return get_int( "_drunkPygmyBanishes" );
}


boolean location_prepared( DrunkPygmyRec self )
{
    return get_boolean( "_lapaDrunkPygmyLocationPrepared" );
}


boolean can_free_fight( DrunkPygmyRec self, int target)
{
    int extra = 0;
    if ( $item[miniature crystal ball].worn() || $item[miniature crystal ball].fetch() )
    {
        extra = 1;
    }
    int threshold = ( saber.worn() || saber.fetch() )? 10 : 11;
    threshold = threshold + extra;
	int free_fights = self.free_fights();
    if ( free_fights > threshold ) return false;
	if ( free_fights >= target ) return false;
	print( "We have not yet met our initial free fight threshold." , "purple");
    int remaining_fights = target - free_fights;
    if ( self.location_prepared() ) juggle_scorpions( remaining_fights );
	return true;
}


boolean can_free_fight( DrunkPygmyRec self )
{
    int threshold = ( $item[miniature crystal ball].worn() || $item[miniature crystal ball].fetch() ) ? 11 : 10;
    return self.can_free_fight( threshold );
}


void run_free_fight( DrunkPygmyRec self )
{
	if ( !bworps.fetch() ) buy_until( 1, bworps, 500 );
    int free_fights = self.free_fights();
    if ( self.free_fights() == 10 ) $item[miniature crystal ball].try_equip();
	print( `"Using a Bowl of Scorpions for free fight #{free_fights + 1} against a drunk pygmy."`, "purple" );
	if ( kramco.try_equip() ) print( "Wearing the Kramco grinder in a goblin-friendly location.", "purple" );
	comma_fights_increment();
	adv1( $location[The Hidden Bowling Alley], -1, "" );
}


void check_location_prepared( DrunkPygmyRec self )
{
    foreach mob in $strings[pygmy bowler, pygmy orderlies]
    {
        if ( !get_string( "banishedMonsters" ).contains_text( mob ) ) return;
    }
    //if ( get_int( "relocatePygmyJanitor" ) > 0 )
    set_property( "_lapaDrunkPygmyLocationPrepared", true );
	if ( !juggle_scorpions( 10 ) ) buy_until( 10, bworps, 500 );
}


void prepare_location( DrunkPygmyRec self )
{
	print( "Banishing non-drunk pygmies in the Hidden Bowling Alley.", "purple" );
	juggle_scorpions( 0 );
	if ( kramco.try_equip() ) print( "Wearing the Kramco grinder in a goblin-friendly location.", "purple" );
	adv1( $location[The Hidden Bowling Alley], -1, "" );
	self.check_location_prepared();
}


boolean force_friends_threshold( DrunkPygmyRec self )
{
    int extra = 0;
    if ( $item[miniature crystal ball].worn() || $item[miniature crystal ball].fetch() )
    {
        extra = 1;
    }
    if ( !saber.worn() && !saber.fetch() ) return false;
    int current_forces = CosplaySaber.get_forces() - CosplaySaber.get_previous_forces_today();
    int threshold = (11 + extra) + ( current_forces * 2 ); // 2 * number of forces at the start of day, 10 initial fights + 1 for the last force
    return self.free_fights() < threshold;
}


boolean can_forced_friends_free_fight( DrunkPygmyRec self )
{
    return self.force_friends_threshold();
}


void run_forced_friends_free_fight( DrunkPygmyRec self )
{
	int free_fights = self.free_fights();
	int forces = CosplaySaber.get_forces();
	if ( CosplaySaber.should_copy_drunk_pygmy( free_fights, forces ) )
    {
        CosplaySaber.copy_drunk_pygmy( forces );
        return;
    }
	print( "We are fighting a forced friend drunk pygmy.", "purple" );
	if ( !bworps.have() && !bworps.fetch() ) buy_until( 1, bworps, 500 );
	adv1( $location[The Hidden Bowling Alley], -1, "" );
	if ( free_fights < self.free_fights() ) return;
    abort( "ERROR: Something went wrong with run_forced_friends_free_fight() in LapaDrunkPygmy.ash." );
}


DrunkPygmyRec DrunkPygmy = new DrunkPygmyRec();
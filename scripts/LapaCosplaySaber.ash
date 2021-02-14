script <LapCosplaySaber.ash>;


record CosplaySaberRec
{
    string ignore;
};


boolean have( CosplaySaberRec self )
{
	return saber.fetch(); // define an own function
}


int get_forces( CosplaySaberRec self )
{
	return get_int( "_saberForceUses" );
}


boolean could_force( CosplaySaberRec self )
{
	return self.get_forces() < 5;
}


void set_previous_forces_today( CosplaySaberRec self )
{
	set_property( "_lapaCosplaySaberPreviousForcesToday", self.get_forces() );
}


int get_previous_forces_today( CosplaySaberRec self )
{
	return get_int( "_lapaCosplaySaberPreviousForcesToday" );
}


boolean is_upgraded( CosplaySaberRec self )
{
    return get_boolean( "_saberMod" );
}


boolean can_upgrade( CosplaySaberRec self )
{
	return self.have() && !self.is_upgraded();
}


boolean upgrade( CosplaySaberRec self, int upgrade )
{
	if ( !self.can_upgrade() ) return false;
	visit_url( "main.php?action=may4" );
	run_choice( upgrade );
	return get_int( "_saberMod" ) == upgrade;
}


boolean upgrade( CosplaySaberRec self )
{   // + Familiar weight
	return self.upgrade( 4 );
}


string get_wanderer( CosplaySaberRec self )
{
	return get_string( "_saberForceMonster" );
}


int get_wanderer_count( CosplaySaberRec self )
{
	return get_int( "_saberForceMonsterCount" );
}


boolean should_copy_drunk_pygmy( CosplaySaberRec self, int free_fights, int forces )
{
	if ( !self.could_force() ) return false;
	int threshold = 10;
    if ( $item[miniature crystal ball].worn() || $item[miniature crystal ball].fetch() )
    {
        threshold = 11;
    }
    if ( free_fights < threshold ) return false;
	boolean first_force = false;
	int friend_count = self.get_wanderer_count();
	if ( self.get_wanderer() != "drunk pygmy" )
	{
		if (  friend_count > 0 ) abort( "ERROR (should_force_friends_drunk_pygmy(), LapaCosplaySaber.ash): You have remaining forced friends for another monster." );
		first_force = true;
	}
	else first_force = ( free_fights == threshold && friend_count != 3 );
	return ( self.get_wanderer_count() == 1 || first_force );
}


void copy_drunk_pygmy( CosplaySaberRec self, int forces )
{
	if ( !saber.try_equip() ) abort( "ERROR (force_friends_drunk_pygmy(), LapaCosplaySaber.ash): Something went wrong with equipping the cosplay saber." );
	juggle_scorpions( 0 );
	print( "We are preparing to use force friends on a drunk pygmy.", "purple" );
	set_property( "_lapaCosplaySaberCopyTarget", 1431 ); // For combat script @TODO String for monstername
	adv1( $location[The Hidden Bowling Alley], -1, "" ); // Use the force
    if ( forces == 5 ) juggle_scorpions( 3 ); // If it's the last force, we receive 3 copies
    else juggle_scorpions( 2 ); // Otherwise we fight two and saber the third.
	if ( !bworps.have() ) buy_until( 1, bworps, 500 );
	if ( forces < self.get_forces() ) return; // Might trip on a sausage goblin?
	abort( "ERROR (copy_drunk_pygmy(), LapaCosplaySaber.ash): Something went wrong with force friending the drunk pygmy." );
}


int get_copy_target( CosplaySaberRec self )
{
	return get_int( "_lapaCosplaySaberCopyTarget" );
}


void use_copier( CosplaySaberRec self, monster mob )
{
	if ( !saber.worn() ) return;
	if ( self.get_copy_target() == mob.id )
	{
		int forces = self.get_forces();
		$skill[7311].use();
		run_choice( 2 );
		if ( forces == self.get_forces() ) abort( "ERROR: Something went wrong with use_force_friends(), LapaCosplaySaber.ash." );
		set_property( "_lapaCosplaySaberCopyTarget", 0 );
	}
}


CosplaySaberRec CosplaySaber = new CosplaySaberRec();
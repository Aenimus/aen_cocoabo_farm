script <LapaCopier.ash>;

boolean boolean_eval( string modifier )
{
    return modifier_eval( modifer ).to_boolean();
}


record Copier
{
    string copier_type;
    string copier;
    string copy_type;
    string copy;
    string could_condition;
    string exhausted;
    int max_uses;
    string prepare;
    string current_monster;
    string use_condition;
    string copier_target;
    string use_copy;
};


Copier AlpineWatercolorSet = new Copier(
    "combat item", // copier_type
    "alpine watercolor set", // copier
    "place", // copy_type
    "use_chateau", // copy
    "pref(chateauAvailable)", // could_condition
    "pref(_chateauMonsterFought)", // exhausted
    1, // max_uses
    "prepare", // prepare
    "chateauMonster", // current_monster
    "1", // use_condition
    
);
Copier DeluxeFaxMachine = new Copier(
    "item", // copier_type
    "Clan VIP key", // copier
    "item", // copy_type
    "photocopied monster", // copy
    "call could_fax", // could_condition
    "pref(_photocopyUsed)", // exhausted
    1, // max_uses
    "prepare",
    "photocopyMonster",
    "1", // use_condition
);
Copier Digitize = new Copier(
    "combat skill", // copier_type
    "Digitize", // copier
    "counter", // copy_type
    "", // copy
    "call could_digitize", // could_condition
    "pref(_sourceTerminalDigitizeMonsterCount)", // exhausted
    3, // max_uses
    "prepare",
    "_sourceTerminalDigitizeMonster",
    "1"
);
Copier FourDCamera = new Copier(
    "combat item", // copier_type
    "4-d camera", // copier
    "item", // copy_type
    "shaking 4-d camera", // copy
    "item", // could_condition
    "pref(_cameraUsed)",
    1, // max_uses
    "prepare",
    "cameraMonster",
    "1"
);
Copier LovEnamorang = new Copier(
    "combat item", // copier_type
    "LOV Enamorang", // copier
    "counter", // copy_type
    "", // copy
    "call could_enamorang", // could_condition
    "pref(_enamorangs)", // exhausted
    3, // max_uses
    "prepare",
    "enamorangMonster",
    "1"
);
Copier PortablePhotocopier = new Copier(
    "combat item", // copier_type
    "portable photocopier", // copier
    "item", // copy_type
    "photocopied monster", // copy
    "call could_photocopy", // could_condition
    "pref(_photocopyUsed)", // exhausted
    1, // max_uses
    "prepare", // prepare
    "photocopyMonster",
    "1"
);
Copier PrintScreenButton = new Copier(
    "combat item," // copier_type
    "print screen button", // copier
    "item", // copy_type
    "screencapped monster", // copy
    "item", // could_condition
    "0", // exhausted
    -1, // max_uses
    "prepare",
    "screencappedMonster",
    "1"
);
Copier PulledGreenTaffy = new Copier(
    "combat item", // copier_type
    "pulled green taffy", // copier
    "item", // copy_type
    "envyfish egg", // copy
    "call could_taffy", // could_condition
    "pref(_envyfishEggUsed)", // exhausted
    1, // max_uses
    "prepare",
    "envyfishMonster",
    "env(underwater)"
);
Copier RainDohBlackBox = new Copier(
    "combat item", // copier_type
    "Rain-Doh black box", // copier
    "item", // copy_type
    "Rain-Doh box full of monster", // copy
    "iotm", // could_condition
    "call putty_exhausted", // exhausted
    5, // max_uses
    "prepare",
    "rainDohMonster",
    "1"
);
Copier Romantic = new Copier(
    "combat skill", // copier_type
    "Romantic Arrow", // copier
    "counter", // copy_type
    "", // copy
    "call could_romantic", // could_condition
    "_badlyRomanticArrows", // exhausted
    1, // max_uses
    "prepare",
    "romanticTarget"
    "special cond"
);
Copier SpookyPuttySheet = new Copier(
    "combat item", // copier_type
    "Spooky Putty sheet", // copier
    "item", // copy_type
    "Spooky Putty monster", // copy
    "iotm", // could_condition
    "call putty_exhausted", // exhausted
    5, // max_uses
    "prepare",
    "spookyPuttyMonster",
    "1"
);
Copier UnfinishedIceSculpture = new Copier(
    "combat item", // copier_type
    "unfinished ice sculpture", // copier
    "item", // copy_type
    "ice sculpture", // copy
    "item", // could_condition
    "pref(_iceSculptureUsed)", // exhausted
    1, // max_uses
    "prepare",
    "iceSculptureMonster",
    "1"
);

Copier [int] combat_copiers = {
    AlpineWaterColorSet,
    FourDCamera,
    LovEnamorang,
    PortablePhotocopier,
    PrintScreenButton,
    PulledGreenTaffy,
    RainDohBlackBox,
    SpookyPuttySheet,
    UnfinishedIceSculpture,
};


boolean chateau_exhausted( Copier self )
{
    return get_boolean( "_chateauMonsterFought" );
}


boolean putty_exhausted( Copier self )
{
    int putty_copies = get_int( "spookyPuttyCopiesMade" );
    int doh_copies = get_int( "_raindohCopiesMade" );
    int primary = putty_copies;
    int secondary = raindoh_copies;

    if ( self.copier == "Rain-Doh black box" )
    {
        int primary = raindoh_copies;
        int secondary = putty_copies;
    }

    return ( primary > 4 || ( primary + secondary ) > 5 );
}


boolean exhausted( Copier self )
{
    string exhausted_string = self.exhausted;
    int max_uses = self.max_uses;
    if ( exhausted_string.starts_with( "$" ) ) 
    {
        exhausted_string = exhausted_string.substring( 1 );
        return call boolean self.exhausted_string();
    }
    if ( max_uses > 1 ) return modifier_eval( exhausted_string ) >= max_uses;
    return boolean_eval( exhausted_string );
}


item get_copier_item( Copier self )
{
    return self.copier.to_item();
}


boolean have_copier_item( Copier self )
{
    return self.get_copier_item().have();
}


skill get_copier_skill( Copier self )
{
    return self.copier.to_skill();
}


boolean have_copier_skill( Copier self )
{
    return self.get_copier_skill().have();
}


boolean is_combat_copier( Copier self )
{
    return self.copier_type.contains_text( "combat" );
}


boolean have_combat_copier( Copier self )
{
    return self.have_copier_item() || self.have_copier_skill();
}


item get_copy_item( Copier self )
{
    return copy.to_item();
}


boolean have_copy_item( Copier self )
{
    return self.get_copy_item().have();
}


boolean could_digitize()
{
    return (
        ( get_campground() contains $item[Source Terminal] ) &&
        ( get_string( "sourceTerminalEducateKnown" ).contains_text( "digitize.edu" ) ) &&
        ( !self.exhausted() )
    );
}


boolean could_enamorang()
{
    // counter check
}


boolean could_fax()
{
    // check key and fax
}

boolean could_photocopy()
{
    return !$item[Clan VIP Lounge key].available();
}


boolean could_romantic()
{
    // familiar checks
}

boolean could_taffy()
{
    // sea and fishy check
}

boolean is_pref( string str )
{
    return str.starts_with( "pref" );
}

boolean is_call( string str )
{
    return str.starts_with( "call" );
}


boolean in( string query, string str )
{
    return str.contains_text( query );
}


boolean could_use_copier( Copier self )
{
    if ( self.exhausted() || self.have_copy_item() ) return false;
    string condition = self.could_condition;
    switch ( condition )
    {
        case "item":    return true;
        case "iotm":    return self.copier.available();
    }
    if ( condition.is_pref() ) return boolean_eval( condition );
    if ( condition.is_call() )
    {
        condition = condition.substring(5);
        return call boolean condition();
    }
    return false;
}


boolean should_copy()
{
    // check worth
    // check counters
}


void prepare( Copier self )
{
    if ( self.copier_type == "combat item" )
    {
        item copier =  self.get_copier_item();
        if ( !copier.fetch() && self.could_copy == "" ) buy_until( 1, copier, 30000 );
    }
    else
    {
        string prepare_string = self.prepare;
        call void self.prepare_string();
    }
}


monster get_current_monster( Copier self )
{
    return self.current_monster.to_monster();
}


boolean can_use_copier( Copier self, monster mob )
{
    if ( self.exhausted() || !boolean_eval( self.use_condition ) ) return false;
    if ( self.have_combat_copier() )
    {
        if ( mob.to_string() != self.monster_target ) return false;
        if ( self.copier_type == "combat item" ) return self.current_monster != get_string( self.monster_target );
        return true; // skills return true here? if all handled in the use condition
        // should_copy?
    }
    // other types
    return;
}


boolean can_use_copier( Copier self )
{
    if ( !self.have_copier() ) return false;
    // other types
    return;
}


boolean can_use_copy( Copier self )
{
    if ( self.have_copy_item() && !self.exhausted() ) return get_string( self.current_monster ) == self.copier_target; //@TODO
    string can_use = self.can_use;
    return call boolean 
}


void use_chateau( Copier self )
{
    if ( self.current_monster == "Black Crayon Crimbo Elf" ) $familiar[Robortender].try_equip();
	visit_url( "place.php?whichplace=chateau&action=chateau_painting" );
	run_combat();
}


void use_copy( Copier self )
{
    if ( self.copy_type == "item" )
    {
        self.get_copy_item().use();
        return;
    }
    string use_copy_string = self.use_copy;
    call void self.use_copy_string();
}

void use_combat_copiers(int rnd, monster mob, int hp_threshold)
{
	item [int] funkslings;
	foreach index, copier in combat_copiers if copier.can_use_copier( mob )
    {
        if ( monster_hp() < hp_threshold ) return;
        funkslings[funkslings.count()] = copier;
        if ( $skill[Ambidextrous Funkslinging].have() )
        {
            if ( funks.count() == 2 )
            {
                print( `"Throwing a {funkslings[0].to_string()} and a {funkslings[1].to_string()} at a {mob.to_string()}."`, "purple");
                throw_items( funkslings[0], funkslings[1] );
                funks.clear();
                rnd++;
            }
        }
        else // Without funkslinging
        {
			print( `"Throwing a {funkslings[0].to_string()} at a {mob.to_string()}."`, "purple");
			throw_item( funkslings[0] );
			rnd++;
        }
    }
	if ( funkslings.count() == 1 ) // One item left with funkslinging
    {
		print( `"Throwing a {funkslings[0].to_string()} at a {mob.to_string()}."`, "purple");
		throw_item( funkslings[0] );
		rnd++;
	}
}
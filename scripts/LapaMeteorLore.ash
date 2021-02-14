script <LapaMeteorLore.ash>;

record MeteorLoreRec
{
    string ignore;
};

boolean have( MeteorLoreRec self )
{
    return $skill[Meteor Lore].have();
}

int get_macros( MeteorLoreRec self )
{
    return get_int( "_macrometeoriteUses" );
}

boolean have_macro( MeteorLoreRec self )
{ // True only if uses remain
    return $skill[Macrometeorite].have();
}

int get_showers( MeteorLoreRec self )
{
    return get_int( "_meteorShowerUses" );
}

boolean have_shower( MeteorLoreRec self )
{ // True only if uses remain
    return $skill[Meteor Shower].have();
}

MeteorLoreRec MeteorLore = new MeteorLoreRec();
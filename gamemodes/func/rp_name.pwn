Hook_IsRPName(const name[]) {
    new underscores = 0, max_underscores = 1;
    if (name[0] < 'A' || name[0] > 'Z') return false;
    if ( strlen ( name ) < 5 ) return false ;
    if ( strlen ( name ) > MAX_PLAYER_NAME ) return false ;

    for(new i = 1; i < strlen(name); i++) {

        if(name[i] != '_' && (name[i] < 'A' || name[i] > 'Z') && (name[i] < 'a' || name[i] > 'z')) return false;
        if( (name[i] >= 'A' && name[i] <= 'Z') && (name[i - 1] != '_') ) return false;

        if(name[i] == '_') {
            underscores++;
            if(underscores > max_underscores || i == strlen(name)) return false;
            if(name[i + 1] < 'A' || name[i + 1] > 'Z') return false;
        }
    }

    if (underscores == 0) return false;

    return true;
}
#if defined _ALS_IsRPName
	#undef IsRPName
#else
	#define _ALS_IsRPName
#endif
#define IsRPName Hook_IsRPName

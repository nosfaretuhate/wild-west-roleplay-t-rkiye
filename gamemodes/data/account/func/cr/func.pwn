NameSelection ( playerid, error = 0 ) {

 	task_yield ( 1 ) ;

	new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
	
	switch ( error ) {
		case 0: await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_INPUT, "Character: Name Selection", "Enter your character's name.", "Continue", "Cancel" );
		case 1: await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_INPUT, "{DEDEDE}Character: Name Selection", "{DEDEDE}Enter your character's name.\n{C23838}ERROR:{DEDEDE} This name already exists.", "Continue", "Cancel" );
		case 2: await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_INPUT, "{DEDEDE}Character: Name Selection", "{DEDEDE}Enter your character's name.\n{C23838}ERROR:{DEDEDE} This name is not a roleplaying name.\n\nExample: \"Firstname_Lastname\".", "Continue", "Cancel" );
	}
	
	//printf("%s", inputtext ) ;

	if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {
		return NameSelection ( playerid, 2 ) ;
	}

	if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

		if ( ! IsRPName ( dialog_response [ E_DIALOG_RESPONSE_InputText ] ) ) {

			return NameSelection ( playerid, 2 ) ;
		}

		new query [ 128 ] ;

		mysql_format(mysql, query, sizeof ( query ), "SELECT * FROM characters WHERE character_name = '%e' LIMIT 1", dialog_response [ E_DIALOG_RESPONSE_InputText ] ) ;
		mysql_tquery ( mysql, query, "CheckPlayerName", "is", playerid, dialog_response [ E_DIALOG_RESPONSE_InputText ] ) ;

	}

	return true ;
}

forward CheckPlayerName ( playerid, string: name [] ) ;
public CheckPlayerName ( playerid, string: name [] ) {

	new rows ;
    cache_get_row_count(rows);

    if ( rows ) {
		
    	return NameSelection ( playerid, 1 ) ;
    }

    else if ( ! rows ) {

		CreateCharacter ( playerid, Account [ playerid ] [ account_id ], name, 
		//CreateCharacter ( playerid, 0, name, 

			player_GenderSelection [ playerid ], 
			player_RaceSelection [ playerid ], 
			player_TownSelection [ playerid ], 
			player_SkinSelection [ playerid ], 
			player_AgeSelection [ playerid ]
		) ;

    }

    return true ;
}
/*
CreateCharacter ( playerid, account_id, name [], gender, race, town, skin, age ) {

	if ( ! IsPlayerCreatingCharacter [ playerid ] ) {

		return SendClientMessage(playerid, -1, "Something went wrong. Please relog and /report for assistance (invalid CreateCharacter variable)." ) ;
	}

	IsPlayerCreatingCharacter [ playerid ] = false ;
	HideCreationTextDraws ( playerid ) ;

	if ( ! player_SkinSelection [ playerid ] ) {

		SendClientMessage(playerid, -1, "Something went wrong. Your skin hasn't been found, so we have manually set it for you based on your selections." ) ;
		UpdateCreationSkin ( playerid ) ;
	}

	return true ;
}


IsRPName(const name[]) {
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
*/
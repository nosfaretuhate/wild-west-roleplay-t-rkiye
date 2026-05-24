enum adminRecordData {

	record_id,
	account_id,

	record_type,
	record_reason [ 64 ],
	record_time,
	record_admin,
	record_date [ 36 ]

} ;

#define MAX_ARECORD_CHARGES	( 100 )	
new AdminRecord [ MAX_PLAYERS ] [ MAX_ARECORD_CHARGES ] [ adminRecordData ] ;

SetAdminRecord ( accountid, adminid, type, reason[], time, date[] ) {

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO admin_record (account_id, record_type, record_reason, record_time, record_admin, record_date) VALUES (%d, %d, '%e', %d, %d, '%e')", accountid, type, reason, time, adminid, date ) ;
	mysql_tquery ( mysql, query ) ;

	return true ;
}

new PlayerLastARecPage [ MAX_PLAYERS ] ;
CMD:adminrecord(playerid ) {

	SendServerMessage ( playerid, "Loading admin record, one moment...", MSG_TYPE_WARN ); 

	Init_AdminRecord ( playerid ) ;

	return true ;
}

forward AdminRecordDelay(playerid);
public AdminRecordDelay(playerid) {

	PlayerLastARecPage [ playerid ] = 1 ;
	return ShowAdminRecord ( playerid ) ;
}

GetPlayerPenaltyCount (playerid) {

	new count ;

	for ( new i ; i < MAX_ARECORD_CHARGES; i ++ ) {

		if ( AdminRecord [ playerid ] [ i ] [ record_id ] != -1 && AdminRecord [ playerid ] [ i ] [ account_id ] == Account [ playerid ] [ account_id ] ) {

			count ++ ;
		}

		else continue ;
	}

	return count ;
}

ShowAdminRecord ( playerid ) {

	new MAX_ITEMS_ON_PAGE = 20, string [ 512 ], bool: nextpage, reason [ 64 ], temp [ 32 ] ;

    new pages = floatround ( GetPlayerPenaltyCount(playerid) / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1, 
    	resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ playerid ] ) - MAX_ITEMS_ON_PAGE ) ;

    strcat(string, "Record ID \t Record Type\t Record Date\t Record Reason\n");

    for ( new i = resultcount; i < GetPlayerPenaltyCount(playerid); i ++ ) {

    	if ( AdminRecord [ playerid ] [ i ] [ account_id ] == Account [ playerid ] [ account_id ] ) {
	        resultcount ++;

	        if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ playerid ] ) {

	        	switch ( AdminRecord [ playerid ] [ i ] [ record_type ] ) {

	        		case ARECORD_TYPE_KICK : 	strcopy ( reason, "Kick" ) ;
					case ARECORD_TYPE_AJAIL : 	strcopy ( reason, "Admin-jail" ) ;
					case ARECORD_TYPE_BAN : 	strcopy ( reason, "Account Ban" ) ;
	        	}


	        	format ( temp, sizeof ( temp ), "[Reason: %s]", AdminRecord [ playerid ] [ i ] [ record_reason ] ) ;

	        	if ( strlen ( AdminRecord [ playerid ] [ i ] [ record_reason ] ) > 12  ) {

	        		format ( temp, sizeof ( temp ), "[Reason: %.12s...]", AdminRecord [ playerid ] [ i ] [ record_reason ] ) ;
	        	}

	           	format ( string, sizeof ( string ), "%s[ID %d]\t[Type: %s]\t[Date: %s]\t%s\n", string, AdminRecord [ playerid ] [ i ] [ record_id ], reason, AdminRecord [ playerid ] [ i ] [ record_date ], temp ) ;
	
	        }

	        if ( resultcount > MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ playerid ] ) {

	            nextpage = true ;
	            break ;
	        }
	    }

	    else continue ;
    }

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }

	task_yield ( 1 ) ;

	new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
	await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Admin Record: Page %d of %d", playerLastCOCPage [ playerid ], pages), string, "View", "Close" );

	if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) return true ;

	if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		if ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] == MAX_ITEMS_ON_PAGE) {

			PlayerLastARecPage [ playerid ] ++ ;
			return cmd_adminrecord(playerid);
		}

		else if ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] < MAX_ITEMS_ON_PAGE ) {

			new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ playerid ] ) - MAX_ITEMS_ON_PAGE ) + dialog_response [ E_DIALOG_RESPONSE_Listitem ];

			PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

			SendClientMessage(playerid, ADMIN_BLUE, "[ADMIN RECORD PARSE DATA]");

			format ( string, sizeof ( string ), "[ID %d]\t[Type: %s]\t[Date: %s]\t[Admin ID: %d]\n", 
				AdminRecord [ playerid ] [ selection ] [ record_id ], reason, AdminRecord [ playerid ] [ selection ] [ record_date ], AdminRecord [ playerid ] [ selection ] [ record_admin ] ) ;

			SendClientMessage(playerid, ADMIN_BLUE, string ) ;

			format ( string, sizeof ( string ), "[Reason: %s]\n", AdminRecord [ playerid ] [ selection ] [ record_reason ]  ) ;

			SendClientMessage(playerid, ADMIN_BLUE, string ) ;
		}
	}

   	return true ;
}


Init_AdminRecord ( playerid ) {

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM admin_record WHERE account_id = %d", Account [ playerid ] [ account_id ] );
	mysql_tquery ( mysql, query, "LoadAdminRecord", "i", playerid ) ;

	return true ;
}

forward LoadAdminRecord ( playerid ) ;
public LoadAdminRecord ( playerid ) {
	new rows ;

	cache_get_row_count ( rows ) ;

	if ( ! rows ) {

		return SendServerMessage ( playerid, "You don't have any records to your account.", MSG_TYPE_INFO ) ;
	}

    else if ( rows ) {

		for ( new i; i < rows; i ++ ) {

			cache_get_value_int ( i, "record_id",		AdminRecord [ playerid ] [ i ] [ record_id ] ) ;
			cache_get_value_int ( i, "account_id",		AdminRecord [ playerid ] [ i ] [ account_id ] ) ;

			cache_get_value_int ( i, "record_type",		AdminRecord [ playerid ] [ i ] [ record_type ] ) ;

			cache_get_value_name ( i, "record_reason", 	AdminRecord [ playerid ] [ i ][ record_reason ], 64 ) ;

			cache_get_value_int ( i, "record_time",		AdminRecord [ playerid ] [ i ] [ record_time ] ) ;
			cache_get_value_int ( i, "record_admin",	AdminRecord [ playerid ] [ i ] [ record_admin ] ) ;

			cache_get_value_name ( i, "record_date", 	AdminRecord [ playerid ] [ i ] [ record_date ], 	36 ) ;
		}

		SetTimerEx("AdminRecordDelay", 1000, false, "i", playerid);
    }

    return true ;
}
#if defined _inc_rev
	#undef _inc_rev
#endif


enum {

	REVISION_TYPE_ADDITION,
	REVISION_TYPE_REMOVAL,
	REVISION_TYPE_CHANGE,
	REVISION_TYPE_HOTFIX,

} ;

enum RevisionData {

	revision_desc [ 256 ],
	revision_type,
	revision_date // use unix
} ;

new RevisionList [ ] [ RevisionData ] = {

	{ "Çiftçilik sistemi: Gerekli malzemeleri genel marketten ve demirciden satýn alabilirsiniz.", 					REVISION_TYPE_ADDITION, 1548331200 },
	{ "Tuzak sistemi: Demirciden bir tuzak alýp hayvanlarý (ve insanlarý) yakalamak için kullanabilirsiniz.", 		REVISION_TYPE_ADDITION, 1548331202 },
	{ "Bayside deðiþtirildi! Artýk karlý bir dað!", 												REVISION_TYPE_CHANGE, 	1548862920 },
	{ "Las Barrancas ve El Quebrados (EQ) tamamen yenilendi.", 											REVISION_TYPE_CHANGE, 	1548862922 },
	{ "/levelup komutu düzeltildi (artýk büyük harf kullanýmý gerekmiyor).", 									REVISION_TYPE_HOTFIX, 	1549022400 },
	{ "Meslek arayüzü (GUI) düzeltildi ve textdraw altyapýsý yenilendi.", 									REVISION_TYPE_HOTFIX, 	1549022402 },
	{ "Bir oyuncunun baðlantýsý koptuðunda çýkan yakýnlýk mesajý düzeltildi (yakýndaki oyuncular artýk uyarýlýyor).", 	REVISION_TYPE_HOTFIX, 	1549023300 },
	{ "M-RP'nin güncellenmiþ envanter modülü entegre edildi. Artýk envanter genel olarak daha akýcý çalýþýyor.", 		REVISION_TYPE_CHANGE, 	1549110600 }
} ;

CMD:updates ( playerid ) {

	new update_list [ sizeof ( RevisionList ) ], string [ 1024 ], revision_index, latest_update_unix ;

	for ( new i; i < sizeof ( RevisionList ) ; i ++ ) {

		if ( RevisionList [ i ] [ revision_date ] > latest_update_unix ) {

			latest_update_unix = RevisionList [ i ] [ revision_date ] ;
		}

		else continue ;
	}

	format ( string, sizeof ( string ), "{DEDEDE}Son güncellemelr (# %d) %s.\n", 
		sizeof ( RevisionList), GetDateForUnix ( latest_update_unix ) ) ;

	for ( new i; i < sizeof ( RevisionList ); i ++ ) {

		update_list [ i ] = RevisionList [ i ] [ revision_date ]  ;
	}

	for ( new i = ( sizeof ( RevisionList ) - 1 ), j, temp; i != 0; i --) {

		for ( j = 0; j < i; j ++ ) {

			if ( update_list [ i ] < update_list [ j ] ) {

				temp = update_list [ i ] ;

				update_list [ i ] = update_list [ j ] ;
				update_list [ j ] = temp;
			}
		}
	}

	for ( new i = sizeof ( update_list ) - 5; i < sizeof ( update_list ); i ++ ) {

		revision_index = GetRevisionIndexByUnix ( update_list [ i ] ) ;

		if ( revision_index == -1 ) {

			continue ;
		}

		format ( string, sizeof ( string ), "%s\n \t %s (%s) \n \t    {FFFFFF}%s{DEDEDE}\n", string,
			GetRevisionType ( update_list [ i ], revision_index ), GetDuration ( gettime() - update_list [ i ] ),
			RevisionList [ revision_index ] [ revision_desc ]
			
		) ;
	}

	ShowPlayerDialog(playerid, 1337, DIALOG_STYLE_MSGBOX, "Güncellemeler", string, "Tamam", "Tamam");

	return true ;
}

GetRevisionIndexByUnix ( unix ) {

	for ( new i; i < sizeof ( RevisionList ); i ++ ) {

		if ( RevisionList [ i ] [ revision_date ] == unix ) {

			return i ;
		}

		else continue ;
	}

	return -1 ;
}

GetRevisionType ( unix, revision_id ) {

	new string [ 32 ] ;

	switch ( RevisionList [ revision_id ] [ revision_type ] ) {

		case REVISION_TYPE_ADDITION: {

			strins ( string, "eklendi{DEDEDE} \t", 0, sizeof ( string ) ) ;
		}

		case REVISION_TYPE_REMOVAL: {

			strins ( string, "kaldýrýldý{DEDEDE}", 0, sizeof ( string ) ) ;
		}

		case REVISION_TYPE_CHANGE: { 

			strins ( string, "deðiþtirildi{DEDEDE}", 0, sizeof ( string ) ) ;
		}

		case REVISION_TYPE_HOTFIX: {

			strins ( string, "düzeltildi{DEDEDE}", 0, sizeof ( string ) ) ;
		}

		default: {

			strins ( string, "güncellendi{DEDEDE}", 0, sizeof ( string ) ) ;
		}
	}

	if ( gettime() - 3600 < unix ) {

		strins ( string, "{87c482}", 0, sizeof ( string ) ) ;
	}

	else {

		strins ( string, "{777777}", 0, sizeof ( string ) ) ;
	}

	return string ;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////


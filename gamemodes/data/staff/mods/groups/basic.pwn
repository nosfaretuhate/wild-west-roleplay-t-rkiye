CMD:clearbuggeditems(playerid,params[]) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}
	new targetid;
	if(sscanf(params,"k<u>",targetid)) { return SendServerMessage(playerid,"/clearbuggeditems [oyuncuID]",MSG_TYPE_ERROR); }
	if(!IsPlayerConnected(targetid)) { return SendServerMessage(playerid,"Bu oyuncu çevrimiçi deðil.",MSG_TYPE_ERROR); }
	ClearBuggedItems(targetid);
	SendServerMessage(playerid,sprintf("(%d) %s'nin hatalý eþyalarý temizlenmelidir.",targetid,ReturnUserName(targetid,true)),MSG_TYPE_INFO);
	SendServerMessage(targetid,sprintf("(%d) %s envanterinizi hatalý eþyalardan temizledi.",playerid,ReturnUserName(playerid,true)),MSG_TYPE_INFO);
	return true;
}

CMD:clearshells ( playerid, params [] ) {
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	ClearGunShells () ;

	SendModeratorWarning ( sprintf("[SILAH_KABUKLARI] %s (%d) silah kabuklarýný temizledi.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_MED ) ;

	return true ;
}

CMD:geoip ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new targetid;

	if ( sscanf ( params, "k<u>", targetid ) ) {

		return SendServerMessage ( playerid, "/geoip [hedef]", MSG_TYPE_ERROR ) ;
	}

	if ( targetid == INVALID_PLAYER_ID ) {

		return SendServerMessage ( playerid, "Bu oyuncunun baðlý olmasý gerekmez.", MSG_TYPE_ERROR ) ;
	}

	new country [ 32 ], region [ 32 ], city [ 32 ], isp [ 32 ], timez [ 32 ], zipcode [ 32 ] ;

	GetPlayerCountry(targetid, country ) ;
	GetPlayerRegion(targetid, region ) ;
	GetPlayerCity(targetid, city ) ;
	GetPlayerISP(targetid, isp ) ;
	GetPlayerZipcode(targetid, zipcode ) ;
	GetPlayerTimezone(targetid, timez ) ; 

	SendClientMessage(playerid, COLOR_YELLOW, sprintf("(%d) %s'nin KONUM VERÝSÝ (IP: %s) [ZAMAN DÝLÝMÝ: %s]", targetid, ReturnUserName ( targetid, true ), ReturnIP ( targetid ), timez ) ) ;
	SendClientMessage(playerid, COLOR_YELLOW, sprintf("Ulke: %s - Bolge: %s - Sehir: %s - ISP: %s - Posta Kodu: %s", country, region, city, isp, zipcode ) ) ;

	SendModeratorWarning ( sprintf("[KONUM] %s (%d) - %s (%d)'nin konum verilerini kontrol etti.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_MED ) ;

	return true ;
}

CMD:togmodwarnings ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( IsPlayerOnAdminDuty [ playerid ] ) {

		return SendServerMessage ( playerid, "Mod görevdeysken moderatör uyarýlarýný devre dýþý býrakamazsýnýz.", MSG_TYPE_WARN ) ;
	}

	if ( ! PlayerModWarnings [ playerid ] ) {

		PlayerModWarnings [ playerid ] = true ;

		return SendServerMessage ( playerid, "Moderatör uyarýlarý etkinleþtirildi. Devre dýþý býrakmak için /togmodwarnings kullanýn.", MSG_TYPE_INFO ) ;
	}

	else if ( PlayerModWarnings [ playerid ] ) {
		PlayerModWarnings [ playerid ] = false ;

		return SendServerMessage ( playerid, "Moderatör uyarýlarý devre dýþý býrakýldý. Etkinleþtirmek için /togmodwarnings kullanýn.", MSG_TYPE_INFO ) ;
	}

	return true ;
}

CMD:afrisk ( playerid, params [] ) {


	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new targetid ;

	if ( sscanf ( params, "k<u>", targetid )) {

		return SendServerMessage ( playerid, "/afrisk [hedef]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected(targetid)){

		return SendServerMessage ( playerid, "Hedef baðlý deðil.", MSG_TYPE_ERROR ) ;
	}

	SendClientMessage(playerid, COLOR_TAB0, sprintf("|________________________| (%d) %s'nin Arama |________________________|", targetid, ReturnUserName ( targetid, true ) ) ) ;
	SendClientMessage( playerid, COLOR_TAB1,  sprintf("[ELINDE]: %s - %d Mermi.", ReturnWeaponName ( Character [ targetid ] [ character_handweapon] ), Character [ targetid ] [ character_handammo ] )) ;
	SendClientMessage( playerid, COLOR_TAB2,  sprintf("[PANTOLONDA]: %s - %d Mermi.", ReturnWeaponName ( Character [ targetid ] [ character_pantsweapon] ), Character [ targetid ] [ character_pantsammo ] )) ;
	SendClientMessage( playerid, COLOR_TAB1,  sprintf("[SIRTINDA]: %s - %d Mermi.", ReturnWeaponName ( Character [ targetid ] [ character_backweapon] ), Character [ targetid ] [ character_backammo ] )) ;
	SendClientMessage( playerid, COLOR_TAB1,  sprintf("[PARA]: $%s", IntegerWithDelimiter ( Character [ targetid ] [ character_handmoney ] )) )  ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin aramýný yaptý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
	
	return true ;
}

CMD:adisarm ( playerid, params [] ) {
	// oyuncudan silahlarý kaldýrýr
	new targetid, permit ;

	if ( sscanf ( params, "k<u>i", targetid, permit ) ) {

		return SendServerMessage ( playerid, "Kullaným: /adisarm <oyuncu> <izin: 0: tut, 1: kaldýr>", MSG_TYPE_ERROR ) ;
	}

	RemovePlayerWeapon ( targetid ) ;

	Character [ targetid ] [ character_pantsweapon ] = WEAPON_FIST;
	Character [ targetid ] [ character_pantsammo ] = 0;

	Character [ targetid ] [ character_backweapon ] = WEAPON_FIST;
	Character [ targetid ] [ character_backammo ] = 0;

	SavePlayerWeapons ( targetid ) ;

	if ( permit ) {
		if ( DoesPlayerHaveItem ( playerid, CARD_GUNPERMIT ) != -1) {

			DiscardItem ( playerid, DoesPlayerHaveItem ( playerid, CARD_GUNPERMIT ) ) ;
		}

		SendServerMessage ( targetid, sprintf("Admin %s sizin silahlarýnýzý, merminizi ve lisansýnýzý aldý.", ReturnUserName ( playerid, false, true ) ), MSG_TYPE_INFO ) ;
		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin silahlarýný ve lisansýný aldý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
		WriteLog ( playerid, "mods/adisarm", sprintf("Admin %s - %s'nin silahlarýný ve lisansýný aldý", ReturnUserName ( playerid, true ), ReturnUserName ( targetid, true ) ) ) ;
			
	}

	else if ( ! permit ) {

		SendServerMessage ( targetid, sprintf("Admin %s sizin silahlarýnýzý ve merminizi aldý.", ReturnUserName ( playerid, false, true ) ), MSG_TYPE_INFO ) ;
		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin silahlarýný aldý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
		WriteLog ( playerid, "mods/adisarm", sprintf("Admin %s - %s'nin silahlarýný aldý", ReturnUserName ( playerid, true ), ReturnUserName ( targetid, true ) ) ) ;
	}			

	return true ;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CMD:stopinjuries ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new targetid ;

	if ( sscanf ( params, "k<u>", targetid )) {

		return SendServerMessage ( playerid, "/stopinjuries [oyuncu]", MSG_TYPE_ERROR ) ;
	}


	if ( targetid == INVALID_PLAYER_ID ) {

		return SendServerMessage ( playerid, "Bu oyuncunun baðlý olmasý gerekmez.", MSG_TYPE_ERROR ) ;
	}

	TogglePlayerSpectating ( targetid, false ) ;

    PlayerDamage [ targetid ] [ DAMAGE_LEGS ] = false ;
    PlayerDamage [ targetid ] [ DAMAGE_ARMS ] = false ;
	
	TogglePlayerControllable ( targetid, true ) ;
	ResetPlayerWounds ( targetid ) ;

	Character [ targetid ] [ character_dmgmode ] = 0 ;
	PlayerInjuredCooldown [ targetid ] = 0 ;

	ClearAnimations ( targetid ) ;
	CancelBloodPuddle ( targetid ) ;

	SetCharacterHealth ( targetid, 100 ) ;

	if ( ! IsPlayerPaused ( targetid ) ) {
		SetName ( targetid, sprintf("(%d) %s", targetid, ReturnUserName ( targetid, false, true ) ), 0xCFCFCFFF ) ;
	}

	else SetName ( targetid, sprintf("[DURDURULDU (/afklist)]{DEDEDE}\n(%d) %s", targetid, ReturnUserName ( targetid, false )  ), COLOR_RED ) ;

	new query [ 128 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_dmgmode = '0' WHERE character_id = '%d'", Character [ targetid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	SendServerMessage ( targetid, sprintf("Yaralanmalarýnýz moderatör (%d) %s tarafýndan kaldýrýldý", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_INFO ) ;
	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin yaralanmalarýný kaldýrdý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
	SendServerMessage ( playerid, "Komutun veritabanýna ulaþtýðýndan emin olmak için bu komutu hedefe bir veya iki kez daha çalýþtýrýn.", MSG_TYPE_ERROR ) ;

	return true ;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CMD:ban ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid, reason [ 64 ], hours ;

	if ( sscanf ( params, "k<u>is[64]", uid, hours, reason ) ) {

		return SendServerMessage ( playerid, "/ban [ oyuncuID / ad ] [ saat ] [ sebep ]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}
		
	if ( hours < 12 || hours > 720 ) {

		return SendServerMessage ( playerid, "Yasaklama saati 12 ile 720 saat arasýnda olmalýdýr", MSG_TYPE_ERROR ) ;
	}
    
	if ( hours == 0 ) {

		hours = 9999 ;
	}

    new secs = hours * 3600, unbants ;
    unbants = gettime() + secs;
    
    new query[256] ;
    
    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
	Account [ uid ] [ account_id ], Account [ uid ] [ account_name ], ReturnIP ( uid ), Account [ playerid ] [ account_name ], reason, gettime(), unbants);

	mysql_tquery(mysql, query);

	SetAdminRecord ( Account [ uid ] [ account_id ], Account [ playerid ] [ account_id ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;
	
	SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s (%d) kullanýcýsýný \"%s\" sebebiyle yasakladý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid,  reason) ) ;
	WriteLog ( uid, "mod/bans", sprintf("%s (%d) - %s (%d) kullanýcýsýný \"%s\" sebebiyle yasakladý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid, reason ) ) ;

	SendRconCommand(sprintf("banip %s", ReturnIP ( uid )));
	KickPlayer ( uid ) ;

	return true ;
}

CMD:offlineban ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new masteracc [  MAX_PLAYER_NAME ], hours, reason [ 64 ] ;

	if ( sscanf ( params, "s[24]is[64]", masteracc, hours, reason ) ) {

		return SendServerMessage ( playerid, "/offlineban [master_hesap] [saat] [sebep] ( hesap adýný almak için /getma veya /getc kullanýn )", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( masteracc ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Adlar 24 karakterden uzun olamaz", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
	}
		
	if ( hours < 12 || hours > 720 ) {

		return SendServerMessage ( playerid, "Yasaklama saati 12 ile 720 saat arasýnda olmalýdýr", MSG_TYPE_ERROR ) ;
	}

	foreach (new i: Player) {

		if ( ! strcmp(masteracc, Account [ playerid ] [ account_name ] ) ) {
			return SendServerMessage ( playerid, sprintf("Oyuncu ID %d olarak baðlý görünüyor. Bunun yerine /ban kullanýn.", i ), MSG_TYPE_WARN ) ;

		}
	}

    new query[256], rows ;

	inline ReturnAccountName() {

		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return SendServerMessage ( playerid, "Veritabaný hesap verisi döndürmedi. Adý yanlýþ yazmýþ olabilirsiniz.", MSG_TYPE_WARN ) ;
		}

		if ( rows ) {

		   	new secs = hours * 3600, unbants, acc_id ;
		    unbants = gettime() + secs;

			cache_get_value_name_int ( 0, "account_id", acc_id ) ;

			SetAdminRecord ( acc_id, Account [ playerid ] [ account_id ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;

		    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', 'CEVRIMDISI YASAK', '%e', '%e', %d, %d)",
			acc_id, masteracc, Account [ playerid ] [ account_name ], reason, gettime(), unbants);

			mysql_tquery(mysql, query);

			SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s adlý kullanýcýyý çevrimdýþý olarak \"%s\" sebebiyle yasakladý", ReturnUserName ( playerid, true ), playerid, masteracc,  reason) ) ;
			WriteLog ( INVALID_PLAYER_ID, "mod/bans", sprintf("%s (%d) - %s adlý kullanýcýyý çevrimdýþý olarak \"%s\" sebebiyle yasakladý", ReturnUserName ( playerid, true ), playerid, masteracc,  reason) ) ;
		}
	}

	MySQL_TQueryInline(mysql, using inline ReturnAccountName, "SELECT account_id FROM master_accounts WHERE account_name = '%s'", masteracc );

	return true ;
}

CMD:oban ( playerid, params [] ) {

	return cmd_offlineban ( playerid, params ) ;
}

CMD:unban ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new masteracc [  MAX_PLAYER_NAME ];

	if ( sscanf ( params, "s[24]", masteracc ) ) {

		return SendServerMessage ( playerid, "/unban [master_hesap] ( hesap adýný almak için /getma veya /getc kullanýn )", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( masteracc ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Adlar 24 karakterden uzun olamaz", MSG_TYPE_ERROR ) ;
	}

    new query[180], rows ;

	inline ReturnAccountName() {

		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return SendServerMessage ( playerid, "Veritabaný hesap verisi döndürmedi. Adý yanlýþ yazmýþ olabilirsiniz.", MSG_TYPE_WARN ) ;
		}

		if ( rows ) {

			new acc_id ;
			cache_get_value_name_int ( 0, "account_id", acc_id ) ;

			inline CheckUnban() {

				cache_get_row_count ( rows ) ;

				if ( ! rows ) {

					return SendServerMessage ( playerid, sprintf("(%d) %s yasaklanmýþ gibi görünmüyor. Adý doðru yazdýnýz mý?", acc_id, masteracc ), MSG_TYPE_WARN ) ;
				}

				if ( rows ) {

				    mysql_format ( mysql, query, sizeof ( query), "DELETE FROM bans WHERE account_id = %d", acc_id ) ;
					mysql_tquery(mysql, query);

					SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin yasaðýný kaldýrdý", ReturnUserName ( playerid, true ), playerid, masteracc, acc_id ), MOD_WARNING_LOW ) ;
					WriteLog ( INVALID_PLAYER_ID, "mod/unbans", sprintf("%s (%d) - (%d) %s'nýn yasaðýný kaldýrdý", ReturnUserName ( playerid, true ), playerid, acc_id, masteracc ) ) ;
				}
			}

			MySQL_TQueryInline(mysql, using inline CheckUnban, "SELECT * FROM bans WHERE account_id = %d", acc_id );
		}
	}

	MySQL_TQueryInline(mysql, using inline ReturnAccountName, "SELECT account_id FROM master_accounts WHERE account_name = '%s'", masteracc );

	return true ;
}

CMD:unbanip ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az temel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new ip [  16 ];

	if ( sscanf ( params, "s[16]", ip ) ) {

		return SendServerMessage ( playerid, "/unbanip [ip] ( hesap adýný almak için /getma veya /getc kullanýn )", MSG_TYPE_ERROR ) ;
	}

	SendRconCommand(sprintf("unbanip %s", ip ) ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - IP %s'yi yasaklamayý kaldýrdý", ReturnUserName ( playerid, true ), playerid, ip ), MOD_WARNING_LOW ) ;
	WriteLog ( playerid, "mods/unban", sprintf("Admin %s - IP %s'yi yasaklamayý kaldýrdý", ReturnUserName ( playerid, true ), ip ) ) ;
	
	return true ;
}

BanChecker ( playerid ) {

	new query [ 512 ] ;

	inline BanHandler() {
		new rows ;

		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return true ;
		}

	    if ( rows ) {

			new unbantimestamp, admin [ MAX_PLAYER_NAME ], reason [ 64 ], date [ 6 ]  ;

			for ( new i, p = rows; i < p; i ++ ) {

				cache_get_value_name ( i, "ban_admin", admin, 24 ) ;
				cache_get_value_name ( i, "ban_reason", reason, 36 ) ;

				cache_get_value_int ( i, "unban_time", unbantimestamp ) ;
			}

			if ( unbantimestamp > gettime () )  {

				HideCharacterTextDraws ( playerid ) ;

				query [ 0 ] = EOS ;

				TimestampToDate ( unbantimestamp, date[0], date[1], date[2], date[3], date[4], date[5], 1) ;

				SendClientMessage(playerid, COLOR_RED, "" ) ;
				SendClientMessage(playerid, COLOR_RED, "Bu hesap kurallarýmýza aykýrý davranýþ nedeniyle geçici olarak askýya alýnmýþtýr." ) ;
				SendClientMessage(playerid, COLOR_RED, "" ) ;
				SendClientMessage(playerid, COLOR_RED, sprintf("Moderatör %s tarafýndan %s sebebiyle yasaklandýnýz.", admin, reason));
				SendClientMessage(playerid, COLOR_RED, sprintf("Yasaðýnýz %02d/%02d/%02d %02d:%02d:%02d tarihinde kaldýrýlacaktýr", date[2], date[1], date[0], date[3], date[4], date[5]));
				SendClientMessage(playerid, COLOR_RED, "" ) ;
				SendClientMessage(playerid, COLOR_RED, "Lütfen bu yasaðý ihlal etmeye çalýþmayýn, çünkü yasak kaçýþý kalýcý yasaða yol açar." ) ;
				SendClientMessage(playerid, COLOR_RED, "Bu yasaða katýlmýyorsanýz, lütfen forumlarýmýzda yasaða itiraz edin. {DEDEDE}(www.ww-rp.net)" ) ;
				SendClientMessage(playerid, COLOR_RED, "" ) ;

				SendRconCommand(sprintf("banip %s", ReturnIP ( playerid )));

		    	return KickPlayer ( playerid ) ;
			}
		}
	}

	MySQL_TQueryInline ( mysql, using inline BanHandler, "SELECT unban_time, ban_admin, ban_reason FROM bans WHERE account_id = '%d'", Account [ playerid ] [ account_id ] ) ;

	return true ;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

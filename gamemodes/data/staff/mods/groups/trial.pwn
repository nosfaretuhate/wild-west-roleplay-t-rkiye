new Float: spec_pos_x 	[ MAX_PLAYERS ] ;
new Float: spec_pos_y 	[ MAX_PLAYERS ] ;
new Float: spec_pos_z 	[ MAX_PLAYERS ] ;
new spec_int 	[ MAX_PLAYERS ] ;
new spec_vw 	[ MAX_PLAYERS ] ;

CMD:trialban ( playerid, params [] ) {


	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid, reason [ 64 ], hours = 24 ;

	if ( sscanf ( params, "k<u>s[64]", uid, reason ) ) {

		SendServerMessage ( playerid, "Bu komut oyuncuyu 24 saat yasaklayacaktýr, kalýcý yasak için temel moderatörle iletiþime geçin.", MSG_TYPE_WARN ) ;
		return SendServerMessage ( playerid, "/trialban [ oyuncuID / ad ] [ sebep ]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}
		

    new secs = hours * 3600, unbants ;
    unbants = gettime() + secs;
    
    new query[256], reason_temp [ 128 ] ;

    strins(reason_temp, sprintf("[GEÇÝCÝ] %s", reason), 0, sizeof ( reason_temp ) ) ;
    
    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
	Account [ uid ] [ account_id ], Account [ uid ] [ account_name ], ReturnIP ( uid ), Account [ playerid ] [ account_name ], reason_temp, gettime(), unbants);

	mysql_tquery(mysql, query);

	SetAdminRecord ( Account [ uid ] [ account_id ], Account [ playerid ] [ account_id ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;
	SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s (%d) kullanýcýsýný geçici olarak \"%s\" sebebiyle yasakladý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid,  reason) ) ;

	WriteLog ( playerid, "mods/trialban", sprintf("[PERSONEL] %s (%d) - %s (%d) kullanýcýsýný geçici olarak \"%s\" sebebiyle yasakladý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid,  reason) ) ;

	SendRconCommand(sprintf("banip %s", ReturnIP ( uid )));
	KickPlayer ( uid ) ;

	return true ;
}

new IsPlayerSpectating [ MAX_PLAYERS ] ;
CMD:spectate(playerid, params[])
{
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	if (!isnull(params) && !strcmp(params, "off", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
			return SendServerMessage(playerid, "Herhangi bir oyuncuyu izlemiyorsunuz.", MSG_TYPE_ERROR);

	    PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);

	    IsPlayerSpectating [ playerid ] = INVALID_PLAYER_ID ;

	 	TogglePlayerSpectating(playerid, false);

	    ac_SetPlayerPos ( playerid, spec_pos_x [ playerid ], spec_pos_y [ playerid ], spec_pos_z [ playerid ] ) ;
	    SetPlayerInterior ( playerid, spec_int [ playerid ] ) ;
	    SetPlayerVirtualWorld( playerid, spec_vw [ playerid ] ) ;

		SendModeratorWarning ( sprintf("[ÝZLEME] %s (%d) oyuncuyu izlemeyi durdurdu.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_MED ) ;

		SetTimerEx("DelayAttachmentPlacement", 2000, false, "i", playerid);

	    return SendServerMessage(playerid, "Artýk izleyici modundasýnýz deðilsiniz.", MSG_TYPE_WARN);
	}

	new userid;

	if (sscanf(params, "k<u>", userid))
		return SendServerMessage(playerid, "/spectate [oyuncuID/ad] - Ýzlemeyi durdurmak için \"/spectate off\" yazýn.", MSG_TYPE_ERROR );

	if (!IsPlayerConnected(userid))
	    return SendServerMessage(playerid, "Geçersiz oyuncu belirttiniz.", MSG_TYPE_ERROR );

	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) {

		GetPlayerPos(playerid, spec_pos_x [ playerid ], spec_pos_y [ playerid ], spec_pos_z [ playerid ]);

		spec_int [ playerid ] = GetPlayerInterior(playerid);
		spec_vw [ playerid ] = GetPlayerVirtualWorld(playerid);
	}

	SetPlayerInterior(playerid, GetPlayerInterior(userid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));

	TogglePlayerSpectating(playerid, true);
	PlayerSpectatePlayer(playerid, userid);

	IsPlayerSpectating [ playerid ] = userid ;

	new buffer[256];
	format ( buffer, sizeof ( buffer ), "(%d) %s'nin admin notu: %s", userid, ReturnUserName(userid), Account [ userid ] [ account_anote] ) ;
	SendClientMessage(playerid, COLOR_YELLOW, buffer);

	if ( ! IsPlayerManager ( playerid ) ) {
		SendModeratorWarning ( sprintf("[ÝZLEME] %s (%d) - %s (%d) oyuncusunu izliyor", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( userid, true ), userid ), MOD_WARNING_MED ) ;
	}

	if(Account[userid][account_rulecheck]) {
		SendServerMessage(playerid,"Bu oyuncunun hesabý \"Potansiyel Kural Ýhlali Yapan\" olarak iþaretlenmiþtir.",MSG_TYPE_WARN);
	}

	return 1;
}

CMD:spec ( playerid, params [] ) {

	return cmd_spectate ( playerid, params ) ;
}

CMD:lastonline ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage ( playerid, "/lastonline [master_hesap]: hesap adýný almak için /getma kullanýn", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Adlar 24 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
	}

	inline ReturnAccountLastLogin() {

		new rows, returned_date, date[6] ;
		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return SendServerMessage ( playerid, "Veritabaný veri döndürmedi. Adý doðru yazdýnýz mý?", MSG_TYPE_WARN ) ;
		}

		if ( rows ) {

			cache_get_value_int ( 0, "account_lastlogin", returned_date ) ;

			if ( ! returned_date ) { 

				return SendServerMessage ( playerid, "Tarih hesaplanamýyor (zaman damgasý 0)", MSG_TYPE_ERROR ) ;
			}

			TimestampToDate ( returned_date, date[0], date[1], date[2], date[3], date[4], date[5], 1 ) ;

			return SendServerMessage ( playerid, sprintf("{D19932}%s{FFFFFF} son olarak %02d/%02d/%d - %02d:%02d:%02d tarihinde çevrimiçiydi.", name, date[2], date[1], date[0], date[3], date[4], date[5] ), MSG_TYPE_INFO ) ; 
		}
	}

	MySQL_TQueryInline(mysql, using inline ReturnAccountLastLogin, "SELECT account_lastlogin FROM master_accounts WHERE account_name = '%e'", name );

	return true ;
}

CMD:getstate ( playerid, params [] ) {

	new targetid;

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	if ( sscanf ( params, "k<u>", targetid ) ) {

		return SendServerMessage ( playerid, "/getstate [oyuncuID/ad]", MSG_TYPE_ERROR ) ;
	}

	SendServerMessage ( playerid, sprintf("%s Durum Bilgisi", ReturnUserName ( targetid, false ) ), MSG_TYPE_INFO ) ;

	SendServerMessage ( playerid, sprintf("{629C5C}Maskelenmis{FFFFFF}: %s", ( ReturnPlayerMasked ( targetid ) ) ? ("Evet") : ("Hayir") ), MSG_TYPE_INFO ) ;
	SendServerMessage ( playerid, sprintf("{FF6347}Yaralý{FFFFFF}: %s", ( Character [ targetid ] [character_dmgmode ] == 1 ) ? ("Evet") : ("Hayir") ), MSG_TYPE_INFO ) ;
	SendServerMessage ( playerid, sprintf("{629C5C}Ölü{FFFFFF}: %s", ( Character [ targetid ] [character_dmgmode ] == 2 ) ? ("Evet") : ("Hayir") ), MSG_TYPE_INFO ) ;
	SendServerMessage ( playerid, sprintf("{FF6347}Ata Binili{FFFFFF}: %s", ( IsPlayerRidingHorse [ targetid ] ) ? ("Evet") : ("Hayir") ), MSG_TYPE_INFO ) ;
	SendServerMessage ( playerid, sprintf("{629C5C}Durduruldu{FFFFFF}: %s", ( IsPlayerPaused ( targetid ) ) ? ("Evet") : ("Hayir") ), MSG_TYPE_INFO ) ;

	return true ;
}


CMD:getmasteraccount ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}
	
	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage ( playerid, "/getma(steraccount) [karakter_adi]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Adlar 24 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
	}

	inline ReturnAccountID() {

		new rows, returned_id, returned_name [ MAX_PLAYER_NAME ];
		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return SendServerMessage ( playerid, "Veritabaný veri döndürmedi. Adý doðru yazdýnýz mý?", MSG_TYPE_WARN ) ;
		}

		if ( rows ) {

			cache_get_value_name_int(0, "account_id", returned_id ) ;

			inline ReturnAccountName() {

				cache_get_row_count ( rows ) ;

				if ( ! rows ) {

					return SendServerMessage ( playerid, "Veritabaný veri döndürmedi. Bu olmak istenmiyordu. Bir geliþtiriciyle iletiþime geçmelisiniz.", MSG_TYPE_WARN ) ;
				}

				if ( rows ) {

					cache_get_value_name(0, "account_name", returned_name, sizeof ( returned_name ) ) ;

					return SendServerMessage ( playerid, sprintf("{D19932}%s'nin{FFFFFF} master hesabý {D19932}(%d) %s{FFFFFF}", name, returned_id, returned_name ), MSG_TYPE_INFO ) ; 
				}
			}

			MySQL_TQueryInline(mysql, using inline ReturnAccountName, "SELECT account_name FROM master_accounts WHERE account_id = %d", returned_id );
		}
	}

	MySQL_TQueryInline(mysql, using inline ReturnAccountID, "SELECT account_id FROM characters WHERE character_name = '%e'", name );

	return true ;
}

CMD:getma ( playerid, params [ ] ) {
	return cmd_getmasteraccount ( playerid, params ) ;
}

CMD:getcharacters ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage ( playerid, "/getc(haracters) [master_adi]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Adlar 24 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
	}

	inline ReturnMasterID() {

		new rows, returned_id  ;
		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return SendServerMessage ( playerid, "Veritabaný veri döndürmedi. Adý doðru yazdýnýz mý?", MSG_TYPE_WARN ) ;
		}

		if ( rows ) {

			cache_get_value_name_int(0, "account_id", returned_id ) ;

			inline ReturnCharacters() {

				new returned_name [ MAX_PLAYER_NAME ], char_string [ 72 ]  ;
				cache_get_row_count ( rows ) ;

				if ( ! rows ) {

					return SendServerMessage ( playerid, "Veritabaný veri döndürmedi. Bu olmak istenmiyordu. Bir geliþtiriciyle iletiþime geçmelisiniz.", MSG_TYPE_WARN ) ;
				}

				if ( rows ) {

					for ( new i, p = rows; i < p; i ++ ) {

						cache_get_value_name(i, "character_name", returned_name, sizeof ( returned_name ) ) ;
						format ( char_string, sizeof ( char_string), "%s (%d) %s", char_string, i, returned_name  ) ;
					}

					SendServerMessage ( playerid, sprintf("Hesap {D19932}(%d) %s{FFFFFF} için karakterler bulundu:", returned_id, name ), MSG_TYPE_INFO ) ;
					SendServerMessage ( playerid, sprintf("{D19932}%s{FFFFFF}", char_string ), MSG_TYPE_INFO ) ;

					
				}
			}

			MySQL_TQueryInline(mysql, using inline ReturnCharacters, "SELECT * FROM characters WHERE account_id = %d", returned_id );	
		}
	}

	MySQL_TQueryInline(mysql, using inline ReturnMasterID, "SELECT account_id FROM master_accounts WHERE account_name = '%e'", name );	

	return true ;
}

CMD:getc ( playerid, params [] ) {
	return cmd_getcharacters ( playerid, params ) ;
}


CMD:makeooc ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid ;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/makeooc [oyuncu / ad]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	if ( ! IsPlayerOOC [ uid ] ) {

		IsPlayerOOC [ uid ] = true ;

		if ( Character [ uid ] [ character_dmgmode ] || PlayerDamage [ uid ] [ DAMAGE_LEGS ] || PlayerDamage [ uid ] [ DAMAGE_ARMS ] ) { 
			
			cmd_stopinjuries ( playerid, Character [ uid ] [ character_name ] ) ; 
		}

		SendServerMessage ( uid, sprintf("%s tarafýndan OOC yapýldýnýz", ReturnUserName ( playerid, true ) ), MSG_TYPE_INFO ) ;
		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu OOC yaptý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

       	SetName ( uid,  sprintf("(( Oyunun Dýþýnda ))\n{[ (%d) %s ]}", uid, ReturnUserName ( uid, false ) ), COLOR_OOC ) ;
	}

	else if ( IsPlayerOOC [ uid ] ) {

		IsPlayerOOC [ uid ] = false ;

		SendServerMessage ( uid, sprintf("%s tarafýndan IC yapýldýnýz", ReturnUserName ( playerid, true ) ), MSG_TYPE_INFO ) ;
		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunun OOC durumunu kaldýrdý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

       	SetName ( uid,  sprintf("(%d) %s", uid, ReturnUserName ( uid, false ) ), 0xCFCFCFFF ) ;
	}

	return true ;
}

CMD:modduty ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerOnAdminDuty [ playerid ] ) {

		IsPlayerOnAdminDuty [ playerid ] = true ;
		PlayerModWarnings [ playerid ] = true ;

		if ( Character [ playerid ] [ character_dmgmode ] || PlayerDamage [ playerid ] [ DAMAGE_LEGS ] || PlayerDamage [ playerid ] [ DAMAGE_ARMS ] ) { 
			
			cmd_stopinjuries ( playerid, Character [ playerid ] [ character_name ] ) ; 
		}		

		SendServerMessage ( playerid, "Mod görevine baþladýnýz. Ýþiniz bittiðinde /staffisland'a gidin.", MSG_TYPE_INFO ) ;
		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) mod görevine baþladý.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_LOW ) ;

		if ( Account [ playerid ] [ account_id ] == 1 || Account [ playerid ] [ account_id ] == 2 ) {

    		SetName ( playerid, sprintf("(( OOC: Geliþtirici Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false ) ), 0x855A83FF ) ;
		}

		else {

			switch ( Account [ playerid ] [ account_stafflevel ] ) {

				case STAFF_MANAGER: {
					
	        		SetName ( playerid, sprintf("(( OOC: Yönetici Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false ) ), MANAGER_COLOR ) ;
				}

				default: SetName ( playerid, sprintf("(( OOC: Moderatör Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false ) ), 0x408040FF ) ;
			}
		}

	}

	else if ( IsPlayerOnAdminDuty [ playerid ] ) {

		IsPlayerOnAdminDuty [ playerid ] = false ;

		SendServerMessage ( playerid, "Mod görevini bitirdiniz.", MSG_TYPE_INFO ) ;
		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) mod görevini bitirdi.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_LOW ) ;

        SetName ( playerid, sprintf("(%d) %s", playerid, ReturnUserName ( playerid, false )), 0xCFCFCFFF ) ;
	}

	return true ;
}

CMD:givelogoutperm ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/givelogoutperm [ oyuncu / ad ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	LogoutPermission [ uid ] = true ;

	SendServerMessage ( uid, "/logout izni verildi. Artýk /logout komutunu kullanabilirsiniz.", MSG_TYPE_INFO ) ;
	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusuna logout izni verdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

	return true ;
}


CMD:aooc ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new string[256],text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, "/aooc [ metin ]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( Account [ playerid ] [ account_staffname ] ) == 0 ) {

		format(string,sizeof(string),"(( [AOOC] (%d) %s: %s ))",playerid,ReturnUserName(playerid,false),text);
		SendSplitMessageToAll ( COLOR_ORANGE, string ) ;
	}

	else {

		format(string,sizeof(string),"(( [AOOC] (%d) %s (%s): %s ))", playerid, ReturnUserName ( playerid, false ), Account [ playerid ] [ account_staffname ], text );
		SendSplitMessageToAll ( COLOR_ORANGE, string ) ;
	}

	return true ;
}

CMD:kick ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid, reason [ 64 ] ;

	if ( sscanf ( params, "k<u>s[64]", uid, reason ) ) {

		return SendServerMessage ( playerid, "/kick [ oyuncuID / ad ] [ sebep ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage ( playerid, "64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
	}

	SetDynamicObjectPos ( HorseObject [ uid ], 0.0, 0.0, 0.0 ) ;
	SetDynamicObjectPos ( CowObject [ uid ], 0.0, 0.0, 0.0 ) ;

	SetAdminRecord ( Account [ uid ] [ account_id ], Account [ playerid ] [ account_id ], ARECORD_TYPE_KICK, reason, 0, ReturnDateTime () ) ;
	SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu \"%s\" sebebiyle çýkardý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid,  reason) ) ;
	WriteLog ( uid, "mod/kicks", sprintf("%s (%d) - %s (%d) oyuncusunu \"%s\" sebebiyle çýkardý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid, reason ) ) ;

	KickPlayer ( uid ) ;

	return true ;
}

CMD:ajail ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid, time, reason [ 64 ] ;

	if ( sscanf ( params, "k<u>is[64]", uid, time, reason ) ) {

		return SendServerMessage ( playerid, "/ajail [oyuncu] [dakika cinsinden zaman] [sebep]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( reason ) > 64 ) {

		return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
	}

	new query [ 128 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_ajailed = '%d' WHERE character_id = '%d'", time, Character [ uid ]  [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	Character [ uid ] [ character_ajailed ] = time ;
	IsPlayerInAdminJail [ uid ] = true ;

	SetAdminRecord ( Account [ uid ] [ account_id ], Account [ playerid ] [ account_id ], ARECORD_TYPE_AJAIL, reason, time, ReturnDateTime () ) ;

	SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu %d dakika cezalandýrdý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid, time) ) ;
	SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] Sebep: \"%s\"", reason ) ) ;

	WriteLog ( uid, "mod/ajail", sprintf("%s (%d) - %s (%d) oyuncusunu %d dakika cezalandýrdý. Sebep: \"%s\"", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid, time, reason ) ) ;

	@pT_AdminJail_Handler_60000 () ;

	return true ;
}

CMD:unajail ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid ;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/unajail [oyuncuID]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerInAdminJail [ uid ] ) {

		new query [ 128 ] ;

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_ajailed = 0 WHERE character_id = '%d'", Character [ uid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		Character [ uid ] [ character_ajailed ] = 0 ;
		IsPlayerInAdminJail [ uid ] = false ;

		return SendServerMessage ( playerid, "Oyuncu cezaevinde deðil, ancak verileri sýfýrlandý.", MSG_TYPE_WARN ) ;
	}

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_ajailed = 0 WHERE character_id = '%d'", Character [ uid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	Character [ uid ]  [ character_ajailed ] = 0 ;
	IsPlayerInAdminJail [ uid ] = false ;

	SendServerMessage ( uid, "Cezaevinden salýndýnýz. Bu sefer davranýþlý olun lütfen.", MSG_TYPE_INFO ) ;
	SpawnPlayer_Character ( uid ) ;

	SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunun cezasýný iptal etti", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid) ) ;
	WriteLog ( uid, "mod/unjail", sprintf("%s (%d) - %s (%d) oyuncusunun cezasýný iptal etti", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ) ) ;

	return true ;
}


CMD:offlinejail ( playerid, params [] ) {


	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new charname [  MAX_PLAYER_NAME ], time, reason [ 64 ] ;

	if ( sscanf ( params, "s[24]is[64]", charname, time, reason ) ) {

		return SendServerMessage ( playerid, "/offlinejail [karakter] [dakika cinsinden zaman] [sebep] ( hesap adýný almak için /getma veya /getc kullanýn )", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( charname ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Adlar 24 karakterden uzun olamaz", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( reason ) > 64 ) {

		return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
	}

	if ( time < 10 || time > 120 ) {

		return SendServerMessage ( playerid, "Birini 2 saatten fazla veya 10 dakikadan az cezalandýramazsýnýz.", MSG_TYPE_ERROR ) ;
	}

	foreach(new i: Player) {

		if ( ! strcmp(charname, ReturnUserName ( i, true ) ) ) {

			return SendServerMessage ( playerid, sprintf("Oyuncu ID %d olarak baðlý görünüyor. Bunun yerine /ajail kullanýn.", i ), MSG_TYPE_WARN ) ;
		}
	}

    new query[180], rows, char_id, acc_id ;

	inline ReturnAccountName() {

		cache_get_row_count ( rows ) ;

		if ( ! rows ) {

			return SendServerMessage ( playerid, "Veritabaný hesap verisi döndürmedi. Adý yanlýþ yazmýþ olabilirsiniz.", MSG_TYPE_WARN ) ;
		}

		if ( rows ) {

			cache_get_value_name_int ( 0, "character_id", char_id ) ;
			cache_get_value_name_int ( 0, "account_id", acc_id ) ;

			mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_ajailed = '%d' WHERE character_id = '%d'", time, char_id ) ;
			mysql_tquery ( mysql, query ) ;

			SetAdminRecord ( acc_id, Account [ playerid ] [ account_id ], ARECORD_TYPE_AJAIL, reason, time, ReturnDateTime () ) ;
			SendSplitMessageToAll ( COLOR_STAFF, sprintf("[PERSONEL] %s (%d) - %s adlý oyuncuyu çevrimdýþý olarak \"%s\" sebebiyle cezalandýrdý", ReturnUserName ( playerid, true ), playerid, charname,  reason) ) ;
			WriteLog ( INVALID_PLAYER_ID, "mod/ajail", sprintf("%s (%d) - %s adlý oyuncuyu çevrimdýþý olarak \"%s\" sebebiyle cezalandýrdý", ReturnUserName ( playerid, true ), playerid, charname,  reason) ) ;
		}
	}

	MySQL_TQueryInline(mysql, using inline ReturnAccountName, "SELECT character_id, account_id FROM characters WHERE character_name = '%s'", charname );

	return true ;
}

CMD:ojail ( playerid, params [] ) {

	return cmd_offlinejail ( playerid, params ) ;
}

task AdminJail_Handler[60000]() {

	foreach (new playerid: Player) {

		if ( IsPlayerInAdminJail [ playerid ] ) {

			if ( Character [ playerid ] [ character_ajailed ] <= 0 ) {

				SendServerMessage ( playerid, "Cezaevinden salýndýnýz. Bu sefer davranýþlý olun lütfen.", MSG_TYPE_INFO ) ;

				IsPlayerInAdminJail [ playerid ] = false ;

				return SpawnPlayer_Character ( playerid ) ;
			}

			GameTextForPlayer(playerid, 
				sprintf("~w~~n~~n~~n~~n~~n~Cezaevinde kalan zaman:~n~~r~%d~w~ dakika", Character [ playerid ] [ character_ajailed ] ) , 59500, 3);

			new query [ 128 ] ;

			Character [ playerid ] [ character_ajailed ] -- ;
			ac_SetPlayerPos ( playerid, 154.1281, -1951.9653, 47.4766 ) ;
			TogglePlayerControllable ( playerid, true ) ;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_ajailed = '%d' WHERE character_id = '%d'", 
				Character [ playerid ] [ character_ajailed ], Character [ playerid ] [ character_id ] ) ;
			mysql_tquery ( mysql, query, "" ) ;
		}
	}

	return true ;
}

CMD:fw ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new Float: xpos, Float: ypos, Float: zpos ;

	GetPlayerPos ( playerid, xpos, ypos, zpos ) ;
	GetXYInFrontOfPlayer ( playerid, xpos, ypos, 2 ) ;

	ac_SetPlayerPos ( playerid, xpos, ypos, zpos, 0 ) ;

	return true ;
}

CMD:dn ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new Float: xpos, Float: ypos, Float: zpos ;
	GetPlayerPos ( playerid, xpos, ypos, zpos ) ;

	ac_SetPlayerPos ( playerid, xpos, ypos, zpos - 2, 0 ) ;

	return true ;
}

CMD:up ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new Float: xpos, Float: ypos, Float: zpos ;
	GetPlayerPos ( playerid, xpos, ypos, zpos ) ;

	ac_SetPlayerPos ( playerid, xpos, ypos, zpos + 2 , 0 ) ;

	return true ;
}

CMD:freeze ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/freeze [ oyuncuID / ad ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	TogglePlayerControllable(uid, false ) ;

	SendServerMessage ( uid, sprintf("Moderatör %s (%d) tarafýndan donduruldunuz", ReturnUserName ( playerid, true ), playerid ), MSG_TYPE_INFO ) ;
	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu dondurdu.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:unfreeze ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/unfreeze [ oyuncuID / ad ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	TogglePlayerControllable(uid, true ) ;

	SendServerMessage ( uid, sprintf("Moderatör %s (%d) tarafýndan çözüldünüz", ReturnUserName ( playerid, true ), playerid ), MSG_TYPE_INFO ) ;
	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu çözdü.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:slap ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/slap [ oyuncuID / ad ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

    new Float:x, Float:y, Float:z;

	GetPlayerPos ( uid, x, y, z ) ;
	ac_SetPlayerPos ( uid, x, y, z + 4 ) ;

	PlayerPlaySound ( uid, 1190, x, y, z ) ;

	SendServerMessage ( uid, sprintf("Moderatör %s (%d) tarafýndan dövüldünüz", ReturnUserName ( playerid, true ), playerid ), MSG_TYPE_INFO ) ;
	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu dövdü.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:bring ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid, Float: x, Float: y, Float: z ;

	if ( sscanf ( params, "u", uid ) ) {

		return SendServerMessage ( playerid, "/bring [ oyuncuID / ad ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	SendServerMessage ( uid, sprintf("Moderatör %s (%d) tarafýndan yanýna ýþýnlandýnýz.", ReturnUserName ( playerid, true ), playerid ), MSG_TYPE_INFO ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunu yanýna ýþýnladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

	BlackScreen ( uid ) ;

	GetPlayerPos ( playerid, x, y, z ) ;
	ac_SetPlayerPos ( uid, x, y, z ) ;

	SetPlayerInterior ( uid, GetPlayerInterior ( playerid ) ) ;
	SetPlayerVirtualWorld ( uid, GetPlayerVirtualWorld ( playerid ) ) ;

	if(GetCharacterPointID(uid) != -1) {

		if(GetCharacterPointID(playerid) != -1) { SetCharacterPointID(uid,GetCharacterPointID(playerid)); }
		else { ResetCharacterPointID(uid); }
	}
	else {

		if(GetCharacterPointID(playerid) != -1) { SetCharacterPointID(uid,GetCharacterPointID(playerid)); }
	}

	return true ;
}

CMD:goto ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az aday moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new uid, Float: x, Float: y, Float: z ;

	if ( sscanf ( params, "k<u>", uid ) ) {

		return SendServerMessage ( playerid, "/goto [ oyuncuID / ad ]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( uid ) ) {

		return SendServerMessage ( playerid, "Seçilen oyuncu yok, çevrimdýþý olabilir.", MSG_TYPE_INFO ) ;
	}

	SendServerMessage ( uid, sprintf("Moderatör %s (%d) sizin yanýnýza ýþýnlandý.", ReturnUserName ( playerid, true ), playerid ), MSG_TYPE_INFO ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusunun yanýna ýþýnlandý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid ), MOD_WARNING_LOW ) ;

	GetPlayerPos ( uid, x, y, z ) ;
	ac_SetPlayerPos ( playerid, x, y, z, 0 ) ;

	SetPlayerInterior ( playerid, GetPlayerInterior ( uid ) ) ;
	SetPlayerVirtualWorld ( playerid, GetPlayerVirtualWorld ( uid ) ) ;

	if(GetCharacterPointID(uid) != -1) { SetCharacterPointID(playerid,GetCharacterPointID(uid)); }

	return true ;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
	if ( newkeys & KEY_FIRE && IsPlayerSpectating [ playerid ] != INVALID_PLAYER_ID ) {

		for ( new i = IsPlayerSpectating [ playerid ] + 1 ; i < Iter_Last(Player); i ++ ) {

			if ( IsPlayerConnected ( i ) && i != playerid ) {

				SetPlayerInterior(playerid, GetPlayerInterior(i));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));

				PlayerSpectatePlayer(playerid, i);

				IsPlayerSpectating [ playerid ] = i ;

				SendServerMessage(playerid, sprintf("%s (ID: %d) oyuncusunu izliyorsunuz.", ReturnUserName(i, false), i), MSG_TYPE_WARN );

				return true ;
			}
		}

		foreach ( new i : Player ) {

			if ( i != playerid ) {

				SetPlayerInterior(playerid, GetPlayerInterior(i));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));

				PlayerSpectatePlayer(playerid, i);

				IsPlayerSpectating [ playerid ] = i ;

				SendServerMessage(playerid, sprintf("%s (ID: %d) oyuncusunu izliyorsunuz.", ReturnUserName(i, false), i), MSG_TYPE_WARN );

				return true ;
			}
		}
	}

	else if ( newkeys & KEY_AIM && IsPlayerSpectating [ playerid ] != INVALID_PLAYER_ID ) {

		for ( new i = IsPlayerSpectating [ playerid ] - 1 ; i >= 0 ; i -- ) {

			if ( IsPlayerConnected ( i ) && i != playerid ) {

				SetPlayerInterior(playerid, GetPlayerInterior(i));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));

				PlayerSpectatePlayer(playerid, i);

				IsPlayerSpectating [ playerid ] = i ;

				SendServerMessage(playerid, sprintf("%s (ID: %d) oyuncusunu izliyorsunuz.", ReturnUserName(i, false), i), MSG_TYPE_WARN );

				return true ;
			}
		}

		for ( new i = MAX_PLAYERS - 1; i >= 0; i -- ) {

			if ( IsPlayerConnected ( i ) && i != playerid ) {

				SetPlayerInterior(playerid, GetPlayerInterior(i));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));

				PlayerSpectatePlayer(playerid, i);

				IsPlayerSpectating [ playerid ] = i ;

				SendServerMessage(playerid, sprintf("%s (ID: %d) oyuncusunu izliyorsunuz.", ReturnUserName(i, false), i), MSG_TYPE_WARN );

				return true ;
			}
		}

	}
	#if defined spec_OnPlayerKeyStateChange
		return spec_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange spec_OnPlayerKeyStateChange
#if defined spec_OnPlayerKeyStateChange
	forward spec_OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys);
#endif

new PlayerModWarnings 	[ MAX_PLAYERS ] ; 
new HasPlayerMutedSupporterChat[MAX_PLAYERS];
new HasPlayerMutedModeratorChat[MAX_PLAYERS];

#include "data/staff/coc.pwn"

#include "data/staff/man/core.pwn"
#include "data/staff/supp/core.pwn"
#include "data/staff/mods/core.pwn"
#include "data/staff/arecord.pwn"


GetStaffRankName ( stafflevel ) {
	
	new staffrankname[36];
	switch(stafflevel) {

		case 0: { staffrankname = "Yok"; }
		case 1: { staffrankname = "Destek Personeli"; }
		case 2: { staffrankname = "Moderatör"; }
		case 3: { staffrankname = "Yönetim"; }
		default: { staffrankname = "N/A"; }
	}
	return staffrankname;
}

GetStaffGroupName ( grouplevel ) {
	
	new staffgroupname[36];
	switch(grouplevel) {

		case 0: { staffgroupname = "Yok"; }
		case 1: { staffgroupname = "Aday Moderatör"; }
		case 2: { staffgroupname = "Temel Moderatör"; }
		case 3: { staffgroupname = "Genel Moderatör"; }
		case 4: { staffgroupname = "Son Seviye Moderatör"; }
		default: { staffgroupname = "N/A"; }
	}
	return staffgroupname;
}

CMD:anote(playerid, params[]) {

	if ( ! IsPlayerStaff ( playerid ) ) {

		return SendServerMessage ( playerid, "Personel üyesi deðilsiniz.", MSG_TYPE_ERROR ) ;
	}

	new option [ 32 ], target, note [ 256 ], buffer[256] ;

	if ( sscanf ( params, "s[32]uS(0)[256]", option, target, note )) {

		return SendServerMessage ( playerid, "/anote [ekle/kontrol]", MSG_TYPE_ERROR ) ;
	}

	if ( ! strcmp ( option, "add", true ) ) {

		if ( ! IsPlayerConnected ( target ) ) {

			return SendServerMessage ( playerid, "Hedef baðlý deðil.", MSG_TYPE_ERROR ) ;
		}

		if ( ! strlen ( note ) || strlen ( note ) > 64 ) {

			return SendServerMessage ( playerid, "Notlar boþ olamaz veya 128 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
		}

		strcat(buffer, Account [ target ] [ account_anote ]);

		Account [ target ] [ account_anote ] [ 0 ] = EOS ;
		strcat ( Account [ target ] [ account_anote ], note );

		SendClientMessage(playerid, COLOR_YELLOW, sprintf("(%d) %s'nin admin notunu deðiþtirdiniz:", target, ReturnUserName(target)));
		SendClientMessage(playerid, 0xDEDEDEFF, sprintf("%s", Account [ target ] [ account_anote ])) ;

		format ( buffer, sizeof ( buffer ), "Eski admin notu: %s", buffer ) ;
		SendClientMessage(playerid, COLOR_YELLOW, buffer);

		buffer [ 0 ] = EOS ;

		mysql_format (mysql, buffer, sizeof ( buffer ), "UPDATE master_accounts SET account_anote='%s' WHERE account_id=%d", Account [ target ] [ account_anote ], Account [ target ] [ account_id ]) ;
		mysql_tquery(mysql, buffer);
	}

	else if ( ! strcmp ( option, "check", true ) ) {

		if ( ! IsPlayerConnected ( target ) ) {

			return SendServerMessage ( playerid, "Hedef baðlý deðil.", MSG_TYPE_ERROR ) ;
		}

		strcat(buffer, Account [ target ] [ account_anote ]);

		format ( buffer, sizeof ( buffer ), "(%d) %s'nin admin notu: %s", target, ReturnUserName(target), buffer ) ;
		SendClientMessage(playerid, COLOR_YELLOW, buffer);
	}

	return true ;
}

CMD:answer ( playerid, params [] ) {

	if ( ! IsPlayerStaff ( playerid ) ) {

		return SendServerMessage ( playerid, "Personel üyesi deðilsiniz.", MSG_TYPE_ERROR ) ;
	}

	new userid, answer [ 144 ] ;

	if ( sscanf ( params, "k<u>s[144]", userid, answer ) ) {

		return SendServerMessage ( playerid, "/answer [id] [cevap]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( userid ) ) {

		return SendServerMessage ( playerid, "Oyuncu baðlý deðil.", MSG_TYPE_ERROR ) ;
	}

	SendSplitMessage(userid, 0xDEDEDEFF, sprintf("{44639C}[CEVAP]{DEDEDE} (%d) %s cevap verdi: %s", playerid, ReturnUserName ( playerid, true ), answer ) ) ;

	foreach(new i: Player) {

		if ( IsPlayerConnected ( i ) && IsPlayerStaff ( i ) ) {

			SendClientMessage(i, 0xDEDEDEFF, sprintf("{44639C}[CEVAP]{DEDEDE} (%d) %s - (%d) %s'ye cevap verdi:", playerid, ReturnUserName ( playerid, true ), userid, ReturnUserName ( userid, true ) ) ) ;
			SendSplitMessage(i, 0xDEDEDEFF, sprintf("%s", answer));
		}

		else continue ;
	}

	WriteLog ( playerid, "mod/answers", sprintf("(%d) %s - (%d) %s'ye cevap verdi: %s", playerid, ReturnUserName ( playerid, true ), userid, ReturnUserName ( userid, true ), answer ) ) ;

	return true ;
}

CMD:staff ( playerid, params [] ) {

	new string [ 256 ], count, name [ MAX_PLAYER_NAME * 2 ] ;


	SendClientMessage(playerid, MANAGER_COLOR, "Çevrimiçi Yöneticiler");

	foreach (new i: Player) {

		if ( GetStaffLevel ( i ) >= STAFF_MANAGER ) {

			count ++ ;

			if ( strlen ( Account [ i ] [ account_staffname ] ) == 0 ) {
				format ( name, sizeof ( name ), "%s", ReturnUserName ( i, true ) ) ;
			}

			else format ( name, sizeof ( name ), "%s (%s)", ReturnUserName ( i, true ), Account [ i ] [ account_staffname ] ) ;

			format ( string, sizeof ( string ), "(%d) %s", i, name ) ;
			SendClientMessage(playerid, 0xDEDEDEFF, string ) ;
		}
	}

	if ( count <= 0 ) {
		SendClientMessage(playerid, COLOR_DEFAULT, "Yok" ) ;
	}

	count = 0 ;

	SendClientMessage(playerid, MODERATOR_COLOR, "Çevrimiçi Moderatörler");

	foreach (new i: Player) {

		if ( GetStaffLevel ( i ) == STAFF_MODERATOR ) {
			count ++ ;

			if ( strlen ( Account [ i ] [ account_staffname ] ) == 0 ) {
				format ( name, sizeof ( name ), "%s", ReturnUserName ( i, true, false ) ) ;
			}

			else format ( name, sizeof ( name ), "%s (%s)", ReturnUserName ( i, true, false ), Account [ i ] [ account_staffname ] ) ;

			if ( IsPlayerOnAdminDuty [ i ] ) {

				format ( string, sizeof ( string ), "%s %s (%d): {007FFF}Görevde", GetStaffGroupName ( Account [ i ] [ account_staffgroup ] ) , name, i ) ;
				SendClientMessage(playerid, 0xDEDEDEFF, string ) ;
			}

			else {

				format ( string, sizeof ( string ), "%s %s (%d): {FF6347}Oyun Ýçinde", GetStaffGroupName ( Account [ i ] [ account_staffgroup ] ), name, i ) ;
				SendClientMessage(playerid, 0xDEDEDEFF, string ) ;
			}
		}
	}

	if ( count <= 0 ) {
		SendClientMessage(playerid, COLOR_DEFAULT, "Yok" ) ;
	}

	count = 0 ;

	SendClientMessage(playerid, SUPPORTER_COLOR, "Çevrimiçi Destek Personeli");

	foreach (new i: Player) {

		if ( GetStaffLevel ( i ) == STAFF_SUPPORTER ) {


			if ( strlen ( Account [ i ] [ account_staffname ] ) == 0 ) {
				format ( name, sizeof ( name ), "%s", ReturnUserName ( i, true, false ) ) ;
			}

			else format ( name, sizeof ( name ), "%s (%s)", ReturnUserName ( i, true, false ), Account [ i ] [ account_staffname ] ) ;


			count ++ ;

			format ( string, sizeof ( string ), "(%d) %s", i, name ) ;
			SendClientMessage(playerid, 0xDEDEDEFF, string ) ;
		}
	}

	if ( count <= 0 ) {

		SendClientMessage(playerid, COLOR_DEFAULT, "Yok" ) ;
	}

	return true ;
}

CMD:staffisland ( playerid, params [] ) {
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bunu yapmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) personel adasýna ýþýnlandý.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_LOW ) ;

	ac_SetPlayerPos ( playerid, 625.9899, -2669.7793, 1.7300 ) ;

	return true ;
}

CMD:staffhelp ( playerid, params [] ) {

	if ( ! IsPlayerStaff ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu listeye eriþmek için personel takýmýnýn parçasý olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffLevel ( playerid ) >= STAFF_SUPPORTER ) {

		SendClientMessage(playerid, 0x4075A1FF, "[DESTEK PERSONELI] /support, /answer, /questions, /staffname" ) ;
	}

	if ( GetStaffLevel ( playerid ) >= STAFF_MODERATOR ) {

		if ( GetStaffGroup ( playerid ) >= TRIAL_MOD ) {


			SendClientMessage(playerid, 0x86DB86FF, "[ADAY MODERATÖR] /trialban, /aooc, /makeooc, /getc(haracters), /givelogoutperm, /fw, /up, /dn, /kick, /ac(un)invite" ) ;
			SendClientMessage(playerid, 0x86DB86FF, "[ADAY MODERATÖR] /modduty, /freeze, /unfreeze, /slap, /bring, /goto, /getma(steraccount), /coc, /spec , /atrap" ) ;
			SendClientMessage(playerid, 0x86DB86FF, "[ADAY MODERATÖR] /togmodwarnings, /staffisland, /m(od), /acceptreport, /denyreport, /reports, /ajail, /unajail, /ojail, /gotodeer" ) ;
		}

		if ( GetStaffGroup ( playerid ) >= BASIC_MOD ) {

			SendClientMessage(playerid, 0x56B356FF, "[TEMEL MODERATÖR] /refreshweather, /ban, /o(ffline)ban, /unban, /getstate, /toggleooc, /geoip,  /stopinjuries" ) ;
			SendClientMessage(playerid, 0x56B356FF, "[TEMEL MODERATÖR] /processn(ame)c(hange), /namechanges, /viewplayeritems, /supportercheck, /lastonline, /adisarm" ) ;
			SendClientMessage(playerid, 0x56B356FF, "[TEMEL MODERATÖR] /afrisk, /unbanip, /clearshells" ) ;
		}
		
		if ( GetStaffGroup ( playerid ) >= GENERAL_MOD ) {

			SendClientMessage(playerid, 0x3B783BFF, "[GENEL MODERATÖR] /set, /setweather, /settime, /setinterior, /setvirtualworld, /forcerespawnore, /removecheckpoints" ) ;
			SendClientMessage(playerid, 0x3B783BFF, "[GENEL MODERATÖR] /reloadpoints, /reloadposses, /gotomotel, /respawndeers, /gotoxyz, /destroydynamiclabel, /acceptlabelrequest" ) ;
			SendClientMessage(playerid, 0x3B783BFF, "[GENEL MODERATÖR] /denylabelrequest, /refreshdynamiclabels" ) ;
		}

		if ( GetStaffGroup ( playerid ) >= ADVANCED_MOD ) {

			SendClientMessage(playerid, 0x2C572CFF, "[ÝLERÝ MODERATÖR] /givemoney, /spawnweapon, /gotodroppedweapon, /removedroppedweapon" ) ;
			SendClientMessage(playerid, 0x2C572CFF, "[ÝLERÝ MODERATÖR] /ap(oint), /aposse, /forcepaycheck, /forcelottery, /toggleooc, /togglereports" ) ;
			SendClientMessage(playerid, 0x2C572CFF, "[ÝLERÝ MODERATÖR] /purgequestions, /clearplayerinventory, /ctable, /dtable");
		}
	}

	if ( IsPlayerManager ( playerid ) ) {

		SendClientMessage(playerid, 0xA13A3AFF, "[YÖNETÝM] /man, /makestaff, /setstaffgroup, /makedonator, /cleardroppeditems" ) ;
	}

	return true ;
}

CMD:staffname ( playerid, params [] ) {
	if ( ! IsPlayerStaff ( playerid ) ) {

		return SendServerMessage ( playerid, "Bunu yapmak için personel üyesi olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage ( playerid, "/staffname [ad]", MSG_TYPE_ERROR ) ;
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage ( playerid, "Ad 24 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
	}

	new query [ 128 ] ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) personel adýný %s olarak deðiþtirdi.", ReturnUserName ( playerid, true ), playerid, name), MOD_WARNING_LOW ) ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_staffname = '%e' WHERE account_id = '%d'", 
	name, Account [ playerid ] [ account_id ] ) ;

	mysql_tquery ( mysql, query ) ;

	Account [ playerid ] [ account_staffname ] [ 0 ] = EOS ;
	strcat(Account [ playerid ] [ account_staffname ], name, MAX_PLAYER_NAME ) ;

	return true ;
}

IsPlayerStaff ( playerid ) {
	if ( ! IsPlayerLogged [ playerid ] ) {

		return false ;
	}

	if ( Account [ playerid ] [ account_stafflevel ] != 0 ) {

		return true ;
	}

	return false ;
}

IsPlayerSupporter ( playerid ) {

	if ( ! IsPlayerLogged [ playerid ] ) {

		return false ;
	}

	new pointer = ( GetStaffLevel ( playerid ) >= STAFF_SUPPORTER ) ? true : false ;

	return pointer ;
}

IsPlayerModerator ( playerid ) {

	if ( ! IsPlayerLogged [ playerid ] ) {

		return false ;
	}

	new pointer = ( GetStaffLevel ( playerid ) >= STAFF_MODERATOR ) ? true : false ;
	return pointer ;
}

IsPlayerManager ( playerid ) {

	if ( ! IsPlayerLogged [ playerid ] ) {

		return false ;
	}

	new pointer = ( GetStaffLevel ( playerid ) >= STAFF_MANAGER ) ? true : false ;
	return pointer ;
}

GetStaffLevel ( playerid ) {

	if ( ! IsPlayerStaff ( playerid ) ) {

		return false ;
	}

	return Account [ playerid ] [ account_stafflevel ] ;
}

GetStaffGroup ( playerid ) {

	if ( ! IsPlayerStaff ( playerid ) ) {

		return false ;
	}

	return Account [ playerid ] [ account_staffgroup ] ;
}

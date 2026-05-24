//#include <BustAim>

#define MAX_ANTICHEAT_WARNINGS	( 3 )

new player_ACTick_Money 		[ MAX_PLAYERS ] ; 
new player_ACTick_Weapon 		[ MAX_PLAYERS ] ; 
new player_ACTick_Ammo 			[ MAX_PLAYERS ] ;
new player_ACTick_Fly 			[ MAX_PLAYERS ] ;
new player_ACTick_Speed 		[ MAX_PLAYERS ] ;
new player_ACTick_AimbotIncr 	[ MAX_PLAYERS ] ;
new player_ACTick_ShootRate 	[ MAX_PLAYERS ] ;

new disallowed_weapons [ ] = {

	WEAPON_BRASSKNUCKLE, 	WEAPON_GOLFCLUB, 			WEAPON_NITESTICK, 			WEAPON_CHAINSAW,
	WEAPON_DILDO,			WEAPON_DILDO2, 				WEAPON_VIBRATOR, 			WEAPON_VIBRATOR2,
	WEAPON_GRENADE,			WEAPON_TEARGAS,				WEAPON_COLT45,				WEAPON_SILENCED,
	WEAPON_SHOTGSPA,		WEAPON_UZI,					WEAPON_MP5,					WEAPON_AK47,			
	WEAPON_M4,				WEAPON_TEC9,				WEAPON_ROCKETLAUNCHER,		WEAPON_HEATSEEKER,		
	WEAPON_FLAMETHROWER,	WEAPON_MINIGUN,				WEAPON_SATCHEL,				WEAPON_BOMB,			
	WEAPON_SPRAYCAN,		WEAPON_FIREEXTINGUISHER,	44,							45,						
	WEAPON_PARACHUTE
} ;


static Float: GetPlayerSpeed(playerid)
{
	new Float:SpeedX, Float:SpeedY, Float:SpeedZ, Float:Speed;

	GetPlayerVelocity(playerid, SpeedX, SpeedY, SpeedZ);
	Speed = floatsqroot(floatadd(floatpower(SpeedX, 2.0), floatpower(SpeedY, 2.0)));

	return floatmul(Speed, 200.0);
}

CheckCBug ( playerid, weaponid, tickcount ) {

	new time;
	if ( weaponid == 24 ) {

		time = GetTickDiff ( GetTickCount(), tickcount ) ;
		if ( time < 650 ) {

			WriteLog (playerid, "cbug", sprintf("(%d) %s c-bug yapmaya çalýþtý.", playerid, ReturnUserName ( playerid, true, false )));

			TogglePlayerControllable ( playerid, false ) ;
			SetTimerEx("CBugRelease", 750, false, "i", playerid);
		}
	}
}

GetShootRate ( playerid ) {

	return player_ACTick_ShootRate [ playerid ];
}

SetShootRate ( playerid ) {

	player_ACTick_ShootRate [ playerid ] = GetTickCount();
}

forward CBugRelease(playerid);
public CBugRelease(playerid) {

	TogglePlayerControllable ( playerid, true ) ;
}

/*

IÞINLANMA (TP) HÝLESÝ KORUMASI:

SetPlayerPos'u bir deðiþkende pozisyonlarý kaydetmek için baðla
Bu deðiþkeni her 2-3 saniyede bir yeni pozisyonla güncelle & oyuncunun önceki pozisyonun (15) menzilinde olup olmadýðýný kontrol et
Eðer deðilse, ýþýnlanma hilesi uyarýsý gönder

*/

new Float: player_AC_Pos_X [ MAX_PLAYERS ] ;
new Float: player_AC_Pos_Y [ MAX_PLAYERS ] ;
new Float: player_AC_Pos_Z [ MAX_PLAYERS ] ;

Safe_SetPlayerPos(playerid, Float: x, Float: y, Float: z ) {

	player_AC_Pos_X [ playerid ] = x ;
	player_AC_Pos_Y [ playerid ] = y ;
	player_AC_Pos_Z [ playerid ] = z ;


	SetPlayerPos(playerid, Float: x, Float: y, Float: z);
	return true ;
}

ac_SetPlayerPos(playerid, Float: x, Float: y, Float: z, fadein = 1, streamin = 1) {
	
	player_AC_Pos_X [ playerid ] = x ;
	player_AC_Pos_Y [ playerid ] = y ;
	player_AC_Pos_Z [ playerid ] = z ;

	if ( fadein ) {
		BlackScreen ( playerid ) ;
		SetPlayerPos(playerid, Float: x, Float: y, Float: z);
		FadeIn ( playerid ) ;
	}

	else if ( ! fadein ) {
		
		SetPlayerPos(playerid, Float: x, Float: y, Float: z);
	}

	if ( streamin ) {
		SetTimerEx("UpdateStreamer", 750, false, "i", playerid);
	}

	return true ;
}

forward UpdateStreamer(playerid);
public UpdateStreamer(playerid) {

	return Streamer_Update(playerid);
}

ptask PlayerAntiCheat[750](playerid){ //350

////	print("PlayerAntiCheat zamanlayýcýsý çaðrýldý (anticheat/core.pwn)");

	if ( IsPlayerSpawned ( playerid ) && ! IsPlayerPaused ( playerid ) ) {

		if ( Character [ playerid ] [ character_level ] < 1 && Character [ playerid ] [ character_level ] < 3 ) {
		
			if ( GetPlayerWeapon ( playerid ) && GetPlayerWeapon ( playerid ) != Character [ playerid ] [ character_handweapon ]) {

				SendModeratorWarning ( sprintf("[SÝLAH] (%d) %s 3. seviyenin altýnda ama bir silahý var. (istemci silahý sunucu silahýyla uyuþmuyor)", playerid, ReturnUserName ( playerid ) ), MOD_WARNING_HIGH );

			}

		}

		new query[180] ;

		if ( ! IsPlayerLogged [ playerid ] && !LogoutPermission [ playerid ] ) {

			WriteLog ( playerid, "epp", sprintf("(%d) %s giriþ yapmadan doðdu", playerid, ReturnUserName ( playerid ) )) ;
			SendModeratorWarning ( sprintf("[EPP] (%d) %s giriþ yapmadan doðdu. Atýlmasý gerekiyor. Atýlmazsa siz atýn.", playerid, ReturnUserName ( playerid ) ), MOD_WARNING_HIGH );

			KickPlayer ( playerid ) ;
		}

		if ( GetPlayerSpeed ( playerid ) > 600 ) {

			if ( IsPlayerModerator ( playerid ) ) {

				return false ;
			}

			WriteLog ( playerid, "anticheat", sprintf("(%d) %s hýz hilesi yüzünden atýldý - IP'sini hemen yasaklayýn", playerid, ReturnUserName ( playerid ) )) ;
			SendClientMessageToAll ( COLOR_STAFF, sprintf("[HÝLE KORUMASI] (%d) %s hýz hilesi yüzünden atýldý.", playerid, ReturnUserName ( playerid ) )) ;

			KickPlayer ( playerid ) ;
		}

		if ( Character [ playerid ] [ character_handweapon ] == UNKNOWN_WEAPON ) {

			RemovePlayerWeapon ( playerid ) ;
			Character [ playerid ] [ character_handweapon ] = WEAPON_FIST ;
			Character [ playerid ] [ character_handammo ] = 0 ;

			SendServerMessage ( playerid, "Silahýnýz iþlenirken bir sorun oluþtu. Sýfýrlandý. Eðer bir hata yüzünden kaybettiyseniz, geri iade konusu açýn.", MSG_TYPE_ERROR ) ;
		}

		if ( GetPlayerMoney ( playerid ) != Character [ playerid ] [ character_handmoney ] ) {

			ResetPlayerMoney ( playerid ) ;
			GivePlayerMoney(playerid, Character [ playerid ] [ character_handmoney ] ) ;

			if ( ++ player_ACTick_Money [ playerid ] > MAX_ANTICHEAT_WARNINGS ) {

				if ( GetPlayerMoney ( playerid ) == Character [ playerid ] [ character_handmoney ] ) {

					return false ;
				}

				player_ACTick_Money [ playerid ] = 0 ;
	    		SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s para hilesi yapýyor olabilir! Ýstemci para: %d, sunucu para: %d", playerid, ReturnUserName ( playerid, true ), GetPlayerMoney(playerid), Character [ playerid ] [ character_handmoney ]), MOD_WARNING_HIGH );
			}
		}

		// Eðer mühimmat sýfýrsa, bu fonksiyonu çaðýrmaz. Hileciler için bir açýk olabilir, belki de olmaz.
		if ( GetPlayerWeapon ( playerid ) != Character [ playerid ] [ character_handweapon ] && GetPlayerWeapon ( playerid ) != WEAPON_FIST ) {
			new WEAPON: pl_weapon = Character [ playerid ] [ character_handweapon ], pl_ammo = Character [ playerid ] [ character_handammo ] ;

			RemovePlayerWeapon ( playerid ) ;
			wep_GivePlayerWeapon ( playerid, pl_weapon, pl_ammo ) ;

			if ( ++ player_ACTick_Weapon [ playerid ] > MAX_ANTICHEAT_WARNINGS ) {

				player_ACTick_Weapon [ playerid ] = 0 ;
	    		SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s silah hilesi yapýyor olabilir! Ýstemci silah: %d, sunucu silah: %d", playerid, ReturnUserName ( playerid, true ), GetPlayerWeapon(playerid), Character [ playerid ] [ character_handweapon ]), MOD_WARNING_HIGH );
			}

			CheckPlayerHackedWeapons ( playerid, GetPlayerWeapon ( playerid ) ) ;
		}

		if ( GetPlayerAmmo ( playerid ) > Character [ playerid ] [ character_handammo ] ) {
			SetPlayerAmmo ( playerid, Character [ playerid ] [ character_handweapon ],Character [ playerid ] [ character_handammo ] );
			
			if ( GetPlayerAmmo ( playerid ) > 150 ) {

				SendSplitMessageToAll ( MANAGER_COLOR, sprintf("[HÝLE KORUMASI] %s (%d) mermi hilesi yüzünden yasaklandý", ReturnUserName ( playerid, true ), playerid )) ;

			    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES ('%d', '%s', 'Hile Korumasý', 'Mermi hilesi', %d, %d)",
				Account [ playerid ] [ account_id ], ReturnIP ( playerid ), gettime(), 9000 * 999);

				mysql_tquery(mysql, query);

				BanEx(playerid, sprintf("Mermi hilesi: hile korumasý tespiti, istemci: %d, sunucu: %d", GetPlayerAmmo ( playerid ), Character [ playerid ] [ character_handammo ] ) ) ;
			}
		}


		new Float: armour ;
		GetPlayerArmour ( playerid, armour ) ;

		if ( armour > 1 ) {
		    
			SendSplitMessageToAll ( MANAGER_COLOR, sprintf("[HÝLE KORUMASI] %s (%d) zýrh hilesi yüzünden yasaklandý", ReturnUserName ( playerid, true ), playerid )) ;

		    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES ('%d', '%s', 'Hile Korumasý', 'Zýrh hilesi', %d, %d)",
			Account [ playerid ] [ account_id ], ReturnIP ( playerid ), gettime(), 9000 * 999);

			mysql_tquery(mysql, query);

			BanEx(playerid, "Zýrh hilesi: hile korumasý tespiti" ) ;
		}

		if ( GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK ) {

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE) ;

			SendSplitMessageToAll ( MANAGER_COLOR, sprintf("[HÝLE KORUMASI] %s (%d) jetpack hilesi yüzünden yasaklandý", ReturnUserName ( playerid, true ), playerid )) ;

		    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES ('%d', '%s', 'Hile Korumasý', 'Jetpack hilesi', %d, %d)",
			Account [ playerid ] [ account_id ], ReturnIP ( playerid ), gettime(), 9000 * 999);

			mysql_tquery(mysql, query);

			BanEx(playerid, "Jetpack hilesi: hile korumasý tespiti" ) ;
		}

		new Float: pos_x, Float: pos_y, Float: pos_z, Float: height ;
		GetPlayerPos ( playerid, pos_x, pos_y, pos_z ) ;
		CA_FindZ_For2DCoord ( pos_x, pos_y, height ) ;

		if ( pos_z > height + 5 ) {

			// Bayside uçma hilesi hatasý düzeltiliyor
			if ( GetPlayerZone ( playerid ) == 0 && pos_z <= 6 ) {

				return false ;
			}

			if ( ++ player_ACTick_Fly [ playerid ] > MAX_ANTICHEAT_WARNINGS && GetPlayerInterior ( playerid ) == 0 && GetPlayerVirtualWorld ( playerid ) == 0) {

				player_ACTick_Fly [ playerid ] = 0 ;
	   			SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s uçma hilesi yapýyor olabilir! ZEMÝN: %.2f, OYUNCU YÜKSEKLÝÐÝ: %.2f", playerid, ReturnUserName ( playerid, true ), pos_x, height ), MOD_WARNING_HIGH);
	   		}
		}

		// Eskiden maks 325 idi.
		if ( ! IsPlayerRidingHorse [ playerid ] ) {

			if ( GetPlayerSpeed ( playerid ) > 175 ) {

				if ( ++ player_ACTick_Speed [ playerid ] > MAX_ANTICHEAT_WARNINGS ) {

					player_ACTick_Speed [ playerid ] = 0 ;
		   			SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s hýz hilesi yapýyor olabilir! NORMAL HIZ: 175, SAHÝP OLDUÐU HIZ: %.2f", playerid, ReturnUserName ( playerid, true ), GetPlayerSpeed ( playerid ) ), MOD_WARNING_HIGH);
		   		}
			}
		}
		
		else {

			if ( Character [ playerid ] [ character_horseid ] == 3 ) {

				if ( GetPlayerSpeed ( playerid ) > 181 ) {

					if ( ++ player_ACTick_Speed [ playerid ] > MAX_ANTICHEAT_WARNINGS ) {

						player_ACTick_Speed [ playerid ] = 0 ;
			   			SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s hýz hilesi yapýyor olabilir! (At Üstünde) NORMAL HIZ: 181, SAHÝP OLDUÐU HIZ: %.2f", playerid, ReturnUserName ( playerid, true ), GetPlayerSpeed ( playerid ) ), MOD_WARNING_HIGH);
			   		}
		   		}
			}

			else if ( Character [ playerid ] [ character_horseid ] == 4 ) {

				if ( GetPlayerSpeed ( playerid ) > 203 ) {

					if ( ++ player_ACTick_Speed [ playerid ] > MAX_ANTICHEAT_WARNINGS ) {

						player_ACTick_Speed [ playerid ] = 0 ;
			   			SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s hýz hilesi yapýyor olabilir! (At Üstünde) NORMAL HIZ: 203, SAHÝP OLDUÐU HIZ: %.2f", playerid, ReturnUserName ( playerid, true ), GetPlayerSpeed ( playerid ) ), MOD_WARNING_HIGH);
			   		}
		   		}
			}

			else if ( Character [ playerid ] [ character_horseid ] == 5 ) {

				if ( GetPlayerSpeed ( playerid ) > 227 ) {

					if ( ++ player_ACTick_Speed [ playerid ] > MAX_ANTICHEAT_WARNINGS ) {

						player_ACTick_Speed [ playerid ] = 0 ;
			   			SendModeratorWarning ( sprintf("[HÝLE KORUMASI] (%d) %s hýz hilesi yapýyor olabilir! (At Üstünde) NORMAL HIZ: 227, SAHÝP OLDUÐU HIZ: %.2f", playerid, ReturnUserName ( playerid, true ), GetPlayerSpeed ( playerid ) ), MOD_WARNING_HIGH);
			   		}
		   		}
			}
		}
	}

	return true ;
}


CheckPlayerHackedWeapons ( playerid, weaponid ) {
	new query [ 512 ] ;

	if ( playerid == INVALID_PLAYER_ID ) {

		return false ;
	}

	for ( new i; i < sizeof ( disallowed_weapons); i ++ ) {
		if ( weaponid == disallowed_weapons [ i ] ) {

			SendSplitMessageToAll ( MANAGER_COLOR, sprintf("[HÝLE KORUMASI] %s (%d) silah hilesi yüzünden yasaklandý", ReturnUserName ( playerid, true ), playerid )) ;

		    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES ('%d', '%s', 'Hile Korumasý', 'Silah hilesi', %d, %d)",
			Account [ playerid ] [ account_id ], ReturnIP ( playerid ), gettime(), 9000 * 999);

			mysql_tquery(mysql, query);

			BanEx(playerid, "Silah hilesi: hile korumasý tespiti" ) ;
		}
	}

	return true ;
}

/*
public OnPlayerSuspectedForAimbot ( playerid, hitid, weaponid, warnings ) {

	new Float: Wstats [ BUSTAIM_WSTATS_SHOTS ] ;
	
	player_ACTick_AimbotIncr [ playerid ] ++;

	if ( warnings & WARNING_OUT_OF_RANGE_SHOT ) {

		SendModeratorWarning ( sprintf("[HÝLE KORUMASI] [Uyarý %d] %s (%d), %s silahýnýn menzilinden daha uzak bir mesafeden ateþ etti (Normal Menzil: %f)", player_ACTick_AimbotIncr [ playerid ], ReturnUserName ( playerid, true ), playerid,ReturnWeaponName ( GetPlayerWeapon ( playerid ) ), BustAim::GetNormalWeaponRange(weaponid)));

		BustAim::GetRangeStats ( playerid, Wstats ) ;

		SendModeratorWarning ( sprintf("[HÝLE KORUMASI] Atýcýdan Kurbana Mesafe (SA Birimi): 1) %.3f 2) %.3f 3) %.3f", Wstats[0], Wstats[1], Wstats[2] )) ;
	}

	if ( warnings & WARNING_PROAIM_TELEPORT ) {

	   	SendModeratorWarning ( sprintf("[HÝLE KORUMASI] [Uyarý %d] %s (%d) proaim kullanýyor (Iþýnlanma Tespit Edildi)", player_ACTick_AimbotIncr [ playerid ], ReturnUserName ( playerid, true ), playerid )) ;

		BustAim::GetTeleportStats ( playerid, Wstats ) ;

		SendModeratorWarning ( sprintf("Mermiden Kurbana Mesafe (SA Birimi): 1) %.3f 2) %.3f 3) %.3f", Wstats[0], Wstats[1], Wstats[2] )) ;
	}

	if ( warnings & WARNING_RANDOM_AIM ) {

	    SendModeratorWarning ( sprintf("[HÝLE KORUMASI] [Uyarý %d] %s (%d) oyuncusunun aimbot kullandýðýndan þüpheleniliyor (%s ile Rastgele Niþan ile vurdu)", player_ACTick_AimbotIncr [ playerid ], ReturnUserName ( playerid, true ), playerid, ReturnWeaponName ( GetPlayerWeapon ( playerid ) ) )) ;

		BustAim::GetRandomAimStats(playerid,Wstats);

		SendModeratorWarning ( sprintf("[HÝLE KORUMASI] Rastgele Niþan Sapmalarý: 1) %.3f 2) %.3f 3) %.3f", Wstats[0], Wstats[1], Wstats[2] )) ;
	}

	if ( warnings & WARNING_CONTINOUS_SHOTS ) {

	   	SendModeratorWarning ( sprintf("[HÝLE KORUMASI] [Uyarý %d] %s (%d), %s (%d) silahý ile art arda 10 el ateþ etti", player_ACTick_AimbotIncr [ playerid ], ReturnUserName ( playerid, true ), playerid, ReturnWeaponName ( GetPlayerWeapon ( playerid ) ), weaponid ));
	}

	return 0;
}*/
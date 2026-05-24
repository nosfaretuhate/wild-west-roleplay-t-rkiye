#define MAX_STORED_WEAPONS	( 3 )

CMD:passgun ( playerid, params [] ) {
	if ( ! Character [ playerid ] [ character_handweapon ] ) {

		return SendServerMessage ( playerid, "Elinde devredebileceðin bir silah yok!", MSG_TYPE_ERROR ) ;
	}

	if ( EquippedItem [ playerid ] != -1 ) {

		return SendServerMessage ( playerid, "Kuþandýðýn bir envanter eþyasý varken bunu yapamazsýn. Önce eþyayý çýkarmalýsýn.", MSG_TYPE_ERROR ) ;
	}

	new target ;

	if ( sscanf ( params, "k<u>", target ) ) {

		return SendServerMessage ( playerid, "/passgun [hedefid]", MSG_TYPE_ERROR ) ;
	}

	if ( target == INVALID_PLAYER_ID ) {

		return SendServerMessage ( playerid, "Böyle bir oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
	}

	if ( Character [ target ] [ character_level ] < 3) {

		return SendServerMessage ( playerid, "Hedefin seviyesi çok düþük. En az 3 olmalý.", MSG_TYPE_ERROR ) ;
	}

	if (  Character [ target ] [ character_handweapon ] ) {

		return SendServerMessage ( playerid, "Hedefin zaten bir silah tutuyor!", MSG_TYPE_ERROR ) ;
	}

	if (EquippedItem [ target ] != -1 ) {

		return SendServerMessage ( playerid, "Hedefin zaten bir þey kuþanmýþ. Ona çýkarmasýný söyle.", MSG_TYPE_ERROR ) ;
	}

	if ( IsPlayerRidingHorse [ target ] ) {

		return SendServerMessage ( playerid, "Hedefin bir ata biniyor. Önce inmesini söyle.", MSG_TYPE_ERROR ) ;
	}

 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

	    return SendServerMessage(playerid, "O oyuncunun yakýnýnda deðilsin.", MSG_TYPE_ERROR);
    }

    // Kötüye kullanýmý önlemek için sadece oyuncuya yakýnlarsa animasyonu oynat
    if ( IsPlayerNearPlayer ( playerid, target, 2.0 ) ) {
		SetPlayerToFacePlayer(target, playerid);
		SetPlayerToFacePlayer(playerid, target);

		ApplyAnimation(target, "GANGS", "prtial_hndshk_biz_01", 4.0, false, false, false, false, 0, SYNC_ALL);
		ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, false, false, false, false, 0, SYNC_ALL);
	}

	new WEAPON: passedgun, passedammo ;

	passedgun = Character [ playerid ] [ character_handweapon ] ;
	passedammo = Character [ playerid ] [ character_handammo ] ;

	RemovePlayerWeapon ( playerid ) ;
	wep_GivePlayerWeapon ( target, passedgun, passedammo ) ;

	ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s silahýný %s adlý oyuncuya verdi.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( passedgun ), ReturnUserName ( target, false, true )) ) ;

	new deter [ 64 ] ;

	if ( GetPosseType ( Character [ playerid ] [ character_posse ] ) == 1 || GetPosseType ( Character [ playerid ] [ character_posse ] ) == 2 ) {

		SendModeratorWarning ( sprintf ( "[ÞERÝF] %s, %s silahýný %d mermiyle %s adlý oyuncuya verdi.", ReturnUserName ( playerid, false ), ReturnWeaponName (passedgun ), passedammo, ReturnUserName ( target, true ) ), MOD_WARNING_HIGH ) ;

		strins(deter, "[ÞERÝF]", 0 ) ;
	}

	if ( DoesPlayerHaveItem ( playerid, CARD_GUNPERMIT ) != -1 ) {

		strins(deter, "[RUHSAT] ", 0 ) ;
	}

	WriteLog ( playerid, "guns/pass", sprintf ( "%s %s, %s silahýný %d mermiyle %s adlý oyuncuya verdi.", deter, ReturnUserName ( playerid, false ), ReturnWeaponName (passedgun ), passedammo, ReturnUserName ( target, true ) )) ;

	new query [ 256 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), 
		"UPDATE characters SET character_handweapon = %d, character_handammo = %d WHERE character_id = %d", 
		Character [ playerid ] [ character_handweapon ], Character [ playerid ] [ character_handammo ], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"UPDATE characters SET character_handweapon = %d, character_handammo = %d WHERE character_id = %d", 
		Character [ target ] [ character_handweapon ], Character [ target ] [ character_handammo ], Character [ target ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	SavePlayerWeapons ( playerid ) ;
	SavePlayerWeapons ( target ) ;

	return true ;
}

CMD:switchgun ( playerid, params [] ) {

	if ( ! Character [ playerid ] [ character_handweapon ] ) {

		return SendServerMessage ( playerid, "Deðiþtirebileceðin bir silah tutmuyorsun!", MSG_TYPE_ERROR ) ;
	}

	if ( EquippedItem [ playerid ] != -1 ) {

		return SendServerMessage ( playerid, "Kuþandýðýn bir envanter eþyasý varken bunu yapamazsýn. Önce eþyayý çýkarmalýsýn.", MSG_TYPE_ERROR ) ;
	}

	if (EquippedItem [ playerid ] != -1 ) {

		return SendServerMessage ( playerid, "Zaten bir þey kuþanmýþsýn. Önce onu çýkar.", MSG_TYPE_ERROR ) ;
	}

	if ( IsPlayerRidingHorse [ playerid ] ) {

		return SendServerMessage ( playerid, "Ata biniyorsun. Önce inmelisin.", MSG_TYPE_ERROR ) ;
	}

	new WEAPON: storedGun, storedAmmo;

	if ( ! strcmp(params, "trousers", true ) ) { // yuva 0

		if ( ! Character [ playerid ] [ character_pantsweapon ]) {

			return SendServerMessage ( playerid, "Pantolonunda saklý bir silah yok!", MSG_TYPE_WARN ) ;
		}

		storedGun = Character [ playerid ] [ character_handweapon ] ;
		storedAmmo = Character [ playerid ] [ character_handammo ] ;

		RemovePlayerWeapon ( playerid ) ;

		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s silahýný pantolonundaki %s ile deðiþtirdi.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( storedGun ), ReturnWeaponName ( Character [ playerid ] [ character_pantsweapon ] ) ) ) ;
		
		wep_GivePlayerWeapon ( playerid, Character [ playerid ] [ character_pantsweapon ] , Character [ playerid ] [ character_pantsammo ]  ) ;

		Character [ playerid ] [ character_pantsweapon ] = storedGun ;
		Character [ playerid ] [ character_pantsammo ] = storedAmmo ;
	}

	else if ( ! strcmp(params, "back", true ) ) { // yuva 1

		if ( ! Character [ playerid ] [ character_backweapon ] ) {

			return SendServerMessage ( playerid, "Sýrtýnda saklý bir silah yok!", MSG_TYPE_WARN ) ;
		}

		storedGun = Character [ playerid ] [ character_handweapon ] ;
		storedAmmo = Character [ playerid ] [ character_handammo ] ;

		RemovePlayerWeapon ( playerid ) ;

		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s silahýný sýrtýndaki %s ile deðiþtirdi.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( storedGun ), ReturnWeaponName ( Character [ playerid ] [ character_backweapon ] ) ) ) ;
		
		wep_GivePlayerWeapon ( playerid, Character [ playerid ] [ character_backweapon ], Character [ playerid ] [ character_backammo ]  ) ;	

		Character [ playerid ] [ character_backweapon ] = storedGun ;
		Character [ playerid ] [ character_backammo ] = storedAmmo ;	
	}

	else return SendServerMessage ( playerid, "/switchgun [trousers | back]", MSG_TYPE_ERROR ) ;

	SavePlayerWeapons ( playerid ) ;

	return true ;
}

CMD:sgun ( playerid, params [] ) {

	return cmd_switchgun ( playerid, params ) ;
}

CMD:holstered ( playerid ) {

	SendClientMessage (playerid, COLOR_TAB0, "|_____________________| Kýlýftaki silahlarýnýn listesi |_____________________| " ) ;


	if ( Character [ playerid ] [ character_handweapon ] ) {
		SendClientMessage(playerid, COLOR_TAB1, sprintf("[KUÞANILAN]{DEDEDE} %s (%d)", ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ), Character [ playerid ] [ character_handammo ] ));
	}

	else SendClientMessage(playerid, COLOR_TAB1, "[KUÞANILAN]{DEDEDE} Boþ" ) ;



	if ( Character [ playerid ] [ character_pantsweapon ] ) {
		SendClientMessage(playerid, COLOR_TAB1, sprintf("[PANTOLON]{DEDEDE} %s (%d)", ReturnWeaponName ( Character [ playerid ] [ character_pantsweapon ] ), Character [ playerid ] [ character_pantsammo ] ));
	}

	else SendClientMessage(playerid, COLOR_TAB1, "[PANTOLON]{DEDEDE} Boþ" ) ;



	if ( Character [ playerid ] [ character_backweapon ] ) {
		SendClientMessage(playerid, COLOR_TAB2, sprintf("[SIRT]{DEDEDE} %s (%d)", ReturnWeaponName ( Character [ playerid ] [ character_backweapon ] ), Character [ playerid ] [ character_backammo ] ));
	}

	else SendClientMessage(playerid, COLOR_TAB2, "[SIRT]{DEDEDE} Boþ" ) ;

	return true ;
}

CMD:gunpos ( playerid, params [] ) {

	if ( ! strcmp(params, "trousers", true ) ) { // yuva 0

		if ( ! Character [ playerid ] [ character_pantsweapon ]) {

			return SendServerMessage ( playerid, "Pantolonunda saklý bir silah yok!", MSG_TYPE_WARN ) ;
		}

		EditAttachedObject(playerid, ATTACH_SLOT_PANTS   ) ;
	}

	else if ( ! strcmp(params, "back", true ) ) { // yuva 1

		if ( ! Character [ playerid ] [ character_backweapon ] ) {

			return SendServerMessage ( playerid, "Sýrtýnda saklý bir silah yok!", MSG_TYPE_WARN ) ;
		}

		EditAttachedObject(playerid, ATTACH_SLOT_BACK  ) ;
	}

	else return SendServerMessage ( playerid, "/gunpos [trousers(kýlýfýna), back(sýrtýna)]", MSG_TYPE_ERROR ) ;


	return true ;
}

CMD:guns ( playerid, params [] ) {

	return cmd_holstered ( playerid ) ;
}

CMD:unholster ( playerid, const params [] ) {

	if ( Character [ playerid ] [ character_handweapon ] ) {

		return SendServerMessage ( playerid, "Zaten bir silah tutuyorsun. Önce /holster kullanarak kýlýfýna koy!", MSG_TYPE_ERROR ) ;
	}

	if ( EquippedItem [ playerid ] != -1 ) {

		return SendServerMessage ( playerid, "Kuþandýðýn bir envanter eþyasý varken bunu yapamazsýn. Önce eþyayý çýkarmalýsýn.", MSG_TYPE_ERROR ) ;
	}

	if (EquippedItem [ playerid ] != -1 ) {

		return SendServerMessage ( playerid, "Zaten bir þey kuþanmýþsýn. Önce onu çýkar.", MSG_TYPE_ERROR ) ;
	}

	if ( IsPlayerRidingHorse [ playerid ] ) {

		return SendServerMessage ( playerid, "Ata biniyorsun. Önce inmelisin.", MSG_TYPE_ERROR ) ;
	}


	printf("unholster çaðrýldý: %d, %d", Character [ playerid ] [ character_handweapon], Character [ playerid ] [ character_handammo] ) ;

	if ( ! strcmp(params, "trousers", true ) ) { // yuva 0

		if ( ! Character [ playerid ] [ character_pantsweapon ]) {

			return SendServerMessage ( playerid, "Pantolonunda saklý bir silah yok!", MSG_TYPE_WARN ) ;
		}

		wep_GivePlayerWeapon ( playerid, Character [ playerid ] [ character_pantsweapon ] , Character [ playerid ] [ character_pantsammo ]  ) ;
		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, pantolonundan %s silahýný çýkardý.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ) ) ) ;

		Character [ playerid ] [ character_pantsweapon ] = WEAPON_FIST ;
		Character [ playerid ] [ character_pantsammo ] = 0 ;
	}

	else if ( ! strcmp(params, "back", true ) ) { // yuva 1

		if ( ! Character [ playerid ] [ character_backweapon ] ) {

			return SendServerMessage ( playerid, "Sýrtýnda saklý bir silah yok!", MSG_TYPE_WARN ) ;
		}

		wep_GivePlayerWeapon ( playerid, Character [ playerid ] [ character_backweapon ], Character [ playerid ] [ character_backammo ]  ) ;
		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, sýrtýndan %s silahýný çýkardý.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ) ) ) ;

		Character [ playerid ] [ character_backweapon ] = WEAPON_FIST ;
		Character [ playerid ] [ character_backammo ] = 0 ;
	}

	else return SendServerMessage ( playerid, "/unholster [trousers(kýlýfýna) | back(sýrtýna)]", MSG_TYPE_ERROR ) ;

	SavePlayerWeapons ( playerid ) ;

	return true ;
}

CMD:guh(playerid, params [] ) {

	return cmd_unholster ( playerid, params ) ;
}

CMD:holster ( playerid, const params [] ) {

	if ( ! Character [ playerid ] [ character_handweapon ]) {

		return SendServerMessage ( playerid, "Saklayacak bir silahýn yok!", MSG_TYPE_ERROR ) ;
	}

	if ( IsPlayerRidingHorse [ playerid ] ) {

		return SendServerMessage ( playerid, "Ata biniyorsun. Önce inmelisin.", MSG_TYPE_ERROR ) ;
	}

	if ( EquippedItem [ playerid ] != -1 ) {

		return SendServerMessage ( playerid, "Kuþandýðýn bir envanter eþyasý varken bunu yapamazsýn. Önce eþyayý çýkarmalýsýn.", MSG_TYPE_ERROR ) ;
	}
	
	if ( ! strcmp(params, "trousers", true ) ) { // yuva 0

		if ( Character [ playerid ] [ character_handweapon ] != WEAPON_DEAGLE && Character [ playerid ] [ character_handweapon ] != WEAPON_KNIFE) {

			return SendServerMessage ( playerid, "Pantolonuna sadece tabanca veya býçak koyabilirsin!", MSG_TYPE_ERROR ) ;
		}

		if ( Character [ playerid ] [ character_pantsweapon ] ) {

			return SendServerMessage ( playerid, "Bu yuvada zaten bir silah var! /holstered komutuyla kontrol edebilirsin.", MSG_TYPE_WARN ) ;
		}

		Character [ playerid ] [ character_pantsweapon ] 		= Character [ playerid ] [ character_handweapon ] ;
		Character [ playerid ] [ character_pantsammo ] 			= Character [ playerid ] [ character_handammo] ;

		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s silahýný pantolonuna koydu.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ) ) ) ;

		RemovePlayerWeapon ( playerid ) ;
		
		Character [ playerid ] [ character_handammo ] = 0 ;
	}

	else if ( ! strcmp(params, "back", true ) ) { // yuva 1

		if ( Character [ playerid ] [ character_backweapon ] ) {

			return SendServerMessage ( playerid, "Bu yuvada zaten bir silah var! /holstered komutuyla kontrol edebilirsin.", MSG_TYPE_WARN ) ;
		}

		Character [ playerid ] [ character_backweapon ] 	= Character [ playerid ] [ character_handweapon ] ;
		Character [ playerid ] [ character_backammo ] 		= Character [ playerid ] [ character_handammo ] ; 

		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s silahýný sýrtýna astý.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ) ) ) ;
		
		RemovePlayerWeapon ( playerid ) ;
		
		Character [ playerid ] [ character_handammo ] = 0 ;
	}

	else return SendServerMessage ( playerid, "/holster [trousers(kýlýf) | back(sýrta)]", MSG_TYPE_ERROR ) ;

	SavePlayerWeapons ( playerid ) ;

	return true ;
}

CMD:gh(playerid, params [] ) {

	return cmd_holster ( playerid, params ) ;
}
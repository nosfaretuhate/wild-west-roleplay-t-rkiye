CMD:saddlebag(playerid, params[]) {

    if ( IsPlayerRidingHorse [ playerid ] ) {

        return SendServerMessage(playerid, "Atýnýzýn yakýnýnda deðilsiniz!", MSG_TYPE_ERROR );
    }

    new Float: x, Float: y, Float: z, query[512], option [ 32 ], slot ;
    GetDynamicObjectPos ( HorseObject [ playerid ], x, y, z ) ;

    if ( ! IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z ) ) {

        return SendServerMessage(playerid, "Atýnýzýn yakýnýnda deðilsiniz.", MSG_TYPE_ERROR ) ;
    }

    if ( sscanf ( params, "s[32]I(0)", option, slot ) ) {

        return SendServerMessage ( playerid, "/s(addle)b(ags) [info(bilgi)/store(depola)/take(al)]", MSG_TYPE_ERROR);
    }

    if ( !strcmp(option, "info", true ) ) {

        SendClientMessage(playerid, COLOR_TAB0, "|_______________| At Eþyalarý |_______________|");

        if ( PlayerSaddleBagWeapon [ playerid ] [ 0 ] ) {
            SendClientMessage ( playerid, COLOR_TAB1, sprintf("[SLOT 1]: %s, %d mermi ile", 
                ReturnWeaponName(PlayerSaddleBagWeapon [ playerid ] [ 0 ] ), PlayerSaddleBagAmmo [ playerid ] [ 0 ] )) ;
        }

        else SendClientMessage(playerid, COLOR_TAB1, "[SLOT 1]: Boþ");

        if ( PlayerSaddleBagWeapon [ playerid ] [ 1 ] ) {
            SendClientMessage ( playerid, COLOR_TAB2, sprintf("[SLOT 2]: %s, %d mermi ile", 
                ReturnWeaponName(PlayerSaddleBagWeapon [ playerid ] [ 1 ] ), PlayerSaddleBagAmmo [ playerid ] [ 1 ] )) ;
        }

        else SendClientMessage(playerid, COLOR_TAB2, "[SLOT 2]: Boþ");        

        return true ; 
    }

    else if ( !strcmp(option, "store", true ) ) {

        if ( ! Character [ playerid ] [ character_handweapon ] ) {

            return SendServerMessage(playerid, "Bunun için bir silah kuþanmýþ olmanýz gerekiyor.", MSG_TYPE_ERROR ) ;
        }

        if ( ! slot || slot > 2 ) {

            return SendServerMessage ( playerid, "/s(addle)b(ags) store [slot: 1 veya 2]", MSG_TYPE_ERROR ) ;
        }

        switch ( slot ) {

            case 1: {

                PlayerSaddleBagWeapon [ playerid ] [ 0 ]    = Character [ playerid ] [ character_handweapon ] ;
                PlayerSaddleBagAmmo [ playerid ] [ 0 ]      = Character [ playerid ] [ character_handammo ] ;
            }

            case 2: {

                PlayerSaddleBagWeapon [ playerid ] [ 1 ]    = Character [ playerid ] [ character_handweapon ] ;
                PlayerSaddleBagAmmo [ playerid ] [ 1 ]      = Character [ playerid ] [ character_handammo ] ;
            }
        }

        ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s silahýný atýna yerleþtiriyor.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ) ) ) ;

        WriteLog ( playerid, "saddlebag", sprintf ( "[STORE] %s, (%d) %s silahýný %d mermi ile heybeye koydu, slot %d", 
            ReturnUserName ( playerid, true, false ), Character [ playerid ] [ character_handweapon ], ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ), Character [ playerid ] [ character_handammo ], slot)) ;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_sb_gun0 = %d, character_sb_gun1 = %d, character_sb_ammo0 = %d, character_sb_ammo1 = %d WHERE character_id=%d",
            PlayerSaddleBagWeapon [ playerid ] [ 0 ] , PlayerSaddleBagWeapon [ playerid ] [ 1 ] , PlayerSaddleBagAmmo [ playerid ] [ 0 ], PlayerSaddleBagAmmo [ playerid ] [ 1 ], Character [ playerid ] [ character_id ] ) ;
    
        mysql_tquery ( mysql, query ) ;

        RemovePlayerWeapon(playerid)  ;

        return true ;
    }

    else if ( !strcmp(option, "take", true ) ) {

        if ( Character [ playerid ] [ character_handweapon ] ) {

            return SendServerMessage(playerid, "Zaten bir silah kuþanmýþ durumdasýnýz.", MSG_TYPE_ERROR ) ;
        }

        if ( EquippedItem[playerid] != -1) {

            return SendServerMessage(playerid, "Önce kuþanmýþ olduðunuz eþyayý býrakmalýsýnýz.",MSG_TYPE_ERROR);
        }

        if ( ! slot || slot > 2 ) {

            return SendServerMessage ( playerid, "/s(addle)b(ags) store [slot: 1 veya 2]", MSG_TYPE_ERROR ) ;
        }

        if ( slot && ! PlayerSaddleBagWeapon [ playerid ] [ 0 ] ) {

            return SendServerMessage ( playerid, "Bu slotta saklanan bir silahýnýz yok!",MSG_TYPE_ERROR);
        }

        if ( slot == 2 && ! PlayerSaddleBagWeapon [ playerid ] [ 1 ] ) {

            return SendServerMessage ( playerid, "Bu slotta saklanan bir silahýnýz yok!",MSG_TYPE_ERROR);
        }

        switch ( slot ) {
            case 1: {

                wep_GivePlayerWeapon ( playerid, PlayerSaddleBagWeapon [ playerid ] [ 0 ], PlayerSaddleBagAmmo [ playerid ] [ 0 ] ) ;
                ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, atýndan bir %s alýyor.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( PlayerSaddleBagWeapon [ playerid ] [ 0 ]) ) ) ;
        
                PlayerSaddleBagWeapon [ playerid ] [ 0 ] = WEAPON_FIST ;
                PlayerSaddleBagAmmo [ playerid ] [ 0 ] = 0 ;
            }
            case 2: {
                wep_GivePlayerWeapon ( playerid, PlayerSaddleBagWeapon [ playerid ] [ 1 ], PlayerSaddleBagAmmo [ playerid ] [ 1 ] ) ;
                ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, atýndan bir %s alýyor.", ReturnUserName ( playerid, false, true ), ReturnWeaponName ( PlayerSaddleBagWeapon [ playerid ] [ 1 ]) ) ) ;

                PlayerSaddleBagWeapon [ playerid ] [ 1 ] = WEAPON_FIST ;
                PlayerSaddleBagAmmo [ playerid ] [ 1 ] = 0 ;
            }
        }

        WriteLog ( playerid, "saddlebag", sprintf ( "[TAKE] %s, (%d) %s silahýný %d mermi ile heybeden aldý, slot %d", 
            ReturnUserName ( playerid, true, false ), Character [ playerid ] [ character_handweapon ], ReturnWeaponName ( Character [ playerid ] [ character_handweapon ] ), Character [ playerid ] [ character_handammo ], slot )) ;


        mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_sb_gun0 = %d, character_sb_gun1 = %d, character_sb_ammo0 = %d, character_sb_ammo1 = %d WHERE character_id=%d",
        PlayerSaddleBagWeapon [ playerid ] [ 0 ] , PlayerSaddleBagWeapon [ playerid ] [ 1 ] , PlayerSaddleBagAmmo [ playerid ] [ 0 ], PlayerSaddleBagAmmo [ playerid ] [ 1 ], Character [ playerid ] [ character_id ] ) ;
    
        mysql_tquery ( mysql, query ) ;

        return true ;
    }

    return true ;
}

CMD:sb(playerid, params[]) {

    return cmd_saddlebag(playerid, params);
}
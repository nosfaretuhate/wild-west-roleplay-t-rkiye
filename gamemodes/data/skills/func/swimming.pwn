new const Float: ShorePoints [ ] [ ] = {

    { -686.8016,        753.1329,       1.7368 },
    { -703.9090,        716.8571,       4.5989 },
    { -783.2010,        949.5403,       0.8289 },
    { -645.6351,        1339.789,       2.3973 },
    { -1358.520,        1690.508,       1.8135 },
    { -1865.594,        2141.875,       1.1363 },
    { -1398.375,        2132.951,       43.176 },
    { -1181.057,        2676.636,       41.364 },
    { -2310.521,        2517.633,       1.7807 }
} ;

new playerSwimmingTick       [ MAX_PLAYERS ] ;
new playerWarningTick        [ MAX_PLAYERS ] ;
new playerSprintWarningTick [ MAX_PLAYERS ] ;

ptask SwimChecker[1250](playerid) {

    if ( ! IsPlayerSwimming ( playerid ) ) {

        return false ;
    }

    new shoreid ;

    if ( IsPlayerSwimming ( playerid ) ) {

        new KEY: keys, ud, lr;
        GetPlayerKeys(playerid, keys, ud, lr);
 
        if ( keys == KEY_SPRINT ) {

            if ( PlayerSkill [ playerid ] [ MISC_swimming ] < 2 ) {

                if ( playerSprintWarningTick [ playerid ] == 0 ) {

                    SendServerMessage(playerid, "Henüz bu kadar hýzlý yüzemezsin! Ýkinci seviye veya daha yüksek yüzme yeteneðine ihtiyacýn var. (/skills)", MSG_TYPE_ERROR ) ;
                }

                if ( ++ playerSprintWarningTick [ playerid ] > 5 ) {

                    playerSprintWarningTick [ playerid ] = 0 ;
                }

                ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, false, false, false, false, 0);
            }
        }

        if ( ++ playerSwimmingTick [ playerid ] > 30 && PlayerSkill [ playerid ] [ MISC_swimming ] < 1) {

            playerSwimmingTick [ playerid ] = 0 ;

            switch ( random ( 3 ) ) {

                case 0: SendServerMessage ( playerid, "Ayaklarýnýn altýndaki yeri kaybettin ve yavaþça okyanusun derinliklerine süzülüyorsun..", MSG_TYPE_WARN ) ;
                case 1: SendServerMessage ( playerid, "Bacaðýna çok kötü bir kramp girdi. Gözlerin kapanýrken suyun derinliklerine doðru kendini býraktýn..", MSG_TYPE_WARN ) ;
                case 2: SendServerMessage ( playerid, "Yorgunluktan nefes nefese kaldýn. Böyle yüzmeye alýþkýn deðilsin. Her þey yavaþça kararýyor..", MSG_TYPE_WARN ) ;
            }

            shoreid = IsPlayerNearShorePoint ( playerid, 200 ) ;

            if ( shoreid != -1) {

                ac_SetPlayerPos ( playerid, ShorePoints [ shoreid ] [ 0 ], ShorePoints [ shoreid ] [ 1 ], ShorePoints [ shoreid ] [ 2 ] ) ;

                switch ( random ( 6 ) ) {
                    case 0: AnimationLoop(playerid, "CRACK", "crckdeth1", 4.1, false, false, false, true, 0, SYNC_ALL);
                    case 1: AnimationLoop(playerid, "CRACK", "crckdeth2", 4.1, true, false, false, false, 0, SYNC_ALL);
                    case 2: AnimationLoop(playerid, "CRACK", "crckdeth3", 4.1, false, false, false, true, 0, SYNC_ALL);
                    case 3: AnimationLoop(playerid, "CRACK", "crckidle1", 4.1, false, false, false, true, 0, SYNC_ALL);
                    case 4: AnimationLoop(playerid, "CRACK", "crckidle2", 4.1, false, false, false, true, 0, SYNC_ALL);
                    case 5: AnimationLoop(playerid, "CRACK", "crckidle3", 4.1, false, false, false, true, 0, SYNC_ALL);
                }

                new damage = 5 + random  ( 15 ) ;

                Character [ playerid ] [ character_health ] -= float ( damage ) ;
                SetCharacterHealth ( playerid, Character [ playerid ] [ character_health ] ) ;
            }

            else if ( shoreid == -1 ) {

                SendServerMessage ( playerid, "Yakýnlarda kýyý yok. Yavaþça boðulmaya baþlýyorsun.", MSG_TYPE_ERROR ) ;
                SetCharacterHealth ( playerid, -1 ) ;
            }

            return true ;
        }

        if ( PlayerSkill [ playerid ] [ MISC_swimming ] < 1 ) {

            if ( playerWarningTick [ playerid ] == 1 ) {

                SendServerMessage ( playerid, "Düzgün yüzemiyorsun! Boðulmadan önce kýyýya ulaþsan iyi olur. (/skills)", MSG_TYPE_ERROR ) ;
            }

            if ( ++ playerWarningTick [ playerid ] > 15 ) {

                playerWarningTick [ playerid ] = 0 ;
            }   
        }
    }

    else if ( ! IsPlayerSwimming ( playerid ) ) {

        if ( playerWarningTick [ playerid ] ) {

            playerWarningTick [ playerid ] = 0 ;
        }
    }

    return true ;
}

IsPlayerNearShorePoint(playerid, Float:range, point = -1)  { 

    if ( point == -1 ) { 

        for ( new i = 0; i < sizeof ( ShorePoints ); i++ ) { 

            if ( IsPlayerInRangeOfPoint ( playerid, range, ShorePoints [ i ] [ 0 ], ShorePoints [ i ] [ 1 ], ShorePoints [ i ] [ 2 ] ) ) {

                return i ;
            }

            else continue ;
        } 
    } 

    else if ( 0 <= point <= sizeof ( ShorePoints ) ) { 

        return IsPlayerInRangeOfPoint(playerid, range, ShorePoints [ point ] [ 0 ], ShorePoints [ point ] [ 1 ], ShorePoints [ point ] [ 2 ] ) ; 
    } 

    return -1; 
}
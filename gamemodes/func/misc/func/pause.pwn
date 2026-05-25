/*
new bool: IsIgnoringPlayerPause [ MAX_PLAYERS ] ;

timer IgnoreConstantPauseTick[3000](playerid) {

////    print("IgnoreConstantPauseTick timer called (pause.pwn)");

    IsIgnoringPlayerPause [playerid] = false ;
}*/

// YSF


new AFKVariable [ MAX_PLAYERS ], bool:HasPlayerUsedAFKCommand[MAX_PLAYERS] ;

IsPlayerUsingAFKCommand(playerid) { return HasPlayerUsedAFKCommand[playerid]; }

public OnPlayerPause(playerid) {
/*
    if ( ! IsIgnoringPlayerPause [ playerid ] ) {
        SendModeratorWarning ( sprintf ("[PAUSE] (%d) %s has paused.", playerid, ReturnUserName ( playerid, true ) ), MOD_WARNING_LOW ) ;

        IsIgnoringPlayerPause = true ;
        defer IgnoreConstantPauseTick(playerid) ;
    }*/


    if ( Character [ playerid ] [ character_dmgmode ] ) {

        if ( CharSwitchTick [ playerid ] ) {

            return SetName ( playerid, sprintf("[\n[AFK (/afklist)]\nOYUNCU YARALI]{007FFF}[KARAKTER DEÐÝÞTÝRÝLÝYOR]{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )), COLOR_RED ) ;
        }

        else return SetName ( playerid,  sprintf("[AFK (/afklist)]\n(%d) %s", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_RED ) ;
    }

    if ( IsPlayerOOC [ playerid ] ) {

        return SetName ( playerid,  sprintf("[AFK (/afklist)]{AAC4E5}\n(( Oyun Dýþý (OOC) ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_RED ) ;
    }

    if ( IsPlayerOnAdminDuty [ playerid ] ) {

        if ( Account [ playerid ] [ account_id ] == 1 || Account [ playerid ] [ account_id ] == 2 ) {

            return SetName ( playerid, sprintf("[AFK (/afklist)]{855A83}\n(( OOC: Geliþtirici Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_RED ) ;
        }

        else {

            switch ( Account [ playerid ] [ account_stafflevel ] ) {

                case STAFF_MANAGER: {
                    return SetName ( playerid, sprintf("[AFK (/afklist)]{AD2D2D}\n(( OOC: Yönetici Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_RED ) ;
                }

                default: return SetName ( playerid, sprintf("[AFK (/afklist)]{408040}\n(( OOC: Moderatör Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_RED ) ;
            }
        }
    }

    if ( CharSwitchTick [ playerid ] ) {

        return SetName ( playerid, sprintf("[AFK (/afklist)]{007FFF}\n[KARAKTER DEÐÝÞTÝRÝLÝYOR]{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )), COLOR_RED ) ;
    }

    if(!HasPlayerUsedAFKCommand[playerid]) { SetName ( playerid, sprintf("[AFK (/afklist)]{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )  ), COLOR_RED ) ; }

    return true ;
}


public OnPlayerResume ( playerid ) {

/*
    if ( ! IsIgnoringPlayerPause [ playerid ] ) {
        SendModeratorWarning ( sprintf ("[PAUSE] (%d) %s has unpaused.", playerid, ReturnUserName ( playerid, true ) ), MOD_WARNING_LOW ) ;

        IsIgnoringPlayerPause = true ;
        defer IgnoreConstantPauseTick(playerid) ;
    }*/

    if ( Character [ playerid ] [ character_dmgmode ] ) {

        return SetName ( playerid,  sprintf("(%d) %s", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_RED ) ;
    }

    if ( IsPlayerOOC [ playerid ] ) {

        return SetName ( playerid,  sprintf("(( Oyun Dýþý (OOC) ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false, true ) ), COLOR_OOC ) ;
    }

    if ( IsPlayerOnAdminDuty [ playerid ] ) {

        if ( Account [ playerid ] [ account_id ] == 1 || Account [ playerid ] [ account_id ] == 2 ) {

            return SetName ( playerid, sprintf("(( OOC: Geliþtirici Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false ) ), 0x855A83FF ) ;
        }

        else {

            switch ( Account [ playerid ] [ account_stafflevel ] ) {

                case STAFF_MANAGER: {
                    
                    return SetName ( playerid, sprintf("(( OOC: Yönetici Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false ) ), MANAGER_COLOR ) ;
                }

                default: return SetName ( playerid, sprintf("(( OOC: Moderatör Görevde ))\n{[ (%d) %s ]}", playerid, ReturnUserName ( playerid, false ) ), 0x408040FF ) ;
            }
        }
    }

    if ( CharSwitchTick [ playerid ] ) {

        return SetName ( playerid, sprintf("[KARAKTER DEÐÝÞTÝRÝLÝYOR]{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )), COLOR_BLUE ) ;
    }

    if(!HasPlayerUsedAFKCommand[playerid]) { SetName ( playerid, sprintf("{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )  ), COLOR_RED ) ; }

    return true ;

}

CMD:afklist ( playerid, params [] ) {

    SendClientMessage(playerid, COLOR_BLUE, "AFK olan tüm oyuncularýn listesi:") ;

    foreach(new i: Player) {

        if ( IsPlayerPaused ( i ) && i != INVALID_PLAYER_ID ) {

            if ( ! IsPlayerSleepingInPoint [ playerid ] ) { 

                SendClientMessage(playerid, COLOR_DEFAULT, sprintf("(%d) %s: %d saniyedir AFK.", i, ReturnUserName ( i, true ), GetPlayerPausedTime(i) / 1000 ) ) ;
            }

            else if ( IsPlayerSleepingInPoint [ playerid ] ) {

                SendClientMessage(playerid, COLOR_DEFAULT, sprintf("(%d) %s: %d saniyedir AFK. [Uyuyor]", i, ReturnUserName ( i, true ), GetPlayerPausedTime(i) / 1000 ) ) ;
            }
        }

        else continue;
    }

    return true ;
}

CMD:afk(playerid,params[]) {

    if(CharSwitchTick [ playerid ]) { return SendServerMessage(playerid,"Karakter deðiþtirirken bunu kullanamazsýn.",MSG_TYPE_ERROR); }
    if(!HasPlayerUsedAFKCommand[playerid]) {

        HasPlayerUsedAFKCommand[playerid] = true;
        TogglePlayerControllable(playerid,false);
        SendServerMessage(playerid,"Þu an AFK modundasýn, 30 dakika boyunca oyundan atýlmazsýn.",MSG_TYPE_INFO);
        SetName ( playerid, sprintf("[AFK]{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )  ), COLOR_RED ) ;
    }
    else {

        HasPlayerUsedAFKCommand[playerid] = false;
        TogglePlayerControllable(playerid,true);
        SendServerMessage(playerid,"Artýk AFK deðilsin.",MSG_TYPE_INFO);
        SetName ( playerid, sprintf("{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false, true )  ), COLOR_RED ) ;
    }
    return true;
}

task AFKCheck[60000]() {

    foreach(new playerid : Player) {

        if(IsPlayerModerator(playerid) || IsPlayerManager(playerid)) { return true; }
        if ( ! IsPlayerSleepingInPoint [ playerid ] ) {

            AFKVariable [ playerid ] ++ ;

            if(!HasPlayerUsedAFKCommand[playerid]) {

                if ( AFKVariable [ playerid ] == 9 ) {

                    SendServerMessage ( playerid, "Hareketsizlikten dolayý bir dakika içinde oyundan atýlacaksýn. Bunu önlemek için hareket et.", MSG_TYPE_WARN ) ;
                }

                else if ( AFKVariable [ playerid ] >= 10 ) {

                    SendServerMessage ( playerid, "AFK olduðun için oyundan atýldýn.", MSG_TYPE_WARN ) ;
                    KickPlayer ( playerid ) ;
                }
            }
            else {

                TogglePlayerControllable(playerid,false);

                if ( AFKVariable [ playerid ] == 29 ) {

                    SendServerMessage ( playerid, "Hareketsizlikten dolayý bir dakika içinde oyundan atýlacaksýn. Bunu önlemek için /afk komutunu kullan.", MSG_TYPE_WARN ) ;
                }

                else if ( AFKVariable [ playerid ] >= 30 ) {

                    SendServerMessage ( playerid, "AFK olduðun için oyundan atýldýn.", MSG_TYPE_WARN ) ;
                    KickPlayer ( playerid ) ;
                }
            }
        }
    }

    return true ;
}

public OnPlayerUpdate(playerid)
{
    if ( AFKVariable [ playerid ] ) {

        AFKVariable [ playerid ] = 0 ;
    }
    #if defined pause_OnPlayerUpdate
        return pause_OnPlayerUpdate(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate pause_OnPlayerUpdate
#if defined pause_OnPlayerUpdate
    forward pause_OnPlayerUpdate(playerid);
#endif
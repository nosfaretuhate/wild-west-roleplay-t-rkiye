#include "func/misc/func/antispam.pwn"
#include "func/misc/func/pause.pwn"
#include "func/misc/func/shakehands.pwn"
#include "func/misc/func/fader.pwn"
#include "func/misc/func/mask.pwn"
#include "func/misc/func/attributes.pwn"
#include "func/misc/func/gunshells.pwn"
#include "func/misc/func/motds.pwn"

new FriskingPlayer [ MAX_PLAYERS ] ;
CMD:frisk ( playerid, params [] ) {

    new target ;

    if ( sscanf ( params, "u", target )) {

        return SendServerMessage ( playerid, "/frisk [id]", MSG_TYPE_ERROR ) ;
    }

    if ( target == INVALID_PLAYER_ID ) {

        return SendServerMessage ( playerid, "Bu oyuncu baðlý deðil.", MSG_TYPE_ERROR ) ;
    }

    FriskingPlayer [ target ] = playerid ;

    SendServerMessage ( target, sprintf("[FRISK] %s seni aramak istiyor. Kabul etmek için /accept frisk yaz.", ReturnUserName ( playerid, true )), MSG_TYPE_INFO ) ;
    SendServerMessage ( playerid, "Arama isteði gönderildi, karþý tarafýn kabul etmesi gerekiyor.", MSG_TYPE_INFO ) ;

    return true ;
}

CMD:checktime ( playerid, params [] ) {

    if ( ! DoesPlayerHaveItemByExtraParam ( playerid, POCKET_WATCH ) ) {

        return SendServerMessage ( playerid, "Üzerinde cep saati yok!", MSG_TYPE_ERROR ) ;
    }

    SendServerMessage ( playerid, sprintf("Þu anki saat %i:%i.",serverHour, serverMin), MSG_TYPE_INFO ) ;
    SetPlayerChatBubble ( playerid, sprintf("* %s saate bakar.", ReturnUserName ( playerid, false , true ) ), COLOR_ACTION, 20.0, 7000 );
    cmd_time ( playerid ) ;
    return true ;
}

CMD:coin ( playerid, params [] ) {

    new coinflip = random ( 2 ), coinresult [ ] [ ] = {

        "Yazý", "Tura"
    } ;

    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf ( "*** %s havaya bozuk para attý ve %s geldi.", ReturnUserName ( playerid, false ), coinresult [ coinflip ] ) ) ;

    return true ;
}

CMD:roll ( playerid, params [] ) {

    return ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf ( "*** %s zar attý ve %d geldi.", ReturnUserName ( playerid, false ), 1 + random ( 5 )) ) ;
}

CMD:accept(playerid, params[]){

    if ( ! IsPlayerFree ( playerid ) ) {

        return SendServerMessage ( playerid, "Þu an bunu yapamazsýn.", MSG_TYPE_ERROR ) ; 
    }

    if ( isnull (params) ) {
        SendServerMessage ( playerid, "/accept [param]", MSG_TYPE_ERROR ) ;
        SendClientMessage(playerid, COLOR_BLUE, "[KOMUTLAR]:{DEDEDE} greet, frisk");
        return 1;
    }

    if (!strcmp(params, "greet", true) && PlayerShakeOffer [ playerid ] != INVALID_PLAYER_ID)
    {
        new targetid = PlayerShakeOffer [ playerid ], type = PlayerShakeType [ playerid ];

        if (!IsPlayerNearPlayer(playerid, targetid, 6.0)) {

            return SendServerMessage(playerid, "O kiþiye yakýn deðilsin.", MSG_TYPE_ERROR);
        }

        SetPlayerToFacePlayer(targetid, playerid);
        SetPlayerToFacePlayer(playerid, targetid);

        PlayerShakeOffer [ playerid ] = INVALID_PLAYER_ID;
        PlayerShakeType [ playerid ] = 0;

        switch (type)
        {
            case 1: { ApplyAnimation(playerid, "GANGS", "hndshkaa", 4.0, false, false, false, false, 0, SYNC_ALL); ApplyAnimation(targetid, "GANGS", "hndshkaa", 4.0, false, false, false, false, 0, SYNC_ALL); }
            case 2: { ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, false, false, false, false, 0, SYNC_ALL); ApplyAnimation(targetid, "GANGS", "hndshkba", 4.0, false, false, false, false, 0, SYNC_ALL); }
            case 3: { ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, false, false, false, false, 0, SYNC_ALL); ApplyAnimation(targetid, "GANGS", "hndshkda", 4.0, false, false, false, false, 0, SYNC_ALL); }
            case 4: { ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, false, false, false, false, 0, SYNC_ALL); ApplyAnimation(targetid, "GANGS", "hndshkea", 4.0, false, false, false, false, 0, SYNC_ALL); }
            case 5: { ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, false, false, false, false, 0, SYNC_ALL); ApplyAnimation(targetid, "GANGS", "hndshkfa", 4.0, false, false, false, false, 0, SYNC_ALL); }
            case 6: { ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, false, false, false, false, 0, SYNC_ALL); ApplyAnimation(targetid, "GANGS", "prtial_hndshk_biz_01", 4.0, false, false, false, false, 0, SYNC_ALL); }
        }

        SendServerMessage(playerid, sprintf( "%s ile tokalaþmayý kabul ettin.", ReturnUserName(targetid, false)), MSG_TYPE_INFO );
        SendServerMessage(targetid, sprintf( "%s seninle tokalaþmayý kabul etti.", ReturnUserName(playerid, false)), MSG_TYPE_INFO );
    }

    else if (!strcmp(params, "frisk", true) && FriskingPlayer [ playerid ] != INVALID_PLAYER_ID) {

        new target = FriskingPlayer [ playerid ] ;

        if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

            return SendServerMessage(playerid, "O kiþiye yakýn deðilsin.", MSG_TYPE_ERROR);
        }

        SendClientMessage(target, COLOR_TAB0, sprintf("|________________________| (%d) %s Tarafýndan Aranýyorsun |________________________|", playerid, ReturnUserName ( playerid, true ) ) ) ;
        SendClientMessage( target, COLOR_TAB1,  sprintf("[EL]: %s (%d mermi).", ReturnWeaponName ( Character [ playerid ] [ character_handweapon] ), Character [ playerid ] [ character_handammo ] )) ;
        SendClientMessage( target, COLOR_TAB2,  sprintf("[PANTOLON]: %s (%d mermi).", ReturnWeaponName ( Character [ playerid ] [ character_pantsweapon] ), Character [ playerid ] [ character_pantsammo ] )) ;
        SendClientMessage( target, COLOR_TAB1,  sprintf("[SIRT]: %s (%d mermi).", ReturnWeaponName ( Character [ playerid ] [ character_backweapon] ), Character [ playerid ] [ character_backammo ] )) ;
        SendClientMessage( target, COLOR_TAB1,  sprintf("[PARA]: $%s", IntegerWithDelimiter ( Character [ playerid ] [ character_handmoney ] )) )  ;

        FriskingPlayer [ playerid ] = INVALID_PLAYER_ID ;

        ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf ( "* %s, %s kiþisini üst aramasýndan geçirdi.", ReturnUserName ( target, false ), ReturnUserName ( playerid, false ) ) ) ;

    }

    return true ;
}
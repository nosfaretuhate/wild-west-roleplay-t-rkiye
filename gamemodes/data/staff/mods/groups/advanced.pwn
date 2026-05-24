CMD:purgereports(playerid,params[]) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    PurgeReports();
    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d) tüm sunucu þikayetlerini temizledi.", ReturnUserName ( playerid, true ), playerid ) , MOD_WARNING_HIGH) ;
    return true;
}

CMD:purgequestions(playerid,params[]) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    PurgeQuestions();
    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d) tüm sunucu sorularýný temizledi.", ReturnUserName ( playerid, true ), playerid ) , MOD_WARNING_HIGH) ;
    return true;
}

CMD:clearplayerinventory(playerid,params[]) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid,query[128];
    if(sscanf(params,"k<u>",targetid)) { return SendServerMessage(playerid,"/clearplayerinventory [oyuncuID]",MSG_TYPE_ERROR); }
    if(!IsPlayerConnected(targetid)) { return SendServerMessage(playerid,"Bu oyuncu baðlý deðil.",MSG_TYPE_ERROR); }

    mysql_format(mysql,query,sizeof(query),"DELETE FROM items_player WHERE player_database_id = %d",Character[targetid][character_id]);
    mysql_tquery(mysql,query);
    Init_LoadPlayerItems(targetid);

    SendServerMessage(targetid,sprintf("[YÖNETÝM] %s (%d) envanterini sýfýrladý.",ReturnUserName(playerid,false,false),playerid),MSG_TYPE_INFO);
    SendModeratorWarning(sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncunun envanterini sýfýrladý.",ReturnUserName(playerid,true,false),playerid,ReturnUserName(targetid,true,false),targetid),MOD_WARNING_MED);
    return true;
}

CMD:toggleooc ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    ToggleOOCChat = !ToggleOOCChat ;

    SendServerMessage ( playerid, sprintf("OOC sohbeti %s.", (ToggleOOCChat) ? ("etkinleþtirdin") : ("devre dýþý býraktýn") ), MSG_TYPE_WARN ) ;

    return true ;

}

CMD:forcepaycheck(playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }


    foreach(new i: Player){

        if ( i != INVALID_PLAYER_ID ) {

            LastPaycheckGiven [ i ] = 0 ;
            Paycheck ( i ) ;
        }
    }

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d) genel bir maaþ daðýtýmý zorladý.", ReturnUserName ( playerid, true ), playerid ) , MOD_WARNING_HIGH) ;

    return true ;
}

CMD:forcelottery ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    @pT_OnLotteryTick_LOTTERY_TICK_TIMER () ;

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d) global bir piyango çekiliþi zorladý.", ReturnUserName ( playerid, true ), playerid ) , MOD_WARNING_HIGH) ;

    return true ;
}

CMD:givemoney ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid, money ;

    if ( sscanf ( params, "k<u>i", targetid, money ) ) {

        return SendServerMessage ( playerid, "/givemoney [oyuncuID] [miktar]", MSG_TYPE_ERROR ) ;
    }

    if ( money > 5000 ) {

        return SendServerMessage ( playerid, "Bunu yapamazsýn. Bir kerede 5000'den fazla para veremezsin.", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( targetid ) ) {

        return SendServerMessage ( playerid, "Geçerli bir oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
    }

    task_yield ( 1 ) ;

    new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
    await_arr ( dialog_response ) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "{C23030}SUÝSTÝMAL UYARISI", "{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\nBir oyuncuya deðerli bir eþya vermek üzeresin.\nBunun suistimal edilmesi durumunda yakalanacak ve /KALICI/ olarak yasaklanacaksýn.\n\nBunu göz önünde bulundurarak devam et.", "{C23030}Devam Et", "Ýptal" ) ;

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        return false ;
    }

    SendServerMessage ( targetid, sprintf("Moderatör (%d) %s tarafýndan sana $%s verildi.", playerid, ReturnUserName ( playerid, true ), IntegerWithDelimiter( money) ), MSG_TYPE_WARN) ;

    GiveCharacterMoney ( targetid, money, MONEY_SLOT_HAND ) ;

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), (%d) %s adlý oyuncuya $%s verdi.", ReturnUserName ( playerid, true ), playerid,  targetid, ReturnUserName ( targetid, true ), IntegerWithDelimiter( money) ), MOD_WARNING_HIGH ) ;
    WriteLog ( targetid, "mod/money", sprintf( "%s (%d), (%d) %s adlý oyuncuya $%s verdi.", ReturnUserName ( playerid, true ), playerid, targetid, ReturnUserName ( targetid, true ), IntegerWithDelimiter( money) )) ;

    return true ;
}

CMD:spawnweapon ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid, WEAPON: weaponid, ammo ;

    if ( sscanf ( params, "k<u>ii", targetid, weaponid, ammo ) ) {

        return SendServerMessage ( playerid, "/spawnweapon [oyuncuID] [silahID] [mermi]", MSG_TYPE_ERROR ) ;
    }

    if ( ammo > 15 ) {

        return SendServerMessage ( playerid, "Bir þarjörde 15'ten fazla mermi veremezsin!", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsValidWeapon ( weaponid ) ) {

        return SendServerMessage ( playerid, "Geçersiz bir silah ID'si.", MSG_TYPE_ERROR ) ;
    }


    if ( ! IsPlayerConnected ( targetid ) ) {

        return SendServerMessage ( playerid, "Geçerli bir oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
    }

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), (%d) %s adlý oyuncuya %d mermili %s verdi.", ReturnUserName ( playerid, true ), playerid, ReturnWeaponName ( weaponid ), ammo, targetid, ReturnUserName ( targetid, true ) ), MOD_WARNING_HIGH ) ;
    WriteLog ( targetid, "mods/gun", sprintf("%s (%d), (%d) %s adlý oyuncuya %d mermili %s verdi.", ReturnUserName ( playerid, true ), playerid, ReturnWeaponName ( weaponid ), ammo,  targetid, ReturnUserName ( targetid, true ))) ;

    return wep_GivePlayerWeapon ( targetid, weaponid, ammo ) ;
}

CMD:gotodroppedweapon ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new id, Float: x, Float: y, Float: z ;

    if ( sscanf ( params, "i", id ) ) {

        return SendServerMessage ( playerid, "/gotodroppedweapon [id]", MSG_TYPE_ERROR ) ;
    }

    if ( IsValidDynamicObject( DroppedWeapon [ id ] )) {

        GetDynamicObjectPos(DroppedWeapon [ id ], x, y, z  ) ;
        ac_SetPlayerPos(playerid, x, y, z ) ;

        SetPlayerVirtualWorld ( playerid, 0 ) ;
        SetPlayerInterior ( playerid, 0 ) ;

        SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), yerdeki %d ID'li silaha ýþýnlandý.", ReturnUserName ( playerid, true ), playerid, id ), MOD_WARNING_LOW) ;
    }

    else return SendServerMessage ( playerid, "Geçersiz silah ID'si. Geçerli bir obje deðil.", MSG_TYPE_WARN ) ;

    return true ;
}

CMD:removedroppedweapon ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az kýdemli moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new id ;

    if ( sscanf ( params, "i", id ) ) {

        return SendServerMessage ( playerid, "/removedroppedweapon [id]", MSG_TYPE_ERROR ) ;
    }

    if ( IsValidDynamicObject( DroppedWeapon [ id ] )) {

        DestroyDynamicObject(DroppedWeapon [ id ] ) ;
        DroppedWeapon [ id ] = -1 ;
        DroppedWeaponAmmo [ id ] = 0 ;

        SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), yerdeki %d ID'li silahý sildi.", ReturnUserName ( playerid, true ), playerid, id ), MOD_WARNING_MED ) ;
    }

    else return SendServerMessage ( playerid, "Geçersiz silah ID'si. Geçerli bir obje deðil.", MSG_TYPE_WARN ) ;

    return true ;
}
CMD:clearbuggeditems(playerid,params[]) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }
    
    new targetid;
    if(sscanf(params,"k<u>",targetid)) { return SendServerMessage(playerid,"/clearbuggeditems [oyuncuID]",MSG_TYPE_ERROR); }
    if(!IsPlayerConnected(targetid)) { return SendServerMessage(playerid,"Bu oyuncu çevrim içi deðil.",MSG_TYPE_ERROR); }
    
    ClearBuggedItems(targetid);
    SendServerMessage(playerid,sprintf("(%d) %s adlý oyuncunun buglu eþyalarý temizlendi.",targetid,ReturnUserName(targetid,true)),MSG_TYPE_INFO);
    SendServerMessage(targetid,sprintf("(%d) %s envanterindeki buglu eþyalarý temizledi.",playerid,ReturnUserName(playerid,true)),MSG_TYPE_INFO);
    return true;
}

CMD:clearshells ( playerid, params [] ) {
    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    ClearGunShells () ;
    SendModeratorWarning ( sprintf("[KOVANLAR] %s (%d) yerdeki mermi kovanlarýný temizledi.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_MED ) ;

    return true ;
}

CMD:geoip ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid;
    if ( sscanf ( params, "k<u>", targetid ) ) {
        return SendServerMessage ( playerid, "/geoip [oyuncuID]", MSG_TYPE_ERROR ) ;
    }

    if ( targetid == INVALID_PLAYER_ID ) {
        return SendServerMessage ( playerid, "Geçerli bir oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
    }

    new country [ 32 ], region [ 32 ], city [ 32 ], isp [ 32 ], timez [ 32 ], zipcode [ 32 ] ;

    GetPlayerCountry(targetid, country ) ;
    GetPlayerRegion(targetid, region ) ;
    GetPlayerCity(targetid, city ) ;
    GetPlayerISP(targetid, isp ) ;
    GetPlayerZipcode(targetid, zipcode ) ;
    GetPlayerTimezone(targetid, timez ) ; 

    SendClientMessage(playerid, COLOR_YELLOW, sprintf("(%d) %s - GEO Verisi (IP: %s) [Zaman Dilimi: %s]", targetid, ReturnUserName ( targetid, true ), ReturnIP ( targetid ), timez ) ) ;
    SendClientMessage(playerid, COLOR_YELLOW, sprintf("Ülke: %s - Bölge: %s - Þehir: %s - ISP: %s - Posta Kodu: %s", country, region, city, isp, zipcode ) ) ;

    SendModeratorWarning ( sprintf("[GEO] %s (%d), %s (%d) adlý oyuncunun konum verilerini kontrol etti.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_MED ) ;

    return true ;
}

CMD:togmodwarnings ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( IsPlayerOnAdminDuty [ playerid ] ) {
        return SendServerMessage ( playerid, "Moderatör görevindeyken uyarýlarý kapatamazsýn.", MSG_TYPE_WARN ) ;
    }

    if ( ! PlayerModWarnings [ playerid ] ) {
        PlayerModWarnings [ playerid ] = true ;
        return SendServerMessage ( playerid, "Moderatör uyarýlarý etkinleþtirildi. Kapatmak için tekrar /togmodwarnings kullan.", MSG_TYPE_INFO ) ;
    }
    else {
        PlayerModWarnings [ playerid ] = false ;
        return SendServerMessage ( playerid, "Moderatör uyarýlarý devre dýþý býrakýldý. Açmak için tekrar /togmodwarnings kullan.", MSG_TYPE_INFO ) ;
    }
}

CMD:afrisk ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid ;
    if ( sscanf ( params, "k<u>", targetid )) {
        return SendServerMessage ( playerid, "/afrisk [oyuncuID]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected(targetid)){
        return SendServerMessage ( playerid, "Oyuncu baðlý deðil.", MSG_TYPE_ERROR ) ;
    }

    SendClientMessage(playerid, COLOR_TAB0, sprintf("|________________________| (%d) %s - Üst Aramasý |________________________|", targetid, ReturnUserName ( targetid, true ) ) ) ;
    SendClientMessage( playerid, COLOR_TAB1,  sprintf("[ELDE]: %s (%d mermi).", ReturnWeaponName ( Character [ targetid ] [ character_handweapon] ), Character [ targetid ] [ character_handammo ] )) ;
    SendClientMessage( playerid, COLOR_TAB2,  sprintf("[PANTOLON]: %s (%d mermi).", ReturnWeaponName ( Character [ targetid ] [ character_pantsweapon] ), Character [ targetid ] [ character_pantsammo ] )) ;
    SendClientMessage( playerid, COLOR_TAB1,  sprintf("[SIRTA]: %s (%d mermi).", ReturnWeaponName ( Character [ targetid ] [ character_backweapon] ), Character [ targetid ] [ character_backammo ] )) ;
    SendClientMessage( playerid, COLOR_TAB1,  sprintf("[PARA]: $%s", IntegerWithDelimiter ( Character [ targetid ] [ character_handmoney ] )) )  ;

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncuyu aradý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
    
    return true ;
}

CMD:adisarm ( playerid, params [] ) {
    new targetid, permit ;

    if ( sscanf ( params, "k<u>i", targetid, permit ) ) {
        return SendServerMessage ( playerid, "Kullaným: /adisarm <oyuncuID> <ruhsat: 0: tut, 1: sil)", MSG_TYPE_ERROR ) ;
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
        SendServerMessage ( targetid, sprintf("Yetkili %s tüm silahlarýný ve ruhsatýný aldý.", ReturnUserName ( playerid, false, true ) ), MSG_TYPE_INFO ) ;
        SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncunun silahlarýný ve ruhsatýný aldý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
    }
    else {
        SendServerMessage ( targetid, sprintf("Yetkili %s tüm silahlarýný aldý.", ReturnUserName ( playerid, false, true ) ), MSG_TYPE_INFO ) ;
        SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncunun silahlarýný aldý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
    } 

    return true ;
}

CMD:stopinjuries ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid ;
    if ( sscanf ( params, "k<u>", targetid )) {
        return SendServerMessage ( playerid, "/stopinjuries [oyuncuID]", MSG_TYPE_ERROR ) ;
    }

    if ( targetid == INVALID_PLAYER_ID ) {
        return SendServerMessage ( playerid, "Oyuncu baðlý deðil.", MSG_TYPE_ERROR ) ;
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
    else {
        SetName ( targetid, sprintf("[DURAKLATILDI (/afklist)]{DEDEDE}\n(%d) %s", targetid, ReturnUserName ( targetid, false )  ), COLOR_RED ) ;
    }

    new query [ 128 ] ;
    mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_dmgmode = '0' WHERE character_id = '%d'", Character [ targetid ] [ character_id ] ) ;
    mysql_tquery ( mysql, query ) ;

    SendServerMessage ( targetid, sprintf("Yaralarýn moderatör (%d) %s tarafýndan temizlendi.", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_INFO ) ;
    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncunun yaralarýný iyileþtirdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
    return true ;
}

CMD:ban ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new uid, reason [ 64 ], hours ;
    if ( sscanf ( params, "k<u>is[64]", uid, hours, reason ) ) {
        return SendServerMessage ( playerid, "/ban [oyuncuID] [saat] [sebep]", MSG_TYPE_ERROR ) ;
    }

    if ( strlen ( reason ) > sizeof ( reason ) ) {
        return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( uid ) ) {
        return SendServerMessage ( playerid, "Seçilen oyuncu bulunamadý, çevrim dýþý olabilir.", MSG_TYPE_INFO ) ;
    }
        
    if ( hours < 12 || hours > 720 ) {
        return SendServerMessage ( playerid, "Ban süresi 12 ile 720 saat arasýnda olmalýdýr.", MSG_TYPE_ERROR ) ;
    }
    
    if ( hours == 0 ) hours = 9999 ;

    new secs = hours * 3600, unbants = gettime() + secs;
    new query[256] ;
    
    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
    Account [ uid ] [ account_id ], Account [ uid ] [ account_name ], ReturnIP ( uid ), Account [ playerid ] [ account_name ], reason, gettime(), unbants);
    mysql_tquery(mysql, query);

    SetAdminRecord ( Account [ uid ] [ account_id ], Account [ playerid ] [ account_id ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;
    
    SendSplitMessageToAll ( COLOR_STAFF, sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncuyu \"%s\" sebebiyle banladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid,  reason) ) ;
    
    SendRconCommand(sprintf("banip %s", ReturnIP ( uid )));
    KickPlayer ( uid ) ;
    return true ;
}

CMD:offlineban ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new masteracc [ MAX_PLAYER_NAME ], hours, reason [ 64 ] ;

    if ( sscanf ( params, "s[24]is[64]", masteracc, hours, reason ) ) {
        return SendServerMessage ( playerid, "/offlineban [ana_hesap] [saat] [sebep]", MSG_TYPE_ERROR ) ;
    }

    if ( strlen ( masteracc ) > MAX_PLAYER_NAME ) {
        return SendServerMessage ( playerid, "Ýsim 24 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
    }

    if ( strlen ( reason ) > sizeof ( reason ) ) {
        return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz!", MSG_TYPE_ERROR ) ;
    }
        
    if ( hours < 12 || hours > 720 ) {
        return SendServerMessage ( playerid, "Ban süresi 12 ile 720 saat arasýnda olmalýdýr.", MSG_TYPE_ERROR ) ;
    }

    foreach (new i: Player) {
        if ( ! strcmp(masteracc, Account [ playerid ] [ account_name ] ) ) {
            return SendServerMessage ( playerid, sprintf("Oyuncu þu an %d ID ile baðlý. Lütfen /ban kullan.", i ), MSG_TYPE_WARN ) ;
        }
    }

    new query[256], rows ;
    inline ReturnAccountName() {
        cache_get_row_count ( rows ) ;
        if ( ! rows ) {
            return SendServerMessage ( playerid, "Veri tabanýnda böyle bir hesap bulunamadý. Ýsmi yanlýþ yazmýþ olabilirsin.", MSG_TYPE_WARN ) ;
        }
        if ( rows ) {
            new secs = hours * 3600, unbants, acc_id ;
            unbants = gettime() + secs;
            cache_get_value_name_int ( 0, "account_id", acc_id ) ;
            SetAdminRecord ( acc_id, Account [ playerid ] [ account_id ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;
            mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', 'ÇEVRÝM DIÞI BAN', '%e', '%e', %d, %d)",
            acc_id, masteracc, Account [ playerid ] [ account_name ], reason, gettime(), unbants);
            mysql_tquery(mysql, query);
            SendSplitMessageToAll ( COLOR_STAFF, sprintf("[YÖNETÝM] %s (%d), %s adlý oyuncuyu çevrim dýþýyken \"%s\" sebebiyle banladý.", ReturnUserName ( playerid, true ), playerid, masteracc, reason) ) ;
        }
    }
    MySQL_TQueryInline(mysql, using inline ReturnAccountName, "SELECT account_id FROM master_accounts WHERE account_name = '%s'", masteracc );
    return true ;
}

CMD:unban ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {
        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new masteracc [ MAX_PLAYER_NAME ];
    if ( sscanf ( params, "s[24]", masteracc ) ) {
        return SendServerMessage ( playerid, "/unban [ana_hesap]", MSG_TYPE_ERROR ) ;
    }

    new query[180], rows ;
    inline ReturnAccountName() {
        cache_get_row_count ( rows ) ;
        if ( ! rows ) {
            return SendServerMessage ( playerid, "Hesap bulunamadý. Ýsmi doðru yazdýðýndan emin ol.", MSG_TYPE_WARN ) ;
        }
        if ( rows ) {
            new acc_id ;
            cache_get_value_name_int ( 0, "account_id", acc_id ) ;
            inline CheckUnban() {
                cache_get_row_count ( rows ) ;
                if ( ! rows ) {
                    return SendServerMessage ( playerid, sprintf("(%d) %s adlý oyuncu banlý deðil.", acc_id, masteracc ), MSG_TYPE_WARN ) ;
                }
                if ( rows ) {
                    mysql_format ( mysql, query, sizeof ( query), "DELETE FROM bans WHERE account_id = %d", acc_id ) ;
                    mysql_tquery(mysql, query);
                    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncunun banýný kaldýrdý.", ReturnUserName ( playerid, true ), playerid, masteracc, acc_id ), MOD_WARNING_LOW ) ;
                }
            }
            MySQL_TQueryInline(mysql, using inline CheckUnban, "SELECT * FROM bans WHERE account_id = %d", acc_id );
        }
    }
    MySQL_TQueryInline(mysql, using inline ReturnAccountName, "SELECT account_id FROM master_accounts WHERE account_name = '%s'", masteracc );
    return true ;
}

BanChecker ( playerid ) {
    new query [ 512 ] ;
    inline BanHandler() {
        new rows ;
        cache_get_row_count ( rows ) ;
        if ( ! rows ) return true ;
        if ( rows ) {
            new unbantimestamp, admin [ MAX_PLAYER_NAME ], reason [ 64 ], date [ 6 ]  ;
            for ( new i, p = rows; i < p; i ++ ) {
                cache_get_value_name ( i, "ban_admin", admin, 24 ) ;
                cache_get_value_name ( i, "ban_reason", reason, 36 ) ;
                cache_get_value_int ( i, "unban_time", unbantimestamp ) ;
            }
            if ( unbantimestamp > gettime () )  {
                HideCharacterTextDraws ( playerid ) ;
                TimestampToDate ( unbantimestamp, date[0], date[1], date[2], date[3], date[4], date[5], 1) ;
                SendClientMessage(playerid, COLOR_RED, "Hesabýn kurallarý ihlal ettiðin için geçici olarak askýya alýndý." ) ;
                SendClientMessage(playerid, COLOR_RED, sprintf("Yetkili %s tarafýndan %s sebebiyle banlandýn.", admin, reason));
                SendClientMessage(playerid, COLOR_RED, sprintf("Banýn %02d/%02d/%02d %02d:%02d:%02d tarihinde açýlacak.", date[2], date[1], date[0], date[3], date[4], date[5]));
                SendClientMessage(playerid, COLOR_RED, "Baný aþmaya çalýþma, bu iþlem kalýcý ban ile sonuçlanýr." ) ;
                SendClientMessage(playerid, COLOR_RED, "Ýtirazýn varsa forum üzerinden talep oluþturabilirsin. (www.ww-rp.net)" ) ;
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

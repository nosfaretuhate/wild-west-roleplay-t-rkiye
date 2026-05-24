CMD:distanceaid(playerid,params[]) {

    if ( ! IsPlayerManager ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için yönetici olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    new Float:distance;
    if(sscanf(params,"f",distance)) { return SendServerMessage(playerid,"/distanceaid [mesafe] (checkpoint'i kaldýrmak için -1)",MSG_TYPE_ERROR); }    

    if(distance == -1) {

        DisablePlayerCheckpoint(playerid);
        SendServerMessage(playerid,"Mesafe yardýmý checkpoint'i kaldýrýldý.",MSG_TYPE_INFO);
    }
    else {

        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        GetXYInFrontOfPlayer(playerid,x,y,distance);
        SetPlayerCheckpoint(playerid,x,y,z,1);
        SendServerMessage(playerid,sprintf("Checkpoint %.02fm mesafeye ayarlandý.",distance),MSG_TYPE_INFO);
    }
    return true;
}

CMD:makedonator ( playerid, params [] ) {

    if ( ! IsPlayerManager ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için yönetici olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    new user[MAX_PLAYER_NAME], donlevel;

    if ( sscanf ( params, "s["#MAX_PLAYER_NAME"]i", user, donlevel ) ) {

        return SendServerMessage ( playerid, "/makedonator [ana_hesap] [seviye 1-3]", MSG_TYPE_ERROR ) ;
    }

    if ( donlevel < 1 || donlevel > 3 ) {

        return SendServerMessage ( playerid, "Geçersiz baðýþçý seviyesi.", MSG_TYPE_ERROR ) ;
    }

    new query [ 128 ] ;

    inline manager_SetDonatorRank() {

        new rows;

        cache_get_row_count ( rows ) ;

        if ( rows ) {

            mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_donatorlevel = %d, account_donatorexpire = %d WHERE account_name = '%e'", donlevel, gettime()+2592000, user ) ;
            mysql_tquery ( mysql, query ) ;

            foreach ( new i : Player ) {

                if ( !strcmp ( user, Account [ i ] [ account_name ] ) ) {

                    new date [ 6 ] ;

                    cache_get_value_name_int ( 0, "account_donatorlevel", Account [ i ] [ account_donatorlevel ] ) ;
                    cache_get_value_name_int ( 0, "account_donatorexpire", Account [ i ] [ account_donatorexpire ] ) ;

                    switch ( Account [ i ] [ account_donatorlevel ] ) {

                        case 1: {

                            Account [ i ] [ account_namechanges ] = 2 ;
                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_namechanges = %d WHERE account_name = '%e'", Account [ i ] [ account_namechanges ], user ) ; 

                        }

                        case 2: {

                            Account [ i ] [ account_namechanges ] = 3 ;
                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_namechanges = %d WHERE account_name = '%e'", Account [ i ] [ account_namechanges ], user ) ; 

                        }

                        case 3: {

                            Account [ i ] [ account_namechanges ] = 4 ;
                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_namechanges = %d WHERE account_name = '%e'", Account [ i ] [ account_namechanges ], user ) ; 

                        }

                    }

                    mysql_tquery ( mysql, query ) ;

                    TimestampToDate ( Account [ i ] [ account_donatorexpire ], date [ 0 ], date [ 1 ], date [ 2 ], date [ 3 ], date [ 4 ], date [ 5 ], 1 ) ;

                    SendServerMessage ( i, sprintf("%s seviye baðýþçý yapýldýn.", GetDonatorRank ( i ) ), MSG_TYPE_INFO ) ;
                    SendServerMessage ( i, sprintf("Baðýþçý rütben %d/%d/%d tarihinde sona erecek.", date [ 2 ], date [ 1 ], date [ 0 ] ), MSG_TYPE_INFO ) ;

                    return true ;
                }

                else continue;
            }

            return SendClientMessageToAll ( COLOR_DEFAULT, sprintf("[BAÐIÞÇI] %s kullanýcýsý baðýþçý yapýldý.", user ) ) ;
        }

        else return SendServerMessage ( playerid, sprintf("'%s' isimli hesap veritabanýnda bulunamadý.", user ), MSG_TYPE_ERROR ) ;

    }

    MySQL_TQueryInline ( mysql, using inline manager_SetDonatorRank, "SELECT account_namechanges, account_donatorlevel, account_donatorexpire FROM master_accounts WHERE account_name = '%e'", user ) ;

    return true ;
}

CMD:makestaff ( playerid, params [] ) {

    if ( ! IsPlayerManager ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için yönetici olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    new uid, lvl ;

    if ( sscanf ( params, "k<u>i", uid, lvl ) ) {

        SendServerMessage ( playerid, "/makestaff [oyuncu] [seviye]", MSG_TYPE_ERROR ) ;
        return SendClientMessage(playerid, -1, "[SEVÝYELER] YOK: 0 | DESTEKÇÝ: 1 | MODERATÖR: 2 | YÖNETÝM: 3 | GELÝÞTÝRÝCÝ: 4" ) ;
    }

    if ( lvl < 0 ||  lvl > 4 ) {

        return SendServerMessage ( playerid, "Seviye 0'dan düþük veya 4'ten yüksek olamaz.", MSG_TYPE_ERROR ) ;
    }

    new query [ 128 ] ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_stafflevel = '%d' WHERE account_id = '%d'", lvl, Account [ uid ] [ account_id ] ) ;
    mysql_tquery ( mysql, query ) ;


    Account [ uid ] [ account_stafflevel ] = lvl ;

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncuyu (%d) %s rütbesine terfi ettirdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid, lvl, GetStaffRankName ( lvl ) ), MOD_WARNING_HIGH ) ;

    return true ;
}

CMD:setstaffgroup ( playerid, params [] ) {

    if ( ! IsPlayerManager ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için yönetici olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    new uid, grp ;

    if ( sscanf ( params, "k<u>i", uid, grp ) ) {

        SendServerMessage ( playerid, "/setstaffgroup [oyuncu] [grup]", MSG_TYPE_ERROR ) ;
        return SendClientMessage(playerid, -1, "Hangi grubu seçeceðini görmek için forumu kullan. Hiyerarþi düzenine göre ID seç." ) ;
    }

    if ( grp < 0 ) {

        return SendServerMessage ( playerid, "Grup 0'dan düþük olamaz.", MSG_TYPE_ERROR ) ;
    }

    if ( grp > 4 ) {

        return SendServerMessage ( playerid, "Grup 4'ten yüksek olamaz.", MSG_TYPE_ERROR ) ;
    }

    new query [ 128 ] ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_staffgroup = %d WHERE account_id = '%d'", grp, Account [ uid ] [ account_id ] ) ;
    mysql_tquery ( mysql, query ) ;

    Account [ uid ] [ account_staffgroup ] = grp ;

    SendModeratorWarning ( sprintf("[YÖNETÝM] %s (%d), %s (%d) adlý oyuncunun yetki grubunu %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( uid, true ), uid, grp ), MOD_WARNING_HIGH ) ;

    return true ;
}

CMD:man(playerid, params [] ) {

    if ( ! IsPlayerManager ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için yönetici olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    new text [ 144 ] ;

    if ( sscanf ( params, "s[144]", text ) ) {

        return SendServerMessage ( playerid, "/man [mesaj]", MSG_TYPE_ERROR ) ;
    }

    SendManagerMessage ( playerid, text ) ;

    return true ;
}

SendManagerMessage ( playerid, text [] ) {

    new string[256];
    foreach (new i: Player) {

        if ( IsPlayerManager ( i ) ) {

            format(string,sizeof(string),"[YÖNETÝM] %s (%d){DEDEDE}: %s", ReturnUserName ( playerid, true ), playerid, text ) ;
            SendSplitMessage(i,MANAGER_COLOR,string);
        }
    }

    return true ;
}
CMD:badge ( playerid, params [] ) {

    new posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir polis grubunda (posse) olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    new type ;

    if ( sscanf ( params, "i", type ) ) {

        return SendServerMessage ( playerid, "/badge [tip: 0 - 3]", MSG_TYPE_ERROR ) ;
    }

    if ( type < 0 || type > 3 ) {

        return SendServerMessage ( playerid, "0'dan küçük veya 3'ten büyük olamaz!", MSG_TYPE_ERROR ) ;
    }

    switch ( type ) {

        case 0: {
            
            SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, 19347, 1 ) ;
        }
        case 1: {
            
            SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, 19774, 1 ) ;
        }
        case 2: {
            
            SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, 19775, 1 ) ;
        }
        case 3: {
            
            SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, 19776, 1 ) ;
        }
    }

    EditAttachedObject(playerid, ATTACH_SLOT_EQUIP ) ;
    SendServerMessage ( playerid, "Artýk rozeti düzenleyebilirsin. Hatýrlatma: bir eþyayý kuþanmak, mevcut olaný kaldýrýr.", MSG_TYPE_ERROR ) ;

    return true ;
}


CMD:posse ( playerid, params [] ) {
    if ( ! IsPlayerInPosse ( playerid ) ) {

        return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_INFO ) ;    
    }

    new option [ 32 ], value, extra [ 36 ], posseid = Character [ playerid ] [ character_posse ] ;

    if ( sscanf ( params, "s[32]I(-1)S(-1)[36]", option, value, extra) ) {

        return SendServerMessage ( playerid, "/posse [chat, invite, uninvite, tier, rank, spawn, members] [oyuncu: isteðe baðlý] [ekstra: isteðe baðlý]", MSG_TYPE_ERROR ) ;
    } 

    if ( ! strcmp ( option, "chat" ) ) {

        if ( ! Character [ playerid ] [ character_posse ] ) {
            return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_INFO ) ;
        }
        
        if ( Character [ playerid ] [ character_possetier ] < 2 ) {
            return SendServerMessage ( playerid, "Bu iþlemi gerçekleþtirmek için yeterli yetkiye sahip deðilsin.", MSG_TYPE_WARN ) ;
        }

        if ( Posse_Chat [ posseid ] ) {
            Posse_Chat [ posseid ] = false ;
            
            return SendPosseWarning ( posseid, sprintf("{[ %s %s (%d) grup sohbetini kapattý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid ) ) ;
        }

        else if ( ! Posse_Chat [ posseid ] ) {
            Posse_Chat [ posseid ] = true ;

            return SendPosseWarning ( posseid, sprintf("{[ %s %s (%d) grup sohbetini açtý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid ) ) ;
        }
    }

    else if ( ! strcmp ( option, "invite" ) ) {

        if ( Character [ playerid ] [ character_possetier ] < 2 ) {

            return SendServerMessage ( playerid, "Bu iþlemi gerçekleþtirmek için yeterli yetkiye sahip deðilsin.", MSG_TYPE_WARN ) ;   
        }

        if ( ! IsPlayerConnected ( value ) ) {

            return SendServerMessage ( playerid, "/posse invite [oyuncu] - girilen oyuncu mevcut deðil.", MSG_TYPE_ERROR ) ;
        }

        if ( Character [ value ] [ character_posse ] > 0 ) {

            return SendServerMessage ( playerid, "Oyuncu zaten bir grupta.", MSG_TYPE_WARN ) ; 
        }

        Character [ value ] [ character_posse ]        =  posseid ;
        Character [ value ] [ character_possetier ]    = 1 ;

        Character [ value ] [ character_posserank ][0] = EOS ;
        strcat(Character [ value ] [ character_posserank ], "Yeni Üye", 36 ) ;

        SendPosseWarning ( posseid, sprintf("{[ %s %s (%d), %s (%d) adlý oyuncuyu gruba davet etti. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid, ReturnUserName ( value, true ), value ));
        SavePlayerFactionData ( value ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "uninvite" ) ) {

        if ( Character [ playerid ] [ character_possetier ] < 3 ) {
            return SendServerMessage ( playerid, "Bu iþlemi sadece grup lideri gerçekleþtirebilir.", MSG_TYPE_ERROR ) ;
        }

        if ( ! IsPlayerConnected ( value ) ) {

            return SendServerMessage ( playerid, "/posse uninvite [oyuncu] - girilen oyuncu mevcut deðil.", MSG_TYPE_ERROR ) ;
        }

        SendPosseWarning ( posseid, sprintf("{[ %s %s (%d), %s (%d) adlý oyuncuyu gruptan çýkardý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid, ReturnUserName ( value, true ), value ));

        Character [ value ] [ character_posse ]        = -1 ;
        Character [ value ] [ character_possetier ]    = 0 ;

        Character [ value ] [ character_posserank ][0] = EOS ;
        strcat(Character [ value ] [ character_posserank ], "Yok", 36 ) ;

        SavePlayerFactionData ( value ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "tier" ) ) {

        new tier = strval ( extra ) ;

        if ( Character [ playerid ] [ character_possetier ] < 3 ) {

            return SendServerMessage ( playerid, "Bu iþlemi gerçekleþtirmek için yeterli yetkiye sahip deðilsin.", MSG_TYPE_WARN ) ;
        }

        if ( ! IsPlayerConnected ( value ) ) {

            return SendServerMessage ( playerid, "/posse tier [oyuncu] [seviye] - girilen oyuncu mevcut deðil.", MSG_TYPE_ERROR ) ;
        }
        
        if ( tier < 1 || tier > 3 ) {
            return SendServerMessage ( playerid, "Seviye 1'den küçük veya 3'ten büyük olamaz.", MSG_TYPE_WARN ) ;
        }
        
        Character [ value ] [ character_possetier ] = tier ;

        SendPosseWarning ( posseid, sprintf("{[ %s %s (%d), %s (%d) adlý oyuncunun seviyesini %d olarak ayarladý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid, ReturnUserName ( value, true ), value, tier ));

        SavePlayerFactionData ( value ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "rank" ) ) {

        if ( ! IsPlayerConnected ( value ) ) {

            return SendServerMessage ( playerid, "/posse rank [oyuncu] [rütbe] - girilen oyuncu mevcut deðil.", MSG_TYPE_ERROR ) ;
        }

        if ( Character [ playerid ] [ character_possetier ] < 2 ) {

            return SendServerMessage ( playerid, "Bu iþlemi gerçekleþtirmek için yeterli yetkiye sahip deðilsin.", MSG_TYPE_WARN ) ;
        }

        if ( strlen ( extra ) > MAX_POSSE_NAME ) {

            return SendServerMessage ( playerid, "Rütbe 36 karakterden uzun olamaz.", MSG_TYPE_WARN ) ;
        }

        Character [ value ] [ character_posserank ][0] = EOS ;
        strcat(Character [ value ] [ character_posserank ], extra, 36 ) ;

        SendPosseWarning ( posseid, sprintf("{[ %s %s (%d), %s (%d) adlý oyuncunun rütbesini %s olarak ayarladý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid, ReturnUserName ( value, true ), value, extra ));

        SavePlayerFactionData ( value ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "spawn" ) ) {

        if ( ! Character [ playerid ] [ character_posse ] ) {
            return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_INFO ) ;
        }
        
        if ( Character [ playerid ] [ character_possetier ] < 3 ) {
            return SendServerMessage ( playerid, "Bu iþlemi gerçekleþtirmek için yeterli yetkiye sahip deðilsin.", MSG_TYPE_WARN ) ;
        }

        new Float: pos_x, Float: pos_y, Float: pos_z, p_int = GetPlayerInterior ( playerid ), p_vw = GetPlayerVirtualWorld ( playerid ), query [ 256 ] ;
        GetPlayerPos ( playerid, pos_x, pos_y, pos_z ) ;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_spawn_x = '%f', posse_spawn_y = '%f', posse_spawn_z = '%f', posse_spawn_int = '%d', posse_spawn_vw = '%d' WHERE posse_id = %d", 
            pos_x, pos_y, pos_z, p_int, p_vw, posseid ) ;

        mysql_tquery ( mysql, query ) ;  

        Init_LoadPosses () ;

        return SendPosseWarning ( posseid, sprintf("{[ %s %s (%d) grup doðma noktasýný deðiþtirdi. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid ) ) ;
    }

    else if ( ! strcmp ( option, "kiosk" ) ) {

        if ( ! Character [ playerid ] [ character_posse ] ) {
            return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_INFO ) ;
        }

        return SendServerMessage(playerid,"/possekiosk komutunu kullan.",MSG_TYPE_ERROR);
    }

    else if ( ! strcmp ( option, "members" ) ) {

        new string [ 1024 ], query [ 128 ] ;
        if ( ! Character [ playerid ] [ character_posse ] ) {
            
            return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_INFO ) ;
        }


        foreach ( new i : Player ) {

            if ( Character [ i ] [ character_posse ] == posseid ) {

                strcat ( string, sprintf("{629C5C}[ÇEVRÝMÝÇÝ]:{DEDEDE} %s %s\n", Character [ i ] [ character_posserank ], ReturnUserName ( i, true ) ) ) ;
            }
            else continue;
        }

        inline posse_OfflineMembers() {

            new rows, pname[MAX_PLAYER_NAME], prank[36], bool: skipresult;

            cache_get_row_count ( rows ) ;

            if ( rows ) {

                query [ 0 ] = EOS ;

                for ( new i, j = rows; i < j; i ++ ) {

                    new char_id;
                    cache_get_value_name_int(i, "character_id", char_id ) ;

                    cache_get_value_name ( i, "character_name", pname, MAX_PLAYER_NAME ) ;
                    cache_get_value_name ( i, "character_posserank", prank, 36 ) ;

                    foreach ( new ix: Player ) {

                        if ( char_id == Character [ ix ] [ character_id ] ) {

                            skipresult = true ;
                        }

                        else continue ;
                    }

                    if ( ! skipresult ) {
                        strcat ( string, sprintf("{FF6347}[ÇEVRÝMDIÞI]:{DEDEDE} %s %s\n", prank, pname ) ) ;

                    }

                    else if ( skipresult ) {
                        skipresult = false ;
                        continue ;
                    }
                }
            }

            return ShowPlayerDialog ( playerid, 9999, DIALOG_STYLE_LIST, "Grup Üyeleri", string, "Çýkýþ", "" ) ;

        }

        return MySQL_TQueryInline ( mysql, using inline posse_OfflineMembers, "SELECT character_id, character_name, character_posserank FROM characters WHERE character_posse = %d", posseid ) ;

    }

    return SendServerMessage ( playerid, "/posse [invite, uninvite, tier, rank, spawn, members] [oyuncu: isteðe baðlý] [ekstra: isteðe baðlý]", MSG_TYPE_ERROR) ;
}

SavePlayerFactionData ( playerid ) {

    new query [ 256 ] ;

    mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET character_posse = '%d', character_possetier = '%d', character_posserank = '%s' WHERE character_id = '%d'", 
        Character [ playerid ] [ character_posse ], Character [ playerid ] [ character_possetier ], Character [ playerid ] [ character_posserank ], Character [ playerid ] [ character_id] ) ;

    mysql_tquery ( mysql, query ) ;

    return true ;
}

CMD:possechat ( playerid, params [] ) {
    new text [ 144 ], string [ 256 ], posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) ) {

        return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_INFO ) ;
    }

    if ( sscanf ( params, "s[144]", text ) ) {

        return SendServerMessage ( playerid, "/possechat <mesaj>", MSG_TYPE_ERROR ) ;
    }

    if ( ! Posse_Chat [ posseid ] && Character [ playerid ] [ character_possetier ] < 2 ) {
        return SendServerMessage ( playerid, "Grup sohbeti kapalý.", MSG_TYPE_ERROR) ;
    }

    format ( string, sizeof ( string ), "{[ %s %s (%d): %s ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, true ), playerid, text);

    SendPosseMessage ( posseid, string ) ;

    return true ;
}

CMD:pc ( playerid, params [] ) return cmd_possechat ( playerid, params ) ; 

CMD:aposse ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olman gerekiyor!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az ileri seviye moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new option [ 32 ], value, extra [ 36 ] ;

    if ( sscanf ( params, "s[32]I(0)S(-1)[36]", option, value, extra) ) {

        return SendServerMessage ( playerid, "/aposse [create, delete, leader, name, type] [ekstra: isteðe baðlý]", MSG_TYPE_ERROR ) ;
    } 

    new query [ 256 ] ;

    if ( ! strcmp ( option, "create" ) ) {

        if ( ! value || strlen ( extra ) < 0 ) {

            return SendServerMessage ( playerid, "/aposse create [slot] [isim]", MSG_TYPE_ERROR ) ;
        }

        CreatePosse ( extra, 1, value ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d) \"%s\" adlý grubu %d slot ile oluþturdu.", ReturnUserName ( playerid, true ), playerid,  extra, value ), MOD_WARNING_MED ) ;

        SendServerMessage ( INVALID_PLAYER_ID, "Grup tipini atamak için /aposse type ve /aposse leader komutlarýný kullan.", MSG_TYPE_WARN ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "delete" ) ) {

        if ( ! IsValidPosse ( value ) ) {
            
            return SendServerMessage ( playerid, "Seçilen grup mevcut deðil.", MSG_TYPE_INFO ) ;
        }

        task_yield ( 1 ) ;

        new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
        await_arr ( dialog_response ) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "{C23030}ÝSTÝSMAR UYARISI", "{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\nBir grubu silmek üzeresin.\nEðer bu seçeneði istismar edersen, tespit edilirsin ve KALICI olarak yasaklanýrsýn.\n\nBunu bilerek, devam et.", "{C23030}Onayla", "Ýptal" ) ;

        if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

            return false ;
        }

        new string [ 36 ] ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d) \"%s\" grubunu (%d) sildi.", ReturnUserName ( playerid, true ), playerid,  Posse [ value ] [ posse_name ], value ), MOD_WARNING_MED ) ;
        DeletePosse ( value );

        foreach ( new i : Player ) {

            if ( Character [ i ] [ character_posse ] == value ) {

                strcopy ( string, "Yok" );

                Character [ i ] [ character_posse ] = 0;
                Character [ i ] [ character_possetier ] = 0;
                Character [ i ] [ character_posserank ] = string;
            }

            else continue ;
        }
    }

    else if ( ! strcmp ( option, "name" ) ) {

        if ( ! IsValidPosse ( value ) ) {
            
            return SendServerMessage ( playerid, "Seçilen grup mevcut deðil.", MSG_TYPE_INFO ) ;
        }

        if ( strlen ( extra ) >= MAX_POSSE_NAME || strlen ( extra ) < 4 ) {
            
            return SendServerMessage ( playerid, "Ýsim 36 karakterden uzun veya 4 karakterden kýsa olamaz.", MSG_TYPE_INFO ) ;
        }

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_name = '%s' WHERE posse_id = %d", extra, value) ;
        mysql_tquery ( mysql, query ) ;  

        SendPosseWarning ( value, sprintf("{[ Yetkili %s (%d) grubun ismini %s olarak deðiþtirdi. ]}", ReturnUserName ( playerid, true ), playerid, extra )) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d) %d ID'li grubun ismini %s olarak deðiþtirdi.", ReturnUserName ( playerid, true ), playerid, value, extra ), MOD_WARNING_LOW ) ;

        Init_LoadPosses();
        return true ;
    }

    else if ( ! strcmp ( option, "leader" ) ) {

        if ( ! IsValidPosse ( value ) ) {
            
            return SendServerMessage ( playerid, "Seçilen grup mevcut deðil.", MSG_TYPE_INFO ) ;
        }

        Character [ playerid ] [ character_posse ]      = value ;
        Character [ playerid ] [ character_possetier ]  = 3 ;

        Character [ playerid] [ character_posserank ] [ 0 ] = EOS ;
        strcat(Character [ playerid ] [ character_posserank ], "Yetkili", 36 ) ;

        SendPosseWarning ( value, sprintf("{[ Yetkili %s (%d) kendini grubun lideri yaptý. ]}", ReturnUserName ( playerid, true ), playerid )) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d) kendini %d ID'li grubun lideri yaptý.", ReturnUserName ( playerid, true ), playerid, value ), MOD_WARNING_MED ) ;

        SavePlayerFactionData ( playerid ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "type" ) ) {

        if ( ! IsValidPosse ( value ) ) {
            
            return SendServerMessage ( playerid, "Seçilen grup mevcut deðil.", MSG_TYPE_INFO ) ;
        }

        new type = strval ( extra ) ;
        Posse [ value ] [ posse_type ] = type ;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_type = '%d' WHERE posse_id = %d", type, Posse [ value ] [ posse_id ] ) ;
        mysql_tquery ( mysql, query ) ;  

        SendPosseWarning ( value, sprintf("{[ Yetkili %s (%d) grubun tipini %d olarak deðiþtirdi. ]}", ReturnUserName ( playerid, true ), playerid, type ) ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d) %d ID'li grubun tipini %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, value, type ), MOD_WARNING_LOW ) ;
        
        Init_LoadPosses();

        return true ;
    }


    return true ;
}

CMD:possebank( playerid, params [] ) {
    new option [ 16 ], amount, cents, query [ 256 ], posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) ) {

        return SendServerMessage ( playerid, "Bir grupta (posse) deðilsin.", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerInRangeOfPoint ( playerid, 3.5, Posse [ posseid ] [ posse_spawn_x ], Posse [ posseid ] [ posse_spawn_y ], Posse [ posseid ] [ posse_spawn_z ] ) ) {

        return SendServerMessage ( playerid, "Grubunun doðma noktasýnda deðilsin.", MSG_TYPE_ERROR ) ;
    }

    if ( sscanf ( params, "s[16]I(-1)I(0)", option, amount, cents ) ) {

        return SendServerMessage ( playerid, "/p(osse)bank [balance, deposit, withdraw] [isteðe baðlý: dolar] [isteðe baðlý: cent]", MSG_TYPE_ERROR ) ;
    }

    if ( !strcmp ( option, "balance", true) ) {

        return SendServerMessage ( playerid, sprintf( "%s Banka Bakiyesi: $%s.%02d", Posse [ posseid ] [ posse_name ], IntegerWithDelimiter ( Posse [ posseid ] [ posse_bank ] ),Posse[posseid][posse_bank_decimal] ), MSG_TYPE_INFO ) ;
    }

    else if ( !strcmp ( option, "deposit", true) ) {

        if ( amount == -1 ) {

            return SendServerMessage ( playerid, "Bir deðer girmelisin.", MSG_TYPE_ERROR ) ;
        }

        if ( Character [ playerid ] [ character_handmoney ] < amount ) {

            return SendServerMessage ( playerid, "Yatýrmak için yeterli paran yok.", MSG_TYPE_ERROR ) ;
        }

        if(cents < 1 || cents > 99) {

            return SendServerMessage(playerid,"Sadece 1-99 arasý cent girebilirsin.", MSG_TYPE_ERROR);
        }

        task_yield(1);

        new dialog_response[e_DIALOG_RESPONSE_INFO];
        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "{C23030}UYARI", "{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\nParaný grup bankasýna yatýrmak üzeresin.\nTier 3 yetkisine sahip olmadan paraný geri çekemezsin.\n\nBunu bilerek, devam et.", "{C23030}Onayla", "Ýptal" ) ;

        if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

            return false ;
        }

        Posse [ posseid ] [ posse_bank ] += amount ;
        if(cents) { Posse [ posseid ] [ posse_bank_decimal ] += cents; }
        TakeCharacterMoney ( playerid, amount, MONEY_SLOT_HAND ) ;
        if(cents) { TakeCharacterChange(playerid,cents,MONEY_SLOT_HAND); }

        SendPosseMessage ( posseid, sprintf("%s (%d), grup bankasýna $%s.%02d yatýrdý.", ReturnUserName ( playerid, true ), playerid, IntegerWithDelimiter( amount ),cents ) ) ;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_bank = '%d', posse_bank_decimal = '%d' WHERE posse_id = %d", Posse [ posseid ] [ posse_bank ], Posse [ posseid ] [posse_bank_decimal], Posse [ posseid ] [ posse_id ] ) ;
        mysql_tquery ( mysql, query ) ;
    }

    else if ( !strcmp ( option, "withdraw", true) ) {

        if ( Character [ playerid ] [ character_possetier ] < 3 ) {

            return SendServerMessage ( playerid, "Bu iþlemi gerçekleþtirmek için yeterli yetkiye sahip deðilsin.", MSG_TYPE_WARN ) ;   
        }

        if ( amount == -1 ) {

            return SendServerMessage ( playerid, "Bir deðer girmelisin.", MSG_TYPE_ERROR ) ;
        }

        if ( Posse [ posseid ] [ posse_bank ] < amount ) {

            return SendServerMessage ( playerid, "Grup bankasýnda çekilecek kadar para yok.", MSG_TYPE_ERROR ) ;
        }

        if(cents < 1 || cents > 99) {

            return SendServerMessage(playerid,"Sadece 1-99 arasý cent çekebilirsin.", MSG_TYPE_ERROR);
        }

        task_yield(1);

        new dialog_response[e_DIALOG_RESPONSE_INFO];
        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "{C23030}ÝSTÝSMAR UYARISI", "{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\nGrup bankasýndan para çekmek üzeresin.\nBunun istismarý tespit edilmene ve /KALICI/ olarak yasaklanmana yol açar.\n\nBunu bilerek, devam et.", "{C23030}Onayla", "Ýptal" ) ;

        if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

            return false ;
        }

        Posse [ posseid ] [ posse_bank ] -= amount ;
        if(cents) { Posse[posseid][posse_bank_decimal] -= cents; }
        GiveCharacterMoney ( playerid, amount, MONEY_SLOT_HAND ) ;
        if(cents) { GiveCharacterChange(playerid,cents,MONEY_SLOT_HAND); }

        SendPosseMessage ( posseid, sprintf("%s (%d), grup bankasýndan $%s.%02d çekti.", ReturnUserName ( playerid, true ), playerid, IntegerWithDelimiter( amount ),cents ) ) ;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_bank = '%d', posse_bank_decimal = '%d' WHERE posse_id = %d", Posse [ posseid ] [ posse_bank ], Posse [ posseid ] [ posse_bank_decimal], Posse [ posseid ] [ posse_id ] ) ;
        mysql_tquery ( mysql, query ) ; 
    }

    return true ;
}

CMD:pbank ( playerid, params [] ) return cmd_possebank ( playerid, params ) ;
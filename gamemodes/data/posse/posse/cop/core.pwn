#include <cuffs>

IsLawEnforcementPosse ( posseid ) {

    if ( posseid == -1 ) {

        return false ;
    }

    if ( Posse [ posseid ] [ posse_type ] == 1 || Posse [ posseid ] [ posse_type ] == 2 ) {

        return true ;
    }

    return false ;
}


new IsPlayerTackled [ MAX_PLAYERS ] ;
CMD:tackle ( playerid, params [] ) {

    new posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    new closest = INVALID_PLAYER_ID, Float: x, Float: y, Float: z ;

    foreach(new i: Player) {

        if ( i == playerid ) {

            continue ;
        }

        if ( IsPlayerTackled [ i ] ) {

            continue ;
        }

        if ( IsPlayerRidingHorse [ i ] ) {

            IsPlayerRidingHorse [ i ] = false ;
            SendServerMessage ( playerid, "Atýndan düþürdün!", MSG_TYPE_INFO ) ;

            RemovePlayerAttachedObject(playerid, 6);
            ClearAudioForZone ( playerid ) ;
        }

        GetPlayerPos ( i, x, y, z ) ;

        if ( IsPlayerInRangeOfPoint ( playerid, 3.5, x, y, z ) ) {

            closest = i ;
            break ;
        }

        else continue ;
    }

    if ( closest == INVALID_PLAYER_ID || ! IsPlayerConnected (closest )) {

        return SendServerMessage ( playerid, "Yakýnýnda kimse yok!", MSG_TYPE_ERROR ) ;
    }

    TogglePlayerControllable ( closest, false ) ;

    new Float: angle ;

    GetPlayerFacingAngle(playerid, angle ) ;
    SetPlayerFacingAngle ( closest, angle ) ;

    AnimationLoop(playerid, "PED", "EV_dive", 4.1, false, true, true, true, 0, SYNC_ALL);
    AnimationLoop(closest, "PED", "EV_dive", 4.1, false, true, true, true, 0, SYNC_ALL);

    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s, %s kiþisini yere devirdi.", ReturnUserName ( playerid, false ), ReturnUserName ( closest, false ) )) ;
    SendServerMessage ( closest, sprintf(" (%d) %s tarafýndan yere devrildin. Kýsa bir süre hareket edemeyeceksin. Lütfen rolüne uygun davran.", playerid, ReturnUserName ( playerid, true )), MSG_TYPE_ERROR );

    SetTimerEx("TackleUnfreeze", 60000, false, "i", closest) ;
    SetTimerEx("TackleAnimFix", 1000, false, "i", playerid);

    IsPlayerTackled [ closest ] = true ;

    return true ;
}

forward TackleAnimFix(playerid);
public TackleAnimFix(playerid) {

    return AnimationLoop(playerid,"PED", "FLOOR_hit_f", 4.1, false, true, true, true, 1, SYNC_ALL); 
}

forward TackleUnfreeze(playerid);
public TackleUnfreeze(playerid) {

    SendServerMessage ( playerid, "Yere devrilme etkisinden kurtuldun. Baþýn biraz dönüyor, dikkatli ol.", MSG_TYPE_WARN ) ;

    TogglePlayerControllable ( playerid, true ) ;
    IsPlayerTackled [ playerid ] = false ;

    return AnimationLoop(playerid,"PED", "FLOOR_hit_f", 4.1, false, true, true, true, 1, SYNC_ALL); 
}


new bool: playerCuffed [ MAX_PLAYERS ] ;
CMD:prisoners ( playerid, params [] ) {

    new posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    if ( GetPointIDFromType ( playerid, POINT_TYPE_SHERIFF ) == -1 ) {

        return SendServerMessage ( playerid, "Þerif ofisinde deðilsin!", MSG_TYPE_ERROR );
    }

    new count ;

    SendServerMessage ( playerid, "Mahkum listesi:", MSG_TYPE_INFO ) ;

    foreach ( new i : Player ) {

        if ( Character [ i ] [ character_prison ] ) {

            SendClientMessage(playerid, -1, sprintf("(%d) %s: %d dakika hapis cezasý kaldý", i, ReturnUserName ( i ), (Character [ i ] [ character_prison] - gettime()) / 60 ) );
            count ++ ;
        }

        else continue;
    }


    if ( ! count ) {

        return SendClientMessage ( playerid, -1, "Þu an hapis cezasý çeken mahkum bulunmuyor." ) ;
    }

    return true ;
}

CMD:cuff ( playerid, params [] ) {

    new targetid, Float: pos_x, Float: pos_y, Float: pos_z, posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    if ( sscanf ( params, "k<u>", targetid ) ) {

        return SendServerMessage ( playerid, "/cuff [oyuncu_id(target)]", MSG_TYPE_ERROR ) ;
    }

    GetPlayerPos ( targetid, pos_x, pos_y, pos_z ) ;

    if ( IsPlayerInRangeOfPoint ( playerid, 2.5, pos_x, pos_y, pos_z ) && GetPlayerInterior ( playerid ) == GetPlayerInterior ( targetid ) && GetPlayerVirtualWorld ( playerid ) == GetPlayerVirtualWorld ( targetid ) ) {

        playerCuffed [ targetid ] = !playerCuffed [ targetid ] ; 

        if ( playerCuffed [ targetid ] ) { 
        
            if ( ReturnItemByParam ( playerid, SHERIFF_HANDCUFFS, true ) != -1 ) {
            
                SetPlayerCuffed ( targetid, true ) ; 
                DecreaseItem ( playerid, ReturnItemByParam ( playerid, SHERIFF_HANDCUFFS, true ), 1 ) ;
            }

            else {

                playerCuffed [ targetid ] = false;
                return SendServerMessage ( playerid, "Birini kelepçelemek için kelepçeye ihtiyacýn var!", MSG_TYPE_ERROR ) ;
            }

        }
        else { 

            SetPlayerCuffed ( targetid, false ) ; 

            if ( ! IsPlayerInvFull ( playerid ) ) {

                GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SHERIFF_HANDCUFFS, 1, 0, SHERIFF_HANDCUFFS, 0 ) ;
            }
        }

        SendServerMessage ( playerid, sprintf("Baþarýyla %s kiþisini %s.", ( playerCuffed [ targetid ] ) ? ( "kelepçeledin" ) : ( "kelepçeden çýkardýn" ), ReturnUserName ( targetid, false, true ) ), MSG_TYPE_INFO ) ;
        SendServerMessage ( targetid, sprintf("Bir yetkili tarafýndan %s.", ( playerCuffed [ targetid ] ) ? ( "kelepçelendin" ) : ( "kelepçen açýldý" ) ), MSG_TYPE_INFO ) ;

        ProxDetector ( playerid, 30.0, COLOR_ACTION, sprintf("%s, %s kiþisini %s.",ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false, true ), ( playerCuffed [ targetid ] ) ? ( "kelepçeledi" ) : ( "kelepçesini açtý" ) ) );

    }

    else return SendServerMessage ( playerid, "Hedeflediðin kiþi yakýnýnda deðil.", MSG_TYPE_ERROR ) ;

    return true ;
}

CMD:disarm ( playerid, params [] ) {

    new targetid, Float: pos_x, Float: pos_y, Float: pos_z, posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid )) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    if ( sscanf ( params, "k<u>", targetid ) ) {

        return SendServerMessage ( playerid, "/disarm [oyuncu_id(target)]", MSG_TYPE_ERROR ) ;
    }

    GetPlayerPos ( targetid, pos_x, pos_y, pos_z ) ;

    if ( IsPlayerInRangeOfPoint ( playerid, 2.5, pos_x, pos_y, pos_z ) && GetPlayerInterior ( playerid ) == GetPlayerInterior ( targetid ) && GetPlayerVirtualWorld ( playerid ) == GetPlayerVirtualWorld ( targetid ) ) {

        SendServerMessage ( playerid, sprintf ( "%s kiþisine silahsýzlandýrma isteði gönderildi.", ReturnUserName ( targetid, false ) ), MSG_TYPE_INFO ) ;

        task_yield(1);

        new dialog_response[e_DIALOG_RESPONSE_INFO];
        await_arr(dialog_response) ShowPlayerAsyncDialog(targetid, DIALOG_STYLE_MSGBOX, "{C23030}UYARI", sprintf ( "{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\n%s %s seni silahsýzlandýrmak üzere.\nBu diyalog kötüye kullanýmý önlemek içindir, ancak her þey rol icabý yapýlýyorsa reddedemezsin.\n\nEðer %s %s bu komutu kötüye kullanýyorsa, forumdan þikayet et ve /report kullan. Aksi takdirde, Devam et butonuna týkla.", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, false ), Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, false ) ), "{C23030}Devam Et", "Ýptal" ) ; 

        if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

            return false ;
        }          

        RemovePlayerWeapon ( targetid ) ;

        Character [ targetid ] [ character_pantsweapon ] = WEAPON_FIST;
        Character [ targetid ] [ character_pantsammo ] = 0;

        Character [ targetid ] [ character_backweapon ] = WEAPON_FIST;
        Character [ targetid ] [ character_backammo ] = 0;

        SavePlayerWeapons ( targetid ) ;

        if ( DoesPlayerHaveItem ( playerid, CARD_GUNPERMIT ) != -1 ) {

            DiscardItem ( playerid, DoesPlayerHaveItem ( playerid, CARD_GUNPERMIT ) ) ;
        }

        SendServerMessage ( playerid, sprintf("Baþarýyla %s kiþisini silahsýzlandýrdýn.", ReturnUserName ( targetid, false, true ) ), MSG_TYPE_INFO ) ;
        SendServerMessage ( targetid, sprintf("%s seni silahsýzlandýrdý.", ReturnUserName ( playerid, false, true ) ), MSG_TYPE_INFO ) ;

        ProxDetector ( playerid, 30.0, COLOR_ACTION, sprintf("%s, %s kiþisini silahsýzlandýrdý.",ReturnUserName ( playerid, false, true ), ReturnUserName ( targetid, false, true ) ) );
    
    }

    else return SendServerMessage ( playerid, "Hedeflediðin kiþi yakýnýnda deðil.", MSG_TYPE_ERROR ) ;

    return true ;
}

CMD:clearcharge ( playerid, params [] ) {

    new posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) ||  !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    if ( GetPointIDFromType ( playerid, POINT_TYPE_SHERIFF ) == -1 ) {

        return SendServerMessage ( playerid, "Þerif ofisinde deðilsin!", MSG_TYPE_ERROR );
    }

    new targetid, chargeid;

    if ( sscanf ( params, "k<u>i", targetid, chargeid ) ) {

        return SendServerMessage ( playerid, "/clearcharge [oyuncu_id(target)] [suç_id(chargeid)]", MSG_TYPE_ERROR ) ;
    }

    new query [ 256 ] ;

    inline CheckPlayerCharge() {

        new rows;
        cache_get_row_count ( rows ) ;

        if ( rows ) {

            for ( new i; i < ReturnChargeCount ( targetid ); i++ ) {

                if ( Charge [ targetid ] [ i ] [ charge_id ] == chargeid ) {

                    SendServerMessage ( playerid, sprintf("Baþarýyla %s kiþisinin $%i tutarýndaki suç kaydýný sildin.", ReturnUserName ( targetid, false ), Charge [ targetid ] [ i ] [ charge_amount ] ), MSG_TYPE_INFO ) ;

                    SendPosseWarning ( posseid, sprintf("%s %s, %s kiþisinin $%i tutarýndaki suç kaydýný sildi.", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ), Charge [ targetid ] [ i ] [ charge_amount ] ) ) ;

                    TakeCharacterMoney ( targetid, Charge [ targetid ] [ i ] [ charge_amount ], MONEY_SLOT_HAND ) ;

                    Posse [ posseid ] [ posse_bank ] += Charge [ targetid ] [ i ] [ charge_amount ] ;
                    Posse [ posseid ] [ posse_bank_decimal ] += Charge [ targetid ] [ i ] [ charge_change ] ;

                    Charge [ targetid ] [ i ] [ charge_amount ] = 0;
                    Charge [ targetid ] [ i ] [ charge_change ] = 0;

                    Init_LoadCharges ( targetid ) ;

                    mysql_format ( mysql, query, sizeof ( query ), "UPDATE charges SET charge_amount = %d, charge_change = %d WHERE charge_id = %d", Charge [ targetid ] [ i ] [ charge_amount ], Charge [ targetid ] [ i ] [ charge_change], chargeid ) ;
                    mysql_tquery ( mysql, query ) ; 

                    mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_bank = %d, posse_bank_decimal = %d WHERE posse_id = %d", Posse [ posseid ] [ posse_bank ], Posse[posseid][posse_bank_decimal], posseid ) ;
                    return mysql_tquery ( mysql, query ) ;
                }

                else continue;
            }

            return SendServerMessage ( playerid, "Bir hata oluþtu, ekran görüntüsü alýp geliþtiriciye gönder.", MSG_TYPE_ERROR ) ;
        }
        
        else {

            return SendServerMessage ( playerid, "Bu ID ile eþleþen bir suç kaydý bulunamadý.", MSG_TYPE_ERROR ) ;
        }
    }

    MySQL_TQueryInline(mysql, using inline CheckPlayerCharge, "SELECT charge_amount FROM charges WHERE charge_id = %d AND charge_holder = '%e'", chargeid, ReturnUserName ( targetid, true ) );

    return true ;
}

CMD:viewcharges ( playerid, params [] ) {

    new posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) ||  !IsLawEnforcementPosse ( posseid )) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    new user[MAX_PLAYER_NAME];

    if ( sscanf ( params, "s["#MAX_PLAYER_NAME"]", user ) ) {

        return SendServerMessage ( playerid, "/viewcharges [oyuncu_ismi]", MSG_TYPE_ERROR ) ;
    }

    if ( GetPointIDFromType ( playerid, POINT_TYPE_SHERIFF ) == -1 ) {

        return SendServerMessage ( playerid, "Þerif ofisinde deðilsin!", MSG_TYPE_ERROR );
    }

    new string [ 512 ] ;

    inline charge_PlayerCharges() {

        new rows;

        cache_get_row_count ( rows ) ;

        if ( rows ) {

            new cid, cplacer[MAX_PLAYER_NAME], camount, ccents, camounttotal,ccenttotal,cinfo[32];

            for ( new i, j = rows; i < j; i++ ) {
                
                cache_get_value_name_int ( i, "charge_id", cid ) ;
                cache_get_value_name ( i, "charge_placer", cplacer, MAX_PLAYER_NAME ) ;
                cache_get_value_name_int ( i, "charge_amount", camount ) ;
                cache_get_value_name_int ( i, "charge_change", ccents ) ;
                cache_get_value_name ( i, "charge_info", cinfo, 32 ) ;

                camounttotal += camount;
                ccenttotal += ccents;
                if(ccenttotal >= 100) {

                    camounttotal++;
                    ccenttotal = 0;
                }

                strcat ( string, sprintf("Suç ID: %i - Ekleyen: %s - Tutar: $%i.%02d - Bilgi: %s\n", cid, cplacer, camount, ccents, cinfo ) ) ;
            }

            strcat ( string, sprintf("\nToplam Ceza Tutarý: $%d.%02d",camounttotal,ccenttotal));

            ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, sprintf("%s'in Suç Kayýtlarý", user ), string, "Çýkýþ", "" );
        }

        else {

            return SendServerMessage ( playerid, "Bu oyuncunun suç kaydý yok veya oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
        }

    }

    MySQL_TQueryInline ( mysql, using inline charge_PlayerCharges, "SELECT charge_id, charge_placer, charge_amount, charge_info FROM charges WHERE charge_holder = '%e'", user ) ;

    return true ;
}

CMD:viewdebt(playerid, params [] ) {
    new posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) ||  !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    new targetid ;

    if ( sscanf ( params, "k<u>", targetid ) ) {

        return SendServerMessage ( playerid, "/viewdebt [oyuncu_id(target)]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( targetid ) ) {

        return SendServerMessage ( playerid, "Oyuncu çevrimdýþý.", MSG_TYPE_ERROR ) ;
    }   

    if ( Character [ targetid ] [ character_bankmoney ] < 0 ) {

        SendServerMessage ( playerid, "Ýþlem yapmadan önce oyuncunun IC ismini bildiðinden emin ol, aksi takdirde metagaming nedeniyle hapse girebilirsin.", MSG_TYPE_WARN ) ;
        return SendServerMessage ( playerid, sprintf("(%d) %s devlete $%s borçlu.", targetid, ReturnUserName ( targetid ), IntegerWithDelimiter (Character [ targetid ] [ character_bankmoney ])), MSG_TYPE_WARN ) ;
    }

    else return SendServerMessage ( playerid, sprintf("(%d) %s devlete borçlu deðil.", targetid, ReturnUserName ( targetid )), MSG_TYPE_WARN ) ;
}
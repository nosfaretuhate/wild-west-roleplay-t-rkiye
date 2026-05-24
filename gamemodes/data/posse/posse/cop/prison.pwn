#define MAX_PRISON_TIME     (130)

ptask PlayerPrisonTimer[60000](playerid) {

////    print("PlayerPrisonTimer timer called (prison.pwn)");

    if ( Character [ playerid ] [ character_prison ] != 0) {

        if ( Character [ playerid ] [ character_prison ] < gettime ( ) ) {

            new id = GetPointIDFromType ( playerid, POINT_TYPE_SHERIFF ), query [ 512 ] ;

            Character [ playerid ] [ character_prison ] = 0;

            Character [ playerid ] [ character_prison_pos_x ] = 0.0;
            Character [ playerid ] [ character_prison_pos_y ] = 0.0;
            Character [ playerid ] [ character_prison_pos_z ] = 0.0;

            Character [ playerid ] [ character_prison_interior ] = 0 ;
            Character [ playerid ] [ character_prison_vw ] = 0 ;
            Character [ playerid ] [ character_prison_bail] = 0 ;

            mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_prison = %d, character_prison_pos_x = '%f', character_prison_pos_y = '%f',character_prison_pos_z = '%f', character_prison_interior = %d, character_prison_vw = %d WHERE character_id = %d",
                Character [ playerid ] [ character_prison ], Character [ playerid ] [ character_prison_pos_x ], Character [ playerid ] [ character_prison_pos_y ], Character [ playerid ] [ character_prison_pos_z ], Character [ playerid ] [ character_prison_interior ], Character [ playerid ] [ character_prison_vw ], Character [ playerid ] [ character_id ] ) ;
            mysql_tquery ( mysql, query );

            if(id != -1) {
                
                ac_SetPlayerPos ( playerid, Point [ id ] [ point_ext_x ], Point [ id ] [ point_ext_y ], Point [ id ] [ point_ext_z ] ) ;

                SetPlayerInterior ( playerid, Point [ id ] [ point_int ] ) ;
                SetPlayerVirtualWorld ( playerid, Point [ id ] [ point_vw ] ) ;
            }

            else {

                ac_SetPlayerPos(playerid,SERVER_SPAWN_X,SERVER_SPAWN_Y,SERVER_SPAWN_Z);

                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
            }

            SendClientMessage ( playerid, COLOR_DEFAULT, "Cezaný tamamladýn ve serbest býrakýldýn." ) ;
        }
    }
}

CMD:prisontimeleft ( playerid, params [] ) {

    if ( Character [ playerid ] [ character_prison ] != 0 ) {

        if ( Character [ playerid ] [ character_prison ] > gettime() ) {

            return SendServerMessage ( playerid, sprintf("Kalan hapis süren: %d dakika", (Character [ playerid ] [ character_prison ] - gettime()) / 60), MSG_TYPE_INFO ) ;
        }

        else if ( Character [ playerid ] [ character_prison ] < gettime() ) {

            return SendServerMessage ( playerid, "Kalan hapis süren: 1 dakikadan az.", MSG_TYPE_INFO ) ;
        }
    }

    else SendServerMessage ( playerid, "Hapiste deðilsin!", MSG_TYPE_ERROR ) ;

    return true ;
}

CMD:prison ( playerid, params [] ) { // time, reason

    new user, time, posseid = Character [ playerid ] [ character_posse ], bail, cents ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }

    if ( sscanf ( params, "k<u>iI(0)", user, time, bail, cents)) {

        return SendServerMessage ( playerid, "Kullaným: /prison [oyuncu_id] [süre: dakika] [kefalet: dolar, yoksa 25 yaz. Kapatmak için 0] [opsiyonel: cent]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( user ) ) {

        return SendServerMessage ( playerid, "Bu oyuncu baðlý deðil!", MSG_TYPE_INFO ) ;  
    }

    if ( time > MAX_PRISON_TIME ) {

        return SendServerMessage ( playerid, "Birini 130 dakikadan fazla hapsedemezsin.", MSG_TYPE_WARN ) ;
    }

    if ( Character [ user ] [ character_prison ] ) {

        return SendServerMessage ( playerid, "Bu oyuncu zaten hapiste!", MSG_TYPE_WARN ) ;
    }

    if ( bail < 0 ) {

        return SendServerMessage(playerid, "Kefalet ücretini negatif yapamazsýn.", MSG_TYPE_WARN);
    }

    if ( cents < 0 || cents > 99 ) {

        return SendServerMessage(playerid, "Cent miktarýný 1-99 arasýnda seçebilirsin.",MSG_TYPE_WARN);
    }

    task_yield ( 1 ) ;

    new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "{C23030}UYARI", sprintf("{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\n%s kiþisini %i %s hapse atmak üzeresin.\nSürenin doðru olduðundan ve %s kiþisinin bir hücrede olduðundan emin ol.\n\nEðer hazýrsan devam et.", ReturnUserName ( user, false ), time, (time == 1) ? ( "dakika" ) : ( "dakika" ), ReturnUserName ( user, false ) ), "{C23030}Devam Et", "Ýptal" ) ;       

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        return false ;
    }

    new Float: pos_x, Float: pos_y, Float: pos_z, query [ 512 ] ;            

    GetPlayerPos ( user, pos_x, pos_y, pos_z ) ;

    Character [ user ] [ character_prison ] = gettime() + ( time * 60 ) ;

    Character [ user ] [ character_prison_pos_x ] = pos_x;
    Character [ user ] [ character_prison_pos_y ] = pos_y;
    Character [ user ] [ character_prison_pos_z ] = pos_z;

    Character [ user ] [ character_prison_interior ] = GetPlayerInterior ( user ) ;
    Character [ user ] [ character_prison_vw ] = GetPlayerVirtualWorld ( user ) ;

    Character [ user ] [ character_prison_bail] = bail ;
    Character [ user ] [ character_prison_bail_cents ] = cents ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_prison = %d, character_prison_pos_x = '%f', character_prison_pos_y = '%f',character_prison_pos_z = '%f', character_prison_interior = %d, character_prison_vw = %d, character_prison_bail = %d, character_prison_bail_cents = %d WHERE character_id = %d",
            Character [ user ] [ character_prison ], Character [ user ] [ character_prison_pos_x ], Character [ user ] [ character_prison_pos_y ], Character [ user ] [ character_prison_pos_z ], Character [ user ] [ character_prison_interior ], Character [ user ] [ character_prison_vw ], Character [ user ] [ character_prison_bail], Character [ user ] [ character_prison_bail_cents], Character [ user ] [ character_id ] ) ;
    mysql_tquery ( mysql, query );

    SendServerMessage ( user, sprintf("%i dakika süreliðine hapsedildin.", time ), MSG_TYPE_INFO ) ;

    SendPosseWarning ( posseid, sprintf("{[ %s %s, %s kiþisini %i dakika hapse attý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, false, false ), ReturnUserName ( user, false, false ), time ) ) ;

    WriteLog ( playerid, "prison", sprintf("%s (%d) kiþisi, %s kiþisini %i dakika hapse attý.", ReturnUserName ( playerid, false, false ), ReturnUserName ( user, false, false ), time ) ) ;

    return true ;
}

CMD:unprison ( playerid, params [] ) { 

    new targetid, Float: pos_x, Float: pos_y, Float: pos_z, posseid = Character [ playerid ] [ character_posse ] ;

    if ( ! IsPlayerInPosse ( playerid ) || !IsLawEnforcementPosse ( posseid ) ) {

        return SendServerMessage ( playerid, "Bu komutu kullanmak için bir kolluk kuvveti grubunda olmalýsýn.", MSG_TYPE_INFO ) ;
    }


    if ( sscanf ( params, "k<u>", targetid )) {

        return SendServerMessage ( playerid, "Kullaným: /unprison [oyuncu_id]", MSG_TYPE_ERROR ) ;
    }

    if ( !Character [ targetid ] [ character_prison ] ) {

        return SendServerMessage ( playerid, "Bu oyuncu hapiste deðil!", MSG_TYPE_WARN ) ;
    }

    GetPlayerPos ( targetid, pos_x, pos_y, pos_z ) ;

    if ( IsPlayerInRangeOfPoint ( playerid, 2.5, pos_x, pos_y, pos_z ) && GetPlayerInterior ( playerid ) == GetPlayerInterior ( targetid ) && GetPlayerVirtualWorld ( playerid ) == GetPlayerVirtualWorld ( targetid ) ) {

        new id = GetPointIDFromType ( targetid, POINT_TYPE_SHERIFF ), query [ 512 ] ;

        Character [ targetid ] [ character_prison ] = 0 ;

        Character [ targetid ] [ character_prison_pos_x ] = 0.0;
        Character [ targetid ] [ character_prison_pos_y ] = 0.0;
        Character [ targetid ] [ character_prison_pos_z ] = 0.0;

        Character [ targetid ] [ character_prison_interior ] = 0 ;
        Character [ targetid ] [ character_prison_vw ] = 0 ;
        Character [ targetid ] [ character_prison_bail] = 0 ;
        Character [ targetid ] [ character_prison_bail_cents ] = 0 ;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_prison = %d, character_prison_pos_x = '%f', character_prison_pos_y = '%f',character_prison_pos_z = '%f', character_prison_interior = %d, character_prison_vw = %d, character_prison_bail = %d, character_prison_bail_cents = %d WHERE character_id = %d",
                Character [ targetid ] [ character_prison ], Character [ targetid ] [ character_prison_pos_x ], Character [ targetid ] [ character_prison_pos_y ], Character [ targetid ] [ character_prison_pos_z ], Character [ targetid ] [ character_prison_interior ], Character [ targetid ] [ character_prison_vw ], Character [ targetid ] [ character_prison_bail ], Character [ targetid ] [ character_prison_bail_cents], Character [ targetid ] [ character_id ] ) ;
        mysql_tquery ( mysql, query );

        if(id != -1) {
            
            ac_SetPlayerPos ( targetid, Point [ id ] [ point_ext_x ], Point [ id ] [ point_ext_y ], Point [ id ] [ point_ext_z ] ) ;

            SetPlayerInterior ( targetid, Point [ id ] [ point_int ] ) ;
            SetPlayerVirtualWorld ( targetid, Point [ id ] [ point_vw ] ) ;
        }
        else {

            ac_SetPlayerPos(targetid,SERVER_SPAWN_X,SERVER_SPAWN_Y,SERVER_SPAWN_Z);

            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }

        SendServerMessage ( targetid, sprintf("%s %s tarafýndan hapisten çýkarýldýn.", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, false ) ), MSG_TYPE_INFO ) ;

        SendPosseWarning ( posseid, sprintf("{[ %s %s, %s kiþisini hapisten çýkardý. ]}", Character [ playerid ] [ character_posserank ], ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ) ) ) ;
    }

    else return SendServerMessage ( playerid, "O oyuncunun yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;

    return true ;
}


CMD:bail ( playerid, params [ ] ) {

    if ( ! Character [ playerid ] [ character_prison ] ) {

        return SendServerMessage ( playerid, "Hapiste deðilsin. Eðer olduðunu düþünüyorsan bir yetkiliye ulaþ.", MSG_TYPE_ERROR ) ;
    }

    if ( ! Character [ playerid ] [ character_prison_bail ] ) {

        if ( ! Character [ playerid ] [ character_prison_bail_cents] ) { return SendServerMessage ( playerid, "Kefaret ödemeye uygun deðilsin.", MSG_TYPE_ERROR ) ; }
    }

    if ( Character [ playerid ] [ character_prison_bail ] > Character [ playerid ] [ character_handmoney ] || (Character[playerid][character_handmoney] > Character[playerid][character_prison_bail] && Character[playerid][character_handchange] < Character[playerid][character_prison_bail_cents])) {

        return SendServerMessage ( playerid, sprintf("Kefalet için yeterli paran yok! Toplam: $%s.%02d",IntegerWithDelimiter(Character[playerid][character_prison_bail]),Character[playerid][character_prison_bail_cents]), MSG_TYPE_ERROR ) ;
    }


    for ( new i; i < MAX_POSSES; i ++ ) {

        if ( Posse [ i ] [ posse_id ] != -1 ) {

            if ( Posse [ i ] [ posse_type ] == 2 ) {

                Posse [ i ] [ posse_bank ] += Character [ playerid ] [ character_prison_bail ] ;
                Posse [ i ] [ posse_bank_decimal ] += Character[playerid][character_prison_bail_cents];
                SendPosseMessage ( i, sprintf("{[ %s (%d) kefaletini ödedi. ]}", ReturnUserName ( playerid, false, false ), playerid ) ) ;
                break;
            }
        }
    }

    SendServerMessage ( playerid, "Cezanýn bedelini ödedin.", MSG_TYPE_INFO ) ;
    new id = GetPointIDFromType ( playerid, POINT_TYPE_SHERIFF ), query [ 512 ] ;

    Character [ playerid ] [ character_prison ] = 0 ;

    Character [ playerid ] [ character_prison_pos_x ] = 0.0;
    Character [ playerid ] [ character_prison_pos_y ] = 0.0;
    Character [ playerid ] [ character_prison_pos_z ] = 0.0;

    Character [ playerid ] [ character_prison_interior ] = 0 ;
    Character [ playerid ] [ character_prison_vw ] = 0 ;
    Character [ playerid ] [ character_prison_bail] = 0 ;
    Character [ playerid ] [ character_prison_bail_cents ] = 0 ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_prison = %d, character_prison_pos_x = '%f', character_prison_pos_y = '%f',character_prison_pos_z = '%f', character_prison_interior = %d, character_prison_vw = %d, character_prison_bail = %d, character_prison_bail_cents = %d WHERE character_id = %d",
            Character [ playerid ] [ character_prison ], Character [ playerid ] [ character_prison_pos_x ], Character [ playerid ] [ character_prison_pos_y ], Character [ playerid ] [ character_prison_pos_z ], Character [ playerid ] [ character_prison_interior ], Character [ playerid ] [ character_prison_vw ], Character [ playerid ] [ character_prison_bail ], Character [ playerid ] [ character_prison_bail_cents], Character [ playerid ] [ character_id ] ) ;
    mysql_tquery ( mysql, query );

    if(id != -1) {
            
        ac_SetPlayerPos ( playerid, Point [ id ] [ point_ext_x ], Point [ id ] [ point_ext_y ], Point [ id ] [ point_ext_z ] ) ;

        SetPlayerInterior ( playerid, Point [ id ] [ point_int ] ) ;
        SetPlayerVirtualWorld ( playerid, Point [ id ] [ point_vw ] ) ;
    }
    else {

        ac_SetPlayerPos(playerid,SERVER_SPAWN_X,SERVER_SPAWN_Y,SERVER_SPAWN_Z);

        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }

    return true; 
}
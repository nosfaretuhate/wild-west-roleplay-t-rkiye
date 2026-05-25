CMD:attributes ( playerid, params [] ){

    new attributes [ 144 ] ;

    if ( sscanf ( params, "s[144]", attributes ) ) {

        return SendServerMessage ( playerid, "/attributes [yazı]", MSG_TYPE_ERROR ) ;
    }

    if ( strlen ( attributes ) > 144 || strlen ( attributes ) < 1 ) {

        return SendServerMessage ( playerid, "Özellik mesajın 144 karakterden uzun veya 1 karakterden kısa olamaz!", MSG_TYPE_ERROR ) ;
    }

    Character [ playerid ] [ character_attributes] [ 0 ] = EOS ;
    strcat ( Character [ playerid ] [ character_attributes], attributes, 144 ) ;

    new query [ 256 ] ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_attributes= '%e' WHERE character_id = '%d'",
    attributes, Character [ playerid ] [ character_id ]  ) ;

    mysql_tquery ( mysql, query ) ;

    SendClientMessage(playerid, COLOR_ACTION, sprintf("** Özellik mesajı: %s kişisinin özellikleri: %s", ReturnUserName ( playerid, true ), attributes ) ) ;

    return true ;
}

CMD:att(playerid, params[]){
    return cmd_attributes(playerid, params);
}


CMD:examine ( playerid, params [] ) {

    new targetid ;

    if ( sscanf ( params, "u", targetid ) ) {

        return SendServerMessage ( playerid, "/examine [hedef]", MSG_TYPE_ERROR ) ;
    }

    if ( targetid == INVALID_PLAYER_ID ) {

        return SendServerMessage ( playerid, "Oyuncu bağlı değil gibi görünüyor.", MSG_TYPE_ERROR ) ;
    }

    if ( targetid == playerid ) {

        SendClientMessage(targetid, COLOR_ACTION, sprintf("** Özellik mesajı: %s kişisinin özellikleri: %s", ReturnUserName ( targetid, true ), Character [ targetid ] [ character_attributes ] ) ) ;
    }

    SetPlayerChatBubble(targetid, sprintf("%s kişisinin özellikleri: %s", ReturnUserName ( targetid, true ), Character [ targetid ] [ character_attributes ]), COLOR_ACTION, 20.0, 10000 ) ;
 
    return true ;
}
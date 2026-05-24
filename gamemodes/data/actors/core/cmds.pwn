CMD:actorhelp ( playerid, params [] ) {

    SendClientMessage ( playerid, ADMIN_ORANGE, "Kullanabileceðiniz aktör komutlarý" ) ;
    
    SendClientMessage ( playerid, ADMIN_LIGHTGREY, "/actorgoto, /actormove, /actorsetangle" ) ;
    SendClientMessage ( playerid, ADMIN_LIGHTGREY, "/actorsettype, /actorsetskin, /actorsetvw" ) ;

    return true ;
}

CMD:actorsetanim ( playerid, params [] ) {

    new actorid, animlib [ 32 ], animname [ 32] ;

    if ( sscanf ( params, "is[32]s[32]", actorid, animlib, animname )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actorsetanim [id] [animlib] [animname]" ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    if ( ! IsValidActorAnim ( animlib ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Girdiðiniz animasyon kütüphanesi geçerli deðil." ) ;
    }

    new query [ 256 ] ;

    ApplyActorAnimation ( actorid, animlib, animname, 4.1, true, false, false, false, 0 ) ;
    
    Actor [ actorid ] [ actor_animlib ] = animlib ;
    Actor [ actorid ] [ actor_animname ] = animname ;   

    ApplyActorAnimation ( actorid, Actor [ actorid ] [ actor_animlib ], Actor [ actorid ] [ actor_animname ], 4.1, true, false, false, false, 0 ) ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE actors SET actor_animlib = '%s', actor_animname = '%s' WHERE actor_id = '%d'",
        animlib, animname, actorid + 1);

    mysql_tquery ( mysql, query ) ;

    format ( query, sizeof ( query ), "[i]{B5B5B5} Not:{ffffff} ID %d olan aktörün animasyonu baþarýyla \"%s\", \"%s\" olarak ayarlandý.", actorid, animlib, animname);
    SendClientMessage ( playerid, ADMIN_BLUE, query ) ;

    return true ;
}

CMD:actorgoto ( playerid, params [] ) {
    new actorid ;

    if ( sscanf ( params, "i", actorid )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actorgoto [id]" ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    new Float: actor_p_x, Float: actor_p_y, Float: actor_p_z ;
    GetActorPos ( actorid, actor_p_x, actor_p_y, actor_p_z ) ;
    
    ac_SetPlayerPos ( playerid, actor_p_x, actor_p_y, actor_p_z ) ;
    
    return true ;

}

CMD:actormove ( playerid, params [] ) {

    new actorid ;

    if ( sscanf ( params, "i", actorid )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actormove [id]" ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    new Float: actor_p_x, Float: actor_p_y, Float: actor_p_z, playerVW, query [ 256 ] ;

    GetPlayerPos ( playerid, actor_p_x, actor_p_y, actor_p_z ) ;
    playerVW = GetPlayerVirtualWorld ( playerid ) ; 

    SetActorPos ( actorid, actor_p_x, actor_p_y, actor_p_z ) ;
    SetActorVirtualWorld ( actorid, playerVW ) ;

    Actor [ actorid ] [ actor_x_pos ] = actor_p_x ;
    Actor [ actorid ] [ actor_y_pos ] = actor_p_y ;
    Actor [ actorid ] [ actor_z_pos ] = actor_p_z ;


    Actor [ actorid ] [ actor_vw ] = playerVW ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE actors SET actor_x_pos = '%f', actor_y_pos = '%f', actor_z_pos = '%f', actor_vw = '%d' WHERE actor_id = '%d'",
        Actor [ actorid ] [ actor_x_pos ], Actor [ actorid ] [ actor_y_pos ], Actor [ actorid ] [ actor_z_pos ], playerVW, actorid + 1);

    mysql_tquery ( mysql, query ) ;

    format ( query, sizeof ( query ), "[i]{B5B5B5} Not:{ffffff} ID %d olan aktör baþarýyla bulunduðunuz konuma taþýndý.", actorid);
    SendClientMessage ( playerid, ADMIN_BLUE, query ) ;

    SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Aktörün bakýþ açýsýný ayarlamak için /actorsetangle komutunu kullanabilirsiniz." ) ;

    UpdateActorInfoString ( actorid ) ;

    return true ;
}

CMD:actorsetangle ( playerid, params [] ) {

    new actorid, Float: faceangle ;

    if ( sscanf ( params, "if", actorid, faceangle )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actorsetangle [id] [açý]" ) ;
    }

    if ( faceangle < 0 || faceangle > 360 ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Açý deðeri 0'dan küçük veya 360'tan büyük olamaz." ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    new query [ 256 ] ;

    SetActorFacingAngle ( actorid, faceangle ) ;
    Actor [ actorid ] [ actor_a_pos ] = faceangle ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE actors SET actor_a_pos = '%f' WHERE actor_id = '%d'",
        Actor [ actorid ] [ actor_a_pos ], actorid + 1);

    mysql_tquery ( mysql, query ) ;

    format ( query, sizeof ( query ), "[i]{B5B5B5} Not:{ffffff} ID %d olan aktörün bakýþ açýsý baþarýyla %f olarak ayarlandý.", actorid, faceangle);
    SendClientMessage ( playerid, ADMIN_BLUE, query ) ;

    UpdateActor ( actorid ) ;

    return true ;
}

CMD:actorsettype ( playerid, params [] ) {

    new actorid, type ;

    if ( sscanf ( params, "ii", actorid, type )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actorsettype [id] [tip]" ) ;
    }

    if ( type < 0 || type > 5 ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Tip deðeri 0'dan küçük veya 5'ten büyük olamaz." ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    new query [ 256 ] ;

    Actor [ actorid ] [ actor_type ] = type ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE actors SET actor_type = '%d' WHERE actor_id = '%d'",
        Actor [ actorid ] [ actor_type ], actorid + 1);

    mysql_tquery ( mysql, query ) ;

    format ( query, sizeof ( query ), "[i]{B5B5B5} Not:{ffffff} ID %d olan aktörün tipi baþarýyla %d olarak ayarlandý.", actorid, type);
    SendClientMessage ( playerid, ADMIN_BLUE, query ) ;

    UpdateActorInfoString ( actorid ) ;

    return true ;
}

CMD:actorsetskin ( playerid, params [] ) {

    new actorid, skin ;

    if ( sscanf ( params, "ii", actorid, skin )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actorsetskin [id] [skin]" ) ;
    }

    if ( ! IsValidSkin ( skin ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Girdiðiniz skin ID geçerli deðil." ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    new query [ 256 ] ;

    Actor [ actorid ] [ actor_skinid ] = skin ;
    UpdateActor ( actorid ) ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE actors SET actor_skinid = '%d' WHERE actor_id = '%d'",
        Actor [ actorid ] [ actor_skinid ], actorid + 1);

    mysql_tquery ( mysql, query ) ;

    format ( query, sizeof ( query ), "[i]{B5B5B5} Not:{ffffff} ID %d olan aktörün skini baþarýyla %d olarak ayarlandý.", actorid, skin);
    SendClientMessage ( playerid, ADMIN_BLUE, query ) ;

    return true ;
}

CMD:actorsetvw ( playerid, params [] ) {

    new actorid, vw ;

    if ( sscanf ( params, "ii", actorid, vw )) {
        return SendClientMessage ( playerid, ADMIN_RED, "[!]{B5B5B5} Kullaným:{ffffff} /actorsetvw [id] [vw]" ) ;
    }

    if ( vw < 0 ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Sanal dünya (virtual world) deðeri 0'dan küçük olamaz." ) ;
    }

    if ( ! IsValidActor ( actorid ) ) {
        return SendClientMessage ( playerid, ADMIN_BLUE, "[i]{B5B5B5} Not:{ffffff} Bu aktör geçerli deðil." ) ;
    }

    new query [ 256 ] ;

    Actor [ actorid ] [ actor_vw ] = vw ;
    SetActorVirtualWorld ( actorid, vw ) ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE actors SET actor_vw = '%d' WHERE actor_id = '%d'",
        Actor [ actorid ] [ actor_vw ], actorid + 1);

    mysql_tquery ( mysql, query ) ;

    format ( query, sizeof ( query ), "[i]{B5B5B5} Not:{ffffff} ID %d olan aktörün sanal dünyasý baþarýyla %d olarak ayarlandý.", actorid, vw);
    SendClientMessage ( playerid, ADMIN_BLUE, query ) ;

    return true ;
}
GivePlayerExperience ( playerid, amount ) {

    #if !defined EXP_INCR
        #define EXP_INCR    (8)
    #endif

    new query [ 256 ] ;

    Character [ playerid ] [ character_expleft ] -= amount ;

    SendServerMessage ( playerid, sprintf("Size %d tecrübe puaný verildi. Seviye atlamak için %d tecrübe puanýna ihtiyacýnýz var.", amount, Character [ playerid ] [ character_expleft ]), MSG_TYPE_INFO ) ;

    if ( Character [ playerid ] [ character_expleft ] <= 0 ) {

        Character [ playerid ] [ character_level ] ++ ;
        Character [ playerid ] [ character_expleft ] = EXP_INCR * Character [ playerid ] [ character_level ] ;
        Character [ playerid ] [ character_skillpoints ] += 1 ;

        SendServerMessage ( playerid, sprintf("Yeni bir seviye kazandýnýz! Artýk %d. seviyesiniz. Tekrar seviye atlamak için %d tecrübe puanýna ihtiyacýnýz olacak.", Character [ playerid ] [ character_level ], Character [ playerid ] [ character_expleft ] ), MSG_TYPE_INFO );
        SendServerMessage ( playerid, sprintf("Size bir yetenek puaný verildi. Þu an %d yetenek puanýnýz var. Kullanmak için /skills komutunu kullanýn.", Character [ playerid ] [ character_skillpoints ] ), MSG_TYPE_INFO );


        SetPlayerScore ( playerid, Character [ playerid ]  [ character_level ]) ;

        if(Character[playerid][character_level] >= 5 && Account[playerid][account_rulecheck] == 1) {

            Account[playerid][account_rulecheck] = 0;
            mysql_format(mysql,query,sizeof(query),"UPDATE master_accounts SET account_rulecheck = %d WHERE account_id = %d",Account[playerid][account_rulecheck],Account[playerid][account_id]);
            mysql_tquery(mysql,query);
        }
    }

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_level = '%d', character_expleft = '%d', character_skillpoints ='%d' WHERE character_id = '%d'",
        Character [ playerid ] [ character_level ], Character [ playerid ] [ character_expleft ], Character [ playerid ] [ character_skillpoints ], Character [ playerid ] [ character_id ]) ;

    mysql_tquery ( mysql, query ) ;

    #if defined EXP_INCR
        #undef EXP_INCR
    #endif

    return true ;
}
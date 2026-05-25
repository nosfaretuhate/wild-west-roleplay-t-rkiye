new IsPlayerMasked [ MAX_PLAYERS ] ;

CMD:resyncmask ( playerid, params [] ) {

    if ( ! Character [ playerid ] [ character_mask ] ) {

        return SendServerMessage ( playerid, "Bir masken yok. Kýyafet maðazasýndan bir tane satýn almalýsýn.", MSG_TYPE_ERROR ) ;
    }

    if ( IsPlayerMasked [ playerid ] ) {

        switch ( Character [ playerid ] [ character_mask ] ) {
            case 1: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18919, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 2: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18912, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 3: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18913, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 4: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18918, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 5: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18911, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 6: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 11704, 2, 0.086534, 0.095857, 0.003273, -90.629531, 101.533355, 269.223754,0.254000,0.369999,0.360000);

        }
    }

    else return SendServerMessage ( playerid, "Maskeli deðilsin - /mask komutunu kullan.", MSG_TYPE_ERROR ) ;

    return true ;
}

CMD:editmask ( playerid, params [] ) {
 
    if ( ! Character [ playerid ] [ character_mask ] ) {

        return SendServerMessage ( playerid, "Bir masken yok. Kýyafet maðazasýndan bir tane satýn almalýsýn.", MSG_TYPE_ERROR ) ;
    }

    if ( IsPlayerMasked [ playerid ] ) {

        switch ( Character [ playerid ] [ character_mask ] ) {
            case 1: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18919, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 2: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18912, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 3: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18913, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 4: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18918, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 5: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18911, 2, 0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754); 
            case 6: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 11704, 2, 0.086534, 0.095857, 0.003273, -90.629531, 101.533355, 269.223754, 0.254000, 0.369999,0.360000);

        }

        EditAttachedObject(playerid, ATTACH_SLOT_MASK) ;
        SendServerMessage ( playerid, "Artýk maskeyi düzenleyebilirsin. Hatýrlatma: bir eþya kuþandýðýnda maske çýkacaktýr.", MSG_TYPE_ERROR ) ;
    }

    else return SendServerMessage ( playerid, "Maskeli deðilsin - /mask komutunu kullan.", MSG_TYPE_ERROR ) ;

    return true ;
}

CMD:mask ( playerid, params [] ) {

    if ( Character [ playerid ] [ character_level ] < 10 ) {

        return SendServerMessage ( playerid, "Maske kullanabilmek için en az 10. seviye olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    if ( ! Character [ playerid ] [ character_mask ] ) {

        return SendServerMessage ( playerid, "Bir masken yok. Kýyafet maðazasýndan bir tane satýn almalýsýn.", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerMasked [ playerid ] ) {

        switch ( Character [ playerid ] [ character_mask ] ) {
            case 1: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18919, 2, Character [ playerid ] [ character_mask_offsetx ], Character [ playerid ] [ character_mask_offsety ], Character [ playerid ] [ character_mask_offsetz ], Character [ playerid ] [ character_mask_rotx ], Character [ playerid ] [ character_mask_roty ], Character [ playerid ] [ character_mask_rotz ], Character [ playerid ] [ character_mask_scalex ], Character [ playerid ] [ character_mask_scaley ], Character [ playerid ] [ character_mask_scalez ] ); 
            case 2: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18912, 2, Character [ playerid ] [ character_mask_offsetx ], Character [ playerid ] [ character_mask_offsety ], Character [ playerid ] [ character_mask_offsetz ], Character [ playerid ] [ character_mask_rotx ], Character [ playerid ] [ character_mask_roty ], Character [ playerid ] [ character_mask_rotz ], Character [ playerid ] [ character_mask_scalex ], Character [ playerid ] [ character_mask_scaley ], Character [ playerid ] [ character_mask_scalez ] );
            case 3: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18913, 2, Character [ playerid ] [ character_mask_offsetx ], Character [ playerid ] [ character_mask_offsety ], Character [ playerid ] [ character_mask_offsetz ], Character [ playerid ] [ character_mask_rotx ], Character [ playerid ] [ character_mask_roty ], Character [ playerid ] [ character_mask_rotz ], Character [ playerid ] [ character_mask_scalex ], Character [ playerid ] [ character_mask_scaley ], Character [ playerid ] [ character_mask_scalez ] );
            case 4: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18918, 2, Character [ playerid ] [ character_mask_offsetx ], Character [ playerid ] [ character_mask_offsety ], Character [ playerid ] [ character_mask_offsetz ], Character [ playerid ] [ character_mask_rotx ], Character [ playerid ] [ character_mask_roty ], Character [ playerid ] [ character_mask_rotz ], Character [ playerid ] [ character_mask_scalex ], Character [ playerid ] [ character_mask_scaley ], Character [ playerid ] [ character_mask_scalez ] );
            case 5: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 18911, 2, Character [ playerid ] [ character_mask_offsetx ], Character [ playerid ] [ character_mask_offsety ], Character [ playerid ] [ character_mask_offsetz ], Character [ playerid ] [ character_mask_rotx ], Character [ playerid ] [ character_mask_roty ], Character [ playerid ] [ character_mask_rotz ], Character [ playerid ] [ character_mask_scalex ], Character [ playerid ] [ character_mask_scaley ], Character [ playerid ] [ character_mask_scalez ] ); 
            case 6: SetPlayerAttachedObject(playerid, ATTACH_SLOT_MASK, 11704, 2, Character [ playerid ] [ character_mask_offsetx ], Character [ playerid ] [ character_mask_offsety ], Character [ playerid ] [ character_mask_offsetz ], Character [ playerid ] [ character_mask_rotx ], Character [ playerid ] [ character_mask_roty ], Character [ playerid ] [ character_mask_rotz ], Character [ playerid ] [ character_mask_scalex ], Character [ playerid ] [ character_mask_scaley ], Character [ playerid ] [ character_mask_scalez ] );
        }
        
        IsPlayerMasked [ playerid ] = true ;
        SendServerMessage ( playerid, "Maskeni taktýn. Maskeni göremiyorsan /editmask komutunu kullan, çünkü henüz doðru ayarlanmamýþ olabilir!", MSG_TYPE_WARN ) ;
    }

    else if ( IsPlayerMasked [ playerid ] ) {

        IsPlayerMasked [ playerid ] = false ;
        RemovePlayerAttachedObject(playerid, ATTACH_SLOT_MASK ) ;
        SendServerMessage ( playerid, "Maskeni çýkardýn.", MSG_TYPE_INFO) ; 
    }

    SetName ( playerid, sprintf("(%d) %s", playerid, ReturnUserName ( playerid, false, true ) ), 0xCFCFCFFF ) ;

    return true ;
}

ReturnPlayerMasked ( playerid ) {

    return IsPlayerMasked [ playerid ] ;
}

ShowMaskSelection ( playerid ) {

    task_yield ( 1 ) ;

    new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
    await_arr ( dialog_response ) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Mask Selection", "18919\tBeyaz Bandana ($5.00)\n18912\tSiyah Bandana ($7.00)\n18913\tYeþil Bandana ($7.00)\n18918\tZeytin Rengi Bandana ($10.00)\n18911\tKuru Kafa Bandana ($10.00)", "Seç", "Ýptal");

    PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        return false ;
    }

    switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {

        case 0: {

            if ( Character [ playerid ] [ character_handmoney ] < 5 ) {

                return SendServerMessage ( playerid, "Bunu satýn almak için en az $5'a ihtiyacýn var.", MSG_TYPE_ERROR ) ;
            }

            TakeCharacterMoney ( playerid, 5, MONEY_SLOT_HAND ) ;

            Character [ playerid ] [ character_mask ] = 1 ;
            SendServerMessage ( playerid, "Beyaz bandanayý $5 karþýlýðýnda satýn aldýn. Artýk /mask komutunu kullanabilirsin.", MSG_TYPE_INFO ) ;
        }

        case 1: {
            if ( Character [ playerid ] [ character_handmoney ] < 7 ) {

                return SendServerMessage ( playerid, "Bunu satýn almak için en az $7'a ihtiyacýn var.", MSG_TYPE_ERROR ) ;
            }

            TakeCharacterMoney ( playerid, 7, MONEY_SLOT_HAND ) ;

            Character [ playerid ] [ character_mask ] = 2 ;
            SendServerMessage ( playerid, "Siyah bandanayý $7 karþýlýðýnda satýn aldýn. Artýk /mask komutunu kullanabilirsin.", MSG_TYPE_INFO ) ;
        }

        case 2: {
            if ( Character [ playerid ] [ character_handmoney ] < 7 ) {

                return SendServerMessage ( playerid, "Bunu satýn almak için en az $7'a ihtiyacýn var.", MSG_TYPE_ERROR ) ;
            }

            TakeCharacterMoney ( playerid, 7, MONEY_SLOT_HAND ) ;

            Character [ playerid ] [ character_mask ] = 3 ;
            SendServerMessage ( playerid, "Yeþil bandanayý $7 karþýlýðýnda satýn aldýn. Artýk /mask komutunu kullanabilirsin.", MSG_TYPE_INFO ) ;
        }

        case 3: {
            if ( Character [ playerid ] [ character_handmoney ] < 10 ) {

                return SendServerMessage ( playerid, "Bunu satýn almak için en az $10'a ihtiyacýn var.", MSG_TYPE_ERROR ) ;
            }

            TakeCharacterMoney ( playerid, 10, MONEY_SLOT_HAND ) ;

            Character [ playerid ] [ character_mask ] = 4 ;
            SendServerMessage ( playerid, "Zeytin rengi bandanayý $10 karþýlýðýnda satýn aldýn. Artýk /mask komutunu kullanabilirsin.", MSG_TYPE_INFO ) ;
        }

        case 4: {
            if ( Character [ playerid ] [ character_handmoney ] < 10 ) {

                return SendServerMessage ( playerid, "Bunu satýn almak için en az $10'a ihtiyacýn var.", MSG_TYPE_ERROR ) ;
            }

            TakeCharacterMoney ( playerid, 10, MONEY_SLOT_HAND ) ;

            Character [ playerid ] [ character_mask ] = 5 ;
            SendServerMessage ( playerid, "Kuru kafa bandanayý $10 karþýlýðýnda satýn aldýn. Artýk /mask komutunu kullanabilirsin.", MSG_TYPE_INFO ) ;
        }
    }

    new query [ 256 ] ; 

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_mask = %d WHERE character_id = '%d'", 
        Character [ playerid ] [ character_mask ],  Character [ playerid ] [ character_id ]) ;

    mysql_tquery ( mysql, query ) ;

    return true ;
}
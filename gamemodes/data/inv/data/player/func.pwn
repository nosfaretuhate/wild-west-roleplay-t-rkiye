#if defined _inc_func
    #undef _inc_func
#endif

new PlayerItemPassCooldown [ MAX_PLAYERS ] ;

PassItem ( playerid, tileid, error = 0 ) {

    if ( tileid == -1 ) {

        return false ;
    }

    task_yield ( 1 ) ;

    new info [ 256 ], dialog_response [ e_DIALOG_RESPONSE_INFO ] ;

    switch ( error ) {

        case 0: info = "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin." ;
        case 1: info = "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin.\nGerçekten bir isim veya oyuncu ID'si girmelisiniz.";
        case 2: info = "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin.\nOyuncu sunucuya baðlý görünmüyor.";
        case 3: info = "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin.\nKendinize eþya veremezsiniz.";
        case 4: format ( info, sizeof ( info ), "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin.\nBaþka bir eþya göndermeden önce %d saniye beklemelisiniz.", PlayerItemPassCooldown[playerid] - gettime () ) ;
        case 5: info = "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin.\nEþyayý vermeye çalýþtýðýnýz oyuncunun yeterli envanter alaný yok.";
        case 6: info = "Eþyayý vermek istediðiniz oyuncunun ID'sini veya adýný girin.\nEþyayý vermeye çalýþtýðýnýz oyuncuya yeterince yakýn deðilsiniz.";
    }

    await_arr ( dialog_response ) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Oyuncuya Eþya Ver", info, "Devam Et", "Ýptal" ) ;

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        return false ;
    }

    if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        new targetid ;

        new Float: tX, Float: tY, Float: tZ;
        GetPlayerPos(targetid, tX, tY, tZ);

        if ( sscanf ( dialog_response [ E_DIALOG_RESPONSE_InputText ], "k<u>", targetid ) ) {

            return PassItem ( playerid, tileid, 1 ) ;
        }

        if ( ! IsPlayerConnected ( targetid ) ) {

            return PassItem ( playerid, tileid, 2 ) ;
        }

        if ( targetid == playerid ) {

            return PassItem ( playerid, tileid, 3 ) ;
        }

        if ( PlayerItemPassCooldown [ playerid ]  >= gettime ()) {

            return PassItem ( playerid, tileid, 4 ) ;
        }

        if( ReturnPlayerItemCount [ playerid ] >= MAX_PLAYER_ITEMS ){

            return PassItem ( playerid, tileid, 5 ) ;
        }

        if(! IsPlayerInRangeOfPoint ( playerid, 3.0, tX, tY, tZ ) ){

            return PassItem ( playerid, tileid, 6 );
        }

        PlayerItemPassCooldown [ playerid ] = gettime () + 5 ;

        new dialog_response_x [ e_DIALOG_RESPONSE_INFO ] ;
        await_arr ( dialog_response_x ) ShowPlayerAsyncDialog(targetid, DIALOG_STYLE_MSGBOX, "Oyuncuya Eþya Ver: Transfer Ýsteði", \
            sprintf("(%d) %s size %d adet %s vermek istiyor.", playerid, ReturnUserName ( playerid ), PlayerItem [ playerid ] [ tileid ] [ player_item_amount ], Item [ PlayerItem [ playerid ] [ tileid ] [ player_item_id ] ] [ item_name ] ), \
        "Kabul Et", "Reddet" ) ;

        if ( ! dialog_response_x[E_DIALOG_RESPONSE_Response] ) {

            return SendServerMessage ( playerid, 
                sprintf("%s eþya transferi isteðinizi reddetti.", ReturnUserName ( targetid ) ), MSG_TYPE_ERROR ) ;
        }

        else if ( dialog_response_x[E_DIALOG_RESPONSE_Response] ) {

            new itemid = PlayerItem [ playerid ] [ tileid ] [ player_item_id ], amount = PlayerItem [ playerid ] [ tileid ] [ player_item_amount ], param1 = PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ], param2 = PlayerItem [ playerid ] [ tileid ] [ player_item_param2 ];
            if ( GivePlayerItem ( targetid, PlayerItem [ playerid ] [ tileid ] [ player_item_id ], PlayerItem [ playerid ] [ tileid ] [ player_item_amount ], 
                PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ], PlayerItem [ playerid ] [ tileid ] [ player_item_param2 ], 0 ) ) {

                if(DiscardItem ( playerid, tileid )){

                    WriteLog ( playerid, "inv/pass", sprintf("** %s passed %s their %s [amount: %d] [params: %d | %d ].", ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ), Item [ itemid ] [ item_name ], amount, param1, param2 )) ;
                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("** %s, %s isimli oyuncuya %s verdi.", ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ), Item [ itemid ] [ item_name ])) ;

                }
            }

            else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Karþý tarafa sorun bildirildi.", MSG_TYPE_ERROR ) ;
        }

        WriteLog ( playerid, "inv/pass", sprintf("** %s offered %s their %s [amount: %d] [params: %d | %d ].", ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ), Item [ PlayerItem [ playerid ] [ tileid ] [ player_item_id ] ] [ item_name ], PlayerItem [ playerid ] [ tileid ] [ player_item_amount ], PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ], PlayerItem [ playerid ] [ tileid ] [ player_item_param2 ] )) ;
        ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("** %s, %s isimli oyuncuya bir %s teklif etti.", ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ), Item [ PlayerItem [ playerid ] [ tileid ] [ player_item_id ] ] [ item_name ])) ; 

        return 1;
    }

    return true ;
}

SplitItem ( playerid, itemid, amount, itemparam1, itemparam2, tileid ) {

    new query [ 256 ], viewing_inventory = IsPlayerViewingInventory [ playerid ] ;

    if ( ReturnPlayerItemCount [ playerid ] >= MAX_PLAYER_ITEMS ) {

        return SendServerMessage ( playerid, "Yeterli envanter slotunuz yok!", MSG_TYPE_ERROR) ;
    }

    if ( PlayerItem [ playerid ] [ tileid ] [ player_item_amount ] <= 1 ) {

        return SendServerMessage ( playerid, "Bu eþyayý ayýrabilmek için bir gruptan (stack) fazlasýna sahip olmalýsýnýz.", MSG_TYPE_ERROR ) ;
    }

    for(new i=0; i<MAX_PLAYER_ITEMS; i++) {
        
        if(PlayerItem[playerid][i][player_item_id] == INVALID_ITEM_ID) {

            PlayerItem[playerid][i][player_item_id] = itemid;
            PlayerItem[playerid][i][player_item_amount] = amount;
            PlayerItem[playerid][i][player_item_param1] = itemparam1;
            PlayerItem[playerid][i][player_item_param2] = itemparam2;

            inline SplitItemQuery() {

                PlayerItem[playerid][i][player_table_id] = cache_insert_id();

                query [ 0 ] = EOS ;
    
                SendServerMessage ( playerid, sprintf("(%d) %s eþyanýzý %d adetlik yeni bir gruba ayýrdýnýz.", itemid,  Item [ itemid ] [ item_name ], amount ), MSG_TYPE_INFO ) ;

                ToggleInventory ( playerid, INV_MAX_TILES, false ) ;
                HideInventoryExamineGUI ( playerid ) ;


                WriteLog ( playerid, "inv/split", sprintf("** %s split their %s. [new amount: %d, amount to have: %d]", ReturnUserName ( playerid, false ), Item [ itemid ] [ item_name ], PlayerItem [ playerid ] [ tileid ] [ player_item_amount ], amount )) ;


                if ( viewing_inventory ) {


                    SendServerMessage ( playerid, "Envanter yenileniyor, lütfen biraz bekleyin.", MSG_TYPE_WARN ) ;
                    SetTimerEx("DelayedInventory", 750, false, "i", playerid);
                }
            }

            MySQL_TQueryInline(mysql,using inline SplitItemQuery,"INSERT INTO `items_player`(player_database_id, player_item_id, player_item_amount, player_item_param1, player_item_param2) VALUES (%d, %d, %d, %d, %d)",
                Character [ playerid ] [ character_id ], itemid, amount, itemparam1, itemparam2);
            return true;
        }
        else { continue; }
    }

    return SendServerMessage(playerid,"Eþya ayrýlýrken bir þeyler ters gitti, hiçbir þey deðiþtirilmedi.",MSG_TYPE_ERROR);
}

// StackItem ( playerid, tileid ) {


// 	new item_id = PlayerItem [ playerid ] [ tileid ] [ player_item_id ],
// 		item_amount = PlayerItem [ playerid ] [ tileid ] [ player_item_amount ],
// 		item_param1 = PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ],
// 		item_param2 = PlayerItem [ playerid ] [ tileid ] [ player_item_param2 ],

// 	viewing_inventory = IsPlayerViewingInventory [ playerid ] ;

// 	if ( GivePlayerItem ( playerid, item_id, item_amount, item_param1, item_param2, 0 ) ) {
// 		ToggleInventory ( playerid, INV_MAX_TILES, false ) ;
// 		HideInventoryExamineGUI ( playerid ) ;

// 		Init_LoadPlayerItems ( playerid ) ;

// 		if ( viewing_inventory ) {

// 			//Init_LoadPlayerItems ( playerid ) ;

// 			SendServerMessage ( playerid, "Refreshing inventory, hold on a moment.", MSG_TYPE_WARN ) ;
// 			defer DelayedInventory(playerid);
// 		}

// 		DiscardItem ( playerid, tileid ) ;
// 		SendServerMessage ( playerid, "Stacked this item with other entities that share it's values. If the item isn't stacked, there weren't any matching entities.", MSG_TYPE_ERROR ) ;
// 	}

// 	else return SendServerMessage ( playerid, "GivePlayerItem function returned false. This means the item didn't properly stack due to an issue. You should still have it.", MSG_TYPE_ERROR ) ;

// 	return true ;
// }
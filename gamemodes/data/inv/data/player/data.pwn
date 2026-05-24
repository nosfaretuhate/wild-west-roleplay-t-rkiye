#if defined _inc_data
	#undef _inc_data
#endif

enum player_itemData {
	player_table_id,
	player_item_id,
	player_item_amount,
	player_item_param1,
	player_item_param2
} ;

new PlayerItem [ MAX_PLAYERS ] [ MAX_ITEMS ] [ player_itemData ], ReturnPlayerItemCount [ MAX_PLAYERS ];

Init_LoadPlayerItems ( playerid ) {
	new query [ 256 ] ;

	for ( new i; i < MAX_ITEMS; i ++ ) {
		PlayerItem [ playerid ] [ i ] [ player_item_id ] = INVALID_ITEM_ID ;
	}

	PlayerItemsLoaded [ playerid ] = false ;

	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM items_player WHERE player_database_id = %d", Character [ playerid ] [ character_id ] );
	return mysql_tquery ( mysql, query, "LoadPlayerItemData", "i", playerid ) ;
}

forward LoadPlayerItemData ( playerid ) ;
public LoadPlayerItemData ( playerid ) {
	new rows ;

	cache_get_row_count ( rows ) ;

    if ( rows ) {

		ReturnPlayerItemCount [ playerid ] = rows ;

		for ( new i, j = rows; i < j; i ++ ) {

			cache_get_value_int ( i, "player_table_id",		PlayerItem [ playerid ] [ i ] [ player_table_id ] ) ;
			cache_get_value_int ( i, "player_item_id",		PlayerItem [ playerid ] [ i ] [ player_item_id ] ) ;
			cache_get_value_int ( i, "player_item_amount",	PlayerItem [ playerid ] [ i ] [ player_item_amount ] ) ;

			cache_get_value_int ( i, "player_item_param1",	PlayerItem [ playerid ] [ i ] [ player_item_param1 ] ) ;
			cache_get_value_int ( i, "player_item_param2",	PlayerItem [ playerid ] [ i ] [ player_item_param2 ] ) ;

			//printf("Loaded item for playerid %d (%d); %d; %d",
			//	playerid, PlayerItem [ playerid ] [ i ] [ player_item_id ], ReturnPlayerItemCount [ playerid ], PlayerItem [ playerid ] [ i ] [ player_item_amount ] ) ;

   		 	PlayerItemsLoaded [ playerid ] = false ;
		}

		printf("oyuncu envanteri yuklendi. (%d) %s", playerid, ReturnUserName ( playerid, true ) ) ;

	    HideInventoryExamineGUI ( playerid ) ;
	    PlayerItemsLoaded [ playerid ] = true ;
	}

	else if ( ! rows ) {

		ReturnPlayerItemCount [ playerid ] = 0 ;
	}

	HasPlayerInventoryUpdated[playerid] = false;

	return true ;
}
GivePlayerItem ( playerid, itemid, itemamount, itemparam1, itemparam2, price, cents = 0, showmsg = 1) {

    new query [ 512 ] ;

    if(itemid == -1) {

        SendServerMessage(playerid, sprintf("Eþya ID'si -1 döndürdü, lütfen bunu bir geliþtiriciye bildirin ve/veya hata raporu oluþturun. [%d|%d]",itemparam1,itemparam2),MSG_TYPE_ERROR);
        return false;
    }

    if ( ReturnPlayerItemCount [ playerid ] >= GetPlayerBackpackSize ( playerid ) ) {

        SendServerMessage ( playerid, "Bu eþyayý yerden almak için yeterli çanta alanýnýz yok. Daha büyük bir çanta almalýsýnýz.", MSG_TYPE_ERROR ) ;
        return false ;
    }
    
    if ( ReturnPlayerItemCount [ playerid ] >= MAX_PLAYER_ITEMS ) {

        if ( ! price ) {
            SendServerMessage ( playerid, "Yeterli envanter slotunuz yok! Eþya yere düþürüldü.", MSG_TYPE_ERROR) ;

            new Float: x, Float: y, Float: z ;

            GetPlayerPos ( playerid, x, y, z ) ;

            mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO dropped_items (dropped_player, dropped_item, dropped_amount, dropped_param1, dropped_param2, dropped_pos_x, dropped_pos_y, dropped_pos_z, dropped_int, dropped_vw) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', %d, %d)",
                Character[playerid][character_id], itemid, itemamount, itemparam1, itemparam2, x, y, z - 0.75, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ) ) ;
            mysql_tquery (mysql, query ) ;


            Init_LoadDropItems () ;
        }

        else if ( price ) {
            
            SendServerMessage ( playerid, "Yeterli envanter slotunuz yok! Ýþlem iptal edildi.", MSG_TYPE_ERROR) ;
        }

        return false ;
    }

    if ( Character [ playerid ] [ character_handmoney ] < price ) {

        if(cents != 0) { SendServerMessage ( playerid, sprintf("Bir %s satýn almak için yeterli paranýz yok. En az $%d.%02d gerekiyor.", Item [ itemid ] [ item_name ], price,cents ), MSG_TYPE_ERROR) ; }
        else { SendServerMessage ( playerid, sprintf("Bir %s satýn almak için yeterli paranýz yok. En az $%d gerekiyor.", Item [ itemid ] [ item_name ], price ), MSG_TYPE_ERROR) ; }
        return false ;
    }

    if(cents != 0) {
        
        if ( Character [ playerid ] [ character_handmoney ] == price && Character [ playerid ] [ character_handchange ] < cents) {

            SendServerMessage ( playerid, sprintf("Bir %s satýn almak için yeterli paranýz yok. En az $%d.%02d gerekiyor.", Item [ itemid ] [ item_name ], price,cents ), MSG_TYPE_ERROR) ;
            return false ;
        }
    }

    if(itemamount > Item[itemid][item_stack]) { 

        itemamount = Item[itemid][item_stack];
    }

    if(!ReturnPlayerItemCount[playerid]) { goto skipItemStack; }

    for ( new i=0; i < ReturnPlayerItemCount [ playerid ]; i ++ ) {
    
        if ( PlayerItem [ playerid ] [ i ] [ player_item_id ] == itemid && PlayerItem [ playerid ] [ i ] [ player_item_param1 ] == itemparam1 && PlayerItem [ playerid ] [ i ] [ player_item_param2 ] == itemparam2 ) {

            if ( PlayerItem [ playerid ] [ i ] [ player_item_amount ] < Item[itemid][item_stack] ) {

                PlayerItem [ playerid ] [ i ] [ player_item_amount ] += itemamount ;

                mysql_format ( mysql, query, sizeof ( query ), "UPDATE `items_player` SET player_item_amount = %d WHERE player_item_id = %d AND player_item_param1 = %d  AND player_item_param2 = %d AND player_database_id = %d",
                    PlayerItem [ playerid ] [ i ] [ player_item_amount ], itemid, PlayerItem [ playerid ] [ i ] [ player_item_param1 ], PlayerItem [ playerid ] [ i ] [ player_item_param2 ], Character [ playerid ] [ character_id ] );

                mysql_tquery ( mysql, query, "" );          

                query [ 0 ] = EOS ;

                if ( price ) {

                    TakeCharacterMoney ( playerid, price, MONEY_SLOT_HAND ) ;
                }

                if ( cents != 0 ) {

                    TakeCharacterChange ( playerid, cents, MONEY_SLOT_HAND ) ;
                }

                if(showmsg) {
    
                    format ( query, sizeof ( query ), "(%d) %s eþyasýný almaya çalýþtýnýz ancak zaten sahipsiniz. Eþyanýn miktarý (%d) mevcut eþyanýn üzerine eklendi.",
                    itemid,  Item [ itemid ] [ item_name ], itemamount);

                    SendServerMessage ( playerid, query, MSG_TYPE_INFO ) ;
                }

                HasPlayerInventoryUpdated[playerid] = true;

                return true;
            }

            else {
                goto skipItemStack;
            }
        }

        else continue ;
    }

    skipItemStack:

    inline AddItemQuery() {

        for(new i=0; i<MAX_PLAYER_ITEMS; i++) {

            if(PlayerItem[playerid][i][player_item_id] == INVALID_ITEM_ID) {

                PlayerItem[playerid][i][player_table_id] = cache_insert_id();
                PlayerItem[playerid][i][player_item_id] = itemid;
                PlayerItem[playerid][i][player_item_amount] = itemamount;
                PlayerItem[playerid][i][player_item_param1] = itemparam1;
                PlayerItem[playerid][i][player_item_param2] = itemparam2;
                
                query [ 0 ] = EOS ;
            
                if ( price ) {

                    if(cents != 0) { SendServerMessage ( playerid, sprintf("$%d.%02d karþýlýðýnda bir %s satýn aldýnýz.", price, cents, Item [ itemid ] [ item_name ] ), MSG_TYPE_INFO ) ; }
                    else { SendServerMessage ( playerid, sprintf("$%d karþýlýðýnda bir %s satýn aldýnýz.", price, Item [ itemid ] [ item_name ] ), MSG_TYPE_INFO ) ; }
                    TakeCharacterMoney ( playerid, price, MONEY_SLOT_HAND ) ;
                }

                if(cents != 0) {

                    if(!price) { SendServerMessage ( playerid, sprintf("%d sent karþýlýðýnda bir %s satýn aldýnýz.", cents, Item [ itemid ] [ item_name ] ), MSG_TYPE_INFO ) ; }
                    TakeCharacterChange(playerid,cents,MONEY_SLOT_HAND);
                }

                else {

                    if(showmsg) { 
                        SendServerMessage ( playerid, sprintf("%d adet (%d) %s eþyasýný aldýnýz.", PlayerItem[playerid][i][player_item_amount], PlayerItem[playerid][i][player_item_id],  Item [ itemid ] [ item_name ] ), MSG_TYPE_INFO ) ; 
                    }   
                }

                if(!ReturnPlayerItemCount[playerid]) { Init_LoadPlayerItems ( playerid ) ; }
                else { 

                    ReturnPlayerItemCount[playerid]++;
                    HasPlayerInventoryUpdated[playerid] = true; 
                }
                return true;
            }
            else { continue; }
        }
        return SendServerMessage(playerid,"Tüm eþya slotlarý kullanýmda.",MSG_TYPE_ERROR);
    }

    MySQL_TQueryInline ( mysql,using inline AddItemQuery,"INSERT INTO `items_player`(player_database_id, player_item_id, player_item_amount, player_item_param1, player_item_param2) VALUES (%d, %d, %d, %d, %d)",
        Character [ playerid ] [ character_id ], itemid, itemamount, itemparam1, itemparam2 );

    return true ;
}

GivePlayerItemByParam ( playerid, param, itemparam, amount, param1, param2, price, cents = 0) {

    for ( new i; i < sizeof ( Item ); i ++ ) {

        if ( Item [ i ] [ item_param ] == param && Item [ i ] [ item_extra_param ] == itemparam ) {

            if ( ReturnPlayerItemCount [ playerid ] >= MAX_PLAYER_ITEMS ) {
                
    
                if ( ! price ) {
                    SendServerMessage ( playerid, "Yeterli envanter slotunuz yok! Eþya yere düþürüldü.", MSG_TYPE_ERROR) ;

                    new Float: x, Float: y, Float: z, query [ 512 ] ;

                    GetPlayerPos ( playerid, x, y, z ) ;

                    mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO dropped_items (dropped_player, dropped_item, dropped_amount, dropped_param1, dropped_param2, dropped_pos_x, dropped_pos_y, dropped_pos_z, dropped_int, dropped_vw, dropped_timestamp) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', %d, %d, %d)",
                        Character[playerid][character_id], i, amount, param1, param2, x, y, z - 0.75, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ), gettime() + 3600 ) ;
                    mysql_tquery (mysql, query ) ;

                    format(query,sizeof(query),"%s tried to receive item %s (%d) but inventory is full - dropping item (%d,%d,%d,%d,%d,%.02f,%.02f,%.02f,%d,%d)",ReturnUserName(playerid,true,false),Item[i][item_name],i,Character[playerid][character_id], i, amount, param1, param2, x, y, z - 0.75, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ));
                    WriteLog(playerid,"item/full_inv",query);

                    Init_LoadDropItems () ;
                }

                else if ( price ) {
                    
                    SendServerMessage ( playerid, "Yeterli envanter slotunuz yok! Ýþlem iptal edildi.", MSG_TYPE_ERROR) ;
                }

                return false ;
            }

            if ( ReturnPlayerItemCount [ playerid ] >= GetPlayerBackpackSize ( playerid ) ) {

                SendServerMessage ( playerid, "Bu eþyayý yerden almak için yeterli çanta alanýnýz yok. Daha büyük bir çanta almalýsýnýz.", MSG_TYPE_ERROR ) ;
                return false ;
            }

            param1 = param;
            param2 = itemparam;

            GivePlayerItem ( playerid, i, amount, param, itemparam, price, cents ) ;
            return true ;
        }

        else continue ;
    }

    SendServerMessage ( playerid, sprintf("GivePlayerItemByParam isteði iþlenirken hata oluþtu. [OYUNCU: %d] [HATA KODU: %d, %d]", playerid, param, itemparam ), MSG_TYPE_ERROR );
    return false ;
}

GetPlayerItemCount ( playerid ) {

    return ReturnPlayerItemCount [ playerid ] ;
}

GetMaxPlayerItems ( ) { 

    return MAX_PLAYER_ITEMS ;
}
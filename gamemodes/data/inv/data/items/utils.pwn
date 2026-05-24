#if defined _inc_utils
	#undef _inc_utils
#endif

DiscardItem ( playerid, tileid ) {

	if ( tileid == -1 ) {

		return false ;
	}

	new query [ 128 ], viewing_inventory = IsPlayerViewingInventory [ playerid ] ; 

	mysql_format ( mysql,query, sizeof ( query ), "DELETE FROM items_player WHERE player_table_id = %d AND player_database_id = %d", 
	PlayerItem [ playerid ] [ tileid ] [ player_table_id ],  Character [ playerid ] [ character_id ]) ;

	mysql_tquery ( mysql, query ) ;

	PlayerItem [ playerid ] [ tileid ] [ player_item_id ] = INVALID_ITEM_ID ;
	PlayerItem [ playerid ] [ tileid ] [ player_item_amount ] = 0 ;

	PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ] = 0;
	PlayerItem [ playerid ] [ tileid ] [ player_item_param2 ] = 0;

	if(EquippedItem [ playerid ] != -1 && EquippedItemTile[playerid] == tileid) {

		RemovePlayerAttachedObject(playerid,ATTACH_SLOT_EQUIP);
		EquippedItem[playerid] = -1;
		EquippedItemTile[playerid] = -1;
		UpdateWeaponGUI(playerid);
	}

	ToggleInventory ( playerid, INV_MAX_TILES, false ) ;
	HideInventoryExamineGUI ( playerid ) ;
	
	//// UpdateWeaponGUI ( playerid );
	//Init_LoadPlayerItems ( playerid ) ;
	HasPlayerInventoryUpdated[playerid] = true;

	CancelSelectTextDraw ( playerid ) ;

	if ( viewing_inventory ) {

		//Init_LoadPlayerItems ( playerid ) ;

		SendServerMessage ( playerid, "Envanter yenileniyor...", MSG_TYPE_WARN ) ;
		SetTimerEx("DelayedInventory", 750, false, "i", playerid);
	}
	else {

		HasPlayerInventoryUpdated[playerid] = true;
		ReturnPlayerItemCount[playerid]--;
	}

	// New with new inv system

	return true ;
}

forward DelayedInventory(playerid);
public DelayedInventory(playerid){
 
	InitiateInventoryTiles ( playerid, PlayerInventoryPage [ playerid ]) ;
	return true ;
}

new PlayerEquipTick [ MAX_PLAYERS ] ;
// new PlayerFoodCooldown [ MAX_PLAYERS ] ;

OnPlayerUseItem ( playerid, itemid, tileid ){

	if ( ! Item [ itemid ] [ item_toggle ] ) {
		return SendServerMessage ( playerid, "Bu eþya ya hiçbir iþe yaramýyor yada aktif edilmemiþ.", MSG_TYPE_ERROR ) ;
	}

	switch ( Item [ itemid ] [ item_type ] ){
		case ITEM_TYPE_UNDEFINED: {
			return SendServerMessage ( playerid, "Bu eþya kullanýlamaz!", MSG_TYPE_ERROR ) ;
		}

		case ITEM_TYPE_MISC: {
			// Quest items, collectibles, etc

		}

		case ITEM_TYPE_FOOD: {
			// Add ConsumeFood here

			if ( Item [ itemid ] [ item_extra_param ] == FOOD_APPLE_RED || Item [ itemid ] [ item_extra_param ] == FOOD_APPLE_GREEN ) {

				new Float: x, Float: y, Float: z ;

				if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {
					GetDynamicObjectPos (HorseObject [ playerid ], x, y, z  ) ;
				}

				else GetDynamicObjectPos ( CowObject [ playerid ], x, y, z ) ;

				if ( IsPlayerInRangeOfPoint ( playerid, 1.5, x, y, z ) || IsPlayerRidingHorse [ playerid ] )  {

					task_yield(1);

					new dialog_response[e_DIALOG_RESPONSE_INFO];
                   await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_LIST, "Bineðinizin Yakýnýndasýnýz - Bir Eylem Seçin", "Atýnýzý besleyin\nYiyeceði kendiniz yiyin", "Ýptal", "Seç" ) ;

					switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {

						case 0: { // feed horse
						
							new Float: hp = Character [ playerid ] [ character_horsehealth ], Float: amount ;
							amount = hp + 25 ;

                          if ( hp <= 0 ) {

                                return SendServerMessage ( playerid, "Atýnýz yaralý. Ahýra giderek onu canlandýrmanýz gerekiyor.", MSG_TYPE_ERROR ) ;
                            }

                            if ( hp >= 100 ) {
                                SetHorseHealth ( playerid, -1, 100 ) ;
                                return SendServerMessage ( playerid, "Atýnýzýn caný zaten dolu. Onu beslemenin bir anlamý yok.", MSG_TYPE_INFO ) ;
                            }
							if ( hp >= 75 ) {
								amount = 100 ;
							}

                          SetHorseHealth ( playerid, -1, amount ) ;

                            if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {
                                SendServerMessage ( playerid, sprintf("Atýnýzý beslediniz. Artýk %.0f caný var.", Character [ playerid ] [ character_horsehealth ] ), MSG_TYPE_INFO ) ;
                                ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s, atýný elma ile besler.",ReturnUserName ( playerid, false ))) ;
                            }

                            else {

                                SendServerMessage ( playerid, sprintf("Ýneðinizi beslediniz. Artýk %.0f caný var.", Character [ playerid ] [ character_horsehealth ] ), MSG_TYPE_INFO ) ;
                                ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s, ineðini elma ile besler.",ReturnUserName ( playerid, false ))) ;
                            }

                            DecreaseItem ( playerid, tileid, 1 ) ;

                            return true ;
                        }

						case 1: { // feed player

							goto skipHorse;

							/*
							if ( IsPlayerBleeding [ playerid ] ) {

								return SendServerMessage ( playerid, "You can't use this wehn you're bleeding.", MSG_TYPE_ERROR ) ;
							}

							if ( Character [ playerid ] [ character_health ] >= 100 ) {

								return SendServerMessage ( playerid, "Your health is already full - there's no need to heal.", MSG_TYPE_ERROR ) ;
							}

							if ( PlayerFoodCooldown [ playerid ]  >= gettime ()) {

								return SendServerMessage ( playerid, sprintf("You need to wait %d seconds before eating something else.", PlayerFoodCooldown[playerid] - gettime ()), MSG_TYPE_WARN ) ;
							}

							PlayerFoodCooldown [ playerid ] = gettime () + 30 ;

							SetCharacterHealth ( playerid, Character [ playerid ] [ character_health ] + 25 ) ;

							return SendServerMessage ( playerid, "You have been healed 25 percent of your health.", MSG_TYPE_INFO ) ;
							*/
						}
					}
				}

			    else { // if not near horse, feed player...

			    	skipHorse:

					if ( IsPlayerBleeding [ playerid ] ) {

						return SendServerMessage ( playerid, "Kanaman var iken birþey yiyemez/içemezsin!", MSG_TYPE_ERROR ) ;
					}

					ConsumeFood ( playerid, itemid ) ;
					DecreaseItem ( playerid, tileid, 1 ) ;
					return true;
			    }
			}
			else {

				if ( IsPlayerBleeding [ playerid ] ) {

					return SendServerMessage ( playerid, "Kanaman var iken birþey yiyemez/içemezsin!", MSG_TYPE_ERROR ) ;
				}

				ConsumeFood ( playerid, itemid ) ;
				DecreaseItem ( playerid, tileid, 1 ) ;
				return true;
			}
		}

case ITEM_TYPE_USE: {

            switch ( Item [ itemid ] [ item_extra_param ] ) {

                case BANDAGE: {

                    SendServerMessage ( playerid, "Kendini sarmayý iptal etmek için ~k~~PED_FIREWEAPON~ tuþuna bas. Sargý iþlemi bittiðinde bandaj kullanýlacaktýr.", MSG_TYPE_WARN ) ;

                    IsPlayerBandaging [ playerid ] = 1 ;
                    OnPlayerBandage ( playerid, itemid, tileid ) ;

                    TogglePlayerControllable ( playerid, false ) ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("** %s kendine bandaj sarmaya baþladý.", ReturnUserName ( playerid, false ))) ;

                    return true ;
                }

                case FARMING_SOIL_BAG: {

                    CreateSoil ( playerid ) ;

                    SendServerMessage(playerid, "Eðer tarým topraðý bugda görünüyorsa (yerin altýnda kalmasý / yazýlarýn kaybolmasý) lütfen /fixsoil ve /refreshsoil komutlarýný kullanýn.", MSG_TYPE_INFO);
                }

                case AMMO_CRATE_PISTOL, FACTION_AMMO_PISTOL : {
                    if ( Character [ playerid ] [ character_handweapon] != WEAPON_DEAGLE ) {

                        return SendServerMessage ( playerid, "Bunu yapmak için elinizde bir tabanca donatýlmýþ olmalýdýr.", MSG_TYPE_ERROR ) ;
                    }

                    if ( Character [ playerid ] [ character_handammo ] ) {

                        return SendServerMessage ( playerid, "Donatýlmýþ silahýnýzda hala mermi var. Bunu sadece merminiz tamamen bittiðinde kullanýn.", MSG_TYPE_ERROR ) ;
                    }

                    new WEAPON: restoredata = Character [ playerid ] [ character_handweapon] ;

                    RemovePlayerWeapon ( playerid ) ;
                    wep_GivePlayerWeapon ( playerid, restoredata, 6 ) ;

                    ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s revolver silahý için bir mermi paketi kullandý.", ReturnUserName ( playerid, true, true ) ) ) ;
                    SendServerMessage ( playerid, "Revolver silahýnýzda mermi paketini kullandýnýz ve mermisini doldurdunuz.", MSG_TYPE_INFO ) ;

                    SavePlayerWeapons ( playerid ) ;
                }

                case AMMO_CRATE_SHOTGUN, FACTION_AMMO_SHOTGUN : {

                    if ( Character [ playerid ] [ character_handweapon] == WEAPON_SHOTGUN || Character [ playerid ] [ character_handweapon] == WEAPON_SAWEDOFF ) {

                        if ( Character [ playerid ] [ character_handammo ] ) {

                            return SendServerMessage ( playerid, "Donatýlmýþ silahýnýzda hala mermi var. Bunu sadece merminiz tamamen bittiðinde kullanýn.", MSG_TYPE_ERROR ) ;
                        }

                        new WEAPON: restoredata = Character [ playerid ] [ character_handweapon] ;
                        RemovePlayerWeapon ( playerid ) ;

                        switch ( restoredata ) {

                            case WEAPON_SHOTGUN: wep_GivePlayerWeapon ( playerid, restoredata, 8 ) ;
                            case WEAPON_SAWEDOFF: wep_GivePlayerWeapon ( playerid, restoredata, 2 ) ;
                        }

                        ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s pompalý silahý için bir mermi paketi kullandý.", ReturnUserName ( playerid, true, true ) ) ) ;
                        SendServerMessage ( playerid, "Pompalý silahýnýzda mermi paketini kullandýnýz ve mermisini doldurdunuz.", MSG_TYPE_INFO ) ;

                        SavePlayerWeapons ( playerid ) ;
                    }

                    else return SendServerMessage ( playerid, "Bunu yapmak için bir pompalý silah donatmýþ olmanýz gerekir.", MSG_TYPE_ERROR ) ;
                }

                case AMMO_CRATE_RIFLE, FACTION_AMMO_RIFLE : {

                    if ( Character [ playerid ] [ character_handweapon] == WEAPON_RIFLE || Character [ playerid ] [ character_handweapon] == WEAPON_SNIPER ) {

                        if ( Character [ playerid ] [ character_handammo ] ) {

                            return SendServerMessage ( playerid, "Donatýlmýþ silahýnýzda hala mermi var. Bunu sadece merminiz tamamen bittiðinde kullanýn.", MSG_TYPE_ERROR ) ;
                        }

                        new WEAPON: restoredata = Character [ playerid ] [ character_handweapon] ;

                        RemovePlayerWeapon ( playerid ) ;
                        wep_GivePlayerWeapon ( playerid, restoredata, 5 ) ;

                        ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s tüfeði için bir mermi paketi kullandý.", ReturnUserName ( playerid, true, true ) ) ) ;
                        SendServerMessage ( playerid, "Tüfeðinizde mermi paketini kullandýnýz ve mermisini doldurdunuz.", MSG_TYPE_INFO ) ;

                        SavePlayerWeapons ( playerid ) ;
                    }

                    else return SendServerMessage ( playerid, "Bunu yapmak için bir tüfek donatmýþ olmanýz gerekir.", MSG_TYPE_ERROR ) ;
                }

                case HUNTING_TRAP : {
                    
                    new trapid = GetFreeTrapID();

                    if(!CreateTrap(playerid,trapid)) {
                        return true;
                    }
                }

                case FARMING_SHOVEL: {

                    new i = FindNearestSoil(playerid, 4.0);

                    if(i == INVALID_SOIL_ID){
                        return SendServerMessage(playerid, "Yakýnlarda herhangi bir tarým topraðý veya bitki yok.", MSG_TYPE_ERROR);
                    } else {

                        if(Soil[i][soil_state] == SOIL_STATE_EMPTY){

                            Soil[i][soil_state] = SOIL_STATE_DIGGED;
                            SendServerMessage(playerid, "Toprakta bir delik kazdýnýz.", MSG_TYPE_INFO);
                            SetupSoil(i);

                        } 
                        else if(Soil[i][soil_state] == SOIL_STATE_DIGGED){

                            return SendServerMessage(playerid, "Þu anda küreði kullanamazsýnýz!", MSG_TYPE_ERROR);

                        } 
                        else if(Soil[i][soil_state] == SOIL_STATE_SEEDED){

                            Soil[i][soil_state] = SOIL_STATE_GROWING;
                            SendServerMessage(playerid, "Topraðýn üzerini kapattýnýz!", MSG_TYPE_INFO);
                            SetupSoil(i);

                            firstTick[i] = true;
                            StartGrowingProcess(i);

                        } else {
                            return SendServerMessage(playerid, "Bunu þu anda kullanamazsýnýz!", MSG_TYPE_ERROR);
                        }
                    }
                    return true;
                }

				case FARMING_PAIL: {
                        
                    new i = FindNearestSoil(playerid, 4.0);

                    if(i == INVALID_SOIL_ID){
                        return SendServerMessage(playerid, "Yakýnlarda herhangi bir tarým topraðý veya bitki yok.", MSG_TYPE_ERROR);
                    } else {

                        switch(Soil[i][soil_water]){

                            case SOIL_WATER_WATERED: {
                                return SendServerMessage(playerid, "Bu bitkinin sulanmaya ihtiyacý yok!", MSG_TYPE_ERROR);
                            }

                            case SOIL_WATER_MODERATE: {
                                Soil[i][soil_water] = SOIL_WATER_WATERED;
                                Soil[i][soil_health] = SOIL_HEALTH_HEALTHY;
                                SetupSoil(i);

                                SendServerMessage(playerid, "Bu bitkiyi suladýnýz.", MSG_TYPE_INFO);

                                DecreaseItem(playerid, tileid, 1);
                                GivePlayerItem ( playerid, FARMING_EMPTY_PAIL, 1, 0, 0, 0, 0, 0);
                            }

                            case SOIL_WATER_DEHYDRATED: {
                                Soil[i][soil_water] = SOIL_WATER_WATERED;
                                Soil[i][soil_health] = SOIL_HEALTH_HEALTHY;
                                SetupSoil(i);

                                SendServerMessage(playerid, "Bu bitkiyi suladýnýz.", MSG_TYPE_INFO);

                                DecreaseItem(playerid, tileid, 1);
                                GivePlayerItem ( playerid, FARMING_EMPTY_PAIL, 1, 0, 0, 0, 0, 0);
                            }

                            default: { return SendServerMessage(playerid, "Bunu þu anda kullanamazsýnýz!", MSG_TYPE_ERROR); }
                        }
                    }
                }

                case FARMING_EMPTY_PAIL: {

                    new i = FindNearestSoil(playerid, 4.0);

                    if(i == INVALID_SOIL_ID){
                        SendServerMessage(playerid, "Yakýnlarda herhangi bir tarým topraðý veya bitki yok.", MSG_TYPE_ERROR);
                    } 
                    else SendServerMessage(playerid, "Önce kovanýzý suyla doldurmanýz gerekiyor!", MSG_TYPE_ERROR);

                    if(IsPlayerNearWater(playerid)){
                        DecreaseItem(playerid, tileid, 1);
                        GivePlayerItem ( playerid, FARMING_PAIL, 1, 0, 0, 0, 0, 0);

                        SendServerMessage(playerid, "Kovanýzý suyla doldurdunuz.", MSG_TYPE_INFO);
                    } 
                    else return SendServerMessage(playerid, "Hiçbir su kaynaðýnýn yakýnýnda deðilsiniz!", MSG_TYPE_ERROR);

                    return true;
                }

                case EMPTY_BASKET: {

                    new i = FindNearestSoil(playerid, 4.0);

                    if(i == INVALID_SOIL_ID){
                        return SendServerMessage(playerid, "Yakýnlarda herhangi bir tarým topraðý veya bitki yok.", MSG_TYPE_ERROR);
                    } else if(Soil[i][soil_state] == SOIL_STATE_GROWN){

                        DecreaseItem ( playerid, tileid, 1 ) ;

                        switch(Soil[i][soil_plant]){ 

                            case SEED_ORANGE: {
                                GivePlayerItem ( playerid, ORANGE_BASKET, 1, 0, 0, 0, 0, 0);
                            }

                            case SEED_APPLE_RED: {
                                GivePlayerItem ( playerid, RAPPLE_BASKET, 1, 0, 0, 0, 0, 0);
                            }

                            case SEED_APPLE_GREEN: {
                                GivePlayerItem ( playerid, GAPPLE_BASKET, 1, 0, 0, 0, 0, 0);
                            }

                            case SEED_TOMATO: {
                                GivePlayerItem ( playerid, TOMATO_BASKET, 1, 0, 0, 0, 0, 0);
                            }

                            case SEED_CABBAGE: {
                                GivePlayerItem ( playerid, CABBAGE_BASKET, 1, 0, 0, 0, 0, 0);
                            }

                            case SEED_WHEAT: {
                                GivePlayerItem ( playerid, WHEAT_BASKET, 1, 0, 0, 0, 0, 0);
                            }

                            case SEED_PUMPKIN: {
                                GivePlayerItem ( playerid, PUMPKIN_BASKET, 1, 0, 0, 0, 0, 0);
                            }
                        }
                    }
                    return true;
                }   
                


                case HUNTING_BAIT : {

                    new trapid = FindNearestTrap(playerid,2.5);
                    
                    if(trapid == -1) { return SendServerMessage(playerid,"Bir tuzaðýn yakýnýnda deðilsiniz.",MSG_TYPE_ERROR); }
                    if(!DoesPlayerOwnTrap(playerid,trapid)) { return SendServerMessage(playerid,"Bu tuzak size ait deðil.",MSG_TYPE_ERROR); }
                    if(IsTrapBaited(trapid)) { return SendServerMessage(playerid,"Tuzakta zaten yem var.",MSG_TYPE_ERROR); }
                    if(IsTrapArmed(trapid)) { return SendServerMessage(playerid,"Yem yerleþtirmeden önce bu tuzaðý devre dýþý býrakmalýsýnýz.",MSG_TYPE_ERROR); }
                    
                    SetTrapBait(trapid);

                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);

                    ProxDetector(playerid, 20.0, COLOR_ACTION, sprintf("* %s tuzaðýna yem yerleþtirir.", ReturnUserName(playerid, false)));
                }
                case THERMOSTAT: {

                    if(GetZoneTemperature(GetPlayerZone(playerid)) != INVALID_TEMPERATURE) { SendServerMessage(playerid,sprintf("Termostat %d F° gösteriyor.",GetZoneTemperature(GetPlayerZone(playerid))),MSG_TYPE_INFO); }
                    else { SendServerMessage(playerid,"Geçerli bir sýcaklýða sahip olmayan bir bölgedesiniz.",MSG_TYPE_ERROR); }
                    return true;
                }
                case GLOVES,LONG_JOHNS: {

                    return SendServerMessage(playerid,"Bu eþyalar soðuk bölgelerde sýcak kalmanýza otomatik olarak yardýmcý olur ancak sýcak bölgelerde sizi daha da ýsýtýr.",MSG_TYPE_INFO);
                }
            }

        }

        case ITEM_TYPE_EQUIP: {
            /*
            ////////////
            ////// NOTE: Make sure to "return" the function, so it doesn't remove the quanity later on.
            //////////// 
            */

            if ( EquippedItem [ playerid ] >= 0 ) {

                new equipitem = GetItemByParamID ( EquippedItem [ playerid ] ) ;

                RemovePlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP ) ;
                RemovePlayerWeapon ( playerid );

                EquippedItem [ playerid ] = -1 ;
                EquippedItemTile[playerid] = -1;
                UpdateWeaponGUI ( playerid );
                DisplayInventoryExamineGUI ( playerid, itemid, tileid ) ;

                ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s, %s eþyasýný çýkardý.",ReturnUserName ( playerid, false, true ), Item [ equipitem ] [ item_name ] ) ) ;
                return SendServerMessage ( playerid, "Daha önce kuþandýðýnýz eþya çýkarýldý.", MSG_TYPE_ERROR ) ;
            }

            if ( Character [ playerid ] [ character_handweapon ] ) {

                return SendServerMessage ( playerid, "Bir þeyi kuþanmadan önce elinizdeki silahý kýlýfýna koymalýsýnýz.", MSG_TYPE_ERROR ) ;
            }

            if ( IsPlayerRidingHorse [ playerid ] ) {

                if(Item [ itemid ] [ item_extra_param ] == SHERIFF_LASSO){

                    EquippedItem [ playerid ] = SHERIFF_LASSO ;
                    EquippedItemTile [ playerid ] = tileid ;

                    //SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, -0.018, 0.06, -0.025, 181.5, 17.5, 0.0, 1.0, 1.0, 1.0) ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir kement kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir kement kuþandýnýz. Birini hedef almak için /lasso [hedef_id] komutunu kullanýn, ardýndan onu yakalamaya çalýþmak için SOL TIK kullanýn.", MSG_TYPE_INFO ) ;
                    SendServerMessage(playerid, "Kementi trolleme amacýyla kötüye kullanmayýn. Bu uyarýyý dikkate almamak admin hapisine (jail) veya yasaklanmaya (ban) yol açabilir.", MSG_TYPE_WARN);

                } else {
                    return SendServerMessage ( playerid, "At binerken herhangi bir eþya kuþanamazsýnýz.", MSG_TYPE_ERROR ) ;
                }
            }

            new temp_Tick = GetTickCount(), temp_tickDiff ;
            temp_tickDiff = temp_Tick - PlayerEquipTick[playerid];
            
            if ( temp_tickDiff < 3000) {
            
                return SendServerMessage ( playerid, sprintf("Tekrar bir þey kuþanmadan önce %0.2f saniye beklemelisiniz.",float(3000 - temp_tickDiff) / 1000.0), MSG_TYPE_ERROR ) ;
            }       

            PlayerEquipTick [ playerid ]  = GetTickCount();     

            switch ( Item [ itemid ] [ item_extra_param ] ) {

                case CAMERA: {
                    EquippedItem [ playerid ] = CAMERA ;
                    EquippedItemTile [ playerid ] = tileid ;

                    wep_GivePlayerWeapon ( playerid, WEAPON_CAMERA, 5 ) ;
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, 0.1, 181.5, 0.0, 0.0, 1.0, 1.0, 1.0 ) ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir fotoðraf makinesi kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir fotoðraf makinesi kuþandýnýz. Artýk fotoðraf çekebilirsiniz.", MSG_TYPE_INFO ) ;
                }

                case HUNTING_KNIFE: {
                    EquippedItem [ playerid ] = HUNTING_KNIFE ;
                    EquippedItemTile [ playerid ] = tileid ;

                    //wep_GivePlayerWeapon ( playerid, WEAPON_KNIFE, 5 ) ;
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, -0.018, 0.06, -0.025, 181.5, 17.5, 0.0, 1.0, 1.0, 1.0) ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir av býçaðý kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir av býçaðý kuþandýnýz. Ölü bir hayvanýn derisini yüzmek için ~k~~SNEAK_ABOUT~ tuþuna basýn.", MSG_TYPE_INFO ) ;

                }

                case FISHING_ROD: {

                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, 0.1, 181.5, 0.0, 0.0, 1.0, 1.0, 1.0 ) ;

                    EquippedItem [ playerid ] = FISHING_ROD ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir olta kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir olta kuþandýnýz. Balýk tutmak için su kenarýnda ~k~~SNEAK_ABOUT~ tuþuna basýn.", MSG_TYPE_INFO ) ;    

                    /*if ( TutorialProgress [ playerid ] > 2 && TutorialProgress [ playerid ] != 7) {

                        TutorialProgress [ playerid ] ++ ;
                        ProcessTutorialTask ( playerid ) ;
                    }   */              
                }

                case DYNAMITE: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, 0.1, 181.5, 0.0, 0.0, 1.0, 1.0, 1.0 ) ;
                    EquippedItem [ playerid ] = DYNAMITE ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir dinamit seti kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir dinamit seti kuþandýnýz. Artýk /dynamite komutunu kullanabilirsiniz.", MSG_TYPE_INFO ) ;
                }

                case MINE_PICKAXE: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.0709,0.0519,0.1359,0.0000,0.0000,0.0000,1.0000,1.0000,1.0000 ) ;
                    EquippedItem [ playerid ] = MINE_PICKAXE ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir kazma kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir kazma kuþandýnýz. Bir kayayý madenlemek için ~k~~SNEAK_ABOUT~ tuþuna basýn.", MSG_TYPE_INFO ) ;
                }

                case LUMBER_HATCHET: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.0709,0.0340,0.0000,0.0000,0.0000,-175.4997,1.0000,1.0000,1.0000 ) ;
                    EquippedItem [ playerid ] = LUMBER_HATCHET ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir balta kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir balta kuþandýnýz. Aðaç kesmek için ~k~~SNEAK_ABOUT~ tuþuna basýn.", MSG_TYPE_INFO ) ;
                }

                case LIQUOR_PALELAGER: {

                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.2, -0.2, 0.0, 3.8, 1, 1, 1 ) ;
                    EquippedItem [ playerid ] = LIQUOR_PALELAGER ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Pale Lager içki þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_MILDALE: {

                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.2, -0.2, 0.0, 3.8, 1, 1, 1 ) ;
                    EquippedItem [ playerid ] = LIQUOR_MILDALE ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Pale Lager içki þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_MALTLIQUOR: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.2, -0.2, 0.0, 3.8, 1, 1, 1 ) ;
                    EquippedItem [ playerid ] = LIQUOR_MALTLIQUOR ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Malt içki þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_WHEATBEER: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.0, 0.0, -0.072, -0.2, 19.0, 3.8, 1.0, 1.0, 1.0 ) ;

                    EquippedItem [ playerid ] = LIQUOR_WHEATBEER ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Buðday Birasý þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_WHITEWINE: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.292, -0.2, 0.0, 3.8, 0.81, 0.83, 0.703 ) ;
                    EquippedItem [ playerid ] = LIQUOR_WHITEWINE ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Beyaz Þarap þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_REDWINE: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.292, -0.2, 0.0, 3.8, 0.81, 0.83, 0.703 ) ;
                    EquippedItem [ playerid ] = LIQUOR_REDWINE ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Kýrmýzý Þarap þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_GRAINWHISKEY: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.22, -0.20, 0.0, 3.8, 0.81, 0.83, 0.70 );

                    EquippedItem [ playerid ] = LIQUOR_GRAINWHISKEY ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Tahýl Viskisi þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_MALTWHISKEY: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, 0.08, 0.04, -0.292, -0.2, 0.0, 3.8, 0.81, 0.83, 0.703 ) ;
                    EquippedItem [ playerid ] = LIQUOR_MALTWHISKEY ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Malt Viskisi þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /drink kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;    
                }

                case LIQUOR_VODKA: {
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6,  0.08, 0.04, -0.292, -0.2, 0.0, 3.8, 0.81, 0.83, 0.703 ) ;
                    EquippedItem [ playerid ] = LIQUOR_VODKA ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir Kaçak Viski Votka þiþesi açtý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /smoke 1 kullanýn. Þiþeyi kuþanmayý býrakarak elinizden çýkarabilirsiniz.", MSG_TYPE_INFO ) ;  
                }

                case SMOKE_CIGARPACK: {
                    DecreaseItem ( playerid, tileid, 1 ) ;
                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, 1485, 6, 0.015, -0.022, 0.019, -0.20, 0.0, 3.8, 0.81, 0.83, 0.70 ) ;

                    EquippedItem [ playerid ] = SMOKE_CIGARPACK ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s paketinden bir puro çýkardý ve yaktý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /smoke 1 kullanýn. Sigara içmeyi durdurmak için kuþanmayý býrakmanýz yeterlidir.", MSG_TYPE_INFO ) ;   
                }

                case SMOKE_BLUNTPACK: {
                    DecreaseItem ( playerid, tileid, 1 ) ;

                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, 3027, 6, 0.11, 0.00, 0.033, 63, 69.2, 3.8, 0.81, 0.83, 0.70 ) ;

                    EquippedItem [ playerid ] = SMOKE_BLUNTPACK ;
                    EquippedItemTile [ playerid ] = tileid ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s paketinden sarýlmýþ bir sigara çýkardý ve yaktý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Ýçmek için /smoke kullanýn. Sigara içmeyi durdurmak için kuþanmayý býrakmanýz yeterlidir.", MSG_TYPE_INFO ) ;            
                }
				case SHERIFF_LASSO: {

                    EquippedItem [ playerid ] = SHERIFF_LASSO ;
                    EquippedItemTile [ playerid ] = tileid ;

                    SetPlayerAttachedObject(playerid, ATTACH_SLOT_EQUIP, Item [ itemid ] [ item_model ], 6, -0.018, 0.06, -0.025, 181.5, 17.5, 0.0, 1.0, 1.0, 1.0) ;

                    ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s bir kement kuþandý.",ReturnUserName ( playerid, false, true ) ) ) ;
                    SendServerMessage ( playerid, "Bir kement kuþandýnýz. Birini hedef almak için /lasso [hedef_id] komutunu kullanýn, ardýndan onu yakalamaya çalýþmak için SOL TIK kullanýn.", MSG_TYPE_INFO ) ;
                    SendServerMessage(playerid, "Kementi trolleme amacýyla kötüye kullanmayýn. Bu uyarýyý dikkate almamak admin hapisine (jail) veya yasaklanmaya (ban) yol açabilir.", MSG_TYPE_WARN);
                }
            }

            DisplayInventoryExamineGUI ( playerid, itemid, tileid ) ;
            UpdateWeaponGUI ( playerid ) ;

            return true ;

        }

        case ITEM_TYPE_SEED: {

            new i = FindNearestSoil(playerid, 4.0);

            if(i == INVALID_SOIL_ID){
                return SendServerMessage(playerid, "Yakýnlarda herhangi bir tarým topraðý veya bitki yok.", MSG_TYPE_ERROR);
            } else {

                if(Character[playerid][character_id] == Soil[i][soil_owner]){

                    if(Soil[i][soil_state] == SOIL_STATE_DIGGED){

                        DecreaseItem ( playerid, tileid, 1 );

                        switch ( Item [ itemid ] [ item_extra_param ] ) {

                            case SEED_ORANGE: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_ORANGE;

                                SendServerMessage(playerid, "Bir portakal tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }

                            case SEED_APPLE_RED: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_APPLE_RED;

                                SendServerMessage(playerid, "Bir kýrmýzý elma tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }

                            case SEED_APPLE_GREEN: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_APPLE_GREEN;

                                SendServerMessage(playerid, "Bir yeþil elma tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }

                            case SEED_TOMATO: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_TOMATO;

                                SendServerMessage(playerid, "Bir domates tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }

                            case SEED_CABBAGE: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_CABBAGE;

                                SendServerMessage(playerid, "Bir lahana tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }

                            case SEED_PUMPKIN: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_PUMPKIN;

                                SendServerMessage(playerid, "Bir bal kabaðý tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }

                            case SEED_WHEAT: {
                                Soil[i][soil_state] = SOIL_STATE_SEEDED;
                                Soil[i][soil_plant] = PLANT_WHEAT;

                                SendServerMessage(playerid, "Bir buðday tohumu ektiniz!", MSG_TYPE_INFO);
                                SetupSoil(i);
                            }
                        }
                    }
                    else {
                        return SendServerMessage(playerid, "Þu anda bu topraða tohum ekemezsiniz!", MSG_TYPE_ERROR);
                    }
                }
                else {
                    return SendServerMessage(playerid, "Bu toprak size ait deðil.", MSG_TYPE_ERROR);
                }
            }
            return true;
        }
    

        case ITEM_TYPE_JUNK: {
            // Check if player is near shopkeeper then sell it
        }

        case ITEM_TYPE_SELL: {
            
            /*if ( TutorialProgress [ playerid ] != MAX_TUTORIAL_PROGRESS) {
                if ( Item [ itemid ] [ item_extra_param ] == FISHING_BLUE_1 ||  Item [ itemid ] [ item_extra_param ] == FISHING_BLUE_2 ||
                Item [ itemid ] [ item_extra_param ] == FISHING_YELLOW ||  Item [ itemid ] [ item_extra_param ] == FISHING_BIGFISH ||
                Item [ itemid ] [ item_extra_param ] == FISHING_SHARK ) {

                    DiscardItem ( playerid, tileid ) ;
                    GiveCharacterMoney ( playerid, 50, MONEY_SLOT_HAND ) ;

                    SendServerMessage ( playerid, sprintf("You have sold your %s for $%s.", Item [ itemid ] [ item_name ], IntegerWithDelimiter ( 50 ) ), MSG_TYPE_INFO ) ;

                    TutorialProgress [ playerid ] ++ ;
                    ProcessTutorialTask ( playerid ) ;

                    return true ;
                }
            }*/

            if(Item[itemid][item_extra_param] == WILDLIFE_MEAT || Item[itemid][item_extra_param] == WILDLIFE_MEAT_LEG) {

                for(new i=0; i<sizeof(CookingLocations); i++) {

                    if(IsPlayerInRangeOfPoint(playerid, 2.5, CookingLocations[i][0],CookingLocations[i][1],CookingLocations[i][2])) {

                        task_yield(1);

                        new error, dialog_response[e_DIALOG_RESPONSE_INFO];

                        for(;;) {

                            switch(error) {

                                case 0: {
                                    
                                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Piþirme Alaný", sprintf("{FFFFFF}Lütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                }
                                case 1: {
                                    
                                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Piþirme Alaný", sprintf("{CF4040}Miktar bir sayý olmalýdýr.{FFFFFF}\n\nLütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                }
                                case 2: {
                                    
                                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Piþirme Alaný", sprintf("{CF4040}Miktar pozitif bir sayý veya 0'dan büyük olmalýdýr.{FFFFFF}\n\nLütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                }
                                case 3: {
                                    
                                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Piþirme Alaný", sprintf("{CF4040}Elinizde bu kadar et bulunmuyor, maksimum miktara dikkat edin.{FFFFFF}\n\nLütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                }
                            }

                            error = 0;

                            if(dialog_response[E_DIALOG_RESPONSE_Response]) {

                                if(!IsNumeric(dialog_response[E_DIALOG_RESPONSE_InputText])) {

                                    error = 1;
                                }
                                else if(strval(dialog_response[E_DIALOG_RESPONSE_InputText]) <= 0) {

                                    error = 2;
                                }
                                else if(strval(dialog_response[E_DIALOG_RESPONSE_InputText]) > PlayerItem[playerid][tileid][player_item_amount]) {

                                    error = 3;
                                }

                                if(error) {

                                    continue;
                                }

                                if(Item[itemid][item_extra_param] == WILDLIFE_MEAT) {

                                    if(GivePlayerItemByParam(playerid, PARAM_HUNGER, FOOD_COOKED_MEAT, strval(dialog_response[E_DIALOG_RESPONSE_InputText]), PARAM_HUNGER, FOOD_COOKED_MEAT, 0)) {
                                        
                                        DecreaseItem(playerid,tileid,strval(dialog_response[E_DIALOG_RESPONSE_InputText]));
                                        return SendServerMessage(playerid,sprintf("%d adet et piþirdiniz.",strval(dialog_response[E_DIALOG_RESPONSE_InputText])),MSG_TYPE_INFO);
                                    }
                                }
                                else {

                                    if(GivePlayerItemByParam(playerid, PARAM_HUNGER, FOOD_COOKED_MEAT_LEG, strval(dialog_response[E_DIALOG_RESPONSE_InputText]), PARAM_HUNGER, FOOD_COOKED_MEAT_LEG, 0)) {
                                        
                                        DecreaseItem(playerid,tileid,strval(dialog_response[E_DIALOG_RESPONSE_InputText]));
                                        return SendServerMessage(playerid,sprintf("%d adet but eti piþirdiniz.",strval(dialog_response[E_DIALOG_RESPONSE_InputText])),MSG_TYPE_INFO);
                                    }
                                }
                            }

                            break;
                        }

                        return 1;
                    }
                    else continue;
                }

			foreach(new i : Player) {

                    if(DoesPlayerHaveCampfire[i]) {

                        new Float:x,Float:y,Float:z;
                        GetDynamicObjectPos(PlayerCampfireObjectHandler[i],x,y,z);
                        if(IsPlayerInRangeOfPoint(playerid,2.5,x,y,z)) {

                            task_yield(1);

                            new error, dialog_response[e_DIALOG_RESPONSE_INFO];

                            for(;;) {

                                switch(error) {

                                    case 0: {

                                        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Kamp Ateþi", sprintf("{FFFFFF}Lütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                    }

                                    case 1: {

                                        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Kamp Ateþi", sprintf("{CF4040}Miktar bir sayý olmalýdýr.{FFFFFF}\n\nLütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                    }

                                    case 2: {

                                        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Kamp Ateþi", sprintf("{CF4040}Miktar pozitif bir sayý veya 0'dan büyük olmalýdýr.{FFFFFF}\n\nLütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                    }

                                    case 3: {

                                        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Kamp Ateþi", sprintf("{CF4040}Elinizde bu kadar et bulunmuyor, maksimum miktara dikkat edin.{FFFFFF}\n\nLütfen piþirmek istediðiniz miktarý girin. (Maksimum: %d)",PlayerItem [ playerid ] [ tileid ] [ player_item_amount ]),"Piþir","Çýkýþ");
                                    }
                                }

                                error = 0;

                                if(dialog_response[E_DIALOG_RESPONSE_Response]) {

                                    if(!IsNumeric(dialog_response[E_DIALOG_RESPONSE_InputText])) {

                                        error = 1;
                                    }
                                    else if(strval(dialog_response[E_DIALOG_RESPONSE_InputText]) <= 0) {

                                        error = 2;
                                    }
                                    else if(strval(dialog_response[E_DIALOG_RESPONSE_InputText]) > PlayerItem[playerid][tileid][player_item_amount]) {

                                        error = 3;
                                    }

                                    if(error) {

                                        continue;
                                    }

                                    if(Item[itemid][item_extra_param] == WILDLIFE_MEAT) {

                                        if(GivePlayerItemByParam(playerid, PARAM_HUNGER, FOOD_COOKED_MEAT, strval(dialog_response[E_DIALOG_RESPONSE_InputText]), PARAM_HUNGER, FOOD_COOKED_MEAT, 0)) {
                                            
                                            DecreaseItem(playerid,tileid,strval(dialog_response[E_DIALOG_RESPONSE_InputText]));
                                            return SendServerMessage(playerid,sprintf("%d adet et piþirdiniz.",strval(dialog_response[E_DIALOG_RESPONSE_InputText])),MSG_TYPE_INFO);
                                        }
                                    }
                                    else {

                                        if(GivePlayerItemByParam(playerid, PARAM_HUNGER, FOOD_COOKED_MEAT_LEG, strval(dialog_response[E_DIALOG_RESPONSE_InputText]), PARAM_HUNGER, FOOD_COOKED_MEAT_LEG, 0)) {
                                            
                                            DecreaseItem(playerid,tileid,strval(dialog_response[E_DIALOG_RESPONSE_InputText]));
                                            return SendServerMessage(playerid,sprintf("%d adet but eti piþirdiniz.",strval(dialog_response[E_DIALOG_RESPONSE_InputText])),MSG_TYPE_INFO);
                                        }
                                    }
                                }

                                break;
                            }
                            return 1;
                        }
                        else { continue; }
                    }
                    else { continue; }
                }

                goto skipCookMeat;
            }

            skipCookMeat:

            if ( ! OnPlayerSell ( playerid, itemid, tileid ) ) {

                return SendServerMessage ( playerid, "Bulunduðunuz konumda bu eþyalarý satamazsýnýz.", MSG_TYPE_ERROR ) ;
            }

            return false ;
        }
    }

    DecreaseItem ( playerid, tileid, 1 ) ;

    return true ;
}

DecreaseItem ( playerid, tileid, amount = 1 ) {
    new string [ 256 ] ;

    PlayerItem [ playerid ] [ tileid ] [ player_item_amount ] -= amount ;

    if ( IsPlayerViewingInventory [ playerid ] == true ) {

        valstr ( string, PlayerItem [ playerid ] [ PlayerExaminingItemTile [ playerid ] ] [ player_item_amount ] ) ;

        PlayerTextDrawHide(playerid, inventory_examine_ptds [ 2 ] ) ;
        PlayerTextDrawSetString ( playerid, inventory_examine_ptds [ 2 ], string ) ; 
        PlayerTextDrawShow(playerid, inventory_examine_ptds [ 2 ] ) ;

        string [ 0 ] = EOS ;
    }

    mysql_format ( mysql, string, sizeof ( string ), "UPDATE items_player SET player_item_amount = '%d' WHERE player_table_id = %d AND player_database_id = '%d'", 
        PlayerItem [ playerid ] [ tileid ] [ player_item_amount ], PlayerItem [ playerid ] [ tileid ] [ player_table_id ], Character [ playerid ] [ character_id ] ) ; 
    mysql_tquery ( mysql, string ) ;

    HasPlayerInventoryUpdated[playerid] = true;

    if ( PlayerItem [ playerid ] [ tileid ] [ player_item_amount ] <= 0 ) {

        DiscardItem ( playerid, tileid ) ;

        return SendServerMessage ( playerid, "Bu eþyadan elinizdeki son miktarý da kullandýnýz.", MSG_TYPE_ERROR ) ;
    }

    return true ;
}

DecreaseItemByExtraParam ( playerid, param, amount ) {

    new string [ 256 ], totalamount = amount ;

    for ( new i; i < ReturnPlayerItemCount [ playerid ] ; i ++ ) {

        if ( totalamount <= 0 ) { break ; }

        if ( PlayerItem [ playerid ] [ i ] [ player_item_param2 ] == param ) {

            if ( totalamount >= PlayerItem [ playerid ] [ i ] [ player_item_amount ] ) { 

                totalamount -= PlayerItem [ playerid ] [ i ] [ player_item_amount ] ; 
                PlayerItem [ playerid ] [ i ] [ player_item_amount ] = 0 ; 
            }
            
            else if ( totalamount < PlayerItem [ playerid ] [ i ] [ player_item_amount ] ) { 

                PlayerItem [ playerid ] [ i ] [ player_item_amount ] -= totalamount ; 
                totalamount = 0 ; 
            }

            if ( IsPlayerViewingInventory [ playerid ] == true ) {
            
                valstr ( string, PlayerItem [ playerid ] [ PlayerExaminingItemTile [ playerid ] ] [ player_item_amount ] ) ;

                PlayerTextDrawHide(playerid, inventory_examine_ptds [ 2 ] ) ;
                PlayerTextDrawSetString ( playerid, inventory_examine_ptds [ 2 ], string ) ; 
                PlayerTextDrawShow(playerid, inventory_examine_ptds [ 2 ] ) ;

                string [ 0 ] = EOS ;
            }

            mysql_format ( mysql, string, sizeof ( string ), "UPDATE items_player SET player_item_amount = '%d' WHERE player_table_id = %d AND player_database_id = '%d'", 
                PlayerItem [ playerid ] [ i ] [ player_item_amount ], PlayerItem [ playerid ] [ i ] [ player_table_id ], Character [ playerid ] [ character_id ] ) ; 
            mysql_tquery ( mysql, string ) ;

            if ( PlayerItem [ playerid ] [ i ] [ player_item_amount ] <= 0 ) {

                DiscardItem ( playerid, i ) ;

                SendServerMessage ( playerid, "Bu eþyadan elinizdeki son miktarý da kullandýnýz.", MSG_TYPE_ERROR ) ;
            }
        }

        else continue ;
    }

    return true ;
}

ConsumeFood(playerid, itemid) {

    new query[128];
    switch(Item[itemid][item_extra_param]) {

        case FOOD_WATER_FULL: {

            Character[playerid][character_thirst] += 20;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir þiþe su içer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_MILK_FULL: {

            Character[playerid][character_thirst] += 15;
            Character[playerid][character_hunger] += 5;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s biraz süt içer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_ORANGE: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 5;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir portakal yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_APPLE_GREEN,FOOD_APPLE_RED: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 5;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            if(Item[itemid][item_extra_param] == FOOD_APPLE_GREEN) { ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir yeþil elma yer.",ReturnUserName(playerid,false,true))); }
            else { ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir kýrmýzý elma yer.",ReturnUserName(playerid,false,true))); }
        }
        case FOOD_TOMATO: {

            Character[playerid][character_hunger] += 5;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir domates yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CABBAGE: {

            Character[playerid][character_hunger] += 7;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s biraz lahana yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_BANANA: {

            Character[playerid][character_hunger] += 5;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir muz yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_BREAD: {

            Character[playerid][character_thirst] -= 5;
            Character[playerid][character_hunger] += 20;
            if(Character[playerid][character_thirst] < 0) { Character[playerid][character_thirst] = 0; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s biraz ekmek yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_PUMPKIN: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 20;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s bir parça bal kabaðý yer.",ReturnUserName(playerid,false,true)));
        }
case FOOD_COOKED_MEAT,FOOD_COOKED_MEAT_LEG: {

            Character[playerid][character_hunger] += 25;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            if(Item[itemid][item_extra_param] == FOOD_COOKED_MEAT) { ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s piþmiþ et yer.",ReturnUserName(playerid,false,true))); }
            else { ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s piþmiþ but eti yer.",ReturnUserName(playerid,false,true))); }
        }
        case FOOD_CANNED_SALMON: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 15;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve somon yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_CORNED_BEEF: {

            Character[playerid][character_hunger] += 15;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve sýðýr eti yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_PINEAPPLES: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 10;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve ananas yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_STRAWBERRIES: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 10;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve çilek yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_KIDNEY_BEANS: {

            Character[playerid][character_hunger] += 15;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve barbunya yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_PEACHES: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 15;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve þeftali yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_SWEETCORN: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 10;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve mýsýr yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_BAKED_BEANS: {

            Character[playerid][character_hunger] += 15;
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve kuru fasulye yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_APRICOTS: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 10;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve kayýsý yer.",ReturnUserName(playerid,false,true)));
        }
        case FOOD_CANNED_PEAS: {

            Character[playerid][character_thirst] += 5;
            Character[playerid][character_hunger] += 10;
            if(Character[playerid][character_thirst] > 100) { Character[playerid][character_thirst] = 100; }
            if(Character[playerid][character_hunger] > 100) { Character[playerid][character_hunger] = 100; }
            mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d,character_hunger = %d WHERE character_id = %d",Character[playerid][character_thirst],Character[playerid][character_hunger],Character[playerid][character_id]);
            mysql_tquery(mysql,query);
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0, SYNC_ALL);
            ProxDetector(playerid,20.0,COLOR_ACTION,sprintf("* %s konserve bezelye yer.",ReturnUserName(playerid,false,true)));
        }
        default: {

            return SendServerMessage(playerid,sprintf("Bir þeyler ters gitti, lütfen bunu bir geliþtiriciye bildirin. [Hata: ID %d array]",itemid),MSG_TYPE_ERROR);
        }
    }
    UpdateGUI(playerid);
    return true;
}
#define LVL1GUNSMITHTIME 	(60000)
#define LVL2GUNSMITHTIME 	(40000)
#define LVL3GUNSMITHTIME 	(20000)

enum GunCreationData {

	gc_name [ 64 ],
	Float: gc_pos_x,
	Float: gc_pos_y,
	Float: gc_pos_z
} ;

new GunCreation [ ] [ GunCreationData ] = {


	{ "Kömür Yýðýný: Yakýt", 			-1212.5631, 1831.2927, 42.3896 }, // elde etmesi daha çok zaman alýr, ama daha hýzlý çalýþýr
	{ "Kütük Bloðu: Külçe Yeniden Þekillendirme", 	-1218.0070, 1825.6216, 41.7440 }, // elde etmesi daha az zaman alýr, ama daha yavaþ çalýþýr
	{ "Fýrýn: Cevher Eritme", 		-1214.9054, 1819.7556, 40.3845 }, // cevheri külçeye dönüþtürmek için
	{ "Soðutma: Külçe Oluþturma", 	-1223.6672, 1821.7823, 41.8300 }, // bir külçeyi sonlandýrmak için
	{ "Bodrum: Silah Sonlandýrma", -1227.2146, 1835.9607, 41.6191 } // külçelerden bir silah parçasý oluþturmak için

}, 	DynamicText3D: gc_Label [ sizeof ( GunCreation ) ] ;


new GunCreationArea ;
Init_GunCreationArea ( ) {

	GunCreationArea = CreateDynamicRectangle(-1212.3748, 1813.9226, -1228.6282, 1838.9640 ) ;

	new count ;

	for ( new i; i < sizeof ( GunCreation ) ; i ++ ) {

		gc_Label [ i ] = CreateDynamic3DTextLabel(sprintf("%s\n{DEDEDE}~k~~SNEAK_ABOUT~ TUÞUNA BASARAK KULLAN", GunCreation [ i ] [ gc_name ]), 
			0x966C5DFF, GunCreation [ i ] [ gc_pos_x ], GunCreation [ i ] [ gc_pos_y ], GunCreation [ i ] [ gc_pos_z ], 15.0 ) ;
	
		count ++ ;
	}

	printf(" * [YASADIÞI SÝLAHLAR] %d adet silah etiketi kuruldu", count ) ;

	return true ;
}

new PlayerGunProgress 				[ MAX_PLAYERS ] ;

new PlayerGunOre 					[ MAX_PLAYERS ] ;
new PlayerGunSecondaryOre 			[ MAX_PLAYERS ] ;

new PlayerCraftingGunComponant 		[ MAX_PLAYERS ] ;

forward FurnaceRefillTime(playerid, ticks, Float: amount ) ;
public FurnaceRefillTime(playerid, ticks, Float: amount ) {

	PlayerGunProgress [ playerid ] += 2 ;

	SetPlayerProgressBarValue(playerid, actionGUI_bar, PlayerGunProgress [ playerid ] ) ;
	//PlayerTextDrawSetString(playerid, actionGUI_infoText, sprintf("@ Genel Ilerleme: %d~n~Bakir Cevheri: %d~n~Kalay Cevheri: %d~n~Durum: Yeniden Dolduruluyor", PlayerGunProgress [ playerid ], PlayerGunOre [ playerid ], PlayerGunSecondaryOre [ playerid ] ) ) ;

	ActionPanel_ChangeGUI ( playerid, sprintf("@ Genel Ilerleme: %d~n~Bakir Cevheri: %d~n~Kalay Cevheri: %d~n~Durum: Yeniden Dolduruluyor", PlayerGunProgress [ playerid ], PlayerGunOre [ playerid ], PlayerGunSecondaryOre [ playerid ] )) ;


	if ( PlayerGunProgress [ playerid ] >= 100 ) {

		if ( GivePlayerItemByParam ( playerid, PARAM_GUNCREATION, FRACTURED_SUBSTANCE, 1, 0, FRACTURED_SUBSTANCE, 0 ) ) { 

			PlayerGunProgress [ playerid ] = 0 ;
			PlayerGunOre [ playerid ] = 0 ;
			PlayerGunSecondaryOre [ playerid ] = 0 ;
			return SendServerMessage ( playerid, "Kýrýk bir madde aldýnýz. Külçeye dönüþtürmek için soðutun.", MSG_TYPE_INFO ) ;
		}

		else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Kýrýk bir madde almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
	}

	if ( ticks > 0 ) {

		ticks -- ;

		SetTimerEx("FurnaceRefillTime", 750, false, "iif", playerid, ticks, amount ) ;
	}

	else if ( ticks <= 0 ) {

		SendServerMessage ( playerid, "Fýrýn sönmüþ gibi görünüyor - yeniden doldurmalýsýnýz.", MSG_TYPE_ERROR ) ;
		//PlayerTextDrawSetString(playerid, actionGUI_infoText, sprintf("@ Genel Ilerleme: %d~n~Bakir Cevheri: %d~n~Kalay Cevheri: %d~n~Durum: Bosta", PlayerGunProgress [ playerid ], PlayerGunOre [ playerid ], PlayerGunSecondaryOre [ playerid ] ) ) ;

		ActionPanel_ChangeGUI ( playerid, sprintf("@ Genel Ilerleme: %d~n~Bakir Cevheri: %d~n~Kalay Cevheri: %d~n~Durum: Bosta", PlayerGunProgress [ playerid ], PlayerGunOre [ playerid ], PlayerGunSecondaryOre [ playerid ] ) ) ;
	}

	return true ;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys) {

	if ( newkeys & KEY_WALK && IsPlayerInGunCreationArea ( playerid ) ) {

		if(!IsPlayerManager(playerid)) { return SendServerMessage(playerid,"Silah üretimi, mevcut sorunlarý düzeltirken devre dýþý býrakýldý, verdiðimiz rahatsýzlýktan dolayý özür dileriz.",MSG_TYPE_ERROR); }
	
		if ( Character [ playerid ] [ character_level ] < 3 ) {

			return SendServerMessage ( playerid, "Seviyeniz en az 3 olmalý.", MSG_TYPE_ERROR ) ;
		}

		if ( IsPlayerInRangeOfPoint ( playerid, 2.5, -1212.5631, 1831.2927, 42.3896 ) ) { // kömür toplama

			if ( DoesPlayerHaveItemByExtraParam ( playerid, FURNACE_COAL ) != -1 ) {

				return SendServerMessage ( playerid, "Zaten biraz kömürün var. Daha fazlasýný almadan önce fýrýna ekle.", MSG_TYPE_ERROR );
			}

			if ( GivePlayerItemByParam ( playerid, PARAM_GUNCREATION, FURNACE_COAL, 1, 0, 0, 0 ) ) { 

				SendServerMessage ( playerid, "Biraz kömür aldýn. Eritme iþlemine devam etmek için fýrýna ekle.", MSG_TYPE_INFO ) ;
			}

			else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Fýrýn Kömürü almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
		}

		else if ( IsPlayerInRangeOfPoint ( playerid, 2.5, -1218.0070, 1825.6216, 41.7440 ) ) { // silah parçasý oluþturma

			if ( DoesPlayerHaveItemByExtraParam ( playerid, INGOT  ) == -1 ) {

				return SendServerMessage ( playerid, "Yeniden þekillendirecek bir külçen yok.", MSG_TYPE_ERROR );
			}

			if ( GivePlayerItemByParam ( playerid, PARAM_GUNCREATION, GUNPART, 1, 0, 0, 0 ) ) { 

				DiscardItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, INGOT) ) ;
				SendServerMessage ( playerid, "Külçeyi bir silah parçasýna dönüþtürdün.", MSG_TYPE_INFO ) ;
			}

			else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Bir Silah Parçasý almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
		}

		else if ( IsPlayerInRangeOfPoint ( playerid, 2.5, -1223.6672, 1821.7823, 41.8300 )) { // külçe oluþturma

			// Bunun için bir nesne aldýklarýndan emin ol - ayrýca külçeyi de ekle.

			if ( DoesPlayerHaveItemByExtraParam ( playerid, FRACTURED_SUBSTANCE ) != -1 ) {

				if ( PlayerSkill [ playerid ] [ JOB_blacksmith ] == 6 ) {

					if ( GivePlayerItemByParam ( playerid, PARAM_GUNCREATION, INGOT, 3, 0, 0, 0 ) ) {

						DecreaseItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, FRACTURED_SUBSTANCE) ) ;
						SendServerMessage ( playerid, "Kýrýk Maddeyi güçlü bir külçeye dönüþtürdün.", MSG_TYPE_INFO ) ;
					}

					else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Bir külçe almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
				}

				else if ( PlayerSkill [ playerid ] [ JOB_blacksmith ] >= 4 && PlayerSkill [ playerid ] [ JOB_blacksmith ] < 6 ) {

					if ( GivePlayerItemByParam ( playerid, PARAM_GUNCREATION, INGOT, 2, 0, 0, 0 ) ) {

						DecreaseItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, FRACTURED_SUBSTANCE) ) ;
						SendServerMessage ( playerid, "Kýrýk Maddeyi güçlü bir külçeye dönüþtürdün.", MSG_TYPE_INFO ) ;
					}

					else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Bir külçe almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
				}

				else if ( PlayerSkill [ playerid ] [ JOB_blacksmith ] <= 3 ) {

					if ( GivePlayerItemByParam ( playerid, PARAM_GUNCREATION, INGOT, 1, 0, 0, 0 ) ) {

						DecreaseItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, FRACTURED_SUBSTANCE) ) ;
						SendServerMessage ( playerid, "Kýrýk Maddeyi güçlü bir külçeye dönüþtürdün.", MSG_TYPE_INFO ) ;
					}

					else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Bir külçe almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
				}

				else return SendServerMessage ( playerid, "Bir þeyler ters gitti. Bir külçe almanýz gerekiyordu. Geliþtiriciden geri ödeme isteyin ve ekran görüntüsü alýn.", MSG_TYPE_ERROR ) ;
			}

			else return SendServerMessage ( playerid, "Yeniden þekillendirecek Kýrýk Madden yok.", MSG_TYPE_ERROR ) ;
		}

		else if ( IsPlayerInRangeOfPoint ( playerid, 2.5, -1214.9054, 1819.7556, 40.3845 )) { // fýrýn

			if ( PlayerGunOre [ playerid ] < 10 || PlayerGunSecondaryOre [ playerid ] < 5 ) {

				if ( PlayerGunOre [ playerid ] < 10 ) {

					if ( DoesPlayerHaveItemByExtraParam ( playerid, MINE_COPPER_ORE ) == -1 ) {

						return SendServerMessage ( playerid, "Fýrýna eklemek için biraz bakýr cevherine ihtiyacýn var.", MSG_TYPE_ERROR ) ;
					}

					PlayerGunOre [ playerid ] ++ ;
					DecreaseItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, MINE_COPPER_ORE ), 1 ) ;

					SendServerMessage ( playerid, sprintf("Fýrýna biraz bakýr cevheri eklendi. %d tane daha eklemen gerekiyor.", 10 - PlayerGunOre [ playerid ] ), MSG_TYPE_INFO ) ;
				}

				else if ( PlayerGunOre [ playerid ] >= 10 &&  PlayerGunSecondaryOre [ playerid ] < 5 ) {

					if ( DoesPlayerHaveItemByExtraParam ( playerid, MINE_TIN_ORE ) == -1 ) {

						return SendServerMessage ( playerid, "Fýrýna eklemek için biraz kalay cevherine ihtiyacýn var.", MSG_TYPE_ERROR ) ;
					}

					PlayerGunSecondaryOre [ playerid ] ++ ;
					DecreaseItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, MINE_TIN_ORE ), 1 ) ;

					SendServerMessage ( playerid, sprintf("Fýrýna biraz kalay cevheri eklendi. %d tane daha eklemen gerekiyor.", 5 - PlayerGunSecondaryOre [ playerid ] ), MSG_TYPE_INFO ) ;
				}


			}

			else if ( PlayerGunOre [ playerid ] >= 10 && PlayerGunSecondaryOre [ playerid ] >= 5 ) {

				if ( DoesPlayerHaveItemByExtraParam ( playerid, FRACTURED_SUBSTANCE ) != -1 ) {

					return SendServerMessage ( playerid, "Kýrýk bir madden var. Ondan bir külçe yapmak için soðutman gerekiyor.", MSG_TYPE_ERROR );
				}

				if ( DoesPlayerHaveItemByExtraParam ( playerid, FURNACE_COAL ) == -1 ) {

					return SendServerMessage ( playerid, "Fýrýný besleyecek ham madden yok.", MSG_TYPE_ERROR ) ;
				}

				else if ( DoesPlayerHaveItemByExtraParam ( playerid, FURNACE_COAL) != -1 ) {

					SendServerMessage ( playerid, "Fýrýna biraz kömür ekledin.", MSG_TYPE_INFO ) ;
					DiscardItem ( playerid, DoesPlayerHaveItemByExtraParam ( playerid, FURNACE_COAL ) ) ;

					SetTimerEx("FurnaceRefillTime", 750, false, "iif", playerid, 10, 0.75 ) ;
				}

				PlayerGunProgress [ playerid ] += 5 ;
			}
		}

		else if ( IsPlayerInRangeOfPoint ( playerid, 2.5, -1227.2146, 1835.9607, 41.6191 ) ) { //silah oluþturma

			if ( DoesPlayerHaveItemByExtraParam ( playerid, GUNPART ) == -1 ) {

				return SendServerMessage ( playerid, "Silah parçan yok.", MSG_TYPE_ERROR ) ;
			}

			if ( Character [ playerid ] [ character_handweapon ] ) {

	      		return SendServerMessage ( playerid, "Zaten bir silah kuþanmýþken baþka bir silah üretemezsin.", MSG_TYPE_ERROR ) ;
	      	}

	      	if ( PlayerCraftingGunComponant [ playerid ] ) {

	      		return SendServerMessage ( playerid, "Zaten bir silah veya mermi üretiyorsun.", MSG_TYPE_ERROR ) ;
	      	}

		 	task_yield ( 1 ) ;

			new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
			await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Üretmek istediðiniz silahý seçin. - Silah Parçalarý: %d",GetTotalItemAmountByExtraParam ( playerid, GUNPART )), \
				"Silah\tMiktar\n\
				Revolver\t4 Silah Parçasý\n\
				Pompalý Tüfek\t6 Silah Parçasý\n\
				Kýsa Pompalý Tüfek\t6 Silah Parçasý\n\
				Tüfek\t8 Silah Parçasý\n\
				Keskin Niþancý Tüfeði\t8 Silah Parçasý\n\
				Tabanca Mermisi\t3 Silah Parçasý\n\
				Pompalý Tüfek Mermisi\t4 Silah Parçasý\n\
				Tüfek Mermisi\t5 Silah Parçasý\n", \
				\
				"Seç", "Ýptal" \
			);

			if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

				return false ;
			}

			else if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

				new amount = -1 ;
				switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {

					case 0: { // deagle - 4

						if ( Character [ playerid ] [ character_level ] < 4 ) {

							return SendServerMessage ( playerid, "Bir revolver üretmek için seviye 4 olmalýsýn.", MSG_TYPE_ERROR ) ;
						}
						
						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 4 ) {

							amount = 4 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 4 tane lazým.", MSG_TYPE_ERROR ) ;
					}

					case 1: { // shotgun - 6

						if ( Character [ playerid ] [ character_level ] < 4 ) {

							return SendServerMessage ( playerid, "Bir pompalý tüfek üretmek için seviye 4 olmalýsýn.", MSG_TYPE_ERROR ) ;
						}
							
						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 6 ) {

							amount = 6 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 6 tane lazým.", MSG_TYPE_ERROR ) ;
					}

					case 2: { // Sawn off - 6

						if ( Character [ playerid ] [ character_level ] < 3 ) {

							return SendServerMessage ( playerid, "Bir kýsa pompalý tüfek üretmek için seviye 3 olmalýsýn.", MSG_TYPE_ERROR ) ;
						}

						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 6 ) {

							amount = 6 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 6 tane lazým.", MSG_TYPE_ERROR ) ;		 					
					}

					case 3: { // rifle - 8

						if ( Character [ playerid ] [ character_level ] < 6 ) {

							return SendServerMessage ( playerid, "Bir tüfek üretmek için seviye 6 olmalýsýn.", MSG_TYPE_ERROR ) ;
						}

						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 8 ) {

							amount = 8 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 8 tane lazým.", MSG_TYPE_ERROR ) ;		 					
					}

					case 4: { // sniper - 8

						if ( Character [ playerid ] [ character_level ] < 8 ) {

							return SendServerMessage ( playerid, "Dürbünlü bir tüfek üretmek için seviye 8 olmalýsýn.", MSG_TYPE_ERROR ) ;
						}
						
						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 8 ) {

							amount = 8 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 8 tane lazým.", MSG_TYPE_ERROR ) ;
					}
					case 5: { // pistol ammo - 3
						
						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 3 ) {

							if ( GetPlayerItemCount ( playerid ) >= GetMaxPlayerItems ( ) ) {

								return SendServerMessage ( playerid, "Yeterli envanter yuvanýz yok!", MSG_TYPE_ERROR) ;
							}

							if ( GetPlayerItemCount ( playerid ) >= GetPlayerBackpackSize ( playerid ) ) {

								return SendServerMessage ( playerid, "Bu eþyayý almak için yeterli çanta boyutunuz yok. Daha büyük bir çanta almalýsýnýz.", MSG_TYPE_ERROR ) ;
							}

							amount = 3 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 3 tane lazým.", MSG_TYPE_ERROR ) ;
					}
					case 6: { // shotgun ammo - 4
						
						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 4 ) {

							if ( GetPlayerItemCount ( playerid ) >= GetMaxPlayerItems ( ) ) {

								return SendServerMessage ( playerid, "Yeterli envanter yuvanýz yok!", MSG_TYPE_ERROR) ;
							}

							if ( GetPlayerItemCount ( playerid ) >= GetPlayerBackpackSize ( playerid ) ) {

								return SendServerMessage ( playerid, "Bu eþyayý almak için yeterli çanta boyutunuz yok. Daha büyük bir çanta almalýsýnýz.", MSG_TYPE_ERROR ) ;
							}

							amount = 4 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 4 tane lazým.", MSG_TYPE_ERROR ) ;
					}
					case 7: { // rifle ammo - 5
						
						if ( GetTotalItemAmountByExtraParam ( playerid, GUNPART ) >= 5 ) {

							if ( GetPlayerItemCount ( playerid ) >= GetMaxPlayerItems ( ) ) {

								return SendServerMessage ( playerid, "Yeterli envanter yuvanýz yok!", MSG_TYPE_ERROR) ;
							}

							if ( GetPlayerItemCount ( playerid ) >= GetPlayerBackpackSize ( playerid ) ) {

								return SendServerMessage ( playerid, "Bu eþyayý almak için yeterli çanta boyutunuz yok. Daha büyük bir çanta almalýsýnýz.", MSG_TYPE_ERROR ) ;
							}

							amount = 5 ;
						}

						else return SendServerMessage ( playerid, "Yeterli silah parçan yok. En az 5 tane lazým.", MSG_TYPE_ERROR ) ;
					}
				}

				if ( amount != -1 ) { 

					if ( PlayerSkill [ playerid ] [ JOB_blacksmith ] == 6 ) { SetTimerEx("GunCreationTimer", LVL3GUNSMITHTIME, false, "iii", playerid, dialog_response [ E_DIALOG_RESPONSE_Listitem ], amount); SetTimerEx("GunCreationCountdownTimer", 975, false, "ii", playerid, 20); }
					else if ( PlayerSkill [ playerid ] [ JOB_blacksmith ] >= 4 && PlayerSkill [ playerid ] [ JOB_blacksmith ] < 6 ) { SetTimerEx("GunCreationTimer", LVL2GUNSMITHTIME, false, "iii", playerid, dialog_response [ E_DIALOG_RESPONSE_Listitem ], amount); SetTimerEx("GunCreationCountdownTimer", 975, false, "ii", playerid, 40); }
					else if ( PlayerSkill [ playerid ] [ JOB_blacksmith ] < 2 ) { SetTimerEx("GunCreationTimer", LVL1GUNSMITHTIME, false, "iii", playerid, dialog_response [ E_DIALOG_RESPONSE_Listitem ], amount); SetTimerEx("GunCreationCountdownTimer", 975, false, "ii", playerid, 60); }
					TogglePlayerControllable ( playerid, false ) ;

					PlayerCraftingGunComponant [ playerid ] = 1 ;

				}

				else return SendServerMessage ( playerid, "Bir þeyler ters gitti, lütfen bir geliþtiriciye ekran görüntüsü gönderin.", MSG_TYPE_ERROR ) ;
			}

			return 1;
		}
	}
	
	#if defined gun2_OnPlayerKeyStateChange
		return gun2_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange gun2_OnPlayerKeyStateChange
#if defined gun2_OnPlayerKeyStateChange
	forward gun2_OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys);
#endif

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA: areaid) {

	if ( areaid == GunCreationArea ) {

		if(IsPlayerManager(playerid)) { SetupActionGUI ( playerid, ACTION_TYPE_GUN ) ; }
	}
	
	#if defined gun2_OnPlayerEnterDynamicArea
		return gun2_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA: areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea gun2_OnPlayerEnterDynamicArea
#if defined gun2_OnPlayerEnterDynamicArea
	forward gun2_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA: areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA: areaid) {

	if ( areaid == GunCreationArea ) {

		HideActionGUI ( playerid ) ;
	}
	
	#if defined gun2_OnPlayerLeaveDynamicArea
		return gun2_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA: areaid );
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea gun2_OnPlayerLeaveDynamicArea
#if defined gun2_OnPlayerLeaveDynamicArea
	forward gun2_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA: areaid );
#endif

IsPlayerInGunCreationArea ( playerid ) {

	if ( IsPlayerInDynamicArea(playerid, GunCreationArea ) ) {

		return true ;
	}

	else return false ;
}

forward GunCreationTimer(playerid, id, amount);
public GunCreationTimer(playerid, id, amount) {

	switch ( id ) {

		case 0: {

			wep_GivePlayerWeapon ( playerid, WEAPON_DEAGLE, 0 ) ;
			SendServerMessage ( playerid, "Bir Revolver ürettin.", MSG_TYPE_INFO ) ;
		}

		case 1: {

			wep_GivePlayerWeapon ( playerid, WEAPON_SHOTGUN, 0 ) ;
			SendServerMessage ( playerid, "Bir Pompalý Tüfek ürettin.", MSG_TYPE_INFO ) ;
		}

		case 2: {

			wep_GivePlayerWeapon ( playerid, WEAPON_SAWEDOFF, 0 ) ;
			SendServerMessage ( playerid, "Bir Kýsa Pompalý Tüfek ürettin.", MSG_TYPE_INFO ) ;
		}

		case 3: {

			wep_GivePlayerWeapon ( playerid, WEAPON_RIFLE, 0 ) ;
			SendServerMessage ( playerid, "Bir Tüfek ürettin.", MSG_TYPE_INFO ) ;
		}

		case 4: {

			wep_GivePlayerWeapon ( playerid, WEAPON_SNIPER, 0 ) ;
			SendServerMessage ( playerid, "Bir Keskin Niþancý Tüfeði ürettin.", MSG_TYPE_INFO ) ;
		}

		case 5: {

			GivePlayerItemByParam ( playerid, PARAM_AMMO, AMMO_CRATE_PISTOL, 1, 0, 0, 0 ) ;
			SendServerMessage ( playerid, "Bir Tabanca Mermisi Sandýðý ürettin.", MSG_TYPE_INFO ) ;
		}

		case 6: {

			GivePlayerItemByParam ( playerid, PARAM_AMMO, AMMO_CRATE_SHOTGUN, 1, 0, 0, 0 ) ;
			SendServerMessage ( playerid, "Bir Pompalý Tüfek Mermisi Sandýðý ürettin.", MSG_TYPE_INFO ) ;
		}

		case 7: {

			GivePlayerItemByParam ( playerid, PARAM_AMMO, AMMO_CRATE_RIFLE, 1, 0, 0, 0 ) ;
			SendServerMessage ( playerid, "Bir Tüfek Mermisi Sandýðý ürettin.", MSG_TYPE_INFO ) ;
		}

		default: { return SendServerMessage ( playerid, sprintf("Bir þeyler ters gitti, ekran görüntüsü alýp bir geliþtiriciye gönderin. ID: %i", id ), MSG_TYPE_ERROR ) ; }
	}

	TogglePlayerControllable ( playerid, true ) ;

	PlayerCraftingGunComponant [ playerid ] = 0 ;

	return DecreaseItemByExtraParam ( playerid, GUNPART, amount ) ;
}

forward GunCreationCountdownTimer(playerid, time);
public GunCreationCountdownTimer(playerid, time) {

	if ( time <= 0 ) { return true ; }

	GameTextForPlayer(playerid, sprintf("~r~%d~w~ saniye kaldi.", time)	, 974, 3 ) ;

	SetTimerEx("GunCreationCountdownTimer", 975, false, "ii", playerid, time-1);
	return true ;
}
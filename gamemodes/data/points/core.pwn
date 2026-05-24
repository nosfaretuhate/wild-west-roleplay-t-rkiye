/*


	BLACKSMITH STORE:

	- Bucket
	- Hammer
	- Pickaxe

	HUNTING STORE:

	 - Hunting Knife

	LIQUOR STORE:

	 - Equipable bottles, supporting every model. (can be equipped and unequipped)

	GENERAL STORE:

	 - Pack of cigarettes (rolled, pre-rolled) and pack of cigars
	( Both of these should offer the appropiate object )

	GUN STORE: 
	(limit purchases for weapon permit ppl)

	- Desert Eagle
	- Shotgun
	- Sawed off Shotgun
	- Rifle
	- Scoped Rifle
*/
#define MAX_FURNITURE_NAME (36)
#define MAX_FURNITURE_LIMIT (100)

enum
{
	FURNI_BUY,
	FURNI_EDIT,
	FURNI_EDIT_TEXTURE,
	FURNI_DELETE
}

enum { // biz types
	POINT_TYPE_GEN_STORE = 0,
	POINT_TYPE_GUN_STORE = 1,
	POINT_TYPE_CLOTHING,
	POINT_TYPE_BARBER,
	POINT_TYPE_LIQUOR,
	POINT_TYPE_SALOON,
	POINT_TYPE_HUNTING,
	POINT_TYPE_BANK,
	POINT_TYPE_POSTAL,
	POINT_TYPE_SHERIFF,
	POINT_TYPE_BLACKSMITH,
	POINT_TYPE_STABLEMASTER
} ;

new CharacterPointID[MAX_PLAYERS];

#include "data/points/func/data.pwn"
#include "data/points/func/man.pwn"
#include "data/points/telegram/func/data.pwn"
#include "data/points/func/misc.pwn"

#include "data/points/furniture/data.pwn"
#include "data/points/furniture/func.pwn"
#include "data/points/furniture/utils.pwn"

#include "data/points/func/buy/skins.pwn"

public OnPlayerConnect(playerid)
{
	CharacterPointID[playerid] = -1;
	#if defined points_OnPlayerConnect
		return points_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect points_OnPlayerConnect
#if defined points_OnPlayerConnect
	forward points_OnPlayerConnect(playerid);
#endif

GetPointExteriorPosition(pointid,&Float:x,&Float:y,&Float:z) {

	if(pointid != -1) {

		x = Point[pointid][point_ext_x];
		y = Point[pointid][point_ext_y];
		z = Point[pointid][point_ext_z];
		return true;
	}
	return false;
}

GetCharacterPointID(playerid) return CharacterPointID[playerid];
SetCharacterPointID(playerid,pointid) {

	CharacterPointID[playerid] = pointid;
	return true;
}
ResetCharacterPointID(playerid) {

	CharacterPointID[playerid] = -1;
	return true;
}

DoesPlayerOwnPoint(playerid,pointid) {

	return (Point[pointid][point_owner] == Character[playerid][character_id]) ? (true) : (false);
}

GetPointType(pointid) {

	return Point[pointid][point_type];
}

GetPlayerOwnedPoints ( playerid, type = -1 ) {
	new count = 0 ;

	switch ( type ) {

		case -1: {

			for ( new i; i < MAX_POINTS; i ++ ) {

				if ( Point [ i ] [ point_id ] != -1 ) {

					if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

						count ++ ;
					}

					else continue ;
				}

				else continue ;
			}
		}

		case POINT_TYPE_HOUSE: {

			for ( new i; i < MAX_POINTS; i ++ ) {

				if ( Point [ i ] [ point_id ] != -1 ) {

					if ( Point [ i ] [ point_type ] == POINT_TYPE_HOUSE ) {

						if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

							count ++ ;
						}

						else continue;
					}

					else continue ;
				}

				else continue ;
			}
		}

		case POINT_TYPE_BIZ: {

			for ( new i; i < MAX_POINTS; i ++ ) {

				if ( Point [ i ] [ point_id ] != -1 ) {

					if ( Point [ i ] [ point_type ] == POINT_TYPE_BIZ ) {

						if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

							count ++ ;
						}

						else continue;
					}

					else continue ;
				}

				else continue ;
			}
		}
	}

	return count ;
}


IsPlayerNearPoint(playerid,Float:distance) {

	for(new i; i < MAX_POINTS; i++) {

		if(Point[i][point_id] != -1) {

			if(IsPlayerInRangeOfPoint(playerid,distance,Point[i][point_ext_x],Point[i][point_ext_y],Point[i][point_ext_z])) {

				return true;
			}
			else if(IsPlayerInRangeOfPoint(playerid,distance,Point[i][point_int_x],Point[i][point_int_y],Point[i][point_int_z])) {

				return true;
			}
			else continue;
		}
		else continue;
	}
	return false;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys) {

	if ( newkeys & KEY_CTRL_BACK ) {

		if ( IsPlayerRidingHorse [ playerid ] ) {

			return SendServerMessage ( playerid, "At üstünde bu giriþten giremezsin.", MSG_TYPE_ERROR ) ;
		}

		if ( Character [ playerid ] [ character_prison ] ) {

			return SendServerMessage ( playerid, "Hapiste iken kullanýlamaz.", MSG_TYPE_ERROR ) ;
		}

		new query [ 256 ] ; 

		if ( GetPlayerInterior ( playerid == 0 ) || GetPlayerVirtualWorld(playerid) == 0 ) {

			ResetCharacterPointID(playerid);
		}

		if(GetCharacterPointID(playerid) == -1) {

			for ( new i; i < MAX_POINTS; i ++ ) {
				if ( Point [ i ] [ point_id ] != -1 ) {
					if ( IsPlayerInRangeOfPoint(playerid, 1.5, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int ] ) {

						if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

							SendServerMessage ( playerid, "Bu mülkün sahibisin /point ile kontrol edebilirsin.", MSG_TYPE_INFO ) ;

							if ( Point [ i ] [ point_type ] == POINT_TYPE_BIZ ) {
								SendServerMessage ( playerid, sprintf("Ýþletme kasasýnda seni bekleyen %s var.", IntegerWithDelimiter( Point [ i ] [ point_till ])), MSG_TYPE_INFO );
							}
						}

						if ( Point [ i ] [ point_locked ] ) {

							return SendServerMessage ( playerid, "Kapýyý açmaya çalýþýrken kilitli olduðunu fark ediyorsun.", MSG_TYPE_ERROR ) ;
						}

						if ( Point [ i ] [ point_fee ] ) {
							//if ( Character [ playerid ] [ character_handmoney ] < Point [ i ] [ point_fee ] ) {
							if(Character[playerid][character_handmoney] == 0 && Character[playerid][character_handchange] < Point[i][point_fee]) {

								return SendServerMessage ( playerid, "Ýþyeri giriþ ücretini karþýlayamýyorsun.", MSG_TYPE_ERROR ) ;
							}

							TakeCharacterChange ( playerid, Point [ i ] [ point_fee ], MONEY_SLOT_HAND ) ;
							Point [ i ] [ point_till_change ] += Point [ i ] [ point_fee ] ;
							if(Point[i][point_till_change] >= 100) {

								Point[i][point_till]++;
								Point[i][point_till_change] = 0;
							}

							SendServerMessage ( playerid, sprintf("Ýþyeri giriþ ücreti olarak $%s ödedin.", IntegerWithDelimiter ( Point [ i ] [ point_fee ] ) ), MSG_TYPE_INFO ) ;

							mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_till = %d,point_till_change = %d WHERE point_id = %d", Point [ i ] [ point_till ], Point[i][point_till_change],Point [ i ] [ point_id ] ) ;
							mysql_tquery ( mysql, query ) ;
						}


						BlackScreen ( playerid ) ;

						ac_SetPlayerPos(playerid, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ],  Point [ i ] [ point_int_z ] ) ;

						if ( Point [ i ] [ point_type ] == POINT_TYPE_BIZ ) {
		 					switch ( Point [ i ] [ point_biztype ] ) {


								case POINT_TYPE_GEN_STORE: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_GUN_STORE: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_CLOTHING: {

									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy [opsiyonel: mask(maske), attachments(aksesuar), misc(diðer)]", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_BARBER: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: Yok", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_LIQUOR: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_SALOON: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_HUNTING: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy - envanterinden eþya satabilirsin.", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_BANK: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /bank", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_POSTAL: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /advertise(reklam), /paycheck(maaþýný çek), /buytelegramnumber(telegram numarasý satýn al), /tele(gram)", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_SHERIFF: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: Yok", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_BLACKSMITH: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy", MSG_TYPE_INFO ) ;
								}

								case POINT_TYPE_STABLEMASTER: {
									SendServerMessage ( playerid, "Kullanýlabilir komutlar: /buy, /revivehorse(atý iyileþtir)", MSG_TYPE_INFO ) ;
								}
							}
						}

						SetPlayerVirtualWorld(playerid, Point [ i ] [ point_int_vw ]) ;
						SetPlayerInterior(playerid, Point [ i ] [ point_int_int ]) ;

						if ( Point [ i ] [ point_int_vw ] || Point [ i ] [ point_int_int ] ) {
							// FadeIn ( playerid ) ;
							SetPlayerWeather ( playerid, 0 ) ;
							SetPlayerTime(playerid, 14, 0) ;

							PlayerTextDrawSetString ( playerid, TD_ZoneName, "San Andreas" ) ;
							PlayerTextDrawShow(playerid, TD_ZoneName ) ;

							PlayAudioStreamForPlayer(playerid, "http://play.ww-rp.net/ambient/ambient_interior.mp3");
						}

						SetCharacterPointID(playerid,i);
						//SendClientMessage(playerid, -1, sprintf("id: %d",i));
						return true;
					}
					/*
					else if ( IsPlayerInRangeOfPoint(playerid, 1.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ],  Point [ i ] [ point_int_z ] ) &&
					GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

						if ( Point [ i ] [ point_locked ] ) {

							return SendServerMessage ( playerid, "The door is locked. You can't leave now. If you are stuck, call an admin.", MSG_TYPE_ERROR ) ;
						}

						//BlackScreen ( playerid ) ;

						ac_SetPlayerPos(playerid, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ],  Point [ i ] [ point_ext_z ] ) ;
						SetPlayerTime(playerid, serverHour, serverMin) ;

						SetPlayerVirtualWorld(playerid, Point [ i ] [ point_vw ]) ;
						SetPlayerInterior(playerid, Point [ i ] [ point_int] ) ;

						Streamer_Update(playerid);

						//if ( Point [ i ] [ point_int_vw ] || Point [ i ] [ point_int_vw ] ) {

						//FadeIn ( playerid ) ;
						//}
					}

					else continue ;
					*/
				}

				else continue ;
			}
		}
		else {

			new id = GetCharacterPointID(playerid);

			//SendClientMessage(playerid, -1, sprintf("get id: %d",id));
			if ( IsPlayerInRangeOfPoint(playerid, 1.5, Point [ id ] [ point_int_x ],  Point [ id ] [ point_int_y ],  Point [ id ] [ point_int_z ] ) &&
				GetPlayerVirtualWorld ( playerid ) == Point [ id ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ id ] [ point_int_int ] ) {

				if ( Point [ id ] [ point_locked ] ) {

					return SendServerMessage ( playerid, "Kapý kilitli çýkamazsýn, eðer sýkýþtýysan /helpme kullanmaktan çekinme.", MSG_TYPE_ERROR ) ;
				}

				//BlackScreen ( playerid ) ;

				ac_SetPlayerPos(playerid, Point [ id ] [ point_ext_x ],  Point [ id ] [ point_ext_y ],  Point [ id ] [ point_ext_z ] ) ;
				SetPlayerTime(playerid, serverHour, serverMin) ;

				SetPlayerVirtualWorld(playerid, Point [ id ] [ point_vw ]) ;
				SetPlayerInterior(playerid, Point [ id ] [ point_int] ) ;

				ResetCharacterPointID(playerid);
				//SendClientMessage(playerid, -1, sprintf("id: %d",GetCharacterPointID(playerid)));

				//if ( Point [ id ] [ point_int_vw ] || Point [ id ] [ point_int_vw ] ) {

					//FadeIn ( playerid ) ;
				//}
			}	
		}

		return true ;
	}
	
	#if defined point_OnPlayerKeyStateChange
		return point_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange point_OnPlayerKeyStateChange
#if defined point_OnPlayerKeyStateChange
	forward point_OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys);
#endif

OnPlayerSell ( playerid, itemid, tileid ) {

	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				switch ( Point [ i ] [ point_biztype ] ) {

					case POINT_TYPE_HUNTING: {

						// Fishing items
						if ( Item [ itemid ] [ item_extra_param ] == FISHING_BLUE_1 ||  Item [ itemid ] [ item_extra_param ] == FISHING_BLUE_2 ||
					 	Item [ itemid ] [ item_extra_param ] == FISHING_YELLOW ||  Item [ itemid ] [ item_extra_param ] == FISHING_BIGFISH ||
					  	Item [ itemid ] [ item_extra_param ] == FISHING_SHARK || Item [ itemid ] [ item_extra_param ] == WILDLIFE_HIDE || 
					  	Item [ itemid ] [ item_extra_param ] == WILDLIFE_MEAT || Item [ itemid ] [ item_extra_param ] == WILDLIFE_MEAT_LEG) {

						
							//new amount = PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ] ;
							//new money = amount / 10 ;
							new change ;
							switch(Item [ itemid ] [ item_extra_param ]) {

								case FISHING_BLUE_1: {

									change = randomEx(10,21);
								}
								case FISHING_BLUE_2: {

									change = randomEx(20,34);
								}
								case FISHING_YELLOW: {

									change = randomEx(8,20);
								}
								case FISHING_BIGFISH: {

									change = randomEx(13,28);
								}
								case FISHING_SHARK: {

									change = randomEx(50,99);
								}
								case WILDLIFE_HIDE: {

									change = randomEx(20,60);
								}
								case WILDLIFE_MEAT,WILDLIFE_MEAT_LEG: {

									change = randomEx(25,70);
								}
							}

							DecreaseItem ( playerid, tileid, 1 ) ;
							//GiveCharacterMoney ( playerid, money, MONEY_SLOT_HAND ) ;
							GiveCharacterChange(playerid,change,MONEY_SLOT_HAND);

							if ( DoingTask [ playerid ] == 1 || DoingTask [ playerid ] == 7 ) {

								ProcessTask ( playerid, DoingTask [ playerid ] ) ;
							}

							SendServerMessage ( playerid, sprintf("%s adlý eþyayý $0.%02d karþýlýðýnda sattýn.", Item [ itemid ] [ item_name ], change ), MSG_TYPE_INFO ) ;
							return true ;
						}

						else return false ;
					}

					case POINT_TYPE_BLACKSMITH: {

						// Mining items
						if ( Item [ itemid ] [ item_extra_param ] == MINE_ROCK || Item [ itemid ] [ item_extra_param ] == MINE_IRON_ORE || Item [ itemid ] [ item_extra_param ] == MINE_COPPER_ORE ||
							Item [ itemid ] [ item_extra_param ] == MINE_GOLD_ORE || Item [ itemid ] [ item_extra_param ] == MINE_COAL_ORE || Item [ itemid ] [ item_extra_param ] == MINE_TIN_ORE  ) {

							
							//new amount = PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ] ;
							//new money = amount / 7 ;
							new change ;

							switch(Item [ itemid ] [ item_extra_param ]) {

								case MINE_ROCK: {

									change = randomEx(1,5);
								}
								case MINE_IRON_ORE,MINE_COPPER_ORE: {

									change = randomEx(15,33);
								}
								case MINE_GOLD_ORE: {

									change = randomEx(45,85);
								}
								case MINE_COAL_ORE,MINE_TIN_ORE: {

									change = randomEx(13,31);
								}
							}
							DecreaseItem ( playerid, tileid, 1 ) ;
							//GiveCharacterMoney ( playerid, money, MONEY_SLOT_HAND ) ;
							GiveCharacterChange(playerid,change,MONEY_SLOT_HAND);

							if ( DoingTask [ playerid ] == 5 ) {

								ProcessTask ( playerid, DoingTask [ playerid ] ) ;
							}

							SendServerMessage ( playerid, sprintf("%s adlý eþyayý $0.%02d karþýlýðýnda sattýn.", Item [ itemid ] [ item_name ], change ), MSG_TYPE_INFO ) ;

							return true ;
						}

						// Woodcut items
						else if ( Item [ itemid ] [ item_extra_param ] == LUMBER_OAK_LOG || Item [ itemid ] [ item_extra_param ] == LUMBER_BIRCH_LOG || Item [ itemid ] [ item_extra_param ] == LUMBER_YEW_LOG  ) {

							//new amount = PlayerItem [ playerid ] [ tileid ] [ player_item_param1 ] ;
							//new money = amount / 7 ;
							new change ;	

							switch(Item [ itemid ] [ item_extra_param ]) {

								case LUMBER_OAK_LOG: {

									change = randomEx(8,21);
								}
								case LUMBER_BIRCH_LOG: {

									change = randomEx(6,15);
								}
								case LUMBER_YEW_LOG: {

									change = randomEx(15,30);
								}
							}

							DecreaseItem ( playerid, tileid, 1 ) ;
							//GiveCharacterMoney ( playerid, money, MONEY_SLOT_HAND ) ;
							GiveCharacterChange(playerid,change,MONEY_SLOT_HAND);

							if ( DoingTask [ playerid ] == 3 ) {

								ProcessTask ( playerid, DoingTask [ playerid ] ) ;
							}

							SendServerMessage ( playerid, sprintf("%s adlý eþyayý $0.%02d karþýlýðýnda sattýn.", Item [ itemid ] [ item_name ],change ), MSG_TYPE_INFO ) ;

							return true ;
						}

						else return false ;

					}

					case POINT_TYPE_GEN_STORE: {

						if ( Item[itemid][item_param] == PARAM_FARMING) {

							new money = randomEx(1,3),	change = randomEx(50,95);

							DecreaseItem ( playerid, tileid, 1 ) ;

							GiveCharacterMoney ( playerid, money, MONEY_SLOT_HAND );
							GiveCharacterChange(playerid,change,MONEY_SLOT_HAND);

							GivePlayerItemByParam ( playerid, PARAM_FARMING, EMPTY_BASKET, 1, 0, 0, 0,0);

							SendServerMessage ( playerid, sprintf("%s adlý eþyayý $%d.%02d karþýlýðýnda sattýn.", Item [ itemid ] [ item_name ], money, change ), MSG_TYPE_INFO ) ;
						}
						else return false;

					}

					default: return SendServerMessage ( playerid, "Birþeyler ters gitti bu lokasyonda satýþ yapamazsýn.", MSG_TYPE_ERROR ) ; 
				}

				// else if ( Point ) --- for mining

				//else if ( Point [ i ] ... )
			}
		}
	}

	return SendServerMessage ( playerid, "Birþeyler ters gitti bu lokasyonda satýþ yapamazsýn.", MSG_TYPE_ERROR ) ;
}

CMD:givegunpermit ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid )  ) {

		return SendServerMessage ( playerid, "Yetersiz yetki.", MSG_TYPE_INFO ) ;
	}

	new target ;

	if ( sscanf ( params, "k<u>", target )) {

		return SendServerMessage ( playerid, "/givegunpermit [oyuncuid]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected(target)) {

		return SendServerMessage ( playerid, "Oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
	}

	if (  DoesPlayerHaveItem ( target, CARD_PASSPORT) == -1 ) {

		return SendServerMessage ( playerid, "Hedefin pasaportu yok.", MSG_TYPE_ERROR );
	}


	SendServerMessage ( playerid, "Kötü kullaným yasaklanmanýza sebep olabilir.", MSG_TYPE_ERROR ) ;
	GivePlayerItemByParam ( target, PARAM_MISC, CARD_GUNPERMIT, 1, 0, 0, 0 ) ;
	SendServerMessage ( playerid, "Baþarýyla silah eriþimi verildi.", MSG_TYPE_WARN ) ;

	return true ;
}

CMD:givelicense ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid )  ) {

		return SendServerMessage ( playerid, "Yetersiz yetki.", MSG_TYPE_INFO ) ;
	}

	new target ;

	if ( sscanf ( params, "k<u>", target )) {

		return SendServerMessage ( playerid, "/givelicense [oyuncuid]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected(target)) {

		return SendServerMessage ( playerid, "Oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
	}

	GivePlayerItemByParam ( target, PARAM_MISC, CARD_PASSPORT, 1, 0, 0, 0 ) ;
	SendServerMessage ( playerid, "Baþarýyla lisans verildi.", MSG_TYPE_WARN ) ;

	return true ;
}



CMD:license ( playerid, params [] ) {

	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				if ( Point [ i ] [ point_biztype ] == POINT_TYPE_POSTAL ) {

   					GivePlayerItemByParam ( playerid, PARAM_MISC, CARD_PASSPORT, 1, 0, 0, 750 ) ;
   					return true ;
				}

				else continue ;
			}

			else continue ;
		}

		else continue ;
	}

	return true ;
}

CMD:buy ( playerid, const params [] ) {

	new option [ 32 ] ;

	if ( sscanf ( params, "S()[32]", option ) ) {
		// Nothing should happen since it's optional...
	}

	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				if ( Point [ i ] [ point_type ] != POINT_TYPE_BIZ ) {

					return SendServerMessage ( playerid, "Ýþyerinde deðilsin, eðer içerde isen iþyeri ayarlanmamýþtýr. Admin ile kontakt kurun.", MSG_TYPE_ERROR ) ;
				}

				switch ( Point [ i ] [ point_biztype ] ) {

					case POINT_TYPE_GEN_STORE: {
						return ShowGeneralStoreSelection ( playerid ) ;
					}

					case POINT_TYPE_GUN_STORE: {
						return ShowGunStoreSelection ( playerid ) ;
					}

					case POINT_TYPE_CLOTHING: {

						if ( ! strlen ( option ) ) {

							ShowSkinSelection ( playerid ) ;
							return true ;
						}

						else if ( ! strcmp ( option, "mask" ) ) {

							if ( Character [ playerid ] [ character_level ] < 10 ) {

								return SendServerMessage ( playerid, "10. seviyede olman gerekir.", MSG_TYPE_ERROR ) ;
							}

							ShowMaskSelection ( playerid ) ;
							return true ;
						}

						else if ( ! strcmp ( option, "attachments" ) ) {

							ShowToyMenu ( playerid ) ;
							return true ;
						}

						else if(!strcmp(option,"misc")) {

							ShowMiscClothingSelection(playerid);
							return true;
						}

						else return SendServerMessage ( playerid, "Bu giysi maðazasýnda bunu yapamazsýn. Doðru parametre: /buy [isteðe baðlý: mask(maske), attachments(aksesuar), misc(diðer)]", MSG_TYPE_ERROR ) ;

					}

					case POINT_TYPE_BARBER: {
						return SendServerMessage ( playerid, "Bu iþyerinde bu iþlemi yapamazsýn.", MSG_TYPE_ERROR ) ;
					}

					case POINT_TYPE_LIQUOR: {
						return ShowLiquorMenu ( playerid ) ;
					}

					case POINT_TYPE_SALOON: {
						return ShowLiquorMenu ( playerid ) ;
					}

					case POINT_TYPE_HUNTING: {
						ShowHuntingStoreSelection ( playerid ) ;
						return SendServerMessage ( playerid, "Envanterin üzerinden et satabilirsin.", MSG_TYPE_ERROR ) ;
					}

					case POINT_TYPE_BANK: {
						return SendServerMessage ( playerid, "Burada hiçbir þey alamazsýn.", MSG_TYPE_ERROR ) ;
					}

					case POINT_TYPE_POSTAL: {
						return SendServerMessage ( playerid, "/buy bu yerde çalýþmaz, /ad(reklam) ise çalýþýr.", MSG_TYPE_ERROR ) ;
					}

					case POINT_TYPE_SHERIFF: {
						return SendServerMessage ( playerid, "Burdan birþey satýn alamazsýn.", MSG_TYPE_ERROR ) ;
					}

					case POINT_TYPE_BLACKSMITH: {
						return ShowBlacksmithMenu ( playerid ) ;
					}
					case POINT_TYPE_STABLEMASTER: {
						return ShowHorseSelection ( playerid ) ;
					}
				}
			}

			else continue ;
		}

		else continue ;
	}

	return true ;
}

ShowMiscClothingSelection(playerid) {
    task_yield(1);
    new sQuery [ 256 ], dialog_response [ e_DIALOG_RESPONSE_INFO ];
    format(sQuery,sizeof(sQuery),"%d\tEldiven ($3.50)\n%d\tUzun Iclik ($6.25)\n",GLOVES_BROWN,LONGJOHNS_OBJ);
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL, "Demirci dükkaný", sQuery, "Seç", "Iptal");
    if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {
        switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {
            case 0: GivePlayerItemByParam ( playerid, PARAM_MISC, GLOVES, 1, PARAM_MISC, GLOVES, 3, 50 ) ;
            case 1: GivePlayerItemByParam ( playerid, PARAM_MISC, LONG_JOHNS, 1, PARAM_MISC, LONG_JOHNS, 6, 25 ) ;
        }
    }
    return true;
}
ShowBlacksmithMenu ( playerid ) {
    task_yield(1);
    new sQuery [ 256 ], dialog_response [ e_DIALOG_RESPONSE_INFO ];
    format(sQuery,sizeof(sQuery),"%d\tKazma ($8.04)\n19468\tKova ($2.45)\n19626\tKurek ($4.02)\n",PICKAXE);
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL, "Demirci dükkaný", sQuery, "Seç", "Iptal");
    if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {
        switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {
            case 0: {
                if ( Character [ playerid ] [ character_level ] < 2 ) return SendServerMessage ( playerid, "Bir kazma satýn almak için en az 2. seviye olmalýsýn.", MSG_TYPE_ERROR ) ;
                GivePlayerItemByParam ( playerid, PARAM_MINING, MINE_PICKAXE, 1, 0, 0, 8, 4 ) ;
            }
            case 1: GivePlayerItemByParam ( playerid, PARAM_FARMING, FARMING_PAIL, 1, 0, 0, 2, 45 ) ;
            case 2: GivePlayerItemByParam ( playerid, PARAM_FARMING, FARMING_SHOVEL, 1, 0, 0, 4, 2 ) ;
        }
        cmd_buy(playerid,"");
    }
    return true ;
}

ShowLiquorMenu ( playerid ) {


   	task_yield(1);
	
	new dialog_response [ e_DIALOG_RESPONSE_INFO ], sQuery [ 256 ] = "\
    1544\tAcik Bira ($1.23)\n\
    1543\tHafif Ale ($1.20)\n\
    1486\tMalt Likor ($2.00)\n\
    1484\tBugday Birasi ($1.89)\n\
    19824\tBeyaz Sarap ($2.05)\n\
    19822\tKirmizi Sarap ($2.11)\n\
    19823\tTahil Viski~n~($2.33)\n\
    19820\tMalt Viski~n~($2.64)\n\
    19821\tMoonshine~n~Votka ($3.05)\n\
	   	" ;

   	await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Ýçki dükkaný", sQuery, "Seç", "Iptal");
	
	if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {

			case 0: {

				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_PALELAGER, 1, 0, 0, 1,23 ) ;
			}

			case 1: {
				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_MILDALE, 1, 0, 0, 1,20 ) ;
			}

			case 2: {
				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_MALTLIQUOR, 1, 0, 0, 2 ) ;
			}

			case 3: {
				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_WHEATBEER, 1, 0, 0, 1,89 ) ;
			}

			case 4: {

				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_WHITEWINE, 1, 0, 0, 2,5 ) ;
			}

			case 5: {

				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_REDWINE, 1, 0, 0, 2,11 ) ;
			}

			case 6: {

				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_GRAINWHISKEY, 1, 0, 0, 2,33 ) ;
			}

			case 7: {

				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_MALTWHISKEY, 1, 0, 0, 2,64 ) ;
			}

			case 8: {

				GivePlayerItemByParam ( playerid, PARAM_LIQUOR, LIQUOR_VODKA, 1, 0, 0, 3,5 ) ;
			}
		}
		cmd_buy(playerid,"");
	}

	return true ;
}

CMD:revivehorse ( playerid, params [] ) {

	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				if ( Point [ i ] [ point_biztype ] == POINT_TYPE_STABLEMASTER ) {

					if ( Character [ playerid ] [ character_horseid ] == -1 ) {

						return SendServerMessage ( playerid, "Herhangi bir atýn yok.", MSG_TYPE_ERROR ) ;
					}

					if ( Character [ playerid ] [ character_horsehealth ] <= 5 ) {

						if ( Character [ playerid ] [ character_handmoney ] < 15 ) {

							return SendServerMessage ( playerid, "Atýný canlandýrmak için $15'ye ihtiyacýn var.", MSG_TYPE_ERROR ) ;
						}

						SendServerMessage ( playerid, "Atýn küçük bir ücret karþýlýðý canlandýrýldý. Artýk /spawnhorse komutunu kullanabilirsin!", MSG_TYPE_INFO ) ;

						SetHorseHealth ( playerid, -1, 100 ) ;
						TakeCharacterMoney ( playerid, 15, MONEY_SLOT_HAND ) ;
					}

					else return SendServerMessage ( playerid, "Atýn saðlýklý görünüyor, canlandýrman gerekmiyor.", MSG_TYPE_ERROR ) ;
				}

				else continue ;
			}

			else continue ;
		}

		else continue ;
	}

	SendServerMessage ( playerid, "Gereken lokasyonda deðilsin.", MSG_TYPE_ERROR ) ;

	return true ;
}

ShowHuntingStoreSelection ( playerid ) {

   	task_yield(1);
	
	new string [ 256 ], dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
	format(string,sizeof(string),"18632\tBalikci oltasi ($1.04)\n335\tAv Bicagi ($17.50)\n%d\tHayvan tuzagi ($11.32)\n",TRAP_FOOTLOCK);


   	await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Av Dükkaný", string, "Seç", "Iptal");
	
	if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {
			case 0: { // Fishing Rod

				GivePlayerItemByParam ( playerid, PARAM_FISHING, FISHING_ROD, 1, 0, 0, 1,4 ) ;
			}
			case 1: { // hunting knife

				GivePlayerItemByParam ( playerid, PARAM_HUNTING, HUNTING_KNIFE, 1, 0, 0, 17,50 ) ;
			}

			case 2: { //animal trap
				GivePlayerItemByParam ( playerid, PARAM_HUNTING, HUNTING_TRAP, 1, 0, 0, 11,32 ) ;
			}
		}
		cmd_buy(playerid,"");
	}

	return 1;


}

ShowHorseSelection ( playerid ) {

	task_yield(1);

  	new string [ 1024 ], price, dialog_response [ e_DIALOG_RESPONSE_INFO ] ;

	for ( new i; i < sizeof (  horseType  ); i ++ ) {

  		if (horseType [ i ] [ horse_enabled ] ) {

	  		price = horseType [ i ] [ h_price ] ;

	  		strcat(string, sprintf("11733\t~b~%s~w~~n~Ucret:~g~$%d~w~~n~Gereken Seviye: %d\n", horseType [ i ] [ h_td_name ], price, horseType [ i ] [ h_level_requirement ] ) ) ;
	 	}

	 	else continue ;
  	}

	await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Genel Maðaza", string, "Seç", "Ýptal");

	if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		// Id 0 is unused
		dialog_response [ E_DIALOG_RESPONSE_Listitem ] += 1 ;

		if ( horseType [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ h_donator ] && ! Account [ playerid ] [ account_donatorlevel ] ) {

			return SendServerMessage ( playerid, "Bu atý satýn almak için donator olman gerekiyor.", MSG_TYPE_ERROR ) ;
		}

		if ( horseType [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ h_level_requirement ] > Character [ playerid ] [ character_level ] ) {

			return SendServerMessage ( playerid, sprintf("Bu atý satýn almak için %d seviyede olman gerekiyor.", horseType [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ h_level_requirement ] ), MSG_TYPE_ERROR ) ;
		}

		price = horseType [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ h_price ] ;

		if ( Character [ playerid ] [ character_handmoney ] < price ) {

			return SendServerMessage ( playerid, sprintf("Gerekli paraya sahip deðilsin, $%d gerekli.", price ), MSG_TYPE_ERROR ) ;
		}

		TakeCharacterMoney ( playerid, price, MONEY_SLOT_HAND ) ;

		Character [ playerid ] [ character_horseid ] = horseType[dialog_response [ E_DIALOG_RESPONSE_Listitem ]][h_td_id] ;
		Character [ playerid ] [ character_horsehealth ] = 100 ;

		mysql_format ( mysql, string, sizeof ( string ), "UPDATE characters SET character_horseid = %d, character_horsehealth = 100 WHERE character_id = %d", Character [ playerid ] [ character_horseid ], Character [ playerid ] [ character_id ] ) ;
		mysql_tquery ( mysql, string ) ;

		SendServerMessage ( playerid, sprintf("{876C45}%s{DEDEDE} model atý {458754}$%d karþýlýðýnda aldýn.", horseType [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ h_td_name ], price ), MSG_TYPE_INFO ) ;
	}

	return true ; 
}

ShowGunStoreSelection ( playerid ) {

    /*
    if (DoesPlayerHaveItem ( playerid, CARD_PASSPORT) == -1 ) {

        return SendServerMessage ( playerid, "Burada alýþveriþ yapabilmek için gerekli belgelere sahip deðilsin.", MSG_TYPE_ERROR );
    }
    */

    if ( Character [ playerid ] [ character_level ] < 3) {

        return SendServerMessage ( playerid, "3. Seviye olman gerekli.", MSG_TYPE_ERROR ) ;
    }

    task_yield(1);

    new dialog_response [ e_DIALOG_RESPONSE_INFO ], sQuery [ 512 ] = "\
    336\tBeyzbol Sopasi ($5.00)\n\
    335\tBicak ($7.50)\n\
    348\tTabanca ($40.00)\n\
    349\tPompali Tufek ($66.00)\n\
    350\tSawn-off ($51.00)\n\
    357\tAv Tufegi ($82.00)\n\
    358\tDurbunlu Av Tufegi~n~($104.00)\n\
    2037\tTabanca mermisi~n~($2.50)\n\
    2041\tPompali tufek mermisi~n~($1.50)\n\
    2043\tYuksek kalibre mermi(av tufegi, durbunlu)~n~($3.50)";

    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Silah Dukkani", sQuery, "Sec", "Iptal");

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        return false ;
    }

    if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        if ( EquippedItem [ playerid ] >= 0 ) {

            return SendServerMessage ( playerid, "Ýlk önce kuþandýðýn eþyayý býrakman gerekmektedir.", MSG_TYPE_ERROR);
        }

        if ( Character [ playerid ] [ character_handweapon ] ) {

            return SendServerMessage ( playerid, "Elinde bir silah varken ikinciyi alamazsýn!", MSG_TYPE_ERROR ) ;
        }

        switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {

            case 0: { //bat

                if ( Character [ playerid ] [ character_level ] < 3 ) {

                    return SendServerMessage ( playerid, "Beyzbol sopasý satýn almak için 3. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handmoney ] < 5 ) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Beyzbol sopasý için 5 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 5, MONEY_SLOT_HAND ) ;
                wep_GivePlayerWeapon ( playerid, WEAPON_BAT, 1 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a baseball bat.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir beyzbol sopasý satýn aldýn.", MSG_TYPE_INFO ) ;
            }

            case 1: { //knife

                if ( Character [ playerid ] [ character_level ] < 4 ) {

                    return SendServerMessage ( playerid, "Býçak satýn almak için 4. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if(Character[playerid][character_handmoney] < 7) { return SendServerMessage ( playerid, "Yeterli paran yok. Býçak için 7.50 dolar ödemelisin.", MSG_TYPE_ERROR ) ; }

                if ( Character [ playerid ] [ character_handmoney ] == 7 && Character[playerid][character_handchange] < 50) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Býçak için 7.50 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 7, MONEY_SLOT_HAND ) ;
                TakeCharacterChange(playerid,50,MONEY_SLOT_HAND);
                wep_GivePlayerWeapon ( playerid, WEAPON_KNIFE, 1 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a knife.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir býçak satýn aldýn.", MSG_TYPE_INFO ) ;
            }

            case 2: { // Desert Eagle

                if ( Character [ playerid ] [ character_level ] < 6 ) {

                    return SendServerMessage ( playerid, "Tabanca satýn almak için 6. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handmoney ] < 40 ) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Tabanca için 40 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 40, MONEY_SLOT_HAND ) ;
                wep_GivePlayerWeapon ( playerid, WEAPON_DEAGLE, 0 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a revolver.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir tabanca satýn aldýn. Þarjörüne mermi eklemek için uygun mermi paketini satýn almalýsýn!", MSG_TYPE_INFO ) ;
            }

            case 3: { // Shotgun

                if ( Character [ playerid ] [ character_level ] < 8 ) {

                    return SendServerMessage ( playerid, "Pompalý tüfek satýn almak için 8. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handmoney ] < 66 ) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Pompalý tüfek için 66 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 66, MONEY_SLOT_HAND ) ;
                wep_GivePlayerWeapon ( playerid, WEAPON_SHOTGUN, 0 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a shotgun.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir pompalý tüfek satýn aldýn. Þarjörüne mermi eklemek için uygun mermi paketini satýn almalýsýn!", MSG_TYPE_INFO ) ;
            }

            case 4: { // Sawn Shotgun

                if ( Character [ playerid ] [ character_level ] < 8 ) {

                    return SendServerMessage ( playerid, "Sawn-off satýn almak için 8. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handmoney ] < 51 ) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Sawn-off için 51 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 51, MONEY_SLOT_HAND ) ;
                wep_GivePlayerWeapon ( playerid, WEAPON_SAWEDOFF, 0 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a sawn off shotgun.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir sawn-off satýn aldýn. Þarjörüne mermi eklemek için uygun mermi paketini satýn almalýsýn!", MSG_TYPE_INFO ) ;
            }

            case 5: { // Rifle

                if ( Character [ playerid ] [ character_level ] < 12 ) {

                    return SendServerMessage ( playerid, "Av tüfeði satýn almak için 12. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handmoney ] < 82 ) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Av tüfeði için 82 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 82, MONEY_SLOT_HAND ) ;
                wep_GivePlayerWeapon ( playerid, WEAPON_RIFLE, 0 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a rifle.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir av tüfeði satýn aldýn. Þarjörüne mermi eklemek için uygun mermi paketini satýn almalýsýn!", MSG_TYPE_INFO ) ;
            }      

            case 6: { // Sniper

                if ( Character [ playerid ] [ character_level ] < 16 ) {

                    return SendServerMessage ( playerid, "Dürbünlü av tüfeði satýn almak için 16. seviye olman gerek.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handmoney ] < 104 ) {

                    return SendServerMessage ( playerid, "Yeterli paran yok. Dürbünlü av tüfeði için 104 dolar ödemelisin.", MSG_TYPE_ERROR ) ;
                }

                TakeCharacterMoney ( playerid, 104, MONEY_SLOT_HAND ) ;
                wep_GivePlayerWeapon ( playerid, WEAPON_SNIPER, 0 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a scoped rifle.", ReturnUserName ( playerid, false, false ), playerid ) ) ;

                SendServerMessage ( playerid, "Bir dürbünlü av tüfeði satýn aldýn. Þarjörüne mermi eklemek için uygun mermi paketini satýn almalýsýn!", MSG_TYPE_INFO ) ;
            }   

            case 7: { // Pistol Ammo

                GivePlayerItemByParam ( playerid, PARAM_AMMO, AMMO_CRATE_PISTOL, 1, 0, 0, 2, 50 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a pistol ammo crate.", ReturnUserName ( playerid, false, false ), playerid ) ) ;
            }      

            case 8: { // Shotty Ammo
                GivePlayerItemByParam ( playerid, PARAM_AMMO, AMMO_CRATE_SHOTGUN, 1, 0, 0, 1, 50 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a shotgun ammo crate.", ReturnUserName ( playerid, false, false ), playerid ) ) ;
            }    

            case 9: { // Rifle Ammo

                GivePlayerItemByParam ( playerid, PARAM_AMMO, AMMO_CRATE_RIFLE, 1, 0, 0, 3, 50 ) ;

                WriteLog ( playerid, "guns/points", sprintf("%s (%d) has bought a rifle ammo crate.", ReturnUserName ( playerid, false, false ), playerid ) ) ;
            }                   
        }
        cmd_buy(playerid,"");
    }

    return true ;
}
ShowGeneralStoreSelection ( playerid ) {
 
    task_yield(1);
    
    new query [ 256 ], sQuery [ 2048 ], dialog_response [ e_DIALOG_RESPONSE_INFO ];

    format(sQuery,sizeof(sQuery),"19043\tCep Saati ($5.50)\n19623\tKamera ($45.00)\n%d\tBalta ($12.00)\n11747\tSargi Bezi ($3.46)\n19575\tKirmizi Elma ($0.20)\n19576\tYesil Elma ($0.20)\n19570\tSu Sisesi ($0.75)\n\
        19567\tKonserve Somon ($2.00)\n19567\tKonserve Sigir Eti ($1.75)\n19564\tKonserve Ananas ($1.50)\n19564\tKonserve Cilek ($1.20)\n19567\tKonserve Fasulye ($1.50)\n19564\tKonserve Seftali ($1.00)\n\
        19567\tKonserve Misir ($1.00)\n19567\tFirin Fasulye ($1.20)\n19564\tKonserve Kayisi ($0.75)\n19567\tKonserve Bezelye ($0.75)\n19897\tPuro Paketi ($2.12)~n~Pakette 20 adet\n19896\tBlunt Paketi ($2.50)~n~Pakette 20 adet\n\
        363\tKucuk Sirt Cantasi ($20.00)\n363\tBuyuk Sirt Cantasi ($45.00)\n2060\tTarim Topragi ($0.85)\n2663\tPortakal Tohumu ($0.10)\n2663\tKirmizi Elma Tohumu ($0.12)\n2663\tYesil Elma Tohumu ($0.12)\n2663\tDomates Tohumu ($0.15)\n\
        2663\tKabak Tohumu ($0.11)\n2663\tLahana Tohumu ($0.14)\n2663\tBugday Tohumu ($0.15)\n19592\tSepet ($2.78)\n",HATCHET);
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Genel Market", sQuery, "Sec", "Iptal");

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

        return false ;
    }

    switch ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] ) {

        case 0: { // Pocket Watch
            GivePlayerItemByParam ( playerid, PARAM_MISC, POCKET_WATCH, 1, 0, POCKET_WATCH, 5,50 ) ;
        }
        case 1: { // Camera
            GivePlayerItemByParam ( playerid, PARAM_WEAPON, CAMERA, 1, 0, 0, 45 ) ;
        }
        case 2: { // Hatchet
            if ( Character [ playerid ] [ character_level ] < 2 ) {
                return SendServerMessage ( playerid, "Balta satin almak icin 2. seviye olman gerekir.", MSG_TYPE_ERROR ) ;
            }
            GivePlayerItemByParam ( playerid, PARAM_LUMBER, LUMBER_HATCHET, 1, 0, 0, 12 ) ;
        }
        case 3: { // Bandage
            GivePlayerItemByParam ( playerid, PARAM_HEAL, BANDAGE, 1, 0, 0, 3,46 ) ;
        }
        case 4: { // Red Apple
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_APPLE_RED, 1, 0, 0, 0,20 ) ;
        }
        case 5: { // Green Apple
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_APPLE_GREEN, 1, 0, 0, 0,20 ) ;
        } 
        case 6: { // water bottle
            GivePlayerItemByParam ( playerid, PARAM_THIRST, FOOD_WATER_FULL, 1, 0, 0, 0,75);
        }
        case 7: { // canned salmon
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_SALMON, 1, 0, 0, 2);
        }
        case 8: { // canned corned beef
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_CORNED_BEEF, 1, 0, 0, 1,75);
        }
        case 9: { // canned pineapples
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_PINEAPPLES, 1, 0, 0, 1,50);
        }
        case 10: { // canned strawberries
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_STRAWBERRIES, 1, 0, 0, 1,20);
        }
        case 11: { // canned kidney beans
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_KIDNEY_BEANS, 1, 0, 0, 1,50);
        }
        case 12: { // canned peaches
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_PEACHES, 1, 0, 0, 1);
        }
        case 13: { // canned sweetcorn
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_SWEETCORN, 1, 0, 0, 1);
        }
        case 14: { // baked beans
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_BAKED_BEANS, 1, 0, 0, 1,20);
        }
        case 15: { // canned apricots
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_APRICOTS, 1, 0, 0, 0,75);
        }
        case 16: { // canned peas
            GivePlayerItemByParam ( playerid, PARAM_HUNGER, FOOD_CANNED_PEAS, 1, 0, 0, 0,75);
        }   
        case 17: { // Cigars
            GivePlayerItemByParam ( playerid, PARAM_SMOKES, SMOKE_CIGARPACK, 20, 0, 0, 2,12) ;
        }   
        case 18: { // Blunt
            GivePlayerItemByParam ( playerid, PARAM_SMOKES, SMOKE_BLUNTPACK, 20, 0, 0, 2,50) ;
        }   
        case 19: { // Backpack lvl 1
            if ( Character [ playerid ] [ character_handmoney ] < 20 ) {
                return SendServerMessage ( playerid, "Yeterli paran yok.", MSG_TYPE_ERROR ) ;
            }
            TakeCharacterMoney ( playerid, 20, MONEY_SLOT_HAND ) ;
            Character [ playerid ] [ character_backpack ] = 1 ;
            mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_backpack = %d WHERE character_id = %d", Character [ playerid ] [ character_backpack ], Character [ playerid ] [ character_id ] ) ;
            mysql_tquery ( mysql, query ) ;
            SendServerMessage ( playerid, "20 Dolar karsiliginda kucuk bir sirt cantasi satin aldin.", MSG_TYPE_INFO ) ;
            return true ;
        }
        case 20: { // Backpack lvl 2
            if ( Character [ playerid ] [ character_handmoney ] < 45 ) {
                return SendServerMessage ( playerid, "Yeterli paran yok.", MSG_TYPE_ERROR ) ;
            }
            TakeCharacterMoney ( playerid, 45, MONEY_SLOT_HAND ) ;
            Character [ playerid ] [ character_backpack ] = 2 ;
            mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_backpack = %d WHERE character_id = %d", Character [ playerid ] [ character_backpack ], Character [ playerid ] [ character_id ] ) ;
            mysql_tquery ( mysql, query ) ;
            SendServerMessage ( playerid, "45 Dolar karsiliginda buyuk bir sirt cantasi satin aldin.", MSG_TYPE_INFO ) ;
            return true ;
        }
        case 21: { // soil bag
            GivePlayerItemByParam ( playerid, PARAM_FARMING, FARMING_SOIL_BAG, 1, 0, 0, 0,85) ;
        }
        case 22: { // orange seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_ORANGE, 1, 0, 0, 0,10) ;
        }
        case 23: { // red apple seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_APPLE_RED, 1, 0, 0, 0,13) ;
        }
        case 24: { // green apple seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_APPLE_GREEN, 1, 0, 0, 0,13) ;
        }
        case 25: { // tomato seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_TOMATO, 1, 0, 0, 0,15) ;
        }
        case 26: { // pumpkin seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_PUMPKIN, 1, 0, 0, 0,11) ;
        }
        case 27: { // cabbage seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_CABBAGE, 1, 0, 0, 0,14) ;
        }
        case 28: { // wheat seed.
            GivePlayerItemByParam ( playerid, PARAM_UNDEFINED, SEED_WHEAT, 1, 0, 0, 0,15) ;
        }
        case 29:{
            GivePlayerItemByParam(playerid, PARAM_FARMING, EMPTY_BASKET, 1, 0, 0, 2, 78);
        }
    }
    cmd_buy(playerid,"");
 
    return true ;
}

ShowSkinSelection ( playerid ) {

    new sex = Character [ playerid ] [ character_gender ] ;
    new race = Character [ playerid ] [ character_origin ] ;
    new skins [ sizeof ( SkinArray ) ], skincount, basecount = 0;
    new sQuery [ 1024 ] ;

    for ( new i; i < sizeof ( SkinArray ); i ++ ) {
        if ( SkinArray [ i ] [ gender ] == sex ) {
            if ( SkinArray [ i ] [ ethnicity ] == race ) {
                skins [ i ] = SkinArray [ i ] [ skinid ] ;
                format ( sQuery, sizeof ( sQuery ), "%s%d\t%d\n", sQuery, skins [ i ], i ) ;
                skincount ++ ;
                if ( ( race || sex ) && ! basecount  ) { basecount = i; }
            }
        }
    }

    if ( skincount == 0 ) {
        return SendServerMessage ( playerid, "Karakter verisi islenirken hata olustu. Lutfen tekrar dene veya bir gelistiriciye ulas.", MSG_TYPE_ERROR ) ;
    }

    task_yield(1);

    new dialog_response[e_DIALOG_RESPONSE_INFO];
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Karakter Secimi", sQuery, "Sec", "Iptal");

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {
        return false ;
    }

    if ( Character [ playerid ] [ character_handmoney ] < 1 || (Character[playerid][character_handmoney] == 1 && Character[playerid][character_handchange] < 25) ) {
        return SendServerMessage ( playerid, "Yeterli paran yok. Yeni bir karakter tipi icin 1.25 dolar odemelisin.", MSG_TYPE_ERROR ) ;
    }

    TakeCharacterMoney ( playerid, 1, MONEY_SLOT_HAND ) ;
    TakeCharacterChange(playerid,25,MONEY_SLOT_HAND);

    SendServerMessage(playerid, sprintf("Karakter tipi ID %d'yi 1.25 dolar karsiliginda satin aldin.", skins [ basecount+dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] ), MSG_TYPE_INFO ) ; 

    Character [ playerid ] [ character_skin ] = skins [ basecount+dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] ;
    SetPlayerSkin ( playerid, Character [ playerid ] [ character_skin ] ) ;
    TogglePlayerControllable(playerid, true ) ;

    new query [ 256 ] ;
    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_skin = %d WHERE character_id = %d", Character [ playerid ] [ character_skin ], Character [ playerid ] [ character_id ] ) ;
    mysql_tquery ( mysql, query ) ;
 
    return true ;
}
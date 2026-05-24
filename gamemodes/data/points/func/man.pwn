new bool: IsPlayerSleepingInPoint [ MAX_PLAYERS ] ;

CMD:point ( playerid, const params [] ) {

	new buyprice, query [ 256 ], option [ 16 ], soption [ 32 ], amount ;


	if ( sscanf ( params, "s[16]S()[16]I(0)", option, soption, amount ) ) {

		return SendServerMessage ( playerid, "/point [buy(satýnal), sell(sat), lock(kilit), furni(ture)(mobilya), fee(giriþ ücreti), collect(topla), store(depola), take(al), storag(depolama), sleep(uyu)]", MSG_TYPE_INFO ) ;
	}

	if ( ! strcmp ( option, "buy" ) ) {

		for ( new i; i < MAX_POINTS; i ++ ) {
			if ( Point [ i ] [ point_id ] != -1 ) {
				if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int ] ) {

					if ( Point [ i ] [ point_owner ] > 0) {

						return SendServerMessage ( playerid, "Zaten bu mülkün sahibi var?", MSG_TYPE_ERROR ) ;
					}

					new total ;

					switch ( Point [ i ] [ point_type ] ) {
					
						case POINT_TYPE_PASS: {

							return SendServerMessage ( playerid, "Bu mülkü satýn alamazsýn.", MSG_TYPE_ERROR ) ;
						}

						case POINT_TYPE_HOUSE: {

							total = GetPlayerOwnedPoints ( playerid, POINT_TYPE_HOUSE ) ;

							if ( total == 1 ) { total = 2; }

							if ( Character [ playerid ] [ character_level ] < total*10 ) {

								return SendServerMessage ( playerid, sprintf("Bir evi almak için %i0 seviye gerekmekte.", total ), MSG_TYPE_ERROR ) ;
							}
						}

						case POINT_TYPE_BIZ: {

							total = GetPlayerOwnedPoints ( playerid, POINT_TYPE_BIZ ) ;

							if ( total == 1 ) { total = 2; }

							if ( Character [ playerid ] [ character_level ] < total*10 ) {

								return SendServerMessage ( playerid, sprintf("Yeni iþyeri almak için %i0 seviye olman gerek!", total ), MSG_TYPE_ERROR ) ;
							}
						}

					}

					buyprice = Point [ i ] [ point_price ] ;

					if ( buyprice > Character [ playerid ] [ character_handmoney ] ) {

						return SendServerMessage ( playerid, "Burayý satýn almak için yeterli paran yok.", MSG_TYPE_ERROR );
					}

					TakeCharacterMoney ( playerid, buyprice, MONEY_SLOT_HAND ) ;
					SendServerMessage ( playerid, sprintf("Bu mülkü satýn aldýn. (%d) %s $%s ödedin!",Point [ i ] [ point_id], Point [ i ] [ point_name ] , IntegerWithDelimiter ( Point [ i ] [ point_price ] )), MSG_TYPE_INFO ) ;

					GivePlayerExperience ( playerid, 3 ) ;

					mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_owner = '%d' WHERE point_id = '%d'", Character [ playerid ] [ character_id ], Point [ i ] [ point_id ] ) ;
					mysql_tquery ( mysql, query ) ;

					Init_Points ( Point [ i ] [ point_id ] ) ;
				}

				else continue ;
			}
		}
	}

	else if ( ! strcmp ( option, "sell" ) ) {
		for ( new i; i < MAX_POINTS; i ++ ) {
			if ( Point [ i ] [ point_id ] != -1 ) {
				if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int ] ) {

					if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

						return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
					}

					buyprice = Point [ i ] [ point_price ] / 2 ;

					SendServerMessage ( playerid, sprintf("Ýþyerini sattýn ve $%s geri aldýn.", IntegerWithDelimiter ( buyprice ) ), MSG_TYPE_INFO ) ;
					GiveCharacterMoney ( playerid, buyprice, MONEY_SLOT_HAND ) ;

					mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_owner = '-1', point_till = '0', point_till_change = '0', point_weapon1 = '0', point_weapon1ammo = '0', point_weapon2 = '0', point_weapon2ammo = '0' WHERE point_id = '%d'", Point [ i ] [ point_id ] ) ;
					mysql_tquery ( mysql, query ) ;

					Init_Points ( Point [ i ] [ point_id ] ) ;
				}

				else continue ;
			}
		}
	}

	else if ( ! strcmp ( option, "lock" ) ) {
		for ( new i; i < MAX_POINTS; i ++ ) {
			if ( Point [ i ] [ point_id ] != -1 ) {
				
				if ( 
					IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int ] ||
					IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

					if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

						return SendServerMessage ( playerid, "Bu mülkün sahibi deðilsin.", MSG_TYPE_ERROR ) ;
					}

					if ( ! Point [ i ] [ point_locked ] ) {

						Point [ i ] [ point_locked ] = true ;

						SendServerMessage ( playerid, "Ýþyerini kilitledin.", MSG_TYPE_INFO ) ;
					}

					else if ( Point [ i ] [ point_locked ] ) { 

						Point [ i ] [ point_locked ] = false ;

						SendServerMessage ( playerid, "Ýþyerinin kilidini açtýn..", MSG_TYPE_INFO ) ;
					}

					mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_locked = '%d' WHERE point_id = '%d'", Point [ i ] [ point_locked ], Point [ i ] [ point_id ] ) ;
					mysql_tquery ( mysql, query ) ;
				}

				else continue ;
			}
		}
	}

	else if ( ! strcmp ( option, "furniture", true) || ! strcmp ( option, "furni", true) ) {

		if(GetCharacterPointID(playerid) != -1) {

			if(DoesPlayerOwnPoint(playerid,GetCharacterPointID(playerid))) {

				if ( GetPointType ( GetCharacterPointID ( playerid ) ) != 1 ) { return SendServerMessage(playerid,"Sadece evlere mobilya ekleyebilirsin.",MSG_TYPE_ERROR); }
				if(GetFurnitureBuilderMode(playerid) != -1) { ResetFurnitureBuilderData(playerid); }
				task_yield(1);
				new dialog_response[e_DIALOG_RESPONSE_INFO];
				await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Mobilya Menüsü","Mobilya Ekle\nMobilya Düzenle\nMobilya Sil","Seç","Çýk");
				if(!dialog_response[E_DIALOG_RESPONSE_Response]) { return 1; }

				switch(dialog_response[E_DIALOG_RESPONSE_Listitem])
				{
					case 0: //add
					{
						AddFurniture(playerid,GetCharacterPointID(playerid));
					}
					case 1: //edit
					{
						EditFurniture(playerid,GetCharacterPointID(playerid));
					}
					case 2: //remove
					{
						RemoveFurniture(playerid,GetCharacterPointID(playerid));
					}
				}
			}
			else return SendServerMessage(playerid,"Bu mülkün sahibi sen deðilsin.",MSG_TYPE_ERROR);
		}
		else return SendServerMessage(playerid,"Mülkün içerisinde olmalýsýn.",MSG_TYPE_ERROR);
	}

else if ( ! strcmp ( option, "fee" ) ) {
        for ( new i; i < MAX_POINTS; i ++ ) {
            if ( Point [ i ] [ point_id ] != -1 ) {
                
                if ( 
                    IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int ] ||
                    IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

                    if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

                        return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                    }

                    if ( Point [ i ] [ point_type ] != POINT_TYPE_BIZ ) {

                        return SendServerMessage ( playerid, "Bu mülk iþyeri deðil.", MSG_TYPE_ERROR ) ;
                    }

                    task_yield ( 1 ) ;

                    new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
                    await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_INPUT, "Ücret Ayarý", "Giriþ ücreti olarak belirlemek istediðin tutarý gir (0-99 cent).", "Devam", "Çýkýþ" );

                    if(dialog_response[ E_DIALOG_RESPONSE_Response ]) {

                        if ( strval ( dialog_response [ E_DIALOG_RESPONSE_InputText ] ) < 0 || strval ( dialog_response [ E_DIALOG_RESPONSE_InputText ] ) > 99 ) {

                            return SendServerMessage ( playerid, "Giriþ ücreti 0 centten az veya 99 centten fazla olamaz.", MSG_TYPE_ERROR ) ;
                        }

                        mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_fee = '%d' WHERE point_id = '%d'", strval ( dialog_response [ E_DIALOG_RESPONSE_InputText ] ), Point [ i ] [ point_id ] ) ;
                        mysql_tquery ( mysql, query ) ;

                        if(strval(dialog_response[E_DIALOG_RESPONSE_InputText]) >= 1) { SendServerMessage(playerid,sprintf("Bu noktanýn giriþ ücretini %d cent olarak ayarladýn.",strval(dialog_response [E_DIALOG_RESPONSE_InputText])),MSG_TYPE_INFO); }
                        else if(!strval(dialog_response[E_DIALOG_RESPONSE_InputText])) { SendServerMessage(playerid,"Bu noktanýn giriþ ücretini kaldýrdýn.",MSG_TYPE_INFO); }

                        Init_Points ( Point [ i ] [ point_id ] ) ;
                    }

                    return true ;
                }

                else continue ;
            }
        }
    }
	/*
	else if(!strcmp(option,"rentable",true)) {

		if(GetCharacterPointID(playerid) == -1) { return SendServerMessage(playerid,"You're not inside a point.",MSG_TYPE_ERROR); }

		new id = GetCharacterPointID(playerid);
		if(Point[id][point_type] == POINT_TYPE_HOUSE) {

			if(Point[id][point_owner] != Character[playerid][character_id]) { return SendServerMessage(playerid,"Bu mülkün sahibi sen deðilsin.",MSG_TYPE_ERROR); }
			if(!Point[id][point_rentable]) {

				Point[id][point_rentable] = 1;
				mysql_format(mysql,query,sizeof(query),"UPDATE points SET point_rentable = %d WHERE point_id = %d",Point[id][point_rentable],Point[id][point_id]);
				mysql_tquery(mysql,query);
				SendServerMessage(playerid,"Your house is now rentable.  Use /point [rent] to change the price.",MSG_TYPE_INFO);
			}
			else {

				Point[id][point_rentable] = 0;
				mysql_format(mysql,query,sizeof(query),"UPDATE points SET point_rentable = %d WHERE point_id = %d",Point[id][point_rentable],Point[id][point_id]);
				mysql_tquery(mysql,query);
				SendServerMessage(playerid,"Your house is no longer rentable.",MSG_TYPE_INFO);
			}
		}
		else { return SendServerMessage(playerid,"This is only for houses.",MSG_TYPE_ERROR); }
	}
	else if(!strcmp(option,"rent",true)) {

		if(GetCharacterPointID(playerid) == -1) { return SendServerMessage(playerid,"You're not inside a point.",MSG_TYPE_ERROR); }

		new id = GetCharacterPointID(playerid);
		if(Point[id][point_type] == POINT_TYPE_HOUSE) {

			if(Point[id][point_owner] != Character[playerid][character_id]) { return SendServerMessage(playerid,"Bu mülkün sahibi sen deðilsin.",MSG_TYPE_ERROR); }

			new dollars,cents;
			if(sscanf(params,"dD(0)",dollars,cents)) { return SendServerMessage(playerid,"/point rent [dollars] [optional:cents]",MSG_TYPE_ERROR); }
			if(dollars < 0) { return SendServerMessage(playerid,"You cannot set dollars to a negative amount.",MSG_TYPE_ERROR); }
			if(dollars > 5) { return SendServerMessage(playerid,"You cannot set rent higher than $5.00.",MSG_TYPE_ERROR); }
			if(dollars == 5 && cents > 0) { return SendServerMessage(playerid,"You cannot set rent higher than $5.00.",MSG_TYPE_ERROR); }
			if(cents < 0) { return SendServerMessage(playerid,"You cannot set cents to a negative amount.",MSG_TYPE_ERROR); }
			if(cents > 99) { return SendServerMessage(playerid,"You can't set cents over 99 cents.",MSG_TYPE_ERROR); }

			Point[id][point_rent_price] = dollars;
			Point[id][point_rent_change] = cents;

			mysql_format(mysql,query,sizeof(query),"UPDATE points SET point_rent_price = %d,point_rent_change = %d WHERE point_id = %d",Point[id][point_rent_price],Point[id][point_rent_change],Point[id][point_id]);
			mysql_tquery(mysql,query);

			SendServerMessage(playerid,sprintf("You've set your rent price to $%02d.%02d.",Point[id][point_rent_price],Point[id][point_rent_change]),MSG_TYPE_INFO);
		}
	}
	else if(!strcmp(option,"tenants",true)) {

		new list[256];

		inline TenantLookup() {

			new rows,fields;

			cache_get_data(rows,fields,mysql);

			if(rows) {


			}
		}
		//mysql_format(mysql,query,sizeof(query),"SELECT ")

		inline TenantList(pid,dialogid,response,listitem,string:inputtext[]) {

			#pragma unused pid,dialogid,response,listitem,inputtext
		}
		Dialog_ShowCallback(playerid,using inline TenantList,DIALOG_STYLE_MSGBOX,"Tenants List",list,"Exit","");
	}
	else if(!strcmp(option,"evict",true)) {

	}
	*/
else if ( ! strcmp ( option, "collect" ) ) {
        for ( new i; i < MAX_POINTS; i ++ ) {
            if ( Point [ i ] [ point_id ] != -1 ) {

                if ( Point [ i ] [ point_type ] != POINT_TYPE_BIZ ) {

                    return SendServerMessage ( playerid, "Bu nokta bir iþyeri deðil.", MSG_TYPE_ERROR ) ;
                }

                if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

                    if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

                        return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                    }

                    SendServerMessage ( playerid, sprintf("Ýþyeri kasanýzdan %s.%02d tutarýnda para çektiniz. Paranýz banka hesabýnýza yatýrýldý.", IntegerWithDelimiter( Point [ i ] [ point_till ]), Point[i][point_till_change]), MSG_TYPE_INFO ) ;
                    GiveCharacterMoney ( playerid, Point [ i ] [ point_till ], MONEY_SLOT_BANK ) ;
                    GiveCharacterChange(playerid, Point[i][point_till_change], MONEY_SLOT_BANK);

                    mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_till = '0', point_till_change = '0' WHERE point_id = '%d'", Point [ i ] [ point_id ] ) ;
                    mysql_tquery ( mysql, query ) ;

                    Init_Points ( Point [ i ] [ point_id ] ) ;
                }

                else continue ;
            }
        }
    }

    else if ( ! strcmp ( option, "store" ) ) {

        if ( isnull ( soption ) ) {

            return SendServerMessage ( playerid, "/point store [money/weapon]", MSG_TYPE_ERROR ) ;
        }

        if ( ! strcmp ( soption, "money" ) ) { 

            if ( amount < 1 ) {

                return SendServerMessage ( playerid, "/point store money [miktar] - miktar 1'den az olamaz.", MSG_TYPE_ERROR ) ;
            }

            for ( new i; i < MAX_POINTS; i ++ ) {

                if ( Point [ i ] [ point_id ] != -1 ) {

                    if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

                        if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

                            return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                        }

                        if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {

                            return SendServerMessage ( playerid, "Bu nokta bir ev deðil.", MSG_TYPE_ERROR ) ;
                        }

                        if ( Character [ playerid ] [ character_handmoney ] < amount ) {

                            return SendServerMessage ( playerid, sprintf("Evine koymak için yeterli paran ( $%i ) yok.", amount ), MSG_TYPE_ERROR ) ;
                        }

                        Point [ i ] [ point_till ] += amount ;
                        TakeCharacterMoney ( playerid, amount, MONEY_SLOT_HAND ) ;

                        WriteLog ( playerid, "point/store", sprintf ( "%s evine $%s (%d) koydu. (point: %d, enumid: %d)", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), amount, Point [ i ] [ point_id ], i )) ;

                        mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_till = %d WHERE point_id = %d", Point [ i ] [ point_till ], Point [ i ] [ point_id ] ) ;
                        mysql_tquery ( mysql, query ) ;

                        Init_Points ( Point [ i ] [ point_id ] ) ;

                        return SendServerMessage ( playerid, sprintf("Evindeki depoya $%s koydun.", IntegerWithDelimiter ( amount )), MSG_TYPE_INFO ) ;
                    }

                    else continue ;
                }

                else continue ;
            }

            return SendServerMessage ( playerid, "Sahibi olduðun bir noktanýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
        }

        else if ( ! strcmp ( soption, "weapon" ) ) {

            for ( new i; i < MAX_POINTS; i ++ ) {

                if ( Point [ i ] [ point_id ] != -1 ) {

                    if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

                        if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

                            return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                        }

                        if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {

                            return SendServerMessage ( playerid, "Bu nokta bir ev deðil.", MSG_TYPE_ERROR ) ;
                        }

                        if ( amount < 1 || amount > 2) {

                            return SendServerMessage ( playerid, "/point store weapon [slot] - slot 1 ile 2 arasýnda olmalýdýr.", MSG_TYPE_ERROR ) ;
                        }

                        if ( amount == 1 ) {

                            if ( Point [ i ] [ point_weapon1 ] ) {

                                return SendServerMessage ( playerid, "Bu slotta zaten bir silah saklý.", MSG_TYPE_ERROR ) ;
                            }

                            if ( ! Character [ playerid ] [ character_handweapon ] ) {

                                return SendServerMessage ( playerid, "Üzerinde saklanabilir bir silah yok.", MSG_TYPE_ERROR ) ;
                            }

                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_weapon1 = %d, point_weapon1ammo = %d WHERE point_id = %d", 
                                Character [ playerid ] [ character_handweapon ], Character [ playerid ] [ character_handammo ], Point [ i ] [ point_id ] ) ;

                            mysql_tquery ( mysql, query ) ;

                            Point [ i ] [ point_weapon1 ]       = Character [ playerid ] [ character_handweapon ] ;
                            Point [ i ] [ point_weapon1ammo ]   = Character [ playerid ] [ character_handammo ] ;

                            RemovePlayerWeapon ( playerid ) ;
                            Init_Points ( Point [ i ] [ point_id ] ) ;

                            return true ;
                        }

                        else if ( amount == 2 ) {
                            if ( Point [ i ] [ point_weapon2 ] ) {

                                return SendServerMessage ( playerid, "Bu slotta zaten bir silah saklý.", MSG_TYPE_ERROR ) ;
                            }

                            if ( ! Character [ playerid ] [ character_handweapon ] ) {

                                return SendServerMessage ( playerid, "Üzerinde saklanabilir bir silah yok.", MSG_TYPE_ERROR ) ;
                            }

                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_weapon2 = %d, point_weapon2ammo = %d WHERE point_id = %d", 
                                Character [ playerid ] [ character_handweapon ], Character [ playerid ] [ character_handammo ], Point [ i ] [ point_id ] ) ;

                            mysql_tquery ( mysql, query ) ;

                            Point [ i ] [ point_weapon2 ]       = Character [ playerid ] [ character_handweapon ] ;
                            Point [ i ] [ point_weapon2ammo ]   = Character [ playerid ] [ character_handammo ] ;

                            RemovePlayerWeapon ( playerid ) ;
                            Init_Points ( Point [ i ] [ point_id ] ) ;

                            return true ;
                        }
                        continue ;
                    }
                    else continue ;
                }
                else continue ;
            }
            return SendServerMessage ( playerid, "Sahibi olduðun bir noktanýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
        }
        else return SendServerMessage ( playerid, "/point store [money/weapon] [miktar/slot]", MSG_TYPE_ERROR ) ;
    }   

    else if ( ! strcmp ( option, "take" ) ) {

        if ( isnull ( soption ) ) {

            return SendServerMessage ( playerid, "/point take [money/weapon]", MSG_TYPE_ERROR ) ;
        }

        if ( ! strcmp ( soption, "money" ) ) { 

            if ( amount < 1 ) {

                return SendServerMessage ( playerid, "/point take money [miktar] - miktar 1'den az olamaz.", MSG_TYPE_ERROR ) ;
            }

            for ( new i; i < MAX_POINTS; i ++ ) {

                if ( Point [ i ] [ point_id ] != -1 ) {

                    if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

                        if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

                            return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                        }

                        if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {

                            return SendServerMessage ( playerid, "Bu nokta bir ev deðil.", MSG_TYPE_ERROR ) ;
                        }

                        if ( Point [ i ] [ point_till ] < amount ) {

                            return SendServerMessage ( playerid, sprintf("Evindeki depoda $%i bulunmuyor.", amount ), MSG_TYPE_ERROR ) ;
                        }

                        Point [ i ] [ point_till ] -= amount ;
                        GiveCharacterMoney ( playerid, amount, MONEY_SLOT_HAND ) ;

                        WriteLog ( playerid, "point/store", sprintf ( "%s evinden $%s (%d) çekti. (point: %d, enumid: %d)", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), amount, Point [ i ] [ point_id ], i )) ;

                        mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_till = %d WHERE point_id = %d", Point [ i ] [ point_till ], Point [ i ] [ point_id ] ) ;
                        mysql_tquery ( mysql, query ) ;

                        Init_Points ( Point [ i ] [ point_id ] ) ;

                        return SendServerMessage ( playerid, sprintf("Evindeki depodan $%s çektin.", IntegerWithDelimiter ( amount )), MSG_TYPE_INFO ) ;
                    }

                    else continue ;
                }

                else continue ;
            }
            return SendServerMessage ( playerid, "Sahibi olduðun bir noktanýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
        }

else if ( ! strcmp ( soption, "weapon" ) ) {
            for ( new i; i < MAX_POINTS; i ++ ) {
                if ( Point [ i ] [ point_id ] != -1 ) {
                    if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {
                        if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {
                            return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                        }
                        if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {
                            return SendServerMessage ( playerid, "Bu nokta bir ev deðil.", MSG_TYPE_ERROR ) ;
                        }
                        if ( amount < 1 || amount > 2) {
                            return SendServerMessage ( playerid, "/point take weapon [1/2] - 1. veya 2. slotu seçmelisin.", MSG_TYPE_ERROR ) ;
                        }
                        if ( amount == 1 ) {
                            if ( ! Point [ i ] [ point_weapon1 ] ) {
                                return SendServerMessage ( playerid, "Bu slotta saklý bir silah bulunmuyor.", MSG_TYPE_ERROR ) ;
                            }
                            if ( Character [ playerid ] [ character_handweapon ] ) {
                                return SendServerMessage ( playerid, "Zaten elinde bir silah var, önce onu kýlýfýna koymalýsýn.", MSG_TYPE_ERROR ) ;
                            }
                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_weapon1 = 0, point_weapon1ammo = 0 WHERE point_id = %d", Point [ i ] [ point_id ] ) ;
                            mysql_tquery ( mysql, query ) ;
                            wep_GivePlayerWeapon ( playerid, Point [ i ] [ point_weapon1 ], Point [ i ] [ point_weapon1ammo ] ) ;
                            Point [ i ] [ point_weapon1 ]       = WEAPON_FIST ;
                            Point [ i ] [ point_weapon1ammo ]   = 0 ;
                            Init_Points ( Point [ i ] [ point_id ] ) ;
                            return true ;
                        }
                        else if ( amount == 2 ) {
                            if ( ! Point [ i ] [ point_weapon2 ] ) {
                                return SendServerMessage ( playerid, "Bu slotta saklý bir silah bulunmuyor.", MSG_TYPE_ERROR ) ;
                            }
                            if ( Character [ playerid ] [ character_handweapon ] ) {
                                return SendServerMessage ( playerid, "Zaten elinde bir silah var, önce onu kýlýfýna koymalýsýn.", MSG_TYPE_ERROR ) ;
                            }
                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_weapon2 = 0, point_weapon2ammo = 0 WHERE point_id = %d",  Point [ i ] [ point_id ] ) ;
                            mysql_tquery ( mysql, query ) ;
                            wep_GivePlayerWeapon ( playerid, Point [ i ] [ point_weapon2 ], Point [ i ] [ point_weapon2ammo ] ) ;
                            Point [ i ] [ point_weapon2 ]       = WEAPON_FIST ;
                            Point [ i ] [ point_weapon2ammo ]   = 0 ;
                            Init_Points ( Point [ i ] [ point_id ] ) ;
                            return true ;
                        }
                        continue ;
                    }
                    else continue ;
                }
                else continue ;
            }
            return SendServerMessage ( playerid, "Sahibi olduðun bir noktanýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
        }
        else return SendServerMessage ( playerid, "/point take [money/weapon] [miktar/slot]", MSG_TYPE_ERROR ) ;
    }   

    else if ( ! strcmp ( option, "storage" ) ) {
        if ( isnull ( soption ) ) {
            return SendServerMessage ( playerid, "/point storage [money/weapon]", MSG_TYPE_ERROR ) ;
        }
        if ( ! strcmp ( soption, "money" ) ) { 
            for ( new i; i < MAX_POINTS; i ++ ) {
                if ( Point [ i ] [ point_id ] != -1 ) {
                    if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {
                        if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {
                            return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                        }
                        if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {
                            return SendServerMessage ( playerid, "Bu nokta bir ev deðil.", MSG_TYPE_ERROR ) ;
                        }
                        return SendServerMessage ( playerid, sprintf("Evinde depolanmýþ $%s bulunuyor.", IntegerWithDelimiter ( Point [ i ] [ point_till ])), MSG_TYPE_WARN ) ;
                    }
                    else continue ;
                }
                else continue ;
            }
            return SendServerMessage ( playerid, "Sahibi olduðun bir noktanýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
        }
        else if ( ! strcmp ( soption, "weapon" ) ) { 
            for ( new i; i < MAX_POINTS; i ++ ) {
                if ( Point [ i ] [ point_id ] != -1 ) {
                    if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {
                        if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {
                            return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
                        }
                        if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {
                            return SendServerMessage ( playerid, "Bu nokta bir ev deðil.", MSG_TYPE_ERROR ) ;
                        }
                        SendClientMessage(playerid, COLOR_TAB0, sprintf("%d ID'li noktanýn silah deposu:", Point [ i ] [ point_id ] ) ) ;
                        SendClientMessage(playerid, COLOR_TAB1, sprintf("[SLOT 1]: %s (%d mermi)", ReturnWeaponName (Point [ i ] [ point_weapon1 ]), Point [ i ] [ point_weapon1ammo ] ) ) ;
                        return SendClientMessage(playerid, COLOR_TAB1, sprintf("[SLOT 2]: %s (%d mermi)", ReturnWeaponName (Point [ i ] [ point_weapon2 ]), Point [ i ] [ point_weapon2ammo ] ) ) ;
                    }
                    else continue ;
                }
                else continue ;
            }
            return SendServerMessage ( playerid, "Sahibi olduðun bir noktanýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
        }
        return SendServerMessage ( playerid, "/point storage [money/weapon]", MSG_TYPE_ERROR ) ;
    }

    else if ( ! strcmp ( option, "buy" ) ) {
        // Satýn alma mantýðý (Burada gerekli kontrollerinizi -para, seviye vb.- yapabilirsiniz)
        for ( new i; i < MAX_POINTS; i ++ ) {
            if ( Point [ i ] [ point_id ] != -1 ) {
                if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] ) {
                    if ( Point [ i ] [ point_owner ] != 0 ) {
                        return SendServerMessage ( playerid, "Bu mülk zaten satýlmýþ.", MSG_TYPE_ERROR ) ;
                    }
                    // Örnek satýn alma iþlemi
                    Point [ i ] [ point_owner ] = Character [ playerid ] [ character_id ] ;
                    mysql_format(mysql, query, sizeof(query), "UPDATE points SET point_owner = %d WHERE point_id = %d", Character[playerid][character_id], Point[i][point_id]);
                    mysql_tquery(mysql, query);
                    
                    SendServerMessage(playerid, sprintf("Baþarýyla %d ID'li mülkü satýn aldýn!", Point[i][point_id]), MSG_TYPE_INFO);
                    return true;
                }
            }
        }
        return SendServerMessage(playerid, "Satýn alabileceðin bir mülkün yakýnýnda deðilsin.", MSG_TYPE_ERROR);
    }

	else if ( ! strcmp ( option, "sleep" ) ) {

		for ( new i; i < MAX_POINTS; i ++ ) {

			if ( Point [ i ] [ point_id ] != -1 ) {

				if ( IsPlayerInRangeOfPoint(playerid, 20.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ]) {

					if ( Point [ i ] [ point_owner ] != Character [ playerid ] [ character_id ] ) {

						return SendServerMessage ( playerid, "Bu mülkün sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;
					}

					if ( Point [ i ] [ point_type ] != POINT_TYPE_HOUSE ) {

						return SendServerMessage ( playerid, "Bu mülk ev deðil!", MSG_TYPE_ERROR ) ;
					}

					switch ( IsPlayerSleepingInPoint [ playerid ] ) {

						case false: {

							TogglePlayerControllable ( playerid, false ) ;

 							ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Evde uyumak", "Þuanda rolsel olarak uyuyorsun..\n\nMaaþ çekini daha yavaþ ve %25 daha az alacaksýn.", "Çýj", "" ) ;

							IsPlayerSleepingInPoint [ playerid ] = true ;
						}

						case true : {

							TogglePlayerControllable ( playerid, true ) ;

							IsPlayerSleepingInPoint [ playerid ] = false ;
						}
					}

					return true;

				}

				else continue; 
			}

			else continue ;
		}

		return SendServerMessage ( playerid, "Bu evin sahibi sen deðilsin.", MSG_TYPE_ERROR ) ;

	}

	else return SendServerMessage ( playerid, "/point [buy(satýnal), sell(sat), lock(kilit), furni(ture)(mobilya), fee(giriþ ücreti), collect(topla), store(depola), take(al), storag(depolama), sleep(uyu)]", MSG_TYPE_INFO ) ;

	return true ;
}

CCMD:apoint ( playerid, params [] ) {

    new option [ 32 ], setting, extra [ 32 ] ;

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için yetkili olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < ADVANCED_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az Geliþmiþ Yetkili olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    if ( sscanf ( params, "s[32]I(-1)S()[32]", option, setting, extra)) {

        SendServerMessage ( playerid, "/apoint [parametre] [ayar] [ekstra: opsiyonel]", MSG_TYPE_ERROR ) ;
        SendServerMessage ( playerid, "PARAMETRELER: [info, create, delete, sell, int, move, name, type, price, biz, lock, goto, inactive, clearinactive, owner, fee]", MSG_TYPE_WARN) ;
        return SendServerMessage ( playerid, "Ek bilgi için /apoint info yaz. Biz tiplerini ve nokta tiplerini gösterir.", MSG_TYPE_INFO ) ;
    }

    new Float: x, Float: y, Float: z, query [ 256 ] ;
    GetPlayerPos ( playerid, x, y, z ) ;

    if ( ! strcmp ( option, "info" ) ) {
        SendServerMessage ( playerid, "[Nokta Tipleri]: 0: Geçiþ Noktasý, 1: Ev, 2: Ýþletme", MSG_TYPE_INFO ) ;
        SendServerMessage ( playerid, "[Ýþletme Tipleri]: 0: Market, 1: Silahçý, 2: Giyim, 3: Berber, 4: Ýçki Dükkaný, 5: Bar, 6: Avcý Dükkaný", MSG_TYPE_INFO ) ;
        SendServerMessage ( playerid, "[Ýþletme Tipleri]: 7: Banka, 8: Postane, 9: Þerif Ofisi, 10: Demirci, 11: Ahýr", MSG_TYPE_INFO ) ;

        return true ;
    }

    if ( ! strcmp ( option, "create" )) {

        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting < 0 || setting > 2 ) {

            return SendServerMessage ( playerid, "Ayar 0'dan küçük veya 2'den büyük olamaz.", MSG_TYPE_ERROR ) ;
        }

        CreatePoint ( playerid, setting, x, y, z ) ;

        return true ;
    }

    else if ( ! strcmp ( option, "int" )) {

        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap int [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        Point [ setting ] [ point_int_x ] = x ;
        Point [ setting ] [ point_int_y ] = y ;
        Point [ setting ] [ point_int_z ] = z ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_int_x = '%f', point_int_y = '%f', point_int_z = '%f' WHERE point_id = '%d'",
            Point [ setting ] [ point_int_x ], Point [ setting ] [ point_int_y ], Point [ setting ] [ point_int_z ], Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendServerMessage ( playerid, sprintf("%d ID'li noktanýn iç mekan konumunu bulunduðun yere ayarladýn.", setting), MSG_TYPE_INFO ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn iç mekanýný kendi konumuna güncelledi.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_LOW ) ;
        ////OldLog ( playerid, "mod/points", sprintf("%s (%d) has updated point %d's interior to their location.", ReturnUserName ( playerid, true ), playerid, setting )) ;

        if ( Point [ setting ] [ point_type ] == POINT_TYPE_HOUSE || Point [ setting ] [ point_type ] == POINT_TYPE_BIZ ) {

            new intvalues = 1 ;
            
            intvalues += setting ;

            Point [ setting ] [ point_int_vw ] = GetPlayerVirtualWorld ( playerid ) + intvalues ;
            Point [ setting ] [ point_int_int ] = GetPlayerInterior ( playerid ) ;

            mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_int_vw = %d, point_int_int = %d WHERE point_id = '%d'",
                Point [ setting ] [ point_int_vw ], Point [ setting ] [ point_int_int ], Point [ setting ] [ point_id ]  ) ;

            mysql_tquery ( mysql, query ) ;

            SendServerMessage ( playerid, 
                sprintf("Nokta tipine göre iç mekan ve sanal dünya güncellendi. (%d:%d)", Point [ setting ] [ point_int_vw ], Point [ setting ] [ point_int_int ]), 
                    MSG_TYPE_INFO ) ;

            return true ;
        }
    }

    else if ( ! strcmp (option, "move" ) ) {


        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap move [noktaid]", MSG_TYPE_ERROR ) ;
        }


        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        Point [ setting ] [ point_ext_x ] = x ;
        Point [ setting ] [ point_ext_y ] = y ;
        Point [ setting ] [ point_ext_z ] = z ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_ext_x = '%f', point_ext_y = '%f', point_ext_z = '%f' WHERE point_id = '%d'",
            Point [ setting ] [ point_ext_x ], Point [ setting ] [ point_ext_y ], Point [ setting ] [ point_ext_z ], Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        Point [ setting ] [ point_vw ] = GetPlayerVirtualWorld(playerid) ;
        Point [ setting ] [ point_int ] = GetPlayerInterior( playerid ) ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_vw = %d, point_int = %d WHERE point_id = '%d'",
            Point [ setting ] [ point_vw ], Point [ setting ] [ point_int ], Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendServerMessage ( playerid, sprintf("%d ID'li noktayý bulunduðun yere taþýdýn.", setting), MSG_TYPE_INFO ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktayý kendi konumuna taþýdý.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_LOW ) ;
        ////OldLog ( playerid, "mod/points", sprintf("%s (%d) has moved point %d to their location.", ReturnUserName ( playerid, true ), playerid, setting )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp (option, "name" ) ) {


        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap name [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        Point [ setting ] [ point_name ] = extra ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_name = '%e' WHERE point_id = %d",
            Point [ setting ] [ point_name ], Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn adýný %s olarak deðiþtirdi.", ReturnUserName ( playerid, true ), playerid,  setting, Point [ setting ] [ point_name ]  ), MOD_WARNING_LOW ) ;
        //OldLog ( playerid, "mod/points", sprintf(" %s (%d) has renamed point ID %d to %s.", ReturnUserName ( playerid, true ), playerid, setting, Point [ setting ] [ point_id ] )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp (option, "type" ) ) {

        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {


            return SendServerMessage ( playerid, "/ap type [noktaid] [tip]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        new type = strval ( extra ) ;

        if ( type < 0 || type > 2 ) {

            return SendServerMessage ( playerid, "Tip 0'dan küçük veya 2'den büyük olamaz. Ýþletme tipleri için /point biztype kullan.", MSG_TYPE_ERROR ) ;
        }

        Point [ setting ] [ point_type ] = type ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_type = '%d' WHERE point_id = %d",
            type, Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn tipini %d olarak deðiþtirdi.", ReturnUserName ( playerid, true ), playerid, setting, Point [ setting ] [ point_type ] ), MOD_WARNING_LOW ) ;
        //OldLog ( playerid, "mod/points", sprintf(" %s (%d) has changed point ID %d's type to %d.", ReturnUserName ( playerid, true ), playerid, setting, Point [ setting ] [ point_type ] )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp (option, "sell" ) ) {


        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap sell [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        Point [ setting ] [ point_owner ] = 0 ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_owner = '-1', point_till = '0', point_till_change = '0', point_weapon1 = '0', point_weapon1ammo = '0', point_weapon2 = '0', point_weapon2ammo = '0' WHERE point_id = '%d'",
            Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktayý sattý.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_HIGH ) ;
        //OldLog ( playerid, "mod/points", sprintf("%s (%d) sold point ID %d.", ReturnUserName ( playerid, true ), playerid, setting )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp (option, "price" ) ) {


        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap price [noktaid] [fiyat]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        new price = strval ( extra ) ;

        Point [ setting ] [ point_price ] = price ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_price = '%d' WHERE point_id = %d",
            price, Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn fiyatýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, setting, price ), MOD_WARNING_MED ) ;
        //OldLog (playerid,  "mod/points", sprintf(" %s (%d) set point ID %d's price to %d.", ReturnUserName ( playerid, true ), playerid, setting, price )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp (option, "biz" ) ) {


        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap biz [noktaid] [iþletme-tipi]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        new biztype = strval ( extra ) ;

        Point [ setting ] [ point_biztype ] = biztype ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_biztype = '%d' WHERE point_id = %d",
            biztype, Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn iþletme tipini %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, setting, biztype ), MOD_WARNING_LOW ) ;
        //OldLog ( playerid, "mod/points", sprintf(" %s (%d) set point ID %d's business type %d.", ReturnUserName ( playerid, true ), playerid, setting, biztype )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp (option, "delete" ) ) {


        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap delete [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        mysql_format(mysql, query, sizeof ( query ), "DELETE FROM `points`  WHERE point_id = %d", Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktayý sildi.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_HIGH ) ;
        //OldLog ( playerid, "mod/points", sprintf("%s (%d) has deleted point ID %d.", ReturnUserName ( playerid, true ), playerid, setting )) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else if ( ! strcmp ( option, "lock" ) ) {

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap lock [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        if ( ! Point [ setting ] [ point_locked ] ) {

            Point [ setting ] [ point_locked ] = true ;

            SendServerMessage ( playerid, "Giriþ kapýsýný kilitledin.", MSG_TYPE_INFO ) ;
            SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktayý kilitledi.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_MED ) ;
            //OldLog ( playerid, "mod/points", sprintf("%s (%d) has locked point ID %d.", ReturnUserName ( playerid, true ), playerid, setting )) ;
        }

        else if ( Point [ setting ] [ point_locked ] ) { 

            Point [ setting ] [ point_locked ] = false ;

            SendServerMessage ( playerid, "Giriþ kapýsýnýn kilidini açtýn.", MSG_TYPE_INFO ) ;
            SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn kilidini açtý.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_MED ) ;
            //OldLog ( playerid, "mod/points", sprintf("%s (%d) has unlocked point ID %d.", ReturnUserName ( playerid, true ), playerid, setting )) ;
        }

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_locked = '%d' WHERE point_id = '%d'", Point [ setting ] [ point_locked ], Point [ setting ] [ point_id ] ) ;
        mysql_tquery ( mysql, query ) ;
    }

    else if ( ! strcmp ( option, "goto" ) ) {
        
        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap goto [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        ac_SetPlayerPos ( playerid, Point [ setting ] [ point_ext_x ], Point [ setting ] [ point_ext_y ], Point [ setting ] [ point_ext_z ]) ;
        SetPlayerInterior ( playerid, Point [ setting ] [ point_int ] ) ;
        SetPlayerVirtualWorld(playerid, Point [ setting ] [ point_vw]) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktaya ýþýnlandý.", ReturnUserName ( playerid, true ), playerid, setting ), MOD_WARNING_LOW ) ;
        //OldLog ( playerid, "mod/points", sprintf("%s (%d) has teleported to point ID %d.", ReturnUserName ( playerid, true ), playerid, setting )) ;

    }

    else if ( ! strcmp ( option, "inactive" ) ) {

        SendClientMessage(playerid, COLOR_YELLOW, "Aktif olmayan noktalar:" ) ;

        new rows [ 3 ] ;
        inline CheckPointOwners() {

            cache_get_row_count ( rows [ 0 ] ) ;

            if ( rows [ 0 ] ) {

                for ( new i, j = rows [ 0 ] ; i < j; i++ ) {

                    new pointid, pointname[32], pointowner;

                    cache_get_value_int ( i, "point_id", pointid ) ;
                    cache_get_value_name ( i, "point_name", pointname, 32 ) ;
                    cache_get_value_int ( i, "point_owner", pointowner ) ;

                    inline PlayerCharacterCheck() {

                        cache_get_row_count ( rows [ 1 ] ) ;

                        if ( rows [ 1 ] ) {

                            new id, name[MAX_PLAYER_NAME];

                            cache_get_value_int (0, "account_id", id ) ;
                            cache_get_value_name(0, "character_name", name, MAX_PLAYER_NAME ) ; 

                            inline PlayerInactiveCheck() {

                                cache_get_row_count ( rows [ 2 ] ) ;

                                if ( rows [ 2 ] ) {

                                    new accname[MAX_PLAYER_NAME],timestamp;

                                    cache_get_value_name(0,"account_name", accname, MAX_PLAYER_NAME ) ;
                                    cache_get_value_int (0, "account_lastlogin", timestamp);

                                    if ( gettime() - 604800 > timestamp ) {

                                        SendServerMessage ( playerid, sprintf("[%d] %s - Sahibi: %s (%s)", pointid, pointname, name, accname), MSG_TYPE_INFO ) ;
                                    }

                                    else continue;
                                }
                            }
                            MySQL_TQueryInline ( mysql, using inline PlayerInactiveCheck, "SELECT account_name,account_lastlogin FROM master_accounts WHERE account_id = %d", id);
                        }
                    }
                    MySQL_TQueryInline ( mysql, using inline PlayerCharacterCheck, "SELECT account_id, character_name FROM characters WHERE character_id = %d", pointowner );
                }

                SetTimerEx("DelayInactiveCheck", 1000, false, "iii", playerid, rows [ 0 ], 0) ;
            }
        }

        MySQL_TQueryInline(mysql, using inline CheckPointOwners, "SELECT point_id, point_name, point_owner FROM points WHERE point_owner != -1");

        return true ;
    }

    else if ( ! strcmp ( option, "clearinactive" ) ) {

        task_yield ( 1 );

        new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
        await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_MSGBOX, "{C23030}UYARI", "{C23030}DEVAM ETMEDEN ÖNCE OKU.{DEDEDE}\n\nAktif olmayan tüm noktalarý temizlemek üzeresin.\nEðer tüm pasif noktalarý silmek istediðine eminsen, \"Devam Et\"e bas.", "{C23030}Devam Et", "Ýptal" ) ;

        if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

            new rows [ 3 ] ;

            inline clear_CheckPointOwners() {

                cache_get_row_count ( rows [ 0 ] ) ;

                if ( rows [ 0 ] ) {

                    for ( new i, j = rows [ 0 ] ; i < j; i++ ) {

                        new pointid, pointowner ;

                        cache_get_value_int ( i, "point_id", pointid ) ;
                        cache_get_value_int ( i, "point_owner", pointowner ) ;

                        inline clear_PlayerCharacterCheck() {

                            cache_get_row_count ( rows [ 1 ] ) ;

                            if ( rows [ 1 ] ) {

                                new id ;

                                cache_get_value_int (0, "account_id", id ) ;

                                inline clear_PlayerInactiveCheck() {

                                    cache_get_row_count ( rows [ 2 ] ) ;

                                    if ( rows [ 2 ] ) {

                                        new timestamp;

                                        cache_get_value_int (0, "account_lastlogin", timestamp);

                                        if ( gettime() - 604800 > timestamp ) {

                                            mysql_format ( mysql, query, sizeof ( query ), "UPDATE points SET point_owner = '-1', point_till = '0', point_till_change = '0', point_weapon1 = '0', point_weapon1ammo = '0', point_weapon2 = '0', point_weapon2ammo = '0' WHERE point_id = '%d'", pointid ) ;
                                            //mysql_tquery ( mysql, query ) ;
                                            //SendServerMessage(playerid,sprintf("[%i]: %i removed.",pointid,pointowner),MSG_TYPE_INFO);
                                        }
                                        else continue;
                                    }
                                }
                                MySQL_TQueryInline ( mysql, using inline clear_PlayerInactiveCheck, "SELECT account_lastlogin FROM master_accounts WHERE account_id = %d", id);
                            }
                        }
                        MySQL_TQueryInline ( mysql, using inline clear_PlayerCharacterCheck, "SELECT account_id FROM characters WHERE character_id = %d", pointowner );
                    }

                    SetTimerEx("DelayInactiveCheck", 1000, false, "iii", playerid, rows [ 0 ], 1) ;
                }

                else {

                    return SendServerMessage ( playerid, "Temizlenecek pasif nokta bulunamadý.", MSG_TYPE_ERROR ) ;
                }
            }

            MySQL_TQueryInline ( mysql, using inline clear_CheckPointOwners, "SELECT point_id, point_owner FROM points WHERE point_owner != -1" );
        }

        else return true ;
    }

    else if ( ! strcmp ( option, "owner" ) ) {

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap owner [noktaid]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        new rows;
        inline CheckPointOwner() {

            cache_get_row_count ( rows ) ;

            if ( rows ) {

                for ( new i; i<rows; i++ ) {

                    new pointowner;
                    cache_get_value_int ( i, "point_owner", pointowner ) ;

                    inline OwnerNamePull() {

                        cache_get_row_count ( rows ) ;

                        if ( rows ) {

                            new accid, charid, name[MAX_PLAYER_NAME];

                            cache_get_value_int (0, "account_id", accid ) ;
                            cache_get_value_int (0, "character_id", charid ) ;

                            cache_get_value_name(0, "character_name", name, MAX_PLAYER_NAME ) ; 

                            SendServerMessage ( playerid, sprintf("Nokta %d'nin sahibi: %s [Karakter ID %d, MA %d ]", setting, name, charid, accid), MSG_TYPE_WARN ) ;
                        }

                        else continue;
                    }

                    MySQL_TQueryInline ( mysql, using inline OwnerNamePull, "SELECT account_id, character_id, character_name FROM characters WHERE character_id = %d", pointowner );

                    return true ;
                }
            }

            else if ( ! rows ) {

                return SendServerMessage ( playerid, "Ýþletmeye sahip kimse yok.", MSG_TYPE_ERROR ) ;
            }

            return SendClientMessage(playerid, -1, "Aktif olmayan nokta yok!" ) ;
        }

        MySQL_TQueryInline(mysql, using inline CheckPointOwner, "SELECT point_owner FROM points WHERE point_id = %d", Point [ setting ] [ point_id ]  );
    }


    else if ( ! strcmp ( option, "fee" ) ) {

        if ( ! IsPlayerManager ( playerid ) ) {

            return SendServerMessage ( playerid, "Hayýr.", MSG_TYPE_ERROR ) ;
        }

        if ( setting == -1 ) {

            return SendServerMessage ( playerid, "/ap fee [noktaid] [ücret]", MSG_TYPE_ERROR ) ;
        }

        if ( Point [ setting ] [ point_id ] == -1 ) {

            return SendServerMessage ( playerid, "Geçersiz nokta ID'si. Lütfen geçerli bir ID seç.", MSG_TYPE_ERROR ) ;
        }

        new fee = strval ( extra ) ;

        Point [ setting ] [ point_fee ] = fee ;

        mysql_format(mysql, query, sizeof ( query ), "UPDATE points SET point_fee = '%d' WHERE point_id = %d",
            fee, Point [ setting ] [ point_id ]  ) ;

        mysql_tquery ( mysql, query ) ;

        SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d), %d ID'li noktanýn ücretini %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, setting, fee ), MOD_WARNING_MED ) ;

        Init_Points ( Point [ setting ] [ point_id ] ) ;
    }

    else {

        SendServerMessage ( playerid, "/apoint [parametre] [ayar] [ekstra: opsiyonel]", MSG_TYPE_ERROR ) ;
        SendServerMessage ( playerid, "PARAMETRELER: [info, create, delete, sell, int, move, name, type, price, biz, lock, goto, inactive, clearinactive, owner, fee]", MSG_TYPE_WARN) ;
        return SendServerMessage ( playerid, "Ek bilgi için /apoint info yaz. Biz tiplerini ve nokta tiplerini gösterir.", MSG_TYPE_INFO ) ;
    }

    return true ;
}

CMD:mypoints ( playerid, params [] ) {

    SendServerMessage ( playerid, "Sahibi olduðun noktalar:", MSG_TYPE_WARN ) ;

    new count ;

    for ( new i; i < MAX_POINTS; i ++ ) {

        if ( Point [ i ] [ point_id ] == -1 ) {

            continue ;
        }

        if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

            count ++ ;

            SendClientMessage(playerid, 0xDEDEDEFF, sprintf("(%d) %s [DB: %d]", i, Point [ i ] [ point_name ], Point [ i ] [ point_id ] ) ) ;

            continue ;
        }

        else continue ;
    }


    if ( ! count ) {

        return SendServerMessage ( playerid, "Hiç noktan yok.", MSG_TYPE_ERROR ) ;
    }

    return true ;
}

forward DelayInactiveCheck(playerid, total, clear);
public DelayInactiveCheck(playerid, total, clear) {

    if ( ! clear ) {

        SendServerMessage ( playerid, sprintf("Toplam %i aktif olmayan nokta var.", total ), MSG_TYPE_INFO ) ;
    }

    else {

        SendServerMessage ( playerid, sprintf("%i aktif olmayan nokta temizlendi.", total ), MSG_TYPE_INFO ) ;
        Init_Points ( ) ;
    }

    return true ;
}
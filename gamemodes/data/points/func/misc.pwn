new advertiseTick [ MAX_PLAYERS ], playerLastTelegramPage [ MAX_PLAYERS ], bool: playerTelegramUsingMySQL [ MAX_PLAYERS ] ;

CMD:doorshout ( playerid, params [] ) {

    new text [ 144 ] ;

    if ( sscanf ( params, "s[144]", text ) ) {

        return SendServerMessage ( playerid, "/doorshout [yazý]", MSG_TYPE_ERROR ) ;
    }

    if ( strlen ( text ) > 144 || ! strlen ( text ) ) {

        return SendServerMessage ( playerid, "Lütfen 144 karakterden fazla yazma!", MSG_TYPE_ERROR ) ;
    }

    new pointid = -1 ;

    for ( new i; i < MAX_POINTS; i ++ ) {

        if ( Point [ i ] [ point_id ] != -1 ) {

            if ( IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_ext_x ],  Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int ] || 
                 IsPlayerInRangeOfPoint(playerid, 2.5, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

                pointid = i ;
            }

            else continue ;
        }

        else continue ;
    }

    if ( pointid == -1 ) {

        return SendServerMessage ( playerid, "Bir kapýnýn yakýnýnda deðilsin.", MSG_TYPE_ERROR ) ;
    }

    foreach (new i: Player) {

        if ( i == playerid ) {

            continue ;
        }

        if ( IsPlayerInRangeOfPoint(i, 2.5, Point [ pointid ] [ point_int_x ],  Point [ pointid ] [ point_int_y ], Point [ pointid ] [ point_int_z ] ) && GetPlayerVirtualWorld ( i ) == Point [ pointid ] [ point_int_vw ] && GetPlayerInterior ( i ) == Point [ pointid ] [ point_int_int ] ) {
    
            SendClientMessage(i, COLOR_BLUE, sprintf("%s kapýdan baðýrýyor (dýþarýdan): %s", ReturnUserName ( playerid, false ), text ) ) ;
        }
        
        else if ( IsPlayerInRangeOfPoint(i, 2.5, Point [ pointid ] [ point_ext_x ],  Point [ pointid ] [ point_ext_y ], Point [ pointid ] [ point_ext_z ] ) && GetPlayerVirtualWorld ( i ) == Point [ pointid ] [ point_vw ] && GetPlayerInterior ( i ) == Point [ pointid ] [ point_int ] ) {
    
            SendClientMessage(i, COLOR_BLUE, sprintf("%s kapýdan baðýrýyor (içeriden): %s", ReturnUserName ( playerid, false ), text ) ) ;
        }

        else continue ;
    }

    ProxDetector ( playerid, 30, -1, sprintf("%s kapýdan baðýrýyor: %s", ReturnUserName ( playerid, false ), text) ) ;

    return true ;
}

CMD:ds ( playerid, params [] ) {

    return cmd_doorshout ( playerid, params ) ;
}

CMD:buytelegramnumber ( playerid, params [] ) {

    return SendServerMessage(playerid,"Bu özellik þu an devre dýþý.",MSG_TYPE_ERROR);
}

CMD:telegram ( playerid, params [] ) {

    for ( new i; i < MAX_POINTS; i ++ ) {
        if ( Point [ i ] [ point_id ] != -1 ) {
            if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
                GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

                if ( Point [ i ] [ point_biztype ] == POINT_TYPE_POSTAL ) {

                    if ( Character [ playerid ] [ character_telegram_id ] == -1 ) {

                        return SendServerMessage ( playerid, "Bir telgraf numaran yok!", MSG_TYPE_ERROR ) ;
                    }

                    new telenumber, message [ 100 ] ;

                    if ( sscanf ( params, "ds[100]", telenumber, message ) ) {

                        return SendServerMessage ( playerid, "/tele(gram) [numara] [mesaj]", MSG_TYPE_ERROR ) ;
                    }

                    if ( telenumber == Character [ playerid ] [ character_telegram_id ] ) {

                        return SendServerMessage ( playerid, "Kendine telgraf gönderemezsin!", MSG_TYPE_ERROR ) ;
                    }

                    new query [ 256 ] ;

                    inline CheckIfTeleNumberExists() {

                        new rows;

                        cache_get_row_count ( rows ) ;

                        if ( rows ) {

                            new charid ;

                            cache_get_value_int ( 0, "character_id", charid ) ;

                            mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO telegrams (telegram_sender, telegram_reciever, telegram_message, telegram_date) VALUES (%d, %d, '%e', '%e')",
                                Character [ playerid ] [ character_telegram_id ], telenumber, message, ReturnServerTime() ) ;
                            mysql_tquery ( mysql, query ) ;

                            SendServerMessage ( playerid, sprintf("%i numarasýna telgraf gönderdin.", telenumber ), MSG_TYPE_INFO ) ;

                            foreach ( new j : Player ) {

                                if ( Character [ j ] [ character_id ] == charid ) {

                                    Init_LoadTelegrams ( j ) ;
                                    SetTimerEx("RecieveTelegramMessage", 300000, false, "i", j);
                                }
                                else continue;
                            }

                            return true ;
                        }

                        else {

                            return SendServerMessage ( playerid, "Bu telgraf numarasý mevcut deðil.", MSG_TYPE_ERROR ) ;
                        }
                    }

                    MySQL_TQueryInline ( mysql, using inline CheckIfTeleNumberExists, "SELECT character_id FROM characters WHERE character_telegram_id = %d", telenumber );

                }
                else continue;
            }
            else continue;
        }
        else continue;
    }

    return SendServerMessage ( playerid, "Bir postane içinde deðilsin!", MSG_TYPE_ERROR ) ;
}

CMD:tele ( playerid, params [] ) return cmd_telegram ( playerid, params ) ;

CMD:viewtelegrams ( playerid, params [] ) {

	return SendClientMessage(playerid, -1, "ÞUANDA DEVRE DIÞI." ) ;

	/*
	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				if ( Point [ i ] [ point_biztype ] == POINT_TYPE_POSTAL ) {

					new option [ 16 ] ;

					if ( sscanf ( params, "s[16]", option ) ) {

						return SendServerMessage ( playerid, "/viewtelegrams [sent/recieved]", MSG_TYPE_ERROR ) ;
					}

					if ( !strcmp ( option, "recieved" ) ) {

						if ( TelegramCount [ playerid ] ) {

							playerLastTelegramPage [ playerid ] = 1 ;
							playerTelegramUsingMySQL [ playerid ] = false ;
							return ViewTelegrams ( playerid ) ;
						}

						else { return SendServerMessage ( playerid, "You have no telegrams!", MSG_TYPE_ERROR ) ; }
					}

					else if ( ! strcmp ( option, "sent" ) ) {

						playerLastTelegramPage [ playerid ] = 1 ;
						playerTelegramUsingMySQL [ playerid ] = true ;
						return ViewTelegrams ( playerid, 1 ) ;
					}
				}
				else continue;
			}
			else continue;
		}
		else continue;
	}

	return true ;
	*/
}

CMD:paycheck ( playerid, params [] ) {

	/*
	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				if ( Point [ i ] [ point_biztype ] == POINT_TYPE_POSTAL ) {

					if ( Character [ playerid ] [ character_paycheck ] <= 0 ) {

						if(Character[playerid][character_paychange] <= 0) { return SendServerMessage ( playerid, "You can't withdraw money that you don't have.", MSG_TYPE_ERROR ) ; }
					}

					new paycheck = Character [ playerid ] [ character_paycheck ], paychange = Character[playerid][character_paychange] ;

					if(paycheck) {

						TakeCharacterMoney ( playerid, Character [ playerid ] [ character_paycheck ], MONEY_SLOT_PAYC ) ;
						GiveCharacterMoney ( playerid, paycheck, MONEY_SLOT_BANK ) ;
					}
					if(paychange) {

						TakeCharacterChange(playerid,Character[playerid][character_paychange],MONEY_SLOT_PAYC);
						GiveCharacterChange(playerid,paychange,MONEY_SLOT_BANK);
					}

					SendServerMessage ( playerid, sprintf("You've collected your paycheck of $%s.%02d.", IntegerWithDelimiter ( paycheck ), paychange), MSG_TYPE_INFO ) ;


					return true ;
				}
			}

			else continue ;
		}

		else continue ;
	}
	*/
if(GetCharacterPointID(playerid) == -1) { return SendServerMessage ( playerid, "Bir postane içinde deðilsin!", MSG_TYPE_ERROR ) ; }
    else {

        new id = GetCharacterPointID(playerid);
        if(Point[id][point_biztype] == POINT_TYPE_POSTAL) {

            if(Character[playerid][character_paycheck] < 0) { return SendServerMessage(playerid,"Maaþ olarak alabileceðin bir para bulunmuyor.",MSG_TYPE_ERROR); }
            else if(Character[playerid][character_paycheck] == 0) {

                if(Character[playerid][character_paychange] <= 0) { return SendServerMessage(playerid,"Maaþ olarak alabileceðin bir para bulunmuyor.",MSG_TYPE_ERROR); }
                else { goto receivePaycheck; }
            }

            receivePaycheck:

            SendServerMessage(playerid,sprintf("Maaþýndan $%s.%02d aldýn.",IntegerWithDelimiter(Character[playerid][character_paycheck]),Character[playerid][character_paychange]),MSG_TYPE_INFO);
            if(Character[playerid][character_paycheck] > 0) {

                GiveCharacterMoney(playerid,Character[playerid][character_paycheck],MONEY_SLOT_BANK);
                SetCharacterMoney(playerid,0,MONEY_SLOT_PAYC);
            }
            if(Character[playerid][character_paychange] > 0) {

                GiveCharacterChange(playerid,Character[playerid][character_paychange],MONEY_SLOT_BANK);
                SetCharacterChange(playerid,0,MONEY_SLOT_PAYC);
            }
        }
        else { return SendServerMessage ( playerid, "Bir postane içinde deðilsin!", MSG_TYPE_ERROR ) ; }
    }
    return true;
}

CMD:bank ( playerid, params [] ) {

    for ( new i; i < MAX_POINTS; i ++ ) {
        if ( Point [ i ] [ point_id ] != -1 ) {
            if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
                GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

                if ( Point [ i ] [ point_biztype ] == POINT_TYPE_BANK ) {

                    new option [ 24 ], value, cents ;

                    if ( sscanf ( params, "s[24]I(0)I(0)", option, value, cents )) {

                        return SendServerMessage ( playerid, "/bank [deposit, withdraw, balance] [opsiyonel:dolar] [opsiyonel:cent]", MSG_TYPE_ERROR ) ;
                    }

                    if ( ! strcmp ( option, "deposit" ) ) {

                        if ( value > Character [ playerid ] [ character_handmoney ] ) {

                            return SendServerMessage ( playerid, "Üzerinde o kadar para yok.", MSG_TYPE_ERROR ) ;
                        }

                        if( value < 0 ) {

                            return SendServerMessage(playerid,"Negatif miktarda para yatýramazsýn.",MSG_TYPE_ERROR);
                        }

                        if ( value == 0 ) {

                            if(cents <= 0) { return SendServerMessage ( playerid, "0 dolar veya cent'ten az miktar yatýramazsýn.", MSG_TYPE_ERROR ) ; }
                        }

						if(cents < 0 || cents > 99) {

							return SendServerMessage(playerid,"1-99 cent yatýrabilirsin.",MSG_TYPE_ERROR);
						}

						new oldbalance = Character [ playerid ] [ character_bankmoney ], oldchange = Character[playerid][character_bankchange] ;

						if(value) {
							
							TakeCharacterMoney ( playerid, value, MONEY_SLOT_HAND ) ;
							GiveCharacterMoney ( playerid, value, MONEY_SLOT_BANK ) ;
						}
						if(cents) {

							TakeCharacterChange(playerid,cents,MONEY_SLOT_HAND);
							GiveCharacterChange(playerid,cents,MONEY_SLOT_BANK);
						}

						if(cents) { SendServerMessage ( playerid, sprintf("Banka hesabýna $%s.%02d yatýrdýn.", IntegerWithDelimiter ( value ), cents ), MSG_TYPE_INFO ) ; }
						else { SendServerMessage ( playerid, sprintf("Banka hesabýna $%s yatýrdýn.", IntegerWithDelimiter ( value ) ), MSG_TYPE_INFO ) ; }
						SendServerMessage ( playerid, sprintf("Yeni bakiye: $%s.%02d. Eski bakiye: $%s.%02d.", IntegerWithDelimiter ( Character [ playerid ] [ character_bankmoney ] ), Character[playerid][character_bankchange], IntegerWithDelimiter ( oldbalance ), oldchange), MSG_TYPE_INFO ) ;
						WriteLog ( playerid, "bank", sprintf("%s deposited %s.%02d [bank: %s.%02d]", ReturnUserName ( playerid, true ), IntegerWithDelimiter ( value ), cents, IntegerWithDelimiter ( Character [ playerid ] [ character_bankmoney ] ), Character[playerid][character_bankchange] ) ) ;
						return true ;
					}

					else if ( ! strcmp ( option, "withdraw" ) ) {
						if ( value > Character [ playerid ] [ character_bankmoney ] ) {

							return SendServerMessage ( playerid, "Banka bakiyeniz yetersiz.", MSG_TYPE_ERROR ) ;
						}

						if( value < 0 ) {

							return SendServerMessage(playerid,"Negatif deðer çekemezsin!",MSG_TYPE_ERROR);
						}
					
						if ( value == 0) {

							if(cents <= 0) { return SendServerMessage ( playerid, "0 dolar veya 0 cent çekemezsin.", MSG_TYPE_ERROR ) ; }
						}

						if(cents < 0 || cents > 99) {

							return SendServerMessage(playerid,"1-99 cent yatýrabilirsin.",MSG_TYPE_ERROR);
						}

						new oldbalance = Character [ playerid ] [ character_bankmoney ], oldchange = Character[playerid][character_bankchange] ;

						if(value) {
							
							TakeCharacterMoney ( playerid, value, MONEY_SLOT_BANK ) ;
							GiveCharacterMoney ( playerid, value, MONEY_SLOT_HAND ) ;
						}
						if(cents) {

							TakeCharacterChange(playerid,cents,MONEY_SLOT_BANK);
							GiveCharacterChange(playerid,cents,MONEY_SLOT_HAND);
						}

					if(cents) { SendServerMessage ( playerid, sprintf("Banka hesabýndan $%s.%02d çektin.", IntegerWithDelimiter ( value ), cents ), MSG_TYPE_INFO ) ; }
					else { SendServerMessage ( playerid, sprintf("Banka hesabýndan $%s çektin.", IntegerWithDelimiter ( value ) ), MSG_TYPE_INFO ) ; }
					SendServerMessage ( playerid, sprintf("Yeni bakiye: $%s.%02d. Eski bakiye: $%s.%02d.", IntegerWithDelimiter ( Character [ playerid ] [ character_bankmoney ] ), Character[playerid][character_bankchange], IntegerWithDelimiter ( oldbalance ), oldchange), MSG_TYPE_INFO ) ;

						WriteLog ( playerid, "bank", sprintf("%s withdrew %s.%02d [bank: %s.%02d]", ReturnUserName ( playerid, true ), IntegerWithDelimiter ( value ), cents, IntegerWithDelimiter ( Character [ playerid ] [ character_bankmoney ] ), Character[playerid][character_bankchange] ) ) ;
						return true ;
					}

					else if ( ! strcmp ( option, "balance" ) ) {

						SendServerMessage ( playerid, sprintf("Banka bakiyesi: $%s.%02d", IntegerWithDelimiter ( Character [ playerid ] [ character_bankmoney ] ),Character[playerid][character_bankchange]), MSG_TYPE_INFO ) ;

						return true ;
					}

					return SendServerMessage ( playerid, "/bank [deposit(yatýr), withdraw(çek), balance(bakiye)] [opsiyonel:dollars] [opsiyonel:cents]", MSG_TYPE_ERROR ) ;
				}

				else continue ;
			}
		}

		else continue ;
	}

	return SendServerMessage ( playerid, "Bankada deðilsin.", MSG_TYPE_ERROR ) ;
}

CMD:advertise ( playerid, params [] ) {

	new tickDiff;
	for ( new i; i < MAX_POINTS; i ++ ) {
		if ( Point [ i ] [ point_id ] != -1 ) {
			if ( IsPlayerInRangeOfPoint(playerid, 15.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && 
				GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

				if ( Point [ i ] [ point_biztype ] == POINT_TYPE_POSTAL ) {

					tickDiff = GetTickDiff ( GetTickCount(), advertiseTick [ playerid ] ) ;

					if ( tickDiff < 30000 ) {

						return SendServerMessage ( playerid, sprintf("Tekrar reklam verebilmek için %0.2f saniye beklemen gerek.",float(30000 - tickDiff) / 1000.0), MSG_TYPE_ERROR ) ;
					}

					if ( Account [ playerid ] [ account_donatorlevel ] < 3 ) { //donor check

						if ( Character [ playerid ] [ character_handmoney ] < 15 ) {

							return SendServerMessage ( playerid, "Reklam verebilmek için en az $15 gerekiyor.", MSG_TYPE_ERROR ) ;
						}
					}

					new adv [ 144 ] ;

					if ( sscanf ( params, "s[144]", adv ) ) {
						SendServerMessage ( playerid, "Karakter baþý ücret alýnýr, 50 karakter 25$ eder.", MSG_TYPE_ERROR ) ;
						return SendServerMessage ( playerid, "/ad(vertise) [mesaj]", MSG_TYPE_ERROR ) ;
					}

					new price = strlen ( adv ) / 2 ;

					if ( Account [ playerid ] [ account_donatorlevel ] < 3 ) { //donor check

						if ( price > Character [ playerid ] [ character_handmoney ] ) {

							return SendServerMessage ( playerid, sprintf("Reklam verebilmek için $%d gerekli.", price), MSG_TYPE_ERROR ) ;
						}

						TakeCharacterMoney ( playerid, price, MONEY_SLOT_HAND ) ;
					}

					SendSplitMessageToAll ( COLOR_TAB1, sprintf("[KASABA GAZETESI]: %s", adv ) ) ;
					WriteLog ( playerid, "advertisements", sprintf("%s made ad: %s", ReturnUserName ( playerid, true ), adv ) ) ;

					if ( Account [ playerid ] [ account_donatorlevel ] < 3 ) { SendServerMessage ( playerid, sprintf("You've paid $%s for your advertisement.", IntegerWithDelimiter ( price )), MSG_TYPE_WARN) ; }
					SendModeratorWarning ( sprintf("[reklam] son reklamý (%d) %s adlý oyuncu gönderdi.", playerid, ReturnUserName ( playerid, true )), MOD_WARNING_MED ) ;
					//OldLog ( playerid, "advs", sprintf ( "%s posted ad \"%s\" for %d", ReturnUserName ( playerid, false ), adv, price )) ;

					advertiseTick [ playerid ] = GetTickCount();

					return true ;
				}
			}

			else continue ;
		}

		else continue ;
	}

	return SendServerMessage ( playerid, "Posta ofisinde deðilsin!", MSG_TYPE_ERROR ) ;
}

CMD:ad(playerid, params [] ) {

	return cmd_advertise ( playerid, params ) ;
}


ViewTelegrams ( playerid, usingmysql = 0 ) {

	task_yield ( 1 );
	
	new MAX_TELEGRAMS_PER_PAGE = 5, string [ 1024 ], pages, resultcount, telecount, dialog_response [ e_DIALOG_RESPONSE_INFO ] ;

	static index ;

	if ( ! usingmysql ) {

		telecount = TelegramCount [ playerid ] ;
		pages = floatround ( telecount / MAX_TELEGRAMS_PER_PAGE, floatround_floor ) + 1 ;
    	resultcount = ( ( MAX_TELEGRAMS_PER_PAGE * playerLastTelegramPage [ playerid ] ) - MAX_TELEGRAMS_PER_PAGE ) ;

    	for ( new i = resultcount; i < sizeof ( telecount ); i ++ ) {

	        if ( resultcount <= MAX_TELEGRAMS_PER_PAGE * playerLastTelegramPage [ playerid ] ) {

	           format ( string, sizeof ( string ), "%s%d. [%s] %d: %s\n", string, Telegram [ playerid ] [ index ] [ telegram_id ], Telegram [ playerid ] [ index ] [ telegram_date ], Telegram [ playerid ] [ index ] [ telegram_sender ], Telegram [ playerid ] [ index ] [ telegram_message ] ) ;
	        }

	        index ++ ; 
	    }

	    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, sprintf("Telgraflar- %d - %d", playerLastTelegramPage [ playerid ], pages ), string, "Next", "Exit" ) ;
	}

	else {

		await mysql_aquery_s ( mysql, @("SELECT telegram_id, telegram_reciever, telegram_message, telegram_date FROM telegrams WHERE telegram_sender = ") % ( Character [ playerid ] [ character_telegram_id ] ) % @("ORDER BY telegram_id DESC") ); 
		
		new rows ;

		cache_get_row_count ( rows ) ;

		if ( rows ) {

			telecount = rows ;
			pages = floatround ( telecount / MAX_TELEGRAMS_PER_PAGE, floatround_floor ) + 1 ;
			resultcount = ( ( MAX_TELEGRAMS_PER_PAGE * playerLastTelegramPage [ playerid ] ) - MAX_TELEGRAMS_PER_PAGE ) ;
			new teleid [ sizeof ( rows ) ], telenum [ sizeof ( rows ) ], telemessage [ sizeof ( rows ) ] [ 100 ], teledate [ sizeof ( rows ) ] [ 64 ], dummymsg [ 100 ], dummydate [ 64 ] ;

			for ( new i; i < rows; i ++ ) {

				cache_get_value_int ( i, "telegram_id", teleid [ i ] ) ;
				cache_get_value_int ( i, "telegram_reciever", telenum [ i ] ) ;
				cache_get_value_name( i, "telegram_message", dummymsg, 100 ) ;
				telemessage [ i ] = dummymsg ;
				cache_get_value_name ( i, "telegram_date", dummydate, 64 ) ;
				teledate [ i ] = dummydate ;
			}

			for ( new i = resultcount; i < sizeof ( telecount ); i ++ ) {

				if ( resultcount <= MAX_TELEGRAMS_PER_PAGE * playerLastTelegramPage [ playerid ] ) {

					format ( string, sizeof ( string ), "%s%d. [%s] %d: %s\n", string, teleid [ i ], teledate [ i ], telenum [ i ], telemessage [ i ] ) ;
				}
			}

			await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, sprintf("Telgraflar- %d - %d", playerLastTelegramPage [ playerid ], pages ), string, "Next", "Exit" ) ;
		}

		else { return SendServerMessage ( playerid, "Henüz bir telgraf yollamadýn.", MSG_TYPE_ERROR ) ; }

	}

	if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) return true ;
	else {

		if ( playerLastTelegramPage [ playerid ] >= pages ) { index = 0 ; playerTelegramUsingMySQL [ playerid ] = false ; return true ; }

		else {

			playerLastTelegramPage [ playerid ] ++ ;
			if ( ! playerTelegramUsingMySQL [ playerid ] ) { return ViewTelegrams ( playerid ) ; }
			else { return ViewTelegrams ( playerid, 1 ) ; }
		}
	}
}
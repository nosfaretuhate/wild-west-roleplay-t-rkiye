SelectSpawn ( playerid ) {

	SetTimerEx("NameTagProofCheck", 5000, false, "i", playerid);

	if ( Character [ playerid ]  [ character_ajailed ] ) {

		SendServerMessage ( playerid, sprintf("Admin cezasý süresi: %d dakika.", Character [ playerid ]  [ character_ajailed ] ), MSG_TYPE_INFO ) ;

		IsPlayerInAdminJail [ playerid ] = true ;
		
		//SetSpawnInfo ( playerid, -1, Character [ playerid ]  [ character_skin ], -869.9045, 2308.7915, 155.8610 , 90.0, -1, -1, -1, -1, -1, -1 ) ;
		ac_SetPlayerPos ( playerid, 154.1281, -1951.9653, 47.4766 ) ;
		TogglePlayerControllable ( playerid, false ) ;
		
		SetPlayerVirtualWorld(playerid, 0 );

		SendServerMessage ( playerid, "Admin jail bölgesine geri gönderildin.", MSG_TYPE_WARN ) ;
		return true ;
	}

	else if ( Character [ playerid ] [ character_prison ] != 0 ) {

		if ( Character [ playerid ] [ character_prison ] > gettime () ) {

			ac_SetPlayerPos ( playerid, Character [ playerid ] [ character_prison_pos_x], Character [ playerid ] [ character_prison_pos_y], Character [ playerid ] [ character_prison_pos_z] ) ;
			SetPlayerInterior ( playerid, Character [ playerid ] [ character_prison_interior ] );
			SetPlayerVirtualWorld ( playerid, Character [ playerid ] [ character_prison_vw ] );
			switch ( random ( 2 ) ) {

                case 0: SendClientMessage(playerid, COLOR_DEFAULT, "** Hücre bloðundaki kavgadan sonra uyandýnýz.." ) ;
                case 1: SendClientMessage(playerid, COLOR_DEFAULT, "** Bir gardiyanýn baþka bir mahkumla tartýþma sesine uyandýnýz.." );
			}
			return true ;
		}

		else {

			new query [ 256 ] ;

			Character [ playerid ] [ character_prison ] = 0;
			Character [ playerid ] [ character_prison_pos_x] = 0.0;
			Character [ playerid ] [ character_prison_pos_y] = 0.0;
			Character [ playerid ] [ character_prison_pos_z] = 0.0;
			Character [ playerid ] [ character_prison_interior] = 0;
			Character [ playerid ] [ character_prison_vw] = 0;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_prison = %d, character_prison_pos_x = '%f', character_prison_pos_y = '%f',character_prison_pos_z = '%f', character_prison_interior = %d, character_prison_vw = %d WHERE character_id = %d",
				Character [ playerid ] [ character_prison ], Character [ playerid ] [ character_prison_pos_x ], Character [ playerid ] [ character_prison_pos_y ], Character [ playerid ] [ character_prison_pos_z ], Character [ playerid ] [ character_prison_interior ], Character [ playerid ] [ character_prison_vw ], Character [ playerid ] [ character_id ] ) ;
			mysql_tquery ( mysql, query );
		}
	}

	else {

		if(Character [ playerid ] [ character_crashed ]) {

			new query[128];
			Character[playerid][character_crashed] = 0;
			ac_SetPlayerPos ( playerid, Character [ playerid ] [ character_pos_x ], Character [ playerid ] [ character_pos_y ], Character [ playerid ] [ character_pos_z ] ) ;

			SetPlayerInterior ( playerid, Character [ playerid ] [ character_pos_interior ] ) ;
			SetPlayerVirtualWorld ( playerid, Character [ playerid ] [ character_pos_vw ] ) ;

			mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_crashed = 0 WHERE character_id = %d",Character[playerid][character_id]);
			mysql_tquery(mysql,query);

			SendServerMessage ( playerid, "Crash aldýðýn konumda spawn edildin.", MSG_TYPE_INFO ) ;
			return true;
		}

		switch ( Character [ playerid ] [ character_spawnpoint ] ) {
			case 0: {

				ac_SetPlayerPos( playerid, SERVER_SPAWN_X, SERVER_SPAWN_Y, SERVER_SPAWN_Z ) ;
				SetPlayerFacingAngle(playerid, SERVER_SPAWN_A ) ;
				SetPlayerVirtualWorld(playerid, 0 );
			}

			case 1 : {

				switch ( Character [ playerid ]  [ character_town ] ) {

					case 0: { // longcreek
							
						ac_SetPlayerPos ( playerid, -1418.1863, 2641.7834, 55.3046 ) ;	
						return true ;
					}

					case 1: { // fremont
							
						ac_SetPlayerPos ( playerid, -797.6470, 1436.1898, 13.4218 ) ;
						return true ;	
					}

					default: { // longcreek
							
						ac_SetPlayerPos ( playerid, -1418.1863, 2641.7834, 55.3046 ) ;	
						return true ;
					}
				}
			}

			case 2 .. 3 : {
				for ( new i; i < MAX_POINTS; i ++ ) {

					if ( Point [ i ] [ point_id]  != -1 ) {

						if ( Character [ playerid ] [ character_spawnpoint ] == 2 ) {
							if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

								if ( Point [ i ] [ point_type ] == POINT_TYPE_HOUSE ) {

									//SetSpawnInfo ( playerid, -1, Character [ playerid ]  [ character_skin ], Point [ i ] [ point_int_x ], Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ], 90.0, -1, -1, -1, -1, -1, -1 ) ;
									ac_SetPlayerPos ( playerid, Point [ i ] [ point_int_x ], Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) ;

									SetPlayerVirtualWorld(playerid, Point [ i ] [ point_int_vw ] ) ;
									SetPlayerInterior(playerid, Point [ i ] [ point_int_int ] ) ;

									SetPlayerWeather ( playerid, 0 ) ;
									SetPlayerTime(playerid, 14, 0) ;

									PlayerTextDrawSetString ( playerid, TD_ZoneName, "San Andreas" ) ;
									PlayerTextDrawShow(playerid, TD_ZoneName ) ;

									PlayAudioStreamForPlayer(playerid, "http://play.ww-rp.net/ambient/ambient_interior.mp3");

									SetCharacterPointID(playerid,i);

									SendServerMessage ( playerid, "Evinde spawn edildin.", MSG_TYPE_INFO ) ;

									return true ;
								}

								else continue ;
							}

							else continue ;
						}

						else if ( Character [ playerid ] [ character_spawnpoint ] == 3 ) {

							if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

								if ( Point [ i ] [ point_type ] == POINT_TYPE_BIZ ) {
									//SetSpawnInfo ( playerid, -1, Character [ playerid ]  [ character_skin ], Point [ i ] [ point_int_x ], Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ], 90.0, -1, -1, -1, -1, -1, -1 ) ;
									ac_SetPlayerPos ( playerid, Point [ i ] [ point_int_x ], Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) ;

									SetPlayerVirtualWorld(playerid, Point [ i ] [ point_int_vw ] ) ;
									SetPlayerInterior(playerid, Point [ i ] [ point_int_int ] ) ;

									SetPlayerWeather ( playerid, 0 ) ;
									SetPlayerTime(playerid, 14, 0) ;

									PlayerTextDrawSetString ( playerid, TD_ZoneName, "San Andreas" ) ;
									PlayerTextDrawShow(playerid, TD_ZoneName ) ;

									PlayAudioStreamForPlayer(playerid, "http://play.ww-rp.net/ambient/ambient_interior.mp3");

									SetCharacterPointID(playerid,i);

									SendServerMessage ( playerid, "Ýþyerinde spawn oldun.", MSG_TYPE_INFO ) ;

									return true ;
								}

								else continue ;
							}

							else continue ;
						}
					}

					else continue ;
				}

				return true ;
			}

			case 4 : {
				new posseid = Character [ playerid ] [ character_posse ] ;

				for ( new i; i < MAX_POSSES; i ++ ) {
					if ( Posse [ i ] [ posse_id ] > 0 && Posse [ i ] [ posse_id ] == posseid ) {

						//SetSpawnInfo ( playerid, -1, Character [ playerid ]  [ character_skin ], Posse [ i ] [ posse_spawn_x ], Posse [ i ] [ posse_spawn_y ], Posse [ i ] [ posse_spawn_z ], 90.0, -1, -1, -1, -1, -1, -1 ) ;			
						ac_SetPlayerPos(playerid, Posse [ i ] [ posse_spawn_x ], Posse [ i ] [ posse_spawn_y ], Posse [ i ] [ posse_spawn_z ] ) ;

						SetPlayerInterior(playerid, Posse [ i ] [ posse_spawn_int ] ) ;
						SetPlayerVirtualWorld(playerid, Posse [ i ] [ posse_spawn_vw ] ) ;

						if ( Posse [ i ] [ posse_spawn_int ] || Posse [ i ] [ posse_spawn_vw ] ) {
							// FadeIn ( playerid ) ;
							SetPlayerWeather ( playerid, 0 ) ;
							SetPlayerTime(playerid, 14, 0) ;

							PlayerTextDrawSetString ( playerid, TD_ZoneName, "San Andreas" ) ;
							PlayerTextDrawShow(playerid, TD_ZoneName ) ;

							PlayAudioStreamForPlayer(playerid, "http://play.ww-rp.net/ambient/ambient_interior.mp3");
						}

						SetCharacterPointID(playerid,i);

						return SendServerMessage ( playerid, "Oluþum spawn'da spawn edildin.", MSG_TYPE_INFO ) ;
					}

					else continue ;
				}

				return true ;
			}

			case 5: {
				new motelspawn = Character [ playerid ] [ character_spawnmotel ] ; 

				ac_SetPlayerPos ( playerid, MotelPoints [ motelspawn ] [ motel_pos_x ], MotelPoints [ motelspawn ] [ motel_pos_y ], MotelPoints [ motelspawn ] [ motel_pos_z ] ) ;
                SendServerMessage ( playerid, sprintf("\"%s\" (%d) konumunda doðdunuz, bunu kaldýrmak için /spawn kullanýn.", MotelPoints [ motelspawn ] [ motel_name ], motelspawn), MSG_TYPE_INFO ) ;
				return true ;
			}

			case 6: {

				if ( Character [ playerid ] [ character_pos_x ] == 0 && Character [ playerid ] [ character_pos_y ] == 0 && Character [ playerid ] [ character_pos_z ] == 0 ) {

					switch ( Character [ playerid ]  [ character_town ] ) {

						case 0: { // longcreek
							
							ac_SetPlayerPos ( playerid, -1418.1863, 2641.7834, 55.3046 ) ;	
							return true ;
						}

						case 1: { // fremont
							
							ac_SetPlayerPos ( playerid, -797.6470, 1436.1898, 13.4218 ) ;
							return true ;	
						}

						default: { // longcreek
							
							ac_SetPlayerPos ( playerid, -1418.1863, 2641.7834, 55.3046 ) ;	
							return true ;
						}
					}
				}

				ac_SetPlayerPos ( playerid, Character [ playerid ] [ character_pos_x ], Character [ playerid ] [ character_pos_y ], Character [ playerid ] [ character_pos_z ] ) ;

				SetPlayerInterior ( playerid, Character [ playerid ] [ character_pos_interior ] ) ;
				SetPlayerVirtualWorld ( playerid, Character [ playerid ] [ character_pos_vw ] ) ;

				SendServerMessage ( playerid, "Son çýkýþ konumunda spawn edildin.", MSG_TYPE_INFO ) ;

				return true ;
			}
		}

	}

	return true ;
}


CMD:spawn(playerid, params [] ) {

    new query [ 256 ] ;

    if ( ! strcmp ( params, "newb" ) || ! strcmp ( params, "yenioyuncu" ) ) {

        Character [ playerid ] [ character_spawnpoint ] = 0 ;

        SendServerMessage ( playerid, "Artýk global spawn'da doðacaksýn.", MSG_TYPE_INFO ) ;

    }

    else if ( ! strcmp ( params, "town" ) || ! strcmp ( params, "kasaba" ) ) {

        Character [ playerid ] [ character_spawnpoint ] = 1 ;

        SendServerMessage ( playerid, "Artýk kendi kasabanda doðacaksýn.", MSG_TYPE_INFO ) ;
    }

    else if ( ! strcmp ( params, "house" ) || ! strcmp ( params, "ev" ) ) {

        new count = 0;

        for ( new i; i < MAX_POINTS; i ++ ) {

            if ( Point [ i ] [ point_id ] != -1 ) {

                if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {

                    if ( Point [ i ] [ point_type ] == POINT_TYPE_HOUSE ) {

                        Character [ playerid ] [ character_spawnpoint ] = 2 ;
                        SendServerMessage ( playerid, "Artýk evinde spawn olacaksýn.", MSG_TYPE_INFO ) ;
                        count ++ ;
                    }

                    else continue ;
                }

                else continue ;
            }

            else continue ;
        }

        if ( ! count ) {

            return SendServerMessage ( playerid, "Evde spawn olmak için evin yok.", MSG_TYPE_ERROR ) ;
        }
    }

    else if ( ! strcmp ( params, "biz" ) || ! strcmp ( params, "isyeri" ) ) {

        new count = 0;

        for ( new i; i < MAX_POINTS; i ++ ) {

            if ( Point [ i ] [ point_id ] != -1 ) {

                if ( Point [ i ] [ point_owner ] == Character [ playerid ] [ character_id ] ) {
                    
                    if ( Point [ i ] [ point_type ] == POINT_TYPE_BIZ ) {
                        
                        Character [ playerid ] [ character_spawnpoint ] = 3 ;
                        SendServerMessage ( playerid, "Artýk iþyerinde spawn olacaksýn.", MSG_TYPE_INFO ) ;
                        count ++ ;
                    }

                    else continue ;
                }

                else continue ;
            }

            else continue ;
        }

        if ( ! count ) {

            return SendServerMessage ( playerid, "Ýþyerinde spawn olmak için iþyerin yok.", MSG_TYPE_ERROR ) ;
        }
    }

    else if ( ! strcmp ( params, "faction" ) || ! strcmp ( params, "birlik" ) ) {

        for ( new i; i < MAX_POSSES; i ++ ) {

            if ( Posse [ i ] [ posse_id] != -1 ) {

                if ( Posse [ i ] [ posse_spawn_x ] == 0 || Posse [ i ] [ posse_spawn_z ] == 0 || Posse [ i ] [ posse_spawn_z ] == 0 ) {

                    return SendServerMessage ( playerid, "Birliðiniz için ayarlanmýþ bir birlik doðma noktasý yok.", MSG_TYPE_ERROR ) ;
                }

                else {
                    
                    Character [ playerid ] [ character_spawnpoint ] = 4 ;
                    SendServerMessage ( playerid, "Artýk birliðinizin doðma noktasýnda spawn olacaksýnýz.", MSG_TYPE_INFO ) ;
                    break;
                }
            }
        }
    }

    else if ( ! strcmp ( params, "location" ) || ! strcmp ( params, "konum" ) ) {

        Character [ playerid ] [ character_spawnpoint ] = 6 ;
        SendServerMessage ( playerid, "Artýk en son çýkýþ yaptýðýnýz konumda spawn olacaksýnýz.", MSG_TYPE_INFO ) ;
    }

    else return SendServerMessage ( playerid, "KULLANIM: /spawn [newb/yenioyuncu, town/kasaba, house/ev, biz/isyeri, faction/birlik, location/konum]", MSG_TYPE_ERROR ) ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_spawnpoint = %d WHERE character_id = %d", Character [ playerid ] [ character_spawnpoint ], Character [ playerid ] [ character_id ] ) ;
    mysql_tquery ( mysql, query ) ;

    return true ;
}
enum PointData {
	point_id,
	point_name [ 32 ],

	point_owner ,
	point_price,
	point_biztype ,

	point_type,
	point_fee,
	point_rentable,
	point_rent_price,
	point_rent_change,

	point_till,
	point_till_change,
	WEAPON: point_weapon1,
	point_weapon1ammo,
	WEAPON: point_weapon2,
	point_weapon2ammo,


	point_locked,

	Float: point_ext_x,
	Float: point_ext_y,
	Float: point_ext_z,

	point_vw,
	point_int,

	Float: point_int_x,
	Float: point_int_y,
	Float: point_int_z,

	point_int_vw,
	point_int_int,

	point_pickup,
	point_mapicon,
	DynamicText3D: point_3dtext
} ;

#define 	MAX_POINTS		( 250 )
new Point [ MAX_POINTS ] [ PointData ] ;

enum {
	POINT_TYPE_PASS,
	POINT_TYPE_HOUSE,
	POINT_TYPE_BIZ
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CreatePoint ( playerid, type, Float: ext_x, Float: ext_y, Float: ext_z ) {

    new slot = FindEmptyPointSlot () + 1, name [ 32 ] ;

    new query [ 512 ] ;

    mysql_format ( mysql, query, sizeof ( query ), 
        "INSERT INTO points (point_name, point_type, point_ext_x, point_ext_y, point_ext_z, point_vw, point_int, point_price, point_int_x, point_int_y, point_int_z, point_int_vw, point_int_int) VALUES ('%s', %d, '%f', '%f', '%f', %d, %d, '500', '1142.8990', '-1810.0664', '33.2668', %d, '0')",
        name, type, ext_x, ext_y, ext_z, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ), slot ) ;

    mysql_tquery ( mysql, query ) ;

    SendModeratorWarning ( sprintf("[YETKÝLÝ] %s (%d) adlý oyuncu, %d ID'li ve %d tipinde bir nokta oluþturdu.", ReturnUserName ( playerid, true, false ), playerid, slot, type ), MOD_WARNING_LOW ) ;
    WriteLog ( playerid, "mod/points", sprintf("%s (%d) adlý oyuncu, %d ID'li ve %d tipinde bir nokta oluþturdu.", ReturnUserName ( playerid, true, false ), playerid, slot, type )) ;

    Init_Points ( ) ;

    return true ;
}

FindEmptyPointSlot() {

	new i = 0;

	while ( i < sizeof ( Point ) && Point [ i ] [ point_id ] != -1 ) {
		i++;
	}

	if ( i == sizeof (Point ) ) return -1;

	return i;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Init_Points ( id = -1 ) {

	if ( id == -1 ) {

		for ( new i ; i < MAX_POINTS; i ++ ) {
			
			Point [ i ] [ point_id ] = -1 ;

			if ( IsValidDynamic3DTextLabel( Point [ i ] [ point_3dtext ] ) ) {

				DestroyDynamic3DTextLabel( Point [ i ] [ point_3dtext ] ) ;
			}

			if ( IsValidDynamicPickup( Point [ i ] [ point_pickup ] ) ) {

				DestroyDynamicPickup( Point [ i ] [ point_pickup ] ) ;
			}

			if ( IsValidDynamicMapIcon ( i ) ) {

				DestroyDynamicMapIcon ( Point [ i ] [ point_mapicon ] ) ;
			}
		}

		return mysql_tquery ( mysql, "SELECT * FROM points", "LoadPoints" ) ;	
	}

	else {

		new pid = -1 ;

		for ( new i ; i < MAX_POINTS; i ++ ) {

			if ( Point [ i ] [ point_id ] == id ) {

				pid = i ;
				break ;
			}
		}

		if ( pid == -1 ) { return false ; }

		else {

			new query [ 128 ] ;

			Point [ pid ] [ point_id ] = -1 ;

			if ( IsValidDynamic3DTextLabel( Point [ pid ] [ point_3dtext ] ) ) {

				DestroyDynamic3DTextLabel( Point [ pid ] [ point_3dtext ] ) ;
			}

			if ( IsValidDynamicPickup( Point [ pid ] [ point_pickup ] ) ) {

				DestroyDynamicPickup( Point [ pid ] [ point_pickup ] ) ;
			}

			if ( IsValidDynamicMapIcon ( pid ) ) {

				DestroyDynamicMapIcon ( Point [ pid ] [ point_mapicon ] ) ;
			}

			mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM points WHERE point_id = %d", id ) ;
			return mysql_tquery ( mysql, query, "LoadSinglePoint", "dd", id, pid ) ;
		}
	}
} 
forward LoadPoints ( ) ;
public LoadPoints ( ) {

    new rows ;
    cache_get_row_count ( rows ) ;

    if ( rows ) {

        print("\n * [PROPERTY] Mülk verileri yükleniyor...") ;

        for ( new i; i < rows; i ++ ) {

            cache_get_value_name_int(i, "point_id",           Point [ i ] [ point_id ] ) ;
            cache_get_value_name_int(i, "point_type",         Point [ i ] [ point_type ] ) ;
            cache_get_value_name_int(i, "point_fee",          Point [ i ] [ point_fee] ) ;
            cache_get_value_name_int(i, "point_rentable",     Point [ i ] [ point_rentable ]);
            cache_get_value_name_int(i, "point_rent_price",   Point [ i ] [ point_rent_price ]);
            cache_get_value_name_int(i, "point_rent_change",  Point [ i ] [ point_rent_change ]);
            cache_get_value_name_int(i, "point_till",         Point [ i ] [ point_till] ) ;
            cache_get_value_name_int(i, "point_till_change",  Point [ i ] [ point_till_change]);
            cache_get_value_name_int(i, "point_locked",       Point [ i ] [ point_locked] ) ;


            cache_get_value_name_int(i, "point_weapon1",      Point [ i ] [ point_weapon1] ) ;
            cache_get_value_name_int(i, "point_weapon1ammo",  Point [ i ] [ point_weapon1ammo] ) ;
            cache_get_value_name_int(i, "point_weapon2",      Point [ i ] [ point_weapon2] ) ;
            cache_get_value_name_int(i, "point_weapon2ammo",  Point [ i ] [ point_weapon2ammo] ) ;

            cache_get_value_name ( i, "point_name",           Point [ i ] [ point_name ], 32 ) ;

            cache_get_value_name_int (i, "point_owner",       Point [ i ] [ point_owner ] ) ;
            cache_get_value_name_int (i, "point_price",       Point [ i ] [ point_price ] ) ;
            cache_get_value_name_int (i, "point_biztype",     Point [ i ] [ point_biztype ] ) ;

            cache_get_value_name_float (i, "point_ext_x",     Point [ i ] [ point_ext_x ] ) ;
            cache_get_value_name_float (i, "point_ext_y",     Point [ i ] [ point_ext_y ] ) ;
            cache_get_value_name_float (i, "point_ext_z",     Point [ i ] [ point_ext_z ] ) ;


            cache_get_value_name_int(i, "point_vw",           Point [ i ] [ point_vw] ) ;
            cache_get_value_name_int(i, "point_int",          Point [ i ] [ point_int] ) ;


            cache_get_value_name_float (i, "point_int_x",     Point [ i ] [ point_int_x ] ) ;
            cache_get_value_name_float (i, "point_int_y",     Point [ i ] [ point_int_y ] ) ;
            cache_get_value_name_float (i, "point_int_z",     Point [ i ] [ point_int_z ] ) ;


            cache_get_value_name_int(i, "point_int_vw",       Point [ i ] [ point_int_vw] ) ;
            cache_get_value_name_int(i, "point_int_int",      Point [ i ] [ point_int_int] ) ;

            switch ( Point [ i ] [ point_type ] ) {

                case POINT_TYPE_HOUSE: {

                    if ( Point [ i ] [ point_owner ] != -1 ) {

                        if( ! Point [ i ] [ point_rentable ] ) {

                            Point [ i ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s", i, Point [ i ] [ point_name ]), COLOR_DEFAULT, 
                                Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 
                                25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;
                        }
                        else {

                            Point [ i ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nKira Bedeli: $%02d.%02d", i, Point [ i ] [ point_name ],Point[i][point_rent_price],Point[i][point_rent_change]), COLOR_DEFAULT, 
                                Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 
                                25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;
                        }
                    }

                    else if ( Point [ i ] [ point_owner ] == -1 ) {
                        Point [ i ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nSatýlýk: $%s", i, Point [ i ] [ point_name ], IntegerWithDelimiter ( Point [ i ] [ point_price ] ) ), COLOR_DEFAULT, 
                            Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 
                            25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;
                    }

                    Point [ i ] [ point_pickup ] = CreateDynamicPickup ( 1272, 1, 
                        Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;
                }

                case POINT_TYPE_BIZ: {
                    if ( Point [ i ] [ point_owner ] != -1 ) {
                        Point [ i ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nGiriþ Ücreti: $0.%d", i, Point [ i ] [ point_name ], Point [ i ] [ point_fee ] ), COLOR_DEFAULT, 
                            Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 
                            25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;
                    }

                    else if ( Point [ i ] [ point_owner ] == -1 ) {
                        Point [ i ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nSatýlýk: $%s", i, Point [ i ] [ point_name ], IntegerWithDelimiter ( Point [ i ] [ point_price ] ) ), COLOR_DEFAULT, 
                            Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 
                            25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;
                    }

                    Point [ i ] [ point_pickup ] = CreateDynamicPickup ( 1274, 1, 
                        Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;

                    Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 56, -1 ) ;
                }

                default: {
                    Point [ i ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nGirmek için ~k~~GROUP_CONTROL_BWD~ tuþuna bas", i, Point [ i ] [ point_name ]), COLOR_DEFAULT, 
                        Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 
                        25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ i ] [ point_vw], Point [ i ] [ point_int], -1 ) ;

                    Point [ i ] [ point_pickup ] = CreateDynamicPickup ( 1239, 1, 
                        Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], Point [ i ] [ point_vw], Point [ i ] [ point_int], 0x0997DEFF ) ;
                }              
            }
        }

        printf(" * [PROPERTY] %d adet mülk yüklendi\n", rows ) ;
    }

    return true ;
}

forward LoadSinglePoint ( id, enumid ) ;
public LoadSinglePoint ( id, enumid ) {

	new rows ;
	cache_get_row_count ( rows ) ;

	if ( rows ) {

		print("\n * [PROPERTY] Loading property parse data...") ;

		cache_get_value_name_int(0, "point_id",				Point [ enumid ] [ point_id ] ) ;
		cache_get_value_name_int(0, "point_type",			Point [ enumid ] [ point_type ] ) ;
		cache_get_value_name_int(0, "point_fee",			Point [ enumid ] [ point_fee] ) ;
		cache_get_value_name_int(0, "point_rentable",		Point [ enumid ] [ point_rentable ]);
		cache_get_value_name_int(0, "point_rent_price",		Point [ enumid ] [ point_rent_price ]);
		cache_get_value_name_int(0, "point_rent_change",	Point [ enumid ] [ point_rent_change ]);
		cache_get_value_name_int(0, "point_till",			Point [ enumid ] [ point_till] ) ;
		cache_get_value_name_int(0, "point_till_change",	Point [ enumid ] [ point_till_change ]);
		cache_get_value_name_int(0, "point_locked",			Point [ enumid ] [ point_locked] ) ;


		cache_get_value_name_int(0, "point_weapon1",		Point [ enumid ] [ point_weapon1] ) ;
		cache_get_value_name_int(0, "point_weapon1ammo",	Point [ enumid ] [ point_weapon1ammo] ) ;
		cache_get_value_name_int(0, "point_weapon2",		Point [ enumid ] [ point_weapon2] ) ;
		cache_get_value_name_int(0, "point_weapon2ammo",	Point [ enumid ] [ point_weapon2ammo] ) ;

		cache_get_value_name ( 0, "point_name",				Point [ enumid ] [ point_name ], 32 ) ;

		cache_get_value_name_int (0, "point_owner",			Point [ enumid ] [ point_owner ] ) ;
		cache_get_value_name_int (0, "point_price",			Point [ enumid ] [ point_price ] ) ;
		cache_get_value_name_int (0, "point_biztype",		Point [ enumid ] [ point_biztype ] ) ;

		cache_get_value_name_float (0, "point_ext_x",		Point [ enumid ] [ point_ext_x ] ) ;
		cache_get_value_name_float (0, "point_ext_y",		Point [ enumid ] [ point_ext_y ] ) ;
		cache_get_value_name_float (0, "point_ext_z",		Point [ enumid ] [ point_ext_z ] ) ;


		cache_get_value_name_int(0, "point_vw",				Point [ enumid ] [ point_vw] ) ;
		cache_get_value_name_int(0, "point_int",			Point [ enumid ] [ point_int] ) ;


		cache_get_value_name_float (0, "point_int_x",		Point [ enumid ] [ point_int_x ] ) ;
		cache_get_value_name_float (0, "point_int_y",		Point [ enumid ] [ point_int_y ] ) ;
		cache_get_value_name_float (0, "point_int_z",		Point [ enumid ] [ point_int_z ] ) ;


		cache_get_value_name_int(0, "point_int_vw",			Point [ enumid ] [ point_int_vw] ) ;
		cache_get_value_name_int(0, "point_int_int",		Point [ enumid ] [ point_int_int] ) ;

         switch ( Point [ enumid ] [ point_type ] ) {

            case POINT_TYPE_HOUSE: {

                if ( Point [ enumid ] [ point_owner ] != -1 ) {

                    if( ! Point [ enumid ] [ point_rentable ] ) {

                        Point [ enumid ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s", enumid, Point [ enumid ] [ point_name ]), COLOR_DEFAULT, 
                            Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 
                            25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;
                    }
                    else {

                        Point [ enumid ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nKira Ucreti: $%02d.%02d", enumid, Point [ enumid ] [ point_name ],Point[enumid][point_rent_price],Point[enumid][point_rent_change]), COLOR_DEFAULT, 
                            Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 
                            25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;
                    }
                }

                else if ( Point [ enumid ] [ point_owner ] == -1 ) {
                    Point [ enumid ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nSatilik: $%s", enumid, Point [ enumid ] [ point_name ], IntegerWithDelimiter ( Point [ enumid ] [ point_price ] ) ), COLOR_DEFAULT, 
                        Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 
                        25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;
                }

                Point [ enumid ] [ point_pickup ] = CreateDynamicPickup ( 1272, 1, 
                    Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;
            }

            case POINT_TYPE_BIZ: {
                if ( Point [ enumid ] [ point_owner ] != -1 ) {
                    Point [ enumid ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nGiris Ucreti: $0.%d", enumid, Point [ enumid ] [ point_name ], Point [ enumid ] [ point_fee ] ), COLOR_DEFAULT, 
                        Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 
                        25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;
                }

                else if ( Point [ enumid ] [ point_owner ] == -1 ) {
                    Point [ enumid ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nSatilik: $%s", enumid, Point [ enumid ] [ point_name ], IntegerWithDelimiter ( Point [ enumid ] [ point_price ] ) ), COLOR_DEFAULT, 
                        Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 
                        25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;
                }

                Point [ enumid ] [ point_pickup ] = CreateDynamicPickup ( 1274, 1, 
                    Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;

                Point [ enumid ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 56, -1 ) ;
            }

            default: {
                Point [ enumid ] [ point_3dtext ] = CreateDynamic3DTextLabel(sprintf("(%d) %s\nGirmek icin ~k~~GROUP_CONTROL_BWD~ tusuna bas", enumid, Point [ enumid ] [ point_name ]), COLOR_DEFAULT, 
                    Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], 
                    25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], -1 ) ;

                Point [ enumid ] [ point_pickup ] = CreateDynamicPickup ( 1239, 1, 
                    Point [ enumid ] [ point_ext_x ], Point [ enumid ] [ point_ext_y ], Point [ enumid ] [ point_ext_z ], Point [ enumid ] [ point_vw], Point [ enumid ] [ point_int], 0x0997DEFF ) ;
            }              
        }

        printf(" * [PROPERTY] %d numarali emlak yuklendi.", enumid ) ;
    }

    return true ;
}

// SetupMapIconForProp ( pointid) {
// 	new i = pointid ;

// 	switch ( Point [ i ] [ point_biztype ] ) {

// 		case POINT_TYPE_GEN_STORE: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 17, -1 ) ;
// 		}

// 		case POINT_TYPE_GUN_STORE: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 6, -1 ) ;
// 		}

// 		case POINT_TYPE_CLOTHING: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 45, -1 ) ;
// 		}

// 		case POINT_TYPE_BARBER: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 7, -1 ) ;
// 		}

// 		case POINT_TYPE_LIQUOR: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 49, -1 ) ;
// 		}

// 		case POINT_TYPE_SALOON: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 25, -1 ) ;
// 		}

// 		case POINT_TYPE_HUNTING: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 3, -1 ) ;
// 		}

// 		case POINT_TYPE_BANK: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 52, -1 ) ;
// 		}

// 		case POINT_TYPE_POSTAL: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 19, -1 ) ;
// 		}

// 		case POINT_TYPE_SHERIFF: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 30, -1 ) ;
// 		}

// 		case POINT_TYPE_BLACKSMITH: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 27, -1 ) ;
// 		}

// 		case POINT_TYPE_STABLEMASTER: {

// 			Point [ i ] [ point_mapicon ]  = CreateDynamicMapIcon ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ], Point [ i ] [ point_ext_z ], 38, -1 ) ;
// 		}

// 	}



// }

GetPointIDFromType ( playerid, type ) {

	for ( new i = 0; i < sizeof ( Point ); i++ ) {

		if ( Point [ i ] [ point_biztype ] == type ) {

			if ( Point [ i ] [ point_int_int ] == GetPlayerInterior ( playerid )  &&  Point [ i ] [ point_int_vw ] == GetPlayerVirtualWorld ( playerid ) ) {

				return i ;
			}
			else continue ;
		}
		else continue ;
	}
	return -1 ;
}
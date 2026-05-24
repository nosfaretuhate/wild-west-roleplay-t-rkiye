/*

*/

#include <YSI_Coding\y_timers>
//#include "data/farm/baskets.pwn"


public OnGameModeInit() {

	#if defined farm_OnGameModeInit
		return farm_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit farm_OnGameModeInit
#if defined farm_OnGameModeInit
	forward farm_OnGameModeInit();
#endif


enum SoilData {

	soil_id,

	soil_owner,
	soil_plant,

	Float: soil_x,
	Float: soil_y,
	Float: soil_z,

	Float: soil_rotx,
	Float: soil_roty,
	Float: soil_rotz,


	soil_water,
	soil_health,
	soil_state,

	soil_obj,
	DynamicText3D: soil_info,

	bool: finished_growing,
	s_ticks, 

	bool: fix,


} ;

#define MAX_SOILS	( 1024 )
#define INVALID_SOIL_ID 	(-1)
new Soil [ MAX_SOILS ] [ SoilData ] ; 


enum { // soil states

	SOIL_STATE_EMPTY,
	SOIL_STATE_DIGGED,
	SOIL_STATE_SEEDED,
	SOIL_STATE_GROWING,
	SOIL_STATE_GROWN
} ;

enum { // health states

	SOIL_HEALTH_DEAD,
	SOIL_HEALTH_DISEASED,
	SOIL_HEALTH_THIRSTY,
	SOIL_HEALTH_HEALTHY
} ;

enum { // water states

	SOIL_WATER_DEHYDRATED,
	SOIL_WATER_MODERATE,
	SOIL_WATER_WATERED

} ;


enum { //plants
	PLANT_ORANGE,
	PLANT_APPLE_RED,
	PLANT_APPLE_GREEN,
	PLANT_PUMPKIN,
	PLANT_WHEAT,
	PLANT_TOMATO,
	PLANT_CABBAGE
}
CreateSoil ( playerid ) {

    if ( GetPlayerInterior ( playerid ) || GetPlayerVirtualWorld ( playerid ) ) {

        return SendServerMessage ( playerid, "Sadece dýþ mekanlarda toprak ekimi yapabilirsiniz!", MSG_TYPE_ERROR ) ;
    }

    if(IsPlayerRidingHorse[playerid]){
        return SendServerMessage(playerid, "Ata binerken toprak ekimi yapamazsýnýz!", MSG_TYPE_INFO);
    }

    new s_id = GetFreeSoilID ( ) ;

    if ( s_id == -1 ) {

        return SendServerMessage ( playerid, "Toprak oluþturulurken bir hata oluþtu. Lütfen bir yetkiliyle iletiþime geçin (fonksiyon -1 döndürdü: muhtemelen sýnýr aþýmý)", MSG_TYPE_ERROR ) ;
    }


    new Float: x, Float: y, Float: z ;
    GetPlayerPos ( playerid, x, y, z ) ;

    new Float: rayX, Float: rayY, Float: rayZ, 
    Float: rayRX, Float: rayRY, Float: rayRZ;

    CA_RayCastLineAngle(x, y, z, x, y, z-5, rayX, rayY, rayZ, rayRX, rayRY, rayRZ);

    x = rayX, y = rayY, z = rayZ;

    new query [ 256 ] ;

    mysql_format ( mysql, query, sizeof ( query ), 
        "INSERT INTO soildata (soil_owner, soil_plant, soil_x, soil_y, soil_z, soil_rotx, soil_roty, soil_rotz, soil_state, soil_water, soil_health) VALUES (%d, -1, %f, %f, %f, %f, %f, %f, 0, 0, 0 )",
        Character [ playerid ] [ character_id ], x, y, z, rayRX, rayRY, rayRZ 
    );
    
    Soil[s_id][s_ticks] = 0;

    mysql_tquery ( mysql, query ) ;

    Init_SoilData () ;

    SendServerMessage(playerid, "Topraðý kazarak tarýma uygun hale getirdiniz. Artýk bir delik açýp içine tohum ekebilirsiniz!", MSG_TYPE_INFO);

    return true ;
}

Init_SoilData () {

	for ( new i; i < MAX_SOILS; i ++ ) {

		if ( IsValidDynamicObject(  Soil [ i ] [ soil_obj ] ) ) {
			DestroyDynamicObject( Soil [ i ] [ soil_obj ] ) ;
		}


		if ( IsValidDynamic3DTextLabel(  Soil [ i ] [ soil_info ] ) ) {
			DestroyDynamic3DTextLabel( Soil [ i ] [ soil_info ]  ) ;
		}

		Soil [ i ] [ soil_id ] = -1 ;
	}

	mysql_tquery ( mysql, "SELECT * FROM soildata", "LoadSoilData", "" ) ;

	return true ;
}

forward LoadSoilData () ;
public LoadSoilData () {

	new rows, count ;

	cache_get_row_count ( rows ) ;

    if ( rows ) {

		for ( new i, j = rows; i < j; i ++ ) {

			cache_get_value_int ( i, "soil_id",		Soil [ i ] [ soil_id ] ) ;

			cache_get_value_int ( i, "soil_owner",	Soil [ i ] [ soil_owner ] ) ;
			cache_get_value_int ( i, "soil_plant",	Soil [ i ] [ soil_plant ] ) ;

			cache_get_value_float ( i, "soil_x",	Soil [ i ] [ soil_x ] ) ;
			cache_get_value_float ( i, "soil_y",	Soil [ i ] [ soil_y ] ) ;
			cache_get_value_float ( i, "soil_z",	Soil [ i ] [ soil_z ] ) ;

			cache_get_value_float ( i, "soil_rotx",	Soil [ i ] [ soil_rotx ] ) ;
			cache_get_value_float ( i, "soil_roty",	Soil [ i ] [ soil_roty ] ) ;
			cache_get_value_float ( i, "soil_rotz",	Soil [ i ] [ soil_rotz ] ) ;

			cache_get_value_int ( i, "soil_state",	Soil [ i ] [ soil_state ] ) ;
			cache_get_value_int ( i, "soil_water",	Soil [ i ] [ soil_water ] ) ;
			cache_get_value_int ( i, "soil_health",	Soil [ i ] [ soil_health ] );

			cache_get_value_int ( i, "s_ticks",		Soil [ i ] [ s_ticks ] );

			SetupSoil ( i ) ;

			if ( Soil[i][soil_state] == SOIL_STATE_GROWING ){
				StartGrowingProcess(i);
			}

			++ count ;

			continue ;
		}
	}

	printf("* [toprak] %d adet toprak yuklendi", count ) ;


	return true ;
}

SetupSoil ( s_id ) {

	if(Soil[s_id][fix]){
		
		Soil [ s_id ] [ soil_z ] += 1;
		Soil[s_id][fix] = false;
	}

	Soil [ s_id ] [ soil_obj ] = CreateDynamicObject(854, 
		Soil [ s_id ] [ soil_x ], Soil [ s_id ] [ soil_y ], Soil [ s_id ] [ soil_z ], 
		0.0, 0.0, random ( 90 ) ) ;

	SetDynamicObjectMaterial(Soil [ s_id ] [ soil_obj ], 0, 16093, "a51_ext", "des_dirt1", 0xFFFFFFFF);

	DestroyDynamic3DTextLabel(Soil[s_id][soil_info]);
	DestroyDynamicObject(Soil[s_id][soil_obj]);

	new info [ 256 ], water [ 32 ], health [ 64 ], sstate [ 32 ], plant [ 32 ];

	new Float: customValueZ;

switch ( Soil [ s_id ] [ soil_water ] ) {

        case SOIL_WATER_DEHYDRATED:    water = "{968354}Kuru{DEDEDE}" ;
        case SOIL_WATER_MODERATE:      water = "{8ED1CE}Orta{DEDEDE}" ;
        case SOIL_WATER_WATERED:        water = "{5EABCC}Sulanmis{DEDEDE}" ;
    }

    switch ( Soil [ s_id ] [ soil_health ] ) {

        case SOIL_HEALTH_DEAD:          health = "{363636}Bu bitki olu!{DEDEDE}";
        case SOIL_HEALTH_DISEASED:      health = "{807455}Hastalikli{DEDEDE}" ;
        case SOIL_HEALTH_THIRSTY:       health = "{968354}Susuz{DEDEDE}" ;
        case SOIL_HEALTH_HEALTHY:       health = "{45963B}Saglikli{DEDEDE}" ;
    }

    switch(Soil [s_id ] [ soil_plant ]){

        case PLANT_ORANGE: { 
            plant = "{F2921B}Portakal{DEDEDE}"; 
            //obj = FARMING_APPLEPLOT;

            //customValueZ = 1.2;
            //Soil[s_id][soil_z] = Soil[s_id][soil_z] + customValueZ;
        }       
        case PLANT_APPLE_RED: { 
            plant = "{F6625A}Kirmizi Elma{DEDEDE}"; 
            //obj = FARMING_APPLEPLOT;

            //customValueZ = 1.2;
            //Soil[s_id][soil_z] = Soil[s_id][soil_z] + customValueZ;
        }      
        case PLANT_APPLE_GREEN: { 
            plant = "{3DF678}Yesil Elma{DEDEDE}"; 
            //obj = FARMING_APPLEPLOT; 

            //customValueZ = 1.2;
            //Soil[s_id][soil_z] = Soil[s_id][soil_z] + customValueZ;
        }  

        case PLANT_PUMPKIN: { 
            plant = "{F2921B}Bal Kabagi{DEDEDE}"; 
            //obj = FARMING_PUMPKINPLOT;

            //customValueZ = 0.2;
            Soil[s_id][soil_z] = Soil[s_id][soil_z] - customValueZ; 
        }

        case PLANT_TOMATO: { 
            plant = "{F6625A}Domates{DEDEDE}"; 
            //obj = FARMING_TOMATOPLOT; 
        }

        case PLANT_CABBAGE: { 
            plant = "{3DF678}Lahana{DEDEDE}"; 
            //obj = FARMING_CABBAGEPLOT; 
        }

        case PLANT_WHEAT: { 
            plant = "{968354}Bugday{DEDEDE}"; 
            //obj = FARMING_WHEATPLOT; 
        }

    }

switch ( Soil [ s_id ] [ soil_state ] ) {

        case SOIL_STATE_EMPTY: {
            sstate = "{C95353}Bos{DEDEDE}" ;

            Soil [ s_id ] [ soil_obj ] = CreateDynamicObject(854, 
            Soil [ s_id ] [ soil_x ], Soil [ s_id ] [ soil_y ], Soil [ s_id ] [ soil_z ], 
            0.0, 0.0, random ( 90 ) ) ;

            SetDynamicObjectMaterial(Soil [ s_id ] [ soil_obj ], 0, 16093, "a51_ext", "des_dirt1", 0xFFFFFFFF);

            format ( info, sizeof ( info ), 
                "[Tarim Topragi]{DEDEDE}\n\nToprak Durumu: %s\n\nBir delik acmak icin kureginizi kullanin.",
                sstate 
            ) ;
        }

        case SOIL_STATE_DIGGED: {

            sstate = "{59C953}Kazilmis{DEDEDE}" ;

            Soil [ s_id ] [ soil_obj ] = CreateDynamicObject(854, 
            Soil [ s_id ] [ soil_x ], Soil [ s_id ] [ soil_y ], Soil [ s_id ] [ soil_z ], 
            0.0, 0.0, random ( 90 ) ) ;

            SetDynamicObjectMaterial(Soil [ s_id ] [ soil_obj ], 0, 16093, "a51_ext", "des_dirt1", 0xFFFFFFFF);

            format ( info, sizeof ( info ), 
                "[Tarim Topragi]{DEDEDE}\n\nToprak Durumu: %s\n\nBir tohum ekin!",
                sstate 
            ) ;
        }

        case SOIL_STATE_SEEDED: {

            sstate = "{59C953}Tohumlanmis{DEDEDE}" ;

            Soil [ s_id ] [ soil_obj ] = CreateDynamicObject(854, 
            Soil [ s_id ] [ soil_x ], Soil [ s_id ] [ soil_y ], Soil [ s_id ] [ soil_z ], 
            0.0, 0.0, random ( 90 ) ) ;

            SetDynamicObjectMaterial(Soil [ s_id ] [ soil_obj ], 0, 16093, "a51_ext", "des_dirt1", 0xFFFFFFFF);

            format ( info, sizeof ( info ), 
                "[Tarim Topragi]{DEDEDE}\n\nToprak Durumu: %s\n\nBitki: %s\n\nBuyumeyi baslatmak icin deligi kapatin!",
                sstate, plant 
            ) ;
        }

        case SOIL_STATE_GROWING: {

            sstate = "{59C953}Buyuyor{DEDEDE}" ;

            Soil [ s_id ] [ soil_obj ] = CreateDynamicObject(854, 
            Soil [ s_id ] [ soil_x ], Soil [ s_id ] [ soil_y ], Soil [ s_id ] [ soil_z ], 
            0.0, 0.0, random ( 90 ) ) ;

            SetDynamicObjectMaterial(Soil [ s_id ] [ soil_obj ], 0, 16093, "a51_ext", "des_dirt1", 0xFFFFFFFF);

            if(Soil[s_id][soil_health] == SOIL_HEALTH_DEAD){
                format ( info, sizeof ( info ), "[Tarim Topragi]{DEDEDE}\n\nSaglik: %s", health) ;
            } else {
                format ( info, sizeof ( info ), 
                "[Tarim Topragi]{DEDEDE}\n\nToprak Durumu: %s\n\nBitki: %s\n\nSaglik: %s\n\nSu: %s",
                sstate, plant, health, water 
                ) ;
            }
        }

        case SOIL_STATE_GROWN: {

            sstate = "{59C953}Buyumus{DEDEDE}" ;

            Soil [ s_id ] [ soil_obj ] = CreateDynamicObject(854, 
            Soil [ s_id ] [ soil_x ], Soil [ s_id ] [ soil_y ], Soil [ s_id ] [ soil_z ], 
            0.0, 0.0, random ( 90 ) ) ;

            SetDynamicObjectMaterial(Soil [ s_id ] [ soil_obj ], 0, 16093, "a51_ext", "des_dirt1", 0xFFFFFFFF);

            format ( info, sizeof ( info ), "[Tarim Topragi]{DEDEDE}\n\nToprak Durumu: %s\n\nBu bitki toplanmaya hazir.", sstate) ;
        }
    }

    new query[256];
    format(query, sizeof(query), "UPDATE soildata SET soil_state = '%i', soil_plant = '%i', soil_water = '%i', soil_health = '%i' WHERE soil_id = '%i'", Soil[s_id][soil_state], Soil[s_id][soil_plant], Soil[s_id][soil_water], Soil[s_id][soil_health], Soil[s_id][soil_id]);

    mysql_tquery(mysql, query);

    Soil [ s_id ] [ soil_info ] = CreateDynamic3DTextLabel(info, 0xA9C248FF, Soil[s_id][soil_x], Soil[s_id][soil_y], Soil[s_id][soil_z], 7.0 ) ;

    return true ;
}

GetFreeSoilID ( ) {

	for ( new i; i < MAX_SOILS; i ++ ) {

		if ( Soil [ i ] [ soil_id ] == -1 ) {

			return i ;
		}

		else continue ;
	}

	return -1 ;
}

StartGrowingProcess(s_id){

	if(!Soil[s_id][finished_growing]){

		Soil[s_id][soil_water] = SOIL_WATER_MODERATE;
		Soil[s_id][soil_health] = SOIL_HEALTH_THIRSTY;

		SetupSoil(s_id);
		
		SetTimerEx("ChangePlantStatus", 600000, false, "i", s_id);
	} 
	else {
		return true;
	}

	return true;
}

new firstTick[MAX_SOILS] = false;

forward ChangePlantStatus(s_id);
public ChangePlantStatus(s_id) {

	if(s_id == INVALID_SOIL_ID)
		return true;

	if(Soil[s_id][soil_health] == SOIL_HEALTH_DEAD){

		SetTimerEx("PlantDeadCooldown", 180000, false, "i", s_id);
		return true;
	}

	if(Soil[s_id][finished_growing])
		return true;


	Soil[s_id][s_ticks]++;

    if(!Soil[s_id][finished_growing] && Soil[s_id][s_ticks] == 5){

    	Soil[s_id][soil_state] = SOIL_STATE_GROWN;
    	Soil[s_id][finished_growing] = true;

    	SetupSoil(s_id);

    	new query[256];
    	format(query, sizeof(query), "UPDATE soildata SET finished_growing = '%i' WHERE soil_id = '%i'", 1, Soil[s_id][soil_id]);
    	mysql_tquery(mysql, query);

    	return true;
    }

    if(Soil[s_id][soil_state] == SOIL_STATE_GROWING && !Soil[s_id][finished_growing]){

    	switch ( Soil [ s_id ] [ soil_water ] ) {

			case SOIL_WATER_DEHYDRATED: {
				Soil [ s_id ] [ soil_health ] = SOIL_HEALTH_DEAD;
				SetupSoil(s_id);
			}

			case SOIL_WATER_MODERATE: {
				Soil[s_id][soil_water] = SOIL_WATER_DEHYDRATED;
				Soil[s_id][soil_health] = SOIL_HEALTH_THIRSTY;
				SetupSoil(s_id);
			}	

			case SOIL_WATER_WATERED: {
				Soil[s_id][soil_water] = SOIL_WATER_MODERATE;
				Soil[s_id][soil_health] = SOIL_HEALTH_HEALTHY;
				SetupSoil(s_id);
			}
		}

		SetTimerEx("ChangePlantStatus", 600000, false, "i", s_id);
    }

    new query[256];

    mysql_format(mysql,	query, sizeof(query), "UPDATE soildata SET s_ticks = '%i' WHERE soil_id = '%i'", Soil[s_id][s_ticks], Soil[s_id][soil_id]);

    mysql_tquery(mysql, query);

    printf("[FARM] changeplantstatus executed, new tick for soil %i is %i", Soil[s_id][soil_id], Soil[s_id][s_ticks]);

    return true;
}


forward PlantDeadCooldown(s_id);
public PlantDeadCooldown(s_id){

	printf("[farm] tohum %d silindi, cunku susuz kalip oldu.", Soil[s_id][soil_id]);

	RemoveSoil(s_id);

	return true;
}

RemoveSoil(soilid){

    if(Soil[soilid][soil_id] == INVALID_SOIL_ID){
    	return printf("gecersiz tohum (%i)", Soil[soilid][soil_id]);
    }

    new query[128];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM soildata WHERE soil_id = '%i'", Soil[soilid][soil_id]);
    mysql_tquery(mysql, query);

    DestroyDynamic3DTextLabel(Soil[soilid][soil_info]);
    DestroyDynamicObject(Soil[soilid][soil_obj]);

    Soil[soilid][soil_id] = INVALID_SOIL_ID;

    printf("[toprak] tohum silindi %i.", Soil[soilid][soil_id]);

    return true;
}

DeleteAllSoils() {

    for(new i; i < MAX_SOILS; i++) {

        if(Soil[i][soil_id] != INVALID_SOIL_ID) {

            RemoveSoil(i);
        }
        else continue;
    }
    return true;
}

FindNearestSoil(playerid, Float: range = 5.0) {

    for(new i; i < MAX_SOILS; i++) {

        if(Soil[i][soil_id] != INVALID_SOIL_ID) {

            if(IsPlayerInRangeOfPoint(playerid, range, Soil[i][soil_x], Soil[i][soil_y], Soil[i][soil_z])) {

                return i;
            }
            else continue;
        }
        else continue;
    }
    return INVALID_SOIL_ID;
}
CMD:asoil(playerid, params[]) {

    if(IsPlayerModerator(playerid)) {

        new choice[12], soilid;
        if(sscanf(params, "s[12]D(-2)", choice, soilid)) {

            return SendServerMessage(playerid, "/asoil [info/remove/hepsinisil/allsoils] [toprak_id (varsayilan olarak menzildeki en yakin toprak)]", MSG_TYPE_ERROR);
        }
        if(soilid == -2) {

            soilid = FindNearestSoil(playerid, 3.0);
        }

        if(!strcmp(choice,"info",true)) {

            if(soilid == INVALID_SOIL_ID) {

                return SendServerMessage(playerid, "Gecersiz toprak ID.", MSG_TYPE_ERROR);
            }

            new acc_name[MAX_PLAYER_NAME], char_name[MAX_PLAYER_NAME];

            inline FindCharName() {

                new rows[2];

                cache_get_row_count(rows[0]);

                if(rows[0]) {

                    new acc_id;

                    cache_get_value_int(0,"account_id",acc_id);
                    cache_get_value_name(0,"character_name",char_name,MAX_PLAYER_NAME);

                    inline FindAccName() {

                        cache_get_row_count(rows[1]);

                        if(rows[1]) {

                            cache_get_value_name(0,"account_name",acc_name,MAX_PLAYER_NAME);

                            SendServerMessage(playerid, sprintf("Toprak ID: %d", Soil[soilid][soil_id]), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Toprak Bitkisi: %d", Soil[soilid][soil_plant]), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Toprak Sahibi: %s (%s)", char_name,acc_name), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Toprak Konumu: %02f, %02f, %02f", Soil[soilid][soil_x], Soil[soilid][soil_y], Soil[soilid][soil_z]), MSG_TYPE_INFO);
                        }
                    }

                    MySQL_TQueryInline(mysql,using inline FindAccName, "SELECT account_name FROM master_accounts WHERE account_id = %d",acc_id);
                }
            }
            MySQL_TQueryInline(mysql, using inline FindCharName, "SELECT account_id,character_name FROM characters WHERE character_id = %d",Soil[soilid][soil_owner]);
            return true;
        }
        else if(!strcmp(choice,"remove",true)) {
         
            if(soilid == INVALID_SOIL_ID) {
                
                return SendServerMessage(playerid, "Gecersiz toprak ID.", MSG_TYPE_ERROR);
            }

            SendServerMessage(playerid, sprintf("Toprak ID %d silindi.",Soil[soilid][soil_id]), MSG_TYPE_INFO);
            RemoveSoil(soilid);
            return true;
        }
        else if(!strcmp(choice,"removeall",true) || !strcmp(choice,"hepsinisil",true)) {

            DeleteAllSoils();
            SendServerMessage(playerid, "Tum topraklar basariyla silindi.", MSG_TYPE_INFO);
            return true;   
        }
        else if(!strcmp(choice,"allsoils",true)) {

            for(new i; i< MAX_SOILS; i++) {

                if(Soil[i][soil_id] != INVALID_SOIL_ID) {

                    new acc_name[MAX_PLAYER_NAME], char_name[MAX_PLAYER_NAME];

                    inline FindCharName() {

                        new rows[2];

                        cache_get_row_count(rows[0]);

                        if(rows[0]) {

                            new acc_id;

                            cache_get_value_int(0,"account_id",acc_id);
                            cache_get_value_name(0,"character_name",char_name,MAX_PLAYER_NAME);

                            inline FindAccName() {

                                cache_get_row_count(rows[1]);

                                if(rows[1]) {

                                    cache_get_value_name(0,"account_name",acc_name,MAX_PLAYER_NAME);

                                    SendServerMessage(playerid, sprintf("Toprak ID: %d | Sahibi: %s (%s)",Soil[i][soil_id],char_name,acc_name), MSG_TYPE_INFO);
                                }
                            }

                            MySQL_TQueryInline(mysql,using inline FindAccName, "SELECT account_name FROM master_accounts WHERE account_id = %d",acc_id);
                        }
                    }
                    MySQL_TQueryInline(mysql, using inline FindCharName, "SELECT account_id,character_name FROM characters WHERE character_id = %d",Soil[i][soil_owner]);
                }
                else continue;
            }

            return true;
        }
        else return SendServerMessage(playerid, "/asoil [info/remove/hepsinisil/allsoils] [toprak_id (varsayilan olarak menzildeki en yakin toprak)]", MSG_TYPE_ERROR);
    } else {
      SendServerMessage(playerid, "Bu komutu kullanabilmek icin moderator olmalisiniz!", MSG_TYPE_ERROR);
    }
    return true;
}

CMD:refreshsoil(playerid, params[]){

    for(new i; i < MAX_SOILS; i++){
        if(IsPlayerInRangeOfPoint(playerid, 6.0, Soil[i][soil_x], Soil[i][soil_y], Soil[i][soil_z]) && Soil[i][soil_owner] == Character[playerid][character_id]){
            
            SetupSoil(i);
            SendServerMessage(playerid, "Yanýnýzdaki topraklarý yenilediniz.", MSG_TYPE_INFO);

            return true;
        }
        else continue; 

    }

    return true;
}

CMD:fixsoil(playerid, params[]){

    for(new i; i < MAX_SOILS; i++){
        if(IsPlayerInRangeOfPoint(playerid, 6.0, Soil[i][soil_x], Soil[i][soil_y], Soil[i][soil_z]) && Soil[i][soil_owner] == Character[playerid][character_id]){

            Soil[i][fix] = true;
            SetupSoil(i);
                
            SendServerMessage(playerid, "Düzeltme uygulandý.", MSG_TYPE_INFO);

            return true;
            
        } 
        else continue;
    
    }

    return true;

}
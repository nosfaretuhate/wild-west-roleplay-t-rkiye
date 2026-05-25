
/*

Herhangi bir su kenarýnda /fish komutunu kullanabilirsin, suyun yerini tespit etmek için ColAndreas kullanýyoruz.
Suya yakýnsan, karakterin rastgele bir þekilde oltasýný suya fýrlatacaktýr.

Bu durum tamamen rastgeledir;d
oltayý suya 10 metreye da fýrlatabilirsin, 12 metreye de.

Oltayý ne kadar derine atarsan,
iyi balýk tutma þansýn o kadar artar.
Balýk oltaya vurduðunda,
bir ilerleme çubuðu dolana kadar "Y" tuþuna spam yapman gerekir.
Sonrasýnda balýk bilgilerini içeren yaban hayatý (wildlife) arayüzü açýlýr.

Balýk tutmak için öncelikle kendi oltaný üretmen ve madencilikten elde ettiðin mineralleri kullanarak onu geliþtirmen gerekiyor. Ayrýca 1-3 farklý türde yem elde etmek için tarým sistemini kullanmalýsýn. Þu an itibarýyla, yaklaþýk 150 TP (XP) kazanman gerekiyor ve seviye atladýðýnda bu miktar ikiye katlanýyor.

TP puanlarý þu þekilde hesaplanýr: uzunluk + aðýrlýk / 2. Bu sayede her zaman 5 ile 20 arasýnda TP kazanmýþ olursun.

->https://github.com/Southclaws/Line/blob/master/README.md
*/

enum FishData {
	fish_name [ 32 ] ,
	fish_model ,

	Float: fish_weigh_incr,

	fish_max_weight,
	fish_max_length,

	fish_item_id
} ;

new Fish [] [ FishData ] = {
    { "Kahverengi Alabalik", 19630, 0.5, 10, 30, FISHING_BIGFISH } ,
    { "Kopekbaligi",          1608,  5.2, 610, 4300, FISHING_SHARK } ,
    { "Somon",                1599,  3.3, 47, 150, FISHING_YELLOW} ,
    { "Sariyuzgec Orkinos",   1600,  1.2, 200, 240, FISHING_BLUE_1} ,
    { "Pasifik Morinasi",     1604,  4.6, 23, 120, FISHING_BLUE_2 } ,
    { "Kokmus bot",           11735, 0.2, 5, 10, FISHING_BOOT }
} ;
#define         MAX_Z_FISH_THRESHOLD            4.0
#define         WATER_CHECK_RADIUS              5.0

new player_DobberPoint [ MAX_PLAYERS ] ;
new FishingProgress [ MAX_PLAYERS ] ;

new player_FishCircle [ MAX_PLAYERS ] ;
new player_RopeLine [ MAX_PLAYERS ] ;

Float: ReturnFishWeight ( fishid ) {

	new length = 1 + random ( Fish [ fishid] [ fish_max_length ] ) ;
	new Float: weight = length * Fish [ fishid ] [ fish_weigh_incr ] ; 

	if ( weight > Fish [ fishid ] [ fish_max_weight ] ) {
		weight = Fish [ fishid ] [ fish_max_weight ] ;
	}

//	print("________________________\n") ;
//	printf("Fish Name: %s\nLength: %d\nWeight Increment: %0.2f\n\nTotal Weight: %0.2f\n",
//		Fish [ fishid ] [ fish_name ], length, Fish [ fishid ] [ fish_weigh_incr ], weight ) ;

	return weight ;
}

forward HandleFishingBar(playerid);
public HandleFishingBar(playerid) {

////	print("HandleFishingBar timer called (fishing/core.pwn)");

	if ( IsFishing [ playerid ] && FishingProgress [ playerid ] > 0 ) {

	 	new remove = randomEx(5, 15);

		FishingProgress [ playerid ] -= remove;

		HidePlayerProgressBar(playerid, actionGUI_bar ) ;
		SetPlayerProgressBarValue(playerid, actionGUI_bar, FishingProgress [ playerid ] );
		ShowPlayerProgressBar(playerid, actionGUI_bar ) ;

		SetTimerEx("HandleFishingBar", 500, false, "i", playerid);
	}

	return true ;
}

OnPlayerFish ( playerid ) {

	new FISHING_TICK = 1250 + random (5750 ) ;

	GameTextForPlayer(playerid, "~w~BALIK TUTULUYOR..", FISHING_TICK - 250, 4 ) ;
	SetTimerEx("FishingTick", FISHING_TICK, false, "i", playerid) ;

	return true ;
}

forward FishingTick(playerid);
public FishingTick(playerid){

////	print("FishingTick timer called (fishing/core.pwn)");

	IsFishing [ playerid ] = true ;
	TogglePlayerControllable ( playerid, true ) ;

	SetupActionGUI ( playerid, ACTION_TYPE_FISH ) ;	

	return true ;
}

OnPlayerCatchFish ( playerid, fishid, weight ) {

	// GivePlayerItemByParam ( playerid, item, param, amount, itemparam, param1, param2 ) 
	if ( GivePlayerItemByParam ( playerid, PARAM_FISHING, Fish [ fishid ] [ fish_item_id ], 1, weight, 0, 0 ) ) {

		/*if ( TutorialProgress [ playerid ] == 4 ) {

			if ( Fish [ fishid ] [ fish_item_id ] == FISHING_BOOT ) {

				return SendServerMessage ( playerid, "Ouch, you caught a smelly boot! You need to catch a fish in order to progress. Try again!", MSG_TYPE_ERROR ) ;
			}

			TutorialProgress [ playerid ] = 5 ;
			ProcessTutorialTask ( playerid ) ;
		}*/

		new query [ 128 ] ;

		Character [ playerid ] [ character_fishactionsleft ] ++;
		if ( Character [ playerid ] [ character_fishactionsleft] >= 10 ) {

			Character [ playerid ] [ character_fishactionsleft ] = 0 ;

			switch ( PlayerSkill [ playerid ] [ JOB_fishing ] ) {

				case 0,1: {

					Character [ playerid ] [ character_fishcd ] = gettime() + LVL1COOLDOWN;
				}
				case 2: {

					Character [ playerid ] [ character_fishcd ] = gettime() + LVL2COOLDOWN;
				}
				case 3: {

					Character [ playerid ] [ character_fishcd ] = gettime() + LVL3COOLDOWN;
				}
			}

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_fishactionsleft = %d, character_fishcd = %d WHERE character_id = %d", 
				Character [ playerid ] [ character_fishactionsleft ], Character [ playerid ] [ character_fishcd ], Character [ playerid ] [ character_id ] ) ;
			mysql_tquery ( mysql, query ) ;

			SendServerMessage ( playerid, "Balýk tutmaktan yoruldun ve býraktýn.", MSG_TYPE_WARN ) ;
	

			return cmd_fixjob ( playerid ) ;

		}
		else {

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_fishactionsleft = %d WHERE character_id = %d", 
					Character [ playerid ] [ character_fishactionsleft ], Character [ playerid ] [ character_id ] ) ;
			mysql_tquery ( mysql, query ) ;
		}

		if ( DoingTask [ playerid ] == 0 ) {

			ProcessTask ( playerid, DoingTask [ playerid ] ) ;
		}

		return printf("Player %d: %s looted fish id %d", playerid, ReturnUserName ( playerid, true ), Fish [ fishid ] [ fish_item_id ] ) ;
	}

	else return SendServerMessage ( playerid, "Balýk tutamadýn.", MSG_TYPE_ERROR ) ;
}

CalculateCatch ( playerid ) {

	new catch ;

	switch ( player_DobberPoint [ playerid ] ) {

		case 1 .. 2: {
			catch = 0 ; // brown trout
		}
		
		case 3 .. 4: {
			catch = 1 ; // shark
		}

		case 5 .. 6: {
			catch = 2 ; // salmon
		}

		case 7 .. 8: {
			catch = 3 ; //yellowfin tuna
		}

		case 9 .. 10: {
			catch = 4 ;  // pacific cod
		}

		case 11 .. 12 : {
			catch = 5 ; // boot
		}
	}

	return catch ;
}

IsPlayerNearWater( playerid ) {

	new Float:x, Float:y, Float:z, Float:checkx, Float:checky, Float:checkz, Float:angle ;
	
	GetPlayerPos ( playerid, x, y, z ) ;
	
	if ( IsCoordBehindDam ( x, y ) ) {

		return true ;	
	}

	else if ( ! IsCoordBehindDam ( x, y ) ) {

		if( z > 0.0 && z < MAX_Z_FISH_THRESHOLD ) {

			for ( new i = 0; i < 4 ; i++ ) {

		        checkx = x + ( WATER_CHECK_RADIUS * floatsin ( -angle, degrees )  );
			    checky = y + ( WATER_CHECK_RADIUS * floatcos ( -angle, degrees ) ) ;

				angle += 90.0 ;

				CA_FindZ_For2DCoord ( checkx, checky, checkz ) ;

				if ( checkz <= 0.0 ) return true ;
			}
		}
	}

	return false ;
}

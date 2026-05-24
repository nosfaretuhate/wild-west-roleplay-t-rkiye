CMD:refreshdynamiclabels(playerid,params[]) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}
	Init_DynamicLabels();
	SendModeratorWarning(sprintf("%s (%d) tüm dinamik etiketleri yeniledi.",ReturnUserName(playerid,false,false),playerid),MOD_WARNING_LOW);
	return true;
}

CMD:reloadposses ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) tüm çeteyi yeniledi.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_LOW ) ;

	return Init_LoadPosses () ;
}

CMD:reloadpoints ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) tüm noktalarý yeniledi.", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_LOW ) ;

	return Init_Points () ;
}

CMD:removecheckpoints ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	for ( new i; i < 1024; i ++ ) {

		DestroyDynamicCP( i ) ;

	}

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) kullanýlmayan tüm kontrol noktalarýný sildi", ReturnUserName ( playerid, true ), playerid), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:refreshweather ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	RefreshZoneWeather() ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) hava durumunu yeniledi.", ReturnUserName ( playerid, true, false ), playerid), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:gotoxyz ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new Float: x, Float: y, Float: z, interior, virtualworld ;

	if ( sscanf ( params, "fffI(0)I(0)", x, y, z, interior, virtualworld ) ) {

		return SendServerMessage ( playerid, "/gotoxyz [x koordinat] [y koordinat] [z koordinat] [opsiyonel:interior] [opsiyonel:virtualworld]", MSG_TYPE_ERROR ) ;
	}

	ac_SetPlayerPos ( playerid, x, y, z ) ;

	SetPlayerInterior ( playerid, interior ) ;
	SetPlayerVirtualWorld ( playerid, virtualworld ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) %.02f, %.02f, %.02f konumuna, %i interior ve %i virtual world'e ýþýnlandý.", ReturnUserName ( playerid, true, false ), playerid, x, y, z, interior, virtualworld), MOD_WARNING_LOW ) ;
	return true ;
}

CMD:setweather ( playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new zone, weather ;

	if ( sscanf ( params, "ii", zone, weather )) {

		return SendServerMessage ( playerid, "/setweather [bölge] [hava durumu]", MSG_TYPE_ERROR ) ;
	}

	if ( zone < 0 || zone > sizeof ( Zones ) ) {

		return SendServerMessage ( playerid, "Geçersiz bölge ID'si. Önce doðru bölgede olduðunuzdan emin olun ve size gönderilen ID'yi kullanýn.", MSG_TYPE_ERROR ) ;
	}

	Zone_Weather [ zone ] = weather ;

	foreach (new i: Player) {

		if ( IsPlayerInDynamicArea(i, zone ) ) {

			SetPlayerWeather ( i, Zone_Weather [ zone ] ) ;	
		}

		else continue ;

	}

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) bölge %d'nin hava durumunu %d olarak ayarladý", ReturnUserName ( playerid, true ), playerid, zone, weather), MOD_WARNING_LOW ) ;

	SendServerMessage ( playerid, sprintf("Bölge %d'nin hava durumunu deðiþtirdiniz, içinde olan oyuncularýn güncellemesi için yeniden girmesi gerekir.", zone), MSG_TYPE_INFO ) ;

	return true ;
}

CMD:settime ( playerid, params [] ) {
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}


	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new time ;

	if ( sscanf ( params, "i", time )) {

		return SendServerMessage ( playerid, "/settime [saat]", MSG_TYPE_ERROR ) ;
	}

	if ( time < 0 || time > 23 ) {

		return SendServerMessage ( playerid, "Saat 0'dan küçük veya 23'ten büyük olamaz", MSG_TYPE_ERROR ) ;
	}

	serverHour = time ;
	SetWorldTime ( serverHour ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) sunucu saatini %d olarak ayarladý. Sunucu deðiþkeni güncellendi.", ReturnUserName ( playerid, true ), playerid, time), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:setinterior ( playerid, params [] ) {
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new targetid, int ;

	if ( sscanf ( params, "k<u>i", targetid, int )) {

		return SendServerMessage ( playerid, "/setint(erior) [kullanýcý] [interior]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, "Oyuncu baðlý deðil.", MSG_TYPE_ERROR ) ;
	}

	SetPlayerInterior(targetid, int ) ;
	SendServerMessage ( targetid, sprintf("Interior'unuz moderatör (%d) %s tarafýndan %d olarak ayarlandý", int, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin interior'unu %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, int), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:setint ( playerid, params [] ) {

	return cmd_setinterior ( playerid, params ) ;
}

CMD:setvirtualworld ( playerid, params [] ) {
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}


	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new targetid, vw ;

	if ( sscanf ( params, "k<u>i", targetid, vw )) {

		return SendServerMessage ( playerid, "/setv(irtual)w(orld) [kullanýcý] [sanal dünya]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, "Oyuncu baðlý deðil.", MSG_TYPE_ERROR ) ;
	}

	SetPlayerVirtualWorld(targetid, vw ) ;
	SendServerMessage ( targetid, sprintf("Sanal dünyasý moderatör (%d) %s tarafýndan %d olarak ayarlandý", vw, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

	SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin sanal dünyasýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, vw), MOD_WARNING_LOW ) ;

	return true ;
}

CMD:setvw ( playerid, params [] ) {

	return cmd_setvirtualworld ( playerid, params ) ;
}

CMD:set(playerid, params [] ) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak için moderatör olmanýz gerekir!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Bunu yapmak için en az genel moderatör olmanýz gerekir.", MSG_TYPE_ERROR ) ;
	}

	new option [ 20 ], targetid, value ;

	if ( sscanf ( params, "s[20]k<u>i", option, targetid, value ) ) {

		SendServerMessage ( playerid, "/set [seçenek] [oyuncu] [deðer]", MSG_TYPE_ERROR ) ;
		SendServerMessage ( playerid, "[SEÇENEKLER]: level, saglik, susuzluk, ac, deri, at, atsagligi, koken, cinsiyet, sehir", MSG_TYPE_ERROR ) ;
		SendServerMessage ( playerid, "[SEÇENEKLER]: adsayisi, tabanca_mermi, shotgun_mermi, rifle_mermi, sirt_cantasi", MSG_TYPE_ERROR ) ;
		return SendServerMessage ( playerid, "[SEÇENEKLER]: ac, susuzluk, kural_kontrol, yas", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, "Oyuncu artýk baðlý deðil.", MSG_TYPE_ERROR ) ;
	}

	new query [ 256 ] ;

	if ( ! strcmp (option, "level", true ) ) {

		if(value <= 0) {

			return SendServerMessage(playerid,"Level 0 veya altýnda olamaz.",MSG_TYPE_ERROR);
		}

		Character [ targetid ] [ character_level ] = value;
		SetPlayerScore(targetid,Character[targetid][character_level]);

		mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_level = %d WHERE character_id = %d",Character[targetid][character_level],Character[targetid][character_id]);
		mysql_tquery(mysql,query);

		SendServerMessage ( targetid, sprintf("Seviye moderatör (%d) %s tarafýndan %d olarak ayarlandý", value, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_INFO ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin seviyesini %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value), MOD_WARNING_MED ) ;
		WriteLog ( targetid, "mod/mod_set", sprintf("%s (%d) - %s (%d)'nin seviyesini %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ) ) ;
	} 
	if ( ! strcmp (option, "health", true ) ) {

		if ( value < 15 || value > 100 ) {

			return SendServerMessage ( playerid, "Saðlýk 15'ten düþük veya 100'den fazla olamaz", MSG_TYPE_ERROR ) ;
		}

		new Float: health = value ;

		SetCharacterHealth ( targetid, health ) ;

		SendServerMessage ( targetid, sprintf("Saðlýðýnýz moderatör (%d) %s tarafýndan %d olarak ayarlandý", value, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin saðlýðýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value), MOD_WARNING_MED ) ;
		WriteLog ( targetid, "mod/mod_set", sprintf("%s (%d) - %s (%d)'nin saðlýðýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ) ) ;
		
		return true ;
	}

	if ( ! strcmp (option, "thirst", true ) ) {

		if ( value < 15 || value > 100 ) {

			return SendServerMessage ( playerid, "Susuzluk 15'ten düþük veya 100'den fazla olamaz", MSG_TYPE_ERROR ) ;
		}

		new thirst = value ;

		Character [ targetid ] [ character_thirst ] = thirst ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_thirst = %d WHERE character_id = %d", Character [ targetid ] [ character_thirst ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Susuzluðunuz moderatör (%d) %s tarafýndan %d olarak ayarlandý", value, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin susuzluðunu %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ), MOD_WARNING_LOW ) ;
		WriteLog ( targetid, "mod/mod_set", sprintf("%s (%d) - %s (%d)'nin susuzluðunu %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ) ) ;
	}

	if ( ! strcmp (option, "hunger", true ) ) {

		if ( value < 15 || value > 100 ) {

			return SendServerMessage ( playerid, "Açlýk 15'ten düþük veya 100'den fazla olamaz", MSG_TYPE_ERROR ) ;
		}

		new hunger = value ;

		Character [ targetid ] [ character_hunger ] = hunger ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_hunger = %d WHERE character_id = %d", Character [ targetid ] [ character_hunger ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Açlýðýnýz moderatör (%d) %s tarafýndan %d olarak ayarlandý", value, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin açlýðýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ), MOD_WARNING_LOW ) ;
		WriteLog ( targetid, "mod/mod_set", sprintf("%s (%d) - %s (%d)'nin açlýðýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ) ) ;
	}

	if ( ! strcmp (option, "skin", true ) ) {

		if ( value < 1 || value > 311 ) {

			return SendServerMessage ( playerid, "Deri 1'den düþük veya 311'den fazla olamaz", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_skin ] = value ;
		SetPlayerSkin ( targetid,	Character [ targetid ] [ character_skin ] ) ;
		TogglePlayerControllable(targetid, true ) ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_skin = %d WHERE character_id = %d", Character [ targetid ] [ character_skin ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Deriniz moderatör (%d) %s tarafýndan %d olarak ayarlandý", value, playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin derisi %d olarak ayarlandý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ), MOD_WARNING_LOW ) ;
		WriteLog ( targetid, "mod/mod_set", sprintf("%s (%d) - %s (%d)'nin derisi %d olarak ayarlandý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value ) ) ;
	}

	if ( ! strcmp (option, "horse", true ) ) {

		if ( value == 0 || value == 4 || value == 5 ) {

			SendServerMessage ( playerid, "[ATLAR] -1: Atý Kaldýr, 1: Dutch Warmblood, 2: Highland Chestnut, 3: American Standardbred", MSG_TYPE_INFO ) ;
			return SendServerMessage ( playerid, "Geçerli at deðerleri yalnýzca -1, 1, 2 ve 3'tür.", MSG_TYPE_ERROR ) ;
		}
	

		if ( IsPlayerRidingHorse [ targetid ] || PlayerHorse [ targetid ] [ IsHorseSpawned ] ) {

			return SendServerMessage ( playerid, "Hedef oyuncu atýný ayarlamadan önce /respawnhorse kullanmalýdýr", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_horseid ] = value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_horseid = %d WHERE character_id = %d", Character [ targetid ] [ character_horseid ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		for(new i=0; i<sizeof(horseType); i++) {

			if(horseType[i][h_td_id] == value) {

				value = i;
				break;
			}
		}

		if ( value != 99 ) {
			SendServerMessage ( targetid, sprintf("Atýnýz moderatör (%d) %s tarafýndan %s olarak ayarlandý", playerid, ReturnUserName ( playerid, true ), horseType [ value ] [ h_td_name ] ), MSG_TYPE_WARN ) ;
			SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin atýný %s olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, horseType [ value ] [ h_td_name ] ), MOD_WARNING_LOW ) ;
			WriteLog ( targetid, "mods/mod_set", sprintf("[PERSONEL] %s (%d) - %s (%d)'nin atýný %s olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, horseType [ value ] [ h_td_name ] ) ) ;
		}

		else if ( value == 99 ) {
			SendServerMessage ( targetid, sprintf("Binen moderatör (%d) %s tarafýndan inek olarak ayarlandý", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;
			SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin binesini inek olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_LOW ) ;
			WriteLog ( targetid, "mods/mod_set", sprintf("[PERSONEL] %s (%d) - %s (%d)'nin binesini inek olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ) ) ;
		}
	}

	if ( ! strcmp (option, "horsehealth", true ) ) {

		if ( value < 5 || value > 100 ) {

			return SendServerMessage ( playerid, "At deðeri 5'ten düþük veya 100'den fazla olamaz.", MSG_TYPE_ERROR ) ;
		}

		if ( IsPlayerRidingHorse [ targetid ] || PlayerHorse [ targetid ] [ IsHorseSpawned ] ) {

			return SendServerMessage ( playerid, "Hedef oyuncu atýný ayarlamadan önce /respawnhorse kullanmalýdýr.", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_horsehealth ] = float(value) ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_horsehealth = %f WHERE character_id = %d", Character [ targetid ] [ character_horsehealth ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("At saðlýðýnýz moderatör (%d) %s tarafýndan %f olarak ayarlandý", playerid, ReturnUserName ( playerid, true ), Character [ targetid ] [ character_horsehealth ] ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin at saðlýðýný %f olarak ayarladý", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, Character [ targetid ] [ character_horsehealth ] ), MOD_WARNING_LOW ) ;
	}

	if ( ! strcmp (option, "origin", true ) ) {

		if ( value < 0 || value > 5 ) {

			SendServerMessage ( playerid, "[KÖKLER]: 0: Caucasian, 1: Hispanic, 2: Afrikalý, 3: Asya, 4: Hint", MSG_TYPE_INFO ) ;
			return SendServerMessage ( playerid, "Köken deðeri 0'dan düþük veya 5'ten fazla olamaz.", MSG_TYPE_ERROR ) ;
		}

		new maleSkin_array [] [] = {
			{95}, {58}, {183}, {210}, {128}
		},  femaleSkin_array [] [] = {
			{157}, {298}, {215}, {169}, {131}
		}, origin_array [] [] = {
			{"Caucasian"}, {"Hispanic"}, {"Afrikalý"}, {"Asya"}, {"Hint"}
		}, gender = Character [ targetid ] [ character_gender ], genderSkin ;

		if ( ! gender ) {
			genderSkin = maleSkin_array [ value ] [ 0 ] ;
		}

		else if ( gender ) {
			genderSkin = femaleSkin_array [ value ] [ 0 ] ;
		}

		SetPlayerSkin ( targetid, genderSkin ) ;

		Character [ targetid ] [ character_skin ] = genderSkin ;
		Character [ targetid ] [ character_origin ] = value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_skin = %d, character_origin = %d WHERE character_id = %d", Character [ targetid ] [ character_skin ], Character [ targetid ] [ character_origin ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Kökeni moderatör (%d) %s tarafýndan (%d) %s olarak ayarlandý", playerid, ReturnUserName ( playerid, true ), value, origin_array [ value ] ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin kökeni (%d) %s olarak ayarlandý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value, origin_array [ value ] ), MOD_WARNING_LOW ) ;
	}

	if ( ! strcmp (option, "gender", true ) ) {

		if ( value < 0 || value > 1 ) {

			SendServerMessage ( playerid, "[CÝNSÝYETLER]: 0: Erkek, 1: Kadýn", MSG_TYPE_INFO ) ;
			return SendServerMessage ( playerid, "Cinsiyet deðeri 0'dan düþük veya 1'den fazla olamaz.", MSG_TYPE_ERROR ) ;	
		}

		new maleSkin_array [] [] = {
			{95}, {58}, {183}, {210}, {128}
		},  femaleSkin_array [] [] = {
			{157}, {298}, {215}, {169}, {131}
		}, gender_array [] [] = {
			{"Erkek"}, {"Kadýn"}
		}, race = Character [targetid] [ character_origin ], genderSkin ;

		Character [ targetid ] [ character_gender ] = value ;

		if ( ! value ) {
			genderSkin = maleSkin_array [ race ] [ 0 ] ;
		}

		else if ( value ) {
			genderSkin = femaleSkin_array [ race ] [ 0 ] ;
		}

		SetPlayerSkin ( targetid, genderSkin ) ;
		Character [ targetid ] [ character_skin ] = genderSkin ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_skin = %d, character_gender = %d WHERE character_id = %d", Character [ targetid ] [ character_skin ], Character [ targetid ] [ character_gender ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Cinsiyet moderatör (%d) %s tarafýndan (%d) %s olarak ayarlandý", playerid, ReturnUserName ( playerid, true ), value, gender_array [ value ] ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin cinsiyeti (%d) %s olarak ayarlandý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value, gender_array [ value ] ), MOD_WARNING_LOW ) ;
	}

	if ( ! strcmp (option, "town", true ) ) {

		if ( value < 0 || value > 2 ) {

			SendServerMessage ( playerid, "[ÞEHIRLER] 0: Bayside, 1: Longcreek, 2: Fremont", MSG_TYPE_INFO ) ;
			return SendServerMessage ( playerid, "Þehir deðeri 0'dan düþük veya 3'den fazla olamaz.", MSG_TYPE_ERROR ) ;
		}

		new location_array [] [] = {
			{"Bayside"}, {"Longcreek"}, {"Fremont"}
		} ;

		Character [ targetid ] [ character_town ] = value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_town = %d WHERE character_id = %d", Character [ targetid ] [ character_town ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Þehriniz moderatör (%d) %s tarafýndan (%d) %s olarak ayarlandý", playerid, ReturnUserName ( playerid, true ), value, location_array [ value ] ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin þehri (%d) %s olarak ayarlandý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid, value, location_array [ value ] ), MOD_WARNING_LOW ) ;

	}

	if ( ! strcmp (option, "namechanges", true ) ) {

		if ( value < 0 || value > 1 ) {

			return SendServerMessage ( playerid, "Her komuta yalnýzca bir tanesini ekleyebilirsiniz. (artýyor)", MSG_TYPE_ERROR ) ;
		}

		Account [ targetid ] [ account_namechanges ] += value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_namechanges = %d WHERE account_id = %d", Account [ targetid ] [ account_namechanges ], Account [ targetid ] [ account_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Moderatör (%d) %s tarafýndan size bir ad deðiþikliði verildi", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusuna bir ad deðiþikliði verdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_MED ) ;

	}

	if ( ! strcmp (option, "pistol_ammo", true ) ) {

		if ( value < 0 || value > 1 ) {

			return SendServerMessage ( playerid, "Her komuta yalnýzca bir tanesini ekleyebilirsiniz. (artýyor)", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_ammopack_pistol ] += value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_ammopack_pistol = %d WHERE character_id = %d", Character [ targetid ] [ character_ammopack_pistol ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Moderatör (%d) %s tarafýndan size bir tabanca mermi paketi verildi", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusuna bir tabanca mermi paketi verdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_HIGH ) ;

	}

	if ( ! strcmp (option, "shotgun_ammo", true ) ) {

		if ( value < 0 || value > 1 ) {

			return SendServerMessage ( playerid, "Her komuta yalnýzca bir tanesini ekleyebilirsiniz. (artýyor)", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_ammopack_shotgun ] += value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_ammopack_shotgun = %d WHERE character_id = %d", Character [ targetid ] [ character_ammopack_shotgun ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Moderatör (%d) %s tarafýndan size bir pompalý mermi paketi verildi", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusuna bir pompalý mermi paketi verdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_HIGH ) ;

	}

	if ( ! strcmp (option, "rifle_ammo", true ) ) {

		if ( value < 0 || value > 1 ) {

			return SendServerMessage ( playerid, "Her komuta yalnýzca bir tanesini ekleyebilirsiniz. (artýyor)", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_ammopack_rifle ] += value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_ammopack_rifle = %d WHERE character_id = %d", Character [ targetid ] [ character_ammopack_rifle ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Moderatör (%d) %s tarafýndan size bir tüfek mermi paketi verildi", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d) oyuncusuna bir tüfek mermi paketi verdi.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid ), MOD_WARNING_HIGH ) ;

	}

	if ( ! strcmp (option, "backpack", true ) ) {

		if ( value < 0 || value > 2 ) {

			return SendServerMessage ( playerid, "Deðer 2'den fazla veya 0'dan küçük olamaz.", MSG_TYPE_ERROR ) ;
		}

		Character [ targetid ] [ character_backpack ] = value ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_backpack = %d WHERE character_id = %d", Character [ targetid ] [ character_backpack ], Character [ targetid ] [ character_id ] ) ;
		mysql_tquery ( mysql, query ) ;

		SendServerMessage ( targetid, sprintf("Sýrt çantanýz moderatör (%d) %s tarafýndan %d olarak ayarlandý", playerid, ReturnUserName ( playerid, true ), value ), MSG_TYPE_WARN ) ;

		SendModeratorWarning ( sprintf("[PERSONEL] %s (%d) - %s (%d)'nin sýrt çantasýný %d olarak ayarladý.", ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid , value ), MOD_WARNING_HIGH ) ;

	}

	if(!strcmp(option,"hunger",true)) {

		if(value < 0 || value > 100) {

			return SendServerMessage(playerid,"Deðer 100'den fazla veya 0'dan küçük olamaz.",MSG_TYPE_ERROR);
		}

		Character[targetid][character_hunger] = value;

		mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_hunger = %d WHERE character_id = %d",Character[targetid][character_hunger],Character[targetid][character_id]);
		mysql_tquery(mysql,query);

		UpdateGUI(targetid);

		SendServerMessage(targetid,sprintf("Açlýðýnýz moderatör (%d) %s tarafýndan %d olarak ayarlandý.",value,playerid,ReturnUserName(playerid,true)),MSG_TYPE_INFO);

		SendModeratorWarning(sprintf("[PERSONEL] %s (%d) - %s (%d)'nin açlýðýný %d olarak ayarladý.",ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid , value ), MOD_WARNING_HIGH ) ;
	}

	if(!strcmp(option,"thirst",true)) {

		if(value < 0 || value > 100) {

			return SendServerMessage(playerid,"Deðer 100'den fazla veya 0'dan küçük olamaz.",MSG_TYPE_ERROR);
		}

		Character[targetid][character_thirst] = value;

		mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_thirst = %d WHERE character_id = %d",Character[targetid][character_thirst],Character[targetid][character_id]);
		mysql_tquery(mysql,query);

		UpdateGUI(targetid);

		SendServerMessage(targetid,sprintf("Susuzluðunuz moderatör (%d) %s tarafýndan %d olarak ayarlandý.",value,playerid,ReturnUserName(playerid,true)),MSG_TYPE_INFO);

		SendModeratorWarning(sprintf("[PERSONEL] %s (%d) - %s (%d)'nin susuzluðunu %d olarak ayarladý.",ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid , value ), MOD_WARNING_HIGH ) ;
	}

	if(!strcmp(option,"rulecheck",true)) {

		if(value < 0 || value > 1) {

			return SendServerMessage(playerid,"Deðer 1'den fazla veya 0'dan küçük olamaz.",MSG_TYPE_ERROR);
		}

		Account[targetid][account_rulecheck] = value;

		mysql_format(mysql,query,sizeof(query),"UPDATE master_accounts SET account_rulecheck = %d WHERE account_id = %d",Account[targetid][account_rulecheck],Account[targetid][account_id]);
		mysql_tquery(mysql,query);

		SendModeratorWarning(sprintf("[PERSONEL] %s (%d) - %s (%d)'nin kural ihlali istatistiðini %d olarak ayarladý.",ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid , value ), MOD_WARNING_HIGH ) ;
	}

	if(!strcmp(option,"age",true)) {

		if(value < 8 || value > 80) {

			return SendServerMessage(playerid,"Deðer 80'den fazla veya 8'den küçük olamaz.",MSG_TYPE_ERROR);
		}

		Character[targetid][character_age] = value;

		mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_age = %d WHERE character_id = %d",Character[targetid][character_age],Character[targetid][character_id]);
		mysql_tquery(mysql,query);

		SendServerMessage(targetid,sprintf("Yaþýnýz moderatör (%d) %s tarafýndan %d olarak ayarlandý.",value,playerid,ReturnUserName(playerid,true)),MSG_TYPE_INFO);

		SendModeratorWarning(sprintf("[PERSONEL] %s (%d) - %s (%d)'nin yaþýný %d olarak ayarladý.",ReturnUserName ( playerid, true ), playerid, ReturnUserName ( targetid, true ), targetid , value ), MOD_WARNING_LOW ) ;
	}

	return true ;
}

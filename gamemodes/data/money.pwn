stock CanCharacterAffordPrice(playerid, dollars, cents = 0) {

	if(Character[playerid][character_handmoney] > dollars) { return true; }
	return (Character[playerid][character_handmoney] == dollars && Character[playerid][character_handchange] >= cents) ? (true) : (false);
}

SetCharacterMoney(playerid,amount,slot) {

	switch(slot) {

		case MONEY_SLOT_HAND: { Character[playerid][character_handmoney] = amount; }
		case MONEY_SLOT_BANK: { Character[playerid][character_bankmoney] = amount; }
		case MONEY_SLOT_PAYC: { Character[playerid][character_paycheck] = amount; }
	}

	new query[256];

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handmoney = '%d', character_bankmoney = '%d', character_paycheck = '%d' WHERE character_id = '%d'", 
		Character [ playerid ] [ character_handmoney ], Character [ playerid ] [ character_bankmoney ], Character [ playerid ] [ character_paycheck ], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney(playerid);
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	UpdateGUI ( playerid ) ;
	return true;
}

SetCharacterChange(playerid,amount,slot) {

	if(amount > 99 || amount < 0) { return false; }
	switch(slot) {

		case MONEY_SLOT_HAND: { Character[playerid][character_handchange] = amount; }
		case MONEY_SLOT_BANK: { Character[playerid][character_bankchange] = amount; }
		case MONEY_SLOT_PAYC: { Character[playerid][character_paychange] = amount; }
	}

	new query[256];

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handmoney = '%d', character_bankmoney = '%d', character_paycheck = '%d' WHERE character_id = '%d'", 
		Character [ playerid ] [ character_handmoney ], Character [ playerid ] [ character_bankmoney ], Character [ playerid ] [ character_paycheck ], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney(playerid);
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	UpdateGUI ( playerid ) ;
	return true;
}

GiveCharacterMoney ( playerid, amount, slot = MONEY_SLOT_HAND) {

	if(amount < 0) { return false; }

	switch ( slot ) {
		case MONEY_SLOT_HAND: Character [ playerid ] [ character_handmoney ] += amount ;
		case MONEY_SLOT_BANK: Character [ playerid ] [ character_bankmoney ] += amount ;
		case MONEY_SLOT_PAYC: Character [ playerid ] [ character_paycheck ] += amount ;
	}

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handmoney = '%d', character_bankmoney = '%d', character_paycheck = '%d' WHERE character_id = '%d'", 
		Character [ playerid ] [ character_handmoney ], Character [ playerid ] [ character_bankmoney ], Character [ playerid ] [ character_paycheck ], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney(playerid);
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	UpdateGUI ( playerid ) ;

	//OldLog ( playerid, "money/script", sprintf ( "GIVECHARACTERMONEY CALLED: %s, ++ $%d, SLOT: %d (0=hand, 1=bank, 2=paycheck)", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), slot  )) ;

	return true ;
}

GiveCharacterChange ( playerid, amount, slot ) {

	if(amount < 0) { return false; }

	switch ( slot ) {
		case MONEY_SLOT_HAND: { 
			
			Character [ playerid ] [ character_handchange ] += amount ;
			if(Character[playerid][character_handchange] >= 100) {

				new total = Character[playerid][character_handchange]-100;
				Character[playerid][character_handmoney]++;
				Character[playerid][character_handchange] = total;
			}
		}
		case MONEY_SLOT_BANK: {

			Character [ playerid ] [ character_bankchange ] += amount ;
			if(Character[playerid][character_bankchange] >= 100) {

				new total = Character[playerid][character_bankchange]-100;
				Character[playerid][character_bankmoney]++;
				Character[playerid][character_bankchange] = total;
			}
		}
		case MONEY_SLOT_PAYC: {

			Character [ playerid ] [ character_paychange ] += amount ;
			if(Character[playerid][character_paychange] >= 100) {

				new total = Character[playerid][character_paychange]-100;
				Character[playerid][character_paycheck]++;
				Character[playerid][character_paychange] = total;
			}
		}
	}

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handmoney = '%d', character_handchange = '%d', character_bankmoney = '%d', character_bankchange = '%d', character_paycheck = '%d', character_paychange = '%d' WHERE character_id = '%d'", 
		Character [ playerid ] [ character_handmoney], Character [ playerid ] [ character_handchange ], Character [ playerid ] [ character_bankmoney ], Character[playerid][character_bankchange], Character [ playerid ] [ character_paycheck ], Character[playerid][character_paychange], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney(playerid);
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	UpdateGUI ( playerid ) ;

	//OldLog ( playerid, "money/script", sprintf ( "GIVECHARACTERMONEY CALLED: %s, ++ $%d, SLOT: %d (0=hand, 1=bank, 2=paycheck)", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), slot  )) ;

	return true ;
}

TakeCharacterMoney ( playerid, amount, slot = MONEY_SLOT_HAND) {

	if ( amount < 0 ) {

		return SendServerMessage ( playerid, "Ýyi deneme.", MSG_TYPE_ERROR ) ;
	}

	switch ( slot ) {
		case MONEY_SLOT_HAND: Character [ playerid ] [ character_handmoney ] -= amount ;
		case MONEY_SLOT_BANK: Character [ playerid ] [ character_bankmoney ] -= amount ;
		case MONEY_SLOT_PAYC: Character [ playerid ] [ character_paycheck ] -= amount ;
	}

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handmoney = '%d', character_bankmoney = '%d', character_paycheck = '%d' WHERE character_id = '%d'", 
		Character [ playerid ] [ character_handmoney ], Character [ playerid ] [ character_bankmoney ], Character [ playerid ] [ character_paycheck ], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney(playerid);
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	UpdateGUI ( playerid ) ;

	//OldLog ( playerid, "money/script", sprintf ( "TAKECHARACTERMONEY CALLED: %s, -- $%d, SLOT: %d (0=hand, 1=bank, 2=paycheck)", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), slot  )) ;

	return true ;
}

TakeCharacterChange(playerid,amount,slot) {

	if ( amount < 0 ) {

		return SendServerMessage ( playerid, "Ýyi deneme.", MSG_TYPE_ERROR ) ;
	}

	switch ( slot ) {
		case MONEY_SLOT_HAND: { 

			Character [ playerid ] [ character_handchange ] -= amount ;
			if(Character[playerid][character_handchange] < 0) {

				new total = 100+Character[playerid][character_handchange];
				Character[playerid][character_handmoney]--;
				Character[playerid][character_handchange] = total;
			}
		}
		case MONEY_SLOT_BANK: { 

			Character [ playerid ] [ character_bankchange ] -= amount ;
			if(Character[playerid][character_bankchange] < 0) {

				new total = 100+Character[playerid][character_bankchange];
				Character[playerid][character_bankmoney]--;
				Character[playerid][character_bankchange] = total;
			}

		}
		case MONEY_SLOT_PAYC: {

			Character [ playerid ] [ character_paycheck ] -= amount ;
			if(Character[playerid][character_paychange] < 0) {

				new total = 100+Character[playerid][character_paychange];
				Character[playerid][character_paycheck]--;
				Character[playerid][character_paychange] = total;
			}
		}
	}

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handmoney = '%d', character_handchange = '%d', character_bankmoney = '%d', character_bankchange = '%d', character_paycheck = '%d', character_paychange = '%d' WHERE character_id = '%d'", 
		Character [ playerid ] [ character_handmoney], Character [ playerid ] [ character_handchange ], Character [ playerid ] [ character_bankmoney ], Character[playerid][character_bankchange], Character [ playerid ] [ character_paycheck ], Character[playerid][character_paychange], Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney(playerid);
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	UpdateGUI ( playerid ) ;

	//OldLog ( playerid, "money/script", sprintf ( "TAKECHARACTERMONEY CALLED: %s, -- $%d, SLOT: %d (0=hand, 1=bank, 2=paycheck)", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), slot  )) ;

	return true ;
}
// --- ÖDEME KOMUTU ---

CMD:paraver(playerid, params[]) {

	new targetid, amount, cents ;

	if ( Character [ playerid ] [ character_level ] < 3 ) {
		return SendServerMessage ( playerid, "Bu komutu kullanabilmek için 3. seviye olmanýz gerekiyor.", MSG_TYPE_ERROR ) ;
	}

	if ( sscanf ( params, "k<u>iI(0)", targetid, amount, cents ) ) {
		return SendServerMessage ( playerid, "/paraver [oyuncu] [dolar] [cent] (/pay)", MSG_TYPE_ERROR ) ;
	}

	if ( targetid == INVALID_PLAYER_ID ) {
		return SendServerMessage ( playerid, "Hedeflediðiniz oyuncu mevcut görünmüyor.", MSG_TYPE_ERROR ) ;
	}

 	if (!IsPlayerNearPlayer(playerid, targetid, 6.0)) {
	    return SendServerMessage(playerid, "O oyuncunun yakýnýnda deðilsiniz.", MSG_TYPE_ERROR);
    }

    if(targetid == playerid) { return SendServerMessage(playerid, "Kendi kendinize ödeme yapamazsýnýz.", MSG_TYPE_ERROR); }

    if(amount < 0) { return SendServerMessage(playerid, "Negatif miktarlarda para ödeyemezsiniz.", MSG_TYPE_ERROR); }

	if(amount < 1) {

		if(cents < 1 || cents > 99) {
			return SendServerMessage(playerid, "Sadece 0-99 arasýnda cent verebilirsiniz.", MSG_TYPE_ERROR);
		}
		TakeCharacterChange(playerid, cents, MONEY_SLOT_HAND);
		GiveCharacterChange(targetid, cents, MONEY_SLOT_HAND);
	}
	else {

		if ( amount < 1 || amount > Character [ playerid ] [ character_handmoney ] ) {
			return SendServerMessage ( playerid, "Üzerinizde o kadar para bulunmuyor.", MSG_TYPE_ERROR ) ;
		}
		if(cents < 0 || cents > 99) {
			return SendServerMessage(playerid, "Sadece 1-99 arasýnda cent verebilirsiniz.", MSG_TYPE_ERROR);
		}
		TakeCharacterMoney ( playerid, amount, MONEY_SLOT_HAND ) ;
		GiveCharacterMoney ( targetid, amount, MONEY_SLOT_HAND ) ;

		if(cents) { 
			TakeCharacterChange(playerid, cents, MONEY_SLOT_HAND);
			GiveCharacterChange(targetid, cents, MONEY_SLOT_HAND);
		}
	}

	if(cents != 0) { 
		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s kiþisine $%s.%02d ödedi.", ReturnUserName ( playerid, false, true ), ReturnUserName ( targetid, false, true ), IntegerWithDelimiter ( amount ), cents) ) ; 
	}
	else { 
		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s, %s kiþisine $%s ödedi.", ReturnUserName ( playerid, false, true ), ReturnUserName ( targetid, false, true ), IntegerWithDelimiter ( amount )) ) ; 
	}

	// Animasyonlar
    if ( IsPlayerNearPlayer ( playerid, targetid, 2.0 ) ) {
		SetPlayerToFacePlayer(targetid, playerid);
		SetPlayerToFacePlayer(playerid, targetid);

		ApplyAnimation(targetid, "GANGS", "prtial_hndshk_biz_01", 4.0, false, false, false, false, 0, SYNC_ALL);
		ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, false, false, false, false, 0, SYNC_ALL);
	}

	SendModeratorWarning ( sprintf("[ÖDEME] %s, %s kiþisine $%s.%02d ödedi.", ReturnUserName ( playerid, true ), ReturnUserName ( targetid, true ), IntegerWithDelimiter ( amount ), cents ), MOD_WARNING_MED ) ;
	WriteLog ( playerid, "money/pay", sprintf ( "%s ödedi %s: $%s.%02d", ReturnUserName ( playerid, false ), ReturnUserName ( targetid, false ), IntegerWithDelimiter ( amount ), cents )) ;

	return true ;
}
CMD:pay(playerid, params[]) return cmd_paraver(playerid, params);


// --- BAÐIÞ KOMUTU ---

CMD:bagis(playerid, params []) {

	new amount, cents, reason [ 64 ] ;

	if ( sscanf ( params, "iis[64]", amount, cents, reason ) ) {
		return SendServerMessage ( playerid, "/bagis [dolar] [cent] [sebep] (/charity)", MSG_TYPE_ERROR ) ;
	}

	if ( amount < 0 || cents < 0) {
		return SendServerMessage ( playerid, "Güzel deneme.", MSG_TYPE_ERROR  ) ;
	}

	if ( Character [ playerid ] [ character_handmoney ] < amount ) {
		return SendServerMessage ( playerid, "Elinizde o kadar dolar bulunmuyor!", MSG_TYPE_ERROR ) ;
	}

	if ( Character [ playerid ] [ character_handchange ] < cents ) { 
		return SendServerMessage(playerid, "Elinizde o kadar cent bulunmuyor!", MSG_TYPE_ERROR);
	}

	if ( ! strlen ( reason ) || strlen ( reason ) > 64 ) {
		return SendServerMessage ( playerid, "Sebebiniz 64 karakterden uzun olamaz veya boþ býrakýlamaz.", MSG_TYPE_ERROR ) ;
	}

	new confirmstring [ 1024 ] ;

	format ( confirmstring, sizeof ( confirmstring ), 

		"{C23030}DEVAM ETMEDEN ÖNCE BUNU OKUYUN.{DEDEDE}\n\n\
		Sunucuya {C23030}%s{DEDEDE} tutarýnda baðýþ yapmak üzeresiniz.\n\n\
		{C23030}BU PARAYI GERÝ ALMANIN HÝÇBÝR YOLU YOKTUR.{DEDEDE}\n\n\
		Yalnýzca eminseniz devam edin."

	, IntegerWithDelimiter ( amount )  ) ;

	task_yield ( 1 ) ;

	new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
	await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_MSGBOX, "{C23030}DÝKKAT: PARA SIFIRLAMA UYARISI{DEDEDE}", confirmstring, "{C23030}Devam Et", "Vazgeç" );

	if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {
		return false ;
	}

	if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		SendClientMessage(playerid, COLOR_YELLOW, sprintf("[BAÐIÞ] (%d) %s adlý oyuncu $%s.%02d tutarýnda baðýþ yaptý. Sebep: %s", playerid, ReturnUserName ( playerid, true ), IntegerWithDelimiter ( amount ), cents, reason )) ;
		SendModeratorWarning ( sprintf("[BAÐIÞ] (%d) %s adlý oyuncu $%s.%02d tutarýnda baðýþ yaptý. Sebep: %s", playerid, ReturnUserName ( playerid, true ), IntegerWithDelimiter ( amount ), cents, reason ), MOD_WARNING_MED ) ;
		
		if(amount) { TakeCharacterMoney ( playerid, amount, MONEY_SLOT_HAND ) ; }
		if(cents) { TakeCharacterChange(playerid, cents, MONEY_SLOT_HAND); }

		WriteLog ( playerid, "money/charity", sprintf ( "%s baðýþ yaptý: $%s, sebep: %s", ReturnUserName ( playerid, false ), IntegerWithDelimiter ( amount ), reason )) ;

		return true ;
	}

	return true ;
}
CMD:charity(playerid, params[]) return cmd_bagis(playerid, params);
/*

new tax = % of character_handmoney +bankmoney ;

new biztax = 50 to 100 per property, based on how many they own;

takecharmoney ( pid, tax+biztax);

if ( biztax ) {
// store in government bank
}

if ( faction == pd or gov ) {
money = xxx ;

if ( gov_bank > money ) {

   givepaycheck ( ) ;
}

else "ur faction doesnt have enough funds to pay u";
}(edited)
*/

forward Paycheck(playerid);
public Paycheck(playerid){

	new query[256];
	if ( LastPaycheckGiven [ playerid ]  >= gettime ()) {

		if ( ! IsPlayerSleepingInPoint [ playerid ]) { 

			SetTimerEx("Paycheck", 270000, false, "i", playerid);
		}

		else SetTimerEx("Paycheck", 4050000, false, "i", playerid);
		return true ;
	}

	LastPaycheckGiven [ playerid ] = gettime () + 1800 ;

	if(IsPlayerUsingAFKCommand(playerid)) { goto skipPaycheck; } //if they're using /afk

	new oldbal = Character [ playerid ] [ character_bankmoney ],
	paycheck, paychange, donator_money, property_tax, property_tax_change ;

	if(GetPlayerOwnedPoints(playerid,POINT_TYPE_HOUSE)) { property_tax++; }
	if(GetPlayerOwnedPoints(playerid,POINT_TYPE_BIZ)) { 
		
		property_tax += 2;
		property_tax_change += 50;
		if(property_tax_change >= 100) {

			property_tax++;
			property_tax_change = 0;
		}
	}
	
	new posseid = Character [ playerid ] [ character_posse ] ;

	paycheck = 2 ;
	paychange = 50 ;

	if ( IsLawEnforcementPosse ( posseid ) ) {

		paycheck = 7 ;
		paychange = 25 ;
	}


	//new interest = money_tax_int / 2, donator_money = 0 ;

	switch ( Account [ playerid ] [ account_donatorlevel ] ) {

		case 1: { 
		
			donator_money = 4 ; //50
		}

		case 2: { 

			//tax_total = floatround( float(tax_total)/1.5 ) ; 
			donator_money = 6 ; //75
		}

		case 3: { 

			//tax_total = tax_total/2 ; 
			donator_money = 8 ; //100
		}
	}

	if ( Account [ playerid ] [ account_donatorlevel ] ) { 
		GiveCharacterMoney ( playerid, donator_money, MONEY_SLOT_BANK );
 	}

 	if(paycheck > 0) { GiveCharacterMoney ( playerid, paycheck, MONEY_SLOT_PAYC ) ; }
 	if(paychange > 0) { GiveCharacterChange(playerid,paychange,MONEY_SLOT_PAYC); }

 	if(property_tax > 0) { TakeCharacterMoney(playerid,property_tax,MONEY_SLOT_BANK); }
 	if(property_tax_change > 0) { TakeCharacterChange(playerid,property_tax_change,MONEY_SLOT_BANK); }

 	if(Character[playerid][character_paycheck] < 0) {

 		new oldpay,oldchange;
 		oldpay = Character[playerid][character_paycheck];
 		oldchange = Character[playerid][character_paychange];
 		Character[playerid][character_paycheck] = 0;
 		Character[playerid][character_paychange] = 0;
 		mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_paycheck = %d,character_paychange = %d WHERE character_id = %d",Character[playerid][character_paycheck],Character[playerid][character_paychange],Character[playerid][character_id]);
 		mysql_tquery(mysql,query);

 		SendModeratorWarning(sprintf("[Maaþ Çeki] (%d) %s adlý oyuncunun maaþ çeki süresi negatif seviyede. Maaþ Çeki: $%02d.%02d",playerid,ReturnUserName(playerid,true,false),oldpay,oldchange),MOD_WARNING_MED);
 	}

	//else paycheck = 0 ;

	SendClientMessage(playerid, COLOR_TAB0, "|_______| Maaþ Çeki |_______|" ) ;
	SendClientMessage(playerid, -1, "");

	SendClientMessage(playerid, COLOR_TAB1, sprintf("[Ödenen Vergiler:] $%s [Mülk Vergisi]: $%s", IntegerWithDelimiter ( property_tax ), IntegerWithDelimiter ( property_tax ) )) ;

	if ( paycheck ) {
		SendClientMessage(playerid, COLOR_TAB1, sprintf("[Gelen]: $%s.%02d [Toplam Maaþ Çeki]: $%s.%02d", IntegerWithDelimiter ( paycheck ), paychange, IntegerWithDelimiter ( Character [ playerid ] [ character_paycheck ] ), Character[playerid][character_paychange] )) ;
	}

	else SendClientMessage(playerid, COLOR_TAB1, sprintf("[Gelen]: $0 [Toplam Maaþ Çeki]: $%s.%02d", IntegerWithDelimiter ( Character [ playerid ] [ character_paycheck ] ), Character[playerid][character_paychange]));

	if ( Account [ playerid ] [ account_donatorlevel ] ) { 
		SendClientMessage ( playerid, COLOR_TAB1, sprintf("[Baðýþçý Bonusu]: $%s", IntegerWithDelimiter ( donator_money ) ) ) ;
	}

	SendClientMessage(playerid, COLOR_TAB1, sprintf("[Eski Bakiye:] $%s.%02d [Yeni Bakiye:] $%s.%02d", IntegerWithDelimiter (oldbal), Character[playerid][character_bankchange], IntegerWithDelimiter(Character [ playerid ] [ character_bankmoney ] ), Character[playerid][character_bankchange] ));

	SendClientMessage(playerid, -1, "");
	SendServerMessage ( playerid, "Maaþ çekinizi tahsil etmek için herhangi bir postanede /maascek yazýn.", MSG_TYPE_INFO ) ;

	switch ( Account [ playerid ] [ account_donatorlevel ] ) {

		case 1: GivePlayerExperience ( playerid, 2 ) ;
		case 2: GivePlayerExperience ( playerid, 3 ) ;
		case 3: GivePlayerExperience ( playerid, 4 ) ;
		default: GivePlayerExperience ( playerid, 1 ) ;
	}

	Character [ playerid ] [ character_hours ] ++ ;

	mysql_tquery ( mysql, sprintf("UPDATE characters SET character_hours = '%d' WHERE character_id = '%d'", Character [ playerid ] [ character_hours ], Character [ playerid ] [ character_id ])) ;
	//WriteLog ( playerid, "paycheck", sprintf("'%s' processed paycheck [income: %d] [property tax: %d] [wealth tax: %d] [general tax: %d]", ReturnUserName ( playerid, true ), IntegerWithDelimiter ( paycheck ), IntegerWithDelimiter ( property_tax ), IntegerWithDelimiter ( money_tax_int ), IntegerWithDelimiter ( taxes ) ) ) ;
		
	/*					
	new query [ 256 ] ;

	for ( new i; i < MAX_POSSES; i ++ ) {

		if ( Posse [ i ] [ posse_id ] != -1 && Posse [ i ] [ posse_type ] == 2 ) {

			//Posse [ i ] [ posse_bank ] += interest ;
			//Posse [ i ] [ posse_bank ] += tax_total ;
			Posse [ i ] [ posse_bank ] -= paycheck ;
			Posse [ i ] [ posse_bank_decimal ] -= paychange;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE posses SET posse_bank = '%d', posse_bank_decimal = '%d' WHERE posse_id = %d", Posse [ i ] [ posse_bank ], Posse [ i ] [ posse_bank_decimal ], Posse [ i ] [ posse_id ] ) ;
			mysql_tquery ( mysql, query ) ; 
		}
	}
	*/

	skipPaycheck:

	if ( ! IsPlayerSleepingInPoint [ playerid ] ) { 

		SetTimerEx("Paycheck", 270000, false, "i", playerid);
	}

	else SetTimerEx("Paycheck", 4050000, false, "i", playerid);

	return true ;
}

IntegerWithDelimiter(integer, const delimiter[] = ",") {
    new string[16];

	valstr(string, integer);

    for (new i = strlen(string) - 3, j = ((integer < 0) ? 1 : 0); i > j; i -= 3) {

        strins(string, delimiter, i, sizeof string);
    }

    return string;
}

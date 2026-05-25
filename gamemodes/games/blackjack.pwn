
/*
	TODO:

	Make it so "call" and "stand" are clickable buttons and not a command
	Make /blackjack spec [id] to spectate their game (only sends the messages, doesnt show GUI)
*/

enum E_PLAYER_BLACKJACK {
	pTableID,
	pStarterCardCount,
	pGuestCardCount,
	pInBJ,
	pStarterBJ,
	pGuestBJ,
	pRequestBJ,
	pAcceptTimerBJ,
	pStarterStatusBJ,
	pGuestStatusBJ,
	pTurnBJ,
	pBetBJ
};
new PlayerBlackJack[MAX_PLAYERS][E_PLAYER_BLACKJACK];

enum { 
    BACK_OF_CARD, 
    CARD_SET_SPADES, 
    CARD_SET_HEARTS, 
    CARD_SET_DIAMONDS, 
    CARD_SET_CLOVERS 
} ; 

enum BJCardData { 

	E_CARD_NAME [ 32 ],
	E_CARD_SPRITE [32],

	E_CARD_VALUE,
	E_CARD_SET
} ; 


new Text:bj_gui_staticdraws[6] = Text: INVALID_TEXT_DRAW;
new PlayerText:bj_gui_housedraws[6] = PlayerText: INVALID_TEXT_DRAW ;
new PlayerText:bj_gui_guestdraws[6] = PlayerText: INVALID_TEXT_DRAW ;

new Card [ ] [ BJCardData ] = { 

    { "Card Back",             "LD_CARD:cdback",    0,        BACK_OF_CARD }, 

    { "King of Spades",         "LD_CARD:cd13s",    13,        CARD_SET_SPADES }, 
    { "King of Hearts",         "LD_CARD:cd13h",    13,        CARD_SET_HEARTS }, 
    { "King of Diamonds",     "LD_CARD:cd13d",    	13,        CARD_SET_DIAMONDS }, 
    { "King of Clovers",        "LD_CARD:cd13c",    13,        CARD_SET_CLOVERS }, 

    { "Queen of Spades",         "LD_CARD:cd12s",  	12,        CARD_SET_SPADES }, 
    { "Queen of Hearts",         "LD_CARD:cd12h", 	12,        CARD_SET_HEARTS }, 
    { "Queen of Diamonds",     "LD_CARD:cd12d",    	12,        CARD_SET_DIAMONDS }, 
    { "Queen of Clovers",        "LD_CARD:cd12c",  	12,        CARD_SET_CLOVERS }, 

    { "Jack of Spades",         "LD_CARD:cd11s",    11,        CARD_SET_SPADES }, 
    { "Jack of Hearts",         "LD_CARD:cd11h",    11,        CARD_SET_HEARTS }, 
    { "Jack of Diamonds",     "LD_CARD:cd11d",    	11,        CARD_SET_DIAMONDS }, 
    { "Jack of Clovers",        "LD_CARD:cd11c",    11,        CARD_SET_CLOVERS }, 

    { "10 of Spades",         "LD_CARD:cd10s",    	10,        CARD_SET_SPADES }, 
    { "10 of Hearts",         "LD_CARD:cd10h",   	10,        CARD_SET_HEARTS }, 
    { "10 of Diamonds",     "LD_CARD:cd10d",    	10,        CARD_SET_DIAMONDS }, 
    { "10 of Clovers",        "LD_CARD:cd10c",    	10,        CARD_SET_CLOVERS }, 

    { "9 of Spades",         "LD_CARD:cd9s",        9,        CARD_SET_SPADES }, 
    { "9 of Hearts",         "LD_CARD:cd9h",        9,        CARD_SET_HEARTS }, 
    { "9 of Diamonds",         "LD_CARD:cd9d",      9,        CARD_SET_DIAMONDS }, 
    { "9 of Clovers",        "LD_CARD:cd9c",        9,        CARD_SET_CLOVERS }, 

    { "8 of Spades",         "LD_CARD:cd8s",        8,        CARD_SET_SPADES }, 
    { "8 of Hearts",         "LD_CARD:cd8h",        8,        CARD_SET_HEARTS }, 
    { "8 of Diamonds",         "LD_CARD:cd8d",      8,        CARD_SET_DIAMONDS }, 
    { "8 of Clovers",        "LD_CARD:cd8c",        8,        CARD_SET_CLOVERS }, 

    { "7 of Spades",         "LD_CARD:cd7s",        7,        CARD_SET_SPADES }, 
    { "7 of Hearts",         "LD_CARD:cd7h",        7,        CARD_SET_HEARTS }, 
    { "7 of Diamonds",         "LD_CARD:cd7d",      7,        CARD_SET_DIAMONDS }, 
    { "7 of Clovers",        "LD_CARD:cd7c",        7,        CARD_SET_CLOVERS }, 

    { "6 of Spades",         "LD_CARD:cd6s",        6,        CARD_SET_SPADES }, 
    { "6 of Hearts",         "LD_CARD:cd6h",        6,        CARD_SET_HEARTS }, 
    { "6 of Diamonds",         "LD_CARD:cd6d",      6,        CARD_SET_DIAMONDS }, 
    { "6 of Clovers",        "LD_CARD:cd6c",        6,        CARD_SET_CLOVERS }, 

    { "5 of Spades",         "LD_CARD:cd5s",        5,        CARD_SET_SPADES }, 
    { "5 of Hearts",         "LD_CARD:cd5h",        5,        CARD_SET_HEARTS }, 
    { "5 of Diamonds",         "LD_CARD:cd5d",      5,        CARD_SET_DIAMONDS }, 
    { "5 of Clovers",        "LD_CARD:cd5c",        5,        CARD_SET_CLOVERS }, 

    { "4 of Spades",         "LD_CARD:cd4s",        4,        CARD_SET_SPADES }, 
    { "4 of Hearts",         "LD_CARD:cd4h",        4,        CARD_SET_HEARTS }, 
    { "4 of Diamonds",         "LD_CARD:cd4d",      4,        CARD_SET_DIAMONDS }, 
    { "4 of Clovers",        "LD_CARD:cd4c",        4,        CARD_SET_CLOVERS }, 

    { "3 of Spades",         "LD_CARD:cd3s",        3,        CARD_SET_SPADES }, 
    { "3 of Hearts",         "LD_CARD:cd3h",        3,        CARD_SET_HEARTS }, 
    { "3 of Diamonds",         "LD_CARD:cd3d",      3,        CARD_SET_DIAMONDS }, 
    { "3 of Clovers",        "LD_CARD:cd3c",        3,        CARD_SET_CLOVERS }, 

    { "2 of Spades",         "LD_CARD:cd2s",        2,        CARD_SET_SPADES }, 
    { "2 of Hearts",         "LD_CARD:cd2h",        2,        CARD_SET_HEARTS }, 
    { "2 of Diamonds",         "LD_CARD:cd2d",      2,        CARD_SET_DIAMONDS }, 
    { "2 of Clovers",        "LD_CARD:cd2c",        2,        CARD_SET_CLOVERS }, 

    { "Ace of Spades",         "LD_CARD:cd1s",		1,        CARD_SET_SPADES }, 
    { "Ace of Hearts",         "LD_CARD:cd1h",		1,        CARD_SET_HEARTS }, 
    { "Ace of Diamonds",     "LD_CARD:cd1d",  		1,        CARD_SET_DIAMONDS }, 
    { "Ace of Clovers",        "LD_CARD:cd1c",		1,        CARD_SET_CLOVERS } 
} ;  

public OnPlayerDisconnect(playerid, reason) {
	
	if(PlayerBlackJack[playerid][pInBJ]){

		new bet = PlayerBlackJack[playerid][pBetBJ] / 2 ;

		if(PlayerBlackJack[playerid][pStarterBJ] == playerid) {

			SendServerMessage(PlayerBlackJack[playerid][pGuestBJ], "Your opponent has quit the server. You've both been refunded your bet.", MSG_TYPE_INFO);
		}

		else if(PlayerBlackJack[playerid][pGuestBJ] == playerid)
		{
			SendServerMessage(PlayerBlackJack[playerid][pStarterBJ], "Your opponent has quit the server. You've both been refunded your bet.", MSG_TYPE_INFO);
		}

		GiveCharacterMoney(PlayerBlackJack[playerid][pGuestBJ], bet, MONEY_SLOT_HAND);
		GiveCharacterMoney(PlayerBlackJack[playerid][pStarterBJ], bet, MONEY_SLOT_HAND);

		BJ_Stop(PlayerBlackJack[playerid][pStarterBJ], PlayerBlackJack[playerid][pGuestBJ]);
	}

	#if defined bj_OnPlayerDisconnect
		return bj_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect bj_OnPlayerDisconnect
#if defined bj_OnPlayerDisconnect
	forward bj_OnPlayerDisconnect(playerid, reason);
#endif
CMD:blackjack(playerid, params[])
{
    new option[20], id, amount;
    new Float:X, Float:Y, Float:Z;
    new starter_id;

    if(sscanf(params, "s[20]U(-1)D(-1)", option, id, amount)) {
        return SendServerMessage(playerid, "/blackjack [accept(kabul et)/refuse(reddet)] -- [call(kartçek)/stand(kal)] -- [play(oyna)/exit(çýk)]", MSG_TYPE_ERROR);
    }

    if(!strcmp(option, "accept", true))
    {
        GetPlayerPos(PlayerBlackJack[playerid][pRequestBJ], X, Y, Z);

        if(!IsPlayerInRangeOfPoint(playerid, 2.0, X, Y, Z)) {
            return SendServerMessage ( playerid, "Hedef oyuncu yakýnýnýzda deðil.", MSG_TYPE_ERROR);
        }

        if(PlayerBlackJack[playerid][pRequestBJ] == -1){
            return SendServerMessage ( playerid, "Bekleyen bir oyun davetiniz yok.", MSG_TYPE_ERROR);
        }

        if(PlayerBlackJack[playerid][pInBJ]){
            return SendServerMessage ( playerid, "Zaten blackjack oynuyorsunuz.", MSG_TYPE_ERROR);
        }

        starter_id = PlayerBlackJack[playerid][pRequestBJ];
        PlayerBlackJack[playerid][pStarterBJ] = starter_id;
        PlayerBlackJack[playerid][pGuestBJ] = playerid;
        PlayerBlackJack[starter_id][pStarterBJ] = starter_id;
        PlayerBlackJack[starter_id][pGuestBJ] = playerid;

        PlayerBlackJack[playerid][pInBJ] = 1;
        PlayerBlackJack[starter_id][pInBJ] = 1;

        PlayerBlackJack[playerid][pTurnBJ] = playerid;
        PlayerBlackJack[starter_id][pTurnBJ] = playerid;

        SendServerMessage(playerid, "Blackjack oynamayý kabul ettiniz, çýkmak için /blackjack exit yazýn!", MSG_TYPE_INFO);
        SendServerMessage(playerid, "Senin sýran, kart çekmek için /blackjack call ve durmak için /blackjack stand komutlarýný kullan.", MSG_TYPE_INFO);

        SendServerMessage(starter_id, sprintf("%s oyunu oynamayý kabul etti. Ýlk olarak onun kart çekmesi gerekiyor.", ReturnUserName(playerid)), MSG_TYPE_INFO);

        BJ_ShowTDs(starter_id);
        BJ_ShowTDs(playerid);

        PlayerTextDrawSetString(starter_id, bj_gui_housedraws[5], sprintf("(%d) %s~n~~r~(Kasa):~w~ 0 toplam puan", starter_id, ReturnUserName(starter_id) ));
        PlayerTextDrawSetString(playerid, bj_gui_housedraws[5], sprintf("(%d) %s~n~~r~(Kasa):~w~ 0 toplam puan", starter_id, ReturnUserName(starter_id) ));

        PlayerTextDrawSetString(starter_id, bj_gui_guestdraws[5], sprintf("(%d) %s~n~~r~(Rakip):~w~ 0 toplam puan", playerid, ReturnUserName(playerid) ));
        PlayerTextDrawSetString(playerid, bj_gui_guestdraws[5], sprintf("(%d) %s~n~~r~(Rakip):~w~ 0 toplam puan", playerid, ReturnUserName(playerid) ));

        KillTimer(PlayerBlackJack[playerid][pAcceptTimerBJ]);
        PlayerBlackJack[playerid][pRequestBJ] = -1; return 1;
    }
    else if(!strcmp(option, "refuse", true))
    {
        if(PlayerBlackJack[playerid][pRequestBJ] == -1){
            return SendServerMessage(playerid, "Blackjack oynamak için bir davetiniz yok.", MSG_TYPE_ERROR);
        }

        SendServerMessage(PlayerBlackJack[playerid][pStarterBJ], "Blackjack oynama davetiniz reddedildi.", MSG_TYPE_ERROR);
        SendServerMessage(playerid, "Blackjack oynamayý reddettiniz.", MSG_TYPE_ERROR);

        starter_id = PlayerBlackJack[playerid][pRequestBJ];
        SendServerMessage(playerid, "Blackjack oyununu reddettiniz.", MSG_TYPE_INFO);
        SendServerMessage(starter_id, sprintf("%s blackjack oynamayý reddetti.", ReturnUserName(playerid)), MSG_TYPE_INFO);
        BJ_Stop(playerid, starter_id);
    }
    else if(!strcmp(option, "play", true))
    {
        GetPlayerPos(id, X, Y, Z);

        if(PlayerBlackJack[playerid][pInBJ]){
            return SendServerMessage(playerid, "Zaten blackjack oynuyorsunuz.", MSG_TYPE_ERROR);
        }

        if(id == -1 || amount < 1 || amount > 10000){
            return SendServerMessage(playerid, "/blackjack [play] [id/Oyuncu Adý] [bahis(1 - 10000)]", MSG_TYPE_ERROR);
        }

        if(!IsPlayerConnected(id) || !IsPlayerInRangeOfPoint(playerid, 2.0, X, Y, Z) || id == playerid){
            return SendServerMessage(playerid, "Bu oyuncu baðlý deðil veya yakýnýnýzda deðil.", MSG_TYPE_ERROR);
        }

        if(PlayerBlackJack[id][pInBJ] || PlayerBlackJack[id][pTableID])return
            SendServerMessage(playerid, "Oyuncu zaten bir blackjack oyunuyla meþgul.", MSG_TYPE_ERROR);

        if(Character [ playerid ] [ character_handmoney ] < amount)return
            SendServerMessage(playerid, sprintf("Yeterli paranýz yok. ($%d)", amount), MSG_TYPE_INFO);

        if(Character [ id ] [ character_handmoney ] < amount)return
            SendServerMessage(playerid, sprintf("Oyuncunun yeterli parasý yok. ($%d)", amount), MSG_TYPE_INFO);

        PlayerBlackJack[id][pRequestBJ] = playerid;

        PlayerBlackJack[playerid][pBetBJ] = amount;
        PlayerBlackJack[id][pBetBJ] = amount;

        SendServerMessage(playerid, sprintf("%s isimli oyuncuyu blackjack oynamaya davet ettiniz. (Bahis: %d $ | Potansiyel Kazanç: %d $)", ReturnUserName(id), amount, amount * 2), MSG_TYPE_INFO);
        SendServerMessage(id, sprintf("%s (kasa) size blackjack daveti gönderdi. (Bahis: %d $ | Potansiyel Kazanç: %d $)", ReturnUserName(playerid), amount, amount * 2), MSG_TYPE_INFO);

        SendServerMessage(id, "Davet 30 saniye içinde otomatik olarak iptal edilecek. (/blackjack accept - /blackjack refuse)", MSG_TYPE_INFO);
        PlayerBlackJack[id][pAcceptTimerBJ] = SetTimerEx("BJ_DeleteRequest", 30000, false, "d", id);
    }
    else if(!strcmp(option, "call", false))
    {
        if(!PlayerBlackJack[playerid][pInBJ])return
            SendServerMessage(playerid, "Blackjack oynamýyorsunuz.", MSG_TYPE_ERROR);

        if(PlayerBlackJack[playerid][pTurnBJ] != playerid){
            return SendServerMessage(playerid, "Sýra sizde deðil.", MSG_TYPE_ERROR);
        }

        BJ_GiveCard(playerid);
    }
    else if(!strcmp(option, "stand", false))
    {
        if(!PlayerBlackJack[playerid][pInBJ]){
            return SendServerMessage(playerid, "Blackjack oynamýyorsunuz.", MSG_TYPE_ERROR);
        }

        if(PlayerBlackJack[playerid][pTurnBJ] != playerid){
            return SendServerMessage(playerid, "Sýra sizde deðil.", MSG_TYPE_ERROR);
        }

        if(!PlayerBlackJack[playerid][pGuestStatusBJ]){
            return SendServerMessage(playerid, "Hiç kart çekmeden duramazsýnýz.", MSG_TYPE_ERROR);
        }

        starter_id = PlayerBlackJack[playerid][pStarterBJ];
        new guest_id = PlayerBlackJack[playerid][pGuestBJ];
        new bet = PlayerBlackJack[playerid][pBetBJ];

        if(playerid == guest_id)
        {
            PlayerBlackJack[starter_id][pTurnBJ] = starter_id;
            PlayerBlackJack[guest_id][pTurnBJ] = starter_id;

            SendServerMessage(guest_id, "Sýranýzý bitirdiniz (stand). Þimdi sýra rakibinizde.", MSG_TYPE_INFO);
            SendServerMessage(starter_id, "Rakibiniz sýrasýný bitirdi (stand). Þimdi sýra sizde, /blackjack call veya /blackjack stand komutunu kullanýn.", MSG_TYPE_INFO);
            return 1;
        }
        if(playerid == starter_id)
        {
            if(PlayerBlackJack[playerid][pStarterStatusBJ] == PlayerBlackJack[playerid][pGuestStatusBJ])
            {
                SendServerMessage(playerid, sprintf("Rakibinle ayný skoru yaptýn: %d.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);
                SendServerMessage(guest_id, sprintf("Rakibin seninle ayný skoru yaptý: %d.", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);

                GiveCharacterMoney(playerid, bet / 2, MONEY_SLOT_HAND);
                GiveCharacterMoney(guest_id, bet / 2, MONEY_SLOT_HAND);

                return BJ_Stop(playerid, guest_id);
            }
            if(PlayerBlackJack[playerid][pStarterStatusBJ] > PlayerBlackJack[playerid][pGuestStatusBJ])
            {
                SendServerMessage(playerid, sprintf("Rakibinin skorunu geçtin (%d), kazandýn.", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);
                SendServerMessage(guest_id, sprintf("Rakibin senin skorunu geçti (%d), kaybettin.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);

                GiveCharacterMoney(playerid, bet, MONEY_SLOT_HAND);
                TakeCharacterMoney(guest_id, bet, MONEY_SLOT_HAND);

                return BJ_Stop(playerid, guest_id);
            }
            else
            {
                SendServerMessage(playerid, sprintf("Rakibinin skorunu geçemedin (%d), kaybettin.", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);
                SendServerMessage(guest_id, sprintf("Rakibin senin skorunu geçemedi (%d), kazandýn.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);

                TakeCharacterMoney(playerid, bet, MONEY_SLOT_HAND);
                GiveCharacterMoney(guest_id, bet, MONEY_SLOT_HAND);

                return BJ_Stop(playerid, guest_id);
            }
        }
    }
    else if(!strcmp(option, "exit", true))
    {
        if(!PlayerBlackJack[playerid][pInBJ]){
            return SendServerMessage(playerid, "Blackjack oynamýyorsunuz.", MSG_TYPE_ERROR);
        }

        starter_id = PlayerBlackJack[playerid][pStarterBJ];
        new guest_id = PlayerBlackJack[playerid][pGuestBJ];
        new bet = PlayerBlackJack[playerid][pBetBJ];

        if(playerid == starter_id)
        {
            SendServerMessage(starter_id, "Oyundan çýktýnýz, bahsi kaybettiniz.", MSG_TYPE_ERROR);
            SendServerMessage(guest_id, "Rakibiniz oyundan çýktý, bahsi kazandýnýz.", MSG_TYPE_INFO);

            TakeCharacterMoney(starter_id, bet, MONEY_SLOT_HAND);
            GiveCharacterMoney(guest_id, bet, MONEY_SLOT_HAND);
            BJ_Stop(starter_id, guest_id);
        }
        else
        {
            SendServerMessage(guest_id, "Oyundan çýktýnýz, bahsi kaybettiniz.", MSG_TYPE_ERROR);
            SendServerMessage(starter_id, "Rakibiniz oyundan çýktý, bahsi kazandýnýz.", MSG_TYPE_INFO);

            TakeCharacterMoney(guest_id, bet, MONEY_SLOT_HAND);
            GiveCharacterMoney(starter_id, bet, MONEY_SLOT_HAND);
            BJ_Stop(starter_id, guest_id);
        }
		if(PlayerBlackJack[playerid][pTurnBJ] == playerid && PlayerBlackJack[playerid][pGuestBJ] == playerid)
		{
			SendServerMessage(PlayerBlackJack[playerid][pStarterBJ], "Senin sýran.", MSG_TYPE_ERROR);
			SendServerMessage(playerid, "Rakibin sýrasý.", MSG_TYPE_ERROR);
			starter_id = PlayerBlackJack[playerid][pStarterBJ];
			PlayerBlackJack[playerid][pTurnBJ] = starter_id;
			PlayerBlackJack[starter_id][pTurnBJ] = starter_id;
		}
		else return 1;
	}
	else if(!strcmp(option, "exit", false))
	{
		if(!PlayerBlackJack[playerid][pInBJ]){
			return SendServerMessage(playerid, "Blackjack oynamýyorsun.", MSG_TYPE_ERROR);
		}

		new bet = (Character [ playerid ] [ character_handmoney ] < PlayerBlackJack[playerid][pBetBJ]) ? Character [ playerid ] [ character_handmoney ] : PlayerBlackJack[playerid][pBetBJ];

		if(PlayerBlackJack[playerid][pStarterBJ] == playerid)
		{
			SendServerMessage(PlayerBlackJack[playerid][pGuestBJ], "Rakibin patladý sen kazandýn.", MSG_TYPE_INFO);
			SendServerMessage(playerid, "Patladýn rakibin kazandý.", MSG_TYPE_INFO);

			GiveCharacterMoney(PlayerBlackJack[playerid][pGuestBJ], bet, MONEY_SLOT_HAND);
			TakeCharacterMoney(playerid, bet, MONEY_SLOT_HAND);

			BJ_Stop(playerid, PlayerBlackJack[playerid][pGuestBJ]);
		}
		if(PlayerBlackJack[playerid][pGuestBJ] == playerid)
		{
			SendServerMessage(PlayerBlackJack[playerid][pStarterBJ], "Rakibin patladý sen kazandýn.", MSG_TYPE_INFO);
			SendServerMessage(playerid, "Patladýn rakibin kazandý.", MSG_TYPE_INFO);

			GiveCharacterMoney(PlayerBlackJack[playerid][pGuestBJ], bet, MONEY_SLOT_HAND);
			TakeCharacterMoney(playerid, bet, MONEY_SLOT_HAND);

			BJ_Stop(playerid, PlayerBlackJack[playerid][pStarterBJ]);
		}
		else return 1;
	}
	else return  SendServerMessage(playerid, "Geçersiz parametre.", MSG_TYPE_ERROR);

	return 1;
}

//Blackjack System

BJ_DeleteRequest(playerid); public BJ_DeleteRequest(playerid)
{
	SendServerMessage(playerid, "Blackjack isteðini kabul etmedin.", MSG_TYPE_INFO);
	SendServerMessage(PlayerBlackJack[playerid][pRequestBJ], "Blackjack isteðini zamanýnda kabul etmedi.", MSG_TYPE_INFO);
	PlayerBlackJack[playerid][pRequestBJ] = -1;
	KillTimer(PlayerBlackJack[playerid][pAcceptTimerBJ]); return 1;
}

BJ_DestroyTDs(playerid)
{

	for ( new i, j = sizeof ( bj_gui_housedraws ); i < j; i ++ ) {

		PlayerTextDrawDestroy(playerid, bj_gui_housedraws [ i ] ) ;
	}

	for ( new i, j = sizeof ( bj_gui_guestdraws ); i < j; i ++ ) {

		PlayerTextDrawDestroy(playerid, bj_gui_guestdraws [ i ] ) ;
	}

	return true ;
}
BJ_ShowTDs(playerid)
{
	for ( new i, j = sizeof ( bj_gui_staticdraws); i < j; i ++ ) {

		TextDrawShowForPlayer(playerid, bj_gui_staticdraws[i]);
	}

	for ( new i, j = sizeof ( bj_gui_housedraws ); i < j; i ++ ) {

		PlayerTextDrawShow(playerid, bj_gui_housedraws [ i ] ) ;
	}

	for ( new i, j = sizeof ( bj_gui_guestdraws ); i < j; i ++ ) {

		PlayerTextDrawShow(playerid, bj_gui_guestdraws [ i ] ) ;
	}

	return true ;
}

BJ_HideTDs(playerid)
{
	for ( new i, j = sizeof ( bj_gui_staticdraws); i < j; i ++ ) {

		TextDrawHideForPlayer(playerid, bj_gui_staticdraws[i]);
	}


	for ( new i, j = sizeof ( bj_gui_housedraws ); i < j; i ++ ) {

		if ( i <= 5 ) {

			PlayerTextDrawSetString(playerid, bj_gui_housedraws[i], "LD_CARD:cdback");
		}

		PlayerTextDrawHide(playerid, bj_gui_housedraws [ i ] ) ;
	}

	for ( new i, j = sizeof ( bj_gui_guestdraws ); i < j; i ++ ) {

		if ( i <= 5 ) {

			PlayerTextDrawSetString(playerid, bj_gui_guestdraws[i], "LD_CARD:cdback");
		}

		PlayerTextDrawHide(playerid, bj_gui_guestdraws [ i ] ) ;
	}

	return true ;
}



BJ_GiveCard(playerid)
{
	new add_point = random(sizeof(Card));
    new cardName_str[36];
    new card_id;

    new id = (PlayerBlackJack[playerid][pStarterStatusBJ] > PlayerBlackJack[playerid][pGuestStatusBJ]) ? PlayerBlackJack[playerid][pGuestBJ] : playerid;
    new bet = (Character [ id ] [ character_handmoney ] < PlayerBlackJack[id][pBetBJ]) ? Character [ id ] [ character_handmoney ] : PlayerBlackJack[id][pBetBJ];

	if(PlayerBlackJack[playerid][pTurnBJ] == playerid && PlayerBlackJack[playerid][pStarterBJ] == playerid)
	{
		new guest_id = PlayerBlackJack[playerid][pGuestBJ];

		PlayerBlackJack[playerid][pStarterStatusBJ] += Card[add_point][E_CARD_VALUE];
		PlayerBlackJack[guest_id][pStarterStatusBJ] = PlayerBlackJack[playerid][pStarterStatusBJ];

		PlayerTextDrawSetString(playerid, bj_gui_housedraws[5], sprintf("(%d) %s~n~~r~(Ev):~w~ %d puan toplam", playerid, ReturnUserName(playerid), PlayerBlackJack[playerid][pStarterStatusBJ] ));
		PlayerTextDrawSetString(guest_id, bj_gui_housedraws[5], sprintf("(%d) %s~n~~r~(Ev):~w~ %d puan toplam", playerid, ReturnUserName(playerid), PlayerBlackJack[playerid][pStarterStatusBJ] ));

		SendServerMessage(playerid, sprintf("Sana bir \"%s\" daðýtýldý, %d puan içeriyor.",
        Card[add_point][E_CARD_NAME], Card[add_point][E_CARD_VALUE]), MSG_TYPE_INFO);
        SendServerMessage(guest_id, sprintf("Rakibe bir \"%s\" daðýtýldý, %d puan içeriyor.",
        Card[add_point][E_CARD_NAME], Card[add_point][E_CARD_VALUE]), MSG_TYPE_INFO);

		if(PlayerBlackJack[playerid][pStarterCardCount] < 1)
		{
			format(cardName_str, sizeof(cardName_str), Card[add_point][E_CARD_SPRITE]);

			PlayerTextDrawSetString(playerid, bj_gui_housedraws[0], cardName_str );
			PlayerBlackJack[playerid][pStarterCardCount]++;
			PlayerTextDrawSetString(guest_id, bj_gui_housedraws[0], cardName_str );
		}
		else
		{
			card_id = PlayerBlackJack[playerid][pStarterCardCount];
			format(cardName_str, sizeof(cardName_str), Card[add_point][E_CARD_SPRITE]);

			if ( card_id >= 5 ) {

				card_id = 0 ;
				PlayerBlackJack[playerid][pStarterCardCount] = 0;
			}

			PlayerTextDrawSetString(playerid, bj_gui_housedraws[card_id], cardName_str );
			PlayerBlackJack[playerid][pStarterCardCount]++;
			PlayerTextDrawSetString(guest_id, bj_gui_housedraws[card_id], cardName_str );
		}
		if(PlayerBlackJack[playerid][pStarterStatusBJ] > 21)
		{
			SendServerMessage(playerid, sprintf("%d puan ile patladýn, rakibin kazandý.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);
			SendServerMessage(guest_id, sprintf("Rakibin %d puan ile patladý, sen kazandýn.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);

			GiveCharacterMoney(guest_id, bet, MONEY_SLOT_HAND);
			TakeCharacterMoney(playerid, bet, MONEY_SLOT_HAND);

			return BJ_Stop(playerid, guest_id);
		}
		if(PlayerBlackJack[playerid][pStarterStatusBJ] == PlayerBlackJack[playerid][pGuestStatusBJ])
		{
  		  SendServerMessage(playerid, sprintf("Rakibinle ayný skoru yaptýn: %d.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);
  		  SendServerMessage(guest_id, sprintf("Rakibin seninle ayný skoru yaptý: %d.", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);

   		 GiveCharacterMoney(playerid, bet / 2, MONEY_SLOT_HAND);
  		  GiveCharacterMoney(guest_id, bet / 2, MONEY_SLOT_HAND);

    		return BJ_Stop(playerid, guest_id);
		}
		if(PlayerBlackJack[playerid][pStarterStatusBJ] > PlayerBlackJack[playerid][pGuestStatusBJ])
		{
  		SendServerMessage(playerid, sprintf("Rakibinin skorunu geçtin (%d), kazandýn.", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);
		SendServerMessage(guest_id, sprintf("Rakibin senin skorunu geçti (%d), kaybettin.", PlayerBlackJack[playerid][pStarterStatusBJ]), MSG_TYPE_INFO);

 		   GiveCharacterMoney(playerid, bet, MONEY_SLOT_HAND);
 		   TakeCharacterMoney(guest_id, bet, MONEY_SLOT_HAND);

		    return BJ_Stop(playerid, guest_id);
		}
else return 1;
	}
	else if(PlayerBlackJack[playerid][pTurnBJ] == playerid && PlayerBlackJack[playerid][pGuestBJ] == playerid)
	{
		new starter_id = PlayerBlackJack[playerid][pStarterBJ];

		PlayerBlackJack[playerid][pGuestStatusBJ] += Card[add_point][E_CARD_VALUE];
		PlayerBlackJack[starter_id][pGuestStatusBJ] = PlayerBlackJack[playerid][pGuestStatusBJ];

		PlayerTextDrawSetString(starter_id, bj_gui_guestdraws[5], sprintf("(%d) %s~n~~r~(Misafir):~w~ %d puan toplam", playerid, ReturnUserName(playerid), PlayerBlackJack[playerid][pGuestStatusBJ] ));
		PlayerTextDrawSetString(playerid, bj_gui_guestdraws[5], sprintf("(%d) %s~n~~r~(Misafir):~w~ %d puan toplam", playerid, ReturnUserName(playerid), PlayerBlackJack[playerid][pGuestStatusBJ] ));

		SendServerMessage(playerid, sprintf("Sana bir \"%s\" daðýtýldý, %d puan içeriyor.",
    		Card[add_point][E_CARD_NAME], Card[add_point][E_CARD_VALUE]), MSG_TYPE_INFO);
		SendServerMessage(starter_id, sprintf("Rakibe bir \"%s\" daðýtýldý, %d puan içeriyor.",
    		Card[add_point][E_CARD_NAME], Card[add_point][E_CARD_VALUE]), MSG_TYPE_INFO);

		if(PlayerBlackJack[playerid][pGuestCardCount] < 1) {

			format(cardName_str, sizeof(cardName_str), Card[add_point][E_CARD_SPRITE]);

			PlayerTextDrawSetString(playerid, bj_gui_guestdraws[0], cardName_str );
			PlayerBlackJack[playerid][pGuestCardCount]++;
			PlayerTextDrawSetString(starter_id, bj_gui_guestdraws[0], cardName_str );
		}
		else {
			card_id = PlayerBlackJack[playerid][pGuestCardCount];
			format(cardName_str, sizeof(cardName_str), Card[add_point][E_CARD_SPRITE]);

			if ( card_id >= 5 ) {

				card_id = 0 ;
				PlayerBlackJack[playerid][pGuestCardCount] = 0;
			}

			PlayerTextDrawSetString(playerid, bj_gui_guestdraws[card_id], cardName_str );
			PlayerBlackJack[playerid][pGuestCardCount]++;
			PlayerTextDrawSetString(starter_id, bj_gui_guestdraws[card_id], cardName_str );
		}
		if(PlayerBlackJack[playerid][pGuestStatusBJ] > 21)
		{
			SendServerMessage(playerid, sprintf("Patladýn (%d), rakibin kazandý!", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);
			SendServerMessage(starter_id, sprintf("Rakibin patladý (%d), sen kazandýn!", PlayerBlackJack[playerid][pGuestStatusBJ]), MSG_TYPE_INFO);
			

			GiveCharacterMoney(starter_id, bet, MONEY_SLOT_HAND);
			TakeCharacterMoney(playerid, bet, MONEY_SLOT_HAND);
			
			BJ_Stop(playerid, starter_id);
		}
		else if(PlayerBlackJack[playerid][pGuestStatusBJ] == 21)
		{
			PlayerBlackJack[playerid][pTurnBJ] = starter_id;
			PlayerBlackJack[starter_id][pTurnBJ] = starter_id;
			SendServerMessage(playerid, "21 yaptýn, sýra karþý tarafta.", MSG_TYPE_INFO);
			SendServerMessage(starter_id, "Rakibin 21 yaptý, sýra sende!", MSG_TYPE_INFO);
		}
		else return 1;
	}
	else SendServerMessage(playerid, "Sýra sende deðilsin.", MSG_TYPE_ERROR);

	return 1;
}

BJ_ResetVariables(playerid) {

	TogglePlayerControllable(playerid, true);
	BJ_HideTDs(playerid);
	PlayerBlackJack[playerid][pStarterBJ] = -1;
	PlayerBlackJack[playerid][pGuestBJ] = -1;
	PlayerBlackJack[playerid][pTurnBJ] = -1;
	PlayerBlackJack[playerid][pRequestBJ] = -1;
	PlayerBlackJack[playerid][pStarterStatusBJ] = 0;
	PlayerBlackJack[playerid][pGuestStatusBJ] = 0;
	PlayerBlackJack[playerid][pBetBJ] = 0;
	PlayerBlackJack[playerid][pInBJ] = 0;
    PlayerBlackJack[playerid][pStarterCardCount] = 0;
    PlayerBlackJack[playerid][pGuestCardCount] = 0;
    //KillTimer(PlayerBlackJack[playerid][pAcceptTimerBJ]);

    return true ;
}

BJ_Stop(playerid, pid)
{
	TogglePlayerControllable(playerid, true);
	TogglePlayerControllable(pid, true);

	BJ_HideTDs(playerid);
	BJ_HideTDs(pid);

	PlayerBlackJack[playerid][pStarterBJ] = -1;
	PlayerBlackJack[playerid][pGuestBJ] = -1;
	PlayerBlackJack[playerid][pTurnBJ] = -1;
	PlayerBlackJack[playerid][pRequestBJ] = -1;
	PlayerBlackJack[playerid][pStarterStatusBJ] = 0;
	PlayerBlackJack[playerid][pGuestStatusBJ] = 0;
	PlayerBlackJack[playerid][pBetBJ] = 0;
	PlayerBlackJack[playerid][pInBJ] = 0;
    PlayerBlackJack[playerid][pStarterCardCount] = 0;
    PlayerBlackJack[playerid][pGuestCardCount] = 0;
    KillTimer(PlayerBlackJack[playerid][pAcceptTimerBJ]);

	PlayerBlackJack[pid][pStarterBJ] = -1;
	PlayerBlackJack[pid][pGuestBJ] = -1;
	PlayerBlackJack[pid][pTurnBJ] = -1;
	PlayerBlackJack[pid][pRequestBJ] = -1;
	PlayerBlackJack[pid][pStarterStatusBJ] = 0;
	PlayerBlackJack[pid][pGuestStatusBJ] = 0;
	PlayerBlackJack[pid][pBetBJ] = 0;
	PlayerBlackJack[pid][pInBJ] = 0;
	PlayerBlackJack[pid][pStarterCardCount] = 0;
	PlayerBlackJack[pid][pGuestCardCount] = 0;
	KillTimer(PlayerBlackJack[pid][pAcceptTimerBJ]);

	return 1;
}

Blackjack_CreateStaticGUI() {


	bj_gui_staticdraws[0] = TextDrawCreate(323.5000, 138.0000, "(( /blackjack komutuyla oyna ))");
	TextDrawFont(bj_gui_staticdraws[0], TEXT_DRAW_FONT_2);
	TextDrawLetterSize(bj_gui_staticdraws[0], 0.2500, 1.0000);
	TextDrawAlignment(bj_gui_staticdraws[0], TEXT_DRAW_ALIGN_CENTRE);
	TextDrawColor(bj_gui_staticdraws[0], -780181761);
	TextDrawSetShadow(bj_gui_staticdraws[0], 0);
	TextDrawSetOutline(bj_gui_staticdraws[0], 1);
	TextDrawBackgroundColor(bj_gui_staticdraws[0], 255);
	TextDrawTextSize(bj_gui_staticdraws[0], 0.0000, 500.0000);

	bj_gui_staticdraws[1] = TextDrawCreate(322.5000, 149.5000, "_");
	TextDrawFont(bj_gui_staticdraws[1], TEXT_DRAW_FONT_2);
	TextDrawLetterSize(bj_gui_staticdraws[1], 0.2500, 19.0000);
	TextDrawAlignment(bj_gui_staticdraws[1], TEXT_DRAW_ALIGN_CENTRE);
	TextDrawColor(bj_gui_staticdraws[1], -1523963137);
	TextDrawSetShadow(bj_gui_staticdraws[1], 0);
	TextDrawSetOutline(bj_gui_staticdraws[1], 1);
	TextDrawBackgroundColor(bj_gui_staticdraws[1], 255);
	TextDrawUseBox(bj_gui_staticdraws[1], true);
	TextDrawBoxColor(bj_gui_staticdraws[1], -780181761);
	TextDrawTextSize(bj_gui_staticdraws[1], 25.0000, 160.0000);

	bj_gui_staticdraws[2] = TextDrawCreate(322.5000, 151.5000, "_");
	TextDrawFont(bj_gui_staticdraws[2], TEXT_DRAW_FONT_2);
	TextDrawLetterSize(bj_gui_staticdraws[2], 0.2500, 18.6000);
	TextDrawAlignment(bj_gui_staticdraws[2], TEXT_DRAW_ALIGN_CENTRE);
	TextDrawColor(bj_gui_staticdraws[2], -1523963137);
	TextDrawSetShadow(bj_gui_staticdraws[2], 0);
	TextDrawSetOutline(bj_gui_staticdraws[2], 1);
	TextDrawBackgroundColor(bj_gui_staticdraws[2], 255);
	TextDrawUseBox(bj_gui_staticdraws[2], true);
	TextDrawBoxColor(bj_gui_staticdraws[2], 286331391);
	TextDrawTextSize(bj_gui_staticdraws[2], 440.0000, 157.0000);

	bj_gui_staticdraws[3] = TextDrawCreate(322.5000, 174.0000, "_");
	TextDrawFont(bj_gui_staticdraws[3], TEXT_DRAW_FONT_2);
	TextDrawLetterSize(bj_gui_staticdraws[3], 0.2500, 4.5000);
	TextDrawAlignment(bj_gui_staticdraws[3], TEXT_DRAW_ALIGN_CENTRE);
	TextDrawColor(bj_gui_staticdraws[3], -1523963137);
	TextDrawSetShadow(bj_gui_staticdraws[3], 0);
	TextDrawSetOutline(bj_gui_staticdraws[3], 1);
	TextDrawBackgroundColor(bj_gui_staticdraws[3], 255);
	TextDrawUseBox(bj_gui_staticdraws[3], true);
	TextDrawBoxColor(bj_gui_staticdraws[3], 858993578);
	TextDrawTextSize(bj_gui_staticdraws[3], 0.0000, 150.0000);

	bj_gui_staticdraws[4] = TextDrawCreate(322.5000, 251.5000, "_");
	TextDrawFont(bj_gui_staticdraws[4], TEXT_DRAW_FONT_2);
	TextDrawLetterSize(bj_gui_staticdraws[4], 0.2500, 4.5000);
	TextDrawAlignment(bj_gui_staticdraws[4], TEXT_DRAW_ALIGN_CENTRE);
	TextDrawColor(bj_gui_staticdraws[4], -1523963137);
	TextDrawSetShadow(bj_gui_staticdraws[4], 0);
	TextDrawSetOutline(bj_gui_staticdraws[4], 1);
	TextDrawBackgroundColor(bj_gui_staticdraws[4], 255);
	TextDrawUseBox(bj_gui_staticdraws[4], true);
	TextDrawBoxColor(bj_gui_staticdraws[4], 858993578);
	TextDrawTextSize(bj_gui_staticdraws[4], 0.0000, 150.0000);

	bj_gui_staticdraws[5] = TextDrawCreate(323.000, 156.0000, "Blackjack:~w~ bir~r~ versus~w~ bir");
	TextDrawFont(bj_gui_staticdraws[5], TEXT_DRAW_FONT_2);
	TextDrawLetterSize(bj_gui_staticdraws[5], 0.2500, 1.0000);
	TextDrawAlignment(bj_gui_staticdraws[5], TEXT_DRAW_ALIGN_CENTRE);
	TextDrawColor(bj_gui_staticdraws[5], -780181761);
	TextDrawSetShadow(bj_gui_staticdraws[5], 0);
	TextDrawSetOutline(bj_gui_staticdraws[5], 1);
	TextDrawBackgroundColor(bj_gui_staticdraws[5], 255);
	TextDrawTextSize(bj_gui_staticdraws[5], 0.0000, 500.0000);

	return 1;
}

// creating player textdraw(s) under "OnPlayerConnect" preferably
Blackjack_CreatePlayerGUI(playerid) {
	/*
	** player textdarw group: "house"
	*/
	bj_gui_housedraws[0] = CreatePlayerTextDraw(playerid, 250.0000, 177.0000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_housedraws[0], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_housedraws[0], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_housedraws[0], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_housedraws[0], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_housedraws[0], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_housedraws[0], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_housedraws[0], 25.0000, 35.0000);

	bj_gui_housedraws[1] = CreatePlayerTextDraw(playerid, 280.0000, 177.0000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_housedraws[1], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_housedraws[1], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_housedraws[1], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_housedraws[1], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_housedraws[1], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_housedraws[1], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_housedraws[1], 25.0000, 35.0000);

	bj_gui_housedraws[2] = CreatePlayerTextDraw(playerid, 310.0000, 177.0000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_housedraws[2], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_housedraws[2], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_housedraws[2], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_housedraws[2], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_housedraws[2], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_housedraws[2], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_housedraws[2], 25.0000, 35.0000);

	bj_gui_housedraws[3] = CreatePlayerTextDraw(playerid, 340.0000, 177.0000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_housedraws[3], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_housedraws[3], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_housedraws[3], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_housedraws[3], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_housedraws[3], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_housedraws[3], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_housedraws[3], 25.0000, 35.0000);

	bj_gui_housedraws[4] = CreatePlayerTextDraw(playerid, 370.0000, 177.0000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_housedraws[4], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_housedraws[4], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_housedraws[4], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_housedraws[4], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_housedraws[4], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_housedraws[4], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_housedraws[4], 25.0000, 35.0000);

	bj_gui_housedraws[5] = CreatePlayerTextDraw(playerid, 323.0000, 220.5000, "(100) Ad soyad~n~~r~(Ev):~w~ 21 puan toplam");
	PlayerTextDrawFont(playerid, bj_gui_housedraws[5], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_housedraws[5], 0.2500, 1.0000);
	PlayerTextDrawAlignment(playerid, bj_gui_housedraws[5], TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawColor(playerid, bj_gui_housedraws[5], -780181761);
	PlayerTextDrawSetShadow(playerid, bj_gui_housedraws[5], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_housedraws[5], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_housedraws[5], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_housedraws[5], 0.0000, 500.0000);

	/*
	** player textdarw group: "guest"
	*/
	bj_gui_guestdraws[0] = CreatePlayerTextDraw(playerid, 250.0000, 254.5000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_guestdraws[0], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_guestdraws[0], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_guestdraws[0], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_guestdraws[0], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_guestdraws[0], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_guestdraws[0], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_guestdraws[0], 25.0000, 35.0000);

	bj_gui_guestdraws[1] = CreatePlayerTextDraw(playerid, 280.0000, 254.5000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_guestdraws[1], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_guestdraws[1], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_guestdraws[1], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_guestdraws[1], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_guestdraws[1], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_guestdraws[1], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_guestdraws[1], 25.0000, 35.0000);

	bj_gui_guestdraws[2] = CreatePlayerTextDraw(playerid, 310.0000, 254.5000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_guestdraws[2], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_guestdraws[2], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_guestdraws[2], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_guestdraws[2], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_guestdraws[2], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_guestdraws[2], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_guestdraws[2], 25.0000, 35.0000);

	bj_gui_guestdraws[3] = CreatePlayerTextDraw(playerid, 340.0000, 254.5000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_guestdraws[3], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_guestdraws[3], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_guestdraws[3], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_guestdraws[3], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_guestdraws[3], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_guestdraws[3], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_guestdraws[3], 25.0000, 35.0000);

	bj_gui_guestdraws[4] = CreatePlayerTextDraw(playerid, 370.0000, 254.5000, "LD_CARD:cdback");
	PlayerTextDrawFont(playerid, bj_gui_guestdraws[4], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, bj_gui_guestdraws[4], 0.2500, 1.0000);
	PlayerTextDrawColor(playerid, bj_gui_guestdraws[4], -1);
	PlayerTextDrawSetShadow(playerid, bj_gui_guestdraws[4], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_guestdraws[4], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_guestdraws[4], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_guestdraws[4], 25.0000, 35.0000);

	bj_gui_guestdraws[5] = CreatePlayerTextDraw(playerid, 323.0000, 298.5000, " ");
	PlayerTextDrawFont(playerid, bj_gui_guestdraws[5], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, bj_gui_guestdraws[5], 0.2500, 1.0000);
	PlayerTextDrawAlignment(playerid, bj_gui_guestdraws[5], TEXT_DRAW_ALIGN_CENTRE);
	PlayerTextDrawColor(playerid, bj_gui_guestdraws[5], -780181761);
	PlayerTextDrawSetShadow(playerid, bj_gui_guestdraws[5], 0);
	PlayerTextDrawSetOutline(playerid, bj_gui_guestdraws[5], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_gui_guestdraws[5], 255);
	PlayerTextDrawTextSize(playerid, bj_gui_guestdraws[5], 0.0000, 500.0000);

	return 1;
}


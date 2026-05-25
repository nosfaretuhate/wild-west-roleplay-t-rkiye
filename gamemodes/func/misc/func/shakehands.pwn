// Handshake script (CMD:accept and CMD:shakehands)
new PlayerShakeOffer [ MAX_PLAYERS ] ;
new PlayerShakeType [ MAX_PLAYERS ] ;

CMD:shakehand(playerid, params[]) {

	if ( ! IsPlayerFree ( playerid ) ) {

		return SendServerMessage ( playerid, "Þuanda bu komutu gerçekleþtiremezsin.", MSG_TYPE_ERROR ) ; 
	}

	new userid, type;

	if (sscanf(params, "k<u>d", userid, type)) {

		return SendServerMessage ( playerid, "/shakehand [oyuncuid] [tip]", MSG_TYPE_ERROR ) ;
	}

    if (!IsPlayerConnected(userid) || !IsPlayerNearPlayer(playerid, userid, 6.0)) {

		return SendServerMessage ( playerid, "Seçilen oyuncu baðlý deðil veya yakýn deðil.", MSG_TYPE_ERROR ) ;
    }

    if (userid == playerid) {

		return SendServerMessage ( playerid, "Kendin ile el sýkýþamazsýn.", MSG_TYPE_ERROR ) ;
    }

	if (type < 1 || type > 6){
		return SendServerMessage ( playerid, "Tip 1'den düþük veya 6'dan yüksek olamaz.", MSG_TYPE_ERROR ) ;
	}

	PlayerShakeOffer [ userid ] = playerid;
	PlayerShakeType [ userid ] = type;

	SendServerMessage(userid, sprintf( "%s sana tokalaþma isteði yolladý. (\"/accept greet\").", ReturnUserName(playerid, false)), MSG_TYPE_INFO );
	SendServerMessage(playerid, sprintf( "%s adlý oyuncuya tokalaþma isteði yolladýn.", ReturnUserName(userid, false)), MSG_TYPE_INFO );
	
	//OldLog ( playerid, "shakehands", sprintf("(%d) %s requested to shake hands with (%d) %s [type %d]", playerid, ReturnUserName ( playerid, true ), userid, ReturnUserName ( userid, true ), type )) ;

	return 1;
}
CMD:tokalas(playerid, params[]) {
	return cmd_shakehand(playerid, params);
}
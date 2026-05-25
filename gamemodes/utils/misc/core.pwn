#include "utils/misc/files/fire.pwn"

CMD:streamdis(playerid, params[]) {

	new limit;

	if ( isnull ( params ) ) {

		SendServerMessage(playerid,"/streamdis(tance) [low(düþük)/medium(orta)/high(yüksek)]",MSG_TYPE_INFO);
		SendServerMessage(playerid,"Bu komut size gösterilecek objelerin hangi mesafede yükleneceðini belirler.",MSG_TYPE_INFO);
		SendServerMessage(playerid,"High - 2000 obje",MSG_TYPE_INFO);
		SendServerMessage(playerid,"Medium - 1250 obje",MSG_TYPE_INFO);
		SendServerMessage(playerid,"Low - 750 obje",MSG_TYPE_INFO);	
		return true ;
	}

	limit = 0;

	if ( ! strcmp ( params, "low", true ) ) {

		limit = 750;
	}

	else if ( ! strcmp ( params, "med", true )  || ! strcmp ( params, "medium", true ) ) {

		limit = 1250;
	}

	else if ( ! strcmp ( params, "high", true ) ) {

		limit = 2000;
	}

	else { 
		
		SendServerMessage(playerid,"/streamdis(tance) [low(düþük)/medium(orta)/high(yüksek)]",MSG_TYPE_INFO);
		SendServerMessage(playerid,"Bu komut size gösterilecek objelerin hangi mesafede yükleneceðini belirler.",MSG_TYPE_INFO);
		SendServerMessage(playerid,"High - 2000 obje",MSG_TYPE_INFO);
		SendServerMessage(playerid,"Medium - 1250 obje",MSG_TYPE_INFO);
		SendServerMessage(playerid,"Low - 750 obje",MSG_TYPE_INFO);	
		return true;
	}


	SendServerMessage(playerid,sprintf("Baþarýyla ayarlandý. \"%s\". (Limit: %d)", params, limit ),MSG_TYPE_INFO);

	Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT,limit,playerid);
	//Streamer_RadiusMultiplier(STREAMER_TYPE_OBJECT,radius,playerid);

	Streamer_Update(playerid, STREAMER_TYPE_OBJECT ) ;

	return true ;
}

CMD:streamdistance(playerid, params[]) {

	return cmd_streamdis(playerid, params);
}
/* 
 * Ýp (Lasso) Kullaným Adýmlarý:
 * - Emniyet merkezinden alýn (?).
 * - Eþyalar menüsünden (inventory) donatýn.
 * - Hedef oyuncuyu seçmek için /yakala [hedefid] veya /ip [hedefid] komutunu kullanýn.
 * - Menzildeysen, sol týkla saldýr. Mesafeye göre kaçýrma þansýn artar.
 * - Baþarýyla yakalarsan, hedef atýndan iner (at üzerindeyse), yere düþer ve dondurulur.
 */

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

CMD:yakala(playerid, params[]){

	if(IsPlayerInLassoMode[playerid]){

		IsPlayerInLassoMode[playerid] = false;
		SendServerMessage(playerid, "Ýp modundan çýktýnýz.", MSG_TYPE_INFO);
	}

	if(EquippedItem[playerid] != SHERIFF_LASSO)
		return SendServerMessage(playerid, "Ýp kullanmak için sheriff ipi donatmýþ olmalýsýnýz.", MSG_TYPE_ERROR);

	if(!IsLawEnforcementPosse(Character[playerid][character_posse]))
		return SendServerMessage(playerid, "Kolluk kuvvetleri posse'sinde deðilsiniz.", MSG_TYPE_ERROR);

	new targetid;

	if(sscanf(params, "u", targetid))
    	return SendServerMessage(playerid, "/yakala [hedef] veya /ip [hedef]", MSG_TYPE_ERROR);

    if(!IsPlayerConnected(targetid))
    	return SendServerMessage(playerid, "Belirtilen oyuncu baðlý deðil!", MSG_TYPE_ERROR);

    if(playerid == targetid)
    	return SendServerMessage(playerid, "Kendini hedefleyemezsin.", MSG_TYPE_INFO);

    if(IsLawEnforcementPosse(Character[targetid][character_posse]))
    	return SendServerMessage(playerid, "Kendi posse'nizdeki bir oyuncuyu hedefleyemezsiniz!", MSG_TYPE_ERROR);

   	IsPlayerInLassoMode[playerid] = true;
   	LassoModeTarget[playerid] = targetid;

   	SendServerMessage(playerid, sprintf("%s (%i) üzerine baþarýyla ip moduna girdiniz. Hedefi yakalamak için SOL TIK'a basýn.", ReturnUserName(targetid), targetid), MSG_TYPE_INFO);
   	SendServerMessage(playerid, "Ýp modundan çýkmak için tekrar /yakala komutunu kullanýn.", MSG_TYPE_INFO);

   	return true;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys){

	if(PRESSED(KEY_FIRE) && IsPlayerInLassoMode[playerid] && IsPlayerOnLassoCooldown[playerid]){
		SendServerMessage(playerid, "Suistimali önlemek için ip kullanýmda kýsa bekleme süresindesiniz! Birkaç saniye sonra tekrar deneyin.", MSG_TYPE_ERROR);
	} else if(PRESSED(KEY_FIRE) && IsPlayerInLassoMode[playerid] && !IsPlayerOnLassoCooldown[playerid]){
		CheckLassoReq(playerid, LassoModeTarget[playerid]);
	} 

	#if defined lasso_OnPlayerKeyStateChange
		return lasso_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return true;
	#endif
}


#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange lasso_OnPlayerKeyStateChange

#if defined lasso_OnPlayerKeyStateChange
    forward lasso_OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys);
#endif



CheckLassoReq(playerid, targetid){

	new Float: targetX, Float: targetY, Float: targetZ;
	GetPlayerPos(targetid, targetX, targetY, targetZ);

	if(IsPlayerInRangeOfPoint(playerid, 10.0, targetX, targetY, targetZ)){
		
		TryLasso(playerid, targetid);

	} else {
		return SendServerMessage(playerid, "Hedefinizden çok uzaktasýnýz. Bu mesafeden denemek kesinlikle kaçýrmanýzla sonuçlanýr!", MSG_TYPE_ERROR);
	}

	return true;
}


TryLasso(playerid, targetid){

	new randomChance = random(11);

	if(randomChance < 5){ // Baþarýlý deneme

		if(IsPlayerRidingHorse[targetid]){

			IsPlayerRidingHorse[targetid] = false;
			IsPlayerInLasso[targetid] = true;

			IsPlayerInLassoMode[playerid] = false;

			SendServerMessage(targetid, "Bir ip tarafýndan yakalandýnýz ve atýnýzdan atýldýnýz!", MSG_TYPE_INFO);
			SendServerMessage(playerid, sprintf("%s oyuncusunu ipinizle yakalayýp atýndan attýnýz.", ReturnUserName(targetid)), MSG_TYPE_INFO);

			RemovePlayerAttachedObject(targetid, ATTACH_SLOT_HORSE);

			TogglePlayerControllable(targetid, false);

			ApplyAnimation(targetid, "CRACK", "crckidle2", 4.0, true, false, false, false, 0);

			IsPlayerOnLassoCooldown[playerid] = true;
			SetTimerEx("ApplyLassoCooldown", 10000, false, "i", playerid);
			SetTimerEx("LassoAutoRemove", 300000, false, "i", targetid);

		} else {

			IsPlayerInLasso[targetid] = true;
			IsPlayerInLassoMode[playerid] = false;

			SendServerMessage(targetid, "Bir ip tarafýndan yakalandýnýz ve yere atýldýnýz!", MSG_TYPE_INFO);
			SendServerMessage(playerid, sprintf("%s oyuncusunu ipinizle yakalayýp yere attýnýz.", ReturnUserName(targetid)), MSG_TYPE_INFO);

			TogglePlayerControllable(targetid, false);

			ApplyAnimation(targetid, "CRACK", "crckidle2", 4.0, true, false, false, false, 0);		

			IsPlayerOnLassoCooldown[playerid] = true;
			SetTimerEx("ApplyLassoCooldown", 10000, false, "i", playerid);
			SetTimerEx("LassoAutoRemove", 300000, false, "i", targetid);

		}

	} else if(randomChance > 5){ // Baþarýsýz deneme

		SendServerMessage(playerid, "Hedefinizi kaçýrdýnýz!", MSG_TYPE_INFO);

		IsPlayerOnLassoCooldown[playerid] = true;
		SetTimerEx("ApplyLassoCooldown", 10000, false, "i", playerid);
	}

	return true;

}

forward ApplyLassoCooldown(playerid);
public ApplyLassoCooldown(playerid){

	IsPlayerOnLassoCooldown[playerid] = false;
	SendServerMessage(playerid, "Ýp bekleme süreniz doldu, tekrar kullanabilirsiniz.", MSG_TYPE_INFO);

	return true;
}

forward LassoAutoRemove(playerid);
public LassoAutoRemove(playerid){

	IsPlayerInLasso[playerid] = false;
	TogglePlayerControllable(playerid, true);

	SendServerMessage(playerid, "Otomatik olarak ipten kurtuldunuz.", MSG_TYPE_INFO);

	return true;
}

CMD:coz(playerid, params[]){ // Ýsmi untielasso -> çöz yaptým

	new Float: x, Float: y, Float: z;
	new bool: found = false;

	foreach(new i : Player){
		if(IsPlayerInLasso[i]){

			GetPlayerPos(i, x, y, z);

			if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)){

				IsPlayerInLasso[i] = false;
				TogglePlayerControllable(i, true);

				SendServerMessage(playerid, sprintf("%s oyuncusunun ipini çözdünüz.", ReturnUserName(i)), MSG_TYPE_INFO);
				SendServerMessage(i, "ipten kurtuldunuz. Lütfen uygun rol yapýn!", MSG_TYPE_INFO);

				found = true;
				break;
			}
		}
	}

	if(!found)
		SendServerMessage(playerid, "Yakýnda ipe baðlý oyuncu yok!", MSG_TYPE_ERROR);

	return true;
}
CMD:untie(playerid, params[]) return cmd_coz(playerid, params);
CMD:ip(playerid, params[]) return cmd_yakala(playerid, params);
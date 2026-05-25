CMD:campfire(playerid,params[]) {

	new option[16];
	if(sscanf(params,"s[16]",option)) { return SendServerMessage(playerid,"KULLANIM: /campfire [info (bilgi), create (oluþtur), addfuel (yakýtekle), destroy (yoket)]",MSG_TYPE_INFO); }
	if(!strcmp(option,"info",true)) {

		if(GetNearestCampfire(playerid) != -1) {

			return SendClientMessage(playerid,-1,sprintf("{d18214}[KAMP ATEÞÝ]{FFFFFF}: %s",GetCampfireStage(GetNearestCampfire(playerid))));
		}
		else { return SendServerMessage(playerid,"Bir kamp ateþinin yakýnýnda deðilsin.",MSG_TYPE_ERROR); }
	}
	else if(!strcmp(option,"create",true)) {

		if(DoesPlayerHaveCampfire[playerid]) { return SendServerMessage(playerid,"Zaten kurulu bir kamp ateþin var.",MSG_TYPE_ERROR); }

		task_yield(1);

		new dialog_response[e_DIALOG_RESPONSE_INFO];
		await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Kamp Ateþi Oluþturma - Ateþi Baþlatmak Ýçin Kütük Seç","Huþ Kütüðü\nMeþe Kütüðü","Seç","Çýkýþ");

		if(dialog_response[E_DIALOG_RESPONSE_Response]) {

			if(dialog_response[E_DIALOG_RESPONSE_Listitem] == 0) { //birch

				if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG) != -1) {

					new tileid = DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG),Float:x,Float:y,Float:z;
					
					GetXYInFrontOfPlayer(playerid,x,y,2.5);
					CA_FindZ_For2DCoord(x,y,z);
					DoesPlayerHaveCampfire[playerid] = true;
					PlayerCampfireObjectHandler[playerid] = CreateDynamicObject(19632, x, y, z, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
					Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],true);
					PlayerCampfireTimeLeft[playerid] = 5;
					SetTimerEx("CampfireStatus", 60000, false, "i", playerid);
					DecreaseItem(playerid,tileid);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"Bir kamp ateþi oluþturdun. Daha fazla yakýt eklemezsen 5 dakika boyunca yanýk kalacak.",MSG_TYPE_INFO);
					Streamer_Update(playerid);
					return true;
				}
				else { return SendServerMessage(playerid,"Ateþ yakmak için hiç huþ kütüðün yok.",MSG_TYPE_ERROR); }
			}
			else { //oak

				if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG) != -1) {

					new tileid = DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG),Float:x,Float:y,Float:z;
					
					GetXYInFrontOfPlayer(playerid,x,y,2.5);
					CA_FindZ_For2DCoord(x,y,z);
					DoesPlayerHaveCampfire[playerid] = true;
					PlayerCampfireObjectHandler[playerid] = CreateDynamicObject(19632, x, y, z, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
					Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],true);
					PlayerCampfireTimeLeft[playerid] = 7;
					SetTimerEx("CampfireStatus", 60000, false, "i", playerid);
					DecreaseItem(playerid,tileid);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"Bir kamp ateþi oluþturdun. Daha fazla yakýt eklemezsen 7 dakika boyunca yanýk kalacak.",MSG_TYPE_INFO);
					Streamer_Update(playerid);
					return true;
				}
				else { return SendServerMessage(playerid,"Ateþ yakmak için hiç meþe kütüðün yok.",MSG_TYPE_ERROR); }
			}
		}
	}
	else if(!strcmp(option,"addfuel",true)) {

		if(!DoesPlayerHaveCampfire[playerid]) { return SendServerMessage(playerid,"Bir kamp ateþin yok.",MSG_TYPE_ERROR); }
		task_yield(1);
		new dialog_response[e_DIALOG_RESPONSE_INFO];
		await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,sprintf("Kamp Ateþi Durumu: %s - Kütük Türü Seç",GetCampfireStage(playerid)),"Huþ - 5 dakika\nMeþe - 7 dakika\nPorsuk - 10 dakika","Seç","Çýkýþ");
		if(dialog_response[E_DIALOG_RESPONSE_Response]) {

			switch(dialog_response[E_DIALOG_RESPONSE_Listitem]) {

				case 0: { //birch

					if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG) == -1) { return SendServerMessage(playerid,"Hiç huþ kütüðün yok.",MSG_TYPE_ERROR); }
					PlayerCampfireTimeLeft[playerid] += 5;
					DecreaseItem(playerid,DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG));
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"Ateþe 5 dakika daha ekledin.",MSG_TYPE_INFO);
				}
				case 1: { //oak

					if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG) == -1) { return SendServerMessage(playerid,"Hiç meþe kütüðün yok.",MSG_TYPE_ERROR); }
					PlayerCampfireTimeLeft[playerid] += 7;
					DecreaseItem(playerid,DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG));
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"Ateþe 7 dakika daha ekledin.",MSG_TYPE_INFO);
				}
				case 2: { //yew

					if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_YEW_LOG) == -1) { return SendServerMessage(playerid,"Hiç porsuk kütüðün yok.",MSG_TYPE_ERROR); }
					PlayerCampfireTimeLeft[playerid] += 10;
					DecreaseItem(playerid,DoesPlayerHaveItemByExtraParam(playerid,LUMBER_YEW_LOG));
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"Ateþe 10 dakika daha ekledin.",MSG_TYPE_INFO);
				}
			}
			return true;
		}
	}
	else if(!strcmp(option,"destroy",true)) {

		if(!DoesPlayerHaveCampfire[playerid]) { return SendServerMessage(playerid,"Zaten bir kamp ateþin yok.",MSG_TYPE_ERROR); }
		if(GetNearestCampfire(playerid) != -1) {

			new id = GetNearestCampfire(playerid);
			if(!DoesPlayerOwnCampfire(playerid,id)) { return SendServerMessage(playerid,"Bu kamp ateþinin sahibi sen deðilsin.",MSG_TYPE_ERROR); }
			DoesPlayerHaveCampfire[playerid] = false;
			PlayerCampfireTimeLeft[playerid] = 0;
			if(IsValidDynamicObject(PlayerCampfireObjectHandler[playerid])) {

				Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],false);
				DestroyDynamicObject(PlayerCampfireObjectHandler[playerid]);
			}
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
			SendServerMessage(playerid,"Kamp ateþini söndürdün.",MSG_TYPE_INFO);
		}
	}
	else { SendServerMessage(playerid,"KULLANIM: /campfire [info (bilgi), create (oluþtur), addfuel (yakýtekle), destroy (yoket)]",MSG_TYPE_INFO); }
	return true;
}

forward CampfireStatus(playerid);
public CampfireStatus(playerid) {

	if(DoesPlayerHaveCampfire[playerid]) {

		PlayerCampfireTimeLeft[playerid]--;
		if(PlayerCampfireTimeLeft[playerid] <= 0) {

			DoesPlayerHaveCampfire[playerid] = false;
			PlayerCampfireTimeLeft[playerid] = 0;
			if(IsValidDynamicObject(PlayerCampfireObjectHandler[playerid])) {

				Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],false);
				DestroyDynamicObject(PlayerCampfireObjectHandler[playerid]);
			}
			SendServerMessage(playerid,"Ateþin söndü.",MSG_TYPE_WARN);
			return true;
		}
		SetTimerEx("CampfireStatus", 60000, false, "i", playerid);
	}
	return true;
}
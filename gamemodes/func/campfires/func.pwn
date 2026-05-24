CMD:campfire(playerid,params[]) {

	new option[16];
	if(sscanf(params,"s[16]",option)) { return SendServerMessage(playerid,"/campfire [info,create,addfuel,destroy]",MSG_TYPE_INFO); }
	if(!strcmp(option,"info",true)) {

		if(GetNearestCampfire(playerid) != -1) {

			return SendClientMessage(playerid,-1,sprintf("{d18214}[CAMPFIRE]{FFFFFF}: %s",GetCampfireStage(GetNearestCampfire(playerid))));
		}
		else { return SendServerMessage(playerid,"You are not near a campfire.",MSG_TYPE_ERROR); }
	}
	else if(!strcmp(option,"create",true)) {

		if(DoesPlayerHaveCampfire[playerid]) { return SendServerMessage(playerid,"You've already got a campfire made.",MSG_TYPE_ERROR); }

		task_yield(1);

		new dialog_response[e_DIALOG_RESPONSE_INFO];
		await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Campfire Creation - Choose Log to Start Fire","Birch Log\nOak Log","Select","Exit");

		if(dialog_response[E_DIALOG_RESPONSE_Response]) {

			if(dialog_response[E_DIALOG_RESPONSE_Listitem] == 0) { //birch

				if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG) != -1) {

					new tileid = DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG),Float:x,Float:y,Float:z;
					
					//GetPlayerPos(playerid,x,y,z);
					GetXYInFrontOfPlayer(playerid,x,y,2.5);
					CA_FindZ_For2DCoord(x,y,z);
					DoesPlayerHaveCampfire[playerid] = true;
					PlayerCampfireObjectHandler[playerid] = CreateDynamicObject(19632, x, y, z, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
					Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],true);
					PlayerCampfireTimeLeft[playerid] = 5;
					SetTimerEx("CampfireStatus", 60000, false, "i", playerid);
					DecreaseItem(playerid,tileid);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"You've created a campfire.  It will remain lit for 5 minutes unless you add more fuel.",MSG_TYPE_INFO);
					Streamer_Update(playerid);
					return true;
				}
				else { return SendServerMessage(playerid,"You don't have any birch logs to start a fire.",MSG_TYPE_ERROR); }
			}
			else { //oak

				if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG) != -1) {

					new tileid = DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG),Float:x,Float:y,Float:z;
					
					//GetPlayerPos(playerid,x,y,z);
					GetXYInFrontOfPlayer(playerid,x,y,2.5);
					CA_FindZ_For2DCoord(x,y,z);
					DoesPlayerHaveCampfire[playerid] = true;
					PlayerCampfireObjectHandler[playerid] = CreateDynamicObject(19632, x, y, z, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
					Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],true);
					PlayerCampfireTimeLeft[playerid] = 7;
					SetTimerEx("CampfireStatus", 60000, false, "i", playerid);
					DecreaseItem(playerid,tileid);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"You've created a campfire.  It will remain lit for 7 minutes unless you add more fuel.",MSG_TYPE_INFO);
					Streamer_Update(playerid);
					return true;
				}
				else { return SendServerMessage(playerid,"You don't have any oak logs to start a fire.",MSG_TYPE_ERROR); }
			}
		}
	}
	else if(!strcmp(option,"addfuel",true)) {

		if(!DoesPlayerHaveCampfire[playerid]) { return SendServerMessage(playerid,"You don't have a campfire.",MSG_TYPE_ERROR); }
		task_yield(1);
		new dialog_response[e_DIALOG_RESPONSE_INFO];
		await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,sprintf("Campfire Current Status: %s - Select Log Type",GetCampfireStage(playerid)),"Birch - 5 minutes\nOak - 7 minutes\nYew - 10 minutes","Select","Exit");
		if(dialog_response[E_DIALOG_RESPONSE_Response]) {

			switch(dialog_response[E_DIALOG_RESPONSE_Listitem]) {

				case 0: { //birch

					if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG) == -1) { return SendServerMessage(playerid,"You don't have any birch logs.",MSG_TYPE_ERROR); }
					PlayerCampfireTimeLeft[playerid] += 5;
					DecreaseItem(playerid,DoesPlayerHaveItemByExtraParam(playerid,LUMBER_BIRCH_LOG));
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"You've added 5 more minutes to the fire.",MSG_TYPE_INFO);
				}
				case 1: { //oak

					if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG) == -1) { return SendServerMessage(playerid,"You don't have any oak logs.",MSG_TYPE_ERROR); }
					PlayerCampfireTimeLeft[playerid] += 7;
					DecreaseItem(playerid,DoesPlayerHaveItemByExtraParam(playerid,LUMBER_OAK_LOG));
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"You've added 7 more minutes to the fire.",MSG_TYPE_INFO);
				}
				case 2: { //yew

					if(DoesPlayerHaveItemByExtraParam(playerid,LUMBER_YEW_LOG) == -1) { return SendServerMessage(playerid,"You don't have any yew logs.",MSG_TYPE_ERROR); }
					PlayerCampfireTimeLeft[playerid] += 10;
					DecreaseItem(playerid,DoesPlayerHaveItemByExtraParam(playerid,LUMBER_YEW_LOG));
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
					SendServerMessage(playerid,"You've added 10 more minutes to the fire.",MSG_TYPE_INFO);
				}
			}
			return true;
		}
	}
	else if(!strcmp(option,"destroy",true)) {

		if(!DoesPlayerHaveCampfire[playerid]) { return SendServerMessage(playerid,"You already don't have a campfire.",MSG_TYPE_ERROR); }
		if(GetNearestCampfire(playerid) != -1) {

			new id = GetNearestCampfire(playerid);
			if(!DoesPlayerOwnCampfire(playerid,id)) { return SendServerMessage(playerid,"You don't own this campfire.",MSG_TYPE_ERROR); }
			DoesPlayerHaveCampfire[playerid] = false;
			PlayerCampfireTimeLeft[playerid] = 0;
			if(IsValidDynamicObject(PlayerCampfireObjectHandler[playerid])) {

				Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT,PlayerCampfireObjectHandler[playerid],false);
				DestroyDynamicObject(PlayerCampfireObjectHandler[playerid]);
			}
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);
			SendServerMessage(playerid,"You've put out the campfire.",MSG_TYPE_INFO);
		}
	}
	else { SendServerMessage(playerid,"/campfire [info,create,addfuel,destroy]",MSG_TYPE_INFO); }
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
			SendServerMessage(playerid,"Your fire has gone out.",MSG_TYPE_WARN);
			return true;
		}
		SetTimerEx("CampfireStatus", 60000, false, "i", playerid);
	}
	return true;
}
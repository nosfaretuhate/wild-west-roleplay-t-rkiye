CreateDynamicLabel(playerid,label_message[],Float:x,Float:y,Float:z,interior,vw) {

	if(GetFreeDynamicLabelID() == -1) {

		SendServerMessage(playerid,"Daha fazla dinamik label oluþturulamaz.",MSG_TYPE_ERROR);
		return false;
	}
	if(strlen(label_message) > 256) {

      SendServerMessage(playerid, sprintf("Label mesajo fazla %d karakter olabilir, þu anki mesaj ise %d karakter uzunluðunda.", 256, strlen(label_message)), MSG_TYPE_ERROR);
      return false;
	}

	new id = GetFreeDynamicLabelID(),dummy_message[256];

	format(dummy_message,sizeof(dummy_message),"%s",label_message);

	inline func_CreateDynLabel() {

		DynamicLabel[id][dynamic_label_id] = cache_insert_id();
		DynamicLabel[id][dynamic_label_creator] = Account[playerid][account_id];
		DynamicLabel[id][dynamic_label_message] = dummy_message;
		DynamicLabel[id][dynamic_label_x_pos] = x;
		DynamicLabel[id][dynamic_label_y_pos] = y;
		DynamicLabel[id][dynamic_label_z_pos] = z;
		DynamicLabel[id][dynamic_label_interior] = interior;
		DynamicLabel[id][dynamic_label_vw] = vw;

		DynamicLabel[id][dynamic_label_handler] = CreateDynamic3DTextLabel(sprintf("{c6c6c6}/inspectlabel{5b3a99}\n(* %d) %s",DynamicLabel[id][dynamic_label_id],DynamicLabel[id][dynamic_label_message]),0x5b3a99FF,DynamicLabel[id][dynamic_label_x_pos],DynamicLabel[id][dynamic_label_y_pos],DynamicLabel[id][dynamic_label_z_pos],15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,DynamicLabel[id][dynamic_label_vw],DynamicLabel[id][dynamic_label_interior]);

		//SendServerMessage(playerid,sprintf("You've successfully created a dynamic label. | Dynamic Label ID: %d | Dynamic Label DB ID: %d",id,DynamicLabel[id][dynamic_label_id]),MSG_TYPE_INFO);
		SendServerMessage(playerid,"Label oluþturma baþvurun kabul edildi.",MSG_TYPE_INFO);
		SendModeratorWarning(sprintf("[LABELS]: %s (%d) adlý oyuncu yeni bir 3d label oluþturdu. %d.",ReturnUserName(playerid,false,false),playerid,DynamicLabel[id][dynamic_label_id]),MOD_WARNING_MED);
	}
	MySQL_TQueryInline(mysql,using inline func_CreateDynLabel,"INSERT INTO dynamic_labels (dynamic_label_creator,dynamic_label_message,dynamic_label_x_pos,dynamic_label_y_pos,dynamic_label_z_pos,dynamic_label_interior,dynamic_label_vw) VALUES (%d,'%e','%f','%f','%f',%d,%d)",\
		Account[playerid][account_id],label_message,x,y,z,interior,vw);
	return true;
}

CMD:inspectlabel(playerid,params[]) {

	new id;
	if(sscanf(params,"d",id)) { return SendServerMessage(playerid,"/inspectlabel [id]",MSG_TYPE_ERROR); }
	if(id == -1 || id > MAX_DYNAMIC_LABELS) { return SendServerMessage(playerid,"Geçersiz ID.",MSG_TYPE_ERROR); }
	for(new i=0; i<MAX_DYNAMIC_LABELS; i++) {

		if(DynamicLabel[i][dynamic_label_id] == id) {

			if(!IsPlayerInRangeOfPoint(playerid,5.0,DynamicLabel[i][dynamic_label_x_pos],DynamicLabel[i][dynamic_label_y_pos],DynamicLabel[i][dynamic_label_z_pos])) { return SendServerMessage(playerid,"You're not close enough to inspect this label.",MSG_TYPE_ERROR); }

			new string[256];
			format(string,sizeof(string),"%s",DynamicLabel[i][dynamic_label_message]);
			ShowPlayerDialog(playerid,9999,DIALOG_STYLE_MSGBOX,sprintf("Dinamik Label: %d",id),string,"Çýk","");
			return true;
		}
		else { continue; }
	}
	SendServerMessage(playerid,"Bu ID'ye ait bir label bulunamadý.",MSG_TYPE_ERROR);
	return true;
}

CMD:createdynamiclabel(playerid,params[]) {

	/*
	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "You need to be a moderator in order to be able to do this!", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "You must be at least a general moderator in order to do this.", MSG_TYPE_ERROR ) ;
	}
	*/

	new string[512],message[256],Float:x,Float:y,Float:z;
	if(sscanf(params,"s[256]",message)) { return SendServerMessage(playerid,"/createdynamiclabel [mesaj]",MSG_TYPE_ERROR); }
	GetPlayerPos(playerid,x,y,z);
	PlayerLabelRequest[playerid] = 1;
	PlayerLabelRequestType[playerid] = DYN_LABEL_CREATE;
	PlayerLabelRequestMessage[playerid] = message;
	PlayerLabelPosition[playerid][0] = x;
	PlayerLabelPosition[playerid][1] = y;
	PlayerLabelPosition[playerid][2] = z;
	format(string,sizeof(string),"[LABELS]: %s (%d) adlý oyuncu label baþvurusu attý /acceptlabelrequest(kabul) /denylabelrequest(red)  :%s",ReturnUserName(playerid,false,false),playerid,message);
	SendModeratorWarning(string,MOD_WARNING_LOW);
	//CreateDynamicLabel(playerid,sprintf("%s",message),x,y,z,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
	return true;
}

CMD:acceptlabelrequest(playerid,params[]) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Bunu yapmak için yetkin yok.", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Yetersiz yetki.", MSG_TYPE_ERROR ) ;
	}

	new targetid,dummy[256];
	dummy[0] = EOS;
	if(sscanf(params,"k<u>",targetid)) { return SendServerMessage(playerid,"/acceptlabelrequest [oyuncuid]",MSG_TYPE_ERROR); }
	if(!PlayerLabelRequest[targetid]) { return SendServerMessage(playerid,"Bu oyuncu bir baþvuru atmamýþ.",MSG_TYPE_ERROR); }
	switch(PlayerLabelRequestType[targetid]) {

		case DYN_LABEL_CREATE: {

			SendModeratorWarning(sprintf("[LABELS]: %s (%d) kullanýcýsý, %s (%d) kullanýcýsýnýn label oluþturma isteðini onayladý.",ReturnUserName(playerid,false,false),playerid,ReturnUserName(targetid,false,false),targetid),MOD_WARNING_MED);
			CreateDynamicLabel(targetid,PlayerLabelRequestMessage[targetid],PlayerLabelPosition[targetid][0],PlayerLabelPosition[targetid][1],PlayerLabelPosition[targetid][2],GetPlayerInterior(targetid),GetPlayerVirtualWorld(targetid));
			ResetDynLabelPlayerVariables(targetid);
		}
		case DYN_LABEL_EDIT: {

			new query[128];
			mysql_format(mysql,query,sizeof(query),"UPDATE dynamic_labels SET dynamic_label_message = '%e' WHERE dynamic_label_creator = %d LIMIT 1",PlayerLabelRequestMessage[targetid],Account[targetid][account_id]);
			mysql_tquery(mysql,query);
			SendModeratorWarning(sprintf("[LABELS]: %s (%d) kullanýcýsý, %s (%d) kullanýcýsýnýn label düzenleme isteðini onayladý.",ReturnUserName(playerid,false,false),playerid,ReturnUserName(targetid,false,false),targetid),MOD_WARNING_MED);
			Init_DynamicLabels();
			ResetDynLabelPlayerVariables(targetid);
		}
	}
	return true;
}

CMD:denylabelrequest(playerid,params[]) {

	if ( ! IsPlayerModerator ( playerid ) ) {

		return SendServerMessage ( playerid, "Yetersiz yetki.", MSG_TYPE_ERROR ) ;
	}

	if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

		return SendServerMessage ( playerid, "Yetersiz yetki.", MSG_TYPE_ERROR ) ;
	}

	new targetid,reason[64];
	if(sscanf(params,"k<u>s[64]",targetid,reason)) { return SendServerMessage(playerid,"/denylabelrequest [oyuncuid] [sebep]",MSG_TYPE_ERROR); }
	if(strlen(reason) > 64) { return SendServerMessage(playerid,"Sebep 64 karakteri geçemez.",MSG_TYPE_ERROR); }
	if(!strlen(reason)) { reason = "Sebep yok."; }
	ResetDynLabelPlayerVariables(targetid);
	SendServerMessage(targetid,sprintf("%s (%d) adlý yetkili label isteðini reddetti sebep: %s",ReturnUserName(playerid,false,false),playerid,reason),MSG_TYPE_WARN);
	SendServerMessage(playerid,sprintf("%s (%d) adlý oyuncunun label baþvurusunu reddettin.",ReturnUserName(targetid,false,false),targetid),MSG_TYPE_INFO);
	return true;
}

CMD:deletedynamiclabel(playerid,params[]) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bu iþlemi yapabilmek için moderatör olman gerekli!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

        return SendServerMessage ( playerid, "Bu iþlemi yapabilmek için en az genel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new id;
    if(sscanf(params,"d",id)) { return SendServerMessage(playerid,"/deletedynamiclabel [id (3d label üzerinde görünen id)]",MSG_TYPE_ERROR); }
    if(id == -1 || id > MAX_DYNAMIC_LABELS) { return SendServerMessage(playerid,"Bu geçerli bir Label ID'si deðil.",MSG_TYPE_ERROR); }
    for(new i=0; i<MAX_DYNAMIC_LABELS; i++) {

        if(DynamicLabel[i][dynamic_label_id] == id) {

            new query[128];

            mysql_format(mysql,query,sizeof(query),"DELETE FROM dynamic_labels WHERE dynamic_label_id = %d",DynamicLabel[i][dynamic_label_id]);
            mysql_tquery(mysql,query);

            DynamicLabel[i][dynamic_label_id] = -1;
            if(IsValidDynamic3DTextLabel(DynamicLabel[i][dynamic_label_handler])) { DestroyDynamic3DTextLabel(DynamicLabel[i][dynamic_label_handler]); }

            return SendModeratorWarning(sprintf("%s (%d) adlý yetkili %d ID'li dynamic label'ý sildi.",ReturnUserName(playerid,false,false),playerid,id),MOD_WARNING_MED);
        }
        else { continue; }
    }
    SendServerMessage(playerid,"Bu ID ile eþleþen bir label bulunamadý.",MSG_TYPE_ERROR);
    return true;
}

CMD:labelrequests(playerid,params[]) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bu iþlemi yapabilmek için moderatör olman gerekli!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < GENERAL_MOD ) {

        return SendServerMessage ( playerid, "Bu iþlemi yapabilmek için en az genel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new labels[512],found = 0;

    labels[0] = EOS;
    strcat(labels,"Oyuncu\tTip\tMesaj\n");
    foreach(new i : Player) {

        if(PlayerLabelRequest[i]) {
            
            format(labels,sizeof(labels),"%s%s (%d)\t%d\t%s\n",labels,ReturnUserName(i,true,false),i,PlayerLabelRequestType[i],PlayerLabelRequestMessage[i]);
            found++;
        }
        else { continue; }
    }
    if(!found) { return SendServerMessage(playerid,"Bekleyen bir label isteði bulunmuyor.",MSG_TYPE_ERROR); }
    SendServerMessage(playerid,"Label Tipleri:",MSG_TYPE_INFO);
    SendServerMessage(playerid,"0 - Label Oluþturma",MSG_TYPE_INFO);
    SendServerMessage(playerid,"1 - Label Düzenleme (yeni mesajý diyalogda gösterir)",MSG_TYPE_INFO);

    ShowPlayerDialog(playerid,9999,DIALOG_STYLE_TABLIST_HEADERS,"Label Ýstekleri","Exit","",labels);
    return true;
}
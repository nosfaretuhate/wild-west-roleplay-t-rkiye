#if defined _inc_func
	#undef _inc_func
#endif

AddFurniture(playerid,pointid) {

    if(Character[playerid][character_handmoney] <= 0) {

        if(Character[playerid][character_handchange] < 25) {

            SendServerMessage(playerid,"Bu mobilyayý almak için en az $0.25 gerekli.",MSG_TYPE_ERROR);
            return false;
        }
    }
    if(GetCharacterPointID(playerid) == pointid) {

        if(GetPointFurnitureCount(pointid) >= MAX_FURNITURE_LIMIT) { 

            SendServerMessage(playerid,"Mobilya sýnýrýna (100) ulaþýldý.",MSG_TYPE_ERROR);
            return false;
        }

        resetDialog:

        task_yield(1);

        new output[512], string[128], dialog_response[e_DIALOG_RESPONSE_INFO];
        output[0] = string[0] = EOS;
        for(new i=0; i<sizeof(FurnitureOverview); i++) {

            format(string,sizeof(string),"%d\t%s\n",FurnitureOverview[i][furniture_model_id],FurnitureOverview[i][furniture_name]);
            strcat(output,string);
        }

        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVIEW_MODEL, "Mobilya - Bir Kategori Seç (Tüm mobilyalar $0.25)", output, "Seç", "Çýkýþ" ) ;

        if(!dialog_response[E_DIALOG_RESPONSE_Response]) { return false; }

        output[0] = string[0] = EOS;
        switch(dialog_response[E_DIALOG_RESPONSE_Listitem]) {

            case 0: { //construction

                for(new i=0; i<sizeof(ConstructionFurniture); i++) {

                    format(string,sizeof(string),"%d\t%s\n",ConstructionFurniture[i][furniture_model_id],ConstructionFurniture[i][furniture_name]);
                    strcat(output,string);
                }

                new dialog_response_1[e_DIALOG_RESPONSE_INFO];
                await_arr(dialog_response_1) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_PREVIEW_MODEL,"Ýnþaat Mobilyalarý (Tüm mobilyalar $0.25)",output,"Seç","Çýkýþ");

                if(!dialog_response_1[E_DIALOG_RESPONSE_Response]) { goto resetDialog; }

                new Float:x, Float:y, Float:dummy;

                GetPlayerPos(playerid,x,y,dummy);
                GetXYInFrontOfPlayer(playerid,x,y,2.5);

                FurnitureBuilder[playerid][furn_builder_mode] = FURNI_BUY;
                FurnitureBuilder[playerid][furn_builder_add_obj_handler] = CreateDynamicObject(ConstructionFurniture[dialog_response_1[E_DIALOG_RESPONSE_Listitem]][furniture_model_id],x,y,dummy,0.0,0.0,0.0,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));

                EditDynamicObject(playerid,FurnitureBuilder[playerid][furn_builder_add_obj_handler]);
                SendServerMessage(playerid,"Mobilya yerleþimini iptal etmek için \"ESC\" tuþuna bas. Yerleþimi onaylayýp satýn almak için kaydet simgesine týkla.",MSG_TYPE_INFO);
            }
            case 1: { //house

                for(new i=0; i<sizeof(HouseFurniture); i++) {

                    format(string,sizeof(string),"%d\t%s\n",HouseFurniture[i][furniture_model_id],HouseFurniture[i][furniture_name]);
                    strcat(output,string);
                }

                new dialog_response_1[e_DIALOG_RESPONSE_INFO];
                await_arr(dialog_response_1) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_PREVIEW_MODEL,"Ev Mobilyalarý (Tüm mobilyalar $0.25)",output,"Seç","Çýkýþ");

                if(!dialog_response_1[E_DIALOG_RESPONSE_Response]) { goto resetDialog; }

                new Float:x, Float:y, Float:dummy;

                GetPlayerPos(playerid,x,y,dummy);
                GetXYInFrontOfPlayer(playerid,x,y,2.5);

                FurnitureBuilder[playerid][furn_builder_mode] = FURNI_BUY;
                FurnitureBuilder[playerid][furn_builder_add_obj_handler] = CreateDynamicObject(HouseFurniture[dialog_response_1[E_DIALOG_RESPONSE_Listitem]][furniture_model_id],x,y,dummy,0.0,0.0,0.0,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));

                EditDynamicObject(playerid,FurnitureBuilder[playerid][furn_builder_add_obj_handler]);
                SendServerMessage(playerid,"Mobilya yerleþimini iptal etmek için \"ESC\" tuþuna bas. Yerleþimi onaylayýp satýn almak için kaydet simgesine týkla.",MSG_TYPE_INFO);
            }
            case 2: { //other

                for(new i=0; i<sizeof(OtherFurniture); i++) {

                    format(string,sizeof(string),"%d\t%s\n",OtherFurniture[i][furniture_model_id],OtherFurniture[i][furniture_name]);
                    strcat(output,string);
                }

                new dialog_response_1[e_DIALOG_RESPONSE_INFO];
                await_arr(dialog_response_1) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_PREVIEW_MODEL,"Diðer Mobilyalar (Tüm mobilyalar $0.25)",output,"Seç","Çýkýþ");

                if(!dialog_response_1[E_DIALOG_RESPONSE_Response]) { goto resetDialog; }

                new Float:x, Float:y, Float:dummy;

                GetPlayerPos(playerid,x,y,dummy);
                GetXYInFrontOfPlayer(playerid,x,y,2.5);

                FurnitureBuilder[playerid][furn_builder_mode] = FURNI_BUY;
                FurnitureBuilder[playerid][furn_builder_add_obj_handler] = CreateDynamicObject(OtherFurniture[dialog_response_1[E_DIALOG_RESPONSE_Listitem]][furniture_model_id],x,y,dummy,0.0,0.0,0.0,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));

                EditDynamicObject(playerid,FurnitureBuilder[playerid][furn_builder_add_obj_handler]);
                SendServerMessage(playerid,"Mobilya yerleþimini iptal etmek için \"ESC\" tuþuna bas. Yerleþimi onaylayýp satýn almak için kaydet simgesine týkla.",MSG_TYPE_INFO);
            }
        }
    }
    else {

        SendServerMessage(playerid,"Bir hata oluþtu, lütfen daha sonra tekrar dene.",MSG_TYPE_ERROR);
        return false;
    }
    return true;
}

EditFurniture(playerid,pointid) {

    if(GetCharacterPointID(playerid) == pointid) {

        task_yield(1);

        new dialog_response[e_DIALOG_RESPONSE_INFO];        
        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Mobilya Düzenle - Düzenleme Türü Seç","Mobilya Yerleþimi\nMobilya Dokusu","Seç","Çýkýþ"); 

        if(!dialog_response[E_DIALOG_RESPONSE_Response]) { return cmd_point(playerid,"furni"); }

        if(dialog_response[E_DIALOG_RESPONSE_Listitem] == 0) { //placement

            FurnitureBuilder[playerid][furn_builder_mode] = FURNI_EDIT;
            SetFurnitureViewerInfo(playerid);
            SelectObject(playerid);
            SendServerMessage(playerid,"Taþýmak istediðin mobilya nesnesini seç.",MSG_TYPE_INFO);
        }
        else if(dialog_response[E_DIALOG_RESPONSE_Listitem] == 1) { //texture

            FurnitureBuilder[playerid][furn_builder_mode] = FURNI_EDIT_TEXTURE;
            SetFurnitureViewerInfo(playerid);
            SelectObject(playerid);
            SendServerMessage(playerid,"Düzenlemek istediðin mobilya nesnesini seç.",MSG_TYPE_INFO);
        }
    }
    return true;
}

RemoveFurniture(playerid,pointid) {

    if(GetCharacterPointID(playerid) == pointid) {
        
        FurnitureBuilder[playerid][furn_builder_mode] = FURNI_DELETE;
        SetFurnitureViewerInfo(playerid);
        SelectObject(playerid);
        SendServerMessage(playerid,"Silmek istediðin mobilya nesnesine týkla.",MSG_TYPE_INFO);
    }
    return true;
}

CMD:editfurnitureobject(playerid,params[]) {

    if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT || FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT_TEXTURE) {

        new furn_id;
        if(sscanf(params,"d",furn_id)) { return SendServerMessage(playerid,"Komut: /editfurni(ture)object [id]",MSG_TYPE_ERROR); }

        if(furn_id < 0) { return SendServerMessage(playerid,"Mobilya ID'leri negatif olamaz.",MSG_TYPE_ERROR); }

        for(new i=0; i<MAX_FURNITURE_LIMIT; i++) {

            if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i] == furn_id) {

                if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_point_id][i] == Point[GetCharacterPointID(playerid)][point_id]) {

                    if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT) {

                        FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = FurnitureObject[GetCharacterPointID(playerid)][furn_object_handler][i];
                        FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i];
                        ResetFurnitureViewerInfo(playerid);
                        EditDynamicObject(playerid, FurnitureBuilder[playerid][furn_builder_edit_obj_handler]);
                        return SendServerMessage(playerid,"Mobilya nesnesini taþý ve yerleþimini kaydetmek için \"Kaydet\" simgesine týkla.",MSG_TYPE_INFO);
                    }

                    else if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT_TEXTURE) {

                        task_yield(1);
                        
                        new string[512], dialog_response[e_DIALOG_RESPONSE_INFO];
                        ResetFurnitureViewerInfo(playerid);
                        CancelEdit(playerid);

                        for(new j=0; j<15; j++) {

                            format(string,sizeof(string),"%sMateryal Ýndeksi %d\n",string,j);
                        }

                        await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Mobilya Düzenle - Materyal Ýndeksleri",string,"Seç","Çýkýþ");

                        if(!dialog_response[E_DIALOG_RESPONSE_Response]) {

                            FurnitureBuilder[playerid][furn_builder_mode] = -1;
                            return cmd_point(playerid,"furni");
                        }

                        FurnitureBuilder[playerid][furn_builder_edit_mat_index] = dialog_response[E_DIALOG_RESPONSE_Listitem];
                        FurnitureBuilder[playerid][furn_builder_edit_td_count] = 0;
                        FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = FurnitureObject[GetCharacterPointID(playerid)][furn_object_handler][i];
                        FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i];
                        SetDynamicObjectMaterial(FurnitureBuilder[playerid][furn_builder_edit_obj_handler],FurnitureBuilder[playerid][furn_builder_edit_mat_index],FurnitureMaterialInfo[0][furniture_texture_modelid],FurnitureMaterialInfo[0][furniture_texture_txd_name],FurnitureMaterialInfo[0][furniture_texture_texture_name]);
                        ShowTextureEditTD(playerid);
                        SelectTextDraw(playerid,0xFFFFFF55);
                        return true;
                    }
                }
            }
        }
        return SendServerMessage(playerid,"Geçersiz bir mobilya ID'si girdin veya girdiðin ID farklý bir noktaya ait.",MSG_TYPE_ERROR);
    }
    else { SendServerMessage(playerid,"Bu komutu sadece mobilya yerleþimi veya dokusu düzenlerken kullanabilirsin.",MSG_TYPE_ERROR); }
    return true;
}
CMD:editfurniobject(playerid,params[]) { return cmd_editfurnitureobject(playerid,params); }

CMD:removefurnitureobject(playerid,params[]) {

    if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_DELETE) {

        new furn_id;
        if(sscanf(params,"d",furn_id)) { return SendServerMessage(playerid,"Komut: /removefurni(ture)object [id]",MSG_TYPE_ERROR); }

        if(furn_id < 0) { return SendServerMessage(playerid,"Mobilya ID'leri negatif olamaz.",MSG_TYPE_ERROR); }

        for(new i=0; i<MAX_FURNITURE_LIMIT; i++) {

            if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i] == furn_id) {

                if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_point_id][i] == Point[GetCharacterPointID(playerid)][point_id]) {

                    ResetFurnitureViewerInfo(playerid);
                    CancelEdit(playerid);

                    task_yield(1);

                    new dialog_response[e_DIALOG_RESPONSE_INFO];
                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_MSGBOX,"Mobilya Silme","UYARI: Silmek için bir mobilya nesnesi seçtin.\nBu diyalog yanlýþlýkla silmeyi önlemek içindir.\nKararýndan eminsen \"Onayla\" butonuna týkla.", "Onayla", "Ýptal");

                    if(!dialog_response[E_DIALOG_RESPONSE_Response]) {

                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        SendServerMessage(playerid,"Mobilya silme iþlemini iptal ettin.",MSG_TYPE_WARN);
                        return cmd_point(playerid,"furni");
                    }

                    new query[128];

                    mysql_format(mysql,query,sizeof(query),"DELETE FROM furniture WHERE furniture_id = %d",FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i]);
                    mysql_tquery(mysql,query);
                    mysql_format(mysql,query,sizeof(query),"DELETE FROM furniture_extra WHERE furniture_ex_id = %d",FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i]);
                    mysql_tquery(mysql,query);

                    FurnitureBuilder[playerid][furn_builder_mode] = -1;
                    DestroyDynamicObject(FurnitureObject[GetCharacterPointID(playerid)][furn_object_handler][i]);
                    Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
                    SendServerMessage(playerid,"Baþarýyla bir mobilya nesnesini sildin.",MSG_TYPE_INFO);

                    return 1;
                }
            }
        }
        return SendServerMessage(playerid,"Geçersiz bir mobilya ID'si girdin veya girdiðin ID farklý bir noktaya ait.",MSG_TYPE_ERROR);
    }
    else { SendServerMessage(playerid,"Bu komutu sadece mobilya silerken kullanabilirsin.",MSG_TYPE_ERROR); }
    return true;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(FurnitureBuilder[playerid][furn_builder_mode] != -1) {

        new query[512],Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
        query[0] = EOS;
        GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
        GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
        if(response == _:EDIT_RESPONSE_CANCEL) {

            switch(FurnitureBuilder[playerid][furn_builder_mode]) {

                case FURNI_BUY: {

                    if(objectid == FurnitureBuilder[playerid][furn_builder_add_obj_handler]) {
                        
                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_add_obj_handler]);
                        return AddFurniture(playerid,GetCharacterPointID(playerid));
                    }
                }
                case FURNI_EDIT: {

                    if(objectid == FurnitureBuilder[playerid][furn_builder_edit_obj_handler]) {
                        
                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        SetDynamicObjectPos(FurnitureBuilder[playerid][furn_builder_edit_obj_handler],oldX,oldY,oldZ);
                        SetDynamicObjectRot(FurnitureBuilder[playerid][furn_builder_edit_obj_handler],oldRotX,oldRotY,oldRotZ);
                        FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = -1;
                        return SendServerMessage(playerid,"Mobilya yerleþimi düzenleme iþlemini iptal ettin.",MSG_TYPE_WARN);
                    }
                }
            }
        }
        else if(response == _:EDIT_RESPONSE_FINAL) {

            switch(FurnitureBuilder[playerid][furn_builder_mode]) {

                case FURNI_BUY: {

                    if(objectid == FurnitureBuilder[playerid][furn_builder_add_obj_handler]) {
                        
                        mysql_format(mysql,query,sizeof(query),"INSERT INTO furniture (furniture_point_id,furniture_model_id,furniture_x_pos,furniture_y_pos,furniture_z_pos,furniture_rx_pos,furniture_ry_pos,furniture_rz_pos,furniture_interior_id,furniture_vw_id,furniture_vanilla) VALUES (%d,%d,'%f','%f','%f','%f','%f','%f',%d,%d,1)", \
                            Point[GetCharacterPointID(playerid)][point_id],GetDynamicObjectModel(objectid),x,y,z,rx,ry,rz,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
                        mysql_tquery(mysql,query);

                        TakeCharacterChange(playerid,25,MONEY_SLOT_HAND);
                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_add_obj_handler]);
                        Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
                        Streamer_Update(playerid,STREAMER_TYPE_OBJECT);
                        SendServerMessage(playerid,"Baþarýyla $0.25 karþýlýðýnda bir mobilya satýn aldýn.",MSG_TYPE_INFO);
                    }
                }
                case FURNI_EDIT: {

                    if(objectid == FurnitureBuilder[playerid][furn_builder_edit_obj_handler]) {
                        
                        mysql_format(mysql,query,sizeof(query),"UPDATE furniture SET furniture_x_pos = '%f',furniture_y_pos = '%f',furniture_z_pos = '%f',furniture_rx_pos = '%f',furniture_ry_pos = '%f',furniture_rz_pos = '%f' WHERE furniture_id = %d",x,y,z,rx,ry,rz,FurnitureBuilder[playerid][furn_builder_edit_obj_db_id]);
                        mysql_tquery(mysql,query);

                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = -1;                    
                        DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler]);
                        Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
                        Streamer_Update(playerid,STREAMER_TYPE_OBJECT);
                        SendServerMessage(playerid,"Bir mobilyanýn yerleþimini düzenledin.",MSG_TYPE_INFO);
                    }
                }            
            }
        }
		/*
		else if(response == EDIT_RESPONSE_UPDATE) {

			if(objectid == FurnitureBuilder[playerid][furn_builder_add_obj_handler]) {
				
				SetDynamicObjectPos(objectid,oldX,oldY,oldZ);
				SetDynamicObjectRot(objectid,oldRotX,oldRotY,oldRotZ);
			}
		}
		*/
	}
	#if defined furn_OnPlayerEditDynamicObject
		return furn_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEditDynamicObject
	#undef OnPlayerEditDynamicObject
#else
	#define _ALS_OnPlayerEditDynamicObject
#endif

#define OnPlayerEditDynamicObject furn_OnPlayerEditDynamicObject
#if defined furn_OnPlayerEditDynamicObject
	forward furn_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT_TEXTURE) {

		if(clickedid == INVALID_TEXT_DRAW) {

			HideTextureEditTD(playerid);
			FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = -1;
			FurnitureBuilder[playerid][furn_builder_mode] = -1;
			FurnitureBuilder[playerid][furn_builder_edit_mat_index] = -1;
			FurnitureBuilder[playerid][furn_builder_edit_td_count] = -1;
			if(IsValidDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler])) { DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler]); }
			FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = -1;

			Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
			Streamer_Update(playerid,STREAMER_TYPE_OBJECT);
			CancelSelectTextDraw(playerid);
			cmd_point(playerid,"furni");
			return true;
		}
		else {

			if(clickedid == FurnitureTexturePreview[0]) { //confirm

				new query[512],td_id = FurnitureBuilder[playerid][furn_builder_edit_td_count];

				mysql_format(mysql,query,sizeof(query),"INSERT INTO furniture_extra (furniture_ex_id,furniture_ex_material_index,furniture_ex_model_id,furniture_ex_txd_name,furniture_ex_texture_name) VALUES (%d,%d,%d,'%e','%e')",FurnitureBuilder[playerid][furn_builder_edit_obj_db_id],FurnitureBuilder[playerid][furn_builder_edit_mat_index],FurnitureMaterialInfo[td_id][furniture_texture_modelid],FurnitureMaterialInfo[td_id][furniture_texture_txd_name],FurnitureMaterialInfo[td_id][furniture_texture_texture_name]);
				mysql_tquery(mysql,query);
				mysql_format(mysql,query,sizeof(query),"UPDATE furniture SET furniture_vanilla = 0 WHERE furniture_id = %d",FurnitureBuilder[playerid][furn_builder_edit_obj_db_id]);
				mysql_tquery(mysql,query);

				if(IsValidDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler])) { DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler]); }
				FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = -1;
				Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
				Streamer_Update(playerid,STREAMER_TYPE_OBJECT);
				HideTextureEditTD(playerid);
				FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = -1;
				FurnitureBuilder[playerid][furn_builder_mode] = -1;
				FurnitureBuilder[playerid][furn_builder_edit_mat_index] = -1;
				FurnitureBuilder[playerid][furn_builder_edit_td_count] = -1;
				CancelSelectTextDraw(playerid);
				SendServerMessage(playerid,"You've successfully retextured a furniture object.",MSG_TYPE_INFO);
				return true;
			}

			else if(clickedid == FurnitureTexturePreview[1]) { //left

				if(FurnitureBuilder[playerid][furn_builder_edit_td_count] <= 0) { FurnitureBuilder[playerid][furn_builder_edit_td_count] = sizeof(FurnitureMaterialInfo)-1; }
				else { FurnitureBuilder[playerid][furn_builder_edit_td_count]--; }
				PlayerTextDrawSetString(playerid,FurnitureTextureName,FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_name]);
				SetDynamicObjectMaterial(FurnitureBuilder[playerid][furn_builder_edit_obj_handler],FurnitureBuilder[playerid][furn_builder_edit_mat_index],FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_modelid],FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_txd_name],FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_texture_name]);
			}

			else if(clickedid == FurnitureTexturePreview[2]) { //right

				if(FurnitureBuilder[playerid][furn_builder_edit_td_count] >= sizeof(FurnitureMaterialInfo)-1) { FurnitureBuilder[playerid][furn_builder_edit_td_count] = 0; }
				else { FurnitureBuilder[playerid][furn_builder_edit_td_count]++; }
				PlayerTextDrawSetString(playerid,FurnitureTextureName,FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_name]);
				SetDynamicObjectMaterial(FurnitureBuilder[playerid][furn_builder_edit_obj_handler],FurnitureBuilder[playerid][furn_builder_edit_mat_index],FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_modelid],FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_txd_name],FurnitureMaterialInfo[FurnitureBuilder[playerid][furn_builder_edit_td_count]][furniture_texture_texture_name]);
			}

			else if(clickedid == FurnitureTexturePreview[3]) { //cancel

				HideTextureEditTD(playerid);
				FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = -1;
				FurnitureBuilder[playerid][furn_builder_mode] = -1;
				FurnitureBuilder[playerid][furn_builder_edit_mat_index] = -1;
				FurnitureBuilder[playerid][furn_builder_edit_td_count] = -1;
				if(IsValidDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler])) { DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler]); }
				FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = -1;

				Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
				Streamer_Update(playerid,STREAMER_TYPE_OBJECT);
				CancelSelectTextDraw(playerid);
				cmd_point(playerid,"furni");
				return true;
			}
		}
	}
	#if defined furn_OnPlayerClickTextDraw
		return furn_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#else
		return 0;
	#endif
}
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif

#define OnPlayerClickTextDraw furn_OnPlayerClickTextDraw
#if defined furn_OnPlayerClickTextDraw
	forward furn_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif
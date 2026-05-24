#if defined _inc_utils
	#undef _inc_utils
#endif

stock ReturnFurnitureName(modelid)
{
	new name[MAX_FURNITURE_NAME];
	name = "N/A";
	for(new i=0; i<sizeof(ConstructionFurniture); i++)
	{
		if(modelid == ConstructionFurniture[i][furniture_model_id])
		{
			strcopy(name,ConstructionFurniture[i][furniture_name]);
			return name;
		}
		else { continue; }
	}
	for(new i=0; i<sizeof(HouseFurniture); i++)
	{
		if(modelid == HouseFurniture[i][furniture_model_id])
		{
			strcopy(name,HouseFurniture[i][furniture_name]);
			return name;
		}
		else { continue; }
	}
	for(new i=0; i<sizeof(OtherFurniture); i++)
	{
		if(modelid == OtherFurniture[i][furniture_model_id])
		{
			strcopy(name,OtherFurniture[i][furniture_name]);
			return name;
		}
		else { continue; }
	}
	return name;
}

GetPointFurnitureCount(pointid) {

	inline furn_CountCheck() {

		new rows;
		cache_get_row_count(rows);

		if(rows) { return rows; }
		else { return false; }
	}
	MySQL_TQueryInline(mysql,using inline furn_CountCheck,"SELECT furniture_id FROM furniture WHERE furniture_point_id = %d",pointid);
	return -1;
}

SetFurnitureViewerInfo(playerid) {

	inline FurnViewInfo() {

		new rows;
		cache_get_row_count(rows);

		if(rows) {

			for(new i=0; i<rows; i++) {

				new Float:x,Float:y,Float:z;
				cache_get_value_name_int(i,"furniture_id",FurnitureViewer[playerid][furn_view_id][i]);
				cache_get_value_name_float(i,"furniture_x_pos",x);
				cache_get_value_name_float(i,"furniture_y_pos",y);
				cache_get_value_name_float(i,"furniture_z_pos",z);
				FurnitureViewer[playerid][furn_view_3d_text_label][i] = CreateDynamic3DTextLabel(sprintf("ID: %d",FurnitureViewer[playerid][furn_view_id][i]),COLOR_RED,x,y,z+0.3,50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid);
			}
			Streamer_Update(playerid,STREAMER_TYPE_3D_TEXT_LABEL);
		}
	}
	MySQL_TQueryInline(mysql,using inline FurnViewInfo,"SELECT furniture_id,furniture_x_pos,furniture_y_pos,furniture_z_pos FROM furniture WHERE furniture_point_id = %d",Point[GetCharacterPointID(playerid)][point_id]);
	return true;
}

ResetFurnitureViewerInfo(playerid) {

	for(new i=0; i<MAX_FURNITURE_LIMIT; i++) {
		
		FurnitureViewer[playerid][furn_view_id][i] = -1;
		if(IsValidDynamic3DTextLabel(FurnitureViewer[playerid][furn_view_3d_text_label][i])) { DestroyDynamic3DTextLabel(FurnitureViewer[playerid][furn_view_3d_text_label][i]); }
	}
	return true;
}

ResetFurnitureBuilderData(playerid) {

	FurnitureBuilder[playerid][furn_builder_mode] = -1;
	if(IsValidDynamicObject(FurnitureBuilder[playerid][furn_builder_add_obj_handler])) { DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_add_obj_handler]); }
	if(IsValidDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler])) { DestroyDynamicObject(FurnitureBuilder[playerid][furn_builder_edit_obj_handler]); }
	FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = -1;
	FurnitureBuilder[playerid][furn_builder_edit_mat_index] = -1;
	FurnitureBuilder[playerid][furn_builder_edit_td_count] = -1;
	return true;
}

GetFurnitureBuilderMode(playerid) { return FurnitureBuilder[playerid][furn_builder_mode]; }
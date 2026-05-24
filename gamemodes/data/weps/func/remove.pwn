Hook_RemovePlayerWeapon(playerid) {

	new query [ 256 ] ;
  
	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_handweapon = 0, character_handammo = 0 WHERE character_id = %d", Character [ playerid ] [ character_id ] ) ;
	mysql_tquery ( mysql, query);

    Character [ playerid ] [ character_handweapon ] = WEAPON_FIST ;
 	Character [ playerid ] [ character_handammo ] = 0 ;

	if(IsPlayerAttachedObjectSlotUsed(playerid,ATTACH_SLOT_HANDS)) { RemovePlayerAttachedObject ( playerid, ATTACH_SLOT_HANDS ) ; }
	ResetPlayerWeaponsEx ( playerid ) ;

	//LoadWeaponPanel ( playerid ) ;

	UpdateWeaponGUI ( playerid ) ;
	//OldLog ( playerid, "guns/script", sprintf ( "[REMOVEPLAYERWEAPON CALLED] %s's guns have been reset.", ReturnUserName ( playerid, false ) )) ;

	return true ;
}
#if defined _ALS_RemovePlayerWeapon
	#undef RemovePlayerWeapon
#else
	#define _ALS_RemovePlayerWeapon
#endif
#define RemovePlayerWeapon Hook_RemovePlayerWeapon

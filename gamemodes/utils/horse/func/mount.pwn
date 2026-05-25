new HorseMountTick [ MAX_PLAYERS ] ;
new HorseMountDirection [ MAX_PLAYERS ] ;

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys) {

    if ( newkeys & KEY_SECONDARY_ATTACK && PlayerHorse [ playerid ] [ IsHorseSpawned ] ) {
        
        if ( IsPlayerRidingHorse [ playerid ] ) {

            new temp_Tick = GetTickCount(), temp_tickDiff ;
            temp_tickDiff = temp_Tick - HorseMountTick[playerid];
            
            if ( temp_tickDiff < 5000) {
            
                return SendServerMessage ( playerid, sprintf("Lütfen at binme fonksiyonunu spamlamayýn. %0.2f saniyelik bekleme süresindesiniz.",float(5000 - temp_tickDiff) / 1000.0), MSG_TYPE_ERROR ) ;
            }       

            HorseMountTick [ playerid ]  = GetTickCount();      

            IsPlayerRidingHorse [ playerid ] = false ;
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_HORSE ) ;

            switch ( HorseMountDirection [ playerid ] ) {

                case 0 : {
                    ApplyAnimation(playerid, "BIKED", "BIKEd_getoffLHS", 4.1, false, false, false, true, 0, SYNC_ALL);
                }

                case 1: {
                    ApplyAnimation(playerid, "BIKED", "BIKEd_getoffRHS", 4.1, false, false, false, true, 0, SYNC_ALL);
                }
            }

            SetTimerEx("DismountHorse", 800, false, "i", playerid);
        }

        else if ( ! IsPlayerRidingHorse [ playerid ] ) {

            new temp_Tick = GetTickCount(), temp_tickDiff ;

            //if ( IsPlayerInDynamicCP(playerid, PlayerMountHorseCP [ playerid ] [ 0 ] ) || IsPlayerInDynamicCP(playerid, PlayerMountHorseCP [ playerid ] [ 0 ] ) ) {
            
            new Float: x, Float: y, Float: z, Float: left_x, Float: left_y,
            Float: right_x, Float: right_y, objectid =  HorseObject [ playerid ] ;
            GetDynamicObjectPos ( HorseObject [ playerid ], x, y, z ) ;

            if ( IsPlayerInRangeOfPoint ( playerid, 2.5, x, y, z ) || ( IsPlayerInDynamicCP(playerid, PlayerMountHorseCP [ playerid ] [ 0 ] ) || IsPlayerInDynamicCP(playerid, PlayerMountHorseCP [ playerid ] [ 0 ] ) )) {


                temp_tickDiff = temp_Tick - HorseMountTick[playerid];

                if ( temp_tickDiff < 5000) {
                
                    return SendServerMessage ( playerid, sprintf("Lütfen at binme fonksiyonunu spamlamayýn. %0.2f saniyelik bekleme süresindesiniz.",float(5000 - temp_tickDiff) / 1000.0), MSG_TYPE_ERROR ) ;
                }       

                HorseMountTick [ playerid ]  = GetTickCount();

                if ( Character [ playerid ] [ character_horsehealth ] <= 0 ) {

                    return SendServerMessage ( playerid, "Atýnýz ölmüþ. Canlandýrmak için bir seyise gidin.", MSG_TYPE_ERROR ) ;
                }

                if ( Character [ playerid ] [ character_handweapon ] != WEAPON_FIST) {

                    return SendServerMessage ( playerid, "Atýnýza binmeden önce silahýnýzý kýlýfýna koymalýsýnýz.", MSG_TYPE_ERROR ) ;
                }
            }



            GetXYInAtOffsetOfObject ( objectid, left_x, left_y, 1.0, 0 ) ;  
            GetXYInAtOffsetOfObject ( objectid, right_x, right_y, 1.0, 180 ) ;
    
            if ( IsPlayerInRangeOfPoint(playerid, 1.0, left_x, left_y, z ) ) {

                ApplyAnimation(playerid, "BIKED", "BIKEd_jumponL", 4.1, false, false, false, true, 0, SYNC_ALL);
                HorseMountDirection [ playerid ] = 0 ;
            }

            else if ( IsPlayerInRangeOfPoint(playerid, 1.0, right_x, right_y, z ) ) {

                ApplyAnimation(playerid, "BIKED", "BIKEd_jumponR", 4.1, false, false, false, true, 0, SYNC_ALL);    
                HorseMountDirection [ playerid ] = 1 ;
            }


            /*if ( IsPlayerInDynamicCP(playerid, PlayerMountHorseCP [ playerid ] [ 0 ] ) ) {

                ApplyAnimation(playerid, "BIKED", "BIKEd_jumponR", 4.1, false, false, false, true, 0, SYNC_ALL);
                HorseMountDirection [ playerid ] = 1 ;
            }

            else if ( IsPlayerInDynamicCP(playerid, PlayerMountHorseCP [ playerid ] [ 1 ] ) ) {

                ApplyAnimation(playerid, "BIKED", "BIKEd_jumponL", 4.1, false, false, false, true, 0, SYNC_ALL);                
                HorseMountDirection [ playerid ] = 0 ;
            }*/

            else return false ;

            new Float: angle ;
            
            if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {

                GetDynamicObjectRot( HorseObject [ playerid ], angle, angle, angle ) ;
            }

            else {

                GetDynamicObjectRot( CowObject [ playerid ], angle, angle, angle ) ;
            }

            SetPlayerFacingAngle ( playerid, angle ) ;

            EquippedItem [ playerid ] = -1 ;
            RemovePlayerAttachedObject(playerid, 6);

            UpdateWeaponGUI ( playerid );
            //Init_LoadPlayerItems ( playerid ) ;

            SetTimerEx("MountHorse", 800, false, "i", playerid);
        }
    }

    #if defined horse_OnPlayerKeyStateChange
        return horse_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange horse_OnPlayerKeyStateChange
#if defined horse_OnPlayerKeyStateChange
    forward horse_OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys);
#endif

forward MountHorse(playerid);
public MountHorse(playerid) {

////    print("MountHorse timer called (mount.pwn)");

    if ( GetPlayerVirtualWorld ( playerid ) || GetPlayerInterior(playerid)) {

        return SendServerMessage ( playerid, "Atý sadece dýþarýdayken çaðýrabilirsiniz.", MSG_TYPE_ERROR ) ;
    }

    //new Float: x, Float: y, Float: z, type = Character [ playerid ] [ SelectedCharacter [ playerid ] ] [ character_horseid ] ;

    if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {
        SetDynamicObjectPos(HorseObject [ playerid ], 0.0, 0.0, 0.0) ;
    }

    else {

        SetDynamicObjectPos(CowObject [ playerid ], 0.0, 0.0, 0.0) ;
    }

    ApplyAnimation(playerid, "BIKED", "BIKEd_Ride", 4.0, true, true, true, true, 0, SYNC_ALL);

    SetPlayerAttachedObject(playerid, ATTACH_SLOT_HORSE, HORSE_OBJECT, 1, -1.64, 0.540, -0.010, 92.7, 73.8, 88.4, 1.0, 1.0, 1.25 );


    PlayerHorse [ playerid ] [ HorseSprintValue ]   = 100 ;
    PlayerHorse [ playerid ] [ HorseAbleToSprint ]  = true ;

    if ( IsValidDynamicCP (PlayerMountHorseCP [ playerid ] [ 0 ] ) ) {
        DestroyDynamicCP( PlayerMountHorseCP [ playerid ] [ 0 ] ) ;
    }
            
    if ( IsValidDynamicCP (PlayerMountHorseCP [ playerid ] [ 1 ] ) ) {
        DestroyDynamicCP( PlayerMountHorseCP [ playerid ] [ 1 ] ) ;
    }

    GUI_ShowHorsePlayerDraws(playerid);
    
    /*
    DestroyPlayerProgressBar(playerid, PlayerHorse [ playerid ] [ HorseSprintBar ] ) ;
    DestroyPlayerProgressBar(playerid, PlayerHorse [ playerid ] [ HorseHealthBar ] ) ;

    TextDrawHideForPlayer ( playerid, TD_HorseSprint ) ;
    TextDrawHideForPlayer ( playerid, TD_HorseHealth ) ;

    PlayerHorse [ playerid ] [ HorseSprintBar ] = CreatePlayerProgressBar(playerid, 265.0, 345.0, 105.0, 10.0, 0xD17F5EFF );
    SetPlayerProgressBarMaxValue(playerid, PlayerHorse [ playerid ] [ HorseSprintBar ], 100);
    SetPlayerProgressBarValue(playerid, PlayerHorse [ playerid ] [ HorseSprintBar  ], PlayerHorse [ playerid ] [ HorseSprintValue ]);
    ShowPlayerProgressBar(playerid, PlayerHorse [ playerid ] [ HorseSprintBar ] ) ;

    TextDrawShowForPlayer ( playerid, TD_HorseSprint ) ;

    PlayerHorse [ playerid ] [ HorseHealthBar ] = CreatePlayerProgressBar(playerid, 265.0, 385.0, 105.0, 10.0, 0xD17F5EFF );
    SetPlayerProgressBarMaxValue(playerid, PlayerHorse [ playerid ] [ HorseHealthBar ], 100);
    SetPlayerProgressBarValue(playerid, PlayerHorse [ playerid ] [ HorseHealthBar  ], Character [ playerid ] [ character_horsehealth ] );
    ShowPlayerProgressBar(playerid, PlayerHorse [ playerid ] [ HorseHealthBar ] ) ;

    TextDrawShowForPlayer ( playerid, TD_HorseHealth ) ;
    */

    SendServerMessage ( playerid, "Eðer gecikme (lag) yaþýyorsanýz, sesli mesajlarý gizlemek için /audiomsg kullanýn veya at seslerini kapatmak için /nohorsesound kullanýn.", MSG_TYPE_INFO ) ;
    SendServerMessage ( playerid, "Eðer oturma animasyonunuz hatalýysa, senkronize etmek için /resynchorse kullanýn.", MSG_TYPE_WARN ) ;

    if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {
        ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s atýna bindi.",ReturnUserName ( playerid, false, true )) ) ;
    }

    else ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s ineðine bindi.",ReturnUserName ( playerid, false, true )) ) ;

    IsPlayerRidingHorse [ playerid ]    = true;

    SetTimerEx("EnableHorseAnimation", 100, false, "i", playerid);

    return true ;
}

forward DismountHorse(playerid);
public DismountHorse(playerid) {

    new Float: x, Float: y, Float: z, Float: angle ;

    GetPlayerPos ( playerid, x, y, z ) ;
    GetPlayerFacingAngle ( playerid, angle ) ;

    switch ( HorseMountDirection [ playerid ] ) {

        case 0 : {
            GetXYInAtOffsetOfPlayer ( playerid, x, y, 1.0, 90 ) ;
        }

        case 1: {
            GetXYInAtOffsetOfPlayer ( playerid, x, y, 1.0, 270 ) ;
        }
    }

    //HorseObject [ playerid ] = CreateDynamicObject ( HORSE_OBJECT, x, y, z - 1.2, 0.0, 0.0, angle - 180 ) ;
/*
    if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {

        SetDynamicObjectPos ( HorseObject [ playerid ], x, y, z - 0.2 ) ;
        SetDynamicObjectRot ( HorseObject [ playerid ], 0.0, -90.0, angle - 180  ) ;

        SetDynamicObjectMaterial(HorseObject [ playerid ], 0, HORSE_OBJECT, "whore_rms", "WH_horse" ) ;
    }
*/
    //else {

    //  SetDynamicObjectPos ( CowObject [ playerid ], x, y, z - 1.2 ) ;
    //  SetDynamicObjectRot ( CowObject [ playerid ], 0.0, 0.0, angle - 180  ) ;
    //}


    new Float: a ;
    GetPlayerFacingAngle(playerid, a);

    SetupHorseObject(playerid, x, y, z, a );

    SetupHorseCheckpoints ( playerid ) ;

    GUI_HideHorsePlayerDraws(playerid);
    //DestroyPlayerProgressBar(playerid, PlayerHorse [ playerid ] [ HorseSprintBar ] ) ;
    //DestroyPlayerProgressBar(playerid, PlayerHorse [ playerid ] [ HorseHealthBar ] ) ;
    
    //TextDrawHideForPlayer(playerid, TD_HorseSprint) ;
    //TextDrawHideForPlayer(playerid, TD_HorseHealth) ;

    ClearAudioForZone ( playerid ) ;

    //OldLog ( playerid, "horse/mounting", sprintf("(%d) %s has dismounted their horse.", playerid, ReturnUserName ( playerid, true ))) ;
    if ( Character [ playerid ] [ character_horseid ] < DONATOR_MOUNT_SLOT ) {
        ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s atýndan indi.",ReturnUserName ( playerid, false, true )) ) ;
    }

    else ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s ineðinden indi.",ReturnUserName ( playerid, false, true )) ) ;

    ClearAnimations ( playerid ) ;
    for(new i=0; i<5; i++) { TogglePlayerControllable ( playerid, true ) ; }

    return true ;
}

SetupHorseObject ( playerid, Float: spawn_x, Float: spawn_y, Float: spawn_z, Float: angle ) {

    if ( IsValidDynamicObject(HorseObject [ playerid ] ) ) {

        DestroyDynamicObject(HorseObject [ playerid ] ) ;
    }


    if ( PlayerSpawnedHorse [ playerid ] == 0 ) {

        //Horse [ horseid ] [ horse_objectid ] = CA_CreateDynamicObject_SC(DONKEY_IDLE_INDEX, spawn_x, spawn_y, spawn_z - 0.2, 0.0, 0, angle + 180, -1, -1, -1, 250.0, 250.0 + 5) ; 
        HorseObject [ playerid ] = CA_CreateDynamicObject_SC(HORSE_OBJECT, spawn_x, spawn_y, spawn_z - 0.2, 0.0, 0, angle + 180, -1, -1, -1, 250.0, 250.0 + 5) ;    
    }
    
    else if ( PlayerSpawnedHorse [ playerid ] > 0 ) {

        //Horse [ horseid ] [ horse_objectid ] = CA_CreateDynamicObject_SC(HORSE_IDLE_INDEX + sizeof(HorseIdleAnim) * PlayerSpawnedHorse [ playerid ], 
            //spawn_x, spawn_y, spawn_z - 0.2, 0.0, -90.0, angle + 270, -1, -1, -1, 250.0, 250.0 + 5) ;

        HorseObject [ playerid ] = CA_CreateDynamicObject_SC(HORSE_IDLE_INDEX + sizeof(HorseIdleAnim) * PlayerSpawnedHorse [ playerid ], 
            spawn_x, spawn_y, spawn_z - 0.2, 0.0, -90.0, angle + 270, -1, -1, -1, 250.0, 250.0 + 5) ;
    }

    Streamer_Update(playerid, STREAMER_TYPE_OBJECT ) ;

}
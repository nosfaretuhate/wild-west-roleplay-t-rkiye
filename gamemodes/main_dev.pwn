//#define OPEN_BETA_TEST
#define UNLOCK_SERVER
#define SERVER_DEV

#if defined OPEN_BETA_TEST
	#warning WARNING: SCRIPT IS IN OPEN BETA MODE
	#warning WARNING: SCRIPT IS IN OPEN BETA MODE
	#warning WARNING: SCRIPT IS IN OPEN BETA MODE
#endif

#if !defined LOG_NEEDED
	#define LOG_NEEDED:%9\32;%0\10;%1 { new LOG_NEEDED; print("LOG_NEEDED: \"%0\""); }
#endif

new PLAYER_MOTD [ 256 ] = "Wild West Roleplay Türkiye'ye hoþ geldin!";
new STAFF_MOTD [ 256 ] = "Artýk {D9AF79}/asoil{DEDEDE} ve {D9AF79}/atrap{DEDEDE} komudu ile çiftlik ve tuzak sistemini deneyebilirsin." ;

#define MIXED_SPELLINGS
#define MAX_PLAYERS 100
//warnings
#pragma warning disable 217, 225, 203
//
#include <open.mp>
//#include <profiler>

#define BODY_PART_TORSO                     (3)
#define BODY_PART_GROIN                     (4)
#define BODY_PART_LEFT_ARM                  (5)
#define BODY_PART_RIGHT_ARM                 (6)
#define BODY_PART_LEFT_LEG                  (7)
#define BODY_PART_RIGHT_LEG                 (8)
#define BODY_PART_HEAD                      (9)

#define IsValidSkin%1(%0)	(((%0)<=299)&&((%0)>=0)&&((%0)!=74))

#define MAX_ATTACHMENTS (5)


#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define PRESSING(%0, %1) (%0 & (%1))
#define RELEASED(%0) ((( newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == ( %0 )))

// YSI stuff
#define CGEN_MEMORY (60000)
#define YSI_NO_KEYWORD_ptask
#define YSI_NO_KEYWORD_task
#include <YSI_Data\y_iterate>
//#include <dialogs>
#include <YSI_Coding\y_inline>

// PawnPlus stuff
#define PP_SYNTAX_AWAIT
#define PP_SYNTAX_STRING_OP
#include <PawnPlus>
#include <PreviewModelDialog>
#include <async-dialogs>
#include <pp-tasks>

// Primary includes
#include <safeDialogs>
//#include <YSF>
//#include <callbacks>
#include <zcmd>
#include <sscanf2>
#include <progress2>
#include <filemanager>

#include <TimestampToDate>
#include <ww_timestamp>
#include <callbacks>
#include <3DTryg>

// Object stuff
#define STREAMER_USE_DYNAMIC_TEXT3D_TAG
#include <streamer>

/*
#if defined STREAMER_OBJECT_SD
#undef STREAMER_OBJECT_SD
#define STREAMER_OBJECT_SD 900.0
#endif
*/
#define GetDynamicObjectModel(%0) Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

#include <ColAndreas>
#include <easybmp>	
#include <virtualcanvas>

#define ZMSG_HYPHEN_END " ..."
#define ZMSG_HYPHEN_START "... "
#include <zmessage>	

#include <samp_bcrypt>

// Custom ww includes
#include <ww_mysql>
#include <strlib> // sprintf and strtrim
#include <ww_angles>
#include <iptrace> // ip lookup script (http://forum.sa-mp.com/showthread.php?t=607276 - author: Banana_Ghost)

//     #include <discord-connector>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define SERVER_SPAWN_X      	(-1358.9551)
#define SERVER_SPAWN_Y      	(2612.5303)
#define SERVER_SPAWN_Z      	(53.5066)
#define SERVER_SPAWN_A      	(51.7536)

#if defined OPEN_BETA_TEST
	#define SERVER_HOSTNAME			"Wild West Roleplay Turkiye - Open Beta Test"
#else
	#define SERVER_HOSTNAME   		"[open.mp] Wild West Roleplay Turkiye"
#endif

#define SERVER_MODE       		"WW-RP v0.2.9b"
#define SERVER_MAP		    	"Tumbleweed v1.1"
#define SERVER_WEBSITE	    	"forum.wildwest-roleplay.com"

#define COLOR_DEFAULT     		(0xDEDEDEFF)
#define COLOR_CLIENT      		(0xAAC4E5FF)
#define COLOR_ACTION      		(0xC2A2DAAA)
#define COLOR_OOC         		(0xAAC4E5FF)

#define COLOR_RED    			(0xFF6347FF)
#define COLOR_YELLOW      		(0xFFFF00FF)
#define COLOR_ORANGE      		(0xFFA500FF)
#define COLOR_BLUE				(0x007FFFFF)
#define COLOR_GREY		  		(0x999999FF)
#define COLOR_GREEN				(0x629C5CFF)

#define COLOR_TAB0				(0x6B5538FF)
#define COLOR_TAB1				(0xBA9E72FF)
#define COLOR_TAB2				(0xDEBD8AFF)

#define ADMIN_RED				(0xCF4040FF)
#define ADMIN_ORANGE    		(0xFFA600FF)
#define ADMIN_YELLOW    		(0xFFF000FF)
#define ADMIN_BLUE      		(0x00A4DBAA)
#define ADMIN_GRAY      		(0x9C9C9CFF)
#define ADMIN_LIGHTGREY     	(0xC4C4C4FF)

#define COLOR_DONATOR			(0xB59664FF)

// Staff-only colors:	
#define COLOR_STAFF				( 0x59BD93FF ) 
#define MODERATOR_COLOR			( 0x449C44FF ) // 408040
#define SUPPORTER_COLOR			( 0x44639CFF )
#define MANAGER_COLOR			( 0xAD2D2DFF )

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enum { // attachments
	ATTACH_SLOT_MASK = 5,
	ATTACH_SLOT_HORSE = 6,
	ATTACH_SLOT_EQUIP = 6,
	ATTACH_SLOT_PANTS = 7,
	ATTACH_SLOT_BACK = 8,
	ATTACH_SLOT_HANDS = 9
}

enum {

	MOD_WARNING_LOW,
	MOD_WARNING_MED,
	MOD_WARNING_HIGH
}

enum {

	MONEY_SLOT_HAND,
	MONEY_SLOT_BANK,
	MONEY_SLOT_PAYC
}

enum {

	ARECORD_TYPE_KICK,
	ARECORD_TYPE_AJAIL,
	ARECORD_TYPE_BAN
}

enum {
	STAFF_NONE,
	STAFF_SUPPORTER,
	STAFF_MODERATOR,
	STAFF_MANAGER
} ;

enum {
	GROUP_NONE = 0,
	TRIAL_MOD = 1,
	BASIC_MOD = 2,
	GENERAL_MOD = 3,
	ADVANCED_MOD = 4
} ;


enum { // Donator levels
	DONATOR_NONE,
	DONATOR_BRONZE,
	DONATOR_SILVER,
	DONATOR_GOLD
} ;

new EquippedItem [ MAX_PLAYERS ] ;
new EquippedItemTile [ MAX_PLAYERS ] ;

new IsPlayerOnAdminDuty [ MAX_PLAYERS ] ;
new IsPlayerOOC 		[ MAX_PLAYERS ] ; 

new bool: IsPlayerInLassoMode [MAX_PLAYERS] = false;
new bool: IsPlayerOnLassoCooldown[MAX_PLAYERS] = false;
new bool: IsPlayerInLasso[MAX_PLAYERS];
new LassoModeTarget [ MAX_PLAYERS ];

new bool:ToggleOOCChat = false;
new IsPlayerHidingOOC [ MAX_PLAYERS ] ;
new PlayerModPMWarning [ MAX_PLAYERS ] = false ;

new ToggleHorseSound [ MAX_PLAYERS ] ;
new zone_Sawmill ;

new HudHidden[MAX_PLAYERS];

// Job vars
new bool: IsMining[MAX_PLAYERS] ;
new bool: IsFishing [ MAX_PLAYERS ] ; 
new bool: IsCuttingTree[MAX_PLAYERS] ;
new bool: IsPlayerFishing [ MAX_PLAYERS ] ;
new Widllife_Harvest_Value [ MAX_PLAYERS ] ;

new LastPaycheckGiven [ MAX_PLAYERS ] ;

// /helpup cmds
new PlayerHelpUpCooldown [ MAX_PLAYERS ] ;
new PlayerRecentlyRevived [ MAX_PLAYERS ] ;

// trap check
new IsPlayerTrapped [MAX_PLAYERS];

// Poker system
#define IsPlayerPlayingPoker(%0) (GetPVarInt(%0,"t_is_in_table"))

#include "assets/header.pwn"

#include "func/rp_name.pwn"
#include "func/nametags/core.pwn"
#include "utils/msgs/core.pwn"
#include "func/misc/func/time.pwn"
#include "func/action_panel.pwn"

// Stores inventory items in an array
//#include "data/inv/func/store.pwn"
#include "data/inv/data/items/data.pwn"


#include "data/account/core.pwn" // account module 
#include "data/weps/func/remove.pwn"
#include "data/skills/core.pwn" // skills module

#include "utils/misc/core.pwn"
#include "utils/horse/base.pwn" // horse
#include "func/anims/core.pwn"
#include "utils/zones/core.pwn" // zones, ambient, weather
#include "func/campfires/header.pwn" //campfires
#include "func/labels/header.pwn" //dynamic labels

#include "data/weps/core.pwn"
#include "data/weps/illegal.pwn"
#include "func/injury/core.pwn" // dmg module
#include "data/staff/core.pwn" // staff module

#include "data/farm/core.pwn" // inv module 
#include "data/inv/core.pwn" // inv module 

#include "data/points/core.pwn" // point
#include "data/points/func/motel.pwn" // point
#include "data/posse/core.pwn"
#include "data/actors/core.pwn"
#include "data/money.pwn"
#include "utils/inv/core.pwn" // handles support-code for inventory script


#include "utils/gui/core.pwn"
#include "func/jobs/core.pwn"
//#include "data/account/ext/tutorial.pwn"

#include "func/misc/core.pwn"
#include "func/object/core.pwn" // object module
#include "func/roleplay_chat.pwn" // ingame RP cmds

#include "func/anticheat/core.pwn"

#include "data/account/func/spawn.pwn"
#include "data/account/func/data.pwn"

#include "utils/transport.pwn"
#include "utils/sessions.pwn"
#include "func/lottery/core.pwn"

#include "func/attachments/core.pwn"

#include "aris/main.pwn"
#include "dignity/main.pwn"


#include "games/blackjack.pwn"
#include "games/poker.pwn"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


main () {

	//Profiler_Start() ;

	mysql_log(ALL);

	MySQL_Init ("omp_wwrp") ;
	Init_Zones () ;

	// We load these before ObjectHandler because
	// it needs to clear data before ObjectHandler to work
	Init_MiningRocks () ;
	Init_WoodcutTrees () ;
	Init_GunCreationArea ( ) ;

	ObjectHandler () ; // handles object stuff (foilage, maploader, roads & removeobjects )
	LoadIntroMap ( ) ; // loads character selection map

	LoadAnimTextDraw ( ) ;
	LoadFaderTextdraw () ;
	//LoadStaticGUITextDraw ( ) ;

	LoadStaticCreationTextDraws () ;
	LoadStaticCharacterSelectDraws ( ) ;
	LoadStaticInventoryExamineGUI ( )  ;
	LoadStaticInventoryTextDraws () ;
	LoadActionGUITextDraws ( ) ;

	LoadHorseSprintTextDraw () ;
	LoadHorseHealthTextDraw () ;
	LoadFurnTextureTD();
	Blackjack_CreateStaticGUI(); 
	//LoadBloodSplatTextures () ;

	// Random stuff:
	ManualVehicleEngineAndLights(), EnableVehicleFriendlyFire();
    DisableInteriorEnterExits(), AllowInteriorWeapons(false);
	DisableNameTagLOS(), ShowNameTags(true);

	ShowNameTags(false); // handles custom name script

	// Anti object removal fix
	Nametags_Init () ;
	GunShells_Init () ;
	Init_Horses () ;
	Init_WantedPosterObjects () ;

    EnableStuntBonusForAll(false);
	SetGameModeText(SERVER_MODE);

	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);

	SendRconCommand("name 		"SERVER_HOSTNAME"");
	SendRconCommand("game.map 	"SERVER_MAP"	");
	SendRconCommand("website 	"SERVER_WEBSITE"");
	#if defined UNLOCK_SERVER
		SendRconCommand("password 0");
	#endif

	// Clearing data for FindEmptyGunSlot
	for ( new i; i < MAX_DROPPED_WEAPONS; i ++ ) {
		
		DroppedWeapon [ i ] = -1 ;
	}

	// Clearing wanted poster data
	for ( new i; i < MAX_POSTERS; i ++ ) {

		WantedPoster [ i ] [ poster_id ] = -1 ;
	}

	// Clearing corpse data
	for ( new i; i < MAX_CORPSES; i ++ ) {

		Corpse [ i ] [ corpse_id ] = -1 ;
	}
	
	// Clearing wound data
	ClearWoundData ( ) ;

	Init_Deers () ;
	Init_Points () ; 
	Init_Furniture();
	Init_LoadActors () ; 
	Init_LoadPosses ( ) ;
	Init_LoadKiosks ( ) ;
	Init_LoadTransmittors ( ) ;
	Init_LoadWantedPosters () ;
	Init_LoadDropItems () ;
	Init_ServerTime () ;

	Init_Motels () ;
	Init_TransportPoints () ;
	Init_TaskLabels ( ) ;
	Init_Fires () ;
	Init_SoilData () ;

	Init_LoadLottery () ;
	Init_Traps();

	// Inv
	Init_LoadDropItems () ;

	Init_LoadPokerTables();

	//dynamic labels
	Init_DynamicLabels();

	// clear dynamite data
	SetupDynamiteData () ; 

	SendASCIILogo () ; // always be last

	// Tutorial label:
	CreateDynamic3DTextLabel("[0] [{DEDEDE}Balýkçýlýk oltasý{A3A3A3}]{DEDEDE}\n~k~~SNEAK_ABOUT~ Tuþu ile alabilirsin.", 0xA3A3A3FF, -1998.5022, -1483.7417, 84.1043, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0 ) ;
	//CreateDynamic3DTextLabel("[Prison Processing Area]\n{DEDEDE}Use /prison to arrest someone.", COLOR_BLUE, -777.8737,769.9468,21.0923, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0 ) ;

	// Bayside fixes to prevent unsolid ground
	new txt_map = CreateDynamicObject(18765, -2374.22510, 2448.69238, 6.13586,   4.00000, 0.00000, -20.82000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2373.52515, 2450.62109, 6.26575,   4.00000, 0.00000, -20.82000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2381.47583, 2451.66675, 6.33982,   3.10000, 0.00000, -20.82000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2380.72876, 2453.36548, 6.33982,   3.10000, 0.00000, -20.82000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2387.30884, 2453.85156, 6.23220,   3.60000, -2.00000, -20.82000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2386.40771, 2455.90161, 6.45519,   3.60000, -2.00000, -20.82000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2422.45166, 2454.12012, 9.74985,   0.00000, 0.00000, 1.08000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2412.58911, 2454.33521, 9.74985,   0.00000, 0.00000, 1.08000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2415.81689, 2457.26074, 9.74985,   0.00000, 0.00000, 1.08000);
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);
	txt_map = CreateDynamicObject(18765, -2418.35571, 2455.53979, 9.74985,   0.00000, 0.00000, 1.08000);	
	SetDynamicObjectMaterial(txt_map, 0, 0, "INVALID", "INVALID", 0xFFFFFFFF);


	zone_Sawmill = CreateDynamicRectangle(-829, 919.5, -776, 964.5);

	Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT,1999);
	//Streamer_SetRadiusMultiplier(STREAMER_TYPE_OBJECT,1.75);

	return true ;
}

#if defined OPEN_BETA_TEST

	ShowBETAMessage(playerid) { 

		ZMsg_SendClientMessage(playerid,-1,"--------------------{FF6347}AÇIK BETA MESAJI{FFFFFF}--------------------");
        ZMsg_SendClientMessage(playerid,-1,"Þu anda Wild West Roleplay Türkiye'nin açýk betasýna katýlýyorsunuz. Lütfen burada geçirdiðiniz süre boyunca bazý hatalarla karþýlaþabileceðinizi unutmayýn; beta sürecinde bulduðunuz hatalarý bildirirseniz çok memnun oluruz.");
        ZMsg_SendClientMessage(playerid,-1,"Bu, sunucunun nihai hali deðildir ve sunucuyu oluþturan tüm özellikler/sistemler deðiþikliðe tabidir. Kurallar bu açýk beta sürecinde de geçerlidir ve bu durumun göz ardý edilmesi cezalandýrýlmayla sonuçlanacaktýr.");
        ZMsg_SendClientMessage(playerid,-1,"Açýk beta sürecinde harika bir deneyim yaþamanýzý diler, sunucu resmi olarak açýldýðýnda da sizi aramýzda görmeyi umarýz.");
        ZMsg_SendClientMessage(playerid,-1,"Saygýlarýmýzla:");
        ZMsg_SendClientMessage(playerid,-1,"Wild West Roleplay Türkiye Yetkili Ekibi");
		ZMsg_SendClientMessage(playerid,-1,"--------------------{FF6347}OPEN BETA MESSAGE{FFFFFF}--------------------");
	}

#endif

public OnGameModeExit () {

	//Profiler_Dump () ;
	return true ;
}

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA: areaid) {

	if ( areaid == zone_Sawmill ) {
		PlayAudioStreamForPlayer(playerid, "http://play.wildwest-roleplay.com/jobs/sawmill.mp3") ;
	}
	
	#if defined main_OnPlayerEnterDynamicArea
		return main_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA: areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea main_OnPlayerEnterDynamicArea
#if defined main_OnPlayerEnterDynamicArea
	forward main_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA: areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA: areaid) {


	if ( areaid == zone_Sawmill ) {

		return cmd_resyncambient(playerid);
	}

	#if defined main_OnPlayerLeaveDynamicArea
		return main_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA: areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea main_OnPlayerLeaveDynamicArea
#if defined main_OnPlayerLeaveDynamicArea
	forward main_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA: areaid);
#endif


ptask Auto_StreamerUpdate[15000](playerid) {

	if ( IsPlayerPlayingPoker(playerid)) {

		return false ;
	}

	return Streamer_Update ( playerid ) ;
}

IsPlayerFree ( playerid ) {

	if ( IsPlayerPlayingPoker(playerid) || IsPlayerInAdminJail [ playerid ] || Character [ playerid ] [ character_dmgmode ] || IsPlayerRidingHorse [ playerid ] || IsPlayerTackled [ playerid ] ) {

		return false ;
	}

	return true ;
}

new PingTicker [ MAX_PLAYERS ],
	PacketLossTicker [ MAX_PLAYERS ] ;


ptask PingWarningClear[120000](playerid) {

////	print("PingWarningClear timer called (main.pwn)");

	if (! PingTicker [ playerid ] ) {

		PingTicker [ playerid ] = 0 ;
	}

	if ( ! PacketLossTicker [ playerid ] ) {

		PacketLossTicker [ playerid ] = 0 ;
	}
 
	return true ;
}

ptask CheckPacketLoss[300000](playerid) {

////    print("CheckPacketLoss timer called (main.pwn)");

    if ( playerid != INVALID_PLAYER_ID && NetStats_PacketLossPercent(playerid) > 10.0 ) {

        SendClientMessage ( playerid, COLOR_RED, sprintf("Senkronizasyonunuz bozuldu! Paket kaybý: %.2f yüzde.", NetStats_PacketLossPercent ( playerid ) ) ) ;

        SendModeratorWarning ( sprintf("[DESYNC] (%d) %s DESYNC OLDU. Paket kaybý: %.2f yüzde. !!! RELOG ATTIRIN !!!", 
            playerid, ReturnUserName ( playerid, true ), NetStats_PacketLossPercent ( playerid ) ), MOD_WARNING_MED ) ;
    }

}
ptask CheckDonatorStatus[1800000](playerid) {

	if ( Account [ playerid ] [ account_donatorlevel ] ) {

		if ( Account [ playerid ] [ account_donatorexpire ] < gettime() ) {

			new query [ 128 ] ;

			Account [ playerid ] [ account_donatorlevel ] = 0 ;
			Account [ playerid ] [ account_donatorexpire ] = 0 ;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_donatorlevel = 0, account_donatorexpire = 0 WHERE account_id = %d", Account [ playerid ] [ account_id ] ) ;
			mysql_tquery ( mysql, query ) ;

			SendServerMessage ( playerid, "Baðýþçý seviyen doldu.", MSG_TYPE_WARN ) ;
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Deprecated: see dignity/update.pwn

CMD:updates ( playerid, params [] ) {

	new string [ 2048 ] ;

	inline ServerUpdateInformation(pid, dialogid, response, listitem, string:inputtext[] ) { 
		#pragma unused pid, dialogid, response, listitem, inputtext

	}

	strcat ( string, "Last Updated: [x/02/2019]\n\nAdditions:\n\n" ) ;

	strcat ( string, "Farming system has been added, you can buy the necessities at the general store and blacksmith.\n" ) ;

	strcat ( string, "Trap system has been added, you can buy a trap at the blacksmith and place baits on it to catch animals. (and humans, sometimes).\n" ) ;
	
	strcat ( string, "\nChanges:\n\n" ) ;

	strcat ( string, "Bayside has been removed and replaced with some new mountain mapping.\nHorse system has been improved with animations.\n" ) ;

	strcat ( string, "El Quebrados is now Longcreek with some new fresh mapping.\n" ) ;

	strcat ( string, "\nRemoved:\n\n" ) ;

	strcat ( string, "None\n" ) ;

	Dialog_ShowCallback ( playerid, using inline ServerUpdateInformation, DIALOG_STYLE_MSGBOX, "Wild West Roleplay - Current Updates", string, "Exit" ) ;
	return true ;
}*/

CMD:logout( playerid, params [] ) {

	if ( ! LogoutPermission [ playerid ] ) {

		return SendServerMessage ( playerid, "Bu komutu kullanmak yetkin yok.", MSG_TYPE_ERROR ) ;
	}

	SetCharacterLoggedPosition ( playerid ) ;

	LogoutPermission [ playerid ] = false ;
	PassedSelectionScreen [ playerid ] = false ;

	HideGUITextDraws ( playerid ) ;
	HideCharacterTextDraws ( playerid ) ;
	HideCreationTextDraws ( playerid ) ;

	DestroyCreationTextDraws ( playerid ) ;
	DestroyCharacterTextDraws ( playerid ) ;

	SetDynamicObjectPos ( HorseObject [ playerid ], 0.0, 0.0, 0.0 ) ;
	SetDynamicObjectPos ( CowObject [ playerid ], 0.0, 0.0, 0.0 ) ;

	SetPlayerName(playerid, Account [ playerid ] [ account_name ] ) ;
	SetPlayerScore(playerid,0);
	SetPlayerColor ( playerid, 0x000000FF) ;

	ClearData ( playerid ) ;

	Account_ConnectionCheck ( playerid ) ;

	//OldLog ( playerid, "acc/logout", sprintf("(%d) %s used /logout", playerid, ReturnUserName ( playerid, true ) ) ) ;

	return true ;
}

CMD:clearchat(playerid, params [] ) {

	for ( new i; i < 20; i ++ ) {

		SendClientMessage( playerid, -1, " " ) ;
	}

	return true ;
}

CMD:safezone ( playerid, params [] ) {

     if ( IsPlayerInRangeOfPoint(playerid, 50, -828.4460, 1087.0280, 38.9719) ) {

        SendServerMessage ( playerid, "Baþlangýç noktasýnýn yakýnýndaki bir güvenli bölgedesiniz, ancak bu sadece bu bölgeden ayrýlana kadar geçerlidir.", MSG_TYPE_WARN ) ;
        return SendServerMessage ( playerid, "Sonrasýnda geri dönerseniz, güvenli bölge kuralý uyarýnca artýk güvende olmayacaksýnýz.", MSG_TYPE_WARN ) ;
    }

	if ( GetPlayerVirtualWorld(playerid) == 0 ) {
		if ( IsZoneSafeZone ( GetPlayerZone ( playerid ) ) ) {

			return SendServerMessage ( playerid, "Güvenli bölgedesin.", MSG_TYPE_INFO ) ;
		}
	}

	else if ( GetPlayerVirtualWorld(playerid) != 0 ) {

		for ( new i; i < MAX_POINTS; i ++ ) {

			if ( Point [ i ] [ point_id ] != -1 ) {

				if ( IsPlayerInRangeOfPoint(playerid, 25.0, Point [ i ] [ point_int_x ],  Point [ i ] [ point_int_y ], Point [ i ] [ point_int_z ] ) && GetPlayerVirtualWorld ( playerid ) == Point [ i ] [ point_int_vw ] && GetPlayerInterior ( playerid ) == Point [ i ] [ point_int_int ] ) {

					if ( IsZoneSafeZone ( GetZone ( Point [ i ] [ point_ext_x ], Point [ i ] [ point_ext_y ] ))) {

						return SendServerMessage ( playerid, "Güvenli bölgedesin.", MSG_TYPE_INFO ) ;
					}

					else continue ;
				}

				else continue ;
			}

			else continue ;
		}
	}

	return SendServerMessage ( playerid, "Güvenli bölgede deðilsin.", MSG_TYPE_ERROR ) ;
}

CMD:servertime ( playerid, params [] ) {

	SendServerMessage ( playerid, sprintf("{DEDEDE}OOC SAAT [[VPS/SERVER HOST]] saat/tarih %s(GMT +1)", ReturnDateTime () ), MSG_TYPE_INFO) ;

	return true ;
}

CMD:help ( playerid, params [] ) { 

    task_yield(1);

    new dialog_response[e_DIALOG_RESPONSE_INFO];
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Yardým - Bir Kategori Seçin","Komutlar\nSýkça Sorulan Sorular","Seç","Çýkýþ");
    
    if(dialog_response[E_DIALOG_RESPONSE_Response]) {

        if(dialog_response[E_DIALOG_RESPONSE_Listitem] == 0) {

            SendClientMessage(playerid, COLOR_TAB0, "|________________________| Kullanabileceðiniz komutlarýn listesi |________________________|" ) ;
            SendClientMessage(playerid, COLOR_TAB1, "[GENEL]:{DEDEDE} /spawn, /report, /ask, /id, /staff, /afklist, /animlist, /resyncambient, /safezone, /badge, /editmask" ) ;
            SendClientMessage(playerid, COLOR_TAB2, "[GENEL]:{DEDEDE} /accept, /shakehand, /clearchat, /accent, /coin, /checktime, /roll, /frisk, /pay, /bank, /paycheck" ) ;
            SendClientMessage(playerid, COLOR_TAB1, "[GENEL]:{DEDEDE} /ad(vertise), /setchat, /attributes, /examine, /charity, /servertime, /showinjuries, /namechange, /blockpm" ) ;
            SendClientMessage(playerid, COLOR_TAB2, "[GENEL]:{DEDEDE} /checkjobcooldown (/cooldown), /resyncmask, /resynchorse, /nohorsesound, /gunpos, /licenses, /drink" ) ;
            SendClientMessage(playerid, COLOR_TAB2, "[GENEL]:{DEDEDE} /prisontimeleft, /bail, /fixjob, /helpup, /transport, /reloadattachments" ) ;
            SendClientMessage(playerid, COLOR_TAB2, "[GENEL]:{DEDEDE} /mypoints, /rentroom, /adminrecord, /streamdis, /attachments, /createdynamiclabel" ) ;
            SendClientMessage(playerid, COLOR_TAB1, "[DÝÐER]:{DEDEDE} /ac, /accentlist, /acchelp, /bountyhelp, /chathelp, /gunhelp, /horsehelp, /point, /samphelp, /possehelp, /possechat" ) ;

            if ( IsPlayerStaff ( playerid ) ) {

                SendClientMessage(playerid, COLOR_STAFF, "[YETKÝLÝ]:{DEDEDE} /staffhelp") ;
            }
        }
        else if(dialog_response[E_DIALOG_RESPONSE_Listitem] == 1) {

            SendSplitMessage(playerid, COLOR_TAB0, "|________________________| Sýkça Sorulan Sorular (SSS) |________________________|" ) ;
            SendSplitMessage(playerid, COLOR_TAB1, "1.{DEDEDE} Nereden baþlamalýyým?" ) ;
            SendSplitMessage(playerid, COLOR_TAB2, "- Bir avcýlýk maðazasýndan olta satýn alarak baþlamanýzý ve balýk tutmak için herhangi bir su kütlesi bulmanýzý öneririz. Balýklarýnýzý satmaya karar verdiðinizde, yakaladýklarýnýzý satmak için bir avcýlýk maðazasýna gidin." ) ;
            SendSplitMessage(playerid, COLOR_TAB1, "2.{DEDEDE} Nasýl at alabilirim?");
            SendSplitMessage(playerid, COLOR_TAB2, "- Longcreek veya Fremont'taki bir seyise gidin, ardýndan /buy yazýn.");
            SendSplitMessage(playerid, COLOR_TAB1, "3.{DEDEDE} Bir yeteneðin seviyesini nasýl yükseltirim?");
            SendSplitMessage(playerid, COLOR_TAB2, "- /levelup [yetenek adý]");
            SendSplitMessage(playerid, COLOR_TAB1, "4.{DEDEDE} Bir binaya nasýl girerim?");
            SendSplitMessage(playerid, COLOR_TAB2, "- H tuþuna basýn (veya \"Grup Kontrolü Geriye\" iþlevi için hangi tuþu atadýysanýz o tuþa basýn).");
            SendSplitMessage(playerid, COLOR_TAB0, "");
            SendSplitMessage(playerid, 0xDEDEDEFF, "Burada olmayan herhangi bir sorunuz varsa, /ask komutunu kullanmaktan veya rehberlere göz atmak için forumlarý kontrol etmekten çekinmeyin!");
        }
    }

    return true ;
}

CMD:rules(playerid) {

    new rules[2048];
    strcat(rules,"1. OOC iþareti verilmediði sürece her zaman rol yapmak zorundasýnýz.\n");
    strcat(rules,"2. Diðer SA-MP topluluklarýnýn reklamýný yapmak yasaktýr.\n");
    strcat(rules,"3. Size veya bir gruba diðerlerine karþý avantaj saðlayabilecek 3. parti modlar yasaktýr.\n");
    strcat(rules,"4. Metagaming, powergaming, deathmatching ve revenge killing yasaktýr.\n");
    strcat(rules,"5. Sunucu hatalarýný veya oyun açýklarýný kötüye kullanmayýn.\n");
    strcat(rules,"6. Belirli þartlar karþýlanmadýðý sürece güvenli bölgelerde suç iþleyemezsiniz. (foruma bakýn)\n");
    strcat(rules,"7. Cinsel veya açýk içerikli roller halka açýk alanlarda yapýlmamalýdýr ve her iki tarafýn da iznini gerektirir.\n");
    strcat(rules,"8. Birinden 60 dolardan fazla soyamaz veya birini 1.500 dolardan fazla dolandýramazsýnýz. Sürece dahil olan her iki tarafýn da en az 5 seviye olmasý gerekir.\n");
    strcat(rules,"9. Karakterinizi canlandýrýrken, dönemin zaman dilimine uygun þekilde rol yapmalýsýnýz (foruma bakýn).\n\n");
    strcat(rules,"Kurallarýn daha fazla detayý ve anlaþýlmasý için lütfen onlara forumdan göz atýn.");

    ShowPlayerDialog(playerid,9999,DIALOG_STYLE_MSGBOX,"Wild West Roleplay Türkiye - Kurallar",rules,"Çýkýþ","");
    return true;
}

CMD:horsehelp ( playerid, params [] ) {

    SendClientMessage(playerid, COLOR_TAB0, "|________________________| At Yardýmý |________________________|") ;

    SendClientMessage(playerid, COLOR_TAB1, "/respawnhorse:{DEDEDE} Tekrar /spawnhorse kullanabilmeniz için at verilerinizi siler.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/spawnhorse:{DEDEDE} Ölü veya iþlevsiz olmadýðý sürece atýnýzý yanýnýzda canlandýrýr.") ;
    SendClientMessage(playerid, COLOR_TAB1, "/revivehorse:{DEDEDE} Öldürülen atýnýzý seyiste küçük bir ücret karþýlýðýnda canlandýrýr.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/toghorsetds:{DEDEDE} At textdraw'larýný açar/kapatýr, ekran görüntüleri için kullanýþlýdýr.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/resynchorse{DEDEDE} At animasyonunu senkronize eder." ) ;
    SendClientMessage(playerid, COLOR_TAB2, "/nohorsesound{DEDEDE} At seslerini açar/kapatýr." ) ;

    return true ;
}

CMD:gunhelp ( playerid, params [] ) {

    SendClientMessage(playerid, COLOR_TAB0, "|________________________| Silah Yardýmý |________________________|") ;

    SendClientMessage(playerid, COLOR_TAB1, "(/guns): /holstered:{DEDEDE} Tüm silahlarýnýzý, slotlarýný ve mermilerini görüntüler.") ;
    SendClientMessage(playerid, COLOR_TAB2, "(/gh, /guh): /holster, /unholster:{DEDEDE} Belirtilen slottaki silahýnýzý kýlýfa koyar/kýlýftan çýkarýr.") ; 
    SendClientMessage(playerid, COLOR_TAB1, "(/sgun): /switchgun:{DEDEDE} Kuþandýðýnýz silahý kýlýftaki bir silahla deðiþtirir.") ; 
    SendClientMessage(playerid, COLOR_TAB2, "(/dgun, /pgun): /dropgun, /pickupgun:{DEDEDE} Silahý yere býrakýr veya yerdeki silahý alýr.") ; 
    SendClientMessage(playerid, COLOR_TAB2, "/ammocrate:{DEDEDE} Kuþandýðýnýz silahýn mermisini doldurmak için bir mühimmat sandýðý kullanýn.") ; 
    SendClientMessage(playerid, COLOR_TAB2, "/passgun:{DEDEDE} Silahýnýzý baþka birine teslim eder.") ; 
    SendClientMessage(playerid, COLOR_TAB2, "/gunpos:{DEDEDE} Kýlýf pozisyonlarýnýzý deðiþtirir [kaydedilmez].") ; 

    return true ;
}

CMD:samphelp ( playerid, params [] ) {
    SendClientMessage(playerid, COLOR_TAB0, "|________________________| SA-MP Komut Yardýmý |________________________|") ;

    SendClientMessage(playerid, COLOR_TAB1, "Not: Daha fazla komut vardýr, bu liste sadece sizin için yararlý olan komutlarý gösterir. Tam liste için {DEDEDE}http://wiki.sa-mp.com/wiki/Client_Commands adresine gidin.") ;
    SendClientMessage(playerid, COLOR_TAB2,"/timestamp:{DEDEDE} Her sohbet mesajýnýn önünde SA/DA/SN þeklinde zaman damgasý gösterir." ) ;
    SendClientMessage(playerid, COLOR_TAB1,"/headmove:{DEDEDE} Tüm oyuncular için kafa hareketini devre dýþý býrakýr (ekran görüntüleri için kullanýþlýdýr)." ) ;
    SendClientMessage(playerid, COLOR_TAB2,"/pagesize:{DEDEDE} Görüntülenen sunucu mesajý satýr sayýsýný artýrýr (yüksek çözünürlükler için kullanýþlýdýr)." ) ;
    SendClientMessage(playerid, COLOR_TAB1,"/fpslimit:{DEDEDE} FPS deðerinizi sýnýrlar. En iyi kararlýlýk ve performans için 60'ta tutulmalýdýr." ) ;
    SendClientMessage(playerid, COLOR_TAB2,"/audiomsg:{DEDEDE} Sunucu bir ses dosyasý oynattýðýnda çýkan yeþil ses mesajlarýný devre dýþý býrakýr." ) ;
    SendClientMessage(playerid, COLOR_TAB1,"/fontsize:{DEDEDE} Sunucu mesajlarýnýn yazý tipi boyutunu artýrýr (yüksek çözünürlükler için kullanýþlýdýr)." ) ;

    return true ;
}

CMD:acchelp ( playerid, params [] ) {

    SendClientMessage(playerid, COLOR_TAB0, "|________________________| Hesap Yardýmý |________________________|") ;

    SendClientMessage(playerid, COLOR_TAB1, "/selectcharacter:{DEDEDE} Seçim menüsünden bir karakter seçmenize olanak tanýr.") ;
    SendClientMessage(playerid, COLOR_TAB1, "/logout:{DEDEDE} Ýzin verildikten sonra giriþ ekranýna gitmenize olanak tanýr.");
    SendClientMessage(playerid, COLOR_TAB2, "/relog:{DEDEDE} Sorunlarý düzeltmek için giriþ ekranýnda veya karakter seçiminde kullanýlabilir.");
    SendClientMessage(playerid, COLOR_TAB1, "/statistics, /stats:{DEDEDE} Oyuna giriþ yapmýþ karakterinizin istatistiklerini görüntüler.");

    return true ;
}

CMD:chathelp ( playerid, params [] ) {

    SendClientMessage(playerid, COLOR_TAB0, "|________________________| Sohbet Yardýmý |________________________|") ;

    SendClientMessage(playerid, COLOR_TAB1, "/me(low), /my(low), /do(low):{DEDEDE} Karakterinizin bir rol eylemi gerçekleþtirmesini saðlar.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/s(hout), /low:{DEDEDE} Karakterinizin belirli bir þekilde bir þey söylemesini saðlar.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/w(hisper):{DEDEDE} Biriyle IC olarak özelden iletiþim kurmanýzý saðlar.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/b, /o(oc), /pm:{DEDEDE} OOC (Karakter Dýþý) olarak iletiþim kurmanýzý saðlar.") ;
    SendClientMessage(playerid, COLOR_TAB1, "/ame, /ado:{DEDEDE} Karakterinizin bir rol eylemi gerçekleþtirmesini saðlar ancak yerel sohbete mesaj göndermez.") ;
    SendClientMessage(playerid, COLOR_TAB2, "** /ame veya /ado yerel sohbete mesaj göndermez, bunun yerine eylemi karakterinizin baþýnýn üzerinde gösterir.") ;
    
    return true ;
}

CMD:bountyhelp ( playerid, params [] ) {

    SendClientMessage(playerid, COLOR_TAB0, "|________________________| Ödül Avcýlýðý Yardýmý |________________________|") ;

    SendClientMessage(playerid, COLOR_TAB1, "/takebounty:{DEDEDE} Bir afiþin yakýnýndaysanýz ödül avý görevini almanýzý saðlar. Afiþ ID'sini belirtmek için isteðe baðlý parametreyi kullanýn.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/abandonbounty:{DEDEDE} Mevcut ödül avý görevinizi býrakmanýzý saðlar.") ;
    SendClientMessage(playerid, COLOR_TAB1, "/pickbounty:{DEDEDE} Öldürdüðünüz ödül hedefini yerden almanýzý saðlar.") ;
    SendClientMessage(playerid, COLOR_TAB2, "/claimbounty:{DEDEDE} Ödül avý için ödülünüzü talep etmenizi saðlar.") ;
    return true ;
}

CMD:licenses ( playerid, params [] ) {

	new target ;

	if ( sscanf ( params, "u", target ) ) {

		return SendServerMessage ( playerid, "/licenses [oyuncuid]", MSG_TYPE_ERROR ) ;
	}

	if ( ! IsPlayerConnected(target )) {

		return SendServerMessage ( playerid, "Böyle bir oyuncu bulunamadý.", MSG_TYPE_ERROR ) ;
	}

	new Float: x, Float: y, Float: z;
	GetPlayerPos ( target, x, y, z ) ;

	new Float: yds = GetPlayerDistanceFromPoint(playerid, x, y, z ) ;

	if ( yds > 10.0 ) {

		return SendServerMessage ( playerid, "Hedefe yeterince yakýn deðilsin.", MSG_TYPE_ERROR ) ;
	}

	SendClientMessage(target, COLOR_TAB0, sprintf("(%d) %s Adlý oyuncunun lisanslarý.", playerid, ReturnUserName ( playerid, true, true ) ) ) ;

	new hasitem [ 16 ] ;

	if ( DoesPlayerHaveItem ( playerid, CARD_PASSPORT) != -1 ) {

		hasitem = "{406E3B}evet" ;
	}

	else hasitem = "{A12F2F}hayýr" ;

	SendClientMessage(target, COLOR_TAB1, sprintf("[Pasaport]: %s", hasitem ) ) ;


	if ( DoesPlayerHaveItem ( playerid, CARD_GUNPERMIT) != -1 ) {

		hasitem = "{406E3B}evet" ;
	}

	else hasitem = "{A12F2F}hayýr" ;

	SendClientMessage(target, COLOR_TAB2, sprintf("[Silah Lisansý]: %s", hasitem ) ) ;

	SendServerMessage ( playerid, sprintf("Lisanslarýný (%d) %s adlý oyuncuya gösterdin.", target, ReturnUserName ( target, true, true )), MSG_TYPE_ERROR ) ;
	ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s lisanslarýný %s adlý kiþiye gösterir.", ReturnUserName ( playerid, true, true ), ReturnUserName ( target, true, true ) ) )   ;

	return true ;
}

CMD:id ( playerid, params [] ) {

    if ( IsNumeric ( params ) ) {

    	if ( ! IsPlayerConnected ( strval ( params ) ) ) {

    		return SendClientMessage(playerid, COLOR_TAB2, "Oyuncu bulunamadý.");
    	}

	    SendClientMessage(playerid, COLOR_TAB0, sprintf("[arama sonuçlarý '%s']", params ));
		SendClientMessage(playerid, COLOR_TAB1, sprintf("%s (ID:%i)",  ReturnUserName ( strval ( params ), false, false), strval ( params )  ) );
    }

    else if (! IsNumeric ( params ) ) {

		if ( strlen( params ) < 3 ) {

	       	return SendServerMessage ( playerid, "/id [isim] - en az 3 karakter girin", MSG_TYPE_ERROR ) ;
	    }

	    new count ;

	    SendClientMessage(playerid, COLOR_TAB0, sprintf("[arama sonuçlarý '%s']", params));

	    foreach(new i: Player ) {
	        new rname [ MAX_PLAYER_NAME ];
	        GetPlayerName(i, rname, sizeof ( rname ) ) ;

	    	if ( strfind ( rname, params, true ) != -1 ) {

				count ++;
				SendClientMessage(playerid, COLOR_TAB1, sprintf("%i. %s (ID:%i)", count, rname, i));
			}
	    }

	    if ( count == 0 ) {

	    	return SendClientMessage(playerid, COLOR_TAB2, "Oyuncu bulunamadý.");
	    }
	}

	return true ;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public OnPlayerConnect( playerid ) {
	RemoveBuildings ( playerid ) ;

	LoadZoneTextDraws ( playerid ) ;
	//LoadGUITextDraws ( playerid ) ;
	LoadPlayerInventoryExamineGUI ( playerid ) ;
	LoadInventoryTextDraws ( playerid )  ;
	LoadPlayerActionTextDraws ( playerid ) ;
	LoadWantedPosterTextDraws ( playerid ) ;
	Blackjack_CreatePlayerGUI(playerid) ;
	BJ_ResetVariables(playerid) ;

	TogglePlayerSpectating ( playerid, true ) ;

//	SendModeratorWarning ( sprintf("[CONNECT] (%d) %s has connected to the server {FFFF00}[%s]", playerid, ReturnUserName ( playerid, true ), ReturnIP ( playerid )), MOD_WARNING_LOW);
	//OldLog ( playerid, "acc/connect", sprintf("(%d) %s has connected to the server [%s]", playerid, ReturnUserName ( playerid, true ), ReturnIP ( playerid ) ) ) ;

	SetPlayerColor ( playerid, 0x000000FF) ;
 	Account_ConnectionCheck ( playerid ) ;

 	return true ;
}

public OnPlayerDisconnect(playerid, reason) {

    ResetPlayerWounds ( playerid ) ;

	TextDrawHideForPlayer(playerid, TD_HorseSprint) ;
	PlayerTextDrawDestroy(playerid, TD_ZoneName ) ;

	DestoryWantedPosterTDs ( playerid ) ;
	DestroyCreationTextDraws ( playerid ) ;
	DestroyCharacterTextDraws ( playerid ) ;
	DestroyPlayerInventoryGUI ( playerid ) ;
	DestroyGUITextDraws ( playerid ) ;
	DestroyPlayerActionGUI ( playerid ) ;
	BJ_DestroyTDs(playerid);

	SetDynamicObjectPos ( HorseObject [ playerid ], 0.0, 0.0, 0.0 ) ;
	SetDynamicObjectPos ( CowObject [ playerid ], 0.0, 0.0, 0.0 ) ;

/*
	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	foreach(new i: Player) {

		if ( IsPlayerInRangeOfPoint(i, 2.5, x, y, z)){

			SendClientMessage(i, 0xDEDEDEFF, sprintf("[DISCONNECT] (%d) %s has just left the server, reason: %s", playerid, ReturnUserName ( playerid, true ), dc_reasons [ reason ])) ;
			continue ;
		}

		else continue ;
	}*/

	new dc_reason[3][] = {
        "Timeout/Crash",
        "Quit",
        "Kick/Ban"
    };

    ProxDetector(playerid, 15.0 , COLOR_CLIENT, sprintf("[AYRILDI] (%d) %s adlý oyuncu %s sebebi ile sunucudan ayrýldý.", 
        playerid, ReturnUserName ( playerid ), dc_reason [ reason ] ));

	//SendModeratorWarning ( sprintf("[DISCONNECT] (%d) %s has just left the server, reason: %s", playerid, ReturnUserName ( playerid, true ), dc_reasons [ reason ] ), MOD_WARNING_LOW);

	return true ;
}

public OnPlayerRequestClass(playerid, classid) {

	return OnPlayerSpawn ( playerid );
}

public OnPlayerRequestSpawn(playerid) {
	
	return OnPlayerSpawn ( playerid ) ;
}

public OnPlayerSpawn(playerid) {

	IsPlayerSpectating [ playerid ] = INVALID_PLAYER_ID ;

	if ( IsPlayerModerator ( playerid ) ) {

		PlayerModWarnings [ playerid ] = true ; 
	}

	return true ;
}

CMD:reloadattachments ( playerid, params [] ) {

	Init_LoadPlayerAttachments ( playerid ) ;
	SetupPlayerGunAttachments ( playerid ) ;

	return SendServerMessage ( playerid, "Silah ve oyuncu aksesuarlarý yeniden yüklendi.", MSG_TYPE_WARN ) ;
}

ReloadPlayerAttachments ( playerid ) {

	Init_LoadPlayerAttachments ( playerid ) ;
	SetupPlayerGunAttachments ( playerid ) ;
	return true ;
}

public OnPlayerDeath ( playerid, killerid, WEAPON: reason ) {

	Player_ClientDeath [ playerid ] = true ;

	return true ;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, CLICK_SOURCE:source){

	if ( IsPlayerModerator ( playerid ) ) {
	    new stats[ 512 ];

	    GetPlayerNetworkStats ( clickedplayerid, stats, sizeof ( stats ) ) ; // get your own networkstats
	    ShowPlayerDialog ( playerid, 0, DIALOG_STYLE_MSGBOX, "Oyuncu Ýnternet Ýstatistikleri", stats, "Tamam", "" ) ;

 		ShowPlayerStatistics ( playerid, clickedplayerid ) ;
	}

    return true ;
}


public OnPlayerShootDynamicObject ( playerid, weaponid, objectid, Float:x, Float:y, Float:z ) {

	for ( new i; i < MAX_WILDLIFE; i ++ ) {

		if ( Wildlife [ i ] [ wildlife_object ] == objectid ) {

			Wildlife_Shot(objectid, weaponid);
			if ( DoingTask [ playerid ] == 6 ) {

				ProcessTask ( playerid, DoingTask [ playerid ] ) ;
			}
		}
	}

	return 1;
}

public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ) {

	CheckPlayerHackedWeapons ( playerid, weaponid ) ;

	if ( Character [ playerid ] [ character_handweapon ] != GetPlayerWeapon ( playerid) ) {

		SendModeratorWarning (sprintf("(%d) %s silah hilesi kullanýyor olmalý.", playerid, ReturnUserName ( playerid )), MOD_WARNING_HIGH ) ;
		ResetPlayerWeapons ( playerid ) ;
		return false ;
	}

	Character [ playerid ] [ character_handammo ] -- ;
	if ( Character [ playerid ] [ character_handammo ] < 1 ) {

 		SetPlayerAttachedObject(playerid, ATTACH_SLOT_HANDS, ReturnWeaponObject ( playerid ), 6, 0.004, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0 );
		ResetPlayerWeaponsEx ( playerid ) ;

		SendServerMessage ( playerid, "Silahýnýn mermisi bitti eðer halen ekranýn sallanýyorsa: /fa (/fixaim).", MSG_TYPE_ERROR ) ;

		SetPlayerDrunkLevel(playerid, 1) ;
		//OldLog ( playerid, "guns/ammo", sprintf ( "%s has ran out of ammo.", ReturnUserName ( playerid, false ) )) ;
	}

	else {

		if ( GetShootRate ( playerid ) ) { 
		
			CheckCBug ( playerid, weaponid, GetShootRate ( playerid ) ) ;
		}

		SetShootRate ( playerid ) ;
	}

	CreatePlayerGunShell ( playerid ) ;

	UpdateWeaponGUI ( playerid ) ;
	SavePlayerWeapons ( playerid ) ;

	return true ;
}

public OnPlayerStreamIn(playerid) {
	Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL );
	return true ;
}

public OnPlayerSelectDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, modelid, Float:x, Float:y, Float:z) {

    if(FurnitureBuilder[playerid][furn_builder_mode] != -1) {

        if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT) {

            for(new i=0; i<MAX_FURNITURE_LIMIT; i++) {
                
                if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_handler][i] == objectid) {
                
                    FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = objectid;
                    FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i];
                    ResetFurnitureViewerInfo(playerid);
                    EditDynamicObject(playerid, FurnitureBuilder[playerid][furn_builder_edit_obj_handler]);
                    return SendServerMessage(playerid,"Mobilyayý hareket ettirin ve yerleþimini kaydetmek için \"Kaydet\" ikonuna týklayýn.",MSG_TYPE_INFO);
                }
                continue;
            }
            //ResetFurnitureViewerInfo(playerid);
            //FurnitureBuilder[playerid][furn_builder_mode] = -1;
            SendServerMessage(playerid,"Bir þeyler ters gitti, taþýmak istediðiniz nesneye tekrar týklamayý deneyin.",MSG_TYPE_ERROR);
            SendServerMessage(playerid,"Eðer bu iþe yaramazsa, /editfurni(ture)object komutunu kullanýn.",MSG_TYPE_ERROR);
        }

        else if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_EDIT_TEXTURE) {

            for(new i=0; i<MAX_FURNITURE_LIMIT; i++) {
                
                if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_handler][i] == objectid) {

                    new string[512];
                    ResetFurnitureViewerInfo(playerid);
                    CancelEdit(playerid);

                    for(new j=0; j<15; j++) {

                        format(string,sizeof(string),"%sMateryal Endeksi %d\n",string,j);
                    }

                    task_yield(1);

                    new dialog_response[e_DIALOG_RESPONSE_INFO];
                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Mobilya Düzenleme - Materyal Endeksleri",string,"Seç","Çýkýþ");

                    if(!dialog_response[E_DIALOG_RESPONSE_Response]) {

                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        return cmd_point(playerid,"furni");
                    }

                    FurnitureBuilder[playerid][furn_builder_edit_mat_index] = dialog_response[E_DIALOG_RESPONSE_Listitem];
                    FurnitureBuilder[playerid][furn_builder_edit_td_count] = 0;
                    FurnitureBuilder[playerid][furn_builder_edit_obj_handler] = objectid;
                    FurnitureBuilder[playerid][furn_builder_edit_obj_db_id] = FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i];
                    SetDynamicObjectMaterial(FurnitureBuilder[playerid][furn_builder_edit_obj_handler],FurnitureBuilder[playerid][furn_builder_edit_mat_index],FurnitureMaterialInfo[0][furniture_texture_modelid],FurnitureMaterialInfo[0][furniture_texture_txd_name],FurnitureMaterialInfo[0][furniture_texture_texture_name]);
                    ShowTextureEditTD(playerid);
                    SelectTextDraw(playerid,0xFFFFFF55);
                    return 1;
                }
            }
            SendServerMessage(playerid,"Bir þeyler ters gitti, kaldýrmak istediðiniz nesneye tekrar týklamayý deneyin.",MSG_TYPE_ERROR);
            SendServerMessage(playerid,"Eðer bu iþe yaramazsa, /removefurni(ture)object komutunu kullanýn.",MSG_TYPE_ERROR);
        }
        else if(FurnitureBuilder[playerid][furn_builder_mode] == FURNI_DELETE) {

            for(new i=0; i<MAX_FURNITURE_LIMIT; i++) {
                
                if(FurnitureObject[GetCharacterPointID(playerid)][furn_object_handler][i] == objectid) {
                    
                    ResetFurnitureViewerInfo(playerid);
                    CancelEdit(playerid);

                    task_yield(1);

                    new dialog_response[e_DIALOG_RESPONSE_INFO];
                    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_MSGBOX,"Mobilya Silme","UYARI: Silmek için bir mobilya nesnesi seçtiniz.\nBu diyalog, mobilya nesnesinin yanlýþlýkla silinmesini önlemek içindir.\nKararýnýzdan eminseniz \"Onayla\" butonuna týklayýn.", "Onayla", "Ýptal");

                    if(!dialog_response[E_DIALOG_RESPONSE_Response]) {

                        FurnitureBuilder[playerid][furn_builder_mode] = -1;
                        SendServerMessage(playerid,"Mobilya nesnesini kaldýrmayý iptal ettiniz.",MSG_TYPE_WARN);
                        return cmd_point(playerid,"furni");
                    }

                    new query[128];

                    mysql_format(mysql,query,sizeof(query),"DELETE FROM furniture WHERE furniture_id = %d",FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i]);
                    mysql_tquery(mysql,query);
                    mysql_format(mysql,query,sizeof(query),"DELETE FROM furniture_extra WHERE furniture_ex_id = %d",FurnitureObject[GetCharacterPointID(playerid)][furn_object_db_id][i]);
                    mysql_tquery(mysql,query);

                    FurnitureBuilder[playerid][furn_builder_mode] = -1;
                    DestroyDynamicObject(objectid);
                    Init_Furniture(Point[GetCharacterPointID(playerid)][point_id]);
                    SendServerMessage(playerid,"Mobilya nesnesini baþarýyla sildiniz.",MSG_TYPE_INFO);

                    return 1;
                }
            }
            SendServerMessage(playerid,"Bir þeyler ters gitti, kaldýrmak istediðiniz nesneye tekrar týklamayý deneyin.",MSG_TYPE_ERROR);
            SendServerMessage(playerid,"Eðer bu iþe yaramazsa, /removefurni(ture)object komutunu kullanýn.",MSG_TYPE_ERROR);
        }
    }
    return true;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

WriteLog ( playerid, const dir[], const text[]) {

	new query [ 512 ], Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	format ( query, sizeof ( query ), "X: %f, Y: %f, Z: %f, vw: %d, int: %d", x, y, z, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ) ) ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO logs (dir, text, date, ip, info) VALUES ('%e', '%e', '%e', '%e', '%e')",
	dir, text, ReturnDateTime ( ), ReturnIP ( playerid ), query );

	mysql_tquery ( mysql, query ) ;

	return true ;
}

ReturnUserName ( playerid, bool: underscore = true , bool: mask = true ) {
	new name [ MAX_PLAYER_NAME + 1 ] ;
	GetPlayerName(playerid, name, sizeof(name));

	if ( playerid == INVALID_PLAYER_ID ) {

		name="Nobody";
		return name ;
	}

	if ( ! underscore ) {
	    for (new i = 0, len = strlen(name); i < len; i ++) {

	        if (name[i] == '_') name[i] = ' ';
		}
	}

	if ( mask == true && IsPlayerMasked [ playerid ] ) {

		format ( name, sizeof ( name ), "Stranger %d_%d",   Account [ playerid ] [ account_id ] * 20, Character [ playerid ] [ character_id ] ) ;
	}

	return name;
}

KickPlayer ( playerid ) {

	SetTimerEx("DisconnectUser", 1000, false, "i", playerid);
	
	return true;
}

forward DisconnectUser(playerid);
public DisconnectUser(playerid) {

	//print("DisconnectUser timer called (main.pwn)");

	return Kick ( playerid ) ;
}

forward DelayAttachmentPlacement(playerid);
public DelayAttachmentPlacement(playerid) {

	return ReloadPlayerAttachments ( playerid ) ;
}

ReturnDateTime ( ) {
	new date[36];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	format(date, sizeof(date), "%02d/%02d/%d, %02d:%02d",
	date[0], date[1], date[2], date[3], date[4]);

	return date;
}

ReturnIP ( playerid ) {
	new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));

	return ip;
}

ReturnWeaponName ( WEAPON: weaponid ) {
	new gunname[32];

	switch ( weaponid ) {
		case WEAPON_FIST .. WEAPON_MOLTOV,  WEAPON_COLT45 .. WEAPON_CAMERA, WEAPON_THERMAL_GOGGLES, WEAPON_PARACHUTE : GetWeaponName ( weaponid, gunname, sizeof ( gunname ) ) ;
		case WEAPON_NIGHT_VISION_GOGGLES:	strcat ( gunname, "Night Vis Goggles");
		default:							strcat ( gunname, "Geçersiz silah ID");
	}

	return gunname;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance) {

	new Float:a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	if (GetPlayerVehicleID(playerid)) {

	  GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

// These two only calculate the southern angle

stock GetXYLeftOfPlayer(playerid, &Float:X, &Float:Y, Float:distance) {
    new Float:Angle;
    GetPlayerFacingAngle(playerid, Angle); Angle += 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

GetXYRightOfPlayer(playerid, &Float:X, &Float:Y, Float:distance) {
    new Float:Angle;
    GetPlayerFacingAngle(playerid, Angle); Angle -= 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

stock epoch_to_datetime(unix_timestamp, &year, &month, &day, &hour, &minute, &second, utc_hour = 0, utc_minute = 0)  { 

    static days_of_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}, next_year, ut_of_next_year; 

    static const unix_timestamp_by_year[] =  { 
        -315619200, -283996800, -252460800, -220924800, -189388800, -157766400, -126230400, -94694400, -63158400, -31536000, 
        0, 31536000, 63072000, 94694400, 126230400, 157766400, 189302400, 220924800, 252460800, 283996800, 
        315532800, 347155200, 378691200, 410227200, 441763200, 473385600, 504921600, 536457600, 567993600, 599616000, 
        631152000, 662688000, 694224000, 725846400, 757382400, 788918400, 820454400, 852076800, 883612800, 915148800, 
        946684800, 978307200, 1009843200, 1041379200, 1072915200, 1104537600, 1136073600, 1167609600, 1199145600, 1230768000, 
        1262304000, 1293840000, 1325376000, 1356998400, 1388534400, 1420070400, 1451606400, 1483228800, 1514764800, 1546300800, 
        1577836800, 1609459200, 1640995200, 1672531200, 1704067200, 1735689600, 1767225600, 1798761600, 1830297600, 1861920000, 
        1893456000, 1924992000, 1956528000, 1988150400, 2019686400, 2051222400, 2082758400, 2114380800, 2145916800, -2117514496 
    }; 
     
    if (!(-315619200 <= (unix_timestamp += (utc_hour * 3600) + (utc_minute * 60)) <= cellmax)) return; 

    next_year = floatround(1970 + (unix_timestamp / 86400) * 0.00273790926, floatround_floor) + 1; 
    ut_of_next_year = unix_timestamp_by_year[next_year - 1960]; 
    year = (!(next_year & 3) && ((next_year % 25) || !(next_year & 15))) && ut_of_next_year <= unix_timestamp <= ut_of_next_year + 86400 ? next_year : next_year - 1; 
    days_of_month[1] = (!(year & 3) && ((year % 25) || !(year & 15))) ? 29 : 28; 
    unix_timestamp -= unix_timestamp_by_year[year - 1960] + ((hour = (unix_timestamp / 3600) % 24) * 3600) + ((minute = (unix_timestamp / 60) % 60) * 60) + (second = unix_timestamp % 60); 
    day = (unix_timestamp / 86400) + 1; 

    for (new i; i != sizeof days_of_month; i++)  { 
    	
        if ((day -= days_of_month[i]) > 0) continue; 

        day = !day ? days_of_month[i] : day + days_of_month[i]; 
        month = i + 1; 

        break; 
    } 
}  

GetDuration(time) { 
    new  str[32]; 

    if (time < 0 || time == gettime()) { 

        strcat(str, "Yok"); 
        return str; 
    } 

    else if (time < 60) format(str, sizeof(str), "%d saniye", time); 
    else if (time >= 0 && time < 60) format(str, sizeof(str), "%d saniye", time); 
    else if (time >= 60 && time < 3600) format(str, sizeof(str), (time >= 120) ? ("%d dakika") : ("%d dakika"), time / 60); 
    else if (time >= 3600 && time < 86400) format(str, sizeof(str), (time >= 7200) ? ("%d saat") : ("%d saat"), time / 3600); 
    else if (time >= 86400 && time < 2592000) format(str, sizeof(str), (time >= 172800) ? ("%d gün") : ("%d gün"), time / 86400); 
    else if (time >= 2592000 && time < 31536000) format(str, sizeof(str), (time >= 5184000) ? ("%d ay") : ("%d ay"), time / 2592000); 
    else if (time >= 31536000) format(str, sizeof(str), (time >= 63072000) ? ("%d yýl") : ("%d yýl"), time / 31536000); 

    strcat(str, " ago"); 

    return str; 
} 

GetDateForUnix ( unix ) {

    new string [ 128 ], year, month, day, hour, minute, second ;

    stamp2datetime(unix, year, month, day, hour, minute, second, 1 ) ;
    format ( string, sizeof ( string ), "%02d/%02d/%d, %02d:%02d:%02d", day, month, year, hour, minute, second ) ;
    
    return string ;
}

IsPlayerNearPlayer(playerid, targetid, Float:radius) {
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

ClearAudioForZone ( playerid ) {

	StopAudioStreamForPlayer ( playerid ) ;

	for ( new i = 0; i < sizeof ( Zones ) ; i++ ) {

		if ( IsPlayerInDynamicArea(playerid, Zone_ID [ i ] )) {

			PlayAudioStreamForPlayer(playerid, Zones [ i ] [ zone_audio ] ) ;

			return true ;		
		}
	}

	return true ;
}

stock PlayerPlaySoundEx(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
	    PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

PlayReloadAnimation(playerid, weaponid)
{
	switch (weaponid)
	{
	    case 22: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.0, false, false, false, false, 0);
		case 23: ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0, false, false, false, false, 0);
		case 24: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, false, false, false, false, 0);
		case 25, 27: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, false, false, false, false, 0);
		case 26: ApplyAnimation(playerid, "COLT45", "sawnoff_reload", 4.0, false, false, false, false, 0);
		case 29..31, 33, 34: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.0, false, false, false, false, 0);
		case 28, 32: ApplyAnimation(playerid, "TEC", "tec_reload", 4.0, false, false, false, false, 0);
	}
	return 1;
}

GetTickDiff(newtick, oldtick) {

	if (oldtick < 0 && newtick >= 0) {
		return newtick - oldtick;
	} else if (oldtick >= 0 && newtick < 0 || oldtick > newtick) {
		return (cellmax - oldtick + 1) - (cellmin - newtick);
	}
	return newtick - oldtick;
}

IsPlayerAiming(playerid)
{
	new anim = GetPlayerAnimationIndex(playerid);
	if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1449) || (anim == 1365) || (anim == 1643) || (anim == 1453) || (anim == 220) ||
	(anim == 1331) || (anim == 363 ) || (anim == 1365) || (anim==361)) return 1;
 	return 0;
}

stock IsPointInRangeOfPoint(Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2, Float:range)
{
    x2 -= x;
    y2 -= y;
    z2 -= z;
    return ((x2 * x2) + (y2 * y2) + (z2 * z2)) < (range * range);
}

GetXYInAtOffsetOfPlayer(playerid, &Float:x, &Float:y, Float:distance, Float:angle_offset)
{
	// Created by Y_Less
	new Float:a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	a += angle_offset;

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

GetXYInAtOffsetOfObject(objectid, &Float:x, &Float:y, Float:distance, Float:angle_offset)
{
	// Created by Y_Less
	new Float: temp, Float:a;

	GetDynamicObjectPos(objectid, x, y, a);
	GetDynamicObjectRot(objectid, temp, temp, a);

	a += angle_offset;

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

SendASCIILogo () {
	
	print ( "\n\nWW      WW IIIII LL      DDDDD      WW      WW EEEEEEE  SSSSS  TTTTTTT" ) ;
	print ( "WW      WW  III  LL      DD  DD     WW      WW EE      SS        TTT" ) ; 
	print ( "WW   W  WW  III  LL      DD   DD    WW   W  WW EEEEE    SSSSS    TTT" ) ; 
	print ( " WW WWW WW  III  LL      DD   DD     WW WWW WW EE           SS   TTT" ) ;
	print ( "  WW   WW  IIIII LLLLLLL DDDDDD       WW   WW  EEEEEEE  SSSSS    TTT\n" ) ;
	print ( "RRRRRR   OOOOO  LL      EEEEEEE    PPPPPP  LL        AAA   YY   YY" ) ;
	print ( "RR   RR OO   OO LL      EE         PP   PP LL       AAAAA  YY   YY" ) ;
	print ( "RR   RR OO   OO LL      EE         PP   PP LL       AAAAA  YY   YY" ) ;
	print ( "RRRRRR  OO   OO LL      EEEEE      PPPPPP  LL      AA   AA  YYYYY" ) ;
	print ( "RR  RR  OO   OO LL      EE         PP      LL      AAAAAAA   YYY" ) ;
	print ( "RR   RR  OOOO0  LLLLLLL EEEEEEE    PP      LLLLLLL AA   AA   YYY\n\n" ) ;
	print ( "  Wild West Roleplay Turkiye - 2016 - 2026 by Y_Less, TommyB, DamianC, h.ted, Dignity, Reyo.." ) ;

	return true ;
}

GetGangZoneCenter(Float:minx,Float:miny,Float:maxx,Float:maxy,&Float:centerx,&Float:centery) {

	centerx = ((minx+maxx)/2);
	centery = ((miny+maxy)/2);
}

/*
ptask PingChecker[5000](playerid) {

////	print("PingChecker timer called (main.pwn)");

	if ( NetStats_PacketLossPercent ( playerid ) > 10.0 && IsPlayerSpawned ( playerid ) ) {

		if ( ++ PacketLossTicker [ playerid ] > 4 ) {

			SendClientMessageToAll ( COLOR_GREEN, sprintf("[PING] (%d) %s has been kicked for having a packet loss of %d% after three consecutive ticks.", playerid, ReturnUserName ( playerid, true ), NetStats_PacketLossPercent ( playerid ) ) ) ;
		}
	}

	else return true ;

	if ( GetPlayerPing ( playerid ) > 800 ) {

		if ( ++ PingTicker [ playerid ] > 4) {

			SendClientMessageToAll ( COLOR_GREEN, sprintf("[PING] (%d) %s has been kicked for having a ping of %d after three consecutive ticks.", playerid, ReturnUserName ( playerid, true ), GetPlayerPing ( playerid ) ) ) ;
		}

		else return true ;
	}

	new string [ 1024 ] ;

	format ( string, sizeof ( string ), 

		"{DEDEDE}Oops! There's been a {EDD72F}network error{DEDEDE}!\n\
		\n\
		Your ping: \t {EDD72F}%d [MAX: 700]{DEDEDE}\n\
		Packet loss: \t {EDD72F}%.2f percent{DEDEDE}\n\
		\n\
		Please reconnect. Contact an admin if the issue persists.\n\
		\n\
		Sorry for the inconvenience\n", 

	 	GetPlayerPing ( playerid ), NetStats_PacketLossPercent ( playerid )
	 ) ;

	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{EDD72F}Network Error: too high ping/packet loss", string, "Close", "" ) ;

	PacketLossTicker [ playerid ] = 0 ;
	PingTicker [ playerid ] = 0 ;
	KickPlayer(playerid);

	return true ;
}
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
--- this is causing the vw bug

// Doesn't seem to work all the time
new PlayerOldInterior [ MAX_PLAYERS ] ;
new PlayerOldWorld [ MAX_PLAYERS ] ;
ptask OnPlayerChangeEntity [1000](playerid) {

////	print("OnPlayerChangeEntity timer called (main.pwn)");

	if ( PlayerOldInterior [ playerid ] != GetPlayerInterior ( playerid ) || PlayerOldWorld [ playerid ] != GetPlayerVirtualWorld ( playerid ) ) {

		foreach(new i: Player) {

			if ( IsPlayerSpectating [ i ] == playerid) {

				if ( IsPlayerSpectating [ i ] != INVALID_PLAYER_ID ) {

					SetPlayerInterior(i, GetPlayerInterior ( playerid ) ) ;
					SetPlayerVirtualWorld(i, GetPlayerVirtualWorld ( playerid ) ) ;

					PlayerSpectatePlayer ( i, playerid ) ;
				}

				else return SendServerMessage ( playerid, "Couldn't pull entity of spectated player. Please re-spec!", MSG_TYPE_ERROR ) ;
			}
		}
	 	
	 	PlayerOldInterior [ playerid ] = GetPlayerInterior ( playerid ) ;
	 	PlayerOldWorld [ playerid ] = GetPlayerVirtualWorld ( playerid ) ;

	}

	return true ;
}*/
// Search for players name
SSCANF:u(name[]) {
	if(isnull(name)) return INVALID_PLAYER_ID;

	new id;

	if ( sscanf(name, "i", id ) ) {
        new matches, rname [ MAX_PLAYER_NAME ];
        
		foreach(new i : Player) {

	        GetPlayerName(i, rname, sizeof ( rname ) ) ;

		    if(strfind(rname, name, true) != -1) {
				matches++;
				id = i;

				if(matches > 1) return INVALID_PLAYER_ID;
			}
		}

		if(matches) return id;
		return INVALID_PLAYER_ID;
	}

	if(id < 0) return INVALID_PLAYER_ID;
	if(!IsPlayerConnected(id)) return INVALID_PLAYER_ID;

	return id;
}

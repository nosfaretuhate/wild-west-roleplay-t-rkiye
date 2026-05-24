#define MAX_CHARACTERS		(3)

enum CharacterData {
	account_id,
	character_id,

	character_ajailed,

	character_level,
	character_hours,
	character_expleft,
	character_skillpoints,

	character_name [ MAX_PLAYER_NAME],
	character_spawnpoint,
	character_spawnmotel,
	character_backpack,

	character_gender,
	character_origin,

	character_skin,
	character_town,
	character_age,

	character_mask,
	character_accent [32],

	///////////////

	character_chatstyle,
	character_dmgmode,

	character_posse,
	character_possetier,
	character_posserank [ 36 ],

	///////////////

	character_horseid,
	Float: character_horsehealth,

	character_hunger,
	character_thirst,
	Float: character_health,

	///////////////

	WEAPON: character_handweapon,
	character_handammo,

	WEAPON: character_pantsweapon,
	character_pantsammo,

	WEAPON: character_backweapon,
	character_backammo,

	character_ammopack_pistol,
	character_ammopack_shotgun,
	character_ammopack_rifle,

	///////////////

	character_handmoney,
	character_handchange,
	character_bankmoney,
	character_bankchange,
	character_paycheck,
	character_paychange,

	///////////////

	character_attributes [ 144 ],

	///////////////

	character_prison,
	Float: character_prison_pos_x,
	Float: character_prison_pos_y,
	Float: character_prison_pos_z,
	character_prison_interior,
	character_prison_vw,
	character_prison_bail,
	character_prison_bail_cents,

	///////////////

	character_bounty_id,
	character_telegram_id,

	///////////////

	character_jobactionsleft,

	character_woodactionsleft,
	character_fishactionsleft,
	character_mineactionsleft,

	character_woodcd,
	character_fishcd,
	character_minecd,

	////////////////

 	Float: character_mask_offsetx,
	Float: character_mask_offsety,
	Float: character_mask_offsetz,

	Float: character_mask_rotx,
	Float: character_mask_roty,
	Float: character_mask_rotz,

	Float: character_mask_scalex,
	Float: character_mask_scaley,
	Float: character_mask_scalez,

	////////////////

 	Float: character_trousergun_offsetx,
	Float: character_trousergun_offsety,
	Float: character_trousergun_offsetz,

	Float: character_trousergun_rotx,
	Float: character_trousergun_roty,
	Float: character_trousergun_rotz,

	Float: character_trousergun_scalex,
	Float: character_trousergun_scaley,
	Float: character_trousergun_scalez,

	////////////////

 	Float: character_backgun_offsetx,
	Float: character_backgun_offsety,
	Float: character_backgun_offsetz,

	Float: character_backgun_rotx,
	Float: character_backgun_roty,
	Float: character_backgun_rotz,

	Float: character_backgun_scalex,
	Float: character_backgun_scaley,
	Float: character_backgun_scalez,

	////////////////

	Float: character_pos_x,
	Float: character_pos_y,
	Float: character_pos_z,
	character_pos_interior,
	character_pos_vw,

	////////////////

	character_temperature,
	character_temperature_decimal,

	////////////////

	character_crashed
};

// Use char_Selected when accessing MAX_CHARACTERS
new Character [ MAX_PLAYERS ] [ CharacterData ] ;

new CharBuffer [ MAX_PLAYERS ] [ MAX_CHARACTERS ] [ CharacterData ] ; 

new bool: Login_SelectionPage [ MAX_PLAYERS ] ; 
new LogoutPermission [ MAX_PLAYERS ] ;
new NewlyRegistered [ MAX_PLAYERS ] ;

new bool: IsPlayerInAdminJail [ MAX_PLAYERS ] ; 
new PassedSelectionScreen [ MAX_PLAYERS ] ;

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

// move the following into the character array some time.. dont fuck up
// Dignity was lazy so he made normal vars
new WEAPON: PlayerSaddleBagWeapon [ MAX_PLAYERS ] [ 2 ];
new PlayerSaddleBagAmmo [ MAX_PLAYERS ] [ 2 ];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new CharSwitchTick [ MAX_PLAYERS ] ;

forward ChangeCharacterTick(playerid, selectedid);
public ChangeCharacterTick(playerid, selectedid) {

////	print("ChangeCharacterTick timer called (character.pwn)");

	CharSwitchTick [ playerid ] -- ;
	GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~b~Switch time left:~w~ %d", CharSwitchTick [ playerid ] ), 1000, 3);

	if ( CharSwitchTick [ playerid ] > 0 ) {

		SetTimerEx("ChangeCharacterTick", 1000, false, "ii", playerid, selectedid);
		return true ;
	}

	else if ( CharSwitchTick [ playerid ] <= 0 ) {

		HideGUITextDraws ( playerid ) ;

		SetCharacterLoggedPosition ( playerid ) ;

		CharSwitchTick [ playerid ] = 0 ;

    	SetPlayerVirtualWorld(playerid, 0);
    	SetPlayerInterior(playerid, 0);

		SendModeratorWarning ( sprintf("[SWITCH] %s has switched to their character %s.", ReturnUserName ( playerid, false ), CharBuffer [ playerid ] [ selectedid ] [ character_name ]), MOD_WARNING_LOW ) ;
		//OldLog ( playerid, "switchchar", sprintf("%s has switched to their character %s.", ReturnUserName ( playerid, false ), CharBuffer [ playerid ] [ selectedid ] [ character_name ])) ;

        TogglePlayerControllable(playerid, true ) ;
    	Account_LoadCharacterData ( playerid, selectedid) ;

    	return true ;
	}

	return true ;
}

CMD:reloadgui ( playerid, params [] ) {

	HideGUITextDraws ( playerid ) ;
	ShowGUITextDraws ( playerid ) ;

	SendServerMessage ( playerid, "GUI has been reloaded.", MSG_TYPE_INFO ) ;
	return true ;
}

CMD:fixchartds(playerid, params[]){
    return HideCharacterTextDraws ( playerid );
}

CMD:switchcharacter ( playerid, params [] ) {

	if ( ! IsPlayerFree ( playerid ) ) {

		return SendServerMessage ( playerid, "You can't do this right now.", MSG_TYPE_ERROR ) ;
	}

	new query [ 512 ] = "{DEDEDE}ID \t Name\n" ;

	for ( new i; i < MAX_CHARACTERS; i ++ ) {

		if ( CharBuffer [ playerid ] [ i ] [ character_id ] ) {

			format ( query, sizeof ( query ), "%s(%d)\t%s\n", query,  CharBuffer [ playerid ] [ i ] [ character_id ],  CharBuffer [ playerid ] [ i ] [ character_name ] ) ;
		}

		else if ( ! CharBuffer [ playerid ] [ i ] [ character_id ] ) {

			format ( query, sizeof ( query ), "%s(%d)\tNone\n", query, i ) ;
		}
	}

	task_yield ( 1 ) ;

	new dialog_response [ e_DIALOG_RESPONSE_INFO ] ;
	await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, "Character Switch", query, "Continue", "Cancel" );

	if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		return false ;
	}

	PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

	if ( CharBuffer [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ character_id ] ) {

		SendServerMessage ( playerid, sprintf("You have selected character slot %d. [DB ID: (%d)] %s. You will switch momentarily.", dialog_response [ E_DIALOG_RESPONSE_Listitem ], CharBuffer [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ character_id ], CharBuffer [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ character_name ] ), MSG_TYPE_INFO ) ;
		SendServerMessage ( playerid, "You're gonna be frozen for fifteen seconds. These will serve as a cooldown and a deterrence to abuse.", MSG_TYPE_WARN) ;

		CharSwitchTick [ playerid ] = 15 ;
		SetTimerEx( "ChangeCharacterTick", 1000, false, "ii", playerid, dialog_response [ E_DIALOG_RESPONSE_Listitem ]) ;

		TogglePlayerControllable(playerid, false ) ;

		SetName ( playerid, sprintf("[SWITCHING CHARACTERS]{DEDEDE}\n(%d) %s", playerid, ReturnUserName ( playerid, false )), COLOR_BLUE ) ;
		GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~b~Switch time left:~w~ %d", CharSwitchTick [ playerid ] ), 1000, 3);

		SendModeratorWarning ( sprintf("[SWITCH] %s is trying to switch to character %s.", ReturnUserName ( playerid, false ), CharBuffer [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ character_name ]), MOD_WARNING_LOW ) ;
		//OldLog ( playerid, "switchchar", sprintf("%s is trying to switch to character %s.", ReturnUserName ( playerid, false ), CharBuffer [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ character_name ])) ;

		return true ;
	}

	else SendServerMessage ( playerid, "You don't have a character in this slot.", MSG_TYPE_ERROR ) ;

	return true ;
}

CMD:switchc ( playerid, params [] ) {

	return cmd_switchcharacter ( playerid, params ) ;
}


CMD:selectcharacter ( playerid, params [] ) {

	new selectid ;

	if ( sscanf ( params, "i", selectid ) ) {

		return SendServerMessage ( playerid, "/selectcharacter [slot 1-3]", MSG_TYPE_ERROR ) ;
	}

	if ( selectid > MAX_CHARACTERS ) {

		return SendServerMessage ( playerid, "You can only have three characters.", MSG_TYPE_ERROR ) ;
	}

	if ( ! Login_SelectionPage [ playerid ] ) {
		return SendServerMessage ( playerid, "You're not in the character selection screen. If you are but it says you're not, use /logout to fix it.", MSG_TYPE_ERROR ) ;
	}

	new characters ;

	for ( new i; i < MAX_CHARACTERS; i ++ ) {

		if ( CharBuffer [ playerid ] [ i ] [ character_id ] ) {

			characters ++ ;
		}
	}

	if ( selectid >= characters ) {

		SendServerMessage ( playerid, "There isn't a character in the slot you selected.", MSG_TYPE_ERROR ) ;
		return SendServerMessage ( playerid, "You can use {E87654}/createcharacter{DEDEDE} to create one.", MSG_TYPE_ERROR ) ;
	}

	SpawnPlayer_Character ( playerid ) ;

	return true ;
}

CreateCharacter ( playerid, master_account, char_name [], char_gender, char_origin, char_town, char_skin, char_age ) {

	if ( ! IsPlayerCreatingCharacter [ playerid ] ) {

		return SendClientMessage(playerid, -1, "Something went wrong. Please relog and /report for assistance (invalid CreateCharacter variable)." ) ;
	}

	IsPlayerCreatingCharacter [ playerid ] = false ;
	HideCreationTextDraws ( playerid ) ;

	if ( ! player_SkinSelection [ playerid ] ) {

		SendClientMessage(playerid, -1, "Something went wrong. Your skin hasn't been found, so we have manually set it for you based on your selections." ) ;
		UpdateCreationSkin ( playerid ) ;
	}

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO characters (account_id, character_name, character_gender, character_origin, character_town, character_skin, character_age, character_horseid) VALUES (%d, '%e', %d, %d, %d, %d, %d, '-1')", 
		master_account, char_name, char_gender, char_origin, char_town, char_skin, char_age ) ;
	mysql_tquery ( mysql, query ) ;

	NewlyRegistered [ playerid ] = true ;

	inline GiveReward() {

		new rows;
		cache_get_row_count(rows);

		if(rows) {

			new charid;
			cache_get_value_name_int(0,"character_id",charid);
			GiveRegisterReward ( playerid, charid ) ;
		}		
	}
	MySQL_TQueryInline(mysql,using inline GiveReward,"SELECT character_id FROM characters WHERE character_name = '%e' LIMIT 1",char_name);

	query [ 0 ] = EOS ;

	HideCreationTextDraws ( playerid ) ;
	HideCharacterTextDraws ( playerid ) ;

	Account_CharacterCheck ( playerid ) ;

	SendModeratorWarning ( sprintf("[CREATE] (%d) %s (%d: %s) has registered a new character.", playerid, char_name, master_account, Account [ playerid ] [ account_name] ), MOD_WARNING_LOW ) ;
	//OldLog ( playerid, "char/create", sprintf("(%d) %s (%d: %s) has registered a new character.", playerid, char_name, master_account, Account [ playerid ] [ account_name] )) ;

	return true ;
}

SpawnPlayer_Character ( playerid ) {

	LogoutPermission [ playerid ] = false ;
	HideGUITextDraws ( playerid ) ;

 	StopAudioStreamForPlayer ( playerid ) ;
	TogglePlayerSpectating ( playerid, false ) ;

	SetPlayerName(playerid, Character [ playerid ]  [ character_name ] ) ;
	SetPlayerColor(playerid, 0xCFCFCFFF ) ;

	Login_SelectionPage [ playerid ] = false ;
	PassedSelectionScreen [ playerid ] = true ;

	SetSpawnInfo ( playerid, -1, Character [ playerid ]  [ character_skin ], SERVER_SPAWN_X, SERVER_SPAWN_Y, SERVER_SPAWN_Z, 90.0 ) ;
	SpawnPlayer ( playerid ) ;

	HideCharacterTextDraws ( playerid ) ;
	HideCreationTextDraws ( playerid ) ;

	CancelSelectTextDraw ( playerid ) ;

	SetPlayerScore ( playerid, Character [ playerid ]  [ character_level ]) ;

//	SendModeratorWarning ( sprintf("[SPAWN] (%d) %s has just spawned.", playerid, ReturnUserName ( playerid, true ) ), MOD_WARNING_LOW ) ;
	//OldLog ( playerid, "char/spawn", sprintf("(%d) %s (%d: %s) has just spawned.", playerid, Character [ playerid ] [ character_name ], Account [ playerid ] [ account_id ], Account [ playerid ] [ account_name] )) ;

    BanEvaderCheck ( playerid ) ;

    if ( Character [ playerid ] [ character_dmgmode ] != 0 ) {

    	Character [ playerid ] [ character_dmgmode ] = 2 ;

		SetTimerEx("DeadCooldown", 1000, false, "i", playerid);
    }

	if ( IsPlayerModerator ( playerid ) ) {

		// The mod warnings are set to true in main.pwn OnPlayerSpawn
		SendServerMessage ( playerid, "Moderator warnings have been automatically enabled. Use /togmodwarnings to disable it.", MSG_TYPE_WARN ) ;
	}

	SendServerMessage ( playerid, "Your animations will be preloaded shortly. This may mean that you experience a small lag spike.", MSG_TYPE_ERROR ) ;
	SetTimerEx("LoadAnimations", 5000, false, "i", playerid) ;

	ResetPlayerWounds ( playerid ) ;

	if ( GetBountyIDByName ( playerid ) != -1 ) {

		LoadWantedPosterPlayerID ( GetBountyIDByName ( playerid ) ) ;
	}

	SendClientMessage(playerid, -1, " " ) ;

	SetTimerEx("LoadDelayedData", 1000, false, "i", playerid );
	SetTimerEx("Paycheck", 2700000, false, "i", playerid);

	return true ;
}

CMD:resyncattachments(playerid, params[]) {

	return Init_LoadPlayerAttachments ( playerid );
}

forward LoadDelayedData(playerid);
public LoadDelayedData(playerid) {

////	print("LoadDelayedData timer called (character.pwn)");

	SetupPlayerGunAttachments ( playerid ) ;

	// Money
	GivePlayerMoney ( playerid, Character [ playerid ] [ character_handmoney ] ) ;

	// GUI
	HideCharacterTextDraws ( playerid ) ;
	HideCreationTextDraws ( playerid ) ;
	
	ShowGUITextDraws ( playerid ) ;
	UpdateWeaponGUI ( playerid ) ;
	UpdateGUI ( playerid ) ;

	// Inventory
	Init_LoadPlayerItems ( playerid ) ;
	Init_LoadPlayerAttachments ( playerid ) ;

	if ( IsLawEnforcementPosse ( Character [ playerid ] [ character_posse ] ) ) {

		if ( ReturnItemByParam ( playerid, RADIO, true ) != -1 ) {

			DiscardItem ( playerid, ReturnItemByParam ( playerid, RADIO, true ) ) ;
		}

		if ( ReturnItemByParam ( playerid, SHERIFF_HANDCUFFS, true ) != -1 ) {

			DiscardItem ( playerid, ReturnItemByParam ( playerid, SHERIFF_HANDCUFFS, true ) ) ;
		}

		if ( ReturnItemByParam ( playerid, SHERIFF_BADGE, true ) != -1 ) {

			DiscardItem ( playerid, ReturnItemByParam ( playerid, SHERIFF_BADGE, true )) ;
		}

		if ( ReturnItemByParam ( playerid, FEDERAL_BADGE, true ) != -1 ) {

			DiscardItem ( playerid, ReturnItemByParam ( playerid, FEDERAL_BADGE, true )) ;
		}
	}

	//Crimes, if any
	Init_LoadCharges ( playerid ) ;

	//Telegram
	Init_LoadTelegrams ( playerid ) ;

	SetName ( playerid, sprintf("(%d) %s", playerid, ReturnUserName ( playerid, false )), 0xCFCFCFFF ) ;
	ShowPlayerMOTD ( playerid ) ;

	LoadPlayerSkills ( playerid ) ;

	// HandleTutorial ( playerid ) ;

	if ( ! Character [ playerid ] [ character_prison ] ) {

		switch ( random ( 4 ) ) {
			case 0: SendClientMessage(playerid, COLOR_DEFAULT, "** You've woken up from a brief nap and feel somewhat refreshed.." ) ;
			case 1: SendClientMessage(playerid, COLOR_DEFAULT, "** You've woken up with your head pounding and the smell of alcohol emitting from your clothes.." ) ;
			case 2: SendClientMessage(playerid, COLOR_DEFAULT, "** You've woken up after a fight. Your face hurts and your knuckles seem to be bloodied.." ) ;
			case 3: {

				if ( Character [ playerid ] [ character_horseid ] != -1 ) {

					SendClientMessage(playerid, COLOR_DEFAULT, "** You've woken up on the ground. It seems your horse has ran off, it shouldn't be too far away.." ) ;
				}

				else SendClientMessage(playerid, COLOR_DEFAULT, "** You've woken up due to a horse hinnicking loudly. You push yourself off the floor..") ;
			}
		}
	}

	SendServerMessage(playerid, "If your character selection/creation textdraws haven't gone away, please use /fixchartds", MSG_TYPE_INFO);

	if(Character [ playerid ] [ character_age ] == 0) {

		task_yield(1);

		new error, dialog_response[e_DIALOG_RESPONSE_INFO];

		for(;;) {
			switch(error) {
				case 0: {
					
					await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Character Age", "The server detected that your age is zero.\n\nIf this isn't correct, take a screenshot of this dialog and send it to a developer.\n\nEnter your character's age below: (8-80)", "Finish", "") ;
				}
				
				case 1: {

					await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Character Age", "No characters were detected.\n\nEnter your character's age below: (8-80)", "Finish", "") ;
				}

				case 2: {

					await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Character Age", "That is not a numeric character.\n\nEnter your character's age below: (8-80)", "Finish", "") ;
				}

				case 3: {

					await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_INPUT, "Character Age", "You character cannot be younger than 8 or older than 80.\n\nEnter your character's age below: (8-80)", "Finish", "") ;
				}
			}

			error = 0;

			if(!dialog_response[E_DIALOG_RESPONSE_Response]) {

				continue;
			}

			if(!strlen(dialog_response[E_DIALOG_RESPONSE_InputText])) {

				error = 1;
			}

			else if(!IsNumeric(dialog_response[E_DIALOG_RESPONSE_InputText])) {

				error = 2;
			}

			else if(strval(dialog_response[E_DIALOG_RESPONSE_InputText]) > 80 || strval(dialog_response[E_DIALOG_RESPONSE_InputText]) < 8) {

				error = 3;
			}

			if(error) {

				continue;
			}

			new query[128];

			Character[playerid][character_age] = strval(dialog_response[E_DIALOG_RESPONSE_InputText]);

			mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_age = %d WHERE character_id = %d",Character[playerid][character_age],Character[playerid][character_id]);
			mysql_tquery(mysql,query);

			SendServerMessage(playerid,sprintf("You've set your character's age to %d.",Character[playerid][character_age]),MSG_TYPE_INFO);
			break;
		}

	}

	SetTimerEx("SpawnPlayerDeter", 1000, false, "i", playerid);

 	return true ;
}

forward SpawnPlayerDeter(playerid);
public SpawnPlayerDeter(playerid) {

//	BlackScreen ( playerid ) ;
//	FadeIn ( playerid ) ;

	SelectSpawn ( playerid ) ;

	for(new i=0; i<5; i++) {

		HideCharacterTextDraws(playerid);
	}
	return true ;
}

forward NameTagProofCheck(playerid);
public NameTagProofCheck(playerid) {

	new namelabel [ MAX_PLAYER_NAME ] ;
 	GetDynamic3DTextLabelText ( nametag[playerid], namelabel ) ;

 	if ( Account [ playerid ] [ account_tutorial ] < ReturnTaskListSize ( ) + 1 ) {
		
		SendClientMessage(playerid, -1, " " ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, "It seems you haven't finished your tutorial tasks yet. If you are new to the server and want to learn the basics" ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, "it is adviced to use {D4AE72}/tasks{DEDEDE} to see your progress. You also get a reward for completing them." ) ;
		SendClientMessage(playerid, -1, " " ) ;

	}

	if ( ! IsRPName ( ReturnUserName ( playerid ) ) ) {

		KickPlayer ( playerid );
		SendServerMessage ( playerid, "There was an error processing your name. Please try relogging or create a new character.", MSG_TYPE_WARN);
		return SendServerMessage ( playerid, "You might want to contact the management team on the forums if you wish to retrieve it.", MSG_TYPE_WARN );
	}

	return true ;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Account_CharacterCheck ( playerid ) {

	new query [ 128 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM characters WHERE account_id = '%d'", Account [ playerid ] [ account_id ] ) ;
	mysql_tquery ( mysql, query, "Account_RetrieveCharacters", "i", playerid ) ;

	return true ;
} 

forward Account_RetrieveCharacters ( playerid ) ;
public Account_RetrieveCharacters ( playerid ) {

	new rows ;
	cache_get_row_count ( rows ) ;

	if ( rows ) {

		for ( new i; i < rows; i ++ ) {

			cache_get_value_name_int (i, "account_id",			CharBuffer [ playerid ] [ i ] [ account_id ] ) ;
			cache_get_value_name_int (i, "character_id",		CharBuffer [ playerid ] [ i ] [ character_id ] ) ;

			cache_get_value_name (i, "character_name",			CharBuffer [ playerid ] [ i ]  [ character_name ], MAX_PLAYER_NAME ) ;

			cache_get_value_name_int (i, "character_skin",		CharBuffer [ playerid ] [ i ] [ character_skin ] ) ;
			cache_get_value_name_int (i, "character_gender",	CharBuffer [ playerid ] [ i ] [ character_gender ] ) ;

			cache_get_value_name_int (i, "character_origin",	CharBuffer [ playerid ] [ i ] [ character_origin ] ) ;
			cache_get_value_name_int (i, "character_town",		CharBuffer [ playerid ] [ i ] [ character_town ] ) ;

			cache_get_value_name_int (i, "character_hours",		CharBuffer [ playerid ] [ i ] [ character_hours ] ) ;
			cache_get_value_name_int (i, "character_level",		CharBuffer [ playerid ] [ i ] [ character_level ] ) ;
			cache_get_value_name_int (i, "character_expleft",	CharBuffer [ playerid ] [ i ] [ character_expleft ] ) ;
		}
	}

	SendClientMessage(playerid, 0xDEDEDEFF, "Please wait a moment while we load the character textdraws, they should appear shortly.") ;
	SendClientMessage(playerid, 0xDEDEDEFF, " ") ;

	BanChecker ( playerid ) ;
	SetTimerEx("Delayed_TextdrawLoad", 1000, false, "i", playerid) ;
}

Account_LoadCharacterData ( playerid, selected ) {

	new query [ 128 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM characters WHERE character_id = %d", CharBuffer [ playerid ] [ selected ] [ character_id ] ) ;
	mysql_tquery ( mysql, query, "Account_LoadCharacters", "i", playerid ) ;

	return true ;
} 

forward Account_LoadCharacters ( playerid ) ;
public Account_LoadCharacters ( playerid ) {

	new rows ;
	cache_get_row_count ( rows ) ;

	if ( rows ) {

		for ( new i; i < rows; i ++ ) {

			cache_get_value_name_int (i, "account_id",						Character [ playerid ] [ account_id ] ) ;
			cache_get_value_name_int (i, "character_id",					Character [ playerid ] [ character_id ] ) ;
			cache_get_value_name_int (i, "character_spawnpoint",			Character [ playerid ] [ character_spawnpoint ] ) ;
			cache_get_value_name_int (i, "character_spawnmotel",			Character [ playerid ] [ character_spawnmotel ] ) ;

			cache_get_value_name_int (i, "character_backpack",				Character [ playerid ] [ character_backpack ] ) ;
			cache_get_value_name_int (i, "character_ajailed",				Character [ playerid ] [ character_ajailed ] ) ;

			cache_get_value_name_int (i, "character_hours",					Character [ playerid ] [ character_hours ] ) ;
			cache_get_value_name_int (i, "character_level",					Character [ playerid ] [ character_level ] ) ;
			cache_get_value_name_int (i, "character_expleft",				Character [ playerid ] [ character_expleft ] ) ;
			cache_get_value_name_int (i, "character_skillpoints",			Character [ playerid ] [ character_skillpoints ] ) ;

			cache_get_value_name (i, "character_name",						Character [ playerid ] [ character_name ], MAX_PLAYER_NAME ) ;
			cache_get_value_name (i, "character_accent",					Character [ playerid ] [ character_accent ], 32 ) ;

			cache_get_value_name_int (i, "character_skin",					Character [ playerid ] [ character_skin ] ) ;
			cache_get_value_name_int (i, "character_gender",				Character [ playerid ] [ character_gender ] ) ;

			cache_get_value_name_int (i, "character_origin",				Character [ playerid ] [ character_origin ] ) ;
			cache_get_value_name_int (i, "character_town",					Character [ playerid ] [ character_town ] ) ;
			cache_get_value_name_int (i, "character_age",					Character [ playerid ] [ character_age ] ) ;
			
			cache_get_value_name_int (i, "character_mask",					Character [ playerid ] [ character_mask ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_chatstyle",				Character [ playerid ] [ character_chatstyle ] ) ;
			cache_get_value_name_int (i, "character_dmgmode",				Character [ playerid ] [ character_dmgmode ] ) ;

			cache_get_value_name_int (i, "character_posse",					Character [ playerid ] [ character_posse ] ) ;
			cache_get_value_name_int (i, "character_possetier",				Character [ playerid ] [ character_possetier ] ) ;

			cache_get_value_name (i, "character_posserank",					Character [ playerid ]  [ character_posserank ], 36 ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_horseid",				Character [ playerid ] [ character_horseid ] ) ;
			cache_get_value_name_float (i, "character_horsehealth",			Character [ playerid ] [ character_horsehealth ] ) ;

			cache_get_value_name_int (i, "character_hunger",				Character [ playerid ] [ character_hunger ] ) ;
			cache_get_value_name_int (i, "character_thirst",				Character [ playerid ] [ character_thirst ] ) ;
			cache_get_value_name_float (i, "character_health",				Character [ playerid ] [ character_health ] ) ;


			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_handweapon",			Character [ playerid ] [ character_handweapon ] ) ;
			cache_get_value_name_int (i, "character_handammo",				Character [ playerid ] [ character_handammo ] ) ;

			cache_get_value_name_int (i, "character_pantsweapon",			Character [ playerid ] [ character_pantsweapon ] ) ;
			cache_get_value_name_int (i, "character_pantsammo",				Character [ playerid ] [ character_pantsammo ] ) ;

			cache_get_value_name_int (i, "character_backweapon",			Character [ playerid ] [ character_backweapon ] ) ;
			cache_get_value_name_int (i, "character_backammo",				Character [ playerid ] [ character_backammo ] ) ;

			cache_get_value_name_int (i, "character_ammopack_pistol",		Character [ playerid ] [ character_ammopack_pistol ] ) ;
			cache_get_value_name_int (i, "character_ammopack_shotgun",		Character [ playerid ] [ character_ammopack_shotgun ] ) ;
			cache_get_value_name_int (i, "character_ammopack_rifle",		Character [ playerid ] [ character_ammopack_rifle ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


			cache_get_value_name_int (i, "character_sb_gun0",				PlayerSaddleBagWeapon [ playerid ] [ 0 ] ) ;
			cache_get_value_name_int (i, "character_sb_gun1",				PlayerSaddleBagWeapon [ playerid ] [ 1 ] ) ;

			cache_get_value_name_int (i, "character_sb_ammo0",				PlayerSaddleBagAmmo [ playerid ] [ 0 ] ) ;
			cache_get_value_name_int (i, "character_sb_ammo1",				PlayerSaddleBagAmmo [ playerid ] [ 1 ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


			cache_get_value_name_int (i, "character_handmoney",				Character [ playerid ] [ character_handmoney ] ) ;
			cache_get_value_name_int (i, "character_handchange",			Character [ playerid ] [ character_handchange ] ) ;
			cache_get_value_name_int (i, "character_bankmoney",				Character [ playerid ] [ character_bankmoney ] ) ;
			cache_get_value_name_int (i, "character_bankchange", 			Character [ playerid ] [ character_bankchange ]) ;
			cache_get_value_name_int (i, "character_paycheck", 				Character [ playerid ] [ character_paycheck ] ) ;
			cache_get_value_name_int (i, "character_paychange", 			Character [ playerid ] [ character_paychange ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_prison",				Character [ playerid ] [ character_prison ] ) ;
			cache_get_value_name_float (i, "character_prison_pos_x",		Character [ playerid ] [ character_prison_pos_x] ) ;
			cache_get_value_name_float (i, "character_prison_pos_y",		Character [ playerid ] [ character_prison_pos_y] ) ;
			cache_get_value_name_float (i, "character_prison_pos_z",		Character [ playerid ] [ character_prison_pos_z] ) ;
			cache_get_value_name_int (i, "character_prison_interior",		Character [ playerid ] [ character_prison_interior ] ) ;
			cache_get_value_name_int (i, "character_prison_vw",				Character [ playerid ] [ character_prison_vw ] ) ;
			cache_get_value_name_int (i, "character_prison_bail",			Character [ playerid ] [ character_prison_bail ] ) ;
			cache_get_value_name_int (i, "character_prison_bail_cents",		Character [ playerid ] [ character_prison_bail_cents ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name (i, "character_attributes",				Character [ playerid ] [ character_attributes ], 144 ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_bounty_id",				Character [ playerid ] [ character_bounty_id ] ) ;
			cache_get_value_name_int (i, "character_telegram_id",			Character [ playerid ] [ character_telegram_id ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_jobactionsleft",		Character [ playerid ] [ character_jobactionsleft ] ) ;

			cache_get_value_name_int (i, "character_woodactionsleft",		Character [ playerid ] [ character_woodactionsleft ] ) ;
			cache_get_value_name_int (i, "character_fishactionsleft",		Character [ playerid ] [ character_fishactionsleft ] ) ;
			cache_get_value_name_int (i, "character_mineactionsleft",		Character [ playerid ] [ character_mineactionsleft ] ) ;
			
			cache_get_value_name_int (i, "character_woodcd",				Character [ playerid ] [ character_woodcd ] ) ;
			cache_get_value_name_int (i, "character_fishcd",				Character [ playerid ] [ character_fishcd ] ) ;
			cache_get_value_name_int (i, "character_minecd",				Character [ playerid ] [ character_minecd ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_float (i, "character_mask_offsetx",		Character [ playerid ] [character_mask_offsetx ] ) ;
			cache_get_value_name_float (i, "character_mask_offsety",		Character [ playerid ] [character_mask_offsety ] ) ;
			cache_get_value_name_float (i, "character_mask_offsetz",		Character [ playerid ] [character_mask_offsetz ] ) ;

			cache_get_value_name_float (i, "character_mask_rotx",			Character [ playerid ] [character_mask_rotx ] ) ;
			cache_get_value_name_float (i, "character_mask_roty",			Character [ playerid ] [character_mask_roty ] ) ;
			cache_get_value_name_float (i, "character_mask_rotz",			Character [ playerid ] [character_mask_rotz ] ) ;

			cache_get_value_name_float (i, "character_mask_scalex",			Character [ playerid ] [character_mask_scalex ] ) ;
			cache_get_value_name_float (i, "character_mask_scaley",			Character [ playerid ] [character_mask_scaley ] ) ;
			cache_get_value_name_float (i, "character_mask_scalez",			Character [ playerid ] [character_mask_scalez ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_float (i, "character_trousergun_offsetx",	Character [ playerid ] [character_trousergun_offsetx ] ) ;
			cache_get_value_name_float (i, "character_trousergun_offsety",	Character [ playerid ] [character_trousergun_offsety ] ) ;
			cache_get_value_name_float (i, "character_trousergun_offsetz",	Character [ playerid ] [character_trousergun_offsetz ] ) ;

			cache_get_value_name_float (i, "character_trousergun_rotx",		Character [ playerid ] [character_trousergun_rotx ] ) ;
			cache_get_value_name_float (i, "character_trousergun_roty",		Character [ playerid ] [character_trousergun_roty ] ) ;
			cache_get_value_name_float (i, "character_trousergun_rotz",		Character [ playerid ] [character_trousergun_rotz ] ) ;

			cache_get_value_name_float (i, "character_trousergun_scalex",	Character [ playerid ] [character_trousergun_scalex ] ) ;
			cache_get_value_name_float (i, "character_trousergun_scaley",	Character [ playerid ] [character_trousergun_scaley ] ) ;
			cache_get_value_name_float (i, "character_trousergun_scalez",	Character [ playerid ] [character_trousergun_scalez ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_float (i, "character_backgun_offsetx",		Character [ playerid ] [character_backgun_offsetx ] ) ;
			cache_get_value_name_float (i, "character_backgun_offsety",		Character [ playerid ] [character_backgun_offsety ] ) ;
			cache_get_value_name_float (i, "character_backgun_offsetz",		Character [ playerid ] [character_backgun_offsetz ] ) ;

			cache_get_value_name_float (i, "character_backgun_rotx",		Character [ playerid ] [character_backgun_rotx ] ) ;
			cache_get_value_name_float (i, "character_backgun_roty",		Character [ playerid ] [character_backgun_roty ] ) ;
			cache_get_value_name_float (i, "character_backgun_rotz",		Character [ playerid ] [character_backgun_rotz ] ) ;

			cache_get_value_name_float (i, "character_backgun_scalex",		Character [ playerid ] [character_backgun_scalex ] ) ;
			cache_get_value_name_float (i, "character_backgun_scaley",		Character [ playerid ] [character_backgun_scaley ] ) ;
			cache_get_value_name_float (i, "character_backgun_scalez",		Character [ playerid ] [character_backgun_scalez ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_float (i, "character_pos_x",				Character [ playerid ] [ character_pos_x ] ) ;
			cache_get_value_name_float (i, "character_pos_y",				Character [ playerid ] [ character_pos_y ] ) ;
			cache_get_value_name_float (i, "character_pos_z",				Character [ playerid ] [ character_pos_z ] ) ;

			cache_get_value_name_int (i, "character_pos_interior",			Character [ playerid ] [ character_pos_interior ] ) ;
			cache_get_value_name_int (i, "character_pos_vw",				Character [ playerid ] [ character_pos_vw ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_temperature",			Character [ playerid ] [ character_temperature ] ) ;
			cache_get_value_name_int (i, "character_temperature_decimal",	Character [ playerid ] [ character_temperature_decimal ] ) ;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			cache_get_value_name_int (i, "character_crashed",				Character [ playerid ] [ character_crashed ]);

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			Init_LoadPlayerAttachments ( playerid ) ;
		}
	}

	return SpawnPlayer_Character ( playerid ) ;
}

SetCharacterLoggedPosition ( playerid, crashed = 0 ) {

	if(!crashed) {

		if ( Character [ playerid ] [ character_spawnpoint ] == 6 ) {

			if ( IsPlayerSpawned ( playerid ) ) {

				new Float: x, Float: y, Float: z, query [ 256 ] ;

				if(GetCharacterPointID(playerid) == -1) {
					
					GetPlayerPos ( playerid, x, y, z ) ;

					mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_pos_x = %f, character_pos_y = %f, character_pos_z = %f, character_pos_interior = %d, character_pos_vw = %d WHERE character_id = %d", x, y, z, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ), Character [ playerid ] [ character_id ] ) ;
					mysql_tquery ( mysql, query ) ;
				}
				else {

					new id = GetCharacterPointID(playerid);
					GetPointExteriorPosition(id,x,y,z);

					mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_pos_x = %f, character_pos_y = %f, character_pos_z = %f, character_pos_interior = 0, character_pos_vw = 0 WHERE character_id = %d", x, y, z, Character [ playerid ] [ character_id ] ) ;
					mysql_tquery ( mysql, query ) ;
				}
			}
		}
	}

	else {

		if ( IsPlayerSpawned ( playerid ) ) {

			Character [ playerid ] [ character_crashed ] = 1;
			new Float: x, Float: y, Float: z, query [ 256 ] ;

			if(GetCharacterPointID(playerid) == -1) {
					
				GetPlayerPos ( playerid, x, y, z ) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_pos_x = %f, character_pos_y = %f, character_pos_z = %f, character_pos_interior = %d, character_pos_vw = %d, character_crashed = 1 WHERE character_id = %d", x, y, z, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ), Character [ playerid ] [ character_id ] ) ;
				mysql_tquery ( mysql, query ) ;
			}
			else {

				new id = GetCharacterPointID(playerid);
				GetPointExteriorPosition(id,x,y,z);

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_pos_x = %f, character_pos_y = %f, character_pos_z = %f, character_pos_interior = 0, character_pos_vw = 0, character_crashed = 1 WHERE character_id = %d", x, y, z, Character [ playerid ] [ character_id ] ) ;
				mysql_tquery ( mysql, query ) ;
			}
		}
	}

	return true ;
}

GiveRegisterReward ( playerid, charid ) {

	if(NewlyRegistered[playerid]) {

		new query [ 256 ] ; 

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_health = 100, character_thirst = 100, character_hunger = 100 WHERE character_id = '%d'", charid ) ;
		mysql_tquery ( mysql, query ) ;

		mysql_format(mysql, query, sizeof ( query ),"UPDATE characters SET character_level = 1, character_expleft = 8 WHERE character_id = '%d'", charid ) ;
		mysql_tquery ( mysql, query ) ;

		mysql_format(mysql, query, sizeof ( query ),"UPDATE characters SET character_posse = -1, character_posserank = 'None' WHERE character_id = '%d'", charid ) ;
		mysql_tquery ( mysql, query ) ;

		mysql_format(mysql,query,sizeof(query),"UPDATE characters SET character_handmoney = %d,character_handchange = %d,character_bankmoney = %d,character_bankchange = %d WHERE character_id = '%d'",10,randomEx(1,25),25,randomEx(1,25),charid);
		mysql_tquery(mysql,query);

		/*
		GiveCharacterMoney ( playerid, 10, MONEY_SLOT_HAND ) ;
		GiveCharacterChange ( playerid, randomEx(1,25), MONEY_SLOT_HAND ) ;
		GiveCharacterMoney ( playerid, 25, MONEY_SLOT_BANK ) ;
		GiveCharacterChange ( playerid, randomEx(1,25), MONEY_SLOT_BANK ) ;
		SetCharacterHealth ( playerid, 100 ) ;

		Character [ playerid ] [ character_hunger ] = 100 ;
		Character [ playerid ] [ character_thirst ] = 100 ;

		Character [ playerid ] [ character_level ] = 1 ;
		Character [ playerid ] [ character_expleft ] = 8 ;

		Character [ playerid ] [ character_posse ] = -1 ;
		format ( Character [ playerid ] [ character_posserank ], Character [ playerid ] [ character_posserank ], "None" ) ;

		GivePlayerItemByParam ( playerid, PARAM_FISHING, FISHING_ROD, 1, 0, 0, 0 ) ;
		*/

		NewlyRegistered [ playerid ] = false ;
	}
}
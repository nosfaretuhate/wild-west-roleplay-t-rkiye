

new Player_ClientDeath [ MAX_PLAYERS ] ;
new IsPlayerBandaging [ MAX_PLAYERS ] ;


#include "func/injury/damage/injuries.pwn"
#include "func/injury/death/corpse.pwn"

#include "func/injury/blood/trail.pwn"
//#include "func/injury/blood/splatter.pwn"

#include "func/injury/health/health.pwn"
#include "func/injury/health/fire.pwn"

#include "func/injury/showinjury.pwn"
//#include "func/injury/splats.pwn"

public OnPlayerSpawn ( playerid ) {

	// resetting injuries
    IsPlayerBleeding [ playerid ] = false ;

    PlayerDamage [ playerid ] [ DAMAGE_LEGS ] = false ;
    PlayerDamage [ playerid ] [ DAMAGE_ARMS ] = false ;

	SetPlayerSkin ( playerid, Character [ playerid ] [ character_skin ] ) ;

    if ( Player_ClientDeath [ playerid ] ) {

		Player_ClientDeath [ playerid ] = false ;
		return SpawnPlayer_Character ( playerid ) ;
    }

	#if defined dmg_OnPlayerSpawn 
		return dmg_OnPlayerSpawn ( playerid );
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn 
	#undef OnPlayerSpawn 
#else
	#define _ALS_OnPlayerSpawn 
#endif

#define OnPlayerSpawn  dmg_OnPlayerSpawn 
#if defined dmg_OnPlayerSpawn 
	forward dmg_OnPlayerSpawn ( playerid );
#endif


CMD:helpup ( playerid, params [] ) {

    if ( PlayerHelpUpCooldown [ playerid ] >= gettime ()) {
        return SendServerMessage ( playerid, sprintf("Birini yerden kaldýrmak için %d saniye daha beklemelisin.", PlayerHelpUpCooldown[playerid] - gettime ()), MSG_TYPE_WARN ) ;
    }

    foreach ( new i: Player ) {

        if ( ! IsPlayerNearPlayer ( playerid, i, 3 ) || i == playerid ) {
            continue ;
        } 

        if ( Character [ i ] [ character_dmgmode ] != 1 ) {
            continue ;
        }

        else if ( Character [ i ] [ character_dmgmode ] ) {

            if(HasPlayerBeenShotInBodyPart(i,BODY_PART_HEAD)) { return SendServerMessage(playerid,"Kafasýndan vurulmuþ birini yerden kaldýramazsýn.",MSG_TYPE_ERROR); }

            TogglePlayerControllable ( i, true ) ;

            Character [ i ] [ character_health ] = 35 ;
            SetCharacterHealth ( i, Character [ i ] [ character_health ] ) ;

            Character [ i ] [ character_dmgmode ] = 0 ;
            PlayerInjuredCooldown [ i ] = 0 ;

            ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "** %s, %s adlý kiþiyi yerden kaldýrýr.", ReturnUserName ( playerid, true, true ), ReturnUserName ( i, true, true ) ) ) ;
                        
            TogglePlayerControllable ( i, true ) ;

            PlayerHelpUpCooldown [ playerid ] = gettime () + 300 ;
            PlayerRecentlyRevived [ i ] = true ;

            if ( ! IsPlayerPaused ( i ) ) {
                SetName ( i, sprintf("(%d) %s", i, ReturnUserName ( i, false, true ) ), 0xCFCFCFFF ) ;
            }       
            else {
                SetName ( i, sprintf("[AFK (/afklist)]{DEDEDE}\n(%d) %s", i, ReturnUserName ( i, false )  ), COLOR_RED ) ;
            }

            return SendServerMessage ( i, sprintf("(%d) %s tarafýndan yerden kaldýrýldýn.", playerid, ReturnUserName ( playerid, true, true ) ), MSG_TYPE_INFO ) ;
        }
    }

    return SendServerMessage ( playerid, "Yakýnýnda yardýma ihtiyacý olan yaralý birisi yok.", MSG_TYPE_ERROR ) ;
}
CMD:yardimet(playerid, params[]) 
{
    return cmd_helpup(playerid, params);
}

new BandageTimeTick [ MAX_PLAYERS ] ;
forward OnPlayerBandage(playerid, itemid, tileid);
public OnPlayerBandage(playerid, itemid, tileid) {

////	print("OnPlayerBandage timer called. (injury/core.pwn)");

	if ( IsPlayerBandaging [ playerid ] ) {
		if ( ++ BandageTimeTick [ playerid ] < 15 ) {
			GameTextForPlayer(playerid, sprintf("~w~KALAN BANDAJ SURESI: ~b~%d", 15 - BandageTimeTick [ playerid ]), 950, 3);

			SetTimerEx( "OnPlayerBandage", 1000, false, "iii", playerid, itemid, tileid ) ;
		}

		if ( BandageTimeTick [ playerid ] >= 15 ) {

			BandageTimeTick [ playerid ] = 0 ;
			IsPlayerBandaging [ playerid ] = false ;

			PlayerDamage [ playerid ] [ DAMAGE_LEGS ] = false ;

			SetCharacterHealth(playerid,Character[playerid][character_health]+20.0);

			TogglePlayerControllable ( playerid, true ) ;
			CancelBloodPuddle ( playerid ) ;

			DecreaseItem ( playerid, tileid, 1 ) ;


			ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("** %s yaralarýna bandaj sarar.", ReturnUserName ( playerid, false ))) ;
			return SendServerMessage ( playerid, "Yaralarýna bandaj sardýn, artýk kanaman yok. Daha iyi hissediyorsun.", MSG_TYPE_INFO ) ;
		}
	}

	return true ;
}
#include "data/staff/mods/groups/trial.pwn"
#include "data/staff/mods/groups/basic.pwn"
#include "data/staff/mods/groups/general.pwn"
#include "data/staff/mods/groups/advanced.pwn"
#include "data/staff/mods/func/banevading.pwn"

new bool: PlayerHasPendingReport [ MAX_PLAYERS ] ;
new PlayerReportedID[MAX_PLAYERS];
new PlayerReportReason [MAX_PLAYERS][64 ] ;
new PlayerReportCooldown [ MAX_PLAYERS ] ;
new PlayerReportTime [ MAX_PLAYERS ] ;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new PlayerAdminconvo [ MAX_PLAYERS ] ;
CMD:acinvite ( playerid, params [] ) {

    if ( GetStaffLevel ( playerid ) < STAFF_MODERATOR ) {

        return SendServerMessage ( playerid, "Moderatör deðilsin.", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az stajyer moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new target ;

    if ( sscanf ( params, "k<u>", target ) ) {

        return SendServerMessage ( playerid, "/acinvite [oyuncu]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( target ) ) {

        return SendServerMessage ( playerid, "Seçtiðin oyuncu baðlý deðil. Tekrar dene.", MSG_TYPE_ERROR ) ;
    }

    if ( PlayerAdminconvo [ target ] != -1 ) {

        return SendServerMessage ( playerid, "Oyuncu zaten bir yönetici konuþmasýnda. Bir yöneticiden onlarý çýkarmasýný iste.", MSG_TYPE_ERROR ) ;
    }

    PlayerAdminconvo [ playerid ] = playerid ;
    PlayerAdminconvo [ target ] = playerid ;

    foreach(new i: Player) {
        if ( PlayerAdminconvo [ i ] == PlayerAdminconvo [ playerid ] ) {

            SendSplitMessageEx ( i, 0x955DD9FF, sprintf("[AC] (%d) %s yönetici konuþmasýna eklendi.", target, ReturnUserName ( target, false )) ) ;
        }
    }

    SendServerMessage ( target, sprintf("Moderatör (%d) %s seni yönetici konuþmasýna davet etti. Konuþmak için /ac kullan.", playerid, ReturnUserName ( playerid, true )), MSG_TYPE_ERROR ) ;
    SendServerMessage ( playerid, sprintf("(%d) %s kiþisini konuþmana davet ettin. Konuþmak için /ac, kaldýrmak için /acuninvite kullan.", target, ReturnUserName ( target, true )), MSG_TYPE_ERROR ) ;

    return true ;
}


CMD:acuninvite ( playerid, params [] ) {

    if ( GetStaffLevel ( playerid ) < STAFF_MODERATOR ) {

        return SendServerMessage ( playerid, "Moderatör deðilsin.", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az stajyer moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new target ;

    if ( sscanf ( params, "k<u>", target ) ) {

        return SendServerMessage ( playerid, "/acuninvite [oyuncu]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( target ) ) {

        return SendServerMessage ( playerid, "Seçtiðin oyuncu baðlý deðil. Tekrar dene.", MSG_TYPE_ERROR ) ;
    }

    if ( PlayerAdminconvo [ target ] == -1 ) {

        return SendServerMessage ( playerid, "Oyuncu herhangi bir yönetici konuþmasýnda deðil.", MSG_TYPE_ERROR ) ;
    }


    foreach(new i: Player) {
        if ( PlayerAdminconvo [ i ] == PlayerAdminconvo [ target ] ) {

            SendSplitMessageEx ( i, 0x955DD9FF, sprintf("[AC] (%d) %s, moderatör (%d) %s tarafýndan yönetici konuþmasýndan çýkarýldý.", target, ReturnUserName ( target, false ), playerid, ReturnUserName ( playerid, false )) ) ;
        }
    }

    PlayerAdminconvo [ target ] = -1 ;

    SendServerMessage ( target, sprintf("Moderatör (%d) %s seni mevcut yönetici konuþmasýndan çýkardý.", playerid, ReturnUserName ( playerid, true )), MSG_TYPE_ERROR ) ;
    SendServerMessage ( playerid, sprintf("(%d) %s kiþisini mevcut yönetici konuþmalarýndan çýkardýn.", target, ReturnUserName ( target, true )), MSG_TYPE_ERROR ) ;

    return true ;
}

CMD:ac(playerid, params [] ) {

    if ( PlayerAdminconvo [ playerid ] == -1 ) {

        return SendServerMessage ( playerid, "Bir yönetici konuþmasýnda deðilsin.", MSG_TYPE_ERROR ) ;
    }

    new text [ 144 ] ; 

    if ( sscanf ( params, "s[144]", text ) ) {

        return SendServerMessage ( playerid, "/ac [metin]", MSG_TYPE_ERROR ) ;
    }

    foreach(new i: Player) {

        if ( PlayerAdminconvo [ i ] == PlayerAdminconvo [ playerid ] ) {

            SendSplitMessageEx ( i, 0x955DD9FF, sprintf("[AC] (%d) %s: %s", playerid, ReturnUserName ( playerid, false ), text ) ) ;
        }

        else continue ;
    }

    return true ;
}

CMD:processnamechange ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid, option[7], reason[64], name[MAX_PLAYER_NAME] = EOS ;

    if ( sscanf ( params, "k<u>s[7]S(Belirtilmedi.)[64]", targetid, option, reason ) ) {

        return SendServerMessage ( playerid, "/processn(ame)c(hange) [oyuncuID] [accept/deny] [sebep (reddedilirse)]", MSG_TYPE_ERROR ) ;
    }

    if ( ! PlayerNameChangeRequest [ targetid ]  ) {

        return SendServerMessage ( playerid, "Bu oyuncunun isim deðiþikliði isteði yok.", MSG_TYPE_ERROR ) ;
    }

    if ( ! strcmp ( option, "accept", true ) ) {

        new query [ 128 ], type = PlayerNameChangeRequest [ targetid ] ;

        SendServerMessage ( playerid, sprintf("%s (%d) adlý oyuncunun isim deðiþikliðini onayladýn.", ReturnUserName ( targetid, true), targetid ), MSG_TYPE_INFO ) ;

        switch ( type ) {

            case 1: {

                SendClientMessageToAll(COLOR_STAFF, sprintf("[ÝSÝM DEÐÝÞÝKLÝÐÝ] %s (%d) isim deðiþikliði yaparak %s oldu.", ReturnUserName ( targetid, true ), targetid, PlayerNameChangeName [ targetid ] ) ) ;

                WriteLog ( playerid, "mods/namechange", sprintf("[ÝSÝM DEÐÝÞÝKLÝÐÝ] %s (%d) isim deðiþikliði yaparak %s oldu.", ReturnUserName ( targetid, true ), targetid, PlayerNameChangeName [ targetid ] ) ) ;

                Character [ targetid ] [ character_name ] = PlayerNameChangeName [ targetid ] ;
                SetPlayerName ( targetid, Character [ targetid ] [ character_name ] ) ;
                SetName ( targetid, sprintf("(%d) %s", targetid, ReturnUserName ( targetid, false, true )), 0xCFCFCFFF ) ;
                Account [ targetid ] [ account_namechanges ] --;

                if ( DoesPlayerHaveItem ( targetid, CARD_GUNPERMIT ) != -1 ) {

                    DiscardItem ( targetid, DoesPlayerHaveItem ( targetid, CARD_GUNPERMIT ) ) ;
                }

                if ( DoesPlayerHaveItem ( targetid, CARD_PASSPORT ) != -1 ) {

                    DiscardItem ( targetid, DoesPlayerHaveItem ( targetid, CARD_PASSPORT ) ) ;
                }

                mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_name = '%e' WHERE character_id = %d", 
                    PlayerNameChangeName [ targetid ], Character [ targetid ] [ character_id ] ) ;
                mysql_tquery ( mysql, query ) ;
            }

            case 2: {

                Account [ targetid ] [ account_name ] = PlayerNameChangeName [ targetid ] ;
                Account [ targetid ] [ account_namechanges ] -= 2;

                SendServerMessage ( targetid, sprintf("Master Hesap ismin %s olarak deðiþtirildi.", Account [ targetid ] [ account_name ] ), MSG_TYPE_INFO ) ;

                WriteLog ( playerid, "mods/namechange", sprintf("%s (%d), %s (%d) adlý kullanýcýnýn master hesap ismini %s olarak deðiþtirdi.", ReturnUserName ( playerid, false, false ), playerid, ReturnUserName ( targetid, false, false ), targetid, Account [ targetid ] [ account_name ] ) ) ;

                mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_name = '%e' WHERE account_id = %d", 
                    PlayerNameChangeName [ targetid ], Account [ targetid ] [ account_id ] ) ;
                mysql_tquery ( mysql, query ) ;
            }
        }

        PlayerNameChangeRequest [ targetid ] = 0;
        PlayerNameChangeName [ targetid ] = name;

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_namechanges = %d WHERE account_id = %d", 
            Account [ targetid ] [ account_namechanges ], Account [ targetid ] [ account_id ] ) ;
        mysql_tquery ( mysql, query ) ;
    }

    else if ( ! strcmp ( option, "deny" ) ) {

        if ( ! strlen ( reason ) ) {

            SendServerMessage ( targetid, sprintf("%s isim deðiþikliði isteðini reddetti. Sebep: Belirtilmedi.", ReturnUserName ( playerid, false ) ), MSG_TYPE_INFO ) ;
            SendServerMessage ( playerid, sprintf("%s adlý oyuncunun isim deðiþikliði isteðini reddettin. Sebep: Belirtilmedi.", ReturnUserName ( targetid, false ) ), MSG_TYPE_INFO ) ;
        }
        else {

            SendServerMessage ( targetid, sprintf("%s isim deðiþikliði isteðini reddetti. Sebep: %s", ReturnUserName ( playerid, false ), reason ), MSG_TYPE_INFO ) ;
            SendServerMessage ( playerid, sprintf("%s adlý oyuncunun isim deðiþikliði isteðini reddettin. Sebep: %s", ReturnUserName ( targetid, false ), reason ), MSG_TYPE_INFO ) ;
        }

        PlayerNameChangeRequest [ targetid ] = 0;
        PlayerNameChangeName [ targetid ] = name;
    }

    return true ;
}

CMD:processnc ( playerid, params [] ) return cmd_processnamechange ( playerid, params ) ;

CMD:namechanges ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < BASIC_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az temel moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new string [ 512 ], count = 0 ;

    strcat ( string, "Ýsim\tTür\tYeni Ýsim\n" );

    foreach ( new i : Player ) {

        if ( PlayerNameChangeRequest [ i ] ) {

            strcat ( string, sprintf("%s \t %s \t %s\n", ReturnUserName(i, true), (PlayerNameChangeRequest [ i ] == 1) ? ("Karakter") : ("Master Hesap"), PlayerNameChangeName [ i ] ) ) ;
            count ++;
        }
        else continue;
    }

    if ( ! count ) {

        return SendServerMessage ( playerid, "Þu an bekleyen isim deðiþikliði isteði yok.", MSG_TYPE_ERROR ) ;
    }

    ShowPlayerDialog ( playerid, 9999, DIALOG_STYLE_TABLIST_HEADERS, "Ýsim Deðiþikliði Ýstekleri", string, "Devam", "");

    return true ;
}

CMD:acceptreport ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az stajyer moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid ;

    if ( sscanf ( params, "k<u>", targetid ) ) {

        return SendServerMessage ( playerid, "/acceptreport [oyuncuID]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( targetid ) ) {

        return SendServerMessage ( playerid, "Oyuncu artýk baðlý görünmüyor.", MSG_TYPE_ERROR ) ;
    }

    if ( ! PlayerHasPendingReport [ targetid ] ) {

        return SendServerMessage ( playerid, "Oyuncunun bekleyen bir þikayeti görünmüyor.", MSG_TYPE_ERROR ) ;
    }

    PlayerHasPendingReport [ targetid ] = false ;

    SendServerMessage ( targetid, sprintf("Þikayetin moderatör (%d) %s tarafýndan kabul edildi. Yakýnda seninle iletiþime geçecekler.", playerid, ReturnUserName ( playerid, true ) ), MSG_TYPE_INFO ) ;
    SendModeratorWarning ( sprintf("[ÞÝKAYET] (%d) %s, (%d) %s adlý oyuncunun þikayetini kabul etti: %s", playerid, ReturnUserName ( playerid, true ), targetid, ReturnUserName ( targetid, true ), PlayerReportReason [ targetid ] ), MOD_WARNING_LOW ) ;

    return true ;
}

CMD:ar ( playerid, params [] ) {

    return cmd_acceptreport ( playerid, params ) ;
}

CMD:denyreport ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az stajyer moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new targetid, reason[ 64 ] ;

    if ( sscanf ( params, "k<u>s[64]", targetid, reason ) ) {

        return SendServerMessage ( playerid, "/denyreport [oyuncuID] [sebep]", MSG_TYPE_ERROR ) ;
    }

    if ( ! IsPlayerConnected ( targetid ) ) {

        return SendServerMessage ( playerid, "Oyuncu artýk baðlý görünmüyor.", MSG_TYPE_ERROR ) ;
    }

    if ( ! PlayerHasPendingReport [ targetid ] ) {

        return SendServerMessage ( playerid, "Oyuncunun bekleyen bir þikayeti görünmüyor.", MSG_TYPE_ERROR ) ;
    }

    if ( ! strlen ( reason ) ) {

        return SendServerMessage ( playerid, "Þikayeti reddetmek için bir sebep belirtmelisin.", MSG_TYPE_ERROR ) ;
    }

    if ( strlen ( reason ) > 64 ) {

        return SendServerMessage ( playerid, "Sebep 64 karakterden uzun olamaz.", MSG_TYPE_ERROR ) ;
    }

    PlayerHasPendingReport [ targetid ] = false ;

    SendServerMessage ( targetid, sprintf("Þikayetin moderatör (%d) %s tarafýndan reddedildi. Sebep: %s.", playerid, ReturnUserName ( playerid, true, false ), reason ), MSG_TYPE_INFO ) ;
    SendModeratorWarning ( sprintf("[ÞÝKAYET] (%d) %s, (%d) %s adlý oyuncunun þikayetini reddetti: %s", playerid, ReturnUserName ( playerid, true, false ), targetid, ReturnUserName ( targetid, true, false ), PlayerReportReason [ targetid ] ), MOD_WARNING_LOW ) ;
    SendModeratorWarning ( sprintf("Sebep: %s", reason ), MOD_WARNING_LOW ) ;

    return true ;
}

CMD:dr ( playerid, params [] ) {

    return cmd_denyreport ( playerid, params ) ;
}

CMD:reports ( playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    if ( GetStaffGroup ( playerid ) < TRIAL_MOD ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için en az stajyer moderatör olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new string [ 1024 ], count ;

    string[0] = EOS;

    strcat(string,"Þikayet Eden\tÞikayet Edilen\tSebep\tZaman\n");

    foreach(new i: Player) {

        if ( PlayerHasPendingReport [ i ] ) {

            count ++ ;
            format ( string, sizeof ( string ), "%s(%d) %s\t(%d) %s\t%s\t%s\n",string,i,ReturnUserName(i,false),PlayerReportedID[i],ReturnUserName(PlayerReportedID[i],false),PlayerReportReason [ i ], GetDuration(gettime() - PlayerReportTime[i]) ) ;
        }
    }

    if ( count == 0 ) {

        string = "Gösterilecek þikayet yok." ;
    }

    ShowPlayerDialog ( playerid, 9999, DIALOG_STYLE_TABLIST_HEADERS, "Þikayetler", string, "Devam", "");

    return true ;
}

CMD:report ( playerid, params [] ) {

    if ( PlayerReportCooldown [ playerid ]  >= gettime ()) {

        return SendServerMessage ( playerid, sprintf("Baþka bir þikayet göndermeden önce %d saniye beklemelisin.", PlayerReportCooldown[playerid] - gettime ()), MSG_TYPE_WARN ) ;
    }

    new targetid, reason [ 64 ] ;

    if ( sscanf ( params, "k<u>s[64]", targetid, reason ) ) {

        return SendServerMessage ( playerid, "/report [oyuncuID] [sebep]", MSG_TYPE_ERROR ) ;
    }

    if(!IsPlayerConnected(targetid)) {

        return SendServerMessage(playerid,"Bu oyuncu kimliði baðlý deðil.",MSG_TYPE_ERROR);
    }

    if ( strlen ( reason ) > 64 ) {

        return SendServerMessage ( playerid, "Þikayetler kýsa olmalý! 64 karakterden fazlasýný kullanamazsýn.", MSG_TYPE_ERROR ) ;
    }

    strcopy ( PlayerReportReason [ playerid ], reason ) ;

    PlayerReportedID[playerid] = targetid;
    PlayerHasPendingReport [ playerid ] = true ;
    PlayerReportCooldown [ playerid ] = gettime () + 30 ;
    PlayerReportTime[ playerid ] = gettime (); 

    new string [ 256 ] ;

    SendServerMessage ( playerid, "Þikayetin baþarýyla gönderildi. Tekrar þikayet etmeden önce lütfen birkaç dakika bekle.", MSG_TYPE_WARN ) ;

    foreach(new i: Player) {
        if ( IsPlayerModerator ( i ) ) {

            format ( string, sizeof ( string ), "{59BD93}[ÞÝKAYET]{DEDEDE} (%d) %s, (%d) %s adlý oyuncuyu þikayet etti:{DEDEDE} %s", playerid, ReturnUserName ( playerid, true ), targetid, ReturnUserName(targetid),reason ) ;
            SendSplitMessage(i, 0xDEDEDEFF, string ) ;
            
            if(Account[targetid][account_rulecheck]) { SendClientMessage(i, 0xDEDEDEFF, sprintf( "{CF4040}[UYARI]{DEDEDE} (%d) %s, \"Potansiyel Kural Ýhlali\" olarak iþaretlenmiþ.",targetid,ReturnUserName(targetid))); }
            SendClientMessage(i, 0xDEDEDEFF, sprintf("Bu þikayeti kabul etmek için {59BD93}/acceptreport %d (/ar) yaz.", playerid ) ) ;
        }

        else continue ;
    }

    return true ;
}

CMD:re(playerid, params[]){

    return cmd_reports(playerid,params);
}

CMD:mod(playerid, params [] ) {

    if ( ! IsPlayerModerator ( playerid ) ) {

        return SendServerMessage ( playerid, "Bunu yapabilmek için moderatör olmalýsýn!", MSG_TYPE_ERROR ) ;
    }

    new text [ 144 ] ;

    if ( sscanf ( params, "s[144]", text ) ) {

        return SendServerMessage ( playerid, "/mod [metin]", MSG_TYPE_ERROR ) ;
    }

    if(HasPlayerMutedModeratorChat[playerid]) {

        return SendServerMessage(playerid,"Moderatör sohbetini açmadan bu sohbette konuþamazsýn.",MSG_TYPE_ERROR);
    }

    SendModeratorMessage ( playerid, text ) ;

    return true ;
}

CMD:m(playerid, params [] ) {

    return cmd_mod ( playerid, params ) ;
}

SendModeratorWarning ( const text [], type ) {

    foreach (new i: Player) {

        if ( ! IsPlayerConnected ( i ) ) continue ;

        if ( IsPlayerModerator ( i ) && PlayerModWarnings [ i ] && !HasPlayerMutedModeratorChat[i]) {

            switch ( type ) {

                case MOD_WARNING_LOW: {
                    SendSplitMessage(i, ADMIN_BLUE, text ) ;
                }

                case MOD_WARNING_MED: {
                    SendSplitMessage(i, COLOR_YELLOW, text ) ;
                }

                case MOD_WARNING_HIGH: {
                    SendSplitMessage(i, COLOR_RED, text ) ;
                }
            }
        }

        else continue ;
    }

    print(text ) ;

    return true ;
}

SendModeratorMessage ( playerid, text [] ) {
    
    new string[256],staff_rank [ 64 ] ;

    if ( IsPlayerManager ( playerid ) ) {

        strcat ( staff_rank,  GetStaffRankName ( Account [ playerid ] [ account_stafflevel ] ) ) ;
    }

    else strcat ( staff_rank,  GetStaffGroupName ( Account [ playerid ] [ account_staffgroup ] ) ) ;

    foreach (new i: Player) {

        if ( IsPlayerModerator ( i ) ) {

            if ( strlen ( Account [ playerid ] [ account_staffname ] ) == 0 ) {

                format(string,sizeof(string),"[MOD] %s %s (%d){DEDEDE}: %s", staff_rank, ReturnUserName ( playerid, true ), playerid, text );
                SendSplitMessage(i,0x46B346FF,string);
            }

            else {
                
                format(string,sizeof(string),"[MOD] %s %s (%s) (%d){DEDEDE}: %s", staff_rank, ReturnUserName ( playerid, true ), Account [ playerid ] [ account_staffname ], playerid, text ) ;
                SendSplitMessage(i,0x46B346FF,string);
            }
        }
    }

    return true ;
}

PurgeReports() {

    new dummystring[64];
    dummystring[0] = EOS;
    foreach(new i : Player) {

        PlayerReportReason[i] = dummystring;
        PlayerReportedID[i] = INVALID_PLAYER_ID;
        PlayerHasPendingReport[i] = false;
        PlayerReportCooldown[i] = 0;
    }
    return true;
}
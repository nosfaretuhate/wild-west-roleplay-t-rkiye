#if defined _inc_utils
	#undef _inc_utils
#endif	

// --- TUZAK SÝSTEMÝ ---

CMD:tuzak(playerid, params[]) {

    new choice[20], trapid;

    if(sscanf(params, "s[20]", choice)) { 
        return SendServerMessage(playerid, "/tuzak [kur / iptal / incele / kurtar / topla]", MSG_TYPE_INFO); 
    }

    // TUZAK KURMA (ARM)
    if(!strcmp(choice, "kur", true) || !strcmp(choice, "arm", true)) {

        trapid = FindNearestTrap(playerid, 2.5);
        if(trapid == INVALID_TRAP_ID) { return SendServerMessage(playerid, "Yakýnlarda bir tuzak yok.", MSG_TYPE_ERROR); }

        if(!DoesPlayerOwnTrap(playerid, trapid)) { return SendServerMessage(playerid, "Size ait olmayan bir tuzaðý kuramazsýnýz.", MSG_TYPE_ERROR); }

        if(!Trap[trapid][trap_deployed]) { return SendServerMessage(playerid, "Tuzaðýnýz zaten kurulmuþ durumda.", MSG_TYPE_ERROR); }

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);

        ProxDetector(playerid, 20.0, COLOR_ACTION, sprintf("* %s tuzaðýný kuruyor.", ReturnUserName(playerid, false)));

        SendServerMessage(playerid, "Tuzaðýnýz kýsa süre içinde aktifleþecek, lütfen oradan uzaklaþýn!", MSG_TYPE_INFO);

        SetTimerEx("SetTrapStatus", 7500, false, "iii", playerid, trapid, 0);
    }
    // TUZAK ÝPTAL (DISARM)
    else if(!strcmp(choice, "iptal", true) || !strcmp(choice, "disarm", true)) {

        trapid = FindNearestTrap(playerid, 2.5);
        if(trapid == INVALID_TRAP_ID) { return SendServerMessage(playerid, "Yakýnlarda bir tuzak yok.", MSG_TYPE_ERROR); }

        if(Trap[trapid][trap_deployed]) { return SendServerMessage(playerid, "Bu tuzak zaten devre dýþý.", MSG_TYPE_ERROR); }

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);

        ProxDetector(playerid, 20.0, COLOR_ACTION, sprintf("* %s bir tuzaðý devre dýþý býrakýyor.", ReturnUserName(playerid, false)));

        SetTimerEx("SetTrapStatus", 2500, false, "iii", playerid, trapid, 1);
    }
    // TUZAK ÝNCELE/ARA (EXAMINE)
    else if(!strcmp(choice, "incele", true) || !strcmp(choice, "examine", true)) {

        new Float:x, Float:y, Float:z, count=0, TrapDetect[MAX_TRAPS];
        for(new j=10; j >= 1; j--) {

            GetXYInFrontOfPlayer(playerid, x, y, float(j));

            CA_FindZ_For2DCoord(x,y,z);
            for(new i; i < MAX_TRAPS; i++) {

                if(Trap[i][trap_id] != INVALID_TRAP_ID) {

                    if(TrapDetect[i]) { continue; }
                    if((5.0 >= (x-Trap[i][trap_pos_x]) >= -5.0) && (5.0 >= (y-Trap[i][trap_pos_y]) >= -5.0)) {

                        new Float:dist = GetPlayerDistanceFromPoint(playerid, Trap[i][trap_pos_x], Trap[i][trap_pos_y], Trap[i][trap_pos_z]);
                        SendServerMessage(playerid, sprintf("%.0f metre ileride bir tuzak görebiliyorsun.", dist), MSG_TYPE_INFO);
                        TrapDetect[i] = 1;
                        count++;
                        continue;
                    }
                    else continue;
                }
                else continue;
            }
        }

        if(!count) { return SendServerMessage(playerid, "Önünüzde herhangi bir tuzak fark edemediniz.", MSG_TYPE_INFO); }
    }
    // KURTAR (RELEASE)
    else if(!strcmp(choice, "kurtar", true) || !strcmp(choice, "releasetrapped", true)) {

        new targetid = GetNearestTrappedPlayer(playerid, 10);

        if(targetid == INVALID_PLAYER_ID)
            return SendServerMessage(playerid, "Etrafýnýzda kurtarýlacak kimse yok.", MSG_TYPE_ERROR);


        TogglePlayerBleeding(targetid);
        DamageLegs(targetid);

        IsPlayerTrapped[targetid] = false;

        SendServerMessage(playerid, sprintf("%s adlý kiþiyi tuzaktan kurtardýnýz!", ReturnUserName(targetid, false)), MSG_TYPE_INFO);
        SendServerMessage(targetid, sprintf("%s tarafýndan tuzaktan kurtarýldýnýz.", ReturnUserName(playerid, false)), MSG_TYPE_INFO);

        ProxDetector(playerid, 20, COLOR_ACTION, sprintf("* %s tuzaðý açar ve %s serbest kalýr.", ReturnUserName(playerid), ReturnUserName(targetid)));
        TogglePlayerControllable(targetid, true);
        ClearAnimations(targetid);
    }
    // TOPLA (PICKUP)
    else if(!strcmp(choice, "topla", true) || !strcmp(choice, "pickup", true)) {

        trapid = FindNearestTrap(playerid, 2.5);
        if(trapid == INVALID_TRAP_ID) { return SendServerMessage(playerid, "Yakýnlarda bir tuzak yok.", MSG_TYPE_ERROR); }

        if(!Trap[trapid][trap_deployed]) { return SendServerMessage(playerid, "Tuzaðý toplamadan önce devre dýþý býrakmanýz gerekiyor.", MSG_TYPE_ERROR); }

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, false, false, false, false, 0, SYNC_ALL);

        ProxDetector(playerid, 20.0, COLOR_ACTION, sprintf("* %s tuzaðý yerden toplar.", ReturnUserName(playerid, false)));

        GivePlayerItemByParam(playerid, PARAM_HUNTING, HUNTING_TRAP, 1, 0, 0, 0);
        if(IsTrapBaited(trapid)) { GivePlayerItemByParam(playerid, PARAM_HUNTING, HUNTING_BAIT, 1, 0, 0, 0); }

        RemoveTrap(playerid, trapid);
    }
    else { SendServerMessage(playerid, "/tuzak [kur / iptal / incele / kurtar / topla]", MSG_TYPE_INFO); }
    return true;
}
CMD:trap(playerid, params[]) return cmd_tuzak(playerid, params);


// --- ADMIN TUZAK KOMUTLARI ---

CMD:atuzak(playerid, params[]) {

    if(IsPlayerModerator(playerid)) {

        new choice[20], trapid;
        if(sscanf(params, "s[20]D(-2)", choice, trapid)) {
            return SendServerMessage(playerid, "/atuzak [bilgi / sil / hepsinisil / yenile / hepsi] [trap_id]", MSG_TYPE_ERROR);
        }

        if(trapid == -2) {
            trapid = FindNearestTrap(playerid, 3.0);
        }

        // BÝLGÝ (INFO)
        if(!strcmp(choice, "bilgi", true) || !strcmp(choice, "info", true)) {

            if(Trap[trapid][trap_id] == INVALID_TRAP_ID) {
                return SendServerMessage(playerid, "Geçersiz tuzak ID.", MSG_TYPE_ERROR);
            }

            new acc_name[MAX_PLAYER_NAME], char_name[MAX_PLAYER_NAME];

            inline FindCharName() {
                new rows[2];
                cache_get_row_count(rows[0]);

                if(rows[0]) {
                    new acc_id;
                    cache_get_value_int(0, "account_id", acc_id);
                    cache_get_value_name(0, "character_name", char_name, MAX_PLAYER_NAME);

                    inline FindAccName() {
                        cache_get_row_count(rows[1]);
                        if(rows[1]) {
                            cache_get_value_name(0, "account_name", acc_name, MAX_PLAYER_NAME);

                            SendServerMessage(playerid, sprintf("Tuzak ID: %d", Trap[trapid][trap_id]), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Tuzak Tipi: %d", Trap[trapid][trap_constant]), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Sahibi: %s (%s)", char_name, acc_name), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Kurulu mu: %s", (Trap[trapid][trap_deployed]) ? ("Hayýr (Devre Dýþý)") : ("Evet (Aktif)")), MSG_TYPE_INFO);
                            SendServerMessage(playerid, sprintf("Konum: %02f, %02f, %02f", Trap[trapid][trap_pos_x], Trap[trapid][trap_pos_y], Trap[trapid][trap_pos_z]), MSG_TYPE_INFO);
                        }
                    }
                    MySQL_TQueryInline(mysql, using inline FindAccName, "SELECT account_name FROM master_accounts WHERE account_id = %d", acc_id);
                }
            }
            MySQL_TQueryInline(mysql, using inline FindCharName, "SELECT account_id,character_name FROM characters WHERE character_id = %d", Trap[trapid][trap_owner]);
            return true;
        }
        // SÝL (REMOVE)
        else if(!strcmp(choice, "sil", true) || !strcmp(choice, "remove", true)) {
         
            if(Trap[trapid][trap_id] == INVALID_TRAP_ID) {
                return SendServerMessage(playerid, "Geçersiz tuzak ID.", MSG_TYPE_ERROR);
            }

            SendServerMessage(playerid, sprintf("Tuzak ID %d silindi.", Trap[trapid][trap_id]), MSG_TYPE_INFO);
            RemoveTrap(playerid, trapid);
            return true;
        }
        // HEPSÝNÝ SÝL (REMOVEALL)
        else if(!strcmp(choice, "hepsinisil", true) || !strcmp(choice, "removeall", true)) {
            DeleteAllTraps(playerid);
            SendServerMessage(playerid, "Tüm tuzaklar silindi.", MSG_TYPE_INFO);
            return true;   
        }
        // YENÝLE (REFRESHALL)
        else if(!strcmp(choice, "yenile", true) || !strcmp(choice, "refreshall", true)) {
            RefreshTraps();
            SendServerMessage(playerid, "Tüm tuzaklar yenilendi.", MSG_TYPE_INFO);
            return true;
        }
        // HEPSÝ (ALLTRAPS)
        else if(!strcmp(choice, "hepsi", true) || !strcmp(choice, "alltraps", true)) {
            for(new i; i<MAX_TRAPS; i++) {
                if(Trap[i][trap_id] != INVALID_TRAP_ID) {
                    new acc_name[MAX_PLAYER_NAME], char_name[MAX_PLAYER_NAME];
                    inline FindCharName() {
                        new rows[2];
                        cache_get_row_count(rows[0]);
                        if(rows[0]) {
                            new acc_id;
                            cache_get_value_int(0, "account_id", acc_id);
                            cache_get_value_name(0, "character_name", char_name, MAX_PLAYER_NAME);

                            inline FindAccName() {
                                cache_get_row_count(rows[1]);
                                if(rows[1]) {
                                    cache_get_value_name(0, "account_name", acc_name, MAX_PLAYER_NAME);
                                    SendServerMessage(playerid, sprintf("ID: %d | Sahibi: %s (%s)", Trap[i][trap_id], char_name, acc_name), MSG_TYPE_INFO);
                                }
                            }
                            MySQL_TQueryInline(mysql, using inline FindAccName, "SELECT account_name FROM master_accounts WHERE account_id = %d", acc_id);
                        }
                    }
                    MySQL_TQueryInline(mysql, using inline FindCharName, "SELECT account_id,character_name FROM characters WHERE character_id = %d", Trap[i][trap_owner]);
                }
            }
            return true;
        }
        else return SendServerMessage(playerid, "/atuzak [bilgi / sil / hepsinisil / yenile / hepsi] [trap_id]", MSG_TYPE_ERROR);
    } else {
      SendServerMessage(playerid, "Bu komutu kullanmak için moderatör olmalýsýnýz!", MSG_TYPE_ERROR);
    }
    return true;
}
CMD:atrap(playerid, params[]) return cmd_atuzak(playerid, params);


FindNearestTrap(playerid, Float: range = 5.0) {

    for(new i; i < MAX_TRAPS; i++) {

        if(Trap[i][trap_id] != INVALID_TRAP_ID) {

            if(IsPlayerInRangeOfPoint(playerid, range, Trap[i][trap_pos_x], Trap[i][trap_pos_y], Trap[i][trap_pos_z])) {

                return i;
            }
            else continue;
        }
        else continue;
    }
    return INVALID_TRAP_ID;
}

DoesPlayerOwnTrap(playerid, trapid) {

    if(Character[playerid][character_id] == Trap[trapid][trap_owner]) { return true; }
    return false;
}

IsTrapArmed(trapid) { 
    
    if(!Trap[trapid][trap_deployed]) { return true; }
    return false;
}

IsTrapBaited(trapid) { return Trap[trapid][trap_bait]; }

SetTrapBait(trapid) {

    new query[128];
    Trap[trapid][trap_bait] = 1;
    mysql_format(mysql,query,sizeof(query),"UPDATE traps SET trap_bait = %d WHERE trap_id = %d",Trap[trapid][trap_bait],Trap[trapid][trap_id]);
    mysql_tquery(mysql,query);
    return true;
}

stock RemoveTrapBait(trapid) {

    new query[128];
    Trap[trapid][trap_bait] = 0;
    mysql_format(mysql,query,sizeof(query),"UPDATE traps SET trap_bait = %d WHERE trap_id = %d",Trap[trapid][trap_bait],Trap[trapid][trap_id]);
    mysql_tquery(mysql,query);
    return true;
}

DeleteAllTraps(playerid) {

    for(new i; i < MAX_TRAPS; i++) {

        if(Trap[i][trap_id] != INVALID_TRAP_ID) {

            RemoveTrap(playerid, i);
        }
        else continue;
    }
    return true;
}

forward SetTrapStatus(playerid, trapid, deploy);
public SetTrapStatus(playerid, trapid, deploy) {

    Trap[trapid][trap_deployed] = deploy;

    new query[256];
    mysql_format(mysql, query, sizeof(query), "UPDATE traps SET trap_deployed_state = '%i' WHERE trap_id = '%i'", Trap[trapid][trap_deployed], Trap[trapid][trap_id]);
    mysql_tquery(mysql, query);

    SendServerMessage(playerid, sprintf("Tuzaðýn %s.",(Trap[trapid][trap_deployed]) ? ("deaktif") : ("aktif")), MSG_TYPE_INFO);

}
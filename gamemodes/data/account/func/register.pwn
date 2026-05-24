new IsPlayerCreatingCharacter [ MAX_PLAYERS ] ;

new player_GenderSelection [ MAX_PLAYERS ] ;
new player_RaceSelection [ MAX_PLAYERS ] ;
new player_TownSelection [ MAX_PLAYERS ] ;
new player_SkinSelection [ MAX_PLAYERS ] ;
new player_AgeSelection [ MAX_PLAYERS ] ;

#include "data/account/func/cr/func.pwn"
#include "data/account/func/cr/tds.pwn"
#include "data/account/func/cr/td_func.pwn"
/*
public OnFilterScriptInit() {

    LoadStaticCreationTextDraws ( ) ;

    MySQL_Init () ;

    return true ;
}

public OnFilterScriptExit() {

    for ( new i; i < 1024 ; i ++ ) {

        TextDrawDestroy ( Text: i ) ;
    }

    DestroyCreationTextDraws ( 0 ) ;

    return true ;
}
*/
//CMD:cc(playerid) {

//  return PromptCharacterCreation ( playerid ) ;
//}

CMD:charactercreate(playerid) {

    //gender,race,townspawn,age,name
    if(!IsPlayerCreatingCharacter[playerid]) { return SendServerMessage(playerid,"Bunu sadece karakter oluþturma esnasýnda kullanabilirsiniz.",MSG_TYPE_ERROR); }
    HideCreationTextDraws(playerid);
    task_yield(1);
    new dialog_response[e_DIALOG_RESPONSE_INFO];
    await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Karakter Oluþturma - Cinsiyet","Erkek\nKadýn","Seç","Çýkýþ");

    if(!dialog_response[E_DIALOG_RESPONSE_Response]) {

        IsPlayerCreatingCharacter[playerid] = false;
        player_GenderSelection[playerid] = 0;
        player_RaceSelection[playerid] = 0;
        player_TownSelection[playerid] = 0;
        player_AgeSelection[playerid] = 8;
        HideCreationTextDraws(playerid);    
        return Account_CharacterCheck(playerid);
    }

    player_GenderSelection[playerid] = dialog_response[E_DIALOG_RESPONSE_Listitem];

    new dialog_response_0[e_DIALOG_RESPONSE_INFO];
    await_arr(dialog_response_0) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Karakter Oluþturma - Irk","Beyaz (Kafkas)\nHispandik\nAfrikalý\nAsyalý\nYerli","Seç","Çýkýþ");

    if(!dialog_response_0[E_DIALOG_RESPONSE_Response]) {

        IsPlayerCreatingCharacter[playerid] = false;
        player_GenderSelection[playerid] = 0;
        player_RaceSelection[playerid] = 0;
        player_TownSelection[playerid] = 0;
        player_AgeSelection[playerid] = 8;
        HideCreationTextDraws(playerid);    
        return Account_CharacterCheck(playerid);
    }

    player_RaceSelection[playerid] = dialog_response_0[E_DIALOG_RESPONSE_Listitem];
    UpdateCreationSkin(playerid,0);

    new dialog_response_1[e_DIALOG_RESPONSE_INFO];
    await_arr(dialog_response_1) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Karakter Oluþturma - Baþlangýç Kasabasý","Longcreek\nFremont","Seç","Çýkýþ");

    if(!dialog_response_1[E_DIALOG_RESPONSE_Response]) {

        IsPlayerCreatingCharacter[playerid] = false;
        player_GenderSelection[playerid] = 0;
        player_RaceSelection[playerid] = 0;
        player_TownSelection[playerid] = 0;
        player_AgeSelection[playerid] = 8;
        HideCreationTextDraws(playerid);    
        return Account_CharacterCheck(playerid);
    }

    player_TownSelection[playerid] = dialog_response_1[E_DIALOG_RESPONSE_Listitem];

    new error, dialog_response_2[e_DIALOG_RESPONSE_INFO];

    for(;;) {
        switch(error) {
            case 0: await_arr(dialog_response_2) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_INPUT,"Karakter Oluþturma - Yaþ","Aþaðýya karakterinizin yaþýný giriniz (8-80).","Seç","Çýkýþ");
            case 1: await_arr(dialog_response_2) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_INPUT,"Karakter Oluþturma - Yaþ","Karakteriniz için bir yaþ girmeniz gerekiyor.\n\nAþaðýya karakterinizin yaþýný giriniz (8-80).","Seç","Çýkýþ");
            case 2: await_arr(dialog_response_2) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_INPUT,"Karakter Oluþturma - Yaþ","Karakterinizin yaþý sayýsal bir deðer olmalýdýr.\n\nAþaðýya karakterinizin yaþýný giriniz (8-80).","Seç","Çýkýþ");
            case 3: await_arr(dialog_response_2) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_INPUT,"Karakter Oluþturma - Yaþ","Karakterinizin yaþý 8'den küçük veya 80'den büyük olamaz.\n\nAþaðýya karakterinizin yaþýný giriniz (8-80).","Seç","Çýkýþ");
        }

        error = 0;

        if(!dialog_response_2[E_DIALOG_RESPONSE_Response]) {

            IsPlayerCreatingCharacter[playerid] = false;
            player_GenderSelection[playerid] = 0;
            player_RaceSelection[playerid] = 0;
            player_TownSelection[playerid] = 0;
            player_AgeSelection[playerid] = 8;
            HideCreationTextDraws(playerid);    
            return Account_CharacterCheck(playerid);
        }

        if(!strlen(dialog_response_2[E_DIALOG_RESPONSE_InputText])) { error = 1; }
        else if(!IsNumeric(dialog_response_2[E_DIALOG_RESPONSE_InputText])) { error = 2; }
        else if(strval(dialog_response_2[E_DIALOG_RESPONSE_InputText]) < 8 || strval(dialog_response_2[E_DIALOG_RESPONSE_InputText]) > 80) { error = 3; }

        if(error) { continue; }

        player_AgeSelection[playerid] = strval(dialog_response_2[E_DIALOG_RESPONSE_InputText]);
        break;
    }

    new genders [ ] [ ] = { "Erkek", "Kadýn" } ;
    new races [ ] [ ] = { "Beyaz (Kafkas)", "Hispandik", "Afrikalý", "Asyalý", "Yerli" } ;
    new towns [ ] [ ] = {"Longcreek", "Fremont" } ;
    new string[256];
    string[0] = EOS;

    format(string,sizeof(string),"Mevcut Oluþturma Ýstatistikleri:\n\nCinsiyet: %s\nIrk: %s\nBaþlangýç Kasabasý: %s\nYaþ: %d\n\nKarakter oluþturmayý tamamlamak ve karakterinize isim vermek istiyorsanýz \"Devam Et\" butonuna, baþtan baþlamak istiyorsanýz \"Ýptal Et\" butonuna týklayýn.",genders[player_GenderSelection[playerid]][0],races[player_RaceSelection[playerid]][0],towns[player_TownSelection[playerid]][0],player_AgeSelection[playerid]);

    new dialog_response_3[e_DIALOG_RESPONSE_INFO];
    await_arr(dialog_response_3) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_MSGBOX,"Karakter Oluþturma - Genel Bakýþ",string,"Devam Et","Ýptal Et");

    if(!dialog_response_3[E_DIALOG_RESPONSE_Response]) {

        IsPlayerCreatingCharacter[playerid] = false;
        player_GenderSelection[playerid] = 0;
        player_RaceSelection[playerid] = 0;
        player_TownSelection[playerid] = 0;
        player_AgeSelection[playerid] = 8;
        HideCreationTextDraws(playerid);    
        return Account_CharacterCheck(playerid);
    }
    return NameSelection(playerid);
}

PromptCharacterCreation ( playerid ) {

    LoadCreationTextDraws ( playerid ) ;

    SendServerMessage ( playerid, "Oluþturma paneli yükleniyor, lütfen bekleyin ...", MSG_TYPE_WARN ); 

    SetTimerEx("DelayCharCreator", 1000, false, "i", playerid);

    return true ;
}

forward DelayCharCreator(playerid);
public DelayCharCreator(playerid) {

    return ShowCreationTextDraws ( playerid ) ;
}   

ShowCreationTextDraws ( playerid ) {

    HideCreationTextDraws ( playerid ) ;

    CancelSelectTextDraw ( playerid ) ;
    SelectTextDraw(playerid, 0xA3A3A3FF ) ;

    for ( new i; i < sizeof ( creation_tds_static ); i ++ ) {

        TextDrawShowForPlayer(playerid,  creation_tds_static [ i ] ) ;
    }

    for ( new i; i < sizeof ( creation_tds_player ); i ++ ) {

        PlayerTextDrawShow(playerid,  creation_tds_player [ i ] ) ;
    }

    IsPlayerCreatingCharacter [ playerid ] = true ;
    player_AgeSelection [ playerid ] = 8 ;

    SendServerMessage(playerid,"Eðer oklara týklayamýyorsanýz veya karakter oluþturmayý tamamlayamýyorsanýz, lütfen /charactercreate komutunu kullanýn.",MSG_TYPE_INFO);
    SendServerMessage(playerid,"Verdiðimiz rahatsýzlýktan dolayý özür dileriz!",MSG_TYPE_INFO);
    
    UpdateCreationSkin ( playerid ) ;

    return true ;
}

HideCreationTextDraws ( playerid ) {
    CancelSelectTextDraw ( playerid ) ;

    for ( new i; i < sizeof ( creation_tds_static ); i ++ ) {

        TextDrawHideForPlayer(playerid,  creation_tds_static [ i ] ) ;
    }

    for ( new i; i < sizeof ( creation_tds_player ); i ++ ) {

        PlayerTextDrawHide(playerid,  creation_tds_player [ i ] ) ;
    }
}

UpdateCreationSkin ( playerid, td = 1 ) {

    switch ( player_GenderSelection [ playerid ] ) {

        case 0: {

            switch ( player_RaceSelection [ playerid ] ) {

                case 0: player_SkinSelection [ playerid ] = 95 ; // caucasian
                case 1: player_SkinSelection [ playerid ] = 58 ; // Hispanic
                case 2: player_SkinSelection [ playerid ] = 183 ; // African
                case 3: player_SkinSelection [ playerid ] = 210 ; // Asian
                case 4: player_SkinSelection [ playerid ] = 128 ; // Indian
            }
        }

        case 1: {
            switch ( player_RaceSelection [ playerid ] ) {

                case 0: player_SkinSelection [ playerid ] = 157 ; // caucasian
                case 1: player_SkinSelection [ playerid ] = 298 ; // Hispanic
                case 2: player_SkinSelection [ playerid ] = 215 ; // African
                case 3: player_SkinSelection [ playerid ] = 169 ; // Asian
                case 4: player_SkinSelection [ playerid ] = 131 ; // Indian
            }
        }
    }

    if ( IsPlayerCreatingCharacter [ playerid ] && td) {

        PlayerTextDrawHide(playerid, creation_tds_player [ 0 ] ) ;
        PlayerTextDrawSetPreviewModel(playerid, creation_tds_player [ 0 ], player_SkinSelection [ playerid ] ) ;
        PlayerTextDrawShow(playerid, creation_tds_player [ 0 ] ) ;
    }


    return true; 
}
/*
-> Karakter geliþimi (Character sheet) için:

Avcýlýk (Hunting - deri yüzme): Kazanýlan ganimeti artýrýr, nadir deri düþme þansý saðlar.
Dericilik (Leatherworking): Deriyi iþlenebilir hale getirir. Kýlýflar, çantalar ve nadir eklentiler için katmanlar oluþturulabilir.

////////////////////////////////////
DERÝCÝLÝK/AVCILIK:

seviye çanta: Baþlangýç çantasý.

seviye çanta: Genel maðazadan satýn alýnabilir (800-900 dolar).

seviye çanta:
-> Genel maðazadan ip gerekir.
3x Nadir geyik derisi (en az 7/10 avcýlýk seviyesi gerekir).
Nadir geyik derisini iþleyebilmek (en az 3/5 dericilik seviyesi gerekir).
Nadir maden çýkarabilmek (en az 7/10 madencilik seviyesi gerekir).
Nadir madeni iþleyip eritebilmek (en az 3/5 demircilik seviyesi gerekir).
[NOT: Nadir eþyalarý "kiþiye özel" yap; yani satýlamaz ve takas edilemez olsun.]
--> Bunun için eþyalara (ruh baðý/soulbound) adýnda yeni bir deðiþken ekle.
////////////////////////////////////

: Bir iþ yaparken oyuncunun sýrtýna, iþe özel (kütük, kaya, bitki, et) tekstürlerle giydirilmiþ bir para çantasý objesi ekle. Çökme (crash) durumlarýna karþý bunu bir deðiþkene kaydet. Çanta taþýrken yeni iþ almayý engelle (önce teslimat yapmalarý gerekir).

Madencilik (farklý cevherler, nadir madenler çýkabilir).
Demircilik (seviyeye baðlý olarak nadir madeni eritip silah metali yapma ve silah üretme).

////////////////////////////////////
MADENCÝLÝK/DEMÝRCÝLÝK NADÝRLERÝ:

Nadir maden gerekir (8/10 madencilik).
Eritme yeteneði gerekir (4/5 demircilik).
Avcýlýk maðazasýndan barut gerekir (250 dolar).
-> KESKÝN NÝÞANCI TÜFEÐÝ YAPMAK ÝÇÝN TÜFEÐE DÜRBÜN EKLE.

////////////////////////////////////

Odunculuk (seviyeye göre farklý kütük türleri).
Marangozluk (seviyeye göre farklý üretim yöntemleri).

////////////////////////////////////
ODUNCULUK/MARANGOZLUK NADÝRLERÝ:
Kozmetik þeytan maskesi.
-> Genel maðazadan ip gerekir.
-> Nadir aðaç gerekir (5/10 odunculuk).
-> Üretim yeteneði gerekir (2/5 marangozluk).
////////////////////////////////////

Çiftçilik: (Seviyeye baðlý olarak daha fazla ürün hasadý).
Yemek Piþirme: (Yemeði yakma þansý daha düþük).

Silah seviyesi (sarsýntýyý azaltýr).
Hareket seviyesi (tetikçi/hitman becerisi).

Yakýn dövüþ seviyesi (farklý dövüþ stilleri, daha fazla hasar vurma/daha az hasar alma).
Bloklama seviyesi (artýrýlmýþ bloklama þansý, daha az hasar alma).

--> Çiftçi (önde tohum çantasý).
--> Madenci (sýrtta kömür çantasý).
--> Oduncu (sýrtta ahþap taþýma rafý).

// Yetenek setlerini kullanabilmek için en az 2. seviye olmalýsýn.
// Seviye ne kadar yüksekse, yetenek puaný maliyeti o kadar artar.

enum { // YETENEK AÐACI
GUN_SKILL_MOVEMENT, // 1. seviye: Hareket etmene olanak tanýr (1. seviye: Hitman silah seviyesi) --> NÝÞAN ALMA (AIM) 2. SEVÝYE OLMALIDIR.
GUN_SKILL_AIM, // Silah sarsýntýsýný azaltýr (1: Sarsýntý azalýr (3500), 2: Küçük sarsýntý, bir saniye niþan alýnca geçer: 2500, 3: Hiç sarsýntý olmaz.)

// [BU HIZLI SÝLAH DEÐÝÞTÝRME YETENEÐÝDÝR]: 0. seviye: 3000ms kýlýfa koyma/çekme süresi.
GUN_SKILL_HOLSTER, // Kýlýfa koyma/çekme süresini azaltýr. (1. seviye: 2000ms, 2. seviye: 1000ms, 3. seviye: 500ms).

// 0. seviye sadece meþe (oak) verir. Temel kütük = 1 + rastgele çarpan (3).
JOB_SKILL_WOODCUTTING, // 1. seviye: huþ (birch), 2. seviye: 3 temel kütük, 3. seviye: porsuk (yew), 4. seviye: 5 temel kütük.

JOB_SKILL_FISHING, // 1: Balýkta artýrýlmýþ aðýrlýk, (2: alabalýk tutabilme), 3: köpekbalýðý tutabilme.
JOB_SKILL_MINING, // 1: Artýrýlmýþ cevher miktarý, (2: bakýr ve kalay kazabilme), 3: kömür ve altýn kazabilme.
JOB_SKILL_HUNTING, // 1: Ýzleri görebilme, 2: izleri uzaktan görebilme, 3: geyik kafasý ganimeti alabilme (her biri 150 dolara satýlýr (10'da 2 þans)).
JOB_SKILL_FARMING, 

// 0. seviye balýkçýlýkta yüzme süresi max. 30 saniyedir, sonra bayýlýrsýn (uyarý mesajý gelir).
MISC_SKILL_SWIMMING, // 1: Yüzme sýnýrý yok, sprint yok. 2: Sprint kullanabilme.
MISC_SKILL_HEALTH, // 1: Yakýn dövüþe karþý daha dirençli. 2: Kan kaybý süresi artar, 3: Ölüm süresi azalýr.

// Yakýn dövüþ için, eðer bir oyuncuya niþan almýyorlarsa yumruk atmayý tamamen devre dýþý býrak.
MELEE_SKILL_STYLE, // 1: Boks, 2: Kungfu.
MELEE_SKILL_UNARMED, // 1: Daha fazla yumruk hasarý, 2: tekme kilidi açýlýr, 3: daha az yakýn dövüþ hasarý alma, 4: çelme takma kilidi açýlýr.
MELEE_SKILL_KNIFE, // 1: Býçakla daha fazla hasar, 2: çoðu yakýn dövüþ saldýrýsýný bloklayabilme.
MELEE_SKILL_KNIFE_THROW
} ;
*/

enum  {

	GUN_movement,
	GUN_aiming,
	GUN_holster,

	JOB_fishing,
	JOB_lumber,
	JOB_mining,
	JOB_hunting,
	JOB_farming,
	JOB_blacksmith,

	MISC_swimming,
	MISC_health,

	MELEE_style,
	MELEE_unarmed,
	MELEE_knife,
	MELEE_knife_throw

} ;

enum SkillDataInfo {
	skill_name [ 32 ],
	skill_maxpts,
	skill_constant,
	skill_row [ 32 ]
} ;

new SkillData [ ] [ SkillDataInfo ] = {

	{ "Weapon Movement", 		6,		GUN_movement,		"GUN_movement" 	}, 
	{ "Weapon Aiming", 			4,		GUN_aiming,			"GUN_aiming" 	}, 
	{ "Weapon Holstering", 		3,		GUN_holster,		"GUN_holster" 	}, 
	
	{ "Fishing", 				2,		JOB_fishing,		"JOB_fishing" 	}, 	
	{ "Woodcutting", 			3,		JOB_lumber,			"JOB_lumber" 	}, 	
	{ "Mining", 				3,		JOB_mining,			"JOB_mining" 	}, 	
	{ "Hunting", 				0,		JOB_hunting,		"JOB_hunting" 	}, 
	{ "Farming", 				0,		JOB_farming,		"JOB_farming" 	},
	{ "Blacksmith",				6,		JOB_blacksmith,		"JOB_blacksmith" }, 
	
	{ "Swimming", 				2,		MISC_swimming,		"MISC_swimming" }, 
	{ "Health", 				0,		MISC_health,		"MISC_health" 	}, 
	
	{ "Fight Style", 			1,		MELEE_style,		"MELEE_style" 	}, 
	{ "Unarmed", 				0,		MELEE_unarmed,		"MELEE_unarmed" }, 
	{ "Knife",		 			0,		MELEE_knife,		"MELEE_knife" 	}, 
	{ "Knife Throwing", 		1,		MELEE_knife_throw,	"MELEE_knife_throw" }
} ;

new PlayerSkill [ MAX_PLAYERS ] [ sizeof ( SkillData ) ] ;

#include "data/skills/func/data.pwn"
#include "data/skills/func/swimming.pwn"
#include "data/skills/func/weapon.pwn"

CMD:skills(playerid, params [] ){

	if ( ! strcmp ( params, "show" ) ) {

		return ShowPlayerSkills ( playerid ) ;
	}

	else if ( ! strcmp(params, "reset" ) ) {

		ResetPlayerSkillPoints ( playerid ) ;
	}	

	else SendServerMessage ( playerid, "/skills [show(göster)/reset(sýfýrla)]", MSG_TYPE_ERROR ) ;

	return true ;
}

ShowPlayerSkills ( playerid ) {

    SendClientMessage(playerid, COLOR_YELLOW, sprintf("Buradan mevcut yeteneklerini görebilirsin. [Kullanýlabilir yetenek puaný: %d]", Character [ playerid ] [ character_skillpoints ] ));

    SendClientMessage(playerid, -1, 
        sprintf("{917E5E}[SÝLAH]{dedede} Hareket: %d/%d - Niþan Alma: %d/%d - Kýlýf/Çekiþ: %d/%d", PlayerSkill [ playerid ] [ GUN_movement ], SkillData [ GUN_movement ] [ skill_maxpts ], PlayerSkill [ playerid ] [ GUN_aiming ], SkillData [ GUN_aiming ] [ skill_maxpts ], PlayerSkill [ playerid ] [ GUN_holster ], SkillData [ GUN_holster ] [ skill_maxpts ] )) ;
    SendClientMessage(playerid, -1, 
        sprintf("{77915E}[MESLEKLER]{dedede} Balýkçýlýk: %d/%d - Odunculuk: %d/%d - Madencilik: %d/%d - Avcýlýk: %d/%d - Çiftçilik: %d/%d\n", PlayerSkill [ playerid ] [ JOB_fishing ],    SkillData [ JOB_fishing ] [ skill_maxpts ],PlayerSkill [ playerid ] [ JOB_lumber ], SkillData [ JOB_lumber ] [ skill_maxpts ], PlayerSkill [ playerid ] [ JOB_mining ], SkillData [ JOB_mining ] [ skill_maxpts ], PlayerSkill [ playerid ] [ JOB_hunting ], SkillData [ JOB_hunting ] [ skill_maxpts ], PlayerSkill [ playerid ] [ JOB_farming], SkillData [ JOB_farming ] [ skill_maxpts ] )) ;
    SendClientMessage(playerid, -1, 
        sprintf("{77915E}[MESLEKLER]{dedede} Demircilik: %d/%d", PlayerSkill [ playerid ] [ JOB_blacksmith ], SkillData [ JOB_blacksmith ] [ skill_maxpts ] ) ) ;
    SendClientMessage(playerid, -1, 
        sprintf("{5E93A8}[YAKIN DÖVÜÞ]{dedede} Dövüþ Stili: %d/%d - Silahsýz: %d/%d - Býçak: %d/%d - Býçak Fýrlatma: %d/%d\n", PlayerSkill [ playerid ] [ MELEE_style ], SkillData [ MELEE_style ] [ skill_maxpts ],PlayerSkill [ playerid ] [ MELEE_unarmed ], SkillData [ MELEE_unarmed ] [ skill_maxpts ], PlayerSkill [ playerid ] [ MELEE_knife ], SkillData [ MELEE_knife ] [ skill_maxpts ], PlayerSkill [ playerid ] [ MELEE_knife_throw ], SkillData [ MELEE_knife_throw ] [ skill_maxpts ] )) ;
    SendClientMessage(playerid, -1, 
        sprintf("{B0B0B0}[DÝÐER]{dedede} Yüzme: %d/%d - Saðlýk: %d/%d", PlayerSkill [ playerid ] [ MISC_swimming ], SkillData [ MISC_swimming ] [ skill_maxpts ],  PlayerSkill [ playerid ] [ MISC_health ], SkillData [ MISC_health ] [ skill_maxpts ] )) ;

    return true ;
}
ResetPlayerSkillPoints ( playerid ) {

    if ( Character [ playerid ] [ character_skillpoints ] != 0 ) {

        return SendServerMessage ( playerid, "Yetenek puanlarýný sýfýrlamadan önce tüm puanlarýný harcamýþ olmalýsýn.", MSG_TYPE_ERROR ) ;
    }

    new query [ 256 ] ;

    for ( new i; i < sizeof ( SkillData ); i ++ ) {

        mysql_format ( mysql, query, sizeof ( query ), "UPDATE character_skills SET %s = 0 WHERE character_id = '%d'", SkillData [ i ] [ skill_row ], Character [ playerid ] [ character_id ] ) ;
        mysql_tquery ( mysql, query ); 

        PlayerSkill [ playerid ] [ i ] = 0 ;
    }

    Character [ playerid ] [ character_skillpoints ] = Character [ playerid ] [ character_level ] ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_skillpoints = %d WHERE character_id = '%d'",  Character [ playerid ] [ character_skillpoints ], Character [ playerid ] [ character_id ] ) ;
    mysql_tquery ( mysql, query );

    SendServerMessage ( playerid, sprintf("%d yetenek puaný iade edildi. Tüm yeteneklerin sýfýrlandý.", Character [ playerid ] [ character_level ] ), MSG_TYPE_WARN ) ;

    return true ;
}

CMD:levelup ( playerid, params [] ) {

    new option [ 32 ] ;

    if ( sscanf ( params, "s[32]", option ) ) {

        return SendServerMessage ( playerid, "/levelup [yetenek_adý]", MSG_TYPE_ERROR ) ;
    }

    for ( new i; i < sizeof ( SkillData ); i ++ ) {

        if ( ! strcmp ( option, SkillData [ i ] [ skill_name ], true ) ) {

            LevelUpSkill ( playerid, i ) ;

            return true ;
        }

        else continue ;
    }

    return true ;
}

LevelUpSkill ( playerid, skillid ) {

    if ( Character [ playerid ] [ character_skillpoints ] <= 0 ) {

        return SendServerMessage ( playerid, "Hiç yetenek puanýn kalmadý. Bir yeteneði yükseltmek için en az bir puana ihtiyacýn var.", MSG_TYPE_ERROR ) ;
    }

    if ( PlayerSkill [ playerid ] [ skillid ] >= SkillData [ skillid ] [ skill_maxpts ] ) {

        return SendServerMessage ( playerid, "Bu yetenekte zaten maksimum seviyedesin. Baþka bir yeteneði yükseltmeyi dene.", MSG_TYPE_ERROR ) ;
    }

    new required;

    if ( ! PlayerSkill [ playerid ] [ skillid ] ) {

        required = 1;
    }

    else {

        required = PlayerSkill [ playerid ] [ skillid ] * 2 ;
    }

    if ( required > Character [ playerid ] [ character_skillpoints ] ) {

        return SendServerMessage ( playerid, sprintf("Yeterli yetenek puanýn yok! %s yeteneðini yükseltmek için %i puan daha gerekiyor.", SkillData [ skillid ] [ skill_name ], ( required - Character [ playerid ] [ character_skillpoints ] ) ), MSG_TYPE_ERROR ) ;
    }

    new query [ 256 ] ;

    Character [ playerid ] [ character_skillpoints ] -= required ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_skillpoints = '%d' WHERE character_id = '%d'", Character [ playerid ] [ character_skillpoints ], Character [ playerid ] [ character_id ] ) ; 
    mysql_tquery ( mysql, query );

    PlayerSkill [ playerid ] [ skillid ] ++ ;

    mysql_format ( mysql, query, sizeof ( query ), "UPDATE character_skills SET %s = '%d' WHERE character_id = '%d'", SkillData [ skillid ] [ skill_row ], PlayerSkill [ playerid ] [ skillid ], Character [ playerid ] [ character_id ] ) ;
    mysql_tquery ( mysql, query );

    SendServerMessage ( playerid, sprintf("%s yeteneðini geliþtirdin. Yeni seviye: %d/%d. Kalan yetenek puanýn: %d.", SkillData [ skillid ] [ skill_name ], PlayerSkill [ playerid ] [ skillid ], SkillData [ skillid ] [ skill_maxpts ], Character [ playerid ] [ character_skillpoints ] ), MSG_TYPE_ERROR ) ;

    return true ;
}
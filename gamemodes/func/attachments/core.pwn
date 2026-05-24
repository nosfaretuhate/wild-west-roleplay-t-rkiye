/*


_model deðiþkeni, modeli diziden çekmesi gerektiði için _array olarak deðiþtirilmelidir.
Gammix'in yeni diyalog include'u ile oyuncak satýn alýmý için bir /buy komutu ekle.
Hazýr baþlamýþken, bu include'u da güncelle ve Drive'da david & benim için bir dizin ekle.

*/

enum {

	ATTACH_TYPE_INVALID,
	ATTACH_TYPE_SPINE,
	ATTACH_TYPE_HEAD,
	ATTACH_TYPE_ARM_LEFT,
	ATTACH_TYPE_ARM_RIGHT,
	ATTACH_TYPE_HAND_LEFT,
	ATTACH_TYPE_HAND_RIGHT,
	ATTACH_TYPE_THIGH_LEFT,
	ATTACH_TYPE_THIGH_RIGHT,
	ATTACH_TYPE_FOOT_LEFT,
	ATTACH_TYPE_FOOT_RIGHT,
	ATTACH_TYPE_CALF_RIGHT,
	ATTACH_TYPE_CALF_LEFT,
	ATTACH_TYPE_FOREARM_LEFT,
	ATTACH_TYPE_FOREARM_RIGHT,
	ATTACH_TYPE_SHOULDER_LEFT,
	ATTACH_TYPE_SHOULDER_RIGHT,
	ATTACH_TYPE_NECK,
	ATTACH_TYPE_JAW
} ;


new PlayerAddingAttachment [ MAX_PLAYERS ] ;
new PlayerEditingObject [ MAX_PLAYERS ] ;

#include "func/attachments/store.pwn" // attachments
#include "func/attachments/data.pwn"
#include "func/attachments/func.pwn"

ShowToyMenu ( playerid ) {

   	new sQuery [ 2048*2 ], temp [ 36 ] ;

	for ( new i; i < sizeof ( Attachments ); i ++ ) {

		temp[0] = EOS ;
		strcat(temp, Attachments [ i ] [ attach_name ], 36 ) ;

		if ( strlen ( Attachments [ i ] [ attach_name ] ) > 12 ) {

			strins(temp, "~n~", 12, 3) ;
		}
		switch(Attachments[i][attach_model]) {
			
			case BANDANA_BROWN,BANDANA_GREEN,BANDANA_OLIVE,BANDANA_ORANGE,BANDANA_PURPLE,BANDANA_RED: { format ( sQuery, sizeof ( sQuery ), "%s%i(0.0, 0.0, -45.0, 2.2)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
			case BELT_BLACK,BELT_BLACKB,BELT_BROWN,BELT_BROWNB,BELT_BULLETS,BELT_ORANGE: { format ( sQuery, sizeof ( sQuery ), "%s%i(0.0, 0.0, -45.0, 3.0)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		    case BANDOLIER: { format ( sQuery, sizeof ( sQuery ), "%s%i(0.0, 0.0, -45.0, 5.0)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		    case HOLSTER_1,HOLSTER_2,HOLSTER_3,HOLSTER_4,HOLSTER_5,HOLSTER_6,SHEATH_1,SHEATH_2: { format ( sQuery, sizeof ( sQuery ), "%s%i(90.0, 90.0, -45.0, 5.0)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		    case KERCHIEF_BLUE,KERCHIEF_GREY,KERCHIEF_OLIVE,KERCHIEF_ORANGE,KERCHIEF_PURPLE,KERCHIEF_RED: { format ( sQuery, sizeof ( sQuery ), "%s%i(90.0, 90.0, -45.0, 2.2)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		    case PONCHO_1,PONCHO_2,PONCHO_3,PONCHO_4,PONCHO_5,PONCHO_6,PONCHO_7,PONCHO_8: { format ( sQuery, sizeof ( sQuery ), "%s%i(0.0, -90.0, 5.0, 5.5)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		    case POUCH_1,POUCH_2,POUCH_3: { format ( sQuery, sizeof ( sQuery ), "%s%i(0.0, 0.0, -45.0, 1.6)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		    case VEST_BLACK,VEST_BLUE,VEST_BROWN,VEST_GREEN,VEST_GREY,VEST_REDA,VEST_REDB: { format ( sQuery, sizeof ( sQuery ), "%s%i(0.0, 0.0, -175.0, 5.0)\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
			default: { format ( sQuery, sizeof ( sQuery ), "%s%i\t%s\n", sQuery, Attachments [ i ] [ attach_model ], Attachments [ i ] [ attach_name ]) ; }
		}

	}

	task_yield(1);

	new dialog_response[e_DIALOG_RESPONSE_INFO];

	for(;;) {

		await_arr(dialog_response) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_PREVMODEL,  "Aksesuar Maðazasý", sQuery, "Seç", "Ýptal");

   		if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

   			if ( ! Character [ playerid ] [ character_handmoney ] ) {

   				if ( Character [ playerid ] [ character_handchange ] < 50 ) {

   					return SendServerMessage ( playerid, "Yeterli paranýz yok. Tüm aksesuarlar 0.50$ tutarýndadýr!", MSG_TYPE_ERROR ) ;
   				}
   			}

   			if ( Attachments [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_model ] == 19347 || Attachments [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_model ] == 19774 || Attachments [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_model ] == 19775 || Attachments [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_model ] == 19776 ) {

   				if ( ! IsLawEnforcementPosse ( Character [ playerid ] [ character_posse ] ) ) {

   					SendServerMessage ( playerid, "Bu aksesuarý satýn almak için bir kanun uygulayýcý çetesinde olmanýz gerekiyor.", MSG_TYPE_ERROR ) ;
   					ShowToyMenu ( playerid ) ;
   					return true ;
   				}
   			}

   			new objectid = Attachments [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_model ] ;

   			PlayerAddingAttachment [ playerid ] = dialog_response [ E_DIALOG_RESPONSE_Listitem ] ;

   			new string[1024];
   			new BoneNames [] [] = {
				
				"Geçersiz", "Omurga", "Kafa", "Sol Kol", "Sað Kol", "Sol El", "Sað El", "Sol Uyluk", "Sað Uyluk",
				"Sol Ayak", "Sað Ayak", "Sað Baldýr", "Sol Baldýr", "Sol Önkol", "Sað Önkol", "Sol Omuz", "Sað Omuz",
				"Boyun", "Çene" 
			} ;

			string[0] = EOS;

			for ( new i = 1, j = sizeof ( BoneNames ); i < j ; i ++ ) {
	
				format ( string, sizeof ( string ), "%s\n%s", string, BoneNames [ i ] [ 0 ] ) ;
			}

			new dialog_response_1 [ e_DIALOG_RESPONSE_INFO ] ;
			await_arr ( dialog_response_1 ) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_LIST,"Aksesuar Kemiðini Seçin",string,"Seç","Ýptal");

			if(dialog_response_1 [ E_DIALOG_RESPONSE_Response ]) {

				new bone = dialog_response_1 [ E_DIALOG_RESPONSE_Listitem ]+1;

				SendServerMessage ( playerid, "Modeli ihtiyaçlarýnýza göre ayarlayýn. Kaydet'e týkladýðýnýzda para sizden alýnacaktýr.", MSG_TYPE_INFO ) ;

				new slot = GetFreeAttachmentSlot ( playerid ) ;

				if ( slot == -1) {

					return SendServerMessage ( playerid, "Boþ bir aksesuar yuvanýz yok gibi görünüyor. Lütfen önce bir eþyayý çýkarýn.", MSG_TYPE_ERROR ) ;
				}

				PlayerEditingObject [ playerid ] = slot ;

				SetPlayerAttachedObject ( playerid, slot, objectid, bone ) ;
				EditAttachedObject ( playerid, PlayerEditingObject [ playerid ] ) ;
			}
			else { continue; }
   		}

		break;
   	}

	return true ;
}

GetFreeAttachmentSlot ( playerid ) {

	for ( new i; i < MAX_ATTACHMENTS; i ++ ) {

		if ( PlayerAttachments [ playerid ] [ i ] [ attach_character_array ] == -1 ) {

			return i ;
		}

		else continue ;
	}

	return -1 ;
}
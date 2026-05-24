public OnPlayerEditAttachedObject(playerid, EDIT_RESPONSE:response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ ) {

	if ( ! response ) {

		if ( index > 5 ) {

			SetupPlayerGunAttachments ( playerid ) ;

			return false ;
		}

		SendServerMessage ( playerid, "Nesneyi düzenlemeyi iptal ettiniz.", MSG_TYPE_INFO ) ;

		RemovePlayerAttachedObject(playerid, index) ;
		Init_LoadPlayerAttachments ( playerid ) ;

		return true ;
	}

	else if(response) {

		if ( index > 5 ) {

			new query [ 512 ] ;

			if ( index == ATTACH_SLOT_PANTS ) {

				if(fScaleX != 1.0 || fScaleY != 1.0 || fScaleZ != 1.0) {

					SendServerMessage(playerid,"Silahýn ölçeðini ayarlayamazsýnýz.",MSG_TYPE_ERROR);

					fScaleX = 1.0, fScaleY = 1.0, fScaleZ = 1.0;
				}

				Character [ playerid ] [ character_trousergun_offsetx ]  	 	= fOffsetX ;
				Character [ playerid ] [ character_trousergun_offsety ]  	 	= fOffsetY ; 
				Character [ playerid ] [ character_trousergun_offsetz ]  	 	= fOffsetZ ;

				Character [ playerid ] [ character_trousergun_rotx ]  		 	= fRotX ;
				Character [ playerid ] [ character_trousergun_roty ]  		 	= fRotY ;
				Character [ playerid ] [ character_trousergun_rotz ]  		 	= fRotZ ;

				Character [ playerid ] [ character_trousergun_scalex ]  		= fScaleX ;
				Character [ playerid ] [ character_trousergun_scaley ]  		= fScaleY ;
				Character [ playerid ] [ character_trousergun_scalez ]  		= fScaleZ ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_trousergun_offsetx = '%f', character_trousergun_offsety = '%f', character_trousergun_offsetz = '%f', character_trousergun_rotx='%f', character_trousergun_roty='%f', character_trousergun_rotz='%f', character_trousergun_scalex = '%f',character_trousergun_scaley = '%f',character_trousergun_scalez = '%f' WHERE character_id='%d'",
					Character [ playerid ] [ character_trousergun_offsetx ], Character [ playerid ] [ character_trousergun_offsety ], Character [ playerid ] [ character_trousergun_offsetz ],
					Character [ playerid ] [ character_trousergun_rotx ], Character [ playerid ] [ character_trousergun_roty ], Character [ playerid ] [ character_trousergun_rotz ], 
					Character [ playerid ] [ character_trousergun_scalex ], Character [ playerid ] [ character_trousergun_scaley ], Character [ playerid ] [ character_trousergun_scalez ],
					Character [ playerid ] [ character_id ] ) ;

				mysql_tquery ( mysql, query ) ;

				SendServerMessage ( playerid, "Pantolon yuvanýzdaki silah pozisyonu ayarlandý. Tekrar giriþ yaptýðýnýzda kaydedilmiþ olmalý.", MSG_TYPE_INFO ) ;
			}

			else if ( index == ATTACH_SLOT_BACK ) {

				if(fScaleX != 1.0 || fScaleY != 1.0 || fScaleZ != 1.0) {

					SendServerMessage(playerid,"Silahýn ölçeðini ayarlayamazsýnýz.",MSG_TYPE_ERROR);

					fScaleX = 1.0, fScaleY = 1.0, fScaleZ = 1.0;
				}
				
				Character [ playerid ] [ character_backgun_offsetx ]  	 	= fOffsetX ;
				Character [ playerid ] [ character_backgun_offsety ]  	 	= fOffsetY ; 
				Character [ playerid ] [ character_backgun_offsetz ]  	 	= fOffsetZ ;

				Character [ playerid ] [ character_backgun_rotx ]  		 	= fRotX ;
				Character [ playerid ] [ character_backgun_roty ]  		 	= fRotY ;
				Character [ playerid ] [ character_backgun_rotz ]  		 	= fRotZ ;

				Character [ playerid ] [ character_backgun_scalex ]  		= fScaleX ;
				Character [ playerid ] [ character_backgun_scaley ]  		= fScaleY ;
				Character [ playerid ] [ character_backgun_scalez ]  		= fScaleZ ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_backgun_offsetx = '%f', character_backgun_offsety = '%f', character_backgun_offsetz = '%f', character_backgun_rotx='%f', character_backgun_roty='%f', character_backgun_rotz='%f', character_backgun_scalex = '%f',character_backgun_scaley = '%f',character_backgun_scalez = '%f' WHERE character_id='%d'",
					Character [ playerid ] [ character_backgun_offsetx ], 	Character [ playerid ] [ character_backgun_offsety ], 	Character [ playerid ] [ character_backgun_offsetz ],
					Character [ playerid ] [ character_backgun_rotx ], 		Character [ playerid ] [ character_backgun_roty ], 		Character [ playerid ] [ character_backgun_rotz ], 
					Character [ playerid ] [ character_backgun_scalex ], 	Character [ playerid ] [ character_backgun_scaley ], 	Character [ playerid ] [ character_backgun_scalez ],
					Character [ playerid ] [ character_id ] ) ;

				mysql_tquery ( mysql, query ) ;

				SendServerMessage ( playerid, "Sýrt yuvanýzdaki silah pozisyonu ayarlandý. Tekrar giriþ yaptýðýnýzda kaydedilmiþ olmalý.", MSG_TYPE_INFO ) ;
			}

			else if ( index == ATTACH_SLOT_MASK ) {


				Character [ playerid ] [ character_mask_offsetx ]  	 	= fOffsetX ;
				Character [ playerid ] [ character_mask_offsety ]  	 	= fOffsetY ; 
				Character [ playerid ] [ character_mask_offsetz ]  	 	= fOffsetZ ;

				Character [ playerid ] [ character_mask_rotx ]  		= fRotX ;
				Character [ playerid ] [ character_mask_roty ]  		= fRotY ;
				Character [ playerid ] [ character_mask_rotz ]  		= fRotZ ;

				Character [ playerid ] [ character_mask_scalex ]  		= fScaleX ;
				Character [ playerid ] [ character_mask_scaley ]  		= fScaleY ;
				Character [ playerid ] [ character_mask_scalez ]  		= fScaleZ ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET character_mask_offsetx = '%f', character_mask_offsety = '%f', character_mask_offsetz = '%f', character_mask_rotx='%f', character_mask_roty='%f', character_mask_rotz='%f', character_mask_scalex = '%f',character_mask_scaley = '%f',character_mask_scalez = '%f' WHERE character_id='%d'",
					Character [ playerid ] [ character_mask_offsetx ], 	Character [ playerid ] [ character_mask_offsety ], 	Character [ playerid ] [ character_mask_offsetz ],
					Character [ playerid ] [ character_mask_rotx ], 		Character [ playerid ] [ character_mask_roty ], 		Character [ playerid ] [ character_mask_rotz ], 
					Character [ playerid ] [ character_mask_scalex ], 	Character [ playerid ] [ character_mask_scaley ], 	Character [ playerid ] [ character_mask_scalez ],
					Character [ playerid ] [ character_id ] ) ;

				mysql_tquery ( mysql, query ) ;

				SendServerMessage ( playerid, "Maske pozisyonu ayarlandý. Tekrar giriþ yaptýðýnýzda kaydedilmiþ olmalý.", MSG_TYPE_INFO ) ;
			}

			SetupPlayerGunAttachments ( playerid ) ;
		}

		if ( index < 5 ) {

			new query [ 1024 ], arrayid = PlayerAddingAttachment [ playerid ], editingid = PlayerEditingObject [ playerid ] ;

			if ( arrayid == -1 ) {

				arrayid = PlayerAttachments [ playerid ] [ editingid ] [ attach_character_array] ;
			}

			if ( PlayerAddingAttachment [ playerid ] != -1 ) {

	   			TakeCharacterChange ( playerid, 50, MONEY_SLOT_HAND ) ;
	   			SendServerMessage ( playerid, "Aksesuar için 0.50$ ödediniz. /attachments komutunu kullanarak eriþebilirsiniz.", MSG_TYPE_INFO ) ;
			}

			else SendServerMessage ( playerid, "Aksesuarýnýzý ayarladýnýz.", MSG_TYPE_INFO ) ;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE attachments SET attach_character_index = %d, attach_character_array = %d, attach_character_bone = %d, \
				attach_character_offsetx = %f, attach_character_offsety = '%f', attach_character_offsetz = '%f', attach_character_rotx = '%f', attach_character_roty = '%f', attach_character_rotz = '%f',\
				attach_character_scalex = '%f', attach_character_scaley = '%f', attach_character_scalez = '%f', attach_character_visible = 1 WHERE attach_character_id = %d AND attach_character_attach_id = %d", 

			 	index, arrayid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ,
				Character [ playerid ] [ character_id ], PlayerAttachments [ playerid ] [ editingid ] [ attach_character_attach_id ]
			) ;

			mysql_tquery ( mysql, query ) ;

			Init_LoadPlayerAttachments ( playerid ) ;
		}

		SetPlayerAttachedObject(playerid, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX , Float:fScaleY, Float:fScaleZ);
	}
	
	#if defined toy_OnPlayerEditAttachedObject
		return toy_OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ );
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEditAttachedObject
	#undef OnPlayerEditAttachedObject
#else
	#define _ALS_OnPlayerEditAttachedObject
#endif

#define OnPlayerEditAttachedObject toy_OnPlayerEditAttachedObject
#if defined toy_OnPlayerEditAttachedObject
	forward toy_OnPlayerEditAttachedObject(playerid, EDIT_RESPONSE:response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ );
#endif

CMD:attachments ( playerid, params [] ) {

	task_yield ( 1 ) ;
	
	new string [ 1024 ], attach_id, dialog_response [ e_DIALOG_RESPONSE_INFO ]  ;

	format ( string, sizeof ( string ), "ID \t Ýsim" ) ;

	for ( new i; i < MAX_ATTACHMENTS ; i ++ ) {

		if ( PlayerAttachments [ playerid ] [ i ] [ attach_character_array ] != -1 ) {
			attach_id = PlayerAttachments [ playerid ] [ i ] [ attach_character_array ] ;

			if ( PlayerAttachments [ playerid ] [ i ] [ attach_character_visible] != 0 ) format ( string, sizeof ( string ), "%s\n%d \t %s [GÝYÝLÝYOR]", string, i, Attachments [ attach_id ] [ attach_name ] ) ;
			else format ( string, sizeof ( string ), "%s\n%d \t %s", string, i, Attachments [ attach_id ] [ attach_name ] ) ;
		}

		else if ( PlayerAttachments [ playerid ] [ i ] [ attach_character_array ] == -1 ) {

			format ( string, sizeof ( string ), "%s\nYok", string ) ;
		}
	}

	await_arr ( dialog_response ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, "Aksesuarlarý Göster", string, "Devam Et", "Ýptal" );

	if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		return false ;
	}

	else if ( dialog_response [ E_DIALOG_RESPONSE_Response ] ) {

		if ( PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_array ] == -1 ) {

			SendServerMessage ( playerid, "Bu yuvada bir aksesuarýnýz yok.", MSG_TYPE_ERROR ) ;
			return cmd_attachments ( playerid, params) ;
		}

		new dialog_response_x [ e_DIALOG_RESPONSE_INFO ] ;
		await_arr ( dialog_response_x ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, "Aksesuarlarý Göster: Düzenleme Menüsü", "Bir eylem seçin\nAksesuarý Giy/Çýkar\nAksesuarý Düzenle\nAksesuarý At", "Devam Et", "Geri" );

		if ( ! dialog_response_x [ E_DIALOG_RESPONSE_Response ] ) {

			return cmd_attachments ( playerid, params ) ;
		}

		else if ( dialog_response_x [ E_DIALOG_RESPONSE_Response ] ) {

			switch ( dialog_response_x [ E_DIALOG_RESPONSE_Listitem ] ) {

				case 0: {

					if ( PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_visible ] ) {

						PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_visible ] = false ;
						RemovePlayerAttachedObject(playerid, PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_index ]) ;
					}

					else {
						PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_visible ] = true ;

						SetPlayerAttachedObject(playerid, PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_index ], Attachments [ PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_array ] ] [ attach_model ], PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_bone ],
							PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_offsetx ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_offsety ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_offsetz ],
							PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_rotx ], 		PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_roty ], 		PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_rotz ],
							PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_scalex ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_scaley ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_scalez ] ) ;
					}

					string [ 0 ] = EOS ;

					mysql_format ( mysql, string, sizeof ( string ), "UPDATE attachments SET attach_character_visible = %d WHERE attach_character_id = %d AND attach_character_attach_id = %d", 
						PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_visible ], Character [ playerid ] [ character_id ], PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_attach_id ] ) ;
					mysql_tquery ( mysql, string ) ;

					SendServerMessage ( playerid, sprintf("\"%s\" adlý aksesuarýnýzý %s.", Attachments [ PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_array ] ] [ attach_name ], ( PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_visible ] ) ? ("giydiniz") : ("çýkardýnýz")), MSG_TYPE_INFO ) ;
					return cmd_attachments ( playerid, params ) ;
				}

				case 1: {

					new dialog_response_ex [ e_DIALOG_RESPONSE_INFO ] ;
					await_arr ( dialog_response_ex ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, "Aksesuarlarý Göster", "Bir eylem seçin\nYerleþimi düzenle\nKemiði deðiþtir", "Devam Et", "Geri" );
					
					if ( ! dialog_response_ex [ E_DIALOG_RESPONSE_Response] ) {

						return cmd_attachments ( playerid, params ) ;
					}

					else if ( dialog_response_ex [ E_DIALOG_RESPONSE_Response ] ) {

						switch ( dialog_response_ex [ E_DIALOG_RESPONSE_Listitem ] ) {

							case 0: {
								
								PlayerAddingAttachment [ playerid ] = -1 ;
								PlayerEditingObject [ playerid ] = dialog_response [ E_DIALOG_RESPONSE_Listitem ] ;

								SetPlayerAttachedObject(playerid, PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_index ], Attachments [ PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_array ] ] [ attach_model ], PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_bone ],
									PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_offsetx ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_offsety ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_offsetz ],
									PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_rotx ], 		PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_roty ], 		PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_rotz ],
									PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_scalex ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_scaley ], 	PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_scalez ] ) ;

								EditAttachedObject(playerid, PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_index ]) ;

								return true ;
							}

							case 1: {
								
								new dialog_response_exe [ e_DIALOG_RESPONSE_INFO ], BoneNames [] [] = {
									"Geçersiz", "Omurga", "Kafa", "Sol Kol", "Sað Kol", "Sol El", "Sað El", "Sol Uyluk", "Sað Uyluk",
									"Sol Ayak", "Sað Ayak", "Sað Baldýr", "Sol Baldýr", "Sol Önkol", "Sað Önkol", "Sol Omuz", "Sað Omuz",
									"Boyun", "Çene" 
								} ;

								string [ 0 ] = EOS ;

								format ( string, sizeof ( string ), "Bir kemik seçin") ;

								for ( new i = 1, j = sizeof ( BoneNames ); i < j ; i ++ ) {

									format ( string, sizeof ( string ), "%s\n%s", string, BoneNames [ i ] [ 0 ] ) ;
								}

								await_arr ( dialog_response_exe ) ShowPlayerAsyncDialog ( playerid, DIALOG_STYLE_TABLIST_HEADERS, "Aksesuarlarý Göster: Kemikleri Düzenleme", string, "Devam Et", "Geri" );

								if ( ! dialog_response_exe [ E_DIALOG_RESPONSE_Response ] ) {

									return cmd_attachments ( playerid, params ) ;
								}

								else if ( dialog_response_exe [ E_DIALOG_RESPONSE_Response ] ) {

									new selection = dialog_response_exe [ E_DIALOG_RESPONSE_Listitem ] + 1 ;

									string [ 0 ] = EOS ;

									mysql_format ( mysql, string, sizeof ( string ), "UPDATE attachments SET attach_character_bone = %d WHERE attach_character_id = %d AND attach_character_attach_id = %d", 
										selection, Character [ playerid ] [ character_id ], PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_attach_id ] ) ;
									mysql_tquery ( mysql, string ) ;

									SendServerMessage ( playerid, sprintf("\"%s\" adlý aksesuarýnýzýn kemiðini %s olarak deðiþtirdiniz.", Attachments [ PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_array ] ] [ attach_name ], BoneNames [ selection ] [ 0 ] ), MSG_TYPE_INFO ) ;
									Init_LoadPlayerAttachments ( playerid ) ;

									return true ;
								}

								return true ;
							}
						}
					}

					return true ;
				}

				case 2: {

					string [ 0 ] = EOS ;

					mysql_format ( mysql, string, sizeof ( string ), "UPDATE attachments SET attach_character_array = -1 WHERE attach_character_id = %d AND attach_character_attach_id = %d", 
						Character [ playerid ] [ character_id ], PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_attach_id ] ) ;

					mysql_tquery ( mysql, string ) ;

					SendServerMessage ( playerid, sprintf("\"%s\" adlý aksesuarýnýzý kaldýrdýnýz.", Attachments [ PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_array ] ] [ attach_name ]), MSG_TYPE_INFO ) ;

					WriteLog ( playerid, "money/clothing_abuse", sprintf ( "%s aksesuarýný sattý. Eðer sürekli kullanýyorsa, para hilesi yapmaya çalýþýyor (+15$).", ReturnUserName ( playerid, false ))) ;


					RemovePlayerAttachedObject(playerid, PlayerAttachments [ playerid ] [ dialog_response [ E_DIALOG_RESPONSE_Listitem ] ] [ attach_character_index ] ) ;
					Init_LoadPlayerAttachments ( playerid ) ;
					
					return true ;
				}
			}

			return true ;
		}

		return true ;
	}

	return true ;
}

CMD:atch(playerid, params[]){
	return cmd_attachments(playerid, params);
}
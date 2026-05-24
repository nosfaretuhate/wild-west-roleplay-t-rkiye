enum QuizData {
    q_question [ 64 ],
    q_correct [ 64 ],
    q_wrong [ 64 ],
    q_wrong2 [ 64 ]
} ;

new RP_Quiz [ ] [ QuizData ] = {
    {"Metagaming nedir?",                                 "OOC (Rol Dýþý) bilgiyi IC (Rol Ýçi) kullanmak.", "IC bilgiyi OOC kullanmak.", "Bir oyuncuya zorla rol dayatmak." },
    {"Powergaming nedir?",                                "Bir oyuncuya zorla eylem dayatmak (Ýmkansýzý yapmak).", "Rolde çok güçlü olmak.", "Sadece kazanmak için oynamak." },
    {"Revenge Killing nedir?",                            "Sizi öldüren birini, canlandýktan sonra intikam için öldürmek.", "Arkadaþýnýzý öldüren birini öldürmek.", "Birine karþý intikam planý yapmak."},
    {"Deathmatching nedir?",                              "Rolsel bir sebep olmadan birini öldürmek.", "Geçerli bir rol sebebiyle birini öldürmek.", "Ölümüne düello yapmak."},
    {"Rol yapmanýn amacý nedir?",                         "Bir karakterin rolüne bürünmek.", "Gördüðün herkesi öldürmek.", "Gerçek hayatta yapamadýklarýný yapmak."},
    {"Bu sunucunun temasý nedir?",                        "Vahþi Batý.", "Orta Çað dönemi.", "Günümüz Amerika Birleþik Devletleri."},
    {"Sunucuda rol yapmayý ne zaman býrakabilirim?",      "Sadece bir yetkilinin izniyle.", "Caným her sýkýldýðýnda.", "Ýnsanlar /b'den konuþtuðunda."},
    {"Hangisi dilbilgisi açýsýndan doðrudur?",            "Bugün çoktan yemek yedim.", "Bugün zaten yerim ben.", "Ben yemek bugün yemek."},
    {"Oyun içi varlýklarý gerçek parayla satabilir miyim?","Hayýr, kesinlikle yasak.", "Evet, bir yetkilinin izniyle.", "Evet, fark etmez."},
    {"Modifikasyon (Mod) kurallarý nedir?",               "Avantaj saðlayan her türlü mod yasaktýr.", "Kendi oyunumu özelleþtirdiðim için her þeyi kullanabilirim.", "Yetkililer yakalamadýðý sürece sorun yok."},
    {"Oyun fiziðini suistimal edebilir miyim? (B-hop vb.)","Hayýr, çünkü bu gerçekçi deðildir.", "Oyunda mümkünse, rolsel olarak da mümkündür.", "Evet, çünkü atlar çok yavaþ."},
    {"Birine tecavüze varan roller yapýlabilir mi?",      "Hayýr, bu tür roller sunucumuzda kesinlikle yasaktýr.", "Evet, sadece karþý tarafýn rýzasý varsa.", "Evet, sonuçta bu bir oyun."},
    {"Birini soyduktan sonra direkt öldürebilir miyim?",  "Hayýr, geçerli bir sebep olmadan öldüremezsiniz.", "Evet, yoksa gidip þerife þikayet eder.", "Fark etmez."},
    {"Ne tür arabalar satýn alabilirsiniz?",              "Hiçbiri, arabalar henüz icat edilmedi.", "Klasik eski model arabalar.", "Her türlü arabayý."},
    {"Hangi chatte emoji/ifade kullanmanýza izin verilir?","Yerel/Genel OOC (Rol Dýþý) chatte.", "Normal IC (Rol Ýçi) chatte.", "Ýstediðim her chatte." },
    {"Bana yardým etmesi için bir yetkiliye PM atabilir miyim?","Hayýr. /report sistemini kullanmalýyým.", "Evet, yetkililer yardýmseverdir.", "Evet, çünkü /report sadece acil durumlar içindir."},
    {"Aþaðýdakilerden hangisi tamamen OOC'dir?",          "Admin Hapsi (Jail).", "Bir yetkili tarafýndan düzenlenen etkinlik.", "Bir rol sahnesini kaybettiðim an."},
    {"Aþaðýdakilerden hangisi doðru bir reklamdýr?",      "The Watering Hole'da bir þeyler içmeye gelin!", "Kolay iþ için bana PM atýn.", "Satýlýk at, forumdan iletiþime geçin."}
} ;

new quiz_SelectionList [ MAX_PLAYERS ] ;
new quiz_CurrentQuestion [ MAX_PLAYERS ] ;
new quiz_WrongAnswers [ MAX_PLAYERS ] ;

StartRPQuiz ( playerid )  {

    new answer_randomizer , titlestring [ 128 ], string [ 256 ] ;

    if ( quiz_SelectionList [ playerid ] == -1 ) { quiz_SelectionList [ playerid ] = randomEx ( 1, 3 ) ; }

    if ( quiz_CurrentQuestion [ playerid ] == -1 ) {

        switch ( quiz_SelectionList [ playerid ] ) {

            case 1: {
                quiz_CurrentQuestion [ playerid ] = 0 ;
            }

            case 2: {
                quiz_CurrentQuestion [ playerid ] = 1 ;
            }

            case 3: {
                quiz_CurrentQuestion [ playerid ] = 2 ;
            }
        }
    }

    quiz_Start:

    switch ( quiz_CurrentQuestion [ playerid ] ) {

        case 15, 16, 17: {

            if ( ! quiz_WrongAnswers [ playerid ] ) {

                new query [ 128 ] ;

                strcopy(string,"{DEDEDE}\
                Kurallara uymayý, /report ve /helpme gibi komutlarý sadece yetkililerle\n\
                iletiþime geçmek amacýyla doðru þekilde kullanacaðýnýzý onaylýyor musunuz?");

                task_yield(1);

                new dialog_response[e_DIALOG_RESPONSE_INFO];
                await_arr(dialog_response) ShowPlayerAsyncDialog(playerid,DIALOG_STYLE_MSGBOX,"{FF6347}UYARI: LÜTFEN OKUYUN",string,"Evet","Hayýr");

                if(dialog_response[E_DIALOG_RESPONSE_Response]) { 

                    mysql_format(mysql,query,sizeof(query),"UPDATE master_accounts SET account_rulecheck = 1 WHERE account_id = %d",Account[playerid][account_id]);
                    mysql_tquery(mysql,query);

                    Account[playerid][account_rulecheck] = 1; 

                    WriteLog(playerid,"register/rulecheck",string);
                }

                string[0] = EOS;

                strcat ( string, "{DEDEDE}\
                Sunucu testini baþarýyla geçtiniz!\n\nSunucunun tam bir üyesi olma yolunda\n\
                ilerliyorsunuz.\n\nBirazdan karakter yaratma ekranýna yönlendirileceksiniz.\nDevam etmek için \
                \"Devam Et\" butonuna basýn.\n\nTeþekkürler ve iyi roller!"); 

                new dialog_response_1[e_DIALOG_RESPONSE_INFO];
                await_arr(dialog_response_1) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_MSGBOX, "Testi Geçtiniz", string, "Devam Et", "" ) ;

                mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_registerquiz = 1 WHERE account_id = %d ", Account [ playerid ] [ account_id ] );
                mysql_tquery ( mysql, query ) ;

                Account [ playerid ] [ account_registerquiz ] = true ;

                quiz_WrongAnswers [ playerid ] = 0 ;
                quiz_CurrentQuestion [ playerid ] = -1 ;
                quiz_SelectionList [ playerid ] = -1 ;

                SendServerMessage ( playerid, "Testi geçtiniz! Ýþlemi tamamlamak için þifrenizi tekrar girin.", MSG_TYPE_INFO ) ;

                return Account_Authenticate ( playerid ) ;
            }

            else {
                SendServerMessage ( playerid, sprintf("Testte %i hatalý cevap verdiðiniz için baþarýsýz oldunuz.", quiz_WrongAnswers [ playerid ] ), MSG_TYPE_ERROR ) ;
                return KickPlayer ( playerid ) ;
            }
        }

        default: {

            quiz_CurrentQuestion [ playerid ] += 3 ;

            answer_randomizer = randomEx ( 0, 2 ) ;

            switch ( answer_randomizer ) {

                case 0: {
                    format ( string, sizeof ( string ), "%s\n%s\n%s", RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_correct ], RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_wrong ], RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_wrong2 ] ) ;
                }

                case 1: {
                    format ( string, sizeof ( string ), "%s\n%s\n%s", RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_wrong ], RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_correct ], RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_wrong2 ] ) ;
                }

                case 2: {
                    format ( string, sizeof ( string ), "%s\n%s\n%s", RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_wrong ], RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_wrong2 ], RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_correct ] ) ;
                }
            }
        }
    }

    task_yield ( 1 ) ;

    new dialog_response [ e_DIALOG_RESPONSE_INFO ];

    strcopy ( titlestring, RP_Quiz [ quiz_CurrentQuestion [ playerid ] ] [ q_question ] ) ;
    await_arr ( dialog_response ) ShowPlayerAsyncDialog(playerid, DIALOG_STYLE_LIST, titlestring, string, "Seç", "Çýkýþ" ) ;

    if ( ! dialog_response [ E_DIALOG_RESPONSE_Response ] ) { KickPlayer ( playerid ) ; }

    else {

        if ( dialog_response [ E_DIALOG_RESPONSE_Listitem ] != answer_randomizer ) {
            quiz_WrongAnswers [ playerid ] ++ ;
        }

        goto quiz_Start ;
    }

	/*

	quiz_Start:

	new quiz_id = quiz_playerQuestion [ playerid ];
	new answer_select, string [ 512 ], titlestring [ 64 ], query [ 128 ] ; 

	if ( quiz_playerQuestion [ playerid ] >= sizeof ( RP_Quiz ) ) {

		quiz_playerQuestion [ playerid ] = 0 ;

		if ( quiz_playerGrade [ playerid ] == sizeof ( RP_Quiz ) ) {

			format ( string, sizeof ( string ), "{DEDEDE}\
			You passed the server quiz!\n\nYou are on your way on becoming a full pledged member of \
			the server.\n\nYou will be taken to the character creation screen momentarily.\nIn order to continue, \
			press \"Continue\".\n\nThanks and good luck!", sizeof ( RP_Quiz ), quiz_playerGrade [ playerid ]); 

			inline QuizResult(pid, dialogid, response, listitem, string:inputtext[] ) { 
			#pragma unused pid, dialogid, response, listitem, inputtext

				///////////////////////////////////////////////

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_registerquiz = 1 WHERE account_id = %d ", Account [ playerid ] [ account_id ] );
				mysql_tquery ( mysql, query ) ;

				Account [ playerid ] [ account_registerquiz ] = true ;

				///////////////////////////////////////////////

				quiz_playerGrade [ playerid ] = 0 ;

				SendServerMessage ( playerid, "You have passed the quiz! Enter your password once again to finish it.", MSG_TYPE_INFO ) ;

				return Account_Authenticate ( playerid ) ;
			}

 			return Dialog_ShowCallback(playerid, using inline QuizResult, DIALOG_STYLE_MSGBOX, "Passed server quiz", string, "Continue" ) ;
		}

		else {
			format ( string, sizeof ( string ), "{DEDEDE}\
				You have failed the server quiz!\n\nYou have to score the maximum (%d) in order to pass. \
				You had %d.\n\nWe advice you to read up on the rules and try to learn a little\nbit more about the server\
				concept and rules before continuing.\n\nBetter luck next time!", sizeof ( RP_Quiz ), quiz_playerGrade [ playerid ]); 

			Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, "Failed server quiz", string, "Quit") ;

			quiz_playerGrade [ playerid ] = 0 ;

			
			return KickPlayer ( playerid) ;
			// Return Kick ;
		} 
	}

	answer_select = random ( 2 ) ;

	if ( ! isnull ( RP_Quiz [ quiz_id ] [ q_question_tip ] ) ) {

		if ( answer_select ) {
			format ( string, sizeof ( string ), "{00A6FF}Question %d{DEDEDE}: \"%s\" \n{C42D2D}TIP:{DEDEDE} %s \n \n{00A6FF}A: {DEDEDE} %s\n{00A6FF}B: {DEDEDE}%s", quiz_id, RP_Quiz [ quiz_id ] [ q_question ], RP_Quiz [ quiz_id ] [ q_question_tip ], RP_Quiz [ quiz_id ] [ q_correct ], RP_Quiz [ quiz_id ] [ q_wrong] );
		}

		else format ( string, sizeof ( string ), "{00A6FF}Question %d{DEDEDE}: \"%s\" \n{C42D2D}TIP:{DEDEDE} %s \n \n{00A6FF}A: {DEDEDE} %s\n{00A6FF}B: {DEDEDE}%s", quiz_id, RP_Quiz [ quiz_id ] [ q_question ], RP_Quiz [ quiz_id ] [ q_question_tip ], RP_Quiz [ quiz_id ] [ q_wrong ], RP_Quiz [ quiz_id ] [ q_correct ] );
	}

	else {

		if ( answer_select ) {
			format ( string, sizeof ( string ), "{00A6FF}Question %d{DEDEDE}: \"%s\" \n \n{00A6FF}A: {DEDEDE} %s\n{00A6FF}B: {DEDEDE}%s", quiz_id, RP_Quiz [ quiz_id ] [ q_question ], RP_Quiz [ quiz_id ] [ q_correct ], RP_Quiz [ quiz_id ] [ q_wrong] );
		}

		else format ( string, sizeof ( string ), "{00A6FF}Question %d{DEDEDE}: \"%s\" \n \n{00A6FF}A: {DEDEDE} %s\n{00A6FF}B: {DEDEDE}%s", quiz_id, RP_Quiz [ quiz_id ] [ q_question ], RP_Quiz [ quiz_id ] [ q_wrong ], RP_Quiz [ quiz_id ] [ q_correct ]  );

	}

	inline QuizHandler(pid, dialogid, response, listitem, string:inputtext[] ) { 
		#pragma unused pid, dialogid, response, listitem, inputtext

		switch ( response ) {

			case 0 : {
				switch ( answer_select ) {
					case false : quiz_playerGrade [ playerid ] ++ ; 
				}
			}

			case 1 : {
				switch ( answer_select ) {
					case true : quiz_playerGrade [ playerid ] ++ ; 
				}
			}
		}

		if ( quiz_playerQuestion [ playerid ] < sizeof ( RP_Quiz ) ) {

			quiz_playerQuestion [ playerid ] ++ ;
			goto quiz_Start ;
		}

		else if ( quiz_playerQuestion [ playerid ] == sizeof ( RP_Quiz ) ) {
			goto quiz_Start ;		
		}
	}

	format ( titlestring, sizeof ( titlestring ), "{DEDEDE} Server Quiz: {00A6FF}(%d/%d)", quiz_playerGrade [ playerid ], sizeof ( RP_Quiz ) ) ;
 	Dialog_ShowCallback(playerid, using inline QuizHandler, DIALOG_STYLE_LIST, titlestring, string, "Answer A", "Answer B" ) ;

 	*/

	return true ;
}
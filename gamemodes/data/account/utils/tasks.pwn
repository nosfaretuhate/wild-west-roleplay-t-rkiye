/*

    Create predefined points and create a dynamic moving arrow.

    -2239.5579, 2357.5815, 4.9803 // task_fishsell
    -2229.0227, 2353.0476, 7.5480 // task_rodsell

    

*/

enum task_data {
    task_id,
    task_desc [ 256 ]

} ;

new TaskList [ ] [ task_data ] = {

    { 1, "Envanterinizi \"N\" tuþuna basarak açýn, balýk oltasý karesine týklayýn ve \"Kuþan\" seçeneðini seçerek ilk balýðýnýzý yakalayýn. Kuþandýktan sonra, balýk tutmak için bir su kaynaðýnýn yakýnýnda \"LALT\" tuþuna basýn." },
    { 2, "Herhangi bir avcýlýk maðazasýndayken envanterinizi \"N\" tuþuna basarak açýp, balýk karesine ve ardýndan \"Sat\" seçeneðine týklayarak yakaladýðýnýz balýklarý satýn." },
    { 3, "Envanterinizden baltanýzý kuþanýp, herhangi bir huþ aðacýnýn yanýna giderek ve \"LALT\" tuþuna basarak ilk aðacýnýzý kesin." },
    { 4, "Bir demirci dükkanýndayken envanterinizi \"N\" tuþuna basarak açýp, odun karesine ve ardýndan \"Sat\" seçeneðine týklayarak odunlarýnýzý satýn." },
    { 5, "Envanterinizden kazmanýzý kuþanýp, bir maden cevherinin yanýna giderek ve \"LALT\" tuþuna basarak ilk madeninizi kazýn." },
    { 6, "Bir demirci dükkanýndayken envanterinizi \"N\" tuþuna basarak açýp, maden karesine ve ardýndan \"Sat\" seçeneðine týklayarak madenlerinizi satýn." },
    { 7, "Herhangi bir ateþli silahla /unholster komutunu kullanýp hayvana ateþ ederek ilk geyiðinizi veya ineðinizi avlayýn." },
    { 8, "Herhangi bir avcýlýk maðazasýndayken envanterinizi \"N\" tuþuna basarak açýp, ilgili kareye (hayvan derisi/eti/bacaðý) ve ardýndan \"Sat\" seçeneðine týklayarak avlarýnýzý satýn." }

} ;


enum task_label_data {

    t_label_id, // to be used in conjunction with task_id, for the moving arrow
    t_label_name [ 64 ],
    Float: t_label_x,
    Float: t_label_y,
    Float: t_label_z
} ;

new TaskLabels [ ] [ task_label_data ] = {
    
    { 2, "[Sunucu Egitimi]\n{DEDEDE}Bos Balik Tezgahi",      -2229.0227, 2353.0476, 7.5480 }

}, DynamicText3D: task_label [ sizeof ( TaskLabels ) ] ;

enum task_checkpoint_data {

    t_checkpoint_id,
    Float: t_checkpoint_x,
    Float: t_checkpoint_y,
    Float: t_checkpoint_z,
    Float: t_checkpoint_size
} ;

// new TaskCheckpoints [ ] [ task_checkpoint_data ] = {

//  { 2, -2229.0227, 2353.0476, 7.5480, 1.0 }
// } ;

new DoingTask [ MAX_PLAYERS ], TaskCheckpoint [ MAX_PLAYERS ] ;

ReturnTaskListSize () { return sizeof ( TaskList ) ; }

Init_TaskLabels ( ) {

    for ( new i; i < sizeof ( TaskLabels ) ; i ++ ) {

        task_label [ i ] = CreateDynamic3DTextLabel(TaskLabels [ i ] [ t_label_name ], 0x77D472FF, TaskLabels [ i ] [ t_label_x ], TaskLabels [ i ] [ t_label_y ], TaskLabels [ i ] [ t_label_z ], 15.0 ) ;
    }

    return true ;
}

// SetTaskCheckPoint ( playerid, taskid ) {

//  if ( TaskCheckpoint [ playerid ] != -1 ) { return false ; }

//  for ( new i; i < sizeof ( TaskCheckpoints ) ; i ++ ) {

//      if ( TaskCheckpoints [ i ] [ t_checkpoint_id ] == taskid ) {

//          TaskCheckpoint [ playerid ] = CreateDynamicCP ( TaskCheckpoints [ i ] [ t_checkpoint_x ], TaskCheckpoints [ i ] [ t_checkpoint_y ], TaskCheckpoints [ i ] [ t_checkpoint_z ], TaskCheckpoints [ i ] [ t_checkpoint_size ] ) ;
//          break ;
//      }

//      else continue ;
//  }

//  return true ;
// }

ProcessTask ( playerid, taskid ) {

    if ( DoingTask [ playerid ] == -1 ) { return false ; }

    for ( new i ; i < sizeof ( TaskList ) ; i ++ ) {

        if ( i == taskid ) {

            new query [ 128 ] ;

            DoingTask [ playerid ] = -1 ;
            
            if ( ! Account [ playerid ] [ account_tutorial ] ) {

                Account [ playerid ] [ account_tutorial ] = 2 ;
            }

            else {

                Account [ playerid ] [ account_tutorial ] ++ ;
            }

            if ( Account [ playerid ] [ account_tutorial ] >= sizeof ( TaskList ) + 1 ) {

                GiveCharacterMoney ( playerid, 125, MONEY_SLOT_HAND ) ;
                SendClientMessage ( playerid, 0x649E66FF, "[GÖREVLER]:{FFFFFF} Tüm görevlerinizi tamamladýnýz ve ödül olarak $125 kazandýnýz." ) ;
            }

            else {

                SendClientMessage ( playerid, 0xC4A754FF, "[GÖREVLER]:{FFFFFF} Bir sonraki göreve geçmek için /task komutunu kullanýn." ) ;
            }

            mysql_format ( mysql, query, sizeof ( query ), "UPDATE master_accounts SET account_tutorial = %d WHERE account_id = %d", Account [ playerid ] [ account_tutorial ], Account [ playerid ] [ account_id ] ) ;
            mysql_tquery ( mysql, query ) ;

            break ; 
        }

        else continue ;
    }
    return true ;
}

CMD:tasks ( playerid, params [] ) {

    SendClientMessage ( playerid, -1, "") ;
    for ( new i; i < sizeof ( TaskList ); i ++ ) {

        if ( Account [ playerid ] [ account_tutorial ] <= TaskList [ i ] [ task_id ] ) {

            if ( strlen ( TaskList [ i ] [ task_desc ] ) <= 100 ) {
                SendClientMessage(playerid, 0xC4A754FF, sprintf("[BEKLEMEDE]{FFFFFF} Görev %d: %s", TaskList [ i ] [ task_id ], TaskList [ i ] [ task_desc ] ) ) ;
            }

            else if ( strlen ( TaskList [ i ] [ task_desc ] ) > 100 ) {

                SendClientMessage(playerid, 0xC4A754FF, sprintf("[BEKLEMEDE]{FFFFFF} Görev %d: %.100s", TaskList [ i ] [ task_id ], TaskList [ i ] [ task_desc ]  ) ) ;
                SendClientMessage(playerid, -1, sprintf("%s", TaskList [ i ] [ task_desc ] [ 100 ]  ) ) ;
            }
        }

        else if ( Account [ playerid ] [ account_tutorial ] > TaskList [ i ] [ task_id ] ) {

            if ( strlen ( TaskList [ i ] [ task_desc ] ) <= 100 ) {
                SendClientMessage(playerid, 0x649E66FF, sprintf("[TAMAMLANDI]{FFFFFF} Görev %d: %s", TaskList [ i ] [ task_id ], TaskList [ i ] [ task_desc ] ) ) ;
            }

            else if ( strlen ( TaskList [ i ] [ task_desc ] ) > 100 ) {
                
                SendClientMessage(playerid, 0x649E66FF, sprintf("[TAMAMLANDI]{FFFFFF} Görev %d: %.100s", TaskList [ i ] [ task_id ], TaskList [ i ] [ task_desc ]  ) ) ;
                SendClientMessage(playerid, -1, sprintf("%s", TaskList [ i ] [ task_desc ] [ 100 ]  ) ) ;
            }

        }
    }

    SendClientMessage ( playerid, -1, "") ;

    SendClientMessage(playerid, -1, "Bir sonraki görevinizi yapmak ve seriyi baþlatmak için /task komutunu kullanýn. Ýptal etmek için /notask kullanýn." ) ;

    return true ;
}

CMD:task ( playerid, params [] ) {

    if ( DoingTask [ playerid ] != -1 ) {

        new id = DoingTask [ playerid ] ;

        if ( strlen ( TaskList [ id ] [ task_desc ] ) <= 100 ) {

            SendClientMessage(playerid, -1, sprintf("Görev %d: %s", TaskList [ id ] [ task_id ], TaskList [ id ] [ task_desc ] ) ) ;
        }

        else if ( strlen ( TaskList [ id ] [ task_desc ] ) > 100 ) {

            SendClientMessage(playerid, -1, sprintf("Görev %d: %.100s", TaskList [ id ] [ task_id ], TaskList [ id ] [ task_desc ]  ) ) ;
            SendClientMessage(playerid, -1, sprintf("%s", TaskList [ id ] [ task_desc ] [ 100 ]  ) ) ;
        }

        return SendServerMessage ( playerid, "Zaten aktif bir görev yapýyorsunuz. Mevcut görevinizi iptal etmek için /notask komutunu kullanýn.", MSG_TYPE_ERROR ) ;
    }

    new taskid = Account [ playerid ] [ account_tutorial ] ;

    if ( ! taskid ) { taskid = 1 ; }

    if ( taskid >= sizeof ( TaskList ) + 1 ) {

        return SendServerMessage ( playerid, "Zaten tüm görevlerinizi tamamladýnýz.", MSG_TYPE_ERROR ) ;
    }

    for ( new i ; i < sizeof ( TaskList ) ; i ++ ) {

        if ( TaskList [ i ] [ task_id ] == taskid ) {
        
            if ( strlen ( TaskList [ i ] [ task_desc ] ) <= 100 ) {

                SendClientMessage(playerid, -1, sprintf("Görev %d: %s", TaskList [ i ] [ task_id ], TaskList [ i ] [ task_desc ] ) ) ;
            }

            else if ( strlen ( TaskList [ i ] [ task_desc ] ) > 100 ) {

                SendClientMessage(playerid, -1, sprintf("Görev %d: %.100s", TaskList [ i ] [ task_id ], TaskList [ i ] [ task_desc ]  ) ) ;
                SendClientMessage(playerid, -1, sprintf("%s", TaskList [ i ] [ task_desc ] [ 100 ]  ) ) ;
            }

            //SetTaskCheckPoint ( playerid, taskid ) ;

            DoingTask [ playerid ] = i ;

            break ;
        }
    }

    return true ;
}

CMD:notask ( playerid, params [ ] ) {

    if ( DoingTask [ playerid ] != -1 ) {

        if ( TaskCheckpoint [ playerid ] != -1 ) {

            DestroyDynamicCP ( TaskCheckpoint [ playerid ] ) ;
            TaskCheckpoint [ playerid ] = -1 ;
        }

        DoingTask [ playerid ] = -1 ;

        SendServerMessage ( playerid, "Mevcut görevinizi iptal ettiniz.", MSG_TYPE_INFO ) ;
    }

    else SendServerMessage ( playerid, "Þu anda aktif bir görev yapmýyorsunuz!", MSG_TYPE_ERROR ) ;
    return true ;
}
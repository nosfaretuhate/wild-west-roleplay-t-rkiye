#define MAX_LOTTERY_AMOUNT (50000)
#define LOTTERY_TICK_TIMER (3600000)

enum LotteryData {

	lottery_amount
};

new Lottery[LotteryData];

new bool: LotteryWinner [ MAX_PLAYERS ];

////////////////////////////////////////////

Init_LoadLottery ( ) {

	Lottery [ lottery_amount ] = 0;

	return mysql_tquery ( mysql, "SELECT * FROM lottery", "LoadLotteryData" ) ;
}

forward LoadLotteryData (  ) ;
public LoadLotteryData (  ) {
	new rows ;

	cache_get_row_count ( rows ) ;

	if ( ! rows ) {

		mysql_tquery ( mysql, "INSERT INTO lottery (lottery_amount) VALUES (100)" ) ;
		return Init_LoadLottery ( ) ;
	}

    if ( rows ) {

		cache_get_value_int ( 0, "lottery_amount", Lottery [ lottery_amount ] ) ;

		printf ( "* Loaded Lottery (%d)", Lottery [ lottery_amount ] ) ;
	}

	return true ;
}

////////////////////////////////////////////

stock ReturnPotAmount () {

	return Lottery [ lottery_amount ];
}

stock AddToLotteryPot ( amount ) {

	new query [ 128 ];

	if ( Lottery [ lottery_amount ] + amount >= MAX_LOTTERY_AMOUNT ) { return false ; }

	Lottery [ lottery_amount ] += amount;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE lottery SET lottery_amount = %d", Lottery [ lottery_amount ] ) ;
	return mysql_tquery ( mysql, query ) ;
}

SetLotteryWinner ( playerid, bool: option ) {

	LotteryWinner [ playerid ] = option;
}
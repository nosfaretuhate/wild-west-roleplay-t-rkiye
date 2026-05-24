#tryinclude <a_samp>
#tryinclude <a_mysql>
#tryinclude <YSI_Extra\y_inline_mysql>
#tryinclude <pp-mysql>

new MySQL:mysql;

// MySQL info
#if defined SERVER_DEV
new SQL_HOST [36] = "localhost",
    SQL_USER [36] = "root",
    SQL_DATA [36] = "omp_wwrp",
    SQL_PASS [36] = "";
#endif

#if !defined SERVER_DEV
new SQL_HOST [36] = "localhost",
    SQL_USER [36] = "root",
    SQL_DATA [36] = "omp_wwrp",
    SQL_PASS [36] = "";
#endif


MySQL_Init(const database[]) {
    mysql_log(ERROR | WARNING);

/*
	#if defined MAPPING_SERVER
		SQL_DATA [ 0 ] = EOS ;
		strcat(SQL_DATA, "mapping", 8) ;
	#endif

	#if defined DEBUG_SERVER
		SQL_DATA [ 0 ] = EOS ;
		strcat(SQL_DATA, "debug", 8) ;
	#endif		
*/

	SQL_DATA [ 0 ] = EOS ;
	strcat(SQL_DATA, database) ;
    mysql = mysql_connect ( SQL_HOST, SQL_USER, SQL_PASS, SQL_DATA ) ;

    if(mysql_errno(mysql) != 0) return print(" * [SQL] Could not connect to database!\n");
	return print(" * [SQL] Connected to database ");
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	switch(errorid)
	{
		case CR_SERVER_GONE_ERROR:
		{
			printf(" * [SQL] Lost connection to server, trying reconnect...");
		}
		case ER_SYNTAX_ERROR:
		{
			printf(" * [SQL] Something is wrong in your syntax, query: %s",query);
		}
	}
	return 1;
}
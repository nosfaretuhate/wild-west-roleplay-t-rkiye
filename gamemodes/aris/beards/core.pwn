#if defined _inc_core
	#undef _inc_core
#endif

enum {

	HAIR_NONE,

	BEARD_SLIGHT,
	BEARD_SMALL,
	BEARD_MEDIUM,
	BEARD_LONG,
	BEARD_EXTREME,

	MOUSTACHE_SMALL,
	MOUSTACHE_MEDIUM,
	MOUSTACHE_LONG,
}

GetHairType(playerid){
	return Character[playerid][character_beard];
}

SetHairType(playerid, hairtype){

	if(Character[playerid][character_gender] == 1)
		return true;

	Character[playerid][character_beard] = hairtype;

	return true;
}

RemoveHairStage(playerid){

	if(Character[playerid][character_gender] == 1) // Kadın karakterse işlem yapma
		return true;

	switch(Character[playerid][character_beard]){

		case HAIR_NONE: 
			print("Hata: Olmayan bir saçı/sakalı kesemezsin.");

		case BEARD_SLIGHT: {
			Character[playerid][character_beard] = HAIR_NONE;
			printf("Karakter %i yeni tarz: Sakalsız", Character[playerid][character_id]);
		}

		case BEARD_SMALL: {
			Character[playerid][character_beard] = BEARD_SLIGHT;
			printf("Karakter %i yeni tarz: Hafif kirli sakal", Character[playerid][character_id]);
		}

		case BEARD_MEDIUM: {
			Character[playerid][character_beard] = BEARD_SMALL;
			printf("Karakter %i yeni tarz: Kısa sakal", Character[playerid][character_id]);
		}

		case BEARD_LONG: {
			Character[playerid][character_beard] = BEARD_MEDIUM;
			printf("Karakter %i yeni tarz: Orta boy sakal", Character[playerid][character_id]);
		}

		case BEARD_EXTREME: {
			Character[playerid][character_beard] = BEARD_LONG;
			printf("Karakter %i yeni tarz: Uzun sakal", Character[playerid][character_id]);
		}

		case MOUSTACHE_SMALL: {
			Character[playerid][character_beard] = HAIR_NONE;
			printf("Karakter %i yeni tarz: Bıyıksız", Character[playerid][character_id]);
		}

		case MOUSTACHE_MEDIUM: {
			Character[playerid][character_beard] = MOUSTACHE_SMALL;
			printf("Karakter %i yeni tarz: Kısa bıyık", Character[playerid][character_id]);
		}

		case MOUSTACHE_LONG: {
			Character[playerid][character_beard] = MOUSTACHE_MEDIUM;
			printf("Karakter %i yeni tarz: Orta boy bıyık", Character[playerid][character_id]);
		}
	}

	return true;
}


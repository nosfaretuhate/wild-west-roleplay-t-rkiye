
#define MAX_ITEM_NAME       ( 36 )
#define MAX_ITEM_STACK_LIMIT	(5)

enum { // types
	ITEM_TYPE_UNDEFINED,
	ITEM_TYPE_EQUIP, // equipable items
	ITEM_TYPE_MISC, // misc. items; collectibles, props, etc
	ITEM_TYPE_FOOD, // edible items; items for the food system
	ITEM_TYPE_USE, // items a player has to use for a system
	ITEM_TYPE_SEED, // items for the farming system
	ITEM_TYPE_JUNK, // items that a player can't use, only sell
	ITEM_TYPE_CRAFT, // items used for crafting
	ITEM_TYPE_SELL // items used for selling
} ;

enum { // params
	PARAM_UNDEFINED,
	PARAM_HEAL,
	PARAM_HUNGER,
	PARAM_THIRST,
	PARAM_FISHING,
	PARAM_MINING,
	PARAM_LUMBER,
	PARAM_FARMING,
	PARAM_WEAPON,
	PARAM_AMMO,
	PARAM_LIQUOR,
	PARAM_SMOKES,
	PARAM_MISC,
	PARAM_HUNTING,
	PARAM_GUNCREATION,
} ;

enum { // extra params 
	EXTRA_PARAM_UNDEFINED,

	CARD_PASSPORT = 1,
	CARD_GUNPERMIT,

	WILDLIFE_HIDE,
	WILDLIFE_MEAT,
	WILDLIFE_MEAT_LEG,

	FOOD_WATER_FULL,
	FOOD_MILK_FULL,
	FOOD_ORANGE,
	FOOD_APPLE_GREEN,
	FOOD_APPLE_RED,
	FOOD_TOMATO,
	FOOD_CABBAGE,
	FOOD_BANANA,
	FOOD_BREAD,
	FOOD_PUMPKIN,
	FOOD_MEAT,
	FOOD_MEAT_LEG,
	FOOD_COOKED_MEAT,
	FOOD_COOKED_MEAT_LEG,
	FOOD_CANNED_SALMON,
	FOOD_CANNED_CORNED_BEEF,
	FOOD_CANNED_PINEAPPLES,
	FOOD_CANNED_STRAWBERRIES,
	FOOD_CANNED_KIDNEY_BEANS,
	FOOD_CANNED_PEACHES,
	FOOD_CANNED_SWEETCORN,
	FOOD_CANNED_BAKED_BEANS,
	FOOD_CANNED_APRICOTS,
	FOOD_CANNED_PEAS,

	SEED_APPLE_GREEN,
	SEED_APPLE_RED,
	SEED_ORANGE,
	SEED_PUMPKIN,
	SEED_TOMATO,
	SEED_CABBAGE,
	SEED_WHEAT,

	FISHING_ROD,
	FISHING_BLUE_1,
	FISHING_BLUE_2,
	FISHING_YELLOW,
	FISHING_BOOT,
	FISHING_BIGFISH,
	FISHING_SHARK,

	BANDAGE,
	DYNAMITE,

	MINE_PICKAXE,
	MINE_ROCK,
	MINE_IRON_ORE,
	MINE_COPPER_ORE,
	MINE_GOLD_ORE,
	MINE_COAL_ORE,
	MINE_TIN_ORE,

	LUMBER_HATCHET,
	LUMBER_OAK_LOG,
	LUMBER_BIRCH_LOG,
	LUMBER_YEW_LOG,

	CAMERA,

	FARMING_SOIL_BAG,
	FARMING_SHOVEL,
	FARMING_RAKE,
	FARMING_PAIL,
	FARMING_EMPTY_PAIL,

	AMMO_CRATE_PISTOL,
	AMMO_CRATE_SHOTGUN,
	AMMO_CRATE_RIFLE,

	FACTION_AMMO_PISTOL,
	FACTION_AMMO_SHOTGUN,
	FACTION_AMMO_RIFLE,

	LIQUOR_PALELAGER,
	LIQUOR_MILDALE,
	LIQUOR_MALTLIQUOR,
	LIQUOR_WHEATBEER,
	LIQUOR_WHITEWINE,
	LIQUOR_REDWINE,
	LIQUOR_GRAINWHISKEY,
	LIQUOR_MALTWHISKEY,
	LIQUOR_VODKA,

	SMOKE_CIGARPACK,
	SMOKE_BLUNTPACK,

	RADIO,
	SHERIFF_HANDCUFFS,
	SHERIFF_BADGE,

	POCKET_WATCH,
	LOTTERY_TICKET,
	FEDERAL_BADGE,
	PRESIDENTIAL_BADGE,
	MAYORAL_BADGE,
	HUNTING_KNIFE,
	HUNTING_TRAP,
	HUNTING_BAIT,
	THERMOSTAT,
	GLOVES,
	LONG_JOHNS,

	// Gun creation
	FRACTURED_SUBSTANCE,
	FURNACE_COAL,
	INGOT,
	GUNPART,
	
	EMPTY_BASKET,
	ORANGE_BASKET,
	GAPPLE_BASKET,
	RAPPLE_BASKET,
	TOMATO_BASKET,
	CABBAGE_BASKET,
	PUMPKIN_BASKET,
	WHEAT_BASKET,

	SHERIFF_LONG_LASSO,
	SHERIFF_LASSO
} ;

enum { // item_rarity

	ITEM_RARITY_NORMAL,
	ITEM_RARITY_COMMON,
	ITEM_RARITY_RARE,
	ITEM_RARITY_EPIC,
	ITEM_RARITY_LEGENDARY
} ;

enum ItemSetData {
	item_model,
	item_name [ MAX_ITEM_NAME ],
	item_type,
	item_param,
	item_extra_param,
	item_rarity,
	item_toggle,
	item_stack
} ;
new Item [ ] [ ItemSetData ] = {

    // Applicable Items

    { INVALID_OBJECT_ID, "Gecersiz",                 ITEM_TYPE_UNDEFINED,        PARAM_UNDEFINED,        EXTRA_PARAM_UNDEFINED,  ITEM_RARITY_NORMAL, false, 0 } ,

    { 1581, "Devlet Pasaportu",           ITEM_TYPE_UNDEFINED,        PARAM_MISC,             CARD_PASSPORT,          ITEM_RARITY_RARE,       false,          1 } ,
    { 19792, "Silah Ruhsati",           ITEM_TYPE_UNDEFINED,        PARAM_MISC,             CARD_GUNPERMIT,         ITEM_RARITY_EPIC,       false,          1 } ,

    { 11749, "Kelepce",               ITEM_TYPE_UNDEFINED,        PARAM_UNDEFINED,        SHERIFF_HANDCUFFS,      ITEM_RARITY_RARE,       false,          1 } ,
    { 18635, "Cekic",                  ITEM_TYPE_USE,              PARAM_UNDEFINED,        EXTRA_PARAM_UNDEFINED,  ITEM_RARITY_NORMAL,     false,          1 } ,
    { 18644, "Tornavida",             ITEM_TYPE_USE,              PARAM_UNDEFINED,        EXTRA_PARAM_UNDEFINED,  ITEM_RARITY_NORMAL,     false,          1 } ,
    { 11747, "Sargi Bezi",                 ITEM_TYPE_USE,              PARAM_HEAL,             BANDAGE,                ITEM_RARITY_COMMON,     true,           2 } ,
        
    { 19623, "Kamera",                  ITEM_TYPE_EQUIP,            PARAM_WEAPON,           CAMERA,                 ITEM_RARITY_NORMAL,     true,           1 } ,
    { 19347, "Serif Rozeti",           ITEM_TYPE_MISC,             PARAM_UNDEFINED,        SHERIFF_BADGE,          ITEM_RARITY_RARE,       false,          1 } ,
    { 19775, "Federal Rozet",           ITEM_TYPE_MISC,             PARAM_UNDEFINED,        FEDERAL_BADGE       ,   ITEM_RARITY_EPIC,       false,          1 } ,
    { 19774, "Baskanlik Rozeti",      ITEM_TYPE_MISC,             PARAM_UNDEFINED,        PRESIDENTIAL_BADGE,     ITEM_RARITY_LEGENDARY,  false,          1 } ,
    { 19088, "Ip",                    ITEM_TYPE_USE,              PARAM_UNDEFINED,        EXTRA_PARAM_UNDEFINED,  ITEM_RARITY_NORMAL,     false,          1 } ,
    { 1654, "Dinamit",                 ITEM_TYPE_EQUIP,            PARAM_WEAPON,           DYNAMITE,               ITEM_RARITY_EPIC,       true,           2 } ,
    
    // Edible Items 
    { 19570, "Su Sisesi (Dolu)",     ITEM_TYPE_FOOD,             PARAM_THIRST,           FOOD_WATER_FULL,        ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },   
    { 19570, "Sut (Dolu)",             ITEM_TYPE_FOOD,             PARAM_THIRST,           FOOD_MILK_FULL,         ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT }, 
    { 19574, "Portakal",                  ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_ORANGE,            ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19575, "Kirmizi Elma",               ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_APPLE_RED,         ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT }, 
    { 19576, "Yesil Elma",           ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_APPLE_GREEN,       ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT }, 
    { 19577, "Domates",                  ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_TOMATO,            ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19578, "Muz",                  ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_BANANA,            ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19579, "Somun Ekmek",              ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_BREAD,             ITEM_RARITY_COMMON,     true, MAX_ITEM_STACK_LIMIT },
    { 19582, "Pismis Et",             ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_MEAT,              ITEM_RARITY_COMMON,     true, MAX_ITEM_STACK_LIMIT },
    { 19847, "Pismis But",         ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_MEAT_LEG,          ITEM_RARITY_COMMON,     true, MAX_ITEM_STACK_LIMIT },
    { 19320, "Bal Kabagi",                 ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_PUMPKIN,           ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19321, "Lahana",                 ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CABBAGE,           ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19882, "Pismis Et",             ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_COOKED_MEAT,       ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19882, "Pismis But",         ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_COOKED_MEAT_LEG,   ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19567, "Somon Konservesi",           ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_SALMON,     ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19567, "Sogus Konservesi",      ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_CORNED_BEEF,ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19564, "Ananas Konservesi",       ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_PINEAPPLES, ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19564, "Cilek Konservesi",     ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_STRAWBERRIES,ITEM_RARITY_NORMAL,    true, MAX_ITEM_STACK_LIMIT },
    { 19567, "Kuru Fasulye Konservesi",     ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_KIDNEY_BEANS,ITEM_RARITY_NORMAL,    true, MAX_ITEM_STACK_LIMIT },
    { 19564, "Seftali Konservesi",          ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_PEACHES,    ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19567, "Misir Konservesi",        ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_SWEETCORN,  ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19567, "Soslu Fasulye",             ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_BAKED_BEANS,ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19564, "Kayisi Konservesi",         ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_APRICOTS,   ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },
    { 19567, "Bezelye Konservesi",           ITEM_TYPE_FOOD,             PARAM_HUNGER,           FOOD_CANNED_PEAS,       ITEM_RARITY_NORMAL,     true, MAX_ITEM_STACK_LIMIT },


    // farming seeds. -- models need modelled
    { 2663, "Portakal Tohumu",              ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_ORANGE,            ITEM_RARITY_NORMAL,     true, 1 } ,
    { 2663, "Kirmizi Elma Tohumu",           ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_APPLE_RED,         ITEM_RARITY_NORMAL,     true, 1 } ,
    { 2663, "Yesil Elma Tohumu",         ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_APPLE_GREEN,       ITEM_RARITY_NORMAL,     true, 1 } ,
    { 2663, "Domates Tohumu",              ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_TOMATO,            ITEM_RARITY_NORMAL,     true, 1 } ,
    { 2663, "Bal Kabagi Tohumu",             ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_PUMPKIN,           ITEM_RARITY_NORMAL,     true, 1 } ,
    { 2663, "Lahana Tohumu",             ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_CABBAGE,           ITEM_RARITY_NORMAL,     true, 1 } ,
    { 2663, "Bugday Tohumu",               ITEM_TYPE_SEED,             PARAM_UNDEFINED,        SEED_WHEAT,             ITEM_RARITY_NORMAL,     true, 1 } ,
    // Hunting items
    { 19582, "Parca Et",            ITEM_TYPE_SELL,             PARAM_HUNTING,           WILDLIFE_MEAT,          ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19882, "Hayvan Derisi",            ITEM_TYPE_SELL,             PARAM_HUNTING,           WILDLIFE_HIDE,          ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19847, "Cig But",                ITEM_TYPE_SELL,             PARAM_HUNTING,           WILDLIFE_MEAT_LEG,      ITEM_RARITY_NORMAL,     true, 1 } ,
        
    // Fishing Items    
    { 18632, "Olta",             ITEM_TYPE_EQUIP,            PARAM_FISHING,           FISHING_ROD,            ITEM_RARITY_NORMAL,     true, 1 } ,
    { 1604, "Mavi Balik",                ITEM_TYPE_SELL,             PARAM_FISHING,           FISHING_BLUE_1,         ITEM_RARITY_COMMON,     true, 2 } ,
    { 1599, "Sari Balik",              ITEM_TYPE_SELL,             PARAM_FISHING,           FISHING_YELLOW,         ITEM_RARITY_COMMON,     true, 2 } ,
    { 19630, "Buyuk Balik",                ITEM_TYPE_SELL,             PARAM_FISHING,           FISHING_BIGFISH,        ITEM_RARITY_RARE,       true, 2 } ,
    { 1600, "Mavi Balik 2",              ITEM_TYPE_SELL,             PARAM_FISHING,           FISHING_BLUE_2,         ITEM_RARITY_RARE,       true, 2 } ,
    { 1608, "Yavru Kopekbaligi",               ITEM_TYPE_SELL,             PARAM_FISHING,           FISHING_SHARK,          ITEM_RARITY_EPIC,       true, 2 } , 
    { 11735, "Cizme",                    ITEM_TYPE_JUNK,             PARAM_FISHING,           FISHING_BOOT,           ITEM_RARITY_NORMAL,     false, 1 } , // Random fail catch
        
    // Mining Items 
    { PICKAXE, "Kazma",               ITEM_TYPE_EQUIP,            PARAM_MINING,           MINE_PICKAXE,           ITEM_RARITY_RARE,       true, 1 } ,
    { 3929, "Normal Cevher",               ITEM_TYPE_SELL,             PARAM_MINING,           MINE_ROCK,              ITEM_RARITY_NORMAL,     true, 1 } ,
    { NUGGET_COPPER, "Bakir Cevheri",      ITEM_TYPE_SELL,             PARAM_MINING,           MINE_COPPER_ORE,        ITEM_RARITY_COMMON,     true, 1 } ,
    { NUGGET_COAL, "Komur Cevheri",          ITEM_TYPE_SELL,             PARAM_MINING,           MINE_COAL_ORE,          ITEM_RARITY_RARE,       true, 1 } ,
    { NUGGET_TIN, "Teneke Cevheri",            ITEM_TYPE_SELL,             PARAM_MINING,           MINE_TIN_ORE,           ITEM_RARITY_RARE,       true, 1 } ,
    { NUGGET_IRON, "Demir Cevheri",          ITEM_TYPE_SELL,             PARAM_MINING,           MINE_IRON_ORE,          ITEM_RARITY_EPIC,       true, 1 } ,
    { NUGGET_GOLD, "Altin Cevheri",          ITEM_TYPE_SELL,             PARAM_MINING,           MINE_GOLD_ORE,          ITEM_RARITY_EPIC,       true, 1 } ,

    { HATCHET, "Balta",               ITEM_TYPE_EQUIP,            PARAM_LUMBER,           LUMBER_HATCHET,         ITEM_RARITY_COMMON,     true, 1 } ,
    { 19793, "Mese Kutugu",                 ITEM_TYPE_SELL,             PARAM_LUMBER,           LUMBER_OAK_LOG,         ITEM_RARITY_COMMON,     true, 1 } ,
    { 19793, "Nyayin Kutugu",               ITEM_TYPE_SELL,             PARAM_LUMBER,           LUMBER_BIRCH_LOG,       ITEM_RARITY_RARE,       true, 1 } ,
    { 19793, "Porsuk Kutugu",                 ITEM_TYPE_SELL,             PARAM_LUMBER,           LUMBER_YEW_LOG,         ITEM_RARITY_EPIC,       true, 1 } ,

    // Farming shit
    { 2060, "Toprak Torbasi",              ITEM_TYPE_USE,              PARAM_FARMING,          FARMING_SOIL_BAG,       ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19626, "Kurek",                    ITEM_TYPE_USE,              PARAM_FARMING,          FARMING_SHOVEL,         ITEM_RARITY_NORMAL,     true, 1 } ,
    { 18890, "Tirmik",                    ITEM_TYPE_USE,              PARAM_FARMING,          FARMING_RAKE,           ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19468, "Dolu Su Kovasi",       ITEM_TYPE_USE,              PARAM_FARMING,          FARMING_PAIL,           ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19468, "Bos Su Kovasi",        ITEM_TYPE_USE,              PARAM_FARMING,          FARMING_EMPTY_PAIL,     ITEM_RARITY_NORMAL,     true, 1 } ,

    { 2037, "Tabanca Mermi Kasasi",        ITEM_TYPE_USE,              PARAM_AMMO,             AMMO_CRATE_PISTOL,      ITEM_RARITY_COMMON,     true, 1 } ,
    { 2041, "Tufek Mermi Kasasi",       ITEM_TYPE_USE,              PARAM_AMMO,             AMMO_CRATE_SHOTGUN,     ITEM_RARITY_RARE,       true, 1 } ,
    { 2043, "Kalasnikof Mermi Kasasi",         ITEM_TYPE_USE,              PARAM_AMMO,             AMMO_CRATE_RIFLE,       ITEM_RARITY_EPIC,       true, 1 } ,

    { 2037, "Tabanca Mermi Kasasi",        ITEM_TYPE_USE,              PARAM_AMMO,             FACTION_AMMO_PISTOL,    ITEM_RARITY_COMMON,     true, 1 } ,
    { 2041, "Tufek Mermi Kasasi",       ITEM_TYPE_USE,              PARAM_AMMO,             FACTION_AMMO_SHOTGUN,   ITEM_RARITY_RARE,       true, 1 } ,
    { 2043, "Kalasnikof Mermi Kasasi",         ITEM_TYPE_USE,              PARAM_AMMO,             FACTION_AMMO_RIFLE,     ITEM_RARITY_EPIC,       true, 1 } ,

    // Available Beverages
    { 1544, "Hafif Bira",               ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_PALELAGER,       ITEM_RARITY_NORMAL,     true, 1 } ,
    { 1543, "Sert Bira",                 ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_MILDALE,         ITEM_RARITY_NORMAL,     true, 1 } ,
    { 1486, "Yuksek Alkollu Bira",              ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_MALTLIQUOR,      ITEM_RARITY_NORMAL,     true, 1 } ,
    { 1484, "Bugday Birasi",               ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_WHEATBEER,       ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19824, "Beyaz Sarap",              ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_WHITEWINE,       ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19822, "Kirmizi Sarap",                ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_REDWINE,         ITEM_RARITY_NORMAL,     true, 1 } , 
    { 19823, "Tahil Viski",           ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_GRAINWHISKEY,    ITEM_RARITY_NORMAL,     true, 1 } , 
    { 19820, "Malt Viski",            ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_MALTWHISKEY,     ITEM_RARITY_NORMAL,     true, 1 } ,
    { 19821, "Kacak Icki",               ITEM_TYPE_EQUIP,            PARAM_LIQUOR,           LIQUOR_VODKA,           ITEM_RARITY_NORMAL,     true, 1 } ,

    // Ciggies
    {19897, "Puro Paketi (Mavi)",        ITEM_TYPE_EQUIP,            PARAM_SMOKES,           SMOKE_CIGARPACK,        ITEM_RARITY_NORMAL,     true, 1 } ,
    {19896, "Sigara Paketi (Kirmizi)",     ITEM_TYPE_EQUIP,            PARAM_SMOKES,           SMOKE_BLUNTPACK,        ITEM_RARITY_NORMAL,     true, 1 } ,

    // Misc items
    { 19942, "Telsiz Cihazi",     ITEM_TYPE_USE,              PARAM_UNDEFINED,        RADIO,                  ITEM_RARITY_NORMAL,     false, 1 } ,
    { 19043, "Cep Saati",            ITEM_TYPE_UNDEFINED,        PARAM_MISC,             POCKET_WATCH,           ITEM_RARITY_NORMAL,     false, 1 } ,
    { 2953, "Piyango Bileti",           ITEM_TYPE_UNDEFINED,        PARAM_UNDEFINED,        LOTTERY_TICKET,         ITEM_RARITY_NORMAL,     false, 1 },
    { 19775, "Belediye Baskani Rozeti",          ITEM_TYPE_UNDEFINED,        PARAM_MISC,             MAYORAL_BADGE,          ITEM_RARITY_EPIC,       false, 1 },
    { 335, "Yuzme Bicagi",            ITEM_TYPE_EQUIP,            PARAM_HUNTING,           HUNTING_KNIFE,          ITEM_RARITY_COMMON,     true, 1 },
    { TRAP_FOOTLOCK, "Ayak Kapani",     ITEM_TYPE_USE,              PARAM_HUNTING,           HUNTING_TRAP,           ITEM_RARITY_NORMAL,     true, 1 },
    { 1923, "Termostat",               ITEM_TYPE_USE,              PARAM_MISC,             THERMOSTAT,             ITEM_RARITY_NORMAL,     true, 1 },
    { GLOVES_BROWN, "Eldiven",           ITEM_TYPE_USE,              PARAM_MISC,             GLOVES,                 ITEM_RARITY_NORMAL,     true, 1 },
    { LONGJOHNS_OBJ, "Termal Iclik",      ITEM_TYPE_USE,              PARAM_MISC,             LONG_JOHNS,             ITEM_RARITY_NORMAL,     true, 1 },


    { 19575, "Av Yemi",             ITEM_TYPE_USE,              PARAM_HUNTING,           HUNTING_BAIT,           ITEM_RARITY_NORMAL,     true, 1 },
    

    { 2936, "Islem Gormus Madde",      ITEM_TYPE_USE,              PARAM_GUNCREATION,      FRACTURED_SUBSTANCE,    ITEM_RARITY_EPIC,       false, 3 },
    { 854, "Ocak Komuru",              ITEM_TYPE_USE,              PARAM_GUNCREATION,      FURNACE_COAL,           ITEM_RARITY_NORMAL,     false, 3 },
    { 19941, "Kulce",                   ITEM_TYPE_USE,              PARAM_GUNCREATION,      INGOT,                  ITEM_RARITY_NORMAL,     false, 3 },
    { 2034, "Silah Parcasi",                  ITEM_TYPE_USE,              PARAM_GUNCREATION,      GUNPART,                ITEM_RARITY_NORMAL,     false, 3 },

    { 19592,  "Bos Sepet",               ITEM_TYPE_USE,              PARAM_FARMING,      EMPTY_BASKET,           ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_EMPTY, "Portakal Dolu Sepet",        ITEM_TYPE_SELL,             PARAM_FARMING,      ORANGE_BASKET,          ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_RAPPLE, "Kirmizi Elma Dolu Sepet",    ITEM_TYPE_SELL,             PARAM_FARMING,      RAPPLE_BASKET,          ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_GAPPLE, "Yesil Elma Dolu Sepet",  ITEM_TYPE_SELL,             PARAM_FARMING,      GAPPLE_BASKET,          ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_WHEAT, "Bugday Dolu Sepet",         ITEM_TYPE_SELL,             PARAM_FARMING,      WHEAT_BASKET,           ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_TOMATO, "Domates Dolu Sepet",       ITEM_TYPE_SELL,             PARAM_FARMING,      TOMATO_BASKET,          ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_CABBAGE, "Lahana Dolu Sepet",     ITEM_TYPE_SELL,             PARAM_FARMING,      CABBAGE_BASKET,         ITEM_RARITY_NORMAL,     true, 1 } ,
    { FARM_BASKET_PUMPKIN, "Bal Kabagi Dolu Sepet",     ITEM_TYPE_SELL,             PARAM_FARMING,      PUMPKIN_BASKET,         ITEM_RARITY_NORMAL,     true, 1 } ,

    { 19088, "Uzun Kement",              ITEM_TYPE_EQUIP,            PARAM_UNDEFINED,            SHERIFF_LONG_LASSO,         ITEM_RARITY_RARE,   true, 1 } ,
    { 19088, "Kement",                   ITEM_TYPE_EQUIP,            PARAM_UNDEFINED,            SHERIFF_LASSO,              ITEM_RARITY_RARE,   true, 1 } 
} ;

GetItemByParamID ( param ) {

	for ( new i; i < sizeof ( Item ); i ++ ) {

		if ( Item [ i ] [ item_extra_param ] == param ) {

			return i ;
		}
	}

	return true ;
}
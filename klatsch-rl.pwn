#include <a_samp>
#include <zcmd>
#include <streamer>
#include <a_mysql>
#include <sscanf2>
#include <banfix>
#include <md5>


//NEXT
//Gang anmelden

enum
{
    TELPORT_LIST,
    TELEPORT,
    DIALOG_GCREATE_OVERVIEW,
    DIALOG_GANG_FAQ,
    DIALOG_GANG_FAQ_,
    DIALOG_GANG_LIST,
    DIALOG_PLAYERGANG_OVERV,
    DIALOG_GANGREQUEST_INFO,
    DIALOG_GANGREQUEST_INSERT,
    DIALOG_REQGANG_MENU,
    DIALOG_REQGANG_MEMBERLIST,
    DIALOG_REQGANG_INVITE,
    DIALOG_REQGANG_UNINVITE,
    DIALOG_LOGIN,
    DIALOG_REGISTER,
    DIALOG_CLOSE,
}

#define HTML_WHITE     					"{FFFFFF}"
#define HTML_GREEN     					"{66CC00}"
#define HTML_LIGHTBLUE     				"{3399FF}"
#define HTML_LIGHTYELLOW     			"{CCFF00}"
#define HTML_PURPEL     				"{E599FF}"
#define HTML_DARKBLUE                   "{0000FF}"
#define HTML_DARKRED                    "{E10000}"
#define HTML_ORANGE                     "{FF5C00}"
#define HTML_DARKGREY                   "{8C8C8C}"
#define HTML_GREY                       "{BEBEBE}"
#define HTML_BLACK                      "{0F0000}"
#define HTML_RED                        "{FF0000}"
#define HTML_GOLDENYELLOW               "{FFFA00}"
#define HTML_PERFECTGREEN               "{458B00}"

#define MSG_BENUTZUNG					0
#define MSG_FEHLER                  	1
#define MSG_ERFOLGREICH             	2
#define MSG_INFO						3
#define MSG_HELP						4
#define MSG_WARNUNG						5

#define COLOR_WHITE 					0xFFFFFFAA
#define COLOR_BLACK 					0x000000FF
#define COLOR_RED 						0xAA3333AA
#define COLOR_LIGHTRED 					0xFF0000FF
#define COLOR_NICERED 					0xFF6347AA
#define COLOR_BLUE						0x2641FEAA
#define COLOR_HELLBLUE					0x0091FFFF
#define COLOR_LIGHTBLUE 				0x33CCFFAA
#define COLOR_YELLOW 					0xFFFF00FF
#define COLOR_GREEN 					0x9EC73DAA
#define COLOR_LIGHTGREEN 				0x00FF0AFF
#define COLOR_PINK 						0xFF66FFAA
#define COLOR_BROWN 					0x7A0000B4
#define COLOR_GRAU 						0xB4B5B7FF
#define COLOR_ORANGE 					0xFF9900AA
#define COLOR_VIOLET 					0x9955DEEE
#define COLOR_NEWS 						0xFFE600FF
#define COLOR_DEPARTMENT 				0xFF6362FF
#define COLOR_RADIO 					0x7380FFFF
#define COLOR_SUPPORT 					0x464DFFFF
#define COLOR_LIGHTRED2					0xFF6347AA
#define COLOR_DURCHSICHTIG 				0xFFFFFF00
#define COLOR_BLUEGREY      			0x007D93FF
#define COLOR_AFKSYSTEM     			0x6400FFFF
#define COLOR_BENUTZUNG       			0xFFB500FE
#define WEISS 							0xFFFFFFFF
#define ALPHASCHWARZ                    0x0000003E
#define HELLBLAU 						0x00FFFFFF
#define ORANGE 							0xFFA000FF
#define BLAU 							0x002DFFFF
#define SORBLAU                         0x0087FFFF
#define WRONGCMD 						0x969696FF
#define GELB 							0xFFFF00AA
#define GRAU 							0xB4B4B4FF
#define HELLROT 						0xFF0A00FF
#define GRUEN 							0x4BB400FF
#define DUNKELGRUEN 					0x239C00D9
#define WANTEDDEATHERROT                0xFF0000FF
#define HIGHROT                         0xe87474AA
#define LEUCHTENDESROT 					0xFF6347AA
#define MEFARBE 						0xC2A2DAAA
#define ADDMEFARBE                      0x00FF64A6
#define ROT 							0xBC0000C8
#define BRAUN 							0x870000FF
#define NEONGRUEN 						0x23FF00FF
#define PAINTBALL                       0x78FF6CEA
#define HELP 							0xAAAAAAB5
#define DUNKELBLAU 						0x00B9FF87
#define HAUSCOLOR 						0x00A5FF91
#define FOrPUBLICHOUSECOLOR             0x000576CA
#define BIZCOLOR 						0xF0F0F0B4
#define SMARKCOLOR                      0xF0F0F0B4
#define SMARKWEAPONCOLOR                0xAFD1FFFF
#define TANKENCOLOR                     0xD7FF00B0
#define BUSuTAXIDUTYFARBE               0xAFD1FFFF
#define SAPDDUTY                        0x00489184
#define FBIDUTY                         0x0000D4FF
#define MEDICDUTY                       0xFF6347AA
#define ARMYDUTY                        0x46952EE7
#define SANEWSAGDUTY                    0xF69500E2
#define OAMTDUTY                        0x00E0FFFF
#define FAHRSCHULEDUTY                  0xFFF000FF
#define SAELEKTRONIKGmBhDUTY            0x5B82C8D4
#define ZOLLGRUEN                       0x00F11EE2
#define PARKPLACEGRUEN                  0x00F11EE2
#define FMELDUNG		                0xFFF100BB
#define FCHATCOLOR                      0x00FFFFFF
#define DEPARTMENTSCOLOR                0xFF6259D4
#define FLCHATCOLOR                     0x00FFA0CD
#define LEADERCHATCOLOR                 0x6E00FFFF
#define PREMIUMCHATCOLOR                0xBDFF00E2
#define JOBCHATCOLOR                    0x91480CE5
#define EXECUTIVCHATCOLOR               0xB900E4A6
#define REPORTANDAFKCOLOR               0xAFD1FFFF
#define REPORTACCEPTCOLOR 				0xFFFF80FF
#define KOFFERCOLOR                     0x9BFF00C1
#define GWCHATCOLOR						0xC81400FF
#define ORGCHATCOLOR					0xAB5922B9
#define SEKTEFARBE                      0xFFFF80FF

forward MinutenTimer();
forward OnGangRequestInsert(playerid);
forward CheckGangRequest(playerid, _inputtext[]);
forward GangRequestMemberliste(playerid, _string[512], _count);
forward GangRequestUninvite(playerid);
forward GangRequestInvite(playerid, pID);
forward OnGangsLoad();
forward OnPlayerDataLoad(playerid);
forward OnGangVehicleLoad();
forward OnPlayerRegister(playerid);
forward StopPlayerPlaySound(playerid);

#define MINLEVEL_GANG_INVITE            3
#define PLAYER_LEVEL_GCREATE            5
#define GANG_CREATE_COST                10000
#define MAX_GANG_FAQ                    8
#define MAX_GANGS                       50
#define MAX_GRANKS                    	11
#define NEEDED_GMEMBERS_FOR_GANG        4
#define MAX_HOUSES     					300

new SQL = -1,

    stunde,minute,sekunde,tag,monat,jahr,

	Text:TimeTextdraw;

enum PlayerEnum
{
    ORM:ORM_ID,
	ID,
	pName[MAX_PLAYER_NAME+1],
	pPassword[128],
    pAdmin,
	pGangMember,
	pGangRank,
	pGangRequestLead,
	pGangRequestMember,
	pGangRequestMembers,
	pFraktion,
	pFrakRang,
	pFrakSkin,
	pLeader,
	pMoney,
	pLevel,
	pSkin,
	pAdminDuty,
	pAdminDutyTime,
	pHunger,
	pHungerCount,
	pThirst,
	pThirstCount,
	pFaction,
	pRank,
}
new PlayerInfo[MAX_PLAYERS][PlayerEnum];

enum hInfo
{
	hDatabaseID,
    Float:hEingangX,
	Float:hEingangY,
	Float:hEingangZ,
	Float:hEingangA,
	Float:hHealX,
	Float:hHealY,
	Float:hHealZ,
	hBesitzer[32],
	hStatus,
	hServerPreis,
	hVerkaufsPreis,
	hInterior,
	hGeschlossen,
	hMietPreis,
	hMaxMieter,
	hVermietung,
	hTresor,
	hTV,
	hGeld,
	hDrogen,
	hMaterials,
	hStadt[64],
	hStadtteil[64],
	hStrasse[64],
	hHausnummer[64],
	hLevel,
	hGroesse
}
new HausInfo[MAX_HOUSES][hInfo];
enum iInfo
{
	iDatabaseID,
	iName[64],
	Float:iAusgangX,
	Float:iAusgangY,
	Float:iAusgangZ,
	Float:iAusgangA,
	iInt,
	iGroesse,
	iPreis
}
new InteriorInfo[20][iInfo];
new HausPickup[MAX_HOUSES];
//new HausSchild[MAX_HOUSES];
new Text3D:HausLabel[MAX_HOUSES];
new HausToPlayer[MAX_PLAYERS][MAX_HOUSES];
new PlayerDialog[MAX_PLAYERS];
new HausVerwaltungHauser[MAX_PLAYERS][10];

enum hVerwaltung
{
	hSelected,
	hVerkauf,
	hClosed,
	hVermietung,
	hMietpreis,
	hVerkaufsArt
};
new HausVerwaltung[MAX_PLAYERS][hVerwaltung];
new InnenraumHaus[MAX_PLAYERS];
new InnenRaumHauser[MAX_PLAYERS][20];
//
//Gangtabelle: Gangid, Gangname, Erstellungsdatum, Gründer, Maxmember, Memberanzahl, ...
//Spielertabelle: Gangid, Gangrang, ...
//Gebiet: GebietID, Gebietname, Gebietowner, Gebietattacker(?), GebietX, GebietY, GebietZ, lastatt, ... ,bonusmoney, bonusskins, bonusitem, bonusdiscount,
//Variable für spieler im gebiet, die auch nach relog bleibt.
//
/*Innenraum:
Stufe 0 / 1 / 2 / 3
Kosten: 0/ 50k / 170k / 450k
Limit: 6/12/16/20/Member

Garage:
Stufe:0/1/2/3/
Kosten:0/80k/250k/600k
Limit:4/8/15/25 Fcars*/
enum gangfaqenum
{
	gfTitle[64],
	gfText[512],
	gfDatum[11],
	gfAutor[MAX_PLAYER_NAME+1],
}
new GangFAQ[MAX_GANG_FAQ][gangfaqenum] = {
//FAQ zu Gang-Befehle
{"Gang-Befehle", "coming soon","11.10.2016","Klatsch"},
//FAQ zu Gründungsvoraussetzungen
{"Gründungsvoraussetzungen", "- Gangleader Level 5\n-Gangmember Level 3\n-Gründung kostst 10.000$\n-4 Member","11.10.2016","Klatsch"},
//FAQ zu Aufstiegsmöglichkeiten
{"Aufstiegsmöglichkeiten", "\
Deine Gang kann sich mit der Zeit vergrößern, allerdings musst\n\
du vorher die Rahmenbedingungen dafür schaffen.\n\
Dazu gehört der Kauf einer Gangbase, das Upgraden der Gangbase\n\
und der Kauf von Gangfahrzeugen.\n\
Mit der Zeit könnt ihr mehr und mehr Features\n\
für eure Gang freischalten.","11.10.2016","Klatsch"},
//FAQ zu Gangbasen
{"Gangbasen", "\
In ganz San Andreas stehen größere Gelände zum Kauf.\n\
Dort könnt ihr euch mit eurer Gang niederlassen und einfach\n\
Gangster sein.","11.10.2016","Klatsch"},
//FAQ zu Gangbase-Upgrades
{"Liste aller Gangbase-Upgrades", "\
Interior Upgrade: erhöht das Memberlimit auf 12,16 und 20\n\
Garage: erhöht das Gcar-Limit auf 8, 15 und 25\n\
Versteck: Platz für Drogen und ungewaschenes Geld\n\
Waffenschrank: Bietet Platz für 1500 kg Waffen\n\
Kühlschrank: Bietet Platz für 250 kg Essen\n\
Medizinschrank: Bietet Platz für 25 kg Arzneimittel\n\
Mülleimer: Bietet Platz für 500 kg Müll und/oder Leichen","11.10.2016","Klatsch"},
//FAQ zu Gangwarteilnahme
{"Gangwarteilnahme", "\
Um am Gangwar teilzunehmen, muss eure Gang erst die\n\
zweite Stufe erreicht haben.","11.10.2016","Klatsch"},
//FAQ zu Gang-Kasse
{"Gang-Kasse", "\
Es gibt bei einer Gang keine klassische Fraktionskasse,\n\
sondern nur ein Versteck in der Gangbase. Das Geld kann\n\
dort allerdings vom LSPD gefunden und beschlagnahmt werden.\n\
Wenn ihr die Letzte Gang-Stufe erreicht habt, könnt ihr ein Biz\n\
kaufen und damit euer Geld waschen.","11.10.2016","Klatsch"},
//FAQ zu Inaktivität
{"Inaktivität", "\
Auf Dauer müssen wir Inaktive Gangs auch wieder löschen und\n\
ihre Gangbasen für andere frei machen. Nach 2 Wochen wird\n\
die Base freigemacht und die Gang wird 'eingefroren'.\n\
Dann könnt ihr sie wieder aktivieren und erhaltet\n\
90% des Geldes für die Base, Fcars und Upgrades zurück.\n\
Nach 3 Monaten wird die Gang endgültig gelöscht.","11.10.2016","Klatsch"}
};

enum gangenum
{
    ORM:ORM_ID,
    gUsed,
	gSQLID,
	gGangName[32],
	gGangTag[4],
	gGangType,
	gGangLevel,
	gGangExp,
	gGangGruender[MAX_PLAYER_NAME+1],
	gGangMember,
	gGangMaxMember,
	gGangMaxVeh,
	gGangColor,
	gGangVehColor1,
	gGangVehColor2,
}
new GangInfo[MAX_GANGS][gangenum],
	GangRanks[MAX_GANGS][MAX_GRANKS][32];
	
enum teleportenum
{
	tStandort[16],
	Float:tX,
	Float:tY,
	Float:tZ,
	Float:tA,
	tVirtualWorld,
	tInterior,
	tName[32],
}
new Teleports[][teleportenum] = {
{"Los Santos",1541.1511,-1675.3354,13.5520,271.3137,0,0,"LSPD"},
{"Los Santos",1358.4196,-1740.1715,13.5469,166.3665,0,0,"Stadthalle 24/7"},
{"Los Santos",377.0677,-2014.6102,7.8301,180.6039,0,0,"LS Pier"},
{"Los Santos",1959.7423,-1451.1929,13.5495,22.0612,0,0,"Skaterpark LS"},
{"Los Santos",1228.5280,-924.9550,42.8035,9.4610,0,0,"Burger Shot North"},
{"Los Santos",1364.9121,-1307.2686,13.5469,1.3370,0,0,"Ammunation LS"},
{"Los Santos",1776.4137,-1943.5392,13.5567,357.6141,0,0,"Bahnhof LS"},
{"Los Santos",1092.1820,-784.0573,107.2812,185.6381,0,0,"Ufohaus(Vinevood)"},
{"Los Santos",1646.2944,-1148.6709,24.0721,97.9422,0,0,"Bankparkplatz"},
{"Los Santos",2210.6470,-1138.3995,25.8079,189.6149,0,0,"Jefferson Motel"},
{"Los Santos",2649.2739,-1680.6938,10.8393,355.6371,0,0,"Los Santos Arena"},
{"Los Santos",1946.5450,-2173.9495,13.5542,2.2851,0,0,"Los Santos Airport"},

{"Las Venturas",2209.6699,1330.3632,10.8203,186.6423,0,0,"Sphinx"},
{"Las Venturas",2083.4365,1683.4391,10.8203,268.7428,0,0,"Caligulas Casino"},
{"Las Venturas",-1502.9639,2659.8589,55.8359,181.8032,0,0,"El Quebrados"},
{"Las Venturas",-42.9437,2318.7517,24.2281,341.8872,0,0,"Snake Farm"},
{"Las Venturas",1438.1932,2598.3174,11.1308,0.9266,0,0,"LV Bahnhof"},

{"San Fierro",-2014.9427,288.4872,34.0961,271.5577,0,0,"Wangs Autohaus"},
{"San Fierro",-1633.9695,1204.0476,7.1797,104.3208,0,0,"Ottos Autohaus"},
{"San Fierro",-2468.6118,714.1004,35.1719,359.9015,0,0,"24/7 San Fierro"},
{"San Fierro",-2645.1030,-203.0757,4.3359,179.3084,0,0,"Countryclub"},
{"San Fierro",-2519.2200,2427.9622,16.9346,223.7774,0,0,"Bayside"}
};



/*Haussystem*/
stock GetHausIngameIDbyDB(dbid)
{
	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if(HausInfo[i][hDatabaseID] == dbid)
	    {
			return i;
	    }
	}
	return -1;
}

stock GetInteriorIngameIDbyDB(dbid)
{
	for(new i=0; i<20; i++)
	{
	    if(InteriorInfo[i][iDatabaseID] != -1)
	    {
	    	if(InteriorInfo[i][iDatabaseID] == dbid)
	    	{
 	 			return i;
	    	}
		}
	}
	return -1;
}
/*Haussystem*/
main(){}

public OnGameModeInit()
{
    mysql_log(LOG_ERROR | LOG_WARNING, LOG_TYPE_HTML);
	SQL = mysql_connect("127.0.0.1", "root", "samp", "");
	if(mysql_errno())return SendRconCommand("exit");
	
	SetGameModeText("German Reallife");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	//------------------------------[Gangsystem]------------------------------//
	mysql_tquery(SQL, "SELECT * FROM `gangs`", "OnGangsLoad", "");
	mysql_tquery(SQL, "SELECT * FROM `gangvehicles`", "OnGangVehicleLoad","");
 	CreateDynamicPickup(1314,1,1631.2754,-1910.4308,13.5521);//GangErstellen-Punkt
 	CreateDynamic3DTextLabel(""#HTML_LIGHTBLUE"Gangmenü\n"#HTML_WHITE"/gmenu | ALT-Taste",WEISS,1631.2754,-1910.4308,13.5521+0.5,5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,0);//GangErstellen-Punkt
 	//-----------------------------------[]-----------------------------------//
 	SetTimer("MinutenTimer", 1000 * 60, 1);
 	//-----------------------------[Uhr-Textdraw]-----------------------------//
 	TimeTextdraw = TextDrawCreate(545.000000, 7.000000, "_");
	TextDrawBackgroundColor(TimeTextdraw, 255);
	TextDrawFont(TimeTextdraw, 3);
	TextDrawLetterSize(TimeTextdraw, 0.390000, 1.400000);
	TextDrawColor(TimeTextdraw, -1);
	TextDrawSetOutline(TimeTextdraw, 0);
	TextDrawSetProportional(TimeTextdraw, 1);
	TextDrawSetShadow(TimeTextdraw, 0);
	TextDrawSetSelectable(TimeTextdraw, 0);
	//-----------------------------------[]-----------------------------------//
	return 1;
}

public OnGameModeExit()
{
    //------------------------------[Gangsystem]------------------------------//
	SaveGangs();
	//-----------------------------------[]-----------------------------------//
	for(new i = 0; i < MAX_HOUSES; i++) SaveHaus(i);
	//-----------------------------[Uhr-Textdraw]-----------------------------//
	TextDrawHideForAll(TimeTextdraw);
	TextDrawDestroy(TimeTextdraw);
	//-----------------------------------[]-----------------------------------//
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new string[164];
    SetPlayerColor(playerid, WEISS);
    ResetVars(playerid);
    //--------------------------------[Account]-------------------------------//
	GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME+1);
    
    format(string,sizeof(string),"Herzlich Willkommen %s auf Klatsch-Reallife",PlayerInfo[playerid][pName]);
	SendClientMessage(playerid,HELLBLAU,string);
    
	new ORM:ormid = PlayerInfo[playerid][ORM_ID] = orm_create("accounts");
	orm_addvar_int(ormid, PlayerInfo[playerid][ID], "ID");
	orm_addvar_string(ormid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME+1, "Name");
	orm_addvar_string(ormid, PlayerInfo[playerid][pPassword], 128, "Password");
	orm_addvar_int(ormid, PlayerInfo[playerid][pAdmin], "Admin");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGangMember], "GangMember");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGangRank], "GangRank");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGangRequestLead], "GangRequestLead");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGangRequestMember], "GangRequestMember");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGangRequestMembers], "GangRequestMembers");
	orm_addvar_int(ormid, PlayerInfo[playerid][pFraktion], "Fraktion");
	orm_addvar_int(ormid, PlayerInfo[playerid][pFrakRang], "FrakRang");
	orm_addvar_int(ormid, PlayerInfo[playerid][pFrakSkin], "FrakSkin");
	orm_addvar_int(ormid, PlayerInfo[playerid][pLeader], "Leader");
	orm_addvar_int(ormid, PlayerInfo[playerid][pMoney], "Money");
	orm_addvar_int(ormid, PlayerInfo[playerid][pLevel], "Level");
	orm_addvar_int(ormid, PlayerInfo[playerid][pSkin], "Skin");
	orm_addvar_int(ormid, PlayerInfo[playerid][pAdminDuty], "AdminDuty");
	orm_addvar_int(ormid, PlayerInfo[playerid][pAdminDutyTime], "AdminDutyTime");
	orm_addvar_int(ormid, PlayerInfo[playerid][pHunger], "Hunger");
	orm_addvar_int(ormid, PlayerInfo[playerid][pHungerCount], "HungerCount");
	orm_addvar_int(ormid, PlayerInfo[playerid][pThirst], "Thirst");
	orm_addvar_int(ormid, PlayerInfo[playerid][pThirstCount], "ThirstCount");
	orm_addvar_int(ormid, PlayerInfo[playerid][pFaction], "Faction");
	orm_addvar_int(ormid, PlayerInfo[playerid][pRank], "Rank");

	orm_setkey(ormid, "Name");
	orm_select(ormid, "OnPlayerDataLoad", "d", playerid);
	//-----------------------------------[]-----------------------------------//
    //-----------------------------[Uhr-Textdraw]-----------------------------//
    gettime(stunde, minute);
    SetPlayerTime(playerid,stunde,minute);


    new hourstr[4], minutestr[4];
    if(stunde < 10)
        format(hourstr, sizeof(hourstr), "0%d", stunde);
	else
        format(hourstr, sizeof(hourstr), "%d", stunde);

    if(minute < 10)
        format(minutestr, sizeof(minutestr), "0%d", minute);
	else
        format(minutestr, sizeof(minutestr), "%d", minute);

    format(string, sizeof(string), "~w~%s~g~:~w~%s ~g~Uhr", hourstr, minutestr);
    TextDrawSetString(TimeTextdraw,string);
    //-----------------------------------[]-----------------------------------//
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    //------------------------------[Gangsystem]------------------------------//
	CheckGangReqInvitation(playerid);
	//-----------------------------------[]-----------------------------------//
	//--------------------------------[Account]-------------------------------//
	if(PlayerInfo[playerid][ID] != -1)orm_update(PlayerInfo[playerid][ORM_ID]);
	orm_destroy(PlayerInfo[playerid][ORM_ID]);
	for(new PlayerEnum:e; e < PlayerEnum; ++e)PlayerInfo[playerid][e] = 0;
	//-----------------------------------[]-----------------------------------//
	return 1;
}

public OnPlayerSpawn(playerid)
{
    //-----------------------------[Uhr-Textdraw]-----------------------------//
    gettime(stunde, minute);
    SetPlayerTime(playerid,stunde,minute);

	TextDrawShowForPlayer(playerid, TimeTextdraw);
	//-----------------------------------[]-----------------------------------//
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    //-----------------------------[Uhr-Textdraw]-----------------------------//
    TextDrawHideForPlayer(playerid, TimeTextdraw);
    //-----------------------------------[]-----------------------------------//
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	getdate(jahr,monat,tag);
	gettime(stunde,minute,sekunde);
   	new cmd[30], params[256];
	sscanf(cmdtext, "s[30]s[256]", cmd, params);

	new BEFEHLNOTALLOWED[100];
	format(BEFEHLNOTALLOWED, sizeof(BEFEHLNOTALLOWED), "• Du darfst diesen Befehl (%s) nicht benutzen!", cmd);

	new BEFEHLNOTFOUND[100];
	format(BEFEHLNOTFOUND, sizeof(BEFEHLNOTFOUND), "• Der Befehl (%s) existiert nicht!", cmd);

	new string[400], giveplayerid;
	
	if(!strcmp(cmd, "/haushilfe", true) || !strcmp(cmd, "/househelp", true) || !strcmp(cmd, "/haushelp", true))
	{
		if(PlayerInfo[playerid][pHausNummer] != 0 && strcmp(PlayerInfo[playerid][pName], HausInfo[PlayerInfo[playerid][pHausNummer]][hBesitzer], true) == 0)
	    {
	        format(string, sizeof(string), "{FFBF00}/hausverkaufen\t{FFFFFF}Haus verkaufen\n{FFBF00}/mieterlaubnis\t{FFFFFF}Haus vermietung verbieten/freigeben\n{FFBF00}/mietpreis\t\t{FFFFFF}Mietpreis festlegen\n{FFBF00}/mieter\t\t{FFFFFF}Mieter anzeigen, die online sind\n{FFBF00}/haustür\t{FFFFFF}Haustür auf-/abschließen");
		    ShowPlayerDialog(playerid, DIALOG_CLOSE, DIALOG_STYLE_MSGBOX, "{FFBF00}Voltage Reallife: {FFFFFF}Haushilfe", string, "Schließen", "");
		}
		else SendClientMessage(playerid, COLOR_GRAU, "• Du besitzt kein eigenes Haus!");
	    return 1;
	}
	
	if(!strcmp(cmd, "/saveall", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid, COLOR_GRAU, "• Du darfst diesen Befehl nicht benutzen!");
	    for(new i = 0; i < MAX_HOUSES; i++) SaveHaus(i);
	    SendClientMessage(playerid, MSG_ERFOLGREICH,"• Alle Serverdaten wurden erfolgreich gespeichert.");
	    return 1;
	}
	
	if(!strcmp(cmd, "/edithaus", true))
	{
		if(PlayerInfo[playerid][pAdmin] < 6) return SendStrukturMessage(playerid, MSG_FEHLER, "Du darfst diesen Befehl nicht benutzen!");
	    new name[64], level[64], bool:failed, level1;
		if(sscanf(params, "s[64]s[64]", name, level))
		{
			SendStrukturMessage(playerid, MSG_BENUTZUNG, "{FFFFFF}/edit [Name] [Menge]");
			SendClientMessage(playerid, COLOR_WHITE, "Verfügbare Namen: Serverpreis, Verkaufspreis, Stadt, Stadtteil");
			SendClientMessage(playerid, COLOR_WHITE, "Strasse, Hausnummer, MaxMieter, Level");
			SendClientMessage(playerid, COLOR_WHITE, "Status (1: staatlicher Verkauf, 2: privater Verkauf, 3: Eigentum, 4: Gesperrt)");
			return 1;
		}
		for(new i = 0; i < MAX_HOUSES; i++)
		{
		    if(HausInfo[i][hDatabaseID] != 0)
		    {
				if(IsPlayerInRangeOfPoint(playerid, 4, HausInfo[i][hEingangX], HausInfo[i][hEingangY], HausInfo[i][hEingangZ]))
				{
			    	failed = false;
                	if(strcmp(name, "MaxMieter", true) == 0)
					{
						level1 = strval(level);
					    HausInfo[i][hMaxMieter] = level1;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | maximale Mieter zu %d geändert!", i, level1);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Level", true) == 0)
					{
						level1 = strval(level);
					    HausInfo[i][hLevel] = level1;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | Level zu %d geändert!", i, level1);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Serverpreis", true) == 0)
					{
						level1 = strval(level);
					    HausInfo[i][hServerPreis] = level1;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | Serverpreis zu %d€ geändert!", i, level1);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Verkaufspreis", true) == 0)
					{
					    level1 = strval(level);
                	    HausInfo[i][hVerkaufsPreis] = level1;
                	    format(string, sizeof(string), "Haus editiert[ID: %d] | Verkaufspreis zu %d€ geändert!", i, level1);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Stadt", true) == 0)
					{
					    HausInfo[i][hStadt] = level;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | Stadt zu %s geändert!", i, level);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Stadtteil", true) == 0)
					{
					    HausInfo[i][hStadtteil] = level;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | Stadtteil zu %s geändert!", i, level);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Strasse", true) == 0)
					{
					    HausInfo[i][hStrasse] = level;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | Strasse zu %s geändert!", i, level);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Hausnummer", true) == 0)
					{
					    HausInfo[i][hHausnummer] = level;
					    format(string, sizeof(string), "Haus editiert[ID: %d] | Hausnummer zu %s geändert!", i, level);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					}
					else if(strcmp(name, "Status", true) == 0)
					{
					    level1=strval(level);
						if(level1<1||level1>4)return SendClientMessage(playerid, COLOR_WHITE, "Der Status darf nicht unter 1 oder über 4 sein.");
						HausInfo[i][hStatus] = level1;
						new status[64];
						switch(level1)
						{
							case 1:
							{
							    status="Verkauf durch Staat";
							}
							case 2:
							{
							    status="Verkauf durch Privatmann";
							}
							case 3:
							{
								status="In Besitz";
							}
							case 4:
							{
							    status="Gesperrt";
							}
						}
						format(string, sizeof(string), "Haus editiert[ID: %d] | Status zu %s geändert!", i, status);
					}
					SaveHaus(i);
					break;
				}
				else failed = true;
			}
		}
		if(failed) return SendClientMessage(playerid, COLOR_GRAU, "Du bist nicht in der nähe eines Hauses!");
		return 1;
	}

	if(!strcmp(cmd, "/createhaus", true))
	{
		if(PlayerInfo[playerid][pAdmin] < 6) return SendClientMessage(playerid,  COLOR_LIGHTRED, "[FEHLER] {FFFFFF}Du darfst diesen Befehl nicht benutzen!");
		mysql_query(sqlHandle, "SELECT * FROM `hausinfo`");
		mysql_store_result();
		new num=mysql_num_rows();
		mysql_free_result();
		if(num>=MAX_HOUSES)return SendClientMessage(playerid, COLOR_WHITE, "Es können keine weitere Häuser erstellt werden!");
		new preis, stadt[64], stadtteil[64], strasse[64], hausnummer[64], level, kapa;
		if(sscanf(params, "ddds[64]s[64]s[64]s[64]", preis, level, kapa, stadt, stadtteil, strasse, hausnummer))
		{
			SendStrukturMessage(playerid, MSG_BENUTZUNG, "{FFFFFF}/createhaus [Preis] [MindestLevel] [Größe(1-3)] [Stadt(LS/SF/LV)] [Stadtteil] [Strasse] [Hausnummer]");
			return 1;
		}
		if(preis < 20000 || preis > 5000000)return SendClientMessage(playerid, COLOR_WHITE, "Fehler: Preis (20.000€ - 5.000.000€)");
		if(level < 5 || level > 60)return SendClientMessage(playerid, COLOR_WHITE, "Fehler: Level (5 - 60)");
		if(kapa < 1 || kapa > 3)return SendClientMessage(playerid, COLOR_WHITE, "Fehler: Größe (1 - 3)");
		if(strcmp(stadt, "LS", true)&&strcmp(stadt, "SF", true)&&strcmp(stadt, "LV", true))return SendClientMessage(playerid, COLOR_WHITE, "Fehler: Stadt (LS/SF/LV)");
		if(strlen(stadtteil)<3)return SendClientMessage(playerid, COLOR_WHITE, "Fehler: Stadtteil (mindestens 3 Zeichen)");
		if(strlen(strasse)<8)return SendClientMessage(playerid, COLOR_WHITE, "Fehler: Straße (mindestens 8 Zeichen)");
		new hid = CreateNewHaus(playerid, preis, level, kapa, stadt, stadtteil, strasse, hausnummer);
		if(hid == -1) return SendClientMessage(playerid, COLOR_NICERED, "• Haus konnte nicht erstellt werden!");
		format(string, sizeof(string), "Haus wurde erstellt! | ID: %d | Anschrift: ", hid);
		SendClientMessage(playerid, COLOR_LIGHTBLUE,string);
		format(string, sizeof(string), "%s %s, %s-%s, San Andreas", strasse, hausnummer, stadt, stadtteil);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		return 1;
	}

	if(!strcmp(cmd, "/deletehaus", true))
	{
	    if(PlayerInfo[playerid][pAdmin] < 6)return SendStrukturMessage(playerid, MSG_FEHLER, "Du darfst diesen Befehl nicht benutzen!");
	    new hausid, query[512];
		if(sscanf(params, "d", hausid))
		{
		    SendClientMessage(playerid, COLOR_WHITE, "Benutze: /deletehaus [HausID]");
		    return 1;
		}
		if(HausInfo[hausid][hDatabaseID]!=0)
		{
			format(query, sizeof(query), "DELETE FROM `hausinfo` WHERE `ID`='%i'",HausInfo[hausid][hDatabaseID]);
			mysql_query(sqlHandle, query);
			format(query, sizeof(query), "DELETE FROM `haustoplayer` WHERE `hausid`='%i'", HausInfo[hausid][hDatabaseID]);
			mysql_query(sqlHandle, query);
			for(new i=0; i<MAX_PLAYERS; i++)
			{
			    if(HausToPlayer[i][hausid]==1)
			    {
			        SendClientMessage(playerid, COLOR_WHITE, "Ein Haus, in dem du eingemietet warst, wurde gelöscht!");
			    }
			    else if(HausToPlayer[i][hausid]==2)
			    {
			        SendClientMessage(playerid, COLOR_WHITE, "Eines deiner Häuser wurde gelöscht!");
			    }
			    HausToPlayer[i][hausid]=0;
			}
			for(new i=0; i<MAX_PLAYERS; i++)
			{
  				if(HausToPlayer[i][hausid]==1)
			    {
  					SendClientMessage(i, COLOR_WHITE, "Ein von dir gemietetes Haus wurde vom Server gelöscht.");
					if(PlayerInfo[i][pSpawnChange] == 1)
					{
						if(PlayerInfo[i][pSpawnHaus] == hausid)
			       		{
			           		PlayerInfo[i][pSpawnHaus]=0;
			           		PlayerInfo[i][pSpawnChange]=0;
			           		SendClientMessage(i, COLOR_WHITE, "Der Zivilistenspawn wurde als dein neuer Spawnort festgelegt. Bitte ändere den Spawnort mit /spawnchange");
			           		SavePlayer(i);
						}
			       	}
				}
				if(HausEntered[i] == hausid)
				{
				    SendClientMessage(i, COLOR_WHITE, "Das Haus, in dem du dich befindest, wurde gelöscht! Du wurdest zum Zivilistenspawn teleportiert!");
					SafeSetPlayerInterior(playerid, 0);
					SafeSetPlayerVirtualWorld(playerid, 0);
					SetPlayerFPos(playerid, 911.7143,-2389.3828,13.2547,29.1168);
					HausEntered[playerid]=9999;
				}
			}
			format(query, sizeof(query), "UPDATE `accounts` SET `SpawnChange`='0', `SpawnHaus`='0' WHERE `SpawnChange`='1' AND `SpawnHaus`='%d'",HausInfo[hausid][hDatabaseID]);
			mysql_query(sqlHandle, query);
			HausInfo[hausid][hDatabaseID]=0;
			DestroyDynamicPickup(HausPickup[hausid]);
			DestroyDynamic3DTextLabel(HausLabel[hausid]);
			format(string, sizeof(string), "Das Haus mit der ID %d wurde gelöscht.", hausid);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
		else
		{
			return SendClientMessage(playerid, COLOR_WHITE, "Das Haus mit der eingegebenen ID existiert nicht!");
		}
		return 1;
	}

	if(!strcmp(cmd, "/gethausid", true))
	{
		if(PlayerInfo[playerid][pAdmin] < 6) return SendClientMessage(playerid,  COLOR_LIGHTRED, "[FEHLER] {FFFFFF}Du darfst diesen Befehl nicht benutzen!");
		for(new i = 1; i < MAX_HOUSES; i++)
		{
		    if(HausInfo[i][hDatabaseID] != 0)
		    {
				if(IsPlayerInRangeOfPoint(playerid, 4, HausInfo[i][hEingangX], HausInfo[i][hEingangY], HausInfo[i][hEingangZ]))
				{
			    	format(string, sizeof(string), "Haus-ID: %d", i);
					SendClientMessage(playerid, COLOR_WHITE, string);
					return 1;
				}
			}
		}
		return SendClientMessage(playerid, COLOR_WHITE, "Du bist nicht in Reichweite eines Hauseingangs.");
	}

	if(!strcmp(cmd, "/hauskaufen", true))
	{
		for(new i=1; i<MAX_HOUSES; i++)
		{
		    if(HausInfo[i][hDatabaseID] != 0)
		    {
				if(IsPlayerInRangeOfPoint(playerid, 2, HausInfo[i][hEingangX], HausInfo[i][hEingangY], HausInfo[i][hEingangZ]))
				{
				    if(HausInfo[i][hStatus]!=1 && HausInfo[i][hStatus]!=2)return SendClientMessage(playerid, COLOR_WHITE, "Dieses Haus steht nicht zum Verkauf!");
					if(PlayerInfo[playerid][pLevel]<HausInfo[i][hLevel])return SendClientMessage(playerid, COLOR_WHITE, "Du musst vorher das benötigte Level erreichen!");
					if((PlayerInfo[playerid][pGeld]<HausInfo[i][hServerPreis]&&HausInfo[i][hStatus]==1)||(PlayerInfo[playerid][pGeld]<HausInfo[i][hVerkaufsPreis]&&HausInfo[i][hStatus]==2))
					{ return SendClientMessage(playerid, COLOR_WHITE, "Du hast nicht genug Geld dabei, um das Haus zu kaufen."); }
					new query[1024];
					format(query, sizeof(query), "SELECT * FROM `haustoplayer` WHERE `spielerid`='%i' AND `status`='2'",PlayerInfo[playerid][pSaveID]);
					mysql_query(sqlHandle, query);
					mysql_store_result();
					if(mysql_num_rows() < 3)
					{
					    mysql_free_result();
						if(HausInfo[i][hStatus]==1) SafeGivePlayerMoney(playerid, -HausInfo[i][hServerPreis]);
						else if(HausInfo[i][hStatus]==2)
						{
						    SafeGivePlayerMoney(playerid, -HausInfo[i][hVerkaufsPreis]);
							format(query, sizeof(query), "SELECT * FROM `haustoplayer` WHERE `hausid`='%i' AND `status`='2'",i);
							mysql_query(sqlHandle, query);
							mysql_store_result();
							new plid;
							new data[256];
							if(mysql_num_rows()) { while(mysql_retrieve_row()) { mysql_get_field("spielerid", data), plid=strval(data); } }
							mysql_free_result();
							new playerid1=GetPlayerIngameIDbyDB(plid);
							if(playerid1==playerid)return SendClientMessage(playerid, COLOR_WHITE, "Das Haus gehört bereits dir! Abbruch über die /hausverwaltung.");
		    				if(!IsPlayerConnected(playerid1)&&playerid1!=-1)
						    {
								format(query, sizeof(query), "SELECT * FROM `accounts` WHERE userID='%i'",plid);
	  	  						mysql_query(sqlHandle, query);
						  	  	mysql_store_result();
						    	new vkgeld;
						    	while(mysql_retrieve_row())
						    	{
						        	mysql_get_field("Geld", data), vkgeld=strval(data);
						    	}
								mysql_free_result();
								vkgeld+=HausInfo[i][hVerkaufsPreis];
								format(query, sizeof(query), "UPDATE `accounts` SET `Geld`='%i' WHERE `userID`='%i'", vkgeld, plid);
								mysql_function_query(sqlHandle, query, false, "", "");
							}
							else
							{
							    SafeGivePlayerMoney(playerid1, HausInfo[i][hVerkaufsPreis]);
							    format(string, sizeof(string), "Dein Haus in %s-%s, %s %s wurde für %d€ verkauft!", HausInfo[i][hStadt], HausInfo[i][hStadtteil], HausInfo[i][hStrasse], HausInfo[i][hHausnummer], HausInfo[i][hVerkaufsPreis]);
							    SendClientMessage(playerid1, COLOR_LIGHTBLUE, string);
							}
						}
						HausToPlayer[playerid][i]=2;
						HausInfo[i][hStatus]=3;
						new pname[32];
						GetPlayerName(playerid, pname, 32);
						HausInfo[i][hBesitzer]=pname;
						SaveHaus(i);
						SavePlayer(playerid);
						SendClientMessage(playerid, COLOR_WHITE, "Du hast das Haus erfolgreich gekauft!");
						return 1;
					}
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "Du befindest dich nicht in der Nähe eines Hauses.");
		return 1;
	}

	if(!strcmp(cmd, "/hausmieten", true))
	{
		for(new i=0; i<MAX_HOUSES;i++)
		{
		    if(HausInfo[i][hDatabaseID] != 0)
		    {
		    	if(IsPlayerInRangeOfPoint(playerid, 4, HausInfo[i][hEingangX], HausInfo[i][hEingangY], HausInfo[i][hEingangZ]))
		    	{
		    	    if(HausInfo[i][hVermietung] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Dieses Haus ist nicht zu Vermieten!");
					if(HausToPlayer[playerid][i] > 0) return SendClientMessage(playerid, COLOR_WHITE, "Du wohnst hier bereits!");
					new counter = 0;
					for(new idx=0; idx<sizeof(HausInfo); idx++)
					{
						if(HausToPlayer[playerid][idx]==1)counter++;
					}
					if(counter>1) return SendClientMessage(playerid, COLOR_WHITE, "Du kannst nicht mehr als 2 Wohnungen oder Häuser mieten.");
					counter=0;
					for(new idy=0; idy<MAX_PLAYERS; idy++)
					{
						if(HausToPlayer[idy][i]==1)counter++;
					}
					if(counter>=HausInfo[i][hMaxMieter])return SendClientMessage(playerid, COLOR_WHITE, "In diesem Haus ist keine Wohnung mehr für dich frei.");
					HausToPlayer[playerid][i]=1;
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "Du wohnst jetzt in diesem Haus.");
					return 1;
		    	}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "Du befindest dich nicht in der Nähe eines Hauses.");
		return 1;
	}
	
	if(!strcmp("/hausverwaltung", cmd, true)||!strcmp("/hverwaltung", cmd, true))
	{
		new counter=0;
		for(new i=0; i<MAX_HOUSES; i++)
		{
		    if(HausInfo[i][hDatabaseID] != 0)
		    {
		    	if(HausToPlayer[playerid][i]==2) counter++;
			}
		}
		if(counter)
		{
			ShowPlayerDialog(playerid, DIALOG_HAUSVERWALTUNG1, DIALOG_STYLE_MSGBOX, "{FFBF00}Hausverwaltung: {FFFFFF}Startseite", "Willkommen in der Immobilienverwaltung!\nMithilfe dieses Systems kannst du alle Immobilien problemlos verwalten und weiterverkaufen.\nDrücke Weiter und Wähle zunächst die Immobilie aus, die du verwalten möchtest.", "Weiter", "Abbrechen");
			PlayerDialog[playerid]=DIALOG_HAUSVERWALTUNG1;
		}
		else return SendClientMessage(playerid, COLOR_WHITE, "Du besitzt keine Immobilie!");
		return 1;
	}
	
	return SendStrukturMessage(playerid, MSG_FEHLER, BEFEHLNOTFOUND);
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_WALK)
	{
	    //----------------------------[Gangsystem]----------------------------//
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1631.2754,-1910.4308,13.5521))return cmd_gmenu(playerid, "");
		//---------------------------------[]---------------------------------//
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[512],pID = INVALID_PLAYER_ID;
	switch(dialogid)
	{
	    case TELPORT_LIST:
	    {
		    if(response==1)
		    {
				new telestring[1024];
				for(new i=0; i<sizeof(Teleports); i++)
				{
				    if(!strcmp(Teleports[i][tStandort],inputtext,true))
				    {
				        format(telestring,sizeof(telestring),"%s\n%s",telestring,Teleports[i][tName]);
				    }
				}
				ShowPlayerDialog(playerid,TELEPORT,DIALOG_STYLE_LIST,"Teleportmenü",telestring,"Wählen","Zurück");
				return 1;
		    }
		}
		case TELEPORT:
		{
			if(response==1)
		    {
		        for(new i=0; i<sizeof(Teleports); i++)
		        {
		            if(!strcmp(Teleports[i][tName],inputtext,true))
		            {
						format(string,sizeof(string),"{FFFFFF}Du hast dich zum {FFEE00}%s {FFFFFF}teleportiert.",inputtext);
						SendClientMessage(playerid,WEISS,string);
						SetPlayerPos(playerid,Teleports[i][tX],Teleports[i][tY],Teleports[i][tZ]);
						SetPlayerFacingAngle(playerid,Teleports[i][tA]);
						SetPlayerVirtualWorld(playerid,Teleports[i][tVirtualWorld]);
						SetPlayerInterior(playerid,Teleports[i][tInterior]);
						return 1;
					}
		        }
		    }
		    if(response==0)
		    {
		        format(string,sizeof(string),"");
				for(new i=0; i<sizeof(Teleports); i++)
				{
				    if(strfind(string,Teleports[i][tStandort],true)==-1)
				    {
				    	format(string,sizeof(string),"%s\n%s",string,Teleports[i][tStandort]);
					}
				}
				ShowPlayerDialog(playerid,TELPORT_LIST,DIALOG_STYLE_LIST,"Teleportmenü",string,"Wählen","Schließen");
		    }
		}
		//-------------------------------[Gangsystem]---------------------------------//
		case DIALOG_GCREATE_OVERVIEW:
		{
		    if(response==1)
		    {
			    switch(listitem)
			    {
			        case 0:
			        {
			            new count=0;
			            format(string,sizeof(string),"");
			            for(new i = 0; i < MAX_GANGS; i++)
						{
						    if(GangInfo[i][gUsed] == 1)
						    {
						        format(string,sizeof(string),"%s\nID: %i | %s (%i/%i Mitglieder)",
								string,GangInfo[i][gSQLID],GangInfo[i][gGangName],
                                GangInfo[i][gGangMember],GangInfo[i][gGangMaxMember]);
						        count++;
							}
						}
						if(count == 0)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Derzeit existieren keine Gangs!");
                        return ShowPlayerDialog(playerid,DIALOG_GANG_LIST,DIALOG_STYLE_MSGBOX,"Gang - Übersicht",string,"Wählen","Schließen");
					}
			        case 1:
					{
                        if(PlayerInfo[playerid][pGangMember] != 0)
						{
						    for(new i=0;i<MAX_GANGS;i++)
						    {
						        if(GangInfo[i][gUsed] == 1)
						        {
						        	if(PlayerInfo[playerid][pGangMember] == GangInfo[i][gSQLID])
						        	{
						        	    format(string,sizeof(string),"|			%s(ID: %i)			|\nTag: %s\n Gang-Typ: %s (Level: %i - %i Exp\ngegründet von: %s\nMitglieder: %i / %i",
										GangInfo[i][gSQLID],GangInfo[i][gGangName],GangInfo[i][gGangTag],
										GetGangTypeName(GangInfo[i][gGangType]),GangInfo[i][gGangLevel],GangInfo[i][gGangExp],
										GangInfo[i][gGangGruender],GangInfo[i][gGangMember],GangInfo[i][gGangMaxMember]);
						        	    return ShowPlayerDialog(playerid,DIALOG_PLAYERGANG_OVERV,DIALOG_STYLE_MSGBOX,GangInfo[i][gGangName],string,"Schließen","");
						        	}
								}
							}
	                        return SendClientMessage(playerid, -1, ""#HTML_RED"DEBUG: "#HTML_WHITE"Es liegt ein Fehler in der Datenbank vor. Melde diesen Bug umgehend im Forum!");
						}
						else
						{

						    return ShowPlayerDialog(playerid,DIALOG_GANGREQUEST_INFO,DIALOG_STYLE_MSGBOX,"Gang erstellen","Willkommen im Gangmenü!\n\
							 Hier kannst du mit deinen Freunden deine eigene Gang gründen.\n\
							 Bevor deine Gang aktiviert wird, muss sie 4 Mitglieder haben.\n\
						 	 Mehr Informationen und die benötigten Befehle findest du in den FAQ.\n","Erstellen","Schließen");
						}
					}
			        case 2:
			        {
			            format(string,sizeof(string),"");
			            for(new i=0; i<MAX_GANG_FAQ; i++)
						{
						    format(string,sizeof(string),"%s\n%s",string,GangFAQ[i][gfTitle]);
						}
						return ShowPlayerDialog(playerid,DIALOG_GANG_FAQ,DIALOG_STYLE_LIST,"Gang - FAQ",string,"Wählen","Schließen");
					}
				}
			}
		}
		case DIALOG_GANGREQUEST_INFO:
		{
		    if(!response)return 1;
		    if(PlayerInfo[playerid][pGangRequestMember] != -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist bereits dabei eine Gang zu gründen. Nutze /grequest.");
		    if(PlayerInfo[playerid][pLevel] < PLAYER_LEVEL_GCREATE)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du kannst eine eigene Gang erst mit Level "#PLAYER_LEVEL_GCREATE" gründen.");
		    if(GetACMoney(playerid) < GANG_CREATE_COST)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du besitzt nicht genügend Geld, um deine eigene Gang zu gründen ("#GANG_CREATE_COST"$).");
			return ShowPlayerDialog(playerid,DIALOG_GANGREQUEST_INSERT, DIALOG_STYLE_INPUT, "Gang erstellen", "Bitte gib den gewünschten Gangnamen ein.\nHiermit sicherst du dir deinen individuellen Wunschnamen.\nBeachte das du für die Erstellung einer Gang, dennoch\nweitere 3 Mitglieder haben muss.", "Absenden", "Abbrechen");
		}
		case DIALOG_GANGREQUEST_INSERT:
		{
		    if(!response)return 1;
		    if(strlen(inputtext) < 5 || strlen(inputtext) > 32)
		    {
		        return ShowPlayerDialog(playerid,DIALOG_GANGREQUEST_INSERT, DIALOG_STYLE_INPUT, "Gang erstellen", "Bitte gib den gewünschten Gangnamen ein.\nHiermit sicherst du dir deinen individuellen Wunschnamen.\nBeachte das du für die Erstellung einer Gang, dennoch\nweitere 3 Mitglieder haben muss.\n\n"#HTML_RED"Dein Gangname muss mindestens aus 5 Zeichen bestehen und darf maximal 32 Zeichen besitzen.", "Absenden", "Abbrechen");
			}
			format(string, sizeof(string),"SELECT `GangName` FROM `gangrquest` WHERE `GangName` = '%s'",inputtext);
			mysql_tquery(SQL, string, "CheckGangRequest", "ds", playerid, inputtext);
		    return 1;
		}
		case DIALOG_GANG_FAQ:
		{
		    if(!response)return 1;
			format(string, sizeof(string),"%s\n\nvon: %s, geschrieben am %s",GangFAQ[listitem][gfText],GangFAQ[listitem][gfAutor],GangFAQ[listitem][gfDatum]);
		    return ShowPlayerDialog(playerid,DIALOG_GANG_FAQ_,DIALOG_STYLE_MSGBOX,GangFAQ[listitem][gfTitle],string,"Verstanden","");
		}
		case DIALOG_REQGANG_MENU:
		{
		    if(!response)return 1;
		    switch(listitem)
		    {
		        case 0:
		        {
					new count=0,query[256];
		            if(PlayerInfo[playerid][pGangRequestMember] == 0)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist in keiner vorläufigen Gang.");
                    format(string, sizeof(string),"");
					for(new i = 0,j = GetPlayerPoolSize();i <= j;i++)
					{
					    if(PlayerInfo[playerid][pGangRequestMember] != PlayerInfo[i][pGangRequestMember])continue;
					    format(string,sizeof(string),"%s\n%s",string,GetName(i));
					}
					if(count == NEEDED_GMEMBERS_FOR_GANG)return ShowPlayerDialog(playerid,DIALOG_REQGANG_MEMBERLIST,DIALOG_STYLE_LIST,"Gangrequest - Mitgliederliste",string,"Wählen","Schließen");
                    format(query, sizeof(query),"SELECT `Name` FROM `accounts` WHERE `GangRequestMember` = %i AND `Online` = 0",PlayerInfo[playerid][pGangRequestMember]);
					mysql_tquery(SQL, query, "GangRequestMemberliste", "dsd", playerid, string, count);
					return 1;
				}
		        case 1:
		        {
		            if(PlayerInfo[playerid][pGangRequestMember] == -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist in keiner vorläufigen Gang.");
		            if(PlayerInfo[playerid][pGangRequestLead] == 0)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist kein Anführer einer vorläufigen Gang.");
					if(PlayerInfo[playerid][pGangRequestMembers] == NEEDED_GMEMBERS_FOR_GANG)return SendClientMessage(playerid, -1, ""#HTML_LIGHTBLUE"INFORMATION: "#HTML_WHITE"Du besitzt bereits "#NEEDED_GMEMBERS_FOR_GANG" Mitglieder. Du kannst deine Gang nun anmelden.");
                    return ShowPlayerDialog(playerid,DIALOG_REQGANG_INVITE, DIALOG_STYLE_INPUT, "Gangrequest - Spieler einladen", "Gib nun die SpielerID ein, die du einladen möchtest:", "Absenden", "Abbrechen");
				}
				case 2:
				{
				    if(PlayerInfo[playerid][pGangRequestMember] == -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist in keiner vorläufigen Gang.");
		            if(PlayerInfo[playerid][pGangRequestLead] == 0)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist kein Anführer einer vorläufigen Gang.");
                    return ShowPlayerDialog(playerid,DIALOG_REQGANG_UNINVITE, DIALOG_STYLE_INPUT, "Gangrequest - Spieler entfernen", "Gib nun den SpielerNamen ein, den du entfernen möchtest:", "Absenden", "Abbrechen");
				}
		        case 3:
		        {
		            if(PlayerInfo[playerid][pGangRequestMember] == -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist in keiner vorläufigen Gang.");
		            if(PlayerInfo[playerid][pGangRequestLead] == 0)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist kein Anführer einer vorläufigen Gang.");//Gang anmelden
                    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1631.2754,-1910.4308,13.5521))return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du befindest dich nicht am Gangmenü-Punkt in Los Santos.");
				}
			}
		}
		case DIALOG_REQGANG_UNINVITE:
		{
		    if(strlen(inputtext) > MAX_PLAYER_NAME+1)return ShowPlayerDialog(playerid,DIALOG_REQGANG_UNINVITE, DIALOG_STYLE_INPUT, "Gangrequest - Spieler entfernen", "Gib nun den SpielerNamen ein, den du entfernen möchtest:\n\n"#HTML_RED"Die angegebene Zeichenzahl entspricht keinem Spielername.", "Absenden", "Abbrechen");
			pID = GetPlayerID(inputtext);
			if(pID == -1)
			{
			    format(string, sizeof(string),"SELECT `Name`,`ID` FROM `accounts` WHERE `GangRequestMember` = %i AND `Name` = '%s' LIMIT 1",PlayerInfo[playerid][pGangRequestMember],inputtext);
			    mysql_tquery(SQL, string, "GangRequestUninvite", "d", playerid);
			    return 1;
			}
			format(string, sizeof(string),"GangRequest-Rauswerfen: %s hat dich aus seiner Gang entfernt.",GetName(playerid));
			SendClientMessage(pID, SEKTEFARBE, string);
			format(string, sizeof(string),"GangRequest-Rauswerfen: Du hast %s erfolgreich aus der Gang entfernt.",GetName(pID));
			SendClientMessage(playerid, SEKTEFARBE, string);
			PlayerInfo[pID][pGangRequestMember] = -1;
			PlayerInfo[playerid][pGangRequestMembers] ++;
			return 1;
		}
		case DIALOG_REQGANG_INVITE:
		{
		    if(!response)return 1;
		    if(!IsNumeric(inputtext))
		    {
		        return ShowPlayerDialog(playerid,DIALOG_REQGANG_INVITE, DIALOG_STYLE_INPUT, "Gangrequest - Spieler einladen", "Gib nun die SpielerID ein, die du einladen möchtest:\n\n"#HTML_RED"Eine SpielerID besteht aus einer Zahl.", "Absenden", "Abbrechen");
			}
			if(!IsPlayerConnected(strval(inputtext)))
			{
			    return ShowPlayerDialog(playerid,DIALOG_REQGANG_INVITE, DIALOG_STYLE_INPUT, "Gangrequest - Spieler einladen", "Gib nun die SpielerID ein, die du einladen möchtest:\n\n"#HTML_RED"Der angegebene Spieler ist nicht mit dem Server verbunden.", "Absenden", "Abbrechen");
			}
			if(IsPlayerNPC(strval(inputtext)))
			{
			    return ShowPlayerDialog(playerid,DIALOG_REQGANG_INVITE, DIALOG_STYLE_INPUT, "Gangrequest - Spieler einladen", "Gib nun die SpielerID ein, die du einladen möchtest:\n\n"#HTML_RED"Der angegebene Spieler ist ein NPC.", "Absenden", "Abbrechen");
			}
			format(string, sizeof(string),"SELECT `GangName` FROM `gangrquest` WHERE `ID` = %i LIMIT 1",PlayerInfo[playerid][pGangRequestMember]);
			mysql_tquery(SQL,string,"GangRequestInvite", "dd", playerid, strval(inputtext));
			return 1;
		}
		//-------------------------------------[]-------------------------------------//
		//---------------------------------[Account]----------------------------------//
		case DIALOG_LOGIN:
		{
		    if(!response)
			{
			    SendClientMessage(playerid,HELLROT,"Du musst dich einloggen, um auf dem Server spielen zu können!");
			    return Kick(playerid);
			}
			if(!strlen(inputtext) || strlen(inputtext) > 32)
			{
			    format(string,sizeof(string),"{FFFFFF}Der Account {1CA8D6}%s {FFFFFF}wurde {66cc00}gefunden.\n{FFFFFF}Bitte gib dein Passwort ein.\n\n"#HTML_RED"Falsches Passwort eingegeben",PlayerInfo[playerid][pName]);
				return ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login",string,"Einloggen","Abbrechen");
			}
			if(!strcmp(MD5_Hash(inputtext), PlayerInfo[playerid][pPassword]))
			{
			    getdate(tag,monat,jahr);
				gettime(stunde,minute,sekunde);
			    TogglePlayerControllable(playerid,1);
	    		TogglePlayerSpectating(playerid,0);
			    StopPlayerPlaySound(playerid);
				PlayerPlaySound(playerid,1188,0.0,0.0,10.0);
				format(string,sizeof(string),"{A91400}SERVER{FFFFFF}: Willkommen %s",PlayerInfo[playerid][pName]);
				SendClientMessage(playerid,WEISS,string);
				switch(monat)
				{
					case 1:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Januar");
					case 2:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Februar");
					case 3:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist März");
					case 4:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist April");
					case 5:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Mai");
					case 6:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Juni");
					case 7:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Juli");
					case 8:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist August");
					case 9:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist September");
					case 10:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Oktober");
					case 11:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist November");
					case 12:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Dezember");
				}
				if(tag == 31 && monat == 3) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Die Sommerzeit hat begonnen");
				if(tag == 27 && monat == 10) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Die Winterzeit hat begonnen");
				if(tag == 31 && monat == 10) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Halloween");
				if(tag == 24 && monat == 12) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Frohe Weihnachten");
				if(tag == 31 && monat == 12) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Das neue Jahr steht vor der Tür");
				if(tag == 1 && monat == 1) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Frohes Neues Jahr");
			    return SpawnPlayerEx(playerid);
			}
			else
			{
			    format(string,sizeof(string),"{FFFFFF}Der Account {1CA8D6}%s {FFFFFF}wurde {66cc00}gefunden.\n{FFFFFF}Bitte gib dein Passwort ein.\n\n"#HTML_RED"Falsches Passwort eingegeben",PlayerInfo[playerid][pName]);
				return ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login",string,"Einloggen","Abbrechen");
			}
		}
		case DIALOG_REGISTER:
		{
		    if(!response)
			{
			    SendClientMessage(playerid,HELLROT,"Du musst dich registrieren, um auf dem Server spielen zu können!");
			    return Kick(playerid);
			}
			if(strlen(inputtext) < 5 || strlen(inputtext) > 32)
			{
			    format(string,sizeof(string),"{FFFFFF}Der Account {1CA8D6}%s {FFFFFF}wurde {E62942}nicht {FFFFFF}gefunden.\nBitte gib das Wunschpasswort ein.\n\n"#HTML_RED"Das Passwort ist ungültig (5-32 Zeichen)!",PlayerInfo[playerid][pName]);
				return ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Registrierung",string,"Registrieren","Abbrechen");
			}
			format(PlayerInfo[playerid][pPassword], 128, "%s", MD5_Hash(inputtext));
			orm_insert(PlayerInfo[playerid][ORM_ID], "OnPlayerRegister", "d", playerid);
			
			getdate(tag,monat,jahr);
			gettime(stunde,minute,sekunde);
		    TogglePlayerControllable(playerid,1);
    		TogglePlayerSpectating(playerid,0);
		    StopPlayerPlaySound(playerid);
			PlayerPlaySound(playerid,1188,0.0,0.0,10.0);
			format(string,sizeof(string),"{A91400}SERVER{FFFFFF}: Willkommen %s",PlayerInfo[playerid][pName]);
			SendClientMessage(playerid,WEISS,string);
			switch(monat)
			{
				case 1:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Januar");
				case 2:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Februar");
				case 3:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist März");
				case 4:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist April");
				case 5:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Mai");
				case 6:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Juni");
				case 7:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Juli");
				case 8:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist August");
				case 9:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist September");
				case 10:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Oktober");
				case 11:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist November");
				case 12:SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Dezember");
			}
			if(tag == 31 && monat == 3) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Die Sommerzeit hat begonnen");
			if(tag == 27 && monat == 10) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Die Winterzeit hat begonnen");
			if(tag == 31 && monat == 10) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Es ist Halloween");
			if(tag == 24 && monat == 12) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Frohe Weihnachten");
			if(tag == 31 && monat == 12) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Das neue Jahr steht vor der Tür");
			if(tag == 1 && monat == 1) SendClientMessage(playerid,WEISS,"{A91400}SERVER{FFFFFF}: Frohes Neues Jahr");
		    return SpawnPlayerEx(playerid);
		}
		//-------------------------------------[]-------------------------------------//
	}
	return 1;
}

public MinutenTimer()
{
    //-----------------------------[Uhr-Textdraw]-----------------------------//
    gettime(stunde, minute);
	for(new i = 0,j = GetPlayerPoolSize();i <= j;i++)
	{
		if(IsPlayerConnected(i))
			SetPlayerTime(i,stunde,minute);
	}

    new string[32], hourstr[4], minutestr[4];
    if(stunde < 10)
        format(hourstr, sizeof(hourstr), "0%d", stunde);
	else
        format(hourstr, sizeof(hourstr), "%d", stunde);

    if(minute < 10)
        format(minutestr, sizeof(minutestr), "0%d", minute);
	else
        format(minutestr, sizeof(minutestr), "%d", minute);

    format(string, sizeof(string), "~w~%s~g~:~w~%s ~g~Uhr", hourstr, minutestr);
    TextDrawSetString(TimeTextdraw,string);
    //-------------------------------------[]-------------------------------------//
}

//-------------------------------[Gangsystem]---------------------------------//
public GangRequestInvite(playerid, pID)
{
	new rows, fields, string[164],result[32];
	cache_get_data(rows, fields);
    if(rows)
	{
	    cache_get_field_content(0,"GangName",result);
	    format(string, sizeof(string),"GangRequest-Einladung: Der Anführer %s möchte dich in seine vorläufige Gang %s einladen. Nutze /reqgangaccept.",GetName(playerid),result);
		SendClientMessage(pID,SEKTEFARBE,string);
		format(string, sizeof(string),"GangRequest-Einladung: Die Einladung erlischt automatisch, wenn %s oder du dich ausloggst.",GetName(playerid));
		SendClientMessage(pID,SEKTEFARBE,string);
		SendClientMessage(pID,SEKTEFARBE,"GangRequest-Einladung: Die Einladung kann mit /reqgangcancel abgelehnt werden.");
		format(string, sizeof(string),"GangRequest-Einladung: Die Einladung wurde an %s versendet. Die Einladung kann mit /reqgangcancel abgebrochen werden.",GetName(pID));
		SendClientMessage(playerid, SEKTEFARBE, string);
		format(string, sizeof(string),"GangRequest-Einladung: Die Einladung erlischt automatisch, wenn %s oder du dich ausloggst.",GetName(pID));
		return SendClientMessage(playerid, SEKTEFARBE, string);
	}
	return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Der GangName konnte aus der Tabelle nicht geladen werden. [#Error Code 00002].");
}

public GangRequestUninvite(playerid)
{
    new rows, fields, string[164],result[32];
	cache_get_data(rows, fields);
    if(!rows) return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Der angegebene Spielername existiert nicht oder ist nicht in deiner vorläufigen Gang.");
	cache_get_field_content(0, "Name", result);
	format(string,sizeof(string),"UPDATE `accounts` SET `GangRequestMember` = -1 WHERE ID = %d",cache_get_field_content_int(0, "ID"));
	mysql_tquery(SQL,string,"", "");
	format(string, sizeof(string),"GangRequest-Rauswerfen: Du hast %s erfolgreich aus der Gang entfernt.",result);
	return SendClientMessage(playerid, SEKTEFARBE, string);
}

public GangRequestMemberliste(playerid, _string[512], _count)
{
    new rows, fields,count=0, _pname[MAX_PLAYER_NAME+1];
	cache_get_data(rows, fields);
    if(rows)
	{
	    while(count<rows)
		{
		    cache_get_field_content(count,"Name",_pname);
		    format(_string,sizeof(_string),"%s\n%s",_string,_pname);
		}
	}
	if(_count == 0)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Es wurde kein Spieler gefunden. [#Error Code 00001].");
    return ShowPlayerDialog(playerid,DIALOG_REQGANG_MEMBERLIST,DIALOG_STYLE_LIST,"Gangrequest - Mitgliederliste",_string,"Wählen","Schließen");
}

public CheckGangRequest(playerid, _inputtext[])
{
    new rows, fields,string[256];
	cache_get_data(rows, fields);
	if(rows)
	{
	    return ShowPlayerDialog(playerid,DIALOG_GANGREQUEST_INSERT, DIALOG_STYLE_INPUT, "Gang erstellen", "Bitte gib den gewünschten Gangnamen ein.\nHiermit sicherst du dir deinen individuellen Wunschnamen.\nBeachte das du für die Erstellung einer Gang, dennoch\nweitere 3 Mitglieder haben muss.\n\n"#HTML_RED"Der gewählte Gangname ist bereits belegt.", "Absenden", "Abbrechen");
	}
    SendClientMessage(playerid, -1, ""#HTML_LIGHTBLUE"INFORMATION: "#HTML_WHITE"Deine Gang wurde vorübergehend erstellt. Bevor deine Gang freigeschaltet wird, muss sie mindestens aus 4 Personen bestehen (/grequest).");
	SendClientMessage(playerid, WRONGCMD,"Falls du dich bei deinem gewünschten Gangnamen vertippt hast, kannst du diesen jederzeit über das User Control Panel ändern.");
	SendClientMessage(playerid, WRONGCMD,"Wenn du deine Gang einmal freigeschaltet hast, ist eine Änderung des Gangnamens nicht mehr möglich.");
	SendClientMessage(playerid, WRONGCMD,"Unzulässige Gangnamen oder Spaßnamen haben zur Folge, dass deine Gang gelöscht werden könnte.");
	ACMoney(playerid, -GANG_CREATE_COST);
	format(string, sizeof(string),"INSERT INTO `gangrequest` (`GangName`,`Datum`) VALUES ('%s',%i)",_inputtext,gettime());
	mysql_tquery(SQL, string, "OnGangRequestInsert", "d", playerid);
	return 1;
}

public OnGangRequestInsert(playerid)
{
	PlayerInfo[playerid][pGangRequestLead] = 1;
	PlayerInfo[playerid][pGangRequestMember] = cache_insert_id();
	PlayerInfo[playerid][pGangRequestMembers] ++;
	return 1;
}

public OnGangVehicleLoad()
{
	return 1;
}

stock CreateGang(playerid, _GangName[32], _GangTag[4], _GangColor, _GangVehColor1, _GangVehColor2)
{
    new string[16];
	for(new i = 0; i < MAX_GANGS; i++)
	{
	    if(GangInfo[i][gUsed] == 0)
	    {
	        format(GangInfo[i][gGangName], 32, "%s", _GangName);
	        format(GangInfo[i][gGangTag], 4, "%s", _GangTag);
	        format(GangInfo[i][gGangGruender], MAX_PLAYER_NAME+1, "%s", GetName(playerid));
	        GangInfo[i][gGangType] = 1;
	        GangInfo[i][gGangLevel] = 1;
	        GangInfo[i][gGangExp] = 0;
	        GangInfo[i][gGangMember] = 0;
	        GangInfo[i][gGangMaxMember] = 6;
	        GangInfo[i][gGangMaxVeh] = 4;
	        GangInfo[i][gGangColor] = _GangColor;
	        GangInfo[i][gGangVehColor1] = _GangVehColor1;
	        GangInfo[i][gGangVehColor2] = _GangVehColor2;

	        new ORM:ormid = GangInfo[i][ORM_ID] = orm_create("gangs");
	        orm_addvar_int(ormid, GangInfo[playerid][gSQLID], "ID");
			orm_addvar_string(ormid, GangInfo[playerid][gGangName], 32, "GangName");
			orm_addvar_string(ormid, GangInfo[playerid][gGangTag], 4, "GangTag");
			orm_addvar_int(ormid, GangInfo[playerid][gGangType], "GangType");
			orm_addvar_int(ormid, GangInfo[playerid][gGangLevel], "GangLevel");
			orm_addvar_int(ormid, GangInfo[playerid][gGangExp], "GangExp");
			orm_addvar_string(ormid, GangInfo[playerid][gGangGruender], MAX_PLAYER_NAME+1, "GangGruender");
			orm_addvar_int(ormid, GangInfo[playerid][gGangMember], "GangMember");
			orm_addvar_int(ormid, GangInfo[playerid][gGangMaxMember], "GangMaxMember");
			orm_addvar_int(ormid, GangInfo[playerid][gGangMaxVeh], "GangMaxVeh");
			orm_addvar_int(ormid, GangInfo[playerid][gGangColor], "GangColor");
			orm_addvar_int(ormid, GangInfo[playerid][gGangVehColor1], "GangVehColor1");
			orm_addvar_int(ormid, GangInfo[playerid][gGangVehColor2], "GangVehColor2");
			for(new r=0;r<MAX_GRANKS;r++)
			{
			    format(GangRanks[i][r], 32,"Rang %i", r);
			    format(string, sizeof(string),"GangRang%i",r);
			    orm_addvar_string(ormid, GangRanks[i][r], 32, string);
			}
			orm_setkey(ormid, "ID");
			orm_insert(ormid, "", "");
	        GangInfo[i][gUsed] = 1;
	        return i;
		}
	}
	return -1;
}

public OnGangsLoad()
{
	new string[16];
	for(new r=0; r < cache_num_rows(); ++r) {
		new ORM:ormid = GangInfo[r][ORM_ID] = orm_create("gangs");

		orm_addvar_int(ormid, GangInfo[r][gSQLID], "ID");
		orm_setkey(ormid, "ID");
		orm_addvar_string(ormid, GangInfo[r][gGangName], 32, "GangName");
		orm_addvar_string(ormid, GangInfo[r][gGangTag], 4, "GangTag");
		orm_addvar_int(ormid, GangInfo[r][gGangType], "GangType");
		orm_addvar_int(ormid, GangInfo[r][gGangLevel], "GangLevel");
		orm_addvar_int(ormid, GangInfo[r][gGangExp], "GangExp");
		orm_addvar_string(ormid, GangInfo[r][gGangGruender], MAX_PLAYER_NAME+1, "GangGruender");
		orm_addvar_int(ormid, GangInfo[r][gGangMember], "GangMember");
		orm_addvar_int(ormid, GangInfo[r][gGangMaxMember], "GangMaxMember");
		orm_addvar_int(ormid, GangInfo[r][gGangMaxVeh], "GangMaxVeh");
		orm_addvar_int(ormid, GangInfo[r][gGangColor], "GangColor");
		orm_addvar_int(ormid, GangInfo[r][gGangVehColor1], "GangVehColor1");
		orm_addvar_int(ormid, GangInfo[r][gGangVehColor2], "GangVehColor2");
		for(new i=0;i<MAX_GRANKS;i++)
		{
		    format(string, sizeof(string),"GangRang%i",i);
		    orm_addvar_string(ormid, GangRanks[r][i], 32, string);
		}
        GangInfo[r][gUsed] = 1;

		orm_apply_cache(ormid, r);
	}
	return 1;
}

stock SaveGangs()
{
	for(new i = 0;i < MAX_GANGS; i++)
	{
    	orm_update(GangInfo[i][ORM_ID]);
		orm_destroy(GangInfo[i][ORM_ID]);
	}
	return 1;
}

stock CheckGangReqInvitation(playerid)
{
	new string[164];
	if(GetPVarInt(playerid, "GangReqMember") == -1 && GetPVarInt(playerid, "GangReqInvite_pID") == -1)return 1;
	if(PlayerInfo[playerid][pGangRequestMember] == -1 && GetPVarInt(playerid, "GangReqMember") == 1)
	{
	    new leaderid = GetPVarInt(playerid, "GangReqInvite_pID");
	    SetPVarInt(leaderid, "GangReqMember", -1),SetPVarInt(leaderid, "GangReqInvite_pID", -1);
	    SetPVarInt(playerid, "GangReqMember", -1),SetPVarInt(playerid, "GangReqInvite_pID", -1);
	    format(string, sizeof(string),"GangRequest-Einladung: %s hat den Server verlassen. Die Einladung ist somit erloschen.",GetName(playerid));
	    return SendClientMessage(leaderid, SEKTEFARBE, string);
	}
	else if(PlayerInfo[playerid][pGangRequestMember] != -1 && GetPVarInt(playerid, "GangReqMember") == 0)
	{
	    new memberid = GetPVarInt(playerid, "GangReqInvite_pID");
	    SetPVarInt(memberid, "GangReqMember", -1),SetPVarInt(memberid, "GangReqInvite_pID", -1);
	    SetPVarInt(playerid, "GangReqMember", -1),SetPVarInt(playerid, "GangReqInvite_pID", -1);
	    format(string, sizeof(string),"GangRequest-Einladung: %s hat den Server verlassen. Deine Einladung ist somit erloschen.",GetName(playerid));
	    return SendClientMessage(memberid, SEKTEFARBE, string);
	}
	return 1;
}

stock GetGangTypeName(_gGangType)
{
	new GangTypeName[16];
	switch(_gGangType)
	{
	    case 0:GangTypeName="Straßengang";
	    case 1:GangTypeName="Gang";
	    case 2:GangTypeName="Mafia";
	    default:GangTypeName="Ungültig";
	}
	return GangTypeName;
}

CMD:grequest(playerid, params[])
{
	#pragma unused params
	if(PlayerInfo[playerid][pGangRequestMember] == -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist in keiner vorläufigen Gang.");
	if(PlayerInfo[playerid][pGangRequestLead] == 0) {ShowPlayerDialog(playerid,DIALOG_REQGANG_MENU,DIALOG_STYLE_LIST,"Gangrequest - Menü","Spielerübersicht","Wählen","Schließen");}
	else {ShowPlayerDialog(playerid,DIALOG_REQGANG_MENU,DIALOG_STYLE_LIST,"Gangrequest - Menü","Spielerübersicht\nSpieler hinzufügen\nSpieler entfernen\nGang anmelden","Wählen","Schließen");}
	return 1;
}

CMD:reqgangaccept(playerid, params[])
{
    if(GetPVarInt(playerid, "GangReqInvite_pID") == -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du hast keine offenen Einladungen.");
	if(PlayerInfo[playerid][pGangRequestMember] == -1 && GetPVarInt(playerid, "GangReqMember") == 1)
	{
	    new string[164];
	    new leaderid = GetPVarInt(playerid, "GangReqInvite_pID");
	    if(PlayerInfo[leaderid][pGangRequestMembers] == NEEDED_GMEMBERS_FOR_GANG)
	    {
	        SetPVarInt(leaderid, "GangReqMember", -1),SetPVarInt(leaderid, "GangReqInvite_pID", -1);
		    SetPVarInt(playerid, "GangReqMember", -1),SetPVarInt(playerid, "GangReqInvite_pID", -1);
	        return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Die Maximale Mitgliederzahl von "#NEEDED_GMEMBERS_FOR_GANG" wurde erreicht.");
		}
		PlayerInfo[playerid][pGangRequestMember] = PlayerInfo[leaderid][pGangRequestMember];
		PlayerInfo[leaderid][pGangRequestMembers] ++;
	    SetPVarInt(leaderid, "GangReqMember", -1),SetPVarInt(leaderid, "GangReqInvite_pID", -1);
	    SetPVarInt(playerid, "GangReqMember", -1),SetPVarInt(playerid, "GangReqInvite_pID", -1);
	    format(string, sizeof(string),"GangRequest-Einladung: Du hast die Einladung von %s in seine Gang angenommen. Weitere Informationen unter /grequest oder im User Control Panel.", GetName(leaderid));
        SendClientMessage(leaderid, SEKTEFARBE, string);
		format(string, sizeof(string),"GangRequest-Einladung: %s hat die Einladung für deine Gang angenommen.",GetName(playerid));
		return SendClientMessage(leaderid, SEKTEFARBE, string);
	}
	return 1;
}

CMD:reqgangcancel(playerid, params[])
{
    if(GetPVarInt(playerid, "GangReqInvite_pID") == -1)return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du hast keine offenen Einladungen.");
    new string[164];
    if(PlayerInfo[playerid][pGangRequestMember] == -1 && GetPVarInt(playerid, "GangReqMember") == 1)
	{
	    new leaderid = GetPVarInt(playerid, "GangReqInvite_pID");
	    SetPVarInt(leaderid, "GangReqMember", -1),SetPVarInt(leaderid, "GangReqInvite_pID", -1);
	    SetPVarInt(playerid, "GangReqMember", -1),SetPVarInt(playerid, "GangReqInvite_pID", -1);
	    format(string, sizeof(string),"GangRequest-Einladung: Du hast die Einladung von %s abgelehnt.", GetName(leaderid));
	    SendClientMessage(playerid, SEKTEFARBE, string);
	    format(string, sizeof(string),"GangRequest-Einladung: %s hat deine Einladung abgelehnt.",GetName(playerid));
	    return SendClientMessage(leaderid, SEKTEFARBE, string);
	}
	else if(PlayerInfo[playerid][pGangRequestMember] != -1 && GetPVarInt(playerid, "GangReqMember") == 0)
	{
	    new memberid = GetPVarInt(playerid, "GangReqInvite_pID");
	    SetPVarInt(memberid, "GangReqMember", -1),SetPVarInt(memberid, "GangReqInvite_pID", -1);
	    SetPVarInt(playerid, "GangReqMember", -1),SetPVarInt(playerid, "GangReqInvite_pID", -1);
	    format(string, sizeof(string),"GangRequest-Einladung: Du hast die Einladung für %s zurückgezogen.", GetName(memberid));
	    SendClientMessage(playerid, SEKTEFARBE, string);
	    format(string, sizeof(string),"GangRequest-Einladung: %s hat die Einladung zurückgezogen.",GetName(playerid));
	    return SendClientMessage(memberid, SEKTEFARBE, string);
	}
	return 1;
}

CMD:ginvite(playerid, params[])
{
	new pID;
    if(sscanf(params, "u", pID)) return SendClientMessage(playerid,-1, ""#HTML_RED"Befehl: "#HTML_WHITE"/ginvite[playerid]");
    return 1;
}

CMD:guninvite(playerid, params[])
{
    new pID;
    if(sscanf(params, "u", pID)) return SendClientMessage(playerid,-1, ""#HTML_RED"Befehl: "#HTML_WHITE"/guninvite[playerid]");
    return 1;
}

CMD:gsetrank(playerid, params[])
{
    new pID,_rank,string[128];
    if(sscanf(params, "ui", pID,_rank)) return SendClientMessage(playerid,-1, ""#HTML_RED"Befehl: "#HTML_WHITE"/gsetrank[playerid][Rang]");
    if(PlayerInfo[playerid][pGangMember] == 0)return SendClientMessage(playerid,-1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist in keiner Gang.");
    if(PlayerInfo[playerid][pGangRank] >= 9)return SendClientMessage(playerid,-1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du bist kein (Co-)Leader.");
	if(PlayerInfo[playerid][pGangRank] < PlayerInfo[pID][pGangRank])return SendClientMessage(playerid,-1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Der angegebene Spieler besitzt einen höheren Rang.");
	PlayerInfo[pID][pGangRank] = _rank;
	format(string, sizeof(string),"** Der Rang von %s wurde von %s %s auf %s geändert. **",GetName(pID),
	GangRanks[PlayerInfo[playerid][pGangMember]][PlayerInfo[playerid][pGangRank]],
	GetName(playerid),GangRanks[PlayerInfo[pID][pGangMember]][PlayerInfo[pID][pGangRank]]);
	return SendFrakMessage(PlayerInfo[playerid][pGangMember],FCHATCOLOR,string);
}

CMD:gmembers(playerid, params[])
{
	#pragma unused params
	return 1;
}

CMD:gchat(playerid, params[])
{
	return 1;
}
//"**(( %s %s: %s ))**"
CMD:g(playerid, params[])return cmd_gchat(playerid, params);

stock SendFrakMessage(_gangid, _color, _text[])
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i))continue;
		if(IsPlayerNPC(i))continue;
        if(PlayerInfo[i][pGangMember] != _gangid)continue;
        SendClientMessage(i,_color,_text);
	}
	return 1;
}

CMD:gmenu(playerid, params[])
{
	new string[256];
	#pragma unused params
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1631.2754,-1910.4308,13.5521))return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du befindest dich nicht am Gangmenü-Punkt in Los Santos.");
	if(PlayerInfo[playerid][pGangMember] != 0)
	{
	    format(string, sizeof(string),"Alle Gangs anzeigen\nGang Informationen\nFrequently Asked Questions");
	}
	else
	{
	    format(string, sizeof(string),"Alle Gangs anzeigen\nEigene Gang gründen\nFrequently Asked Questions");
	}
	ShowPlayerDialog(playerid, DIALOG_GCREATE_OVERVIEW,DIALOG_STYLE_LIST,"Gangmenü",string, "Auswählen", "Abbrechen");
	return 1;
}
//-------------------------------------[]-------------------------------------//
CMD:admintester(playerid, params[])
{
	ACMoney(playerid,60000);
	PlayerInfo[playerid][pAdmin] = 7;
	PlayerInfo[playerid][pLevel] = 5;
	SendClientMessage(playerid, -1, "TEST COMMAND AUSGEFÜHRT");
	return 1;
}


CMD:teleport(playerid, params[])
{
	if(!isPlayerAnAdmin(playerid, 1))return SendClientMessage(playerid, -1, ""#HTML_RED"FEHLER: "#HTML_WHITE"Du besitzt nicht den jeweiligen Adminrang.");
	new string[512];
	#pragma unused params
	format(string,sizeof(string),"");
	for(new i=0; i<sizeof(Teleports); i++)
	{
	    if(strfind(string,Teleports[i][tStandort],true)==-1)
	    {
	    	format(string,sizeof(string),"%s\n%s",string,Teleports[i][tStandort]);
		}
	}
	ShowPlayerDialog(playerid,TELPORT_LIST,DIALOG_STYLE_LIST,"Teleportmenü",string,"Wählen","Schließen");
	return 1;
}
CMD:telemenu(playerid, params[])return cmd_teleport(playerid, params);
CMD:tele(playerid, params[])return cmd_teleport(playerid, params);

stock AdminRang(playerid)
{
	new adminname[32];
	switch(PlayerInfo[playerid][pAdmin])
	{
	    case 0:adminname="-";
		case 1:adminname="Probesupporter";
		case 2:adminname="Supporter";
		case 3:adminname="Moderator";
		case 4:adminname="Administrator";
		case 5:adminname="Super Administrator";
		case 6:adminname="Server Manager";
		case 7:adminname="Server Leitung";
	}
	return adminname;
}

stock isPlayerFraktion(playerid, frakid)
{
    if(PlayerInfo[playerid][pFraktion] == frakid)return 1;
	return 0;
}

stock isPlayerLeader(playerid)
{
    if(PlayerInfo[playerid][pLeader] == 1)return 1;
	return 0;
}

stock isPlayerAnAdmin(playerid,rang)
{
	if(PlayerInfo[playerid][pAdmin] >= rang)return 1;
	return 0;
}

CMD:admin(playerid, params[])
{
	return 1;
}

stock SetACMoney(playerid,money)
{
	if(!IsPlayerConnected(playerid))return 0;
 	ResetPlayerMoney(playerid);
 	PlayerInfo[playerid][pMoney] = money;
	GivePlayerMoney(playerid,PlayerInfo[playerid][pMoney]);
	return 1;
}

stock ACMoney(playerid,money)
{
	if(!IsPlayerConnected(playerid))return 0;
	PlayerInfo[playerid][pMoney] = PlayerInfo[playerid][pMoney]+money;
    GivePlayerMoney(playerid,money);
	return 1;
}

stock GetACMoney(playerid) return PlayerInfo[playerid][pMoney];

stock ResetVars(playerid)
{
	PlayerInfo[playerid][ID] = -1;
    PlayerInfo[playerid][pGangRequestLead] = 0, PlayerInfo[playerid][pGangRequestMember] = -1, PlayerInfo[playerid][pGangRequestMembers] = 0;
    SetPVarInt(playerid, "GangReqMember", -1), SetPVarInt(playerid, "GangReqInvite_pID", -1);
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerRegister(playerid)
{
	printf("REGISTRATION: Spieler %s hat sich registriert und hat die ID %d.", PlayerInfo[playerid][pName], PlayerInfo[playerid][ID]);
}


public OnPlayerDataLoad(playerid)
{
	new string[128];
	switch(orm_errno(PlayerInfo[playerid][ORM_ID]))
	{
		case ERROR_OK: {
			format(string,sizeof(string),"{FFFFFF}Der Account {1CA8D6}%s {FFFFFF}wurde {66cc00}gefunden.\n{FFFFFF}Bitte gib dein Passwort ein.",PlayerInfo[playerid][pName]);
			ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login",string,"Einloggen","Abbrechen");
		}
		case ERROR_NO_DATA: {
			format(string,sizeof(string),"{FFFFFF}Der Account {1CA8D6}%s {FFFFFF}wurde {E62942}nicht {FFFFFF}gefunden.\nBitte gib das Wunschpasswort ein.",PlayerInfo[playerid][pName]);
			ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Registrierung",string,"Registrieren","Abbrechen");
		}
	}
	orm_setkey(PlayerInfo[playerid][ORM_ID], "ID");
	return 1;
}

stock GetName(playerid)
{
	new name[MAX_PLAYER_NAME+1];
    GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetPlayerID(const accname[])
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(strcmp(accname,GetName(i),true) == 0)
			return i;
		}
	}
	return -1;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

stock SpawnPlayerEx(playerid)
{
    if(!IsPlayerConnected(playerid))return 0;
	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
	ClearAnimations(playerid);
	SpawnPlayer(playerid);
	return 1;
}

public StopPlayerPlaySound(playerid)
{
    PlayerPlaySound(playerid,1063,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1069,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1077,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1098,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1166,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1184,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1186,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1188,0.0,0.0,0.0);
	PlayerPlaySound(playerid,1036,0.0,0.0,0.0);
	return 1;
}

//Haussystem
stock SaveHaus(hid)
{
    new count = GetTickCount();
	new query[2048], miniquery[256], string[512];
	if(HausInfo[hid][hDatabaseID] > 0)
	{
		format(query, sizeof(query), "UPDATE `hausinfo` SET ");
		format(miniquery, sizeof(miniquery), "`EingangX` = '%f',", HausInfo[hid][hEingangX]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`EingangY` = '%f',", HausInfo[hid][hEingangY]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`EingangZ` = '%f',", HausInfo[hid][hEingangZ]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`EingangA` = '%f',", HausInfo[hid][hEingangA]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`HealX` = '%f',", HausInfo[hid][hHealX]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`HealY` = '%f',", HausInfo[hid][hHealY]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`HealZ` = '%f',", HausInfo[hid][hHealZ]), strcat(query, miniquery);
        format(miniquery, sizeof(miniquery), "`VerkaufsPreis` = '%d',", HausInfo[hid][hVerkaufsPreis]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`ServerPreis` = '%d',", HausInfo[hid][hServerPreis]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Geschlossen` = '%d',", HausInfo[hid][hGeschlossen]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`MietPreis` = '%d',", HausInfo[hid][hMietPreis]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Vermietung` = '%d',", HausInfo[hid][hVermietung]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Tresor` = '%d',", HausInfo[hid][hTresor]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`TV` = '%d',", HausInfo[hid][hMaterials]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Geld` = '%d',", HausInfo[hid][hGeld]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Drogen` = '%d',", HausInfo[hid][hDrogen]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Materials` = '%d',", HausInfo[hid][hMaterials]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Level` = '%d',", HausInfo[hid][hLevel]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Stadt` = '%s',", HausInfo[hid][hStadt]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Stadtteil` = '%s',", HausInfo[hid][hStadtteil]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Strasse` = '%s',", HausInfo[hid][hStrasse]), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), "`Hausnummer` = '%s',", HausInfo[hid][hHausnummer]), strcat(query, miniquery);
        format(miniquery, sizeof(miniquery), "`MaxMieter` = '%d',", HausInfo[hid][hMaxMieter]), strcat(query, miniquery);
        format(miniquery, sizeof(miniquery), "`Status` = '%d',", HausInfo[hid][hStatus]), strcat(query, miniquery);
        format(miniquery, sizeof(miniquery), "`Groesse` = '%d',", HausInfo[hid][hGroesse]), strcat(query, miniquery);
        if(HausInfo[hid][hInterior] != -1) format(miniquery, sizeof(miniquery), "`Interior` = '%d'", HausInfo[hid][hInterior]), strcat(query, miniquery);
        else format(miniquery, sizeof(miniquery), "`Interior` = '-1'"), strcat(query, miniquery);
		format(miniquery, sizeof(miniquery), " WHERE `ID` = '%d'", HausInfo[hid][hDatabaseID]), strcat(query, miniquery);
		mysql_function_query(sqlHandle, query, false, "QueryMeldung", "");
		format(string, sizeof(string), "[ - HAUSSYSTEM - ] Haus %d wurde mit einer Geschwindigkeit von %d Millisekunden gespeichert!", HausInfo[hid][hDatabaseID], GetTickCount() - count);
		SendMySQLMessage(string);
		UpdateHausLabel(hid);
	}
	return 1;
}

stock UpdateHausLabel(hid)
{
	new string[200];
    if(HausInfo[hid][hDatabaseID] > 0)
	{
	    if(HausInfo[hid][hStatus] == 4)
 		{
	        format(string, sizeof(string), "%s %s\n%s-%s\nKeine Interaktion Verfügbar", HausInfo[hid][hStrasse], HausInfo[hid][hHausnummer], HausInfo[hid][hStadt], HausInfo[hid][hStadtteil]);
			DestroyDynamicPickup(HausPickup[hid]);
			UpdateDynamic3DTextLabelText(HausLabel[hid], 0x3333FFAA, string);
			HausPickup[hid] = CreateDynamicPickup(1272, 1, HausInfo[hid][hEingangX], HausInfo[hid][hEingangY], HausInfo[hid][hEingangZ]-0.1);
	    }
        else if(HausInfo[hid][hStatus] < 3)
        {
			new preis[10];
            if(HausInfo[hid][hStatus] == 2)
			{
			    format(preis, sizeof(preis), "%d", HausInfo[hid][hVerkaufsPreis]);
			    new len=strlen(preis);
			    if(HausInfo[hid][hVerkaufsPreis]>=1000000) { format(preis, sizeof(preis), "%d",HausInfo[hid][hVerkaufsPreis]),strins(preis, ".", len-6),len++,strins(preis, ".", len-3); }
			    else if(HausInfo[hid][hVerkaufsPreis]>=1000) { format(preis, sizeof(preis), "%d",HausInfo[hid][hVerkaufsPreis]),strins(preis, ".", len-3); }
		 		format(string, sizeof(string), "%s %s\n%s-%s\nVerkauf durch %s\nLevel: %d\nPreis: %s€\nKapazität: %d Personen\nzum Kaufen /hauskaufen", HausInfo[hid][hStrasse], HausInfo[hid][hHausnummer], HausInfo[hid][hStadt], HausInfo[hid][hStadtteil], HausInfo[hid][hBesitzer], HausInfo[hid][hLevel], preis, HausInfo[hid][hMaxMieter], HausInfo[hid][hGroesse]);
			}
			else if(HausInfo[hid][hStatus] == 1)
			{
			    format(preis, sizeof(preis), "%d", HausInfo[hid][hServerPreis]);
			    new len=strlen(preis);
			    if(HausInfo[hid][hServerPreis]>=1000000) { format(preis, sizeof(preis), "%d",HausInfo[hid][hServerPreis]),strins(preis, ".", len-6),len++,strins(preis, ".", len-3); }
			    else if(HausInfo[hid][hServerPreis]>=1000) { format(preis, sizeof(preis), "%d",HausInfo[hid][hServerPreis]),strins(preis, ".", len-3); }
                format(string, sizeof(string), "%s %s\n%s-%s\nVerkauf durch San Andreas Immobilien\nLevel: %d\nPreis: %s€\nKapazität: %d Personen\nGrößen-Kategorie: %d\nzum Kaufen /hauskaufen", HausInfo[hid][hStrasse], HausInfo[hid][hHausnummer], HausInfo[hid][hStadt], HausInfo[hid][hStadtteil], HausInfo[hid][hLevel], preis, HausInfo[hid][hMaxMieter], HausInfo[hid][hGroesse]);
			}
			UpdateDynamic3DTextLabelText(HausLabel[hid], 0x00FF00AA, string);
			DestroyDynamicPickup(HausPickup[hid]);
			HausPickup[hid] = CreateDynamicPickup(1273, 1, HausInfo[hid][hEingangX], HausInfo[hid][hEingangY], HausInfo[hid][hEingangZ]-0.1);
		}
		else if(HausInfo[hid][hStatus] == 3)
		{
		    if(HausInfo[hid][hVermietung] == 1)
		    {
		        format(string, sizeof(string), "%s %s\n%s-%s\nBesitzer: %s\nMietpreis: %d\nzum Mieten /hausmieten", HausInfo[hid][hStrasse], HausInfo[hid][hHausnummer], HausInfo[hid][hStadt], HausInfo[hid][hStadtteil], HausInfo[hid][hBesitzer], HausInfo[hid][hMietPreis]);
                DestroyDynamicPickup(HausPickup[hid]);
				HausPickup[hid] = CreateDynamicPickup(1239, 1, HausInfo[hid][hEingangX], HausInfo[hid][hEingangY], HausInfo[hid][hEingangZ]-0.1);
			    if(HausInfo[hid][hGeschlossen] == 0) UpdateDynamic3DTextLabelText(HausLabel[hid], 0x00FF22AA, string);
				else UpdateDynamic3DTextLabelText(HausLabel[hid], 0xFF0000AA, string);
			}
			else
		    {
		        format(string, sizeof(string), "%s %s\n%s-%s\nBesitzer: %s\nkeine Interaktion verfügbar", HausInfo[hid][hStrasse], HausInfo[hid][hHausnummer], HausInfo[hid][hStadt], HausInfo[hid][hStadtteil], HausInfo[hid][hBesitzer]);
		        DestroyDynamicPickup(HausPickup[hid]);
				HausPickup[hid] = CreateDynamicPickup(1239, 1, HausInfo[hid][hEingangX], HausInfo[hid][hEingangY], HausInfo[hid][hEingangZ]-0.1);
			    if(HausInfo[hid][hGeschlossen] == 0) UpdateDynamic3DTextLabelText(HausLabel[hid], 0x00FF22AA, string);
				else UpdateDynamic3DTextLabelText(HausLabel[hid], 0xFF0000AA, string);
			}
		}
		else
		{
		    format(string, sizeof(string), "Hausnummer: %d\nKein Verkauf", HausInfo[hid][hDatabaseID], HausInfo[hid][hBesitzer]);
      		DestroyDynamicPickup(HausPickup[hid]);
			HausPickup[hid] = CreateDynamicPickup(1272, 1, HausInfo[hid][hEingangX], HausInfo[hid][hEingangY], HausInfo[hid][hEingangZ]-0.1);
			UpdateDynamic3DTextLabelText(HausLabel[hid], 0xFF000091, string);
		}
	}
	return 1;
}

stock CreateNewHaus(playerid, preis, level, groesse, stadt[64], stadtteil[64], strasse[64], hausnummer[64])
{
	new query[1024], string[100], Float:Pos[4];
	for(new h = 1; h < MAX_HOUSES; h++)
	{
	    if(HausInfo[h][hDatabaseID] == 0)
	    {
	        GetPlayerPos(playerid, Pos[0],Pos[1],Pos[2]);
	        GetPlayerFacingAngle(playerid, Pos[3]);
	        HausInfo[h][hServerPreis] = preis;
	        HausInfo[h][hEingangX] = Pos[0];
	        HausInfo[h][hEingangY] = Pos[1];
	        HausInfo[h][hEingangZ] = Pos[2];
	        HausInfo[h][hEingangA] = Pos[3];
	        HausInfo[h][hGeschlossen] = 1;
		    HausInfo[h][hStatus] = 1;
		    HausInfo[h][hGeld] = 0;
		    HausInfo[h][hDrogen] = 0;
		    HausInfo[h][hMaterials] = 0;
		    HausInfo[h][hStadt] = stadt;
		    HausInfo[h][hStadtteil] = stadtteil;
		    HausInfo[h][hStrasse] = strasse;
		    HausInfo[h][hHausnummer] = hausnummer;
		    HausInfo[h][hMaxMieter] = 3;
		    HausInfo[h][hGroesse] = groesse;
		    HausInfo[h][hVermietung] = 0;
		    HausInfo[h][hMietPreis] = 80;
		    HausInfo[h][hInterior] = -1;
		    HausInfo[h][hLevel] = level;
		    strmid(HausInfo[h][hBesitzer], "SA Immobilien", 0, strlen("SA Immobilien"), 128);
		    format(query, sizeof(query), "INSERT INTO `hausinfo` (`EingangX`, `EingangY`, `EingangZ`, `EingangA`, `Serverpreis`, `Stadt`, `Stadtteil`, `Strasse`, `Hausnummer`, `Groesse`) VALUES ('%f', '%f', '%f', '%f', '%i', '%s', '%s', '%s', '%s', '%d')", Pos[0], Pos[1], Pos[2], Pos[3], preis, stadt, stadtteil, strasse, hausnummer, groesse);
			mysql_query(sqlHandle, query);
		    HausInfo[h][hDatabaseID] = mysql_insert_id();
		    format(string, sizeof(string), "%s %s\n%s, %s\nKeine Interaktion Verfügbar", HausInfo[h][hStrasse], HausInfo[h][hHausnummer], HausInfo[h][hStadtteil], HausInfo[h][hStadt]);
			HausLabel[h] = CreateDynamic3DTextLabel(string, 0x0000AAAA, HausInfo[h][hEingangX], HausInfo[h][hEingangY], HausInfo[h][hEingangZ], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
			HausPickup[h] = CreateDynamicPickup(1239, 1, HausInfo[h][hEingangX], HausInfo[h][hEingangY], HausInfo[h][hEingangZ]);
			format(string, sizeof(string), "%d",h);
			print(string);
			SaveHaus(h);
		    return h;
	    }
	}
	return 0;
}
//Haussystem

stock SendStrukturMessage(playerid, typ, text[])
{
	switch(typ)
	{
	    case MSG_BENUTZUNG: SendFormatMessage(playerid, COLOR_BENUTZUNG, "[BENUTZUNG] {FFFFFF}%s", text);
	    case MSG_FEHLER: SendFormatMessage(playerid, COLOR_LIGHTRED, "[FEHLER] {FFFFFF}%s", text);
	    case MSG_ERFOLGREICH: SendFormatMessage(playerid, COLOR_LIGHTGREEN, "[ERFOLGREICH] {FFFFFF}%s", text);
		case MSG_INFO: SendFormatMessage(playerid, 0x00FFBEFF, "[INFORMATION] {FFFFFF}%s", text);
		case MSG_HELP: SendFormatMessage(playerid, 0x00FF96FF, "[HILFE] {FFFFFF}%s", text);
		case MSG_WARNUNG: SendFormatMessage(playerid, 0xF5FF00FF, "[WARNUNG] {FFFFFF}%s", text);
	}
	return 1;
}



stock SendFormatMessage(const iPlayer, const iColor, const szFormat[], { Float, _ }: ...) // by RyDeR`
{
	new iArgs = (numargs() - 3) << 2;
	if(iArgs)
	{
		static s_szBuf[144],s_iAddr1,s_iAddr2;
		#emit ADDR.PRI szFormat
		#emit STOR.PRI s_iAddr1
		for(s_iAddr2 = s_iAddr1 + iArgs, iArgs += 12; s_iAddr2 != s_iAddr1; s_iAddr2 -= 4)
		{
			#emit LOAD.PRI s_iAddr2
			#emit LOAD.I
			#emit PUSH.PRI
		}
		#emit CONST.PRI s_szBuf
		#emit PUSH.S szFormat
		#emit PUSH.C 144
		#emit PUSH.PRI
		#emit PUSH.S iArgs
		#emit SYSREQ.C format
		#emit LCTRL 4
		#emit LOAD.S.ALT iArgs
		#emit ADD.C 4
		#emit ADD
		#emit SCTRL 4
		return (iPlayer != -1) ? SendClientMessage(iPlayer, iColor, s_szBuf) : SendClientMessageToAll(iColor, s_szBuf);
	}
	return (iPlayer != -1) ? SendClientMessage(iPlayer, iColor, szFormat) : SendClientMessageToAll(iColor, szFormat);
}

public OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	switch(errorid)
	{
		case CR_SERVER_GONE_ERROR:
		{
			printf("Lost connection to server, trying reconnect...");
			mysql_reconnect(connectionHandle);
		}
		case ER_SYNTAX_ERROR:
		{
			printf("Something is wrong in your syntax, query: %s",query);
		}
	}
	return 1;
}

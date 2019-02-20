////////////////////////////////////////////////////////////////////////////////////////////////
//							  PLAYER LOCATION DISPLAY v1.0                                    //
//									By Infin1tyy :D                                           //
//	 (Special Thanks to Gravityfalls/Logic for helping me get this to work with streamer!) 	  //
////////////////////////////////////////////////////////////////////////////////////////////////

#define FILTERSCRIPT
#include <a_samp>

#include <streamer>
#include <izcmd>

new PlayerText:p_BarTextdraw[MAX_PLAYERS][2];
new PlayerText:p_LocationTextdraw[MAX_PLAYERS][2];
new PlayerText:p_DirectionTextdraw[MAX_PLAYERS];

new bool:p_Direction[MAX_PLAYERS];
new bool:p_PlayerSpawned[MAX_PLAYERS];

#define COLOR_BLUE		0x2641FEFF
#define COL_BLUE		"{2641FE}"

//#define SHOW_GANGZONES uncomment this to make gangzones viewable.

main() {
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	print("Player Location Display v1.0 Loaded!");
	print("By Infin1tyy, with help from Gravityfalls.");
	print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
}

#include "filterscripts/pld/zones.pwn"
#include "filterscripts/pld/cmds.pwn"
#include "filterscripts/pld/colors.pwn"

public OnFilterScriptInit() {
	for(new i = 0; i < sizeof eZones; i++) {
		eZones[i][e_ZONE_GANGZONE] = GangZoneCreate(eZones[i][e_ZONE_MIN_X], eZones[i][e_ZONE_MIN_Y], 
			eZones[i][e_ZONE_MAX_X], eZones[i][e_ZONE_MAX_Y]);

		eZones[i][e_ZONE_RECTANGLE] = CreateDynamicRectangle(eZones[i][e_ZONE_MIN_X], eZones[i][e_ZONE_MIN_Y], 
			eZones[i][e_ZONE_MAX_X], eZones[i][e_ZONE_MAX_Y]);

        Streamer_SetIntData(STREAMER_TYPE_AREA, eZones[i][e_ZONE_RECTANGLE], E_STREAMER_EXTRA_ID, i);
	}

	return 1;
}

public OnFilterScriptExit() {
	for(new i = 0; i < sizeof eZones; i++) {
		GangZoneDestroy(eZones[i][e_ZONE_GANGZONE]);
	}

	return 1;
}

public OnPlayerSpawn(playerid) {
	p_BarTextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 124.666679, 419.652221, "mdl-12000:bar");
	PlayerTextDrawTextSize(playerid, p_BarTextdraw[playerid][0], 3.000000, 23.000000);
	PlayerTextDrawAlignment(playerid, p_BarTextdraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, p_BarTextdraw[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, p_BarTextdraw[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, p_BarTextdraw[playerid][0], 255);
	PlayerTextDrawFont(playerid, p_BarTextdraw[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, p_BarTextdraw[playerid][0], 0);

	p_BarTextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 97.666702, 419.652038, "mdl-12000:bar");
	PlayerTextDrawTextSize(playerid, p_BarTextdraw[playerid][1], 3.000000, 23.000000);
	PlayerTextDrawAlignment(playerid, p_BarTextdraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, p_BarTextdraw[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, p_BarTextdraw[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, p_BarTextdraw[playerid][1], 255);
	PlayerTextDrawFont(playerid, p_BarTextdraw[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, p_BarTextdraw[playerid][1], 0);
	PlayerTextDrawSetSelectable(playerid, p_BarTextdraw[playerid][1], true);

	p_LocationTextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 131.333374, 419.392639, "Unknown_Location");
	PlayerTextDrawLetterSize(playerid, p_LocationTextdraw[playerid][0], 0.298000, 0.882370);
	PlayerTextDrawTextSize(playerid, p_LocationTextdraw[playerid][0], -40.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, p_LocationTextdraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, p_LocationTextdraw[playerid][0], -5963521);
	PlayerTextDrawSetShadow(playerid, p_LocationTextdraw[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, p_LocationTextdraw[playerid][0], 255);
	PlayerTextDrawFont(playerid, p_LocationTextdraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, p_LocationTextdraw[playerid][0], 1);

	p_LocationTextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 131.000061, 429.348144, "Undefined,_San_Andreas");
	PlayerTextDrawLetterSize(playerid, p_LocationTextdraw[playerid][1], 0.410666, 1.313777);
	PlayerTextDrawAlignment(playerid, p_LocationTextdraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, p_LocationTextdraw[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, p_LocationTextdraw[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, p_LocationTextdraw[playerid][1], 255);
	PlayerTextDrawFont(playerid, p_LocationTextdraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, p_LocationTextdraw[playerid][1], 1);

	p_DirectionTextdraw[playerid] = CreatePlayerTextDraw(playerid, 112.333335, 422.711120, "NW");
	PlayerTextDrawLetterSize(playerid, p_DirectionTextdraw[playerid], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, p_DirectionTextdraw[playerid], 2);
	PlayerTextDrawColor(playerid, p_DirectionTextdraw[playerid], -1);
	PlayerTextDrawSetShadow(playerid, p_DirectionTextdraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, p_DirectionTextdraw[playerid], 255);
	PlayerTextDrawFont(playerid, p_DirectionTextdraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid, p_DirectionTextdraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, p_DirectionTextdraw[playerid], true);

	#if defined SHOW_GANGZONES
	for(new i = 0; i < sizeof eZones; i++) {
		GangZoneShowForPlayer(playerid, eZones[i][e_ZONE_GANGZONE], eZones[i][e_ZONE_COLOR]);
	}
	#endif

	for(new i = 0; i < 2; i++) {
		PlayerTextDrawShow(playerid, p_BarTextdraw[playerid][i]);
	}

	for(new i = 0; i < 2; i++) {
		PlayerTextDrawShow(playerid, p_LocationTextdraw[playerid][i]);
	}

	PlayerTextDrawShow(playerid, p_DirectionTextdraw[playerid]);

	p_Direction[playerid] = true;
	p_PlayerSpawned[playerid] = true;

	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	for(new i = 0; i < 2; i++) {
		PlayerTextDrawHide(playerid, p_BarTextdraw[playerid][i]);
	}
	for(new i = 0; i < 2; i++) {
		PlayerTextDrawHide(playerid, p_LocationTextdraw[playerid][i]);
	}
	PlayerTextDrawHide(playerid, p_DirectionTextdraw[playerid]);
	return 1;
}

public OnPlayerUpdate(playerid) {
	if(p_Direction[playerid] == false) 
		return 1;

	new Float:angle;

	if(IsPlayerInAnyVehicle(playerid)) {
		GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
	}
	else {
		GetPlayerFacingAngle(playerid, angle);
	}

	if(angle >= 355.0 || angle <= 5.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "N");
	else if(angle >= 265.0 && angle <= 275.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "E");
	else if(angle >= 175.0 && angle <= 185.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "S");
	else if(angle >= 85.0 && angle <= 95.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "W");

	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid) {
    new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);

    PlayerTextDrawSetString(playerid, p_LocationTextdraw[playerid][0], eZones[i][e_ZONE_NAME_1]);
    PlayerTextDrawSetString(playerid, p_LocationTextdraw[playerid][1], eZones[i][e_ZONE_NAME_2]);
    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid) {
    if (!IsPlayerInAnyDynamicArea(playerid)) {
		PlayerTextDrawSetString(playerid, p_LocationTextdraw[playerid][0], "Unknown_Location");
		PlayerTextDrawSetString(playerid, p_LocationTextdraw[playerid][1], "Undefined,_San_Andreas");
    }
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	if(playertextid == p_DirectionTextdraw[playerid]) {
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Player Location Display", "Player Location Display\nCreated by Infinity\n\
			With help from Gravityfalls!", "Okay", "");
	}
	return 1;
}
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
new p_TextDirection[8][MAX_PLAYERS];

#define COLOR_BLUE		0x2641FEFF
#define COL_BLUE		"{2641FE}"

#define COLOR_GREEN     0x00FF00FF
#define COL_GREEN       "{00FF00}"

#define COLOR_RED       0xFF0000FF
#define COL_RED         "{FF0000}"

/* 
	v1.1 Changelog

	- Removed the colors.pwn module.
	- Removed OnPlayerDisconnect.
	- Removed p_PlayerSpawned.
	- Added a couple new variables, updating will only happen if the player's direction has actually changed.
	- Player is now able to know whether or not they have PLD disabled with a notification.
	- Textdraws now load when a player connects.
	- I forgot to distrubute the bars between the direction, it's added now.

*/

//#define SHOW_GANGZONES uncomment this to make gangzones viewable.

main() {
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	print("Player Location Display v1.0 Loaded!");
	print("By Infin1tyy, with help from Gravityfalls.");
	print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
}

#include "filterscripts/pld/zones.pwn"
#include "filterscripts/pld/cmds.pwn"

public OnFilterScriptInit() {
	for(new i = 0; i < sizeof eZones; i++) {
		eZones[i][e_ZONE_GANGZONE] = GangZoneCreate(eZones[i][e_ZONE_MIN_X], eZones[i][e_ZONE_MIN_Y], 
			eZones[i][e_ZONE_MAX_X], eZones[i][e_ZONE_MAX_Y]);

		eZones[i][e_ZONE_RECTANGLE] = CreateDynamicRectangle(eZones[i][e_ZONE_MIN_X], eZones[i][e_ZONE_MIN_Y], 
			eZones[i][e_ZONE_MAX_X], eZones[i][e_ZONE_MAX_Y]);

        Streamer_SetIntData(STREAMER_TYPE_AREA, eZones[i][e_ZONE_RECTANGLE], E_STREAMER_EXTRA_ID, i);
	}

	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) {
		if (IsPlayerConnected(i)) {
			CreateTextDraws(i);
		}
	}

	return 1;
}

public OnFilterScriptExit() {
	for(new i = 0; i < sizeof eZones; i++) {
		GangZoneDestroy(eZones[i][e_ZONE_GANGZONE]);
	}

	return 1;
}

forward CreateTextDraws(playerid);
public CreateTextDraws(playerid) {
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

	return 1;
}

public OnPlayerConnect(playerid) {
	CreateTextDraws(playerid);	
	return 1;
}

public OnPlayerUpdate(playerid) {
	if(p_Direction[playerid] == false) 
		return 1;

	new Float:rz;
	new p_PreviousDirection[8];

	strcat((p_PreviousDirection[0] = EOS, p_PreviousDirection), p_TextDirection[playerid]);

	if(IsPlayerInAnyVehicle(playerid)) {
		GetVehicleZAngle(GetPlayerVehicleID(playerid), rz);
	}
	else {
		GetPlayerFacingAngle(playerid, rz);
	}

	/*if(angle >= 355.0 || angle <= 5.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "N");
	else if(angle >= 265.0 && angle <= 275.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "E");
	else if(angle >= 175.0 && angle <= 185.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "S");
	else if(angle >= 85.0 && angle <= 95.0) PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], "W");*/

	if(rz >= 348.75 || rz < 11.25) p_TextDirection[playerid] = "N";
	else if(rz >= 326.25 && rz < 348.75) p_TextDirection[playerid] = "NNE";
	else if(rz >= 303.75 && rz < 326.25) p_TextDirection[playerid] = "NE";
	else if(rz >= 281.25 && rz < 303.75) p_TextDirection[playerid] = "ENE";
	else if(rz >= 258.75 && rz < 281.25) p_TextDirection[playerid] = "E";
	else if(rz >= 236.25 && rz < 258.75) p_TextDirection[playerid] = "ESE";
	else if(rz >= 213.75 && rz < 236.25) p_TextDirection[playerid] = "SE";
	else if(rz >= 191.25 && rz < 213.75) p_TextDirection[playerid] = "SSE";
	else if(rz >= 168.75 && rz < 191.25) p_TextDirection[playerid] = "S";
	else if(rz >= 146.25 && rz < 168.75) p_TextDirection[playerid] = "SSW";
	else if(rz >= 123.25 && rz < 146.25) p_TextDirection[playerid] = "SW";
	else if(rz >= 101.25 && rz < 123.25) p_TextDirection[playerid] = "WSW";
	else if(rz >= 78.75 && rz < 101.25) p_TextDirection[playerid] = "W";
	else if(rz >= 56.25 && rz < 78.75) p_TextDirection[playerid] = "WNW";
	else if(rz >= 33.75 && rz < 56.25) p_TextDirection[playerid] = "NW";
	else if(rz >= 11.5 && rz < 33.75) p_TextDirection[playerid] = "NNW";
	// Credits to Pottus for the above.

	if(strcmp(p_PreviousDirection, p_TextDirection[playerid]))
		return 1;

	PlayerTextDrawSetString(playerid, p_DirectionTextdraw[playerid], p_TextDirection[playerid]);

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
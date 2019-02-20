#include <a_samp>

main() {
	print("\n----------------------------------");
	print("  Bare script configured for PLD \n");
	print("----------------------------------\n");
}

public OnGameModeInit () {
    print("PLD bare script online!");
	SendRconCommand("loadfs main"); // it will automatically load the filterscript. remove this line if you are loading from server.cfg!

	CreateVehicle(411, 2, 0, 5, 0, -1, -1, 0, 0);
    return true; 
}

public OnGameModeExit () {
	print("PLD bare script offline!");
	SendRconCommand("unloadfs main"); // it will automatically unload the filterscript.
	return true;
}

public OnPlayerConnect(playerid) {
	SendClientMessage(playerid, -1, "Welcome to this Player Location Display bare script server.");
	return true;
}

public OnPlayerSpawn(playerid) {
	SetPlayerPos(playerid, 0, 0, 3);
	return true;
}


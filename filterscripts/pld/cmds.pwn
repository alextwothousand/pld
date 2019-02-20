CMD:pld(playerid, params[]) {
	if(!p_PlayerSpawned[playerid])
		return SendClientMessage(playerid, COLOR_BLUE, "PLD: {FFFFFF}You must be spawned to use this command!");

	switch (p_Direction[playerid]) {
		case 1: p_Direction[playerid] = false;
		case 0: p_Direction[playerid] = true;
	}
	return 1;
}
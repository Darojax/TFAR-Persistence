if (!hasInterface) exitWith { false };

TFARP_testFailNextRespawn = true;
TFARP_testLeaveRespawnMismatch = false;
["Respawn recovery test armed for the next player death and respawn"] call TFARP_fnc_notify;
true

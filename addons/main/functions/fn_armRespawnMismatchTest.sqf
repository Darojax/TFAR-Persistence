if (!hasInterface) exitWith { false };

TFARP_testFailNextRespawn = true;
TFARP_testLeaveRespawnMismatch = true;
["Mismatch-only test armed; the next respawn will retain deliberately incorrect radio settings"] call TFARP_fnc_notify;
true

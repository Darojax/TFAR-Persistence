[
    "TFARP_persistFrequencies",
    "CHECKBOX",
    ["Persist channel frequencies", "Disable this if the mission or server owns the frequency plan."],
    "TFAR Persistence",
    true,
    false
] call CBA_fnc_addSetting;

[
    "TFARP_notifications",
    "CHECKBOX",
    ["Show notifications", "Show informational, warning, and error messages from TFAR Persistence."],
    "TFAR Persistence",
    true,
    false
] call CBA_fnc_addSetting;

TFARP_restoring = false;
TFARP_respawnSnapshot = [];
TFARP_respawnAwaiting = false;
TFARP_respawnGeneration = 0;
TFARP_respawnPlayerAdjusted = false;
TFARP_testFailNextRespawn = false;
TFARP_testLeaveRespawnMismatch = false;

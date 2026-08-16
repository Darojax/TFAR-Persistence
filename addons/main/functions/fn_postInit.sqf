if (!hasInterface) exitWith {};

[
    "TFAR Persistence",
    "TFARP_openPresetManager",
    ["Open saved radio setups", "Create, restore, and delete named cross-session radio setups."],
    { call TFARP_fnc_openPresetDialog; },
    {},
    [-1, [false, false, false]]
] call CBA_fnc_addKeybind;

[
    "TFAR Persistence",
    "TFARP_saveCurrent",
    ["Save current settings to active profile", "Immediately update the selected named radio profile."],
    { [true] call TFARP_fnc_saveCurrent; },
    {},
    [-1, [false, false, false]]
] call CBA_fnc_addKeybind;

[
    "TFAR Persistence",
    "TFARP_restoreSaved",
    ["Restore active radio profile", "Manually restore the selected named profile to radios currently carried."],
    { [] spawn TFARP_fnc_confirmRestoreActive; },
    {},
    [-1, [false, false, false]]
] call CBA_fnc_addKeybind;

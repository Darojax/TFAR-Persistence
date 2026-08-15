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

private _radioAdjustmentEvents = [
    "OnSWchannelSet",
    "OnLRchannelSet",
    "OnSWvolumeSet",
    "OnLRvolumeSet",
    "OnSWstereoSet",
    "OnLRstereoSet",
    "OnSWspeakersSet",
    "OnLRspeakersSet",
    "OnFrequencyChanged"
];

{
    [format ["TFAR_event_%1", _x], {
        if (
            missionNamespace getVariable ["TFARP_respawnAwaiting", false] &&
            {!(missionNamespace getVariable ["TFARP_restoring", false])}
        ) then {
            TFARP_respawnPlayerAdjusted = true;
            TFARP_respawnAwaiting = false;
        };
    }] call CBA_fnc_addEventHandler;
} forEach _radioAdjustmentEvents;

addMissionEventHandler ["EntityKilled", {
    params ["_unit"];
    if (hasInterface && {_unit isEqualTo player}) then {
        TFARP_respawnSnapshot = [_unit] call TFARP_fnc_captureCurrent;
        private _radioCount = count (TFARP_respawnSnapshot param [2, []]) + count (TFARP_respawnSnapshot param [3, []]);
        TFARP_respawnAwaiting = (TFARP_respawnSnapshot param [0, 0]) isEqualTo 1 && {_radioCount > 0};
        TFARP_respawnPlayerAdjusted = false;
        TFARP_respawnGeneration = TFARP_respawnGeneration + 1;
    };
}];

addMissionEventHandler ["EntityRespawned", {
    params ["_newEntity"];
    if (hasInterface && {_newEntity isEqualTo player} && {TFARP_respawnAwaiting}) then {
        private _generation = TFARP_respawnGeneration;
        [{[_this, 0] call TFARP_fnc_verifyRespawnRestore}, _generation, 8] call CBA_fnc_waitAndExecute;
    };
}];

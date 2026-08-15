params [
    ["_generation", -1, [0]],
    ["_attempt", 0, [0]]
];

if (
    !(missionNamespace getVariable ["TFARP_respawnAwaiting", false]) ||
    {_generation isNotEqualTo (missionNamespace getVariable ["TFARP_respawnGeneration", -2])} ||
    {missionNamespace getVariable ["TFARP_respawnPlayerAdjusted", false]}
) exitWith { false };

private _snapshot = missionNamespace getVariable ["TFARP_respawnSnapshot", []];
if (_snapshot isEqualTo []) exitWith {
    TFARP_respawnAwaiting = false;
    false
};

([_snapshot] call TFARP_fnc_compareSnapshot) params ["_matching", "_mismatching", "_matched", "_total"];

if (_matched < _total && {_attempt < 5}) exitWith {
    [{_this call TFARP_fnc_verifyRespawnRestore}, [_generation, _attempt + 1], 2] call CBA_fnc_waitAndExecute;
    true
};

TFARP_respawnAwaiting = false;
if (_mismatching isEqualTo []) exitWith { true };

private _restored = [_snapshot, _matching] call TFARP_fnc_restoreSnapshot;
if (_restored isNotEqualTo []) then {
    [format ["Respawn recovery corrected settings on %1 radio(s)", count _restored]] call TFARP_fnc_notify;
};
true

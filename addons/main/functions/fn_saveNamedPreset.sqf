params [
    ["_name", "", [""]]
];

if ((count _name) > 40) then { _name = _name select [0, 40]; };

if (_name isEqualTo "") exitWith {
    ["Enter a name for this setup"] call TFARP_fnc_notify;
    false
};

private _store = call TFARP_fnc_loadStore;
_store params ["", "", ["_profiles", [], [[]]]];
private _existingIndex = _profiles findIf {
    toLowerANSI (_x param [0, ""]) isEqualTo toLowerANSI _name
};
if (_existingIndex >= 0) exitWith {
    private _existingName = (_profiles select _existingIndex) param [0, _name];
    [format ["A radio profile named '%1' already exists. Choose a different name.", _existingName]] call TFARP_fnc_notify;
    false
};

TFARP_respawnPlayerAdjusted = true;
TFARP_respawnAwaiting = false;

private _snapshot = [] call TFARP_fnc_captureCurrent;
if (_snapshot isEqualTo []) exitWith { false };
if ((_snapshot param [2, []]) isEqualTo [] && {(_snapshot param [3, []]) isEqualTo []}) exitWith {
    ["You are not carrying a supported handheld or backpack radio"] call TFARP_fnc_notify;
    false
};

_profiles pushBack [_name, _snapshot];

_store set [1, _name];
_store set [2, _profiles];
[_store] call TFARP_fnc_writeStore;
call TFARP_fnc_refreshPresetDialog;
true

params [
    ["_showNotification", false, [false]]
];

if (!hasInterface || {missionNamespace getVariable ["TFARP_restoring", false]}) exitWith { false };

private _snapshot = [] call TFARP_fnc_captureCurrent;
if (_snapshot isEqualTo []) exitWith { false };
if ((_snapshot param [2, []]) isEqualTo [] && {(_snapshot param [3, []]) isEqualTo []}) exitWith {
    if (_showNotification) then {
        ["You are not carrying a supported handheld or backpack radio"] call TFARP_fnc_notify;
    };
    false
};

private _store = call TFARP_fnc_loadStore;
_store params ["", ["_activeName", "Default", [""]], ["_profiles", [], [[]]]];
private _index = _profiles findIf {toLowerANSI (_x param [0, ""]) isEqualTo toLowerANSI _activeName};
if (_index < 0) then {
    _activeName = "Default";
    _profiles pushBack [_activeName, _snapshot];
} else {
    _profiles set [_index, [(_profiles select _index) param [0, _activeName], _snapshot]];
};
_store set [1, _activeName];
_store set [2, _profiles];
[_store] call TFARP_fnc_writeStore;

if (_showNotification) then {
    [format ["Radio settings saved to '%1'", _activeName]] call TFARP_fnc_notify;
};

true

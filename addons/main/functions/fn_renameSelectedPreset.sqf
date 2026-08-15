params [
    ["_oldName", "", [""]],
    ["_newName", "", [""]]
];

if (_oldName isEqualTo "") exitWith { false };
if ((count _newName) > 40) then { _newName = _newName select [0, 40]; };
if (_newName isEqualTo "") exitWith {
    ["Enter a new name for this profile"] call TFARP_fnc_notify;
    false
};

private _store = call TFARP_fnc_loadStore;
_store params ["", ["_activeName", "Default", [""]], ["_profiles", [], [[]]]];
private _oldIndex = _profiles findIf {(_x param [0, ""]) isEqualTo _oldName};
if (_oldIndex < 0) exitWith { false };

private _duplicateIndex = _profiles findIf {
    toLowerANSI (_x param [0, ""]) isEqualTo toLowerANSI _newName
};
if (_duplicateIndex >= 0 && {_duplicateIndex isNotEqualTo _oldIndex}) exitWith {
    [format ["A profile named '%1' already exists", _newName]] call TFARP_fnc_notify;
    false
};

private _snapshot = (_profiles select _oldIndex) param [1, []];
_profiles set [_oldIndex, [_newName, _snapshot]];
if (toLowerANSI _activeName isEqualTo toLowerANSI _oldName) then {
    _store set [1, _newName];
};
_store set [2, _profiles];
[_store] call TFARP_fnc_writeStore;

call TFARP_fnc_refreshPresetDialog;
disableSerialization;
private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { true };
private _list = _display displayCtrl 9501;
private _newIndex = _profiles findIf {(_x param [0, ""]) isEqualTo _newName};
if (_newIndex >= 0) then {
    _list lbSetCurSel _newIndex;
};
[format ["Profile '%1' renamed to '%2'", _oldName, _newName]] call TFARP_fnc_notify;
true

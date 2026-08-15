disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { false };

private _list = _display displayCtrl 9501;
private _name = _list lbData (lbCurSel _list);
if (_name isEqualTo "") exitWith { false };

private _store = call TFARP_fnc_loadStore;
_store params ["", ["_activeName", "Default", [""]], ["_profiles", [], [[]]]];
if ((count _profiles) <= 1) exitWith {
    systemChat format [
        "[TFAR Persistence] '%1' is the last saved radio profile. Create another profile before deleting it.",
        _name
    ];
    false
};

private _confirmed = [
    format ["Delete the saved radio setup '%1'?", _name],
    "TFAR Persistence",
    true,
    true
] call BIS_fnc_guiMessage;
if (!_confirmed) exitWith { false };

private _index = _profiles findIf {(_x param [0, ""]) isEqualTo _name};
if (_index < 0) exitWith { false };

_profiles deleteAt _index;
if (toLowerANSI _activeName isEqualTo toLowerANSI _name) then {
    private _newActive = _profiles select 0;
    _store set [1, _newActive param [0, "Default"]];
};
_store set [2, _profiles];
[_store] call TFARP_fnc_writeStore;
call TFARP_fnc_refreshPresetDialog;
[format ["Setup '%1' deleted", _name]] call TFARP_fnc_notify;
true

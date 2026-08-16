disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith {};

private _list = _display displayCtrl 9501;
private _previousName = _list lbData (lbCurSel _list);
lbClear _list;

(call TFARP_fnc_loadStore) params ["", ["_activeName", "Default", [""]], ["_profiles", [], [[]]]];

{
    _x params [["_name", "", [""]], ["_snapshot", [], [[]]]];
    private _isActive = toLowerANSI _name isEqualTo toLowerANSI _activeName;
    private _row = _list lbAdd format ["%1%2", _name, ["", " (Active)"] select _isActive];
    _list lbSetData [_row, _name];
    _list lbSetTooltip [_row, [_snapshot] call TFARP_fnc_buildProfileTooltip];
    if (_isActive) then {
        _list lbSetColor [_row, [0.968627, 0.956863, 0.666667, 1]];
        _list lbSetSelectColor [_row, [0, 0, 0, 1]];
    };
} forEach _profiles;

private _selection = 0;
if (_previousName isNotEqualTo "") then {
    private _found = _profiles findIf {(_x param [0, ""]) isEqualTo _previousName};
    if (_found >= 0) then { _selection = _found; };
};

if ((lbSize _list) > 0) then {
    _list lbSetCurSel _selection;
};

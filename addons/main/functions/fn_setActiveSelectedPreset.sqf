disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { false };

private _list = _display displayCtrl 9501;
private _name = _list lbData (lbCurSel _list);
if (_name isEqualTo "") exitWith { false };

[_name] call TFARP_fnc_restoreNamedPreset

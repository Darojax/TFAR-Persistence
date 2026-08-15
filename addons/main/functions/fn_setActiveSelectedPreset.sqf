disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { false };

private _list = _display displayCtrl 9501;
private _name = _list lbData (lbCurSel _list);
if (_name isEqualTo "") exitWith { false };

private _confirmed = [
    format ["Set '%1' as the active profile and restore its settings to the radios you are currently carrying?", _name],
    "TFAR Persistence",
    true,
    true
] call BIS_fnc_guiMessage;

if (!_confirmed) exitWith { false };
[_name] call TFARP_fnc_restoreNamedPreset

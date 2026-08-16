params [
    ["_mode", "save", [""]]
];

private _initialName = "";
if (_mode isEqualTo "rename") then {
    disableSerialization;
    private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
    if (isNull _display) exitWith { false };

    private _list = _display displayCtrl 9501;
    _initialName = _list lbData (lbCurSel _list);
    if (_initialName isEqualTo "") exitWith { false };
};

uiNamespace setVariable ["TFARP_nameDialogMode", _mode];
uiNamespace setVariable ["TFARP_nameDialogOriginal", _initialName];
private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { false };

private _prompt = _display displayCtrl 9512;
private _edit = _display displayCtrl 9511;
private _submit = _display displayCtrl 9513;

if (_mode isEqualTo "rename") then {
    _prompt ctrlSetText "Enter a new profile name";
    _submit ctrlSetText "Rename";
} else {
    _prompt ctrlSetText "Save current radio settings as";
    _submit ctrlSetText "Save";
};

_edit ctrlSetText _initialName;
{(_display displayCtrl _x) ctrlEnable false} forEach [9501, 9504, 9506, 9507, 9508, 9509];
{(_display displayCtrl _x) ctrlShow true} forEach [9511, 9512, 9513, 9514, 9515, 9516, 9517];
ctrlSetFocus _edit;
true

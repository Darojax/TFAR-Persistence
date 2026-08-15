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
private _parent = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _parent) exitWith { false };
!isNull (_parent createDisplay "TFARP_RscNameDialog")

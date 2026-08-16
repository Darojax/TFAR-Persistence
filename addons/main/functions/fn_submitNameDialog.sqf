disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { false };

private _name = ctrlText (_display displayCtrl 9511);
private _mode = uiNamespace getVariable ["TFARP_nameDialogMode", "save"];
private _success = if (_mode isEqualTo "rename") then {
    private _original = uiNamespace getVariable ["TFARP_nameDialogOriginal", ""];
    [_original, _name] call TFARP_fnc_renameSelectedPreset
} else {
    [_name] call TFARP_fnc_saveNamedPreset
};

if (_success) then {
    call TFARP_fnc_closeNameDialog;
};
_success

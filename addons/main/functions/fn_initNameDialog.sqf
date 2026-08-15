disableSerialization;

private _display = uiNamespace getVariable ["TFARP_nameDisplay", displayNull];
if (isNull _display) exitWith {};

private _mode = uiNamespace getVariable ["TFARP_nameDialogMode", "save"];
private _initialName = uiNamespace getVariable ["TFARP_nameDialogOriginal", ""];
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
ctrlSetFocus _edit;

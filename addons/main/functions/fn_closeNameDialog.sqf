disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith { false };

{(_display displayCtrl _x) ctrlShow false} forEach [9511, 9512, 9513, 9514, 9515, 9516, 9517];
{(_display displayCtrl _x) ctrlEnable true} forEach [9501, 9504, 9506, 9507, 9508, 9509];
(_display displayCtrl 9511) ctrlSetText "";
ctrlSetFocus (_display displayCtrl 9501);
true

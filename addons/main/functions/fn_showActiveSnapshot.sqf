(call TFARP_fnc_getActiveProfile) params ["_available", "_name", "_snapshot"];
if (!_available) exitWith {
    [format ["Profile '%1' has no saved radio settings", _name]] call TFARP_fnc_notify;
    false
};
[_snapshot, _name] call TFARP_fnc_showSnapshot

(call TFARP_fnc_getActiveProfile) params ["_available", "_name"];
if (!_available) exitWith {
    [format ["Profile '%1' has no saved radio settings", _name]] call TFARP_fnc_notify;
    false
};

private _confirmed = [
    format ["Restore '%1' to the radios you are currently carrying?", _name],
    "TFAR Persistence",
    true,
    true
] call BIS_fnc_guiMessage;
if (!_confirmed) exitWith { false };

[true] call TFARP_fnc_restoreSaved

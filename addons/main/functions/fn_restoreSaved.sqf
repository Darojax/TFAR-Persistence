params [
    ["_showNotification", false, [false]]
];

(call TFARP_fnc_getActiveProfile) params ["_available", "_name", "_snapshot"];
if (!_available) exitWith {
    if (_showNotification) then {
        [format ["Profile '%1' has no saved radio settings", _name]] call TFARP_fnc_notify;
    };
    false
};

[_snapshot, _showNotification] call TFARP_fnc_queueRestore

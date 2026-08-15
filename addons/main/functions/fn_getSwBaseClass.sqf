params [
    ["_radio", "", [""]]
];

if (_radio isEqualTo "") exitWith { "" };

[_radio, "tf_parent", _radio] call TFAR_fnc_getWeaponConfigProperty


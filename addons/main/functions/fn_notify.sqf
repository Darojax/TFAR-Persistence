params [
    ["_message", "", [""]]
];

if (missionNamespace getVariable ["TFARP_notifications", true]) then {
    systemChat format ["[TFAR Radio Settings Save & Restore] %1", _message];
};

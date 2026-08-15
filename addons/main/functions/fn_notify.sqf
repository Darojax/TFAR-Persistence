params [
    ["_message", "", [""]]
];

if (missionNamespace getVariable ["TFARP_notifications", true]) then {
    systemChat format ["[TFAR Persistence] %1", _message];
};


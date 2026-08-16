[
    "TFARP_persistFrequencies",
    "CHECKBOX",
    ["Persist channel frequencies", "Disable this if the mission or server owns the frequency plan."],
    "TFAR Persistence",
    true,
    false
] call CBA_fnc_addSetting;

[
    "TFARP_notifications",
    "CHECKBOX",
    ["Show notifications", "Show informational, warning, and error messages from TFAR Persistence."],
    "TFAR Persistence",
    true,
    false
] call CBA_fnc_addSetting;

TFARP_restoring = false;

[
    "TFARP_persistFrequencies",
    "CHECKBOX",
    ["Persist channel frequencies", "Disable this if the mission or server owns the frequency plan."],
    "TFAR Radio Settings Save & Restore",
    true,
    false
] call CBA_fnc_addSetting;

[
    "TFARP_notifications",
    "CHECKBOX",
    ["Show notifications", "Show informational, warning, and error messages from TFAR Radio Settings Save & Restore."],
    "TFAR Radio Settings Save & Restore",
    true,
    false
] call CBA_fnc_addSetting;

TFARP_restoring = false;

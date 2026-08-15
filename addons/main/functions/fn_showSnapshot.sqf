params [
    ["_snapshot", [], [[]]],
    ["_label", "Saved Radio Settings", [""]]
];

if (_snapshot isEqualTo [] || {(_snapshot param [0, 0]) isNotEqualTo 1}) exitWith {
    ["Saved radio settings are unavailable"] call TFARP_fnc_notify;
    false
};

private _entries = (_snapshot param [2, []]) apply {["SW", _x]};
_entries append ((_snapshot param [3, []]) apply {["LR", _x]});

if (_entries isEqualTo []) exitWith {
    ["The saved setup contains no supported radios"] call TFARP_fnc_notify;
    false
};

private _notification = [[toUpperANSI _label, 1.2]];

{
    _x params ["_kind", "_entry"];
    _entry params [
        "_base",
        "_occurrence",
        "_isActive",
        "_channel",
        "_volume",
        "_frequencies",
        "_stereo",
        "_additionalChannel"
    ];

    private _displayName = if (_kind isEqualTo "SW") then {
        getText (configFile >> "CfgWeapons" >> _base >> "displayName")
    } else {
        getText (configFile >> "CfgVehicles" >> _base >> "displayName")
    };
    if (_displayName isEqualTo "") then { _displayName = _base; };

    private _ear = ["Both Ears", "Left Ear", "Right Ear"] param [_stereo, "Unknown"];
    private _frequency = _frequencies param [_channel, "?"];
    private _additional = if (_additionalChannel >= 0) then {
        private _additionalVolume = _entry param [10, _volume];
        format [" | Additional Ch %1 Vol %2%3", _additionalChannel + 1, (_additionalVolume + 1) * 10, "%"]
    } else {
        ""
    };
    private _active = ["", " | Active"] select _isActive;
    private _ordinal = if (_occurrence > 0) then {format [" #%1", _occurrence + 1]} else {""};

    _notification pushBack [format [
        "%1%2: Ch %3 (%4 MHz) | Vol %5%6 | %7%8%9",
        _displayName,
        _ordinal,
        _channel + 1,
        _frequency,
        (_volume + 1) * 10,
        "%",
        _ear,
        _additional,
        _active
    ]];
} forEach _entries;

[
    {
        isNil "cba_ui_notifyQueue" || {cba_ui_notifyQueue isEqualTo []}
    },
    {
        params ["_notification"];
        private _normalLifetime = missionNamespace getVariable ["cba_ui_notifyLifetime", 4];
        cba_ui_notifyLifetime = 10;
        _notification call CBA_fnc_notify;
        cba_ui_notifyLifetime = _normalLifetime;
    },
    [_notification]
] call CBA_fnc_waitUntilAndExecute;
true

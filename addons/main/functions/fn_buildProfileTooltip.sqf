params [
    ["_snapshot", [], [[]]]
];

private _entries = (_snapshot param [2, []]) apply {["SW", _x]};
_entries append ((_snapshot param [3, []]) apply {["LR", _x]});
if (_entries isEqualTo []) exitWith {"No supported radio settings saved"};

private _lines = [];
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
        "_additionalChannel",
        "_additionalStereo",
        "_speakers"
    ];

    private _displayName = if (_kind isEqualTo "SW") then {
        getText (configFile >> "CfgWeapons" >> _base >> "displayName")
    } else {
        getText (configFile >> "CfgVehicles" >> _base >> "displayName")
    };
    if (_displayName isEqualTo "") then {_displayName = _base};

    private _ordinal = if (_occurrence > 0) then {format [" #%1", _occurrence + 1]} else {""};
    private _mainStereo = ["Both", "Left", "Right"] param [_stereo, "?"];
    private _additional = "Alt Off";
    if (_additionalChannel >= 0) then {
        private _additionalVolume = _entry param [10, _volume];
        private _additionalEar = ["Both", "Left", "Right"] param [_additionalStereo, "?"];
        _additional = format [
            "Alt Ch %1 %2 MHz %3%4 %5",
            _additionalChannel + 1,
            _frequencies param [_additionalChannel, "?"],
            (_additionalVolume + 1) * 10,
            "%",
            _additionalEar
        ];
    };

    _lines pushBack format [
        "%1%2 [%3] | Main Ch %4 %5 MHz %6%7 %8 | %9 | Spk %10%11",
        _displayName,
        _ordinal,
        _kind,
        _channel + 1,
        _frequencies param [_channel, "?"],
        (_volume + 1) * 10,
        "%",
        _mainStereo,
        _additional,
        ["Off", "On"] select _speakers,
        ["", " | Active radio"] select _isActive
    ];
} forEach _entries;

_lines joinString (toString [10])

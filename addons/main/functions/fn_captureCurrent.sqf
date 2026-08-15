if (!hasInterface) exitWith { [] };

params [
    ["_unit", missionNamespace getVariable ["TFAR_currentUnit", player], [objNull]]
];
if (isNull _unit) exitWith { [] };

private _swEntries = [];
private _swBases = [];
private _swCounts = [];
private _activeSw = call TFAR_fnc_activeSwRadio;

{
    private _radio = _x;
    private _base = _radio call TFARP_fnc_getSwBaseClass;
    private _baseIndex = _swBases find _base;
    private _occurrence = 0;

    if (_baseIndex < 0) then {
        _swBases pushBack _base;
        _swCounts pushBack 1;
    } else {
        _occurrence = _swCounts select _baseIndex;
        _swCounts set [_baseIndex, _occurrence + 1];
    };

    private _settings = _radio call TFAR_fnc_getSwSettings;
    private _volume = _radio call TFAR_fnc_getSwVolume;
    private _frequencyCount = count (_settings param [2, []]);
    private _frequencies = [];
    for "_channel" from 1 to _frequencyCount do {
        _frequencies pushBack ([_radio, _channel] call TFAR_fnc_getChannelFrequency);
    };

    _swEntries pushBack [
        _base,
        _occurrence,
        _radio isEqualTo _activeSw,
        _radio call TFAR_fnc_getSwChannel,
        _volume,
        _frequencies,
        _radio call TFAR_fnc_getSwStereo,
        _radio call TFAR_fnc_getAdditionalSwChannel,
        _radio call TFAR_fnc_getAdditionalSwStereo,
        _radio call TFAR_fnc_getSwSpeakers,
        if (isNil "TFAR_fnc_getAdditionalSwVolume") then {_volume} else {_radio call TFAR_fnc_getAdditionalSwVolume}
    ];
} forEach (_unit call TFAR_fnc_radiosList);

private _lrEntries = [];
private _backpack = unitBackpack _unit;
private _activeLr = call TFAR_fnc_activeLrRadio;

if (!isNull _backpack) then {
    {
        private _radio = _x;
        if ((_radio param [0, objNull]) isEqualTo _backpack) then {
            private _settings = _radio call TFAR_fnc_getLrSettings;
            private _volume = _radio call TFAR_fnc_getLrVolume;
            private _frequencyCount = count (_settings param [2, []]);
            private _frequencies = [];
            for "_channel" from 1 to _frequencyCount do {
                _frequencies pushBack ([_radio, _channel] call TFAR_fnc_getChannelFrequency);
            };

            _lrEntries pushBack [
                typeOf _backpack,
                0,
                _radio isEqualTo _activeLr,
                _radio call TFAR_fnc_getLrChannel,
                _volume,
                _frequencies,
                _radio call TFAR_fnc_getLrStereo,
                _radio call TFAR_fnc_getAdditionalLrChannel,
                _radio call TFAR_fnc_getAdditionalLrStereo,
                _radio call TFAR_fnc_getLrSpeakers,
                if (isNil "TFAR_fnc_getAdditionalLrVolume") then {_volume} else {_radio call TFAR_fnc_getAdditionalLrVolume}
            ];
        };
    } forEach (_unit call TFAR_fnc_lrRadiosList);
};

[
    1,
    systemTimeUTC,
    _swEntries,
    _lrEntries
]

params [
    ["_snapshot", [], [[]]],
    ["_alreadyApplied", [], [[]]]
];

if (!hasInterface || {_snapshot isEqualTo []}) exitWith { [] };

_snapshot params [
    ["_version", 0, [0]],
    ["_savedAt", [], [[]]],
    ["_swEntries", [], [[]]],
    ["_lrEntries", [], [[]]]
];

if (_version isNotEqualTo 1) exitWith { [] };

private _unit = missionNamespace getVariable ["TFAR_currentUnit", player];
if (isNull _unit) exitWith { [] };

TFARP_restoring = true;
private _newlyApplied = [];
private _swBases = [];
private _swCounts = [];
private _activeSwToRestore = "";

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

    private _key = format ["S|%1|%2", _base, _occurrence];
    if !(_key in _alreadyApplied) then {
        private _entryIndex = _swEntries findIf {
            (_x param [0, ""]) isEqualTo _base && {(_x param [1, -1]) isEqualTo _occurrence}
        };

        if (_entryIndex >= 0) then {
            (_swEntries select _entryIndex) params [
                "_savedBase",
                "_savedOccurrence",
                "_isActive",
                "_channel",
                "_volume",
                "_frequencies",
                "_stereo",
                "_additionalChannel",
                "_additionalStereo",
                "_speakers"
            ];
            private _additionalVolume = (_swEntries select _entryIndex) param [10, _volume];

            [_radio, _channel] call TFAR_fnc_setSwChannel;
            [_radio, _volume] call TFAR_fnc_setSwVolume;

            private _currentAdditional = _radio call TFAR_fnc_getAdditionalSwChannel;
            if (_currentAdditional >= 0) then {
                [_radio, _currentAdditional] call TFAR_fnc_setAdditionalSwChannel;
            };
            [_radio, _stereo] call TFAR_fnc_setSwStereo;
            if (_additionalChannel >= 0) then {
                [_radio, _additionalChannel] call TFAR_fnc_setAdditionalSwChannel;
                if !(isNil "TFAR_fnc_setAdditionalSwVolume") then {
                    [_radio, _additionalVolume] call TFAR_fnc_setAdditionalSwVolume;
                };
            };
            [_radio, _additionalStereo] call TFAR_fnc_setAdditionalSwStereo;

            if ((_radio call TFAR_fnc_getSwSpeakers) isNotEqualTo _speakers) then {
                [_radio] call TFAR_fnc_setSwSpeakers;
            };

            if (missionNamespace getVariable ["TFARP_persistFrequencies", true]) then {
                {
                    [_radio, _forEachIndex + 1, _x] call TFAR_fnc_setChannelFrequency;
                } forEach _frequencies;
            };

            if (_isActive) then { _activeSwToRestore = _radio; };
            _newlyApplied pushBack _key;
        };
    };
} forEach (_unit call TFAR_fnc_radiosList);

if (_activeSwToRestore isNotEqualTo "") then {
    _activeSwToRestore call TFAR_fnc_setActiveSwRadio;
};

private _backpack = unitBackpack _unit;
private _activeLrToRestore = [];

if (!isNull _backpack) then {
    {
        private _radio = _x;
        if ((_radio param [0, objNull]) isEqualTo _backpack) then {
            private _base = typeOf _backpack;
            private _key = format ["L|%1|0", _base];

            if !(_key in _alreadyApplied) then {
                private _entryIndex = _lrEntries findIf {(_x param [0, ""]) isEqualTo _base};

                if (_entryIndex >= 0) then {
                    (_lrEntries select _entryIndex) params [
                        "_savedBase",
                        "_savedOccurrence",
                        "_isActive",
                        "_channel",
                        "_volume",
                        "_frequencies",
                        "_stereo",
                        "_additionalChannel",
                        "_additionalStereo",
                        "_speakers"
                    ];
                    private _additionalVolume = (_lrEntries select _entryIndex) param [10, _volume];

                    [_radio, _channel] call TFAR_fnc_setLrChannel;
                    [_radio, _volume] call TFAR_fnc_setLrVolume;

                    private _currentAdditional = _radio call TFAR_fnc_getAdditionalLrChannel;
                    if (_currentAdditional >= 0) then {
                        [_radio, _currentAdditional] call TFAR_fnc_setAdditionalLrChannel;
                    };
                    [_radio, _stereo] call TFAR_fnc_setLrStereo;
                    if (_additionalChannel >= 0) then {
                        [_radio, _additionalChannel] call TFAR_fnc_setAdditionalLrChannel;
                        if !(isNil "TFAR_fnc_setAdditionalLrVolume") then {
                            [_radio, _additionalVolume] call TFAR_fnc_setAdditionalLrVolume;
                        };
                    };
                    [_radio, _additionalStereo] call TFAR_fnc_setAdditionalLrStereo;

                    if ((_radio call TFAR_fnc_getLrSpeakers) isNotEqualTo _speakers) then {
                        _radio call TFAR_fnc_setLrSpeakers;
                    };

                    if (missionNamespace getVariable ["TFARP_persistFrequencies", true]) then {
                        {
                            [_radio, _forEachIndex + 1, _x] call TFAR_fnc_setChannelFrequency;
                        } forEach _frequencies;
                    };

                    if (_isActive) then { _activeLrToRestore = _radio; };
                    _newlyApplied pushBack _key;
                };
            };
        };
    } forEach (_unit call TFAR_fnc_lrRadiosList);
};

if (_activeLrToRestore isNotEqualTo []) then {
    _activeLrToRestore call TFAR_fnc_setActiveLrRadio;
};

TFARP_restoring = false;
_newlyApplied

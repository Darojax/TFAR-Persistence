params [
    ["_snapshot", [], [[]]]
];

if (
    !hasInterface ||
    {_snapshot isEqualTo []} ||
    {!(missionNamespace getVariable ["TFARP_testFailNextRespawn", false])}
) exitWith { 0 };

private _unit = missionNamespace getVariable ["TFAR_currentUnit", player];
if (isNull _unit) exitWith { 0 };

private _savedSw = _snapshot param [2, []];
private _savedLr = _snapshot param [3, []];
private _changed = 0;
private _swBases = [];
private _swCounts = [];

// Public TFAR setters fire the same events as genuine player input. Mark this
// short mutation as internal so the respawn guard does not cancel its own test.
TFARP_restoring = true;

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

    private _savedIndex = _savedSw findIf {
        (_x param [0, ""]) isEqualTo _base && {(_x param [1, -1]) isEqualTo _occurrence}
    };

    if (_savedIndex >= 0) then {
        private _savedVolume = (_savedSw select _savedIndex) param [4, 0];
        private _testVolume = [0, 10] select (_savedVolume <= 0);
        [_radio, _testVolume] call TFAR_fnc_setSwVolume;
        _changed = _changed + 1;
    };
} forEach (_unit call TFAR_fnc_radiosList);

private _backpack = unitBackpack _unit;
if (!isNull _backpack) then {
    {
        private _radio = _x;
        private _base = typeOf _backpack;
        private _savedIndex = _savedLr findIf {(_x param [0, ""]) isEqualTo _base};
        if ((_radio param [0, objNull]) isEqualTo _backpack && {_savedIndex >= 0}) then {
            private _savedVolume = (_savedLr select _savedIndex) param [4, 0];
            private _testVolume = [0, 10] select (_savedVolume <= 0);
            [_radio, _testVolume] call TFAR_fnc_setLrVolume;
            _changed = _changed + 1;
        };
    } forEach (_unit call TFAR_fnc_lrRadiosList);
};

TFARP_restoring = false;

if (_changed > 0) then {
    TFARP_testFailNextRespawn = false;
    [format [
        "TEST: simulated failed TFAR restoration on %1 radio(s); recovery verification is now running",
        _changed
    ]] call TFARP_fnc_notify;
};

_changed

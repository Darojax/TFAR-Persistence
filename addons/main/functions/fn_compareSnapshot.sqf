params [
    ["_snapshot", [], [[]]]
];

if (_snapshot isEqualTo [] || {(_snapshot param [0, 0]) isNotEqualTo 1}) exitWith {[[], [], 0, 0]};

private _current = [player] call TFARP_fnc_captureCurrent;
private _savedSw = _snapshot param [2, []];
private _savedLr = _snapshot param [3, []];
private _currentSw = _current param [2, []];
private _currentLr = _current param [3, []];
private _compareFrequencies = missionNamespace getVariable ["TFARP_persistFrequencies", true];
private _matching = [];
private _mismatching = [];
private _matched = 0;

private _entriesMatch = {
    params ["_saved", "_live", "_compareFrequencies"];
    private _same = true;
    {
        if ((_saved select _x) isNotEqualTo (_live select _x)) exitWith { _same = false; };
    } forEach [2, 3, 4, 6, 7, 8, 9];
    if (_same && {_compareFrequencies}) then {
        _same = (_saved param [5, []]) isEqualTo (_live param [5, []]);
    };
    if (_same) then {
        _same = (_saved param [10, _saved param [4, 0]]) isEqualTo (_live param [10, _live param [4, 0]]);
    };
    _same
};

{
    private _saved = _x;
    private _base = _saved param [0, ""];
    private _occurrence = _saved param [1, -1];
    private _key = format ["S|%1|%2", _base, _occurrence];
    private _index = _currentSw findIf {
        (_x param [0, ""]) isEqualTo _base && {(_x param [1, -1]) isEqualTo _occurrence}
    };
    if (_index >= 0) then {
        _matched = _matched + 1;
        if ([_saved, _currentSw select _index, _compareFrequencies] call _entriesMatch) then {
            _matching pushBack _key;
        } else {
            _mismatching pushBack _key;
        };
    };
} forEach _savedSw;

{
    private _saved = _x;
    private _base = _saved param [0, ""];
    private _occurrence = _saved param [1, 0];
    private _key = format ["L|%1|%2", _base, _occurrence];
    private _index = _currentLr findIf {
        (_x param [0, ""]) isEqualTo _base && {(_x param [1, 0]) isEqualTo _occurrence}
    };
    if (_index >= 0) then {
        _matched = _matched + 1;
        if ([_saved, _currentLr select _index, _compareFrequencies] call _entriesMatch) then {
            _matching pushBack _key;
        } else {
            _mismatching pushBack _key;
        };
    };
} forEach _savedLr;

[_matching, _mismatching, _matched, count _savedSw + count _savedLr]

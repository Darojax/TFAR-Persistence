if (!hasInterface) exitWith { false };

private _snapshot = missionNamespace getVariable ["TFARP_respawnSnapshot", []];
if (_snapshot isEqualTo []) exitWith {
    ["TEST FAIL: no pre-death respawn snapshot is available"] call TFARP_fnc_notify;
    false
};

([_snapshot] call TFARP_fnc_compareSnapshot) params ["_matching", "_mismatching", "_matched", "_total"];
if (_matched < _total) exitWith {
    [format [
        "TEST BLOCKED: only %1 of %2 saved radios are currently available",
        _matched,
        _total
    ]] call TFARP_fnc_notify;
    false
};

if (_mismatching isEqualTo []) exitWith {
    ["TEST BLOCKED: the carried radios already match the pre-death snapshot"] call TFARP_fnc_notify;
    false
};

private _restored = [_snapshot, _matching] call TFARP_fnc_restoreSnapshot;
private _verification = [_snapshot] call TFARP_fnc_compareSnapshot;
private _remainingMismatches = _verification param [1, []];
private _verified = _verification param [2, 0];
private _verifyTotal = _verification param [3, 0];

if (
    _restored isNotEqualTo [] &&
    {_verified isEqualTo _verifyTotal} &&
    {_remainingMismatches isEqualTo []}
) exitWith {
    [format [
        "TEST PASS: TFAR Persistence restored and verified %1 radio(s)",
        count _restored
    ]] call TFARP_fnc_notify;
    true
};

[format [
    "TEST FAIL: %1 radio(s) remain incorrect after TFAR Persistence restoration",
    count _remainingMismatches
]] call TFARP_fnc_notify;
false

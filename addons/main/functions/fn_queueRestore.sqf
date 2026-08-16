params [
    ["_snapshot", [], [[]]],
    ["_showNotification", false, [false]]
];

if (_snapshot isEqualTo [] || {(_snapshot param [0, 0]) isNotEqualTo 1}) exitWith { false };

private _restored = [_snapshot, []] call TFARP_fnc_restoreSnapshot;
private _configured = count _restored;
private _total = count (_snapshot param [2, []]) + count (_snapshot param [3, []]);

if (_showNotification) then {
    if (_configured <= 0) then {
        ["No currently carried radios matched this profile"] call TFARP_fnc_notify;
    } else {
        if (_configured < _total) then {
            [format [
                "Restored %1 of %2 saved radios; missing radios were left unchanged",
                _configured,
                _total
            ]] call TFARP_fnc_notify;
        };
    };
};

call TFARP_fnc_refreshPresetDialog;
true

params [
    ["_name", "", [""]]
];

private _store = call TFARP_fnc_loadStore;
_store params ["", "", ["_profiles", [], [[]]]];
private _index = _profiles findIf {(_x param [0, ""]) isEqualTo _name};
if (_index < 0) exitWith {
    [format ["Named setup '%1' was not found", _name]] call TFARP_fnc_notify;
    false
};

_store set [1, _name];
[_store] call TFARP_fnc_writeStore;
[(_profiles select _index) param [1, []], true] call TFARP_fnc_queueRestore

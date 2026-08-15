private _store = call TFARP_fnc_loadStore;
_store params ["", ["_activeName", "Default", [""]], ["_profiles", [], [[]]]];

private _index = _profiles findIf {toLowerANSI (_x param [0, ""]) isEqualTo toLowerANSI _activeName};
if (_index < 0) then {
    _index = 0;
    if (_profiles isNotEqualTo []) then {
        _activeName = (_profiles select 0) param [0, "Default"];
    };
};

if (_index < 0) exitWith { [false, "Default", []] };

private _profile = _profiles select _index;
private _snapshot = _profile param [1, []];
[_snapshot isNotEqualTo [], _profile param [0, _activeName], _snapshot]

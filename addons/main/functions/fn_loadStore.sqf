private _store = profileNamespace getVariable ["TFARP_store_v3", []];
private _profiles = [];
private _activeName = "Default";

if (_store isEqualType [] && {(_store param [0, 0]) isEqualTo 3}) then {
    _activeName = _store param [1, "Default"];
    _profiles = +(_store param [2, []]);
} else {
    private _v2Store = profileNamespace getVariable ["TFARP_store_v2", []];
    if (_v2Store isEqualType [] && {(_v2Store param [0, 0]) isEqualTo 2}) then {
        private _legacySnapshotV2 = _v2Store param [1, []];
        _profiles = +(_v2Store param [2, []]);
        private _defaultIndex = _profiles findIf {toLowerANSI (_x param [0, ""]) isEqualTo "default"};

        if (_defaultIndex < 0) then {
            _profiles insert [0, [["Default", _legacySnapshotV2]]];
        } else {
            private _existingDefault = _profiles select _defaultIndex;
            if ((_existingDefault param [1, []]) isEqualTo [] && {_legacySnapshotV2 isNotEqualTo []}) then {
                _profiles set [_defaultIndex, ["Default", _legacySnapshotV2]];
            };
        };
    } else {
        private _legacySnapshot = profileNamespace getVariable ["TFARP_savedSnapshot_v1", []];
        _profiles = [["Default", _legacySnapshot]];
    };
};

if (_profiles isEqualTo []) then {
    _profiles = [["Default", []]];
};

if (_profiles findIf {toLowerANSI (_x param [0, ""]) isEqualTo toLowerANSI _activeName} < 0) then {
    _activeName = (_profiles select 0) param [0, "Default"];
};

private _migrated = [3, _activeName, _profiles];
if (_migrated isNotEqualTo _store) then {
    profileNamespace setVariable ["TFARP_store_v3", _migrated];
    saveProfileNamespace;
};

+_migrated

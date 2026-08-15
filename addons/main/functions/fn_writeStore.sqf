params [
    ["_store", [], [[]]]
];

if ((_store param [0, 0]) isNotEqualTo 3) exitWith { false };

profileNamespace setVariable ["TFARP_store_v3", _store];
saveProfileNamespace;
true


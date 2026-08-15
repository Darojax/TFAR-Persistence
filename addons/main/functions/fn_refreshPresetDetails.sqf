disableSerialization;

private _display = uiNamespace getVariable ["TFARP_presetDisplay", displayNull];
if (isNull _display) exitWith {};

private _list = _display displayCtrl 9501;
private _details = _display displayCtrl 9503;
private _name = _list lbData (lbCurSel _list);

private _store = call TFARP_fnc_loadStore;
_store params ["", "", ["_profiles", [], [[]]]];
private _index = _profiles findIf {(_x param [0, ""]) isEqualTo _name};
if (_index < 0) exitWith {
    _details ctrlSetStructuredText parseText "<t color='#B8B8B8'>Select a profile to inspect its saved radio settings.</t>";
};

private _snapshot = (_profiles select _index) param [1, []];
private _entries = (_snapshot param [2, []]) apply {["SW", _x]};
_entries append ((_snapshot param [3, []]) apply {["LR", _x]});

if (_entries isEqualTo []) exitWith {
    _details ctrlSetStructuredText parseText "<t color='#B8B8B8'>No supported radio settings are saved in this profile.</t>";
};

private _lines = [];
{
    _x params ["_kind", "_entry"];
    _entry params [
        "_base",
        "_occurrence",
        "_isActive",
        "_channel",
        "_volume",
        "_frequencies",
        "_stereo",
        "_additionalChannel"
    ];

    private _displayName = if (_kind isEqualTo "SW") then {
        getText (configFile >> "CfgWeapons" >> _base >> "displayName")
    } else {
        getText (configFile >> "CfgVehicles" >> _base >> "displayName")
    };
    if (_displayName isEqualTo "") then { _displayName = _base; };

    private _ordinal = if (_occurrence > 0) then {format [" #%1", _occurrence + 1]} else {""};
    private _mainFrequency = _frequencies param [_channel, "?"];
    private _additional = if (_additionalChannel >= 0) then {
        private _additionalVolume = _entry param [10, _volume];
        format ["Alt Ch %1 (%2 MHz), Vol %3%4", _additionalChannel + 1, _frequencies param [_additionalChannel, "?"], (_additionalVolume + 1) * 10, "%"]
    } else {
        "Alt Off"
    };
    private _active = ["", " | Active radio"] select _isActive;

    _lines pushBack format [
        "<t color='#F7F4AA'>%1%2</t><br/><t color='#D8D8D8'>Main Ch %3 (%4 MHz) | %5 | Vol %6%7%8</t>",
        _displayName,
        _ordinal,
        _channel + 1,
        _mainFrequency,
        _additional,
        (_volume + 1) * 10,
        "%",
        _active
    ];
} forEach _entries;

_details ctrlSetStructuredText parseText (_lines joinString "<br/>");

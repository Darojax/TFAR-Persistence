class CfgPatches {
    class tfarp_main {
        name = "TFAR Persistence";
        author = "Darojax";
        url = "https://github.com/Darojax/TFAR-Persistence";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {
            "A3_UI_F",
            "ace_interact_menu",
            "cba_main",
            "tfar_core"
        };
        skipWhenMissingDependencies = 1;
    };
};

class CfgFunctions {
    class TFARP {
        tag = "TFARP";

        class Persistence {
            file = "\z\tfarp\addons\main\functions";

            class captureCurrent {};
            class confirmRestoreActive {};
            class deleteSelectedPreset {};
            class getActiveProfile {};
            class getSwBaseClass {};
            class initNameDialog {};
            class loadStore {};
            class notify {};
            class openNameDialog {};
            class openPresetDialog {};
            class postInit { postInit = 1; };
            class preInit { preInit = 1; };
            class queueRestore {};
            class refreshPresetDialog {};
            class refreshPresetDetails {};
            class restoreNamedPreset {};
            class restoreSaved {};
            class restoreSnapshot {};
            class saveCurrent {};
            class saveNamedPreset {};
            class renameSelectedPreset {};
            class setActiveSelectedPreset {};
            class showActiveSnapshot {};
            class showSnapshot {};
            class submitNameDialog {};
            class compareSnapshot {};
            class verifyRespawnRestore {};
            class writeStore {};
        };
    };
};

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class TFAR_Radio {
                class TFARP_RadioSettings {
                    displayName = "Settings";
                    condition = "true";

                    class TFARP_ShowActive {
                        displayName = "Show Currently Active Profile Settings";
                        condition = "(call TFARP_fnc_getActiveProfile) param [0, false]";
                        statement = "call TFARP_fnc_showActiveSnapshot";
                        modifierFunction = "params ['', '', '', '_actionData']; private _profile = call TFARP_fnc_getActiveProfile; _actionData set [1, format ['Show Currently Active Profile Settings (%1)', _profile param [1, 'Default']]]";
                    };

                    class TFARP_RestoreActive {
                        displayName = "<t color='#98d7ff'>Restore Settings</t>";
                        condition = "(call TFARP_fnc_getActiveProfile) param [0, false]";

                        class TFARP_ConfirmRestoreActive {
                            displayName = "<t color='#98d7ff'>Confirm</t>";
                            condition = "true";
                            statement = "[true] call TFARP_fnc_restoreSaved";
                        };
                    };

                    class TFARP_SaveActive {
                        displayName = "<t color='#ffa4a4'>Save Settings</t>";
                        condition = "(call TFAR_fnc_haveSWRadio) || (call TFAR_fnc_haveLRRadio)";

                        class TFARP_ConfirmSaveActive {
                            displayName = "<t color='#ffa4a4'>Confirm</t>";
                            condition = "true";
                            statement = "[true] call TFARP_fnc_saveCurrent";
                        };
                    };

                    class TFARP_ManageSetups {
                        displayName = "Manage Profiles";
                        condition = "true";
                        statement = "call TFARP_fnc_openPresetDialog";
                    };
                };
            };
        };
    };
};

class RscText;
class RscFrame;
class RscEdit;
class RscListbox;
class RscButton;
class RscStructuredText;

class TFARP_RscPresetDialog {
    idd = 9500;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['TFARP_presetDisplay', _this select 0]; call TFARP_fnc_refreshPresetDialog";
    onUnload = "uiNamespace setVariable ['TFARP_presetDisplay', displayNull]";

    class ControlsBackground {
        class Background: RscText {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.29";
            y = "safeZoneY + safeZoneH * 0.20";
            w = "safeZoneW * 0.42";
            h = "safeZoneH * 0.60";
            colorBackground[] = {0.05, 0.05, 0.05, 0.94};
        };
        class Frame: RscFrame {
            idc = -1;
            text = "TFAR Persistence - Profiles";
            x = "safeZoneX + safeZoneW * 0.30";
            y = "safeZoneY + safeZoneH * 0.22";
            w = "safeZoneW * 0.40";
            h = "safeZoneH * 0.56";
        };
    };

    class Controls {
        class PresetList: RscListbox {
            idc = 9501;
            x = "safeZoneX + safeZoneW * 0.315";
            y = "safeZoneY + safeZoneH * 0.27";
            w = "safeZoneW * 0.37";
            h = "safeZoneH * 0.25";
            onLBSelChanged = "call TFARP_fnc_refreshPresetDetails";
        };
        class PresetDetails: RscStructuredText {
            idc = 9503;
            x = "safeZoneX + safeZoneW * 0.315";
            y = "safeZoneY + safeZoneH * 0.535";
            w = "safeZoneW * 0.37";
            h = "safeZoneH * 0.13";
            colorBackground[] = {0.02, 0.02, 0.02, 0.65};
        };
        class SetActive: RscButton {
            idc = 9506;
            text = "Set active";
            x = "safeZoneX + safeZoneW * 0.315";
            y = "safeZoneY + safeZoneH * 0.70";
            w = "safeZoneW * 0.068";
            h = "safeZoneH * 0.04";
            action = "[] spawn TFARP_fnc_setActiveSelectedPreset";
        };
        class Save: RscButton {
            idc = 9504;
            text = "Create new";
            x = "safeZoneX + safeZoneW * 0.3905";
            y = "safeZoneY + safeZoneH * 0.70";
            w = "safeZoneW * 0.068";
            h = "safeZoneH * 0.04";
            action = "['save'] call TFARP_fnc_openNameDialog";
        };
        class Rename: RscButton {
            idc = 9507;
            text = "Rename";
            x = "safeZoneX + safeZoneW * 0.466";
            y = "safeZoneY + safeZoneH * 0.70";
            w = "safeZoneW * 0.068";
            h = "safeZoneH * 0.04";
            action = "['rename'] call TFARP_fnc_openNameDialog";
        };
        class Delete: RscButton {
            idc = 9508;
            text = "Delete";
            x = "safeZoneX + safeZoneW * 0.5415";
            y = "safeZoneY + safeZoneH * 0.70";
            w = "safeZoneW * 0.068";
            h = "safeZoneH * 0.04";
            action = "[] spawn TFARP_fnc_deleteSelectedPreset";
        };
        class Close: RscButton {
            idc = 9509;
            text = "Close";
            x = "safeZoneX + safeZoneW * 0.617";
            y = "safeZoneY + safeZoneH * 0.70";
            w = "safeZoneW * 0.068";
            h = "safeZoneH * 0.04";
            action = "closeDialog 0";
        };
    };
};

class TFARP_RscNameDialog {
    idd = 9510;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['TFARP_nameDisplay', _this select 0]; call TFARP_fnc_initNameDialog";
    onUnload = "uiNamespace setVariable ['TFARP_nameDisplay', displayNull]";

    class ControlsBackground {
        class Background: RscText {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.36";
            y = "safeZoneY + safeZoneH * 0.36";
            w = "safeZoneW * 0.28";
            h = "safeZoneH * 0.22";
            colorBackground[] = {0.05, 0.05, 0.05, 0.96};
        };
        class Frame: RscFrame {
            idc = -1;
            text = "TFAR Persistence";
            x = "safeZoneX + safeZoneW * 0.37";
            y = "safeZoneY + safeZoneH * 0.38";
            w = "safeZoneW * 0.26";
            h = "safeZoneH * 0.18";
        };
    };

    class Controls {
        class Prompt: RscText {
            idc = 9512;
            text = "Profile name";
            x = "safeZoneX + safeZoneW * 0.385";
            y = "safeZoneY + safeZoneH * 0.415";
            w = "safeZoneW * 0.23";
            h = "safeZoneH * 0.03";
        };
        class Name: RscEdit {
            idc = 9511;
            x = "safeZoneX + safeZoneW * 0.385";
            y = "safeZoneY + safeZoneH * 0.455";
            w = "safeZoneW * 0.23";
            h = "safeZoneH * 0.035";
        };
        class Submit: RscButton {
            idc = 9513;
            text = "Save";
            x = "safeZoneX + safeZoneW * 0.43";
            y = "safeZoneY + safeZoneH * 0.51";
            w = "safeZoneW * 0.065";
            h = "safeZoneH * 0.035";
            action = "call TFARP_fnc_submitNameDialog";
        };
        class Cancel: RscButton {
            idc = 9514;
            text = "Cancel";
            x = "safeZoneX + safeZoneW * 0.505";
            y = "safeZoneY + safeZoneH * 0.51";
            w = "safeZoneW * 0.065";
            h = "safeZoneH * 0.035";
            action = "private _display = uiNamespace getVariable ['TFARP_nameDisplay', displayNull]; if (!isNull _display) then {_display closeDisplay 2}";
        };
    };
};

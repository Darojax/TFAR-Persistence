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

            class armRespawnTest {};
            class armRespawnMismatchTest {};
            class captureCurrent {};
            class buildProfileTooltip {};
            class closeNameDialog {};
            class confirmRestoreActive {};
            class deleteSelectedPreset {};
            class getActiveProfile {};
            class getSwBaseClass {};
            class initNameDialog {};
            class injectRespawnTestFailure {};
            class loadStore {};
            class notify {};
            class openNameDialog {};
            class openPresetDialog {};
            class postInit { postInit = 1; };
            class preInit { preInit = 1; };
            class queueRestore {};
            class refreshPresetDialog {};
            class restoreNamedPreset {};
            class restoreSaved {};
            class restoreSnapshot {};
            class runRespawnRecoveryTest {};
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

class TFARP_RscPresetDialog {
    idd = 9500;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['TFARP_presetDisplay', _this select 0]; call TFARP_fnc_refreshPresetDialog; call TFARP_fnc_initNameDialog";
    onUnload = "uiNamespace setVariable ['TFARP_presetDisplay', displayNull]";
    onKeyDown = "if ((_this select 1) isEqualTo 1 && {ctrlShown ((_this select 0) displayCtrl 9511)}) then {call TFARP_fnc_closeNameDialog; true} else {false}";

    class ControlsBackground {
        class Background: RscText {
            idc = -1;
            x = "safeZoneX + safeZoneW * 0.34";
            y = "safeZoneY + safeZoneH * 0.27";
            w = "safeZoneW * 0.32";
            h = "safeZoneH * 0.46";
            colorBackground[] = {0.05, 0.05, 0.05, 0.94};
        };
        class Frame: RscFrame {
            idc = -1;
            text = "TFAR Persistence - Radio Profiles";
            x = "safeZoneX + safeZoneW * 0.35";
            y = "safeZoneY + safeZoneH * 0.29";
            w = "safeZoneW * 0.30";
            h = "safeZoneH * 0.42";
            sizeEx = "safeZoneH * 0.026";
        };
    };

    class Controls {
        class PresetList: RscListbox {
            idc = 9501;
            x = "safeZoneX + safeZoneW * 0.365";
            y = "safeZoneY + safeZoneH * 0.335";
            w = "safeZoneW * 0.27";
            h = "safeZoneH * 0.265";
            onLBDblClick = "call TFARP_fnc_setActiveSelectedPreset";
        };
        class SetActive: RscButton {
            idc = 9506;
            text = "Set active";
            x = "safeZoneX + safeZoneW * 0.365";
            y = "safeZoneY + safeZoneH * 0.635";
            w = "safeZoneW * 0.052";
            h = "safeZoneH * 0.035";
            action = "call TFARP_fnc_setActiveSelectedPreset";
        };
        class Save: RscButton {
            idc = 9504;
            text = "Create new";
            x = "safeZoneX + safeZoneW * 0.420";
            y = "safeZoneY + safeZoneH * 0.635";
            w = "safeZoneW * 0.055";
            h = "safeZoneH * 0.035";
            action = "['save'] call TFARP_fnc_openNameDialog";
        };
        class Rename: RscButton {
            idc = 9507;
            text = "Rename";
            x = "safeZoneX + safeZoneW * 0.478";
            y = "safeZoneY + safeZoneH * 0.635";
            w = "safeZoneW * 0.048";
            h = "safeZoneH * 0.035";
            action = "['rename'] call TFARP_fnc_openNameDialog";
        };
        class Delete: RscButton {
            idc = 9508;
            text = "Delete";
            x = "safeZoneX + safeZoneW * 0.529";
            y = "safeZoneY + safeZoneH * 0.635";
            w = "safeZoneW * 0.047";
            h = "safeZoneH * 0.035";
            action = "[] spawn TFARP_fnc_deleteSelectedPreset";
        };
        class Close: RscButton {
            idc = 9509;
            text = "Close";
            x = "safeZoneX + safeZoneW * 0.579";
            y = "safeZoneY + safeZoneH * 0.635";
            w = "safeZoneW * 0.047";
            h = "safeZoneH * 0.035";
            action = "closeDialog 0";
        };
        class NameDim: RscText {
            idc = 9515;
            x = "safeZoneX + safeZoneW * 0.34";
            y = "safeZoneY + safeZoneH * 0.27";
            w = "safeZoneW * 0.32";
            h = "safeZoneH * 0.46";
            colorBackground[] = {0, 0, 0, 0.55};
        };
        class NameBackground: RscText {
            idc = 9516;
            x = "safeZoneX + safeZoneW * 0.38";
            y = "safeZoneY + safeZoneH * 0.385";
            w = "safeZoneW * 0.24";
            h = "safeZoneH * 0.19";
            colorBackground[] = {0.05, 0.05, 0.05, 0.98};
        };
        class NameFrame: RscFrame {
            idc = 9517;
            text = "TFAR Persistence";
            x = "safeZoneX + safeZoneW * 0.39";
            y = "safeZoneY + safeZoneH * 0.40";
            w = "safeZoneW * 0.22";
            h = "safeZoneH * 0.16";
        };
        class Prompt: RscText {
            idc = 9512;
            text = "Profile name";
            x = "safeZoneX + safeZoneW * 0.402";
            y = "safeZoneY + safeZoneH * 0.425";
            w = "safeZoneW * 0.196";
            h = "safeZoneH * 0.025";
        };
        class Name: RscEdit {
            idc = 9511;
            x = "safeZoneX + safeZoneW * 0.402";
            y = "safeZoneY + safeZoneH * 0.462";
            w = "safeZoneW * 0.196";
            h = "safeZoneH * 0.035";
        };
        class Submit: RscButton {
            idc = 9513;
            text = "Save";
            x = "safeZoneX + safeZoneW * 0.43";
            y = "safeZoneY + safeZoneH * 0.515";
            w = "safeZoneW * 0.065";
            h = "safeZoneH * 0.03";
            action = "call TFARP_fnc_submitNameDialog";
        };
        class Cancel: RscButton {
            idc = 9514;
            text = "Cancel";
            x = "safeZoneX + safeZoneW * 0.505";
            y = "safeZoneY + safeZoneH * 0.515";
            w = "safeZoneW * 0.065";
            h = "safeZoneH * 0.03";
            action = "call TFARP_fnc_closeNameDialog";
        };
    };
};

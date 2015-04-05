/*
 * Author: Glowbal
 * Called from the onLoad of ACE_settingsMenu dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [onLoadEvent] call ACE_optionsmenu_fnc_onSettingsMenuOpen
 *
 * Public: No
 */

#include "script_component.hpp"

if (GVAR(serverConfigGeneration) == 0 || isMultiplayer) exitwith {closeDialog 145246;};

// Filter only user setable setting
GVAR(serverSideOptions) = [];
GVAR(serverSideColors) = [];
GVAR(serverSideValues) = [];
{
    _name = _x select 0;
    _typeName = _x select 1;
    _isClientSetable = _x select 2;
    _localizedName = _x select 3;
    _localizedDescription = _x select 4;
    _possibleValues = _x select 5;
    _defaultValue = _x select 6;

    // Exclude client side options if they are not included for the export
    if (!(_isClientSetable) || GVAR(ClientSettingsExportIncluded)) then {
        // Append the current value to the setting metadata
        _setting = + _x;
        _setting pushBack (missionNamespace getVariable (_x select 0));

        // Categorize the setting according to types
        // @todo: allow the user to modify other types of parameters?
        if ((_typeName == "SCALAR" && count _possibleValues > 0) || (_x select 1) == "BOOL") then {
            GVAR(serverSideOptions) pushBack _setting;
        };
        if (_typeName == "COLOR") then {
            GVAR(serverSideColors) pushBack _setting;
        };
        if ((_typeName == "SCALAR" && count _possibleValues == 0) || _typeName == "ARRAY" || _typeName == "STRING") then {
            GVAR(serverSideValues) pushBack _setting;
        };
    };
} forEach EGVAR(common,settings);

//Delay a frame
[{ [MENU_TAB_SERVER_OPTIONS] call FUNC(onServerListBoxShowSelectionChanged) }, []] call EFUNC(common,execNextFrame);

private "_menu";
disableSerialization;
_menu = uiNamespace getvariable "ACE_serverSettingsMenu";
(_menu displayCtrl 1003) ctrlEnable false;


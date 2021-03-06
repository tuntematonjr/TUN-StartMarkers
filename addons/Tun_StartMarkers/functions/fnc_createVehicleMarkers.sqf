﻿/*
 * Author: [Tuntematon]
 * [Description]
 * Create vehicle markers
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call Tun_startmarkers_fnc_createVehicleMarkers
 *
 * Public: [No]
 */
#include "script_component.hpp"


private _vehiclesToCreateMarkers = [];

//Delete old markers
if (count GVAR(VEHICLE_Markers) > 0) then {
    {
        (findDisplay GVAR(display)) displayCtrl 51 ctrlRemoveEventHandler ["Draw", _x];
    } forEach GVAR(VEHICLE_Markers);
    GVAR(VEHICLE_Markers) = [];
};


//Collect vehicles
{
    private _vehicle = _x;
    private _side = _vehicle getVariable [QGVAR(vehilce_side), sideLogic];

    ///check that side is defined
    if ( _side != sideLogic && {_vehicle getVariable [QGVAR(enable_marker), true]}) then {

        ///Show allied vehicles if needed
        if (GVAR(showFriendlyMarkers) && {playerSide != civilian}) then {
            if ([_side, playerSide] call BIS_fnc_sideIsFriendly) then {
               _vehiclesToCreateMarkers pushBack _vehicle;
            };
        } else {
            if (playerSide == _side && {_vehicle getVariable [QGVAR(enable_marker), true]}) then {
                _vehiclesToCreateMarkers pushBack _vehicle;
            };
        };
    };
} forEach vehicles;



{
    private _vehicle = _x;
    private _position = getPos _vehicle;
    private _direction = getDir _vehicle;
    private _classname = typeOf _vehicle;
    private _text = str" ";
    private _side = _vehicle getVariable QGVAR(vehilce_side);
    private _color = [_side, false] call BIS_fnc_sideColor;

    if (GVAR(vehicle_marker_text_status)) then {
        _text = str (_vehicle getVariable ["displayName", getText (configFile >> "CfgVehicles" >>  typeOf _vehicle >> "displayName")]);
    };

        _IDC = ((findDisplay GVAR(display)) displayCtrl 51) ctrlAddEventHandler ["Draw", format ['
                (_this select 0) drawIcon [
                getText (configFile >> "CfgVehicles" >> %1 >> "Icon"),
                %2,
                %3,
                30,
                30,
                %4,
                %5,
                2
                ];',
                str _classname,
                _color,
                _position,
                _direction,
                _text
                ]
            ];
     GVAR(VEHICLE_Markers) pushBack _IDC;

} forEach _vehiclesToCreateMarkers;

/*
function: XM8_VG_checkNearByFlags
file: XM8_VG\scripts\XM8_VG_checkNearByFlags.sqf

XM8 VG By Jan Babor
Part of the ExAd Virtual Garage script
*/
private ["_vehicles"];
_vehicles = nearestObjects [player,["Car","Air"],15];


if(vehicle player != player)exitWith{
	["Whoops", ["Get out of the vehicle first"]] call ExileClient_gui_notification_event_addNotification;
	["sideApps", 1] call ExileClient_gui_xm8_slide
};

if(count _vehicles == 0)exitWith{
	["Whoops", ["No vehicles nearby"]] call ExileClient_gui_notification_event_addNotification;
	["sideApps", 1] call ExileClient_gui_xm8_slide
};

if({local _x}count _vehicles == 0)exitWith{
	["Whoops", ["You need to get into the vehicle first"]] call ExileClient_gui_notification_event_addNotification;
	["sideApps", 1] call ExileClient_gui_xm8_slide
};

if({local _x && isArray(missionConfigFile >> "CfgExileArsenal" >> (typeOf _x) >> "upgradeTo")}count _vehicles > 0)then{
	["mainVUSlide", 0] call ExileClient_gui_xm8_slide;
	[_vehicles] call XM8_VU_loadContent;
} else {
	["Whoops", ["No upgradeable vehicles nearby"]] call ExileClient_gui_notification_event_addNotification;
	["sideApps", 1] call ExileClient_gui_xm8_slide
};
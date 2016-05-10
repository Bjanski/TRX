/*	
	XM8 VU app by Jan Babor
	
	file: XM8_VU\scripts\XM8_VU_init.sqf
	
	This script will be executed once, when player login. It is executed straight from initLocalPlayer.sqf.
	This is best place to compile functions, define global variables and read gonfiguration files used in app.
*/

params ["_pathToAppFolder"];

XM8_VG_mainVGSlideIDCmap = [];

{
	if (isNil _x) then {
		private ["_code"];
		_code = compileFinal (preprocessFileLineNumbers (format (["%1scripts\%2.sqf",_pathToAppFolder,_x])));
		if (isNil "_code") then {_code = compileFinal ""};
		missionNamespace setVariable [_x, _code];
	};
} forEach [
	"XM8_VU_mainVUSlide_onLoad",
	"XM8_VU_checkNearByVehicles",
	"XM8_VU_loadContent"
];

call compile preProcessFileLineNumbers format ["%1XM8_VU_config.sqf",_pathToAppFolder];
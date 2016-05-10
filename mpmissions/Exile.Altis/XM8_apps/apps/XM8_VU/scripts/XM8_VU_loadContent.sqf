/*
function: XM8_VG_loadContent
file: XM8_VG\scripts\XM8_VG_loadContent.sqf

XM8 VG by Jan Babor
Part of the ExAd Virtual Garage script
*/
params ["_vehicles","_display","_error","_slides","_getControl","_flag","_allowedVeh","_storedVeh","_strTxtVehCntColor","_strTxtVehCnt"];

_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (isNull _display) exitWith {_error = "Error loading XM8 VG app, display is null"; systemChat _error; diag_log _error;};
_slides = _display displayCtrl 4007;
if (isNull _slides) exitWith {_error = "Error loading XM8 VG app, slides control is null"; systemChat _error; diag_log _error;};

_getControl = {
	params ["_key"]; 
	private ["_ctrl","_idc","_index","_slideClassName"]; 
	_ctrl = controlNull;
	_slideClassName = "mainVUSlide"; //Classname of your slide
	_map = XM8_VU_mainVUSlideIDCmap; //Variable name of IDC map of slide
	_index = _map find _key;
	if (_index != -1) then {
		_idc = ((getNumber (missionConfigFile >> "CfgXM8" >> _slideClassName >> "controlID")) + _index);
		_ctrl = _display displayCtrl _idc;
	};
	_ctrl;
};

_upgradeVehList = [];

{
	if(local _x && isArray(missionConfigFile >> "CfgExileArsenal" >> (typeOf _x) >> "upgradeTo"))then{
		_upgradeVehList pushBack _x
	}
}forEach _vehicles;

[_upgradeVehList , ctrlIDC ("nearByVehList" call _getControl)] call XM8_VU_fillList;
lbClear ctrlIDC ("upgToList" call _getControl);

("InfoPic" call _getControl) ctrlSetText "";
("InfoVehStr" call _getControl) ctrlSetStructuredText parseText "<t></t>";
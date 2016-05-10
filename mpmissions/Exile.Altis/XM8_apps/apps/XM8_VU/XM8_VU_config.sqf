/*	
	XM8 VU app by Jan Babor
	
	file: XM8_VU\XM8_VU_config.sqf
	function: no function
	
	This is configuration file for VU app.
*/

XM8_VU_TOOLS = ["Exile_Item_Rope"];

XM8_VU_elChanged_Available = {
	params ["_listCtrl","_targetCtrl"];
	
	_ref = objectFromNetId (_listCtrl lbData (lbCurSel _listCtrl));
		
	if(isArray(missionConfigFile >> "CfgExileArsenal" >> typeOf _ref >> "upgradeTo"))then{
		_vehs = getArray(missionConfigFile >> "CfgExileArsenal" >> typeOf _ref >> "upgradeTo");
		[_vehs , _targetCtrl] call XM8_VU_fillList;
	};
	
	ExAd_VU_curVeh = _ref;
};

XM8_VU_elChanged_upgradeTo = {
	params ["_listCtrl","_picCtrl","_strCtrl","_btnCtrl","_vehClass","_pic","_recipeString","_recipe","_display"];
	
	_vehClass = _listCtrl lbData (lbCurSel _listCtrl);

	if!(isArray(missionConfigFile >> "CfgExileArsenal" >> _vehClass >> "recipe"))exitWith{false};
	
	_pic = getText(configFile >> "CfgVehicles" >> _vehClass >> "picture");
	ctrlSetText [_picCtrl, _pic];
	
	_recipeString = "";
	_recipe = getArray(missionConfigFile >> "CfgExileArsenal" >> _vehClass >> "recipe");
	{
		_color = if(count _x > 1)then {
			if!([player, _x] call XM8_VU_itemsInCargo) then {"#DF0101"}else{"#01DF01"}
		} else {
			if!([player, _x select 0] call ExileClient_util_playerEquipment_contains) then {"#DF0101"}else{"#01DF01"}
		};
		_recipeString = _recipeString + format["<br /><t size=1 color='%3'>%1x %2<br />    %4</t>",(if(count _x > 1)then{_x select 1}else{1}), (_x select 0) call XM8_VU_getDisplayName,_color,_x select 0];
	}forEach _recipe;
	
	_text = format["<t size='1.2'>%1</t>%2",_vehClass call XM8_VU_getDisplayName,_recipeString];
	_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
	(_display displayCtrl _strCtrl) ctrlSetStructuredText parseText _text;
	
	ctrlEnable [_btnCtrl,[_recipe] call XM8_VU_canUpgrade];
};

XM8_VU_fillList = {
	params ["_list","_idc","_vehClass","_data","_name","_pic"];
	
	lbClear _idc;
	{
		_vehClass = if(typeName _x == "OBJECT")then{typeOf _x}else{_x};
		_data = if(typeName _x == "OBJECT")then{netId _x}else{_x};
		
		_name = getText(configFile >> "CfgVehicles" >> _vehClass >> "displayName");
		_index = lbAdd[_idc,_name];
		_pic = getText(configFile >> "CfgVehicles" >> _vehClass >> "picture");
		lbSetPicture [_idc, _index, _pic];
		lbSetPictureColor [_idc, _index, [1,1,1,1]];
		lbSetData [_idc, _index, _data];
		lbSetTooltip [_idc, _index, _vehClass];
	}forEach _list;
};

XM8_VU_getDisplayName = {
	params ["_item","_cfg"];

	_cfg = _item;
	{
		if(isClass (configFile >> _x >> _item))then{
			_cfg = getText (configFile >> _x >> _item >> "displayName")
		};
	}forEach ["cfgVehicles","cfgWeapons","cfgMagazines"];
	_cfg

};

XM8_VU_itemsInCargo = {
	params ["_container","_itemArray"];

	_item = toLower (_itemArray select 0);
	_amount = _itemArray select 1;

	_response = false;
	{
		if(_item == toLower _x)then{
			_amount = _amount - 1;
		};
		if(_amount <= 0)exitWith{_response = true}
	}forEach (magazines player + weapons player);

	_response
};

XM8_VU_canUpgrade = {
	params ["_recipe"];
	
	_result = true;
	{
		if(count _x > 1)then
		{
			if!([player, _x] call XM8_VU_itemsInCargo) then {_result = false}
		} else {
			if!([player, _x select 0] call ExileClient_util_playerEquipment_contains) then {_result = false}
		}
	}forEach _recipe;
	
	_result
};

XM8_VU_startUpgrade = {
	params["_listCtrl"];
	
	_vehClass = lbData [_listCtrl, (lbCurSel _listCtrl)];
	if!(isArray(missionConfigFile >> "CfgExileArsenal" >> _vehClass >> "recipe") || isNil "ExAd_VU_curVeh")exitWith{false};
	_recipe = getArray(missionConfigFile >> "CfgExileArsenal" >> _vehClass >> "recipe");
		
	{
		if!((_x select 0) in XM8_VU_TOOLS)then{
			_count = if(count _x > 1)then{(_x select 1)}else{1};
			for "_i" from 1 to _count do {
				[player, _x select 0] call ExileClient_util_playerCargo_remove
			}
		}
	}forEach _recipe;
	
	disableUserInput true;
	player playActionNow "Medic";	
	["craft", [netId ExAd_VU_curVeh, _vehClass]] call TRX_fnc_serverDispatch;
	closeDialog 0;
	
	[] spawn {
		UISleep 7;
		disableUserInput false;
	};
};
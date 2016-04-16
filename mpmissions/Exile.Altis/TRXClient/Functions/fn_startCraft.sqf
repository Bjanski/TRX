/*  
	fn_startCraft.sqf

	Copyright 2016 Jan Babor

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/
params["_vehObj","_caller","_actionId","_actionParams","_recipe","_continue"];

_recipe = (typeOf _vehObj) call TRX_fnc_getRecipe;

_continue = true;
try 
{
	{
		if(count _x > 1)then
		{
			if!([player, _x] call TRX_fnc_itemsInCargo) then {throw 1}
		} else {
			if!([player, _x select 0] call ExileClient_util_playerEquipment_contains) then {throw 2}
		}
	}forEach _recipe;
	
	{
		_count = if(count _x > 1)then{(_x select 1)}else{1};
		for "_i" from 1 to _count do {
			if!([player, _x select 0] call ExileClient_util_playerCargo_remove)then{throw 3}
		}
	}forEach _recipe;
} 
catch 
{
	switch (_exception) do {
		case 1;
		case 2: {
			diag_log format["TRXClient Error - startCraft - %1",_exception]; 
			_upgradeToClass = getText(missionConfigFile >> "CfgExileArsenal" >> (typeOf _vehObj) >> "upgradeTo");
			_upgradeToDisplayName = getText(ConfigFile >> "CfgVehicles" >> _upgradeToClass >> "displayName");
			_vehObjDisplayName = getText(ConfigFile >> "CfgVehicles" >> (typeOf _vehObj) >> "displayName");
			_recipeMsg = "";
			{
				_amount = if(count _x > 1)then{_x select 1}else{1};
				_recipeMsg = _recipeMsg + format["%1x : %2\n",_amount, (_x select 0)];
			}forEach _recipe;
			cutText [format["To upgrade the %1 to a %2 you need;\n%3",_vehObjDisplayName,_upgradeToDisplayName,_recipeMsg],"PLAIN",2];
		};
		case 3: { hint "Now it went really south!! :| Contact Jan" };
	};
	_continue = false;
};

if!(_continue)exitWith{false};

disableUserInput true;
player playActionNow "Medic";

["craft", [netId _vehObj]] call TRX_fnc_serverDispatch;

UISleep 8;
disableUserInput false;
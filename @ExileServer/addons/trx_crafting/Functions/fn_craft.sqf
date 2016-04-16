/*
	fn_craft.sqf
  
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

/*
manipulate db entry
spawn in new vehicle. 
*/

params ["_objNetId","_objVeh"];

_objVeh = objectFromNetId _objNetId;

if!(_objVeh getVariable ["ExileIsPersistent", false])exitWith{diag_log "trying to upgrade a non-persistant vehicle"};

_newClass = getText(missionConfigFile >> "CfgExileArsenal" >> (typeOf _objVeh) >> "upgradeTo");

_objVeh call ExileServer_object_vehicle_database_update;
_objId = _objVeh getVariable ["ExileDatabaseID", -1];

_objVeh call ExileServer_system_vehicleSaveQueue_removeVehicle;
_objVeh call ExileServer_system_simulationMonitor_removeVehicle;
deleteVehicle _objVeh;

[_objId,_newClass] spawn {
	params ["_objId","_newClass"];
	
	UISleep 2;
	format ["updateVehicleClass:%1:%2",_newClass,_objId] call ExileServer_system_database_query_fireAndForget;	
	
	UISleep 2;
	_objId call ExileServer_object_vehicle_database_load;	
};

true
params ["_vehNetId","_playerNetId","_vehicleObject","_playerObject"];

_vehicleObject = objectFromNetId _vehNetId;
_playerObject = objectFromNetId _playerNetId;

diag_log format["Test har - UID - %1 -- _this %2", getPlayerUID _playerObject, _this ];

_vehicleObject setVariable ["ExileIsPersistent", true];
_vehicleObject setVariable ["ExileAccessCode", "0000"];
_vehicleObject setVariable ["ExileOwnerUID", (getPlayerUID _playerObject)];
_vehicleObject setVariable ["ExileIsLocked",0];
_vehicleObject lock 0;
_vehicleObject call ExileServer_object_vehicle_database_insert;
_vehicleObject call ExileServer_object_vehicle_database_update;

_objId = _vehicleObject getVariable ["ExileDatabaseID", -1];

_vehicleObject call ExileServer_system_vehicleSaveQueue_removeVehicle;
_vehicleObject call ExileServer_system_simulationMonitor_removeVehicle;
deleteVehicle _vehicleObject;

_objId call ExileServer_object_vehicle_database_load;	

true
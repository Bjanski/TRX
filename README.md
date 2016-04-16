# TRX
TRX Crafting

## Installation

**Don't change the folder structures.**

### Step 1 - Client
* Copy TRXClient into the mission root  
* Include neccessary classes into config.cpp. E.g. put the following inside (missionConfigFile >> "CfgInteractionMenus" >> "Car" >> "Actions") 
```cpp
class Upgrade: ExileAbstractAction
{
	title = "Upgrade";
	condition = "_this call TRX_fnc_canUpgrade";
	action = "_this call TRX_fnc_startCraft";
};
```
* Include neccessary classes into desription.ext
```js
class CfgFunctions
{
	#include "TRXClient\CfgFunctions.cpp"
};

class CfgRemoteExec
{
	class Functions
	{
		mode = 1;
		jip = 0;
		class ExileServer_system_network_dispatchIncomingMessage { allowedTargets=2; };
		class TRXServer_fnc_clientrequest { allowedTargets=2; };
	};
	class Commands
	{
		mode=0;
		jip=0;
	};
};
```
### Step 2 - Server 
* Copy "trx_crafting" into @ExileServer\addon\
### Step 3 - Database
* Inside "@ExileServer\extDB\sql_custom_v3\exile.ini" you find a couple of rows that needs to be put into the end of the same file on the server. 

## Example
In "mpmissions\Exile.Altis\config.cpp" you'll find and example. 
To attach an upgrade option to a vehicle you'll need to provide a "recipe" and a vehicle class "upgradeTo"
```js
class CfgExileArsenal
{
	class Exile_Car_LandRover_Red 				{ quality = 1; price = 11000; recipe[] = {{"Exile_Item_DuctTape",1},{"Exile_Item_Rope",2}}; upgradeTo = "Exile_Car_LandRover_Urban"; };
	class Exile_Car_LandRover_Urban 			{ quality = 1; price = 11000; recipe[] = {{"Exile_Item_DuctTape",1},{"Exile_Item_Rope",2}}; upgradeTo = "Exile_Car_LandRover_Red"; };
};
```
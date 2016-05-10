class CfgExileArsenal
{
	class Exile_Car_LandRover_Red 				{ quality = 1; price = 11000; recipe[] = {{"Exile_Item_DuctTape",1},{"Exile_Item_Rope",2}}; upgradeTo[] = {"Exile_Car_LandRover_Urban"}; };
	class Exile_Car_LandRover_Urban 			{ quality = 1; price = 11000; recipe[] = {{"Exile_Item_DuctTape",1},{"Exile_Item_Rope",2}}; upgradeTo[] = {"Exile_Car_LandRover_Red"}; };
};
class CfgInteractionMenus
{
	class Car 
	{
		targetType = 2;
		target = "Car";

		class Actions 
		{
			// TRX Upgrade vehicle
			class Upgrade: ExileAbstractAction
			{
				title = "Upgrade";
				condition = "_this call TRX_fnc_canUpgrade";
				action = "[] spawn {[] call ExileClient_gui_xm8_show; UISleep 2; call XM8_VG_checkNearByVehicles}";
			};
			class SaveVehicle: ExileAbstractAction
			{
				title = "SaveVehicle";
				condition = "((locked ExileClientInteractionObject) isEqualTo 1 && local ExileClientInteractionObject)";
				action = "['saveVehicle', [netId ExileClientInteractionObject, netId player]] call TRX_fnc_serverDispatch; hint 'The vehicle pin code is 0000';";
			};
		};
	};

	class Air
	{
		target = "Air";
		targetType = 2;

		class Actions
		{
			// TRX Upgrade vehicle
			class Upgrade: ExileAbstractAction
			{
				title = "Upgrade";
				condition = "_this call TRX_fnc_canUpgrade";
				action = "[] spawn {[] call ExileClient_gui_xm8_show; UISleep 2; call XM8_VG_checkNearByVehicles}";
			};
			class SaveVehicle: ExileAbstractAction
			{
				title = "SaveVehicle";
				condition = "((locked ExileClientInteractionObject) isEqualTo 1 && local ExileClientInteractionObject)";
				action = "['saveVehicle', [netId ExileClientInteractionObject, netId player]] call TRX_fnc_serverDispatch; hint 'The vehicle pin code is 0000'; ";
			};
		};
	};
};
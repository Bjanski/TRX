/*  
	fn_itemsInCargo.sqf

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

params ["_container","_itemArray"];

_item = toLower (_itemArray select 0);
_amount = _itemArray select 1;

_response = false;
{
	if(_item == toLower _x)then{
		_amount = _amount - 1;
	};
	if(_amount <= 0)exitWith{_response = true}
}forEach magazines player;

_response
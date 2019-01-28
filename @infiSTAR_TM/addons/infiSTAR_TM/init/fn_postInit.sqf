if(isServer)then
{
	infiSTAR_TM_EXTDB = getText(configFile >> "Cfg_infiSTAR_TM" >> "extDB_DLL_NAME");
	
	_fidx64 = (toLower infiSTAR_TM_EXTDB) find '_x64';
	if(_fidx64 > -1)then{
		NEW_infiSTAR_TM_EXTDB = infiSTAR_TM_EXTDB select [0,_fidx64];
		diag_log format["<infiSTAR.de> TM - changed %1 to %2",infiSTAR_TM_EXTDB,NEW_infiSTAR_TM_EXTDB];
		infiSTAR_TM_EXTDB = NEW_infiSTAR_TM_EXTDB;
	};
	if(infiSTAR_TM_EXTDB isEqualTo "")then{infiSTAR_TM_EXTDB = "extDB2";};
	
	fn_TM_extDB_getSingleResult = {
		_query = [0, ExileServerDatabaseSessionId, _this] joinString ":";
		_result = infiSTAR_TM_EXTDB callExtension _query;
		_result select [5,(_result find "]]]")-5]
	};
	fn_infiSTAR_TM__SERVERHANDLE = {
		_this params [["_option",0,[0]]];
		switch (_option) do 
		{
			case 0: {
				_this params [
					["_option",0,[0]],
					["_flag",objNull,[objNull]],
					["_newTerritoryName","",[""]],
					["_newFlagTexture","",[""]]
				];
				
				if(isNull _flag || _newTerritoryName isEqualTo "")exitWith{};
				
				_flagID = _flag getVariable ["ExileDatabaseID", -1];
				if(_flagID isEqualTo -1)exitWith{};
				
				_flag setVariable ["ExileTerritoryName", _newTerritoryName, true];
				_flag call ExileClient_system_territory_createLocationForTerritory;
				
				format["setTerritoryName:%1:%2",_newTerritoryName,_flagID] call ExileServer_system_database_query_fireAndForget;
				
				
				if(_newFlagTexture isEqualTo "")exitWith{};
				
				_flagTexture = flagTexture _flag;
				if(_flagTexture isEqualTo _newFlagTexture)exitWith{};
				format["setTerritoryFlagTexture:%1:%2",_newFlagTexture,_flagID] call ExileServer_system_database_query_fireAndForget;
				
				[[_flag,_newFlagTexture],{(_this select 0) setFlagTexture (_this select 1);}] remoteExecCall ["call",0,false];
			};
			case 1: {
				_this params [
					["_option",0,[0]],
					["_subOption",0,[0]]
				];
				if(_subOption isEqualTo 0)exitWith
				{
					_this params [
						["_option",0,[0]],
						["_subOption",0,[0]],
						["_flagNetID","",[""]],
						["_playerNetID","",[""]]
					];
					private ["_flag","_player","_flagID","_ownerUID"];
					
					_res = call {
						_flag = objectFromNetId _flagNetID;
						if(isNull _flag)exitWith{"Flag object is null!"};
						
						_player = objectFromNetId _playerNetID;
						if(isNull _player)exitWith{"Player object is null!"};
						
						_flagID = _flag getVariable ["ExileDatabaseID", -1];
						if(_flagID isEqualTo -1)exitWith{"Flag object is not saved in database!"};
						
						_ownerUID = _flag getVariable ["ExileOwnerUID", -1];
						if(_ownerUID isEqualTo -1)exitWith{"Flag has no owner!"};
						
						""
					};
					if(_res isEqualTo "")then
					{
						_position = getPosATL _flag;
						_log = format["Now moving [%1] with ID %2 from %3",_flag getVariable ["ExileTerritoryName","Flag"],_flagID,_position];
						[_log,{["SuccessTitleAndText", ["infiSTAR TM", format["%1",_this]]] call ExileClient_gui_toaster_addTemplateToast;}] remoteExecCall ["call",remoteExecutedOwner,false];
						
						_flag attachTo [_player, [0,2,4]];
						
						
						[
							[_flag],
							{
								params [
									["_flag",objNull,[objNull]]
								];
								
								attached_posarray = [0,2,4];
								attached_flag = _flag;
								
								if(!isNil "fn_TM_keyDown_attach_id")then{(findDisplay 46) displayRemoveEventHandler ["keyDown",fn_TM_keyDown_attach_id];fn_TM_keyDown_attach_id = nil;};
								fn_TM_keyDown_attach = {
									params ["_display","_keycode", "_keyshift", "_keyctrl", "_keyalt"];
									_handle = false;
									
									if(_keycode isEqualTo 0xCB)then
									{
										attached_posarray set [0,(attached_posarray select 0) - 0.5];
										_handle = true;
									};
									if(_keycode isEqualTo 0xCD)then
									{
										attached_posarray set [0,(attached_posarray select 0) + 0.5];
										_handle = true;
									};
									if(_keycode isEqualTo 0xC8)then
									{
										attached_posarray set [1,(attached_posarray select 1) + 0.5];
										_handle = true;
									};
									if(_keycode isEqualTo 0xD0)then
									{
										attached_posarray set [1,(attached_posarray select 1) - 0.5];
										_handle = true;
									};
									if(_keycode isEqualTo 0xC9)then
									{
										attached_posarray set [2,(attached_posarray select 2) + 0.5];
										_handle = true;
									};
									if(_keycode isEqualTo 0xD1)then
									{
										attached_posarray set [2,(attached_posarray select 2) - 0.5];
										_handle = true;
									};
									if(_handle)then
									{
										[4, netId attached_flag, netId player, attached_posarray] call fn_TM_serverRequest;
									};
									_handle
								};
								fn_TM_keyDown_attach_id = (findDisplay 46) displayAddEventHandler ["keyDown",{ call fn_TM_keyDown_attach; }];
							}
						] remoteExecCall ["call",remoteExecutedOwner,false];
					}
					else
					{
						[_log,{["ErrorTitleAndText", ["infiSTAR TM", format["%1",_this]]] call ExileClient_gui_toaster_addTemplateToast;}] remoteExecCall ["call",remoteExecutedOwner,false];
					};
				};
				if(_subOption isEqualTo 1)exitWith
				{
					_this params [
						["_option",0,[0]],
						["_subOption",0,[0]],
						["_flagNetID","",[""]]
					];
					
					_flag = objectFromNetId _flagNetID;
					if(isNull _flag)exitWith{};
					
					_flagID = _flag getVariable ["ExileDatabaseID", -1];
					if(_flagID isEqualTo -1)exitWith{};
					_position = getPosATL _flag;
					_res = format["setTerritoryPos:%1:%2:%3:%4", _position select 0, _position select 1, _position select 2, _flagID] call ExileServer_system_database_query_fireAndForget;
					
					_log = format["Moved [%1] with ID %2 to %3. %4",_flag getVariable ["ExileTerritoryName","Flag"],_flagID,_position,_res];
					[_log,{["SuccessTitleAndText", ["infiSTAR TM", format["%1",_this]]] call ExileClient_gui_toaster_addTemplateToast;}] remoteExecCall ["call",remoteExecutedOwner,false];
				};
			};
			case 2: {
				_this params [
					["_option",0,[0]],
					["_uid","",[""]]
				];
				_thread = missionNameSpace getVariable [format["NAME_REQUEST_THREAD_%1",_uid],scriptNull];
				if(isNull _thread)then
				{
					_thread = [_option,_uid] spawn {
						_this params [
							["_option",0,[0]],
							["_uid","",[""]]
						];
						if(_uid isEqualTo "")exitWith{};
						
						_name = missionNameSpace getVariable [format["NAME_BY_UID_%1",_uid],""];
						if(_name isEqualTo "")then
						{
							_name = format["getAccountName:%1", _uid] call fn_TM_extDB_getSingleResult;
							missionNameSpace setVariable [format["NAME_BY_UID_%1",_uid],_name];
						};
						if!(_name isEqualTo "")then
						{
							[
								[_name,_uid],
								{
									params [
										["_name","",[""]],
										["_uid","",[""]]
									];
									profileNamespace setVariable[format["last_name_%1",_uid],_name];
									saveprofileNamespace;
									
									_log = format["fetched name: %1(%2)",_name,_uid];
									diag_log _log;
									systemChat _log;
								}
							] remoteExecCall ["call",remoteExecutedOwner,false];
						};
						missionNameSpace setVariable [format["NAME_REQUEST_THREAD_%1",_uid],nil];
					};
					missionNameSpace setVariable [format["NAME_REQUEST_THREAD_%1",_uid],_thread];
				};
			};
			case 3: {
				_this spawn {
					_this params [
						["_option",0,[0]],
						["_flagNetID","",[""]]
					];
					
					_flag = objectFromNetId _flagNetID;
					if(isNull _flag)exitWith{};
					
					_flagID = _flag getVariable ["ExileDatabaseID", -1];
					if(_flagID isEqualTo -1)exitWith{};
					
					_uid = format["getFlagStolenBy:%1", _flagID] call fn_TM_extDB_getSingleResult;
					_name = format["getAccountName:%1", _uid] call fn_TM_extDB_getSingleResult;
					
					_stolenBy = format["%1 (%2)",_name,_uid];
					_stolenByVariable = _flag getVariable ["ExileFlagStolenBy", ""];
					if!(_stolenBy isEqualTo _stolenByVariable)then
					{
						_flag setVariable ["ExileFlagStolenBy",_stolenBy,true];
					};
				};
			};
			case 4: {
				_this params [
					["_option",0,[0]],
					["_flagNetID","",[""]],
					["_playerNetId","",[""]],
					["_attachToArray",[],[[]]]
				];
				
				_flag = objectFromNetId _flagNetID;
				if(isNull _flag)exitWith{};
				
				_player = objectFromNetId _playerNetId;
				if(isNull _player)exitWith{};
				
				detach _flag;
				_flag attachTo [_player, _attachToArray];
				
				[
					[_flag, _player, _attachToArray],
					{
						systemChat str _this;
					}
				] remoteExecCall ["call",remoteExecutedOwner,false];
			};
			default {};
		};
	};
};

infiSTAR_TM_fnc_full = {
waitUntil{uiSleep 1;getClientStateNumber >= 10 && !isNull findDisplay 46 && !isNil"ADMINLEVELACCESS"};
uiSleep 1;

if(isNil "TM_flagTextureArray")then
{
	TM_flagTextureArray = [];
	if(isClass (missionConfigFile >> "CfgFlags"))then
	{
		TM_flagTextureArray = TM_flagTextureArray + ("true" configClasses (missionConfigFile >> "CfgFlags"));
	};
	TM_flagTextureArray = TM_flagTextureArray + ("true" configClasses (configFile >> "CfgFlagsNative"));
};

fn_TM_serverRequest = {
	[4,[_this,"fn_infiSTAR_TM__SERVERHANDLE"]] call FN_infiSTAR_CS;
};
fn_TM_obj_by_uid = {
	_obj = missionNameSpace getVariable [format["object_by_uid_%1",_this],objNull];
	if(!alive _obj)then
	{
		{
			if(getPlayerUID _x isEqualTo _this)exitWith
			{
				missionNameSpace setVariable [format["object_by_uid_%1",_this],_x];
				_obj = _x;
			};
		} forEach allPlayers;
	};
	_obj
};
fn_TM_LBDblClick = {
	params ["_lbctrl2","_lbCurSel",["_player",objNull]];
	_netId = _lbctrl2 lbData _lbCurSel;
	_object = objectFromNetId _netId;
	if(isNull _object)then
	{
		["ErrorTitleAndText", ["infiSTAR TM", "Object not found"]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else
	{
		_dir = getDir _object;
		_pos = _object modelToWorldVisual [0,-1.5,0];
		if(isNull _player)then
		{
			if(isNil"freeFlightCam")then
			{
				freeFlightCam = objNull;
			};
			if(!isNull freeFlightCam)then{camDestroy freeFlightCam;};
			freeFlightCam = "camera" camCreate _pos;
			freeFlightCam camCommand "MANUAL ON";
			freeFlightCam camCommand "INERTIA OFF";
			freeFlightCam cameraEffect["INTERNAL", "BACK"];
			showCinemaBorder false;
			
			freeFlightCam setPosASL (AGLToASL _pos);
			freeFlightCam setDir _dir;
			
			["SuccessTitleAndText", ["infiSTAR TM", "RightMouseButton to stop CameraView!"]] call ExileClient_gui_toaster_addTemplateToast;
		}
		else
		{
			_player setPosASL (AGLToASL _pos);
			_player setDir _dir;
		};
	};
	false
};
fn_TM_btn3_ok = {
	if(!isNil"TM_btn_NameChange_thread")then{terminate TM_btn_NameChange_thread;TM_btn_NameChange_thread=nil;};
	TM_btn_NameChange_thread = _this spawn {
		disableSerialization;
		params ["_netId"];
		
		_flag = objectFromNetId _netId;
		_stolen = _flag getVariable ["ExileFlagStolen", 0] isEqualTo 1;
		if(_stolen)exitWith
		{
			["ErrorTitleAndText", ["infiSTAR TM", "Flag was stolen, can not do any changes while the flag is stolen!"]] call ExileClient_gui_toaster_addTemplateToast;
			false
		};
		
		_ExileTerritoryName = _flag getVariable ["ExileTerritoryName",""];
		
		_display = uiNameSpace getVariable ["RscExileSetupTerritoryDialog", displayNull];
		_newTerritoryName = ctrlText (_display displayCtrl 4000);
		
		
		_alphabet = getText (missionConfigFile >> "CfgClans" >> "clanNameAlphabet");
		_forbiddenCharacter = [_newTerritoryName, _alphabet] call ExileClient_util_string_containsForbiddenCharacter;
		if !(_forbiddenCharacter isEqualTo -1) exitWith 
		{
			["ErrorTitleAndText", ["infiSTAR TM", "Forbidden Character"]] call ExileClient_gui_toaster_addTemplateToast;
			false
		};
		
		_listBox = _display displayCtrl 4001;
		_newFlagTexture = _listBox lbData (lbCurSel _listBox);
		
		if(!(_ExileTerritoryName isEqualTo _newTerritoryName) || !((flagTexture _flag) isEqualTo _newFlagTexture))then
		{
			[0,_flag,_newTerritoryName,_newFlagTexture] call fn_TM_serverRequest;
		};
		
		if!(_ExileTerritoryName isEqualTo _newTerritoryName)then
		{
			_timeOut1 = time + 10;
			waitUntil { _flag getVariable ["ExileTerritoryName",""] isEqualTo _newTerritoryName || time > _timeOut1 };
			["SuccessTitleAndText", ["infiSTAR TM", format["%1 is now named %2.",_ExileTerritoryName,_newTerritoryName]]] call ExileClient_gui_toaster_addTemplateToast;
		};
		
		if!((flagTexture _flag) isEqualTo _newFlagTexture)then
		{
			_timeOut2 = time + 10;
			waitUntil { (flagTexture _flag) isEqualTo _newFlagTexture || time > _timeOut2};
			["SuccessTitleAndText", ["infiSTAR TM", "Flag changed!"]] call ExileClient_gui_toaster_addTemplateToast;
			
			_flagTexture = flagTexture _flag;
			_listBox lbSetData [0,_flagTexture];
			_listBox lbSetPicture [0,_flagTexture];
			_listBox lbSetData [1,_flagTexture];
		};
	};
};
fn_TM_btn3 = {
	params ["_lbctrl2","_lbCurSel",["_player",objNull]];
	_netId = _lbctrl2 lbData _lbCurSel;
	_flag = objectFromNetId _netId;
	if(isNull _flag)then
	{
		["ErrorTitleAndText", ["infiSTAR TM", "Flag object not found"]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else
	{
		_stolen = _flag getVariable ["ExileFlagStolen", 0] isEqualTo 1;
		if(_stolen)exitWith
		{
			["ErrorTitleAndText", ["infiSTAR TM", "Flag was stolen, can not do any changes while the flag is stolen!"]] call ExileClient_gui_toaster_addTemplateToast;
			false
		};
		
		disableSerialization;
		if(isNull(uiNameSpace getVariable ["RscExileSetupTerritoryDialog", displayNull]))then{createDialog "RscExileSetupTerritoryDialog";};
		_display = uiNameSpace getVariable ["RscExileSetupTerritoryDialog", displayNull];
		
		_ExileTerritoryName = _flag getVariable ["ExileTerritoryName",""];
		(_display displayCtrl 4000) ctrlSetText _ExileTerritoryName;

		_flagTexture = flagTexture _flag;
		_listBox = _display displayCtrl 4001;
		lbClear _listBox;
		_lbId = _listBox lbAdd "-- Current FlagTexture";
		_listBox lbSetData [_lbId,_flagTexture];
		_listBox lbSetPicture [_lbId,_flagTexture];
		_listBox lbSetCurSel 0;
		
		{
			_xTexture = getText (_x >> "texture");
			_lbId = _listBox lbAdd (getText (_x >> "name"));
			_listBox lbSetData [_lbId,_xTexture];
			_listBox lbSetPicture [_lbId,_xTexture];
		} forEach TM_flagTextureArray;
		
		(_display displayCtrl 4002) ctrlSetText "Ok";
		(_display displayCtrl 4002) ctrlRemoveAllEventHandlers "MouseButtonClick";
		(_display displayCtrl 4002) ctrlSetEventHandler["ButtonClick","["+str _netId+"] call fn_TM_btn3_ok;true"];
		true
	};
};
fn_TM_showInstructions = {
	disableSerialization;
	ctrlDelete ((findDisplay 46) displayCtrl 555);
	_ctrl = (findDisplay 46) ctrlCreate["RscStructuredText", 555];
	_ctrl ctrlSetPosition [safeZoneX,safeZoneY+(safeZoneH/3),0.6,1];
	_ctrl ctrlSetScale 2;
	_ctrl ctrlCommit 0;

	_text = "<t size=""0.48"" align=""left"" color=""#e5e5e5"" font=""PuristaMedium"">";
	_text = _text + "Instructions:" + "<br/>";
	_text = _text + "Once you have started moving a flag, " + "<br/>";
	_text = _text + "arrow keys will move the flag in all directions " + "<br/>";
	_text = _text + "picture up and picture down will move the flag up or down. easy." + "<br/>";
	_text = _text + "open the menu and press the move flag button again, to save and drop it at the new location" + "<br/>";
	_text = _text + "</t>";

	_ctrl ctrlSetStructuredText parseText format["%1",_text];
	_ctrl ctrlsetFade 1;
	_ctrl ctrlCommit 60;
};
fn_TM_btn4 = {
	params ["_lbctrl2","_lbCurSel",["_player",objNull]];
	_netId = _lbctrl2 lbData _lbCurSel;
	_flag = objectFromNetId _netId;
	
	if(!isNil"attached_flag")exitWith
	{
		detach attached_flag;
		
		if(!isNil "fn_TM_keyDown_attach_id")then{(findDisplay 46) displayRemoveEventHandler ["keyDown",fn_TM_keyDown_attach_id];fn_TM_keyDown_attach_id = nil;};
		[1,1,netId attached_flag] call fn_TM_serverRequest;
		
		attached_flag=nil;
		ctrlDelete ((findDisplay 46) displayCtrl 555);
	};
	if(isNull _flag)exitWith
	{
		["ErrorTitleAndText", ["infiSTAR TM", "Flag object not found"]] call ExileClient_gui_toaster_addTemplateToast;
	};
	if(_player distance _flag > 10)exitWith
	{
		["ErrorTitleAndText", ["infiSTAR TM", "Please Teleport to Flag first!"]] call ExileClient_gui_toaster_addTemplateToast;
	};

	[1,0,netId _flag,netId player] call fn_TM_serverRequest;
	call fn_TM_showInstructions;
	false
};
if(isNil"fn_TM_FLAGOBJECT")then{fn_TM_FLAGOBJECT = objNull;};
fn_TM_drawFlag = {
	if(visibleMap)then
	{
		if(!isNull fn_TM_FLAGOBJECT)then
		{
			_ctrl = _this select 0;
			_ctrl drawIcon ["iconObject_circle", [1,0.7,0.15,1], getPosASL fn_TM_FLAGOBJECT, 23, 23, 0, fn_TM_FLAGOBJECT getVariable ["ExileTerritoryName","Flag"]];
		};
	};
};
if(!isNil"TM_drawFlag_ID")then{ (findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw",TM_drawFlag_ID];TM_drawFlag_ID=nil; };
TM_drawFlag_ID = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler["Draw","call fn_TM_drawFlag"];
fn_TM_addInformation = {
	_playerobj = _this call fn_TM_obj_by_uid;
	if(isNull _playerobj)then
	{
		_playername = profileNamespace getVariable[format["last_name_%1",_this],""];
		if(_playername isEqualTo "")then
		{
			_lbctrl2 lbAdd _this;
			[2,_this] call fn_TM_serverRequest;
		}
		else
		{
			_lbctrl2 lbAdd format["%1 (%2)",_playername,_this];
		};
	}
	else
	{
		_playername = _playerobj call fnc_get_exileObjName;
		_txt = format["%1 (%2) distance to flag: %3", _playername, _this, _playerobj distance _flag];
		_lbindex = _lbctrl2 lbAdd _txt;
		_lbctrl2 lbSetColor [_lbindex,[0,1,0,1]];
		_lbctrl2 lbSetData [_lbindex, netId _playerobj];
		
		profileNamespace setVariable[format["last_name_%1",_this],_playername];
	};
};
fn_TM_LBSelChanged = {
	params ["_lbctrl","_lbCurSel"];
	_netId = if(_lbCurSel isEqualType "")then{_lbCurSel}else{_lbctrl lbData _lbCurSel};
	_flag = objectFromNetId _netId;
	_lbctrl2 = (findDisplay -1338) displayCtrl 1501;
	lbClear _lbctrl2;
	if(isNull _flag)then
	{
		_lbctrl2 lbAdd "No Territory selected..!";
	}
	else
	{
		fn_TM_FLAGOBJECT = _flag;
		
		_nextProtectionMoneyDueDate = _flag getVariable ["ExileTerritoryMaintenanceDue", [0, 0, 0, 0, 0]];
		_dateTimeString = format 
		[
			"%1-%2-%3 %4:%5",
			_nextProtectionMoneyDueDate select 0,
			_nextProtectionMoneyDueDate select 1,
			_nextProtectionMoneyDueDate select 2,
			_nextProtectionMoneyDueDate select 3,
			_nextProtectionMoneyDueDate select 4
		];
		_ownerUID = _flag getVariable ["ExileOwnerUID", ""];
		_stolen = _flag getVariable ["ExileFlagStolen", 0];
		if(_stolen isEqualTo 1)then{[3,netId _flag] call fn_TM_serverRequest;};
		_stolenBy = _flag getVariable ["ExileFlagStolenBy", ""];
		_level = _flag getVariable ["ExileTerritoryLevel", 0];
		_range = _flag getVariable ["ExileTerritorySize", 15];
		_num = _flag getVariable ["ExileTerritoryNumberOfConstructions", 0];
		_ExileTerritoryName = _flag getVariable ["ExileTerritoryName",""];
		_buildRights = _flag getVariable ["ExileTerritoryBuildRights",[]];
		_moderators = _flag getVariable ["ExileTerritoryModerators",[]];

		_flagTexture = flagTexture _flag;
		((findDisplay -1338) displayCtrl 12345) ctrlSetText _flagTexture;

		_grid = mapGridPosition _flag;
		_xpos = _grid select [0,3];
		_ypos = _grid select [3,6];

		_lbctrl2 = (findDisplay -1338) displayCtrl 1501;
		_lbindex = _lbctrl2 lbAdd format["NAME: %1 | GPS: %2/%3 | POS: %4", _ExileTerritoryName, _xpos, _ypos, _flag modelToWorldVisual [0,0,0]];_lbctrl2 lbSetData [_lbindex, _netId];
		_lbindex = _lbctrl2 lbAdd format["Stolen%1",if(_stolen isEqualTo 1)then{format[": Yes by %1",str _stolenBy]}else{": No"}];_lbctrl2 lbSetData [_lbindex, _netId];
		_lbindex = _lbctrl2 lbAdd format["Level: %1", _level];_lbctrl2 lbSetData [_lbindex, _netId];
		_lbindex = _lbctrl2 lbAdd format["TerritorySize: %1", _range];_lbctrl2 lbSetData [_lbindex, _netId];
		_lbindex = _lbctrl2 lbAdd format["Constructions: %1", _num];_lbctrl2 lbSetData [_lbindex, _netId];
		_lbindex = _lbctrl2 lbAdd format["Protection due date: %1", _dateTimeString];_lbctrl2 lbSetData [_lbindex, _netId];

		_lbctrl2 lbAdd "";
		_lbindex = _lbctrl2 lbAdd "Owner";
		_lbctrl2 lbSetColor [_lbindex,[1,0,1,1]];
		_ownerUID call fn_TM_addInformation;

		_lbctrl2 lbAdd "";
		_lbindex = _lbctrl2 lbAdd "ExileTerritoryBuildRights";
		_lbctrl2 lbSetColor [_lbindex,[1,0,1,1]];
		{ _x call fn_TM_addInformation; } forEach _buildRights;

		_lbctrl2 lbAdd "";
		_lbindex = _lbctrl2 lbAdd "ExileTerritoryModerators";
		_lbctrl2 lbSetColor [_lbindex,[1,0,1,1]];
		{ _x call fn_TM_addInformation; } forEach _moderators;

		if(_num > 0)then
		{
			_lbctrl2 lbAdd "";
			_lbindex = _lbctrl2 lbAdd "Construction Parts";
			_lbctrl2 lbSetColor [_lbindex,[1,0,1,1]];
			_lbindex = _lbctrl2 lbAdd "HP (x/3) - TYPE (CLASS)";
			
			{
				_xDamage = _x getVariable ["ExileConstructionDamage", 0];
				_lbindex = _lbctrl2 lbAdd format["%1/3 - %2", 3 - _xDamage, typeOf _x];
				if(_xDamage isEqualTo 0)then{_lbctrl2 lbSetColor [_lbindex,[0,1,0,1]];};
				if(_xDamage isEqualTo 1)then{_lbctrl2 lbSetColor [_lbindex,[1,0.5,0,1]];};
				if(_xDamage isEqualTo 2)then{_lbctrl2 lbSetColor [_lbindex,[1,0,0,1]];};
				_lbctrl2 lbSetData [_lbindex, netId _x];
			} forEach (_flag nearObjects ["Exile_Construction_Abstract_Static", _range]);
		};

		_lbctrl2 lbSetCurSel -1;
		for "_i" from 0 to 30 do { _lbctrl2 lbAdd ""; };
		saveprofileNamespace;
	};
	false
};
fn_TM_KeyUp_search = {
	params ["_editctrl","_keycode", "_keyshift", "_keyctrl", "_keyalt"];
	_edittxt = toLower(ctrlText _editctrl);

	_lbctrl = (findDisplay -1338) displayCtrl 1500;
	lbClear _lbctrl;

	if(_edittxt isEqualTo "")then
	{
		{
			_flag = _x;
			_buildRights = _flag getVariable ["ExileTerritoryBuildRights",[]];
			_ExileTerritoryName = _flag getVariable ["ExileTerritoryName",""];
			
			_online = false;
			{
				_playerobj = _x call fn_TM_obj_by_uid;
				if(!isNull _playerobj)then
				{
					_online = true;
				};
			} forEach _buildRights;
			
			_lbindex = _lbctrl lbAdd format["%1. %2", _forEachIndex + 1, _ExileTerritoryName];
			_lbctrl lbSetData [_lbindex, netId _flag];
			if(_online)then{ _lbctrl lbSetColor [_lbindex,[0,1,0,1]]; };
		} forEach TM_flag_array;
	}
	else
	{
		{
			_flag = _x;
			_buildRights = _flag getVariable ["ExileTerritoryBuildRights",[]];
			_ExileTerritoryName = _flag getVariable ["ExileTerritoryName",""];
			
			_online = false;
			_advancedBuildRights = "";
			{
				if(_forEachIndex > 0)then
				{
					_advancedBuildRights = _advancedBuildRights + ", ";
				};
				
				_playerobj = _x call fn_TM_obj_by_uid;
				if(isNull _playerobj)then
				{
					_advancedBuildRights = _advancedBuildRights + format["%1",_x];
				}
				else
				{
					_playername = _playerobj call fnc_get_exileObjName;
					_txt = format["%1 (%2)", _playername, _x];
					_advancedBuildRights = _advancedBuildRights + _txt;
					_online = true;
				};
			} forEach _buildRights;
			
			_ls = toLower(format["%1 %2", _ExileTerritoryName, _advancedBuildRights]);
			if(_ls find _edittxt > -1)then
			{
				_lbindex = _lbctrl lbAdd format["%1. %2", _forEachIndex + 1, _ExileTerritoryName];
				_lbctrl lbSetData [_lbindex, netId _flag];
				if(_online)then{ _lbctrl lbSetColor [_lbindex,[0,1,0,1]]; };
			};
		} forEach TM_flag_array;
	};
	_lbctrl lbSetCurSel 0;
	for "_i" from 0 to 30 do { _lbctrl lbAdd ""; };

	[_lbctrl, 0] call fn_TM_LBSelChanged;
	false
};
fn_TM_load = {
	_display = findDisplay -1338;


	_flagsA = [];
	{_flagsA set[_forEachIndex, [_x distance cameraOn, _x]];} forEach (call {TM_flag_array});
	_flagsA sort true;

	_flags = [];
	{
		_flag = _x select 1;
		_flags pushBackUnique _flag;
	} forEach _flagsA;
	TM_flag_array = _flags;


	{
		if(ctrlIDC _x in [10,11,12,21,100,1500,1501])then
		{
			_x ctrlEnable true;
			_x ctrlShow true;
		} else {
			_x ctrlEnable false;
			_x ctrlShow false;
			ctrlDelete _x;
		};
	} forEach (allControls _display);

	_pic = [findDisplay -1338,"RscPicture",12345] call fnc_createctrl;
	_pic ctrlSetPosition [safeZoneX + ((safeZoneW/5)*3.68), safeZoneY + (safeZoneH / 12), 0.35, 0.3];
	_pic ctrlCommit 0;

	_editInfoTxtBackground = [findDisplay -1338,"IGUIBack",12346] call fnc_createctrl;
	_editInfoTxtBackground ctrlSetPosition [safeZoneX + ((safeZoneW/5)*1.4), (safeZoneY + (safeZoneH / 12)*2.68)-0.05, (safeZoneW/5), 0.05];
	_editInfoTxtBackground ctrlSetBackgroundColor [0.15,0.15,0.15,1];
	_editInfoTxtBackground ctrlCommit 0;
	
	_editInfoTxt = [findDisplay -1338,"RscText",12347] call fnc_createctrl;
	_editInfoTxt ctrlSetPosition [safeZoneX + ((safeZoneW/5)*1.4), (safeZoneY + (safeZoneH / 12)*2.68)-0.05, (safeZoneW/5), 0.05];
	_editInfoTxt ctrlCommit 0;
	_editInfoTxt ctrlSetText "Enter Territoryname, Player Name or UID to filter for it.";


	_editctrl = (findDisplay -1338) displayCtrl 100;
	_editctrl ctrlSetBackgroundColor [0.15,0.15,0.15,1];
	_editctrl ctrlSetPosition [safeZoneX + ((safeZoneW/5)*1.4), safeZoneY + (safeZoneH / 12)*2.68, (safeZoneW/5), 0.05];
	_editctrl ctrlSetText "";
	_editctrl ctrlCommit 0;
	_editctrl ctrlAddEventHandler ["KeyUp", fn_TM_KeyUp_search];

	_btn1 = (findDisplay -1338) displayCtrl 10;
	_btn1 ctrlSetPosition [safeZoneX + ((safeZoneW/5)*2.42), safeZoneY + (safeZoneH / 12)*2.7, (safeZoneW/13), 0.04];
	_btn1 ctrlCommit 0;
	_btn1 ctrlSetText "Teleport to Flag";
	_btn1 buttonSetAction "[(findDisplay -1338) displayCtrl 1501, 1, player] call fn_TM_LBDblClick;true";

	_btn2 = (findDisplay -1338) displayCtrl 11;
	_btn2 ctrlSetPosition [safeZoneX + ((safeZoneW/5)*2.42), (safeZoneY + (safeZoneH / 12)*2.7) - 0.045, (safeZoneW/13), 0.04];
	_btn2 ctrlCommit 0;
	_btn2 ctrlSetText "Create Camera at Flag";
	_btn2 buttonSetAction "[(findDisplay -1338) displayCtrl 1501, 1, objNull] call fn_TM_LBDblClick;true";
	
	_btn3 = (findDisplay -1338) displayCtrl 12;
	_btn3 ctrlSetPosition [safeZoneX + ((safeZoneW/5)*2.42) + ((safeZoneW/12)*2), safeZoneY + (safeZoneH / 12)*2.7, (safeZoneW/13), 0.04];
	_btn3 ctrlCommit 0;
	_btn3 ctrlSetText "Change Name or Flag";
	_btn3 buttonSetAction "[(findDisplay -1338) displayCtrl 1501, 1, objNull] call fn_TM_btn3;true";

	_btn4 = (findDisplay -1338) displayCtrl 21;
	_btn4 ctrlSetPosition [safeZoneX + ((safeZoneW/5)*2.42) + ((safeZoneW/12)*2), (safeZoneY + (safeZoneH / 12)*2.7) - 0.045, (safeZoneW/13), 0.04];
	_btn4 ctrlCommit 0;
	_btn4 ctrlSetText "Move Flag / Put Flag down";
	_btn4 buttonSetAction "[(findDisplay -1338) displayCtrl 1501, 1, player] call fn_TM_btn4;true";

	_lbctrl = [findDisplay -1338,"RscListBox_infiSTAR",1500] call fnc_createctrl;
	_lbctrl ctrlSetBackgroundColor [0.15,0.15,0.15,1];
	_lbctrl ctrlSetPosition [safeZoneX + ((safeZoneW/5)*1.4), safeZoneY + (safeZoneH / 12)*3, (safeZoneW/5), safeZoneH/1.6];
	_lbctrl ctrlCommit 0;
	_lbctrl ctrlAddEventHandler ["LBSelChanged", fn_TM_LBSelChanged];
	_lbctrl ctrlSetFontHeight 0.035;
	lbClear _lbctrl;

	_lbctrl2 = (findDisplay -1338) displayCtrl 1501;
	_lbctrl2 ctrlSetBackgroundColor [0.15,0.15,0.15,1];
	_lbctrl2 ctrlSetPosition [safeZoneX + ((safeZoneW/5)*2.4), safeZoneY + (safeZoneH / 12)*3, (safeZoneW/5)*2, safeZoneH/1.6];
	_lbctrl2 ctrlCommit 0;
	_lbctrl2 ctrlAddEventHandler ["LBDblClick", { [_this select 0,_this select 1,player] call fn_TM_LBDblClick }];
	_lbctrl2 ctrlSetFontHeight 0.035;
	lbClear _lbctrl2;

	if!(TM_flag_array isEqualTo [])then
	{
		{
			_flag = _x;
			_buildRights = _flag getVariable ["ExileTerritoryBuildRights",[]];
			_ExileTerritoryName = _flag getVariable ["ExileTerritoryName",""];
			if(_ExileTerritoryName isEqualTo "")then{_ExileTerritoryName = [_flag modelToWorldVisual [0,0,0]] call ExileClient_util_world_getNearestLocationName;};
			
			_online = false;
			_advancedBuildRights = "";
			{
				if(_forEachIndex > 0)then
				{
					_advancedBuildRights = _advancedBuildRights + ", ";
				};
				
				_playerobj = _x call fn_TM_obj_by_uid;
				if(isNull _playerobj)then
				{
					_advancedBuildRights = _advancedBuildRights + format["%1",_x];
				}
				else
				{
					_playername = _playerobj call fnc_get_exileObjName;
					_txt = format["%1 (%2)", _playername, _x];
					_advancedBuildRights = _advancedBuildRights + _txt;
					_online = true;
				};
			} forEach _buildRights;
			
			_lbindex = _lbctrl lbAdd format["%1. %2", _forEachIndex + 1, _ExileTerritoryName];
			_lbctrl lbSetData [_lbindex, netId _flag];
			if(_online)then{ _lbctrl lbSetColor [_lbindex,[0,1,0,1]]; };
		} forEach TM_flag_array;
		for "_i" from 0 to 30 do { _lbctrl lbAdd ""; };
		[_lbctrl, netId(TM_flag_array select 0)] call fn_TM_LBSelChanged;
	};

	_lbctrl lbSetCurSel 0;
	ctrlSetFocus _btn1;
};
fn_TM_init = {
	disableSerialization;
	if(isNull findDisplay -1338)then
	{
		TM_flag_array = allMissionObjects "Exile_Construction_Flag_Static";
		createdialog "infiSTAR_AdminMenu";
		call fn_TM_load;
	};
};


["SuccessTitleAndText", ["infiSTAR TM", "Territory Management loaded."]] call ExileClient_gui_toaster_addTemplateToast;
};
if(hasInterface && !isServer)then{ [] spawn infiSTAR_TM_fnc_full; };
true

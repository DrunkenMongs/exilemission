/*
	Author: Chris(tian) "infiSTAR" Lorenzen
	Contact: infiSTAR23@gmail.com // www.infiSTAR.de
	
	Copyright infiSTAR - 2011 - 2019. All rights reserved.
	Christian (Chris) L. (infiSTAR23@gmail.com) Developer of infiSTAR
	
	Description:
	Arma AntiHack & AdminTools - infiSTAR.de
	
	NOTE:
	PLEASE DO NOT ADD ANYTHING TO ANY INFISTAR FILE AT ALL! THIS IS SO WE CAN TRACK WHATS ACTUALLY BEEN ADDED!
	
	
	READ:
	type 0 = just execute
	type 1 = toggleable function
	type 2 = function targets the selected player (it will be _this)
	
	name = name shown in the admin menu (this is also what has to be put in the EXILE_AHAT_CONFIG.sqf as Admin Power!)
	
	code = code to execute - if you have a linebreak within the code, you need to put a \ at the end of each line!
	
	List of functions and according levels:
	zomshield - Level 2 and 3
*/
class CfgCustomFunctions {
	
	class zomshield {
		type = 1;	// toggle on/off
		name = "Zombie Shield";
		code = "if(isNil'zombieShieldToggle')then{MiZ_Zombie_Toggle1 = 1; zombieShieldToggle=true;}else{MiZ_Zombie_Toggle1 = 0;zombieShieldToggle=nil;}; \
[]spawn \
{ \
	while {MiZ_Zombie_Toggle1 == 1} do \
	{ \
		_Pos1 = getPos player; \
		_EntitiesArray1 = _Pos1 nearEntities ['all',100]; \
		{ \
			_Zombie1 = _x; \
			if (_Zombie1 getVariable 'RZ_isZombie') then \
			{ \
				deleteVehicle _Zombie1; \
				sleep 1; \
			}; \
			if (_Zombie1 getVariable 'RZ_isDemon') then \
			{ \
				deleteVehicle _Zombie1; \
				sleep 1; \
			}; \
		}foreach _EntitiesArray1; \
	sleep 1; \
	}; \
};";
	};
};

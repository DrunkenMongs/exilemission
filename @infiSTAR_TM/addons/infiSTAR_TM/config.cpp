/*
	Author: Chris(tian) "infiSTAR" Lorenzen
	Contact: infiSTAR23@gmail.com // www.infiSTAR.de
	
	Copyright infiSTAR - 2011 - 2019. All rights reserved.
	Christian (Chris) L. (infiSTAR23@gmail.com) Developer of infiSTAR
*/
class CfgPatches
{
	class infiSTAR_TM
	{
		requiredVersion = 0.1;
		requiredAddons[] = {};
		units[] = {};
		weapons[] = {};
		magazines[] = {};
		ammo[] = {};
		infiSTAR_TM_version = 0.1;
		author[]= {"Chris(tian) 'infiSTAR' Lorenzen"};
		website[]= {"http://infiSTAR.de"};
		contact[]= {"admin@infiSTAR.de"};
		contact_alt[]= {"infiSTAR23@gmail.com"};
	};
};
class CfgFunctions
{
	class infiSTAR_TM
	{
		class main
		{
			file = "infiSTAR_TM\init";
			class preInit { preInit = 1; };
			class postInit { postInit = 1; };
		};
	};
};
class Cfg_infiSTAR_TM
{
	#include "settings.hpp"
};
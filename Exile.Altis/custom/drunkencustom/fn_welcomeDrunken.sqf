/*
    ____                   __                 __  ___                      
   / __ \_______  ______  / /_____  ____     /  |/  /___  ____  ____ ______
  / / / / ___/ / / / __ \/ //_/ _ \/ __ \   / /|_/ / __ \/ __ \/ __ `/ ___/
 / /_/ / /  / /_/ / / / / ,< /  __/ / / /  / /  / / /_/ / / / / /_/ (__  ) 
/_____/_/   \__,_/_/ /_/_/|_|\___/_/ /_/  /_/  /_/\____/_/ /_/\__, /____/  
                                                             /____/        

						File: fn_welcomeDrunken.sqf
						Desc: Calls to see if player is alive
						Author: Vipes // Inspiration from old arma 2 life (kinda)
*/

createDialog "RscDisplayWelcome";

_display = findDisplay 999999;
_text1 = _display displayCtrl 1100;
_buttonStuff = _display displayCtrl 2400;
_textStuff = _display displayCtrl 1101;
_text2 = _display displayCtrl 1102;

_message = ""; // Please Keep Blankm Unless you are ugly like me L:3
_message = _message + "<t align='center' size='8' shadow='0'></t><br />";
_message = _message + "<t align='center' size='2' shadow='0'>Welcome to <a color='#ff9900'>Drunen Mongs</a> Exile Altis!</t><br />";
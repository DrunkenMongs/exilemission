class CfgServerInfoMenu
{
   addAction = 1; // Enable/disable action menu item | use 0 to disable | default: 1 (enabled)
   antiHACK = "infiSTAR + BattlEye";
   hostedBy = "DM";
   ipPort = "000.123.456.789:2302";
   openKey = "User7"; // https://community.bistudio.com/wiki/inputAction/actions
   openAtLogin = no;
   restart = 3; // Amount of hours before server automatically restarts
   serverName = "Drunken Mongs Exile";
   class menuItems
   {
      // title AND content accept formatted text ( since update Oct5.2016 )
      class first
      {
         menuName = "General";
         title = "<t color='#ffffff'>GENERAL INFORMATION</t>";
         content[] = {
            "Welcome to Drunken Mongs!<br /> Join our discord @ www.drunkenmongs.com"
         };
      };
      class second
      {
         menuName = "Rules";
         title = "SERVER RULES";
         content[] = {
            "<t size='1.75'>Rule #1</t><br />Players/admins are NOT permitted to show racism, profanity and disrespect towards any other player/admin in this server.<br />",
            "<t size='1.75'>Rule #2</t><br />No voice transmission over side chat. Adjust your control settings to prevent doing it by accident.<br />"
         };
      };
      class third
      {
         menuName = "Crafting";
         title = "CRAFTING GUIDE";
         content[] = {"Just your standard Crafting! Nothing special yet :("};
      };
      class fourth
      {
         menuName = "Admins";
         title = "ADMINISTRATORS";
         content[] = {"Vipes, Vaas, Madlax, Infamous, Rider, Koneg, Xverion"};
      };
      class fifth
      {
         menuName = "Scripts";
         title = "INSTALLED SCRIPTS";
         content[] = {""};
      };
      class sixth
      {
         menuName = "Communication";
         title = "VOICE SERVER AND WEBSITE";
         content[] = {
            "<t size='1.25'>TeamSpeak:</t> 37.187.24.229",
            "<br />",
            "<t size='1.25'>Discord:</t> www.drunkenmongs.com"
         };
      };
      class seventh
      {
         menuName = "Credits";
         title = "CREDITS WHERE CREDITS DUE";
         content[] = {
            "<t size='1.25'>IT07:</t> Server created and maintained by",
            "<br />",
            "<t size='1.25'>Name:</t> Vipes"
         };
      };
   };
};

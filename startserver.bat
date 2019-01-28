@echo off
color 0a
title Exile
:Serverstart
echo Launching Server...
C:
cd "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Server"
echo Monitor Active!
start "Arma3" /min /wait arma3server.exe  -port=2902 "-config=C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Server\TADST\default\TADST_config.cfg" "-cfg=C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Server\TADST\default\TADST_basic.cfg" "-profiles=C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Server\TADST\default" -name=default -filePatching "-mod=@Exile;@ExileServer;@infiSTAR_Exile;@infiSTAR_TM;@Zombies and Demons" -autoInit
ping 127.0.0.1 -n 15 >NUL
echo Server Shutdown....
ping 127.0.0.1 -n 5 >NUL
cls
goto Serverstart
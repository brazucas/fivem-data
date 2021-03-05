@echo off

pause
start ..\FXServer.exe +exec config/config.cfg +set onesync on +set onesync_population false
exit

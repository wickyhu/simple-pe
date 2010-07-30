@echo off
setlocal
echo VNC: Check if network client is installed
bartpe.exe -c c -q ms_msclient
if not "%errorlevel%" == "0" (
	echo.
	echo VNC: MS Client is not installed!
	echo VNC: Please load client network support before this script!
	goto _err)
echo VNC: Check if server service is installed
bartpe.exe -c s -q ms_server
if not "%errorlevel%" == "0" (
	echo.
	echo VNC: MS Server service is not installed!
	echo VNC: Please load file sharing support before this script!
	goto _err)
echo VNC: Installing VNC Server Service
%~dp0winvnc.exe -installs
echo VNC: Importing registry settings
regedit /s %~dp0vncsettings.reg
echo VNC: Starting the VNC Server Service,
net start "vnc server"
echo VNC: default VNC password is "bartpevnc" !!!
goto _end
:_err
echo.
echo VNC: There was an error, script aborted!!!
rem set errorlevel to 1 by (mis)using color
color 00 
:_end
endlocal

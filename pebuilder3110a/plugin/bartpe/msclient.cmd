@echo off
setlocal
echo BARTPE: Starting Network Support (client)
regsvr32 /s netcfgx.dll
echo BARTPE: Detecting/installing drivers
bartpe -pnp -cn bartpe-* -wg workgroup
if errorlevel 1 goto _err
echo BARTPE: Installing Tcpip
bartpe -c p -i ms_tcpip
if errorlevel 1 goto _err
echo BARTPE: Installing Microsoft Client
bartpe -c c -i ms_msclient
if errorlevel 1 goto _err
echo BARTPE: Starting TCPIP service
net start tcpip
if errorlevel 1 goto _err
echo BARTPE: Starting DHCP service
net start dhcp
if errorlevel 1 goto _err
echo BARTPE: Starting NLA service
net start nla
if errorlevel 1 goto _err
echo BARTPE: Starting LMHOSTS service
net start lmhosts
if errorlevel 1 goto _err
if not exist %windir%\system32\hostname.exe goto _nohost
echo Getting hostname...
hostname.exe
:_nohost
goto _end
:_err
echo.
echo BARTPE: There was an error, script aborted!!!
rem set errorlevel to 1 by (mis)using color
color 00 
:_end

@echo off
setlocal
:_client
echo BARTPE: Check if network client is installed
bartpe.exe -c c -q ms_msclient 1>nul 2>&1
if not "%errorlevel%" == "0" (
	netconfig.exe
	goto _client)
echo BARTPE: Check if server service is installed
bartpe.exe -c s -q ms_server 1>nul 2>&1
if "%errorlevel%" == "0" (
	echo.
	echo BARTPE: MS Server service is already installed!
	echo BARTPE: It can only be loaded once...
	goto _err)
echo BARTPE: Installing Microsoft Server
bartpe.exe -c s -i ms_server
if errorlevel 1 goto _err
echo BARTPE: Starting SERVER service
net start server
if errorlevel 1 goto _err
set _pass=%random%
echo BARTPE: Setting Administrator password to %_pass%
net user Administrator %_pass%
if errorlevel 1 goto _err
echo BARTPE: Creating drive shares
for %%i in (b c d e f g h i j k l m n o p q r s t u v w x y z) do (
	if exist %%i:\nul net share drive-%%i=%%i:\
)
if not exist %windir%\system32\hostname.exe goto _nohost
echo Getting hostname...
hostname.exe
:_nohost
echo.
echo *** SECURITY NOTE! ***
echo To access the shares on this system you must logon as administrator 
echo with the password %_pass% !!!
echo *** SECURITY NOTE! ***
goto _end
:_err
echo.
echo BARTPE: There was an error, script aborted!!!
rem set errorlevel to 1 by (mis)using color
color 00 
:_end
endlocal

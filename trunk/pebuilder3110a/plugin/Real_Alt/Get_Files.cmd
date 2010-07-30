@echo off &MODE CON: COLS=75 LINES=20 &color 1e
:: All my thanks to hilander999 and Siegfried for their help
:: Original code from hilander999
: edit and modified to fit this plugin by Xtreme

SETLOCAL ENABLEEXTENSIONS
cd /d %~dp0

set INFname=RealAlt.inf
::SET NOW=2
::SET TOPBOX=? 
::SET MIDBOX= ????????????????????????????????????????????????????????????????????????ธ
::SET NUMROW= 0%%                25%%               50%%               75%%              100%%

echo ===================================== > "%cd%\File_Grabber.log"
echo Real Alternative Codecs Plugin >> File_Grabber.log
echo Plugin by: Xtreme >> File_Grabber.log
echo Collector by: Xtreme >> File_Grabber.log
echo Plugin for: Windows Xpire Rd CD >> File_Grabber.log
echo Website: http://xtremee.orgfree.com >> File_Grabber.log
echo Copyright ฉ Windows Xpire Tech Center. All rights reserved. >> File_Grabber.log
echo ===================================== >> File_Grabber.log

IF NOT EXIST "%programfiles%\Real Alternative\settings.exe" GOTO :error1

cls&CALL :BRANDH
echo  Please wait till Grabber finish Real Alternative Codecs grabbing process..

IF NOT EXIST "%cd%\files" md files
IF NOT EXIST "%cd%\files\Sys32" md files\Sys32
rem IF NOT EXIST "%cd%\files\Media Player Classic" md "files\Media Player Classic"
IF NOT EXIST "%cd%\files\Real Alternative" md "files\Real Alternative"

echo.&echo   -Grabbing file: Copy System32 files... &FOR %%A IN (
%Systemroot%\system32\pncrt.dll
%Systemroot%\system32\pndx5016.dll
%Systemroot%\system32\pndx5032.dll
%Systemroot%\system32\rmoc3260.dll
	)DO (ECHO. Grabbing file:%%~A >>"%cd%\File_Grabber.log"
		Copy /Y "%%~A" files\Sys32 >NUL
		if errorlevel 1 (SET ERRORLEVEL=1&echo. *ERROR: File_Grabber can't find %%~A >>"%cd%\File_Grabber.log")
		)

rem echo.&echo   -Grabbing file: Copy Media Player Classic Directory... &xcopy /s "%programfiles%\Media Player Classic\*.*" "files\Media Player Classic" >>"%cd%\File_Grabber.log"
echo.&echo   -Grabbing file: Copy Real Alternative Directory... &xcopy /s "%programfiles%\Real Alternative\*.*" "files\Real Alternative" >>"%cd%\File_Grabber.log"

CALL :PROGRESS

::pause
MODE CON: COLS=76 LINES=23
IF "%ERRORLEVEL%"=="1" (GOTO :error2)else goto :done
GOTO :END

:PROGRESS
::SET /A NOW+=1
::IF %NOW% LEQ 2 GOTO :EOF
cls&CALL :BRANDH
::echo.&echo.   File: %~1&echo.&echo.%TOPBOX%&echo.%MIDBOX%&echo.%NUMROW%
::SET TOPBOX=%TOPBOX%U
::SET NOW=1
copy SCRIPTS\StaticINF.dat "%INFname%"
if exist start.inf del start.inf
GOTO :EOF

:error1
MODE CON: COLS=78 LINES=28 &COLOR 4F &cls

echo.&echo. >> File_Grabber.log
echo   Real Alternative Codecs not installed on your System >> File_Grabber.log
echo.  >> File_Grabber.log
echo If you don't have   Real Alternative Codecs you can download it from  >> File_Grabber.log
echo.&echo -free-codecs.com:  >> File_Grabber.log
echo   	  http://www.free-codecs.com/Real_Alternative_download.htm >> File_Grabber.log
echo. >> File_Grabber.log
echo For help you can check Help.html >> File_Grabber.log

CALL :BRANDH
echo.&echo.	  Real Alternative Codecs not installed on your Windows
echo.&echo.	You need to setup   Real Alternative Codecs then try again
echo.&echo.     If you don't have   Real Alternative Codecs you can download it from
echo.&echo.       -free-codecs.com:
echo             http://www.free-codecs.com/Real_Alternative_download.htm&echo.
CALL :BRAND2
GOTO :END


:error2
cls&COLOR 4F
CALL :BRANDH
echo.&echo 		One or more required files was not found.
echo.&echo.	Check the log for details...&echo.	"%cd%\File_Grabber.log"&echo.
CALL :BRAND2
pause
IF EXIST %systemroot%\system32\notepad.exe (start %systemroot%\system32\notepad.exe "%cd%\File_Grabber.log")
endlocal
exit

:done
cls&CALL :BRANDH
echo.&echo.	  Real Alternative Codecs Files have been succesfully collected
echo.&echo.		You can now start build your PE version &echo.
CALL :BRAND2
GOTO :END

:BRANDH
MODE CON: COLS=75 LINES=30 &color 1e
echo.
ECHO          ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO          บ                                                      บ
ECHO          บ    Real Alternative Codecs plugin Files Collector    บ
ECHO          บ                                                      บ  
ECHO          บ                   Plugin by Xtreme                   บ
ECHO          บ______________________________________________________บ  
ECHO          บ              Xtremesony_xp@yahoo.com                 บ
ECHO          ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ 
echo.
GOTO :EOF

:BRAND2
echo.    - For more help and update you Can join us in our group
echo.           http://groups.yahoo.com/group/Windows-Xpire/
echo.
echo.    - For more BartPE Plugin go to our website:
echo.           http://xtremee.orgfree.com 
echo.
echo.    - Send all comments to: Xtremesony_xp@yahoo.com     
echo.
echo.
ECHO          ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO          บ       Copyright (C) Windows Xpire Tech Center        บ
ECHO          ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ 

GOTO :EOF


:END
ENDLOCAL
echo.
PAUSE&EXIT

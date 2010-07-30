@echo off &MODE CON: COLS=75 LINES=20 &color 1e
:: All my thanks to hilander999 and Siegfried for their help
:: Original code from hilander999
: edit and modified to fit this plugin by Xtreme

SETLOCAL ENABLEEXTENSIONS
cd /d %~dp0

set INFname=UltraISO.inf
::SET NOW=2
::SET TOPBOX=? 
::SET MIDBOX= ????????????????????????????????????????????????????????????????????????ธ
::SET NUMROW= 0%%                25%%               50%%               75%%              100%%

echo ===================================== > "%cd%\File_Grabber.log"
echo UltraISO v8.6.6.2180 Plugin >> File_Grabber.log
echo Plugin by: Xtreme >> File_Grabber.log
echo Collector by: Xtreme >> File_Grabber.log
echo Plugin for: EZB Systems, Inc (http://www.ezbsystems.com) >> File_Grabber.log
echo Website: http://xtreme.boot-land.net >> File_Grabber.log
echo  -mirror: http://xtremee.orgfree.com >> File_Grabber.log
echo Copyright ฉ Windows Xpire Tech Center. All rights reserved. >> File_Grabber.log
echo ===================================== >> File_Grabber.log

IF NOT EXIST "%ProgramFiles%\UltraISO\UltraISO.exe" GOTO :error1

cls&CALL :BRANDH

IF NOT EXIST "%cd%\files" md files

echo.&echo   -Grabbing file: Copy UltraISO main directory files... &FOR %%A IN (
"%programfiles%\UltraISO\isoshell.dll"
"%programfiles%\UltraISO\ultraiso.chm"
"%programfiles%\UltraISO\UltraISO.exe"
"%programfiles%\UltraISO\ultraiso.ico"
	)DO (ECHO. Grabbing file:%%~A >>"%cd%\File_Grabber.log"
		Copy /Y "%%~A" files >NUL
		if errorlevel 1 (SET ERRORLEVEL=1&echo. *ERROR: File_Grabber can't find %%~A >>"%cd%\File_Grabber.log")
		)

echo.&echo   -Grabbing file: Copy UltraISO drivers directory files... &FOR %%B IN (
"%programfiles%\UltraISO\drivers\ISODrive.sys"
"%programfiles%\UltraISO\drivers\ISODrv64.sys"
"%programfiles%\UltraISO\drivers\IsoCmd.exe"
	)DO (ECHO. Grabbing file:%%~B >>"%cd%\File_Grabber.log"
		Copy /Y "%%~B" files >NUL
		if errorlevel 1 (SET ERRORLEVEL=1&echo. *ERROR: File_Grabber can't find %%~B >>"%cd%\File_Grabber.log")
		)

echo.&echo   -Grabbing file: Copy UltraISO main language files... &FOR %%C IN (
"%programfiles%\UltraISO\lang\lang_de.dll"
"%programfiles%\UltraISO\lang\lang_fr.dll"
"%programfiles%\UltraISO\lang\lang_it.dll"
"%programfiles%\UltraISO\lang\lang_es.dll"
"%programfiles%\UltraISO\lang\lang_pt.dll"
"%programfiles%\UltraISO\lang\lang_nl.dll"
"%programfiles%\UltraISO\lang\lang_se.dll"
"%programfiles%\UltraISO\lang\lang_pl.dll"
"%programfiles%\UltraISO\lang\lang_cz.dll"
"%programfiles%\UltraISO\lang\lang_hu.dll"
"%programfiles%\UltraISO\lang\lang_ru.dll"
"%programfiles%\UltraISO\lang\lang_ua.dll"
"%programfiles%\UltraISO\lang\lang_bg.dll"
"%programfiles%\UltraISO\lang\lang_tr.dll"
"%programfiles%\UltraISO\lang\lang_kr.dll"
"%programfiles%\UltraISO\lang\lang_gr.dll"
"%programfiles%\UltraISO\lang\lang_yu.dll"
"%programfiles%\UltraISO\lang\lang_by.dll"
"%programfiles%\UltraISO\lang\lang_he.dll"
"%programfiles%\UltraISO\lang\lang_br.dll"
"%programfiles%\UltraISO\lang\lang_dk.dll"
"%programfiles%\UltraISO\lang\lang_no.dll"
"%programfiles%\UltraISO\lang\lang_lv.dll"
"%programfiles%\UltraISO\lang\lang_ar.dll"
"%programfiles%\UltraISO\lang\lang_si.dll"
"%programfiles%\UltraISO\lang\lang_cn.dll"
"%programfiles%\UltraISO\lang\lang_tw.dll"
"%programfiles%\UltraISO\lang\lang_et.dll"
"%programfiles%\UltraISO\lang\lang_sk.dll"
"%programfiles%\UltraISO\lang\lang_ct.dll"
"%programfiles%\UltraISO\lang\lang_fi.dll"
"%programfiles%\UltraISO\lang\lang_mk.dll"
"%programfiles%\UltraISO\lang\lang_hr.dll"
"%programfiles%\UltraISO\lang\lang_ro.dll"
"%programfiles%\UltraISO\lang\lang_lt.dll"
"%programfiles%\UltraISO\lang\lang_sr.dll"
"%programfiles%\UltraISO\lang\lang_ir.dll"
"%programfiles%\UltraISO\lang\lang_jp.dll"
	)DO (ECHO. Grabbing file:%%~C >>"%cd%\File_Grabber.log"
		Copy /Y "%%~C" files >NUL
		if errorlevel 1 (SET ERRORLEVEL=1&echo. *ERROR: File_Grabber can't find %%~C >>"%cd%\File_Grabber.log")
		)

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
echo   UltraISO v8.6.6.2180 not installed on your System >> File_Grabber.log
echo.  >> File_Grabber.log
echo If you don't have UltraISO v8.6.6.2180 you can download it from  >> File_Grabber.log
echo.&echo -EZB Systems:  >> File_Grabber.log
echo   	   http://www.ezbsystems.com/ultraiso/download.htm >> File_Grabber.log
echo. >> File_Grabber.log
echo For help you can check Help.html >> File_Grabber.log

CALL :BRANDH
echo.&echo.	  UltraISO v8.6.6.2180 not installed on your Windows
echo.&echo.	You need to setup UltraISO v8.6.6.2180 then try again
echo.&echo.     If you don't have UltraISO v8.6.6.2180 you can download it from
echo.&echo.       -EZB Systems:
echo             http://www.ezbsystems.com/ultraiso/download.htm&echo.
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
echo.&echo.    UltraISO v8.6.6.2180 Files have been succesfully collected
echo.&echo.		You can now start build your PE version &echo.
CALL :BRAND2
GOTO :END

:BRANDH
MODE CON: COLS=75 LINES=30 &color 1e
echo.
ECHO          ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO          บ                                                      บ
ECHO          บ      UltraISO v8.6.6.2180 plugin Files Collector     บ
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
echo.                 http://xtreme.boot-land.net 
echo.        (mirror) http://xtremee.orgfree.com 
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

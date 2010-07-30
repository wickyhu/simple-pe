@echo off
title BartPE Installer script v2.0.2
echo.
echo BartPE Installer script v2.0.2
echo Copyright (c) 2003-2006 Bart Lagerweij. All rights reserved.
echo This program is free software. Use and/or distribute it under
echo the terms of the Nu2 License (see peinst.txt file).
echo.
setlocal
rem %~d0
rem cd "%~dp0"
set _base=%~dp0
set _tmp=%tmp%\peinst.tmp
set _tmp1=%tmp%\peinst1.tmp
for %%i in (_source _target _go) do set %%i=
:_arg
for %%i in (-h -?) do if /I "%%i" == "%1" goto _usage
if /I "%1" == "-i" goto _i
if "%_source%" == "" if not "%1" == "" goto _1
if "%_target%" == "" if not "%1" == "" goto _2
goto _start
:_i
set _go=_install
goto _next
:_1
set _source=%1
goto _next
:_2
set _target=%1
goto _next
:_next
shift
if "%1" == "" goto _start
goto _arg
:_usage
echo.
echo Usage: %~n0 [Options] [SourcePath] [TargetPath]
echo.
echo SourcePath: the path where BartPE can be found. By default the drive where 
echo            %~n0 is located is used.
echo TargetPath: is the path to where BartPE will be installed.By default drive 
echo            C: is used.
echo Options:
echo -i          Install BartPE files (choice 5,1)
echo -h          Help
goto _end
:_start
echo PEINST: Checking for required file(s)...
for %%i in (%_base%mkbt.exe %_base%nt2peldr.exe) do if not exist %%i (
	echo PEINST: Required file %%i not found!
	goto _abort)
rem if exist "%~d0\i386\setupldr.bin" set _source=%~d0
rem if exist c:\boot.ini set _target=c:
if not "%_go%" == "" goto %_go%
:_main
echo.
echo     -[MAIN]-
echo     1) Change source path [%_source%]
echo        - Path to BartPE source files -
echo     2) Change target path [%_target%]
echo        - Path where BartPE will be installed -
echo     3) List or format volume(s).
echo        - use for formatting USB Flash Devices -
echo     4) Create, delete partition(s).
echo        - use for partitioning a harddisk -
if "%_source%" == "" goto _menu1
if "%_target%" == "" goto _menu1
echo     5) Install BartPE to %_target%
echo        - Install BartPE files -
:_menu1
echo     Q) Quit.
echo.
:_mainch
set _ok=
set /p _ok=Enter your choice :
if "%_ok%" == "1" goto _getsrc
if "%_ok%" == "2" goto _gettrg
if "%_ok%" == "3" goto _voledit
if "%_ok%" == "4" goto _part
if "%_ok%" == "5" goto _instpe
if /I "%_ok%" == "q" goto _end
goto :_mainch

:_getsrc
set _ok=
echo.
echo PEINST: Please give the location to your BartPE files
set /p _ok=Enter Source path :
if exist "%_ok%\i386\setupldr.bin" (
	set _source=%_ok%
) else (
	echo.
	echo PEINST: Error: The path "%_ok%" does not contain BartPE ^(or any other PE^) files!
	pause
)
goto _main

:_gettrg
set _ok=
echo.
echo PEINST: Please give the location where to install to
set /p _ok=Enter Target path :
if not exist %_ok%\nul (
	echo PEINST: Path "%_ok%" does not exist!
	pause
	goto _main
)
set _target=%_ok%
goto _main

:_instpe
echo.
echo     -[INSTALL]-
echo     1) Install BartPE files to %_target%
echo        - Install the files (takes a few minutes) -
echo     2) Install PE-loader in %_target%\boot.ini
echo        - use this if you want to select BartPE in your boot.ini menu -
echo     Q) Quit
echo.
set _ok=
set /p _ok=Enter your choice :
if "%_ok%" == "1" goto _install
if "%_ok%" == "2" goto _bootini
if /I "%_ok%" == "q" goto _main
goto :_voledit


:_bootini
echo PEINST: Checking if NT Loader is installed on drive %_target%
if not exist %_target%\ntldr (
	echo PEINST: Oops, file "%_target%\ntldr" not found.
	goto _abort)

echo PEINST: Checking if boot.ini is on drive %_target%
if not exist %_target%\boot.ini (
	echo PEINST: Oops, file "%_target%\ntldr" not found.
	goto _abort)

echo PEINST: Installing PE Bootsector (peboot.bin)
%_base%mkbt.exe -x -c %_target% %_target%\peboot.bin
if errorlevel 1 goto _abort
echo PEINST: Updating peboot.bin
%_base%nt2peldr.exe %_target%\peboot.bin
if errorlevel 1 goto _abort
echo PEINST: Updating boot.ini
echo PEINST: Setting timeout to 30 seconds
rem bootcfg.exe /Timeout 30
rem if errorlevel 1 goto _abort
echo PEINST: Adding BartPE entry to %_target%\boot.ini
findstr /I /B /L /V "%_target%\peboot.bin" %_target%\boot.ini > %_target%\boot$.ini
echo %_target%\peboot.bin="Boot BartPE (by PE Builder)" >> %_target%\boot$.ini
attrib -r -h -s %_target%\boot.ini
if errorlevel 1 goto _abort
del /q /f %_target%\boot.ini
if errorlevel 1 goto _abort
ren %_target%\boot$.ini boot.ini
if errorlevel 1 goto _abort
attrib +r +h +s %_target%\boot.ini
echo PEINST: Installing PE Loader (peldr)
copy %_source%\i386\setupldr.bin %_target%\peldr
if errorlevel 1 goto _abort
echo PEINST: PE-Loader installed...
pause
goto _main

:_part
echo.
call :_dskcmd "" "list disk"
if errorlevel 1 (
	echo PEINST: Getting disk list failed. No disks?!?
	pause
	goto _main
)
:_partseldsk
echo.
set _disk=
set /p _disk=Select disk. Enter disk number or 'q' to go back :
if /I "%_disk%" == "q" goto _main
call :_chkdsk %_disk%
if errorlevel 1 goto _part
goto _partedit

:_voledit
echo.
echo     -[VOLUME]-
echo     1) List all volumes
echo     2) Format a volume (FAT or NTFS)
echo     Q) Quit
echo.
set _ok=
set /p _ok=Enter your choice :
if "%_ok%" == "1" call :_dskcmd "" "list volume"
if "%_ok%" == "2" goto _volfmt
if /I "%_ok%" == "q" goto _main
goto :_voledit

:_volfmt
set _letter=
set /p _letter=Enter the drive letter to format (leave empty to quit) :
if "%_letter%" == "" goto _voledit
set _letter=%_letter:~0,1%
:_askfs
set _ok=
set /p _ok=Filesystem to use, NTFS or FAT? (n/f/q to quit) :
if /I "%_ok%" == "q" goto _voledit
if /I "%_ok%" == "n" goto _askfs2
if /I "%_ok%" == "f" goto _askfs2
goto _askfs
:_askfs2
if /I "%_ok%" == "n" set _fs=ntfs
if /I "%_ok%" == "f" set _fs=fat
echo.
echo PEINST: Are you sure you want to format drive "%_letter%:" ?
echo PEINST: -- THIS WILL TOTALLY ERASE ALL DATA ON THAT VOLUME! --
echo.
set _ok=
set /p _ok=To continue type "YES" (uppercase without quotes) :
if "%_ok%" == "YES" goto _volfmtok
echo PEINST: You typed "%_OK%", that is not equal to "YES", bailing out...
goto _voledit
:_volfmtok
call :_format %_letter% %_fs%
if errorlevel 1 (
	echo PEINST: Error: Format returned an error...
	pause
	goto _voledit
)
echo.
echo PEINST: Format was succesfull
pause
goto _voledit

:_format
if "%1" == "" (
	echo PEINST: Error: _format: %1 empty
	goto _abort)
if "%2" == "" (
	echo PEINST: Error: _format: %2 empty
	goto _abort)
echo PEINST: Formating %1: 
format %1: /fs:%2 /v:BartPE /backup /force
goto :eof

:_partedit
echo.
echo Currently selected disk: %_disk%
echo.
echo     -[PARTITION]-
echo     1) Show disk details
echo     2) List partitions
echo     3) Create primary partition and format it
echo     4) Remove a partition
echo     5) Remove all partitions (clean)
echo     Q) Quit
echo.
set _ok=
set /p _ok=Enter your choice :
if "%_ok%" == "1" call :_dskcmd %_disk% "detail disk"
if "%_ok%" == "2" call :_dskcmd %_disk% "list partition"
if "%_ok%" == "3" goto _crpart
if "%_ok%" == "4" goto _delpart
if "%_ok%" == "5" goto _clean
if /I "%_ok%" == "q" goto _main
goto :_partedit

:_crpart
echo.
set _size=
set /p _size=New partition size in MB (hit enter for all available space, q to quit) :
if /I "%_size%" == "q" goto _partedit
:_crpartl
set _letter=
set /p _letter=The drive letter you want to assign to the volume (q to quit) :
if /I "%_letter%" == "q" goto _partedit
set _letter=%_letter:~0,1%
:_crparta
set _active=
echo PEINST: If you want to boot from this partition you must set it "active"
set /p _active=Set the partition active? (y/n/q to quit) :
if /I "%_active%" == "q" goto _partedit
if /I "%_active%" == "y" goto _crpartgo
if /I "%_active%" == "n" goto _crpartgo
goto _crparta
:_crpartgo
set _sbuf="create partition primary
if not "%_size%" == "" set _sbuf=%_sbuf% size=%_size%
set _sbuf=%_sbuf%"
if /I "%_active%" == "y" set _sbuf=%_sbuf% "active"
set _sbuf=%_sbuf% "assign letter=%_letter%"
call :_dskcmd %_disk% %_sbuf%
if errorlevel 1 (
	echo PEINST: Error: Partition creation returned an error...
	pause
	goto _partedit)
call :_format %_letter% ntfs
if errorlevel 1 (
	echo PEINST: Error: Format returned an error...
	pause
	goto _partedit)
echo.
echo PEINST: Partition created and formatted OK
echo PEINST: Drive letter to access the new volume is  "%_letter%:"
goto _partedit

:_clean
echo.
echo PEINST: Do you want to remove all partitions from disk %_disk%?
echo PEINST: -- THIS WILL TOTALLY ERASE ALL DATA ON YOUR DISK! --
echo.
set _ok=
set /p _ok=To continue type "YES" (uppercase without quotes) :
if "%_ok%" == "YES" goto _cleanok
echo PEINST: You typed "%_OK%", that is not equal to "YES", bailing out...
goto _partedit
:_cleanok
call :_dskcmd %_disk% "clean"
if errorlevel 1 pause
goto _partedit

:_dskcmd
echo rem > %_tmp%
if not "%~1" == "" (
	echo Disk="%~1"
	echo select disk %~1 >> %_tmp%)
:_dskcmdl
if "%~2" == "" goto _dskcmdgo
echo Command="%~2"
echo %~2 >> %_tmp%
shift
goto _dskcmdl
:_dskcmdgo
diskpart.exe /s "%_tmp%" > %_tmp1%
call :_print "%_tmp1%"
if errorlevel 1 goto _dskcmderr
goto :eof
:_dskcmderr
color 00
goto :eof

:_chkdsk
if "%1" == "" goto _chkdski
echo.
echo PEINST: Checking disk %1, please wait...
echo select disk %1 > %_tmp%
echo detail disk >> %_tmp%
diskpart.exe /s "%_tmp%" > %_tmp1%
rem call :_print "%_tmp1%"
if errorlevel 1 goto _chkdski
echo PEINST: Disk number %1 is a valid disk number...
goto :eof
:_chkdski
echo PEINST: Disk number %1 is invalid!
:_chkdsk1n
color 00
goto :eof

:_install
if not exist "%_source%\i386\setupldr.bin" (
	echo.
	echo PEINST: Error: The path "%_source%" does not contain BartPE ^(or any other PE^) files!
	pause
	goto _main
)
rem if /I "%_target%" == "%SystemDrive%" (
rem 	echo PEINST: Error: You cannot install BartPE onto your current SystemDrive
rem 	pause
rem 	goto _main
rem )
if not exist "%_target%" (
	echo PEINST: Target path "%_target%" does not exist!
	pause
	goto _main
)
if not exist %_target%\ntdetect.com (
	echo PEINST: Installing ntdetect to %_target%
	copy %_source%\i386\ntdetect.com %_target%\
	if errorlevel 1 goto _abort
)
if not exist %_target%\ntldr (
	echo PEINST: Installing ntldr to %_target%
	copy %_source%\i386\setupldr.bin %_target%\ntldr
	if errorlevel 1 goto _abort
)

echo PEINST: Installing BartPE files from %_source% to %_target%\

call :_copy i386 minint
if errorlevel 1 goto _abort
call :_copy programs programs
if errorlevel 1 goto _abort

echo.
echo PEINST: Installation completed...
if not "%_go%" == "" goto _end
pause
goto _main
:_copy
if "%~1" == "" goto :eof
if "%~2" == "" goto :eof
if not exist "%_source%\%~1" goto :eof
if exist "%_target%\%~2" (
	echo PEINST: Checking for BartPE tag file ^(save removal^)...
	if not exist "%_target%\%~2\bartpe.tag" goto _tagerr
	echo PEINST: Removing %_target%\%~2
	rmdir /s /q "%_target%\%~2\")
	if errorlevel 1 goto :eof
	mkdir "%_target%\%~2\"
	if errorlevel 1 goto :eof
	echo PEINST: Tag file for BartPE do not remove! > "%_target%\%~2\bartpe.tag"
	if errorlevel 1 goto :eof
echo PEINST: Copying files from "%_source%\%~1" to "%_target%\%~2"
xcopy /e /s "%_source%\%~1\*.*" "%_target%\%~2\"
goto :eof
:_tagerr
echo PEINST: Tag file "%_target%\%~2\bartpe.tag" not found!
echo PEINST: Not safe to remove directory!
echo.
echo PEINST: Workaround:
echo PEINST: You could delete the folder "%_target%\%~2" manually and restart the installation...
rem set errorlevel to 1 by (mis)using color
color 00 
goto :eof
:_print
for /f "skip=4 tokens=*" %%i in (%~1) do echo %%i
goto :eof
:_abort
echo.
echo PEINST: Aborted...
pause
goto _main
:_end
for %%i in (_tmp _tmp1) do if exist "%%i" del /f /q "%%i"
endlocal
echo.
echo PEINST: Done (PEINST.CMD will be closed)
pause

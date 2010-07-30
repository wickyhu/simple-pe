@echo off
title BartPE USB Installer v1.0.1
echo.
echo BartPE USB Installer v1.0.1
echo Copyright (c) 2005 Bart Lagerweij. All rights reserved.
echo This program is free software. Use and/or distribute it under
echo the terms of the Nu2 License.
echo.
setlocal
set _format=
set _target=
set _base=%~dp0
if "%1" == "-f" set _format=1& shift
set _target=%~d1
if "%_target%" == "" (
	echo Usage pe2usb [-f] ^<drive:^>
	echo.
	echo Where:
	echo     ^<drive:^> The drive letter of your USB flash drive
	echo     -f       Format USB drive and install patched bootsector
	echo              ^(this is only needed the first time^)
	goto _err)
echo USB target drive set to "%_target%"
echo Checking drive "%_target%"
if not exist %_target%\nul (
	echo Error: Drive "%_target%" does not exist!
	goto _err)
if "%_target%" == "%SystemDrive%" (
	echo Error: Trying to install to your SystemDrive?!?
	goto _err)
echo Checking files...
for %%i in ("%_base%plugin\peinst\mkbt.exe" "%_base%pe2usb.bin" "%_base%BartPE\i386\setupldr.bin" "%_base%mkisofs.exe" "%_base%srsp1\ramdisk.sys" "%_base%srsp1\setupldr.bin" "%_base%BartPE\bootsect.bin") do if not exist %%i (
	echo Error: File %%i not found!
	echo Please check the pe2usb.txt for details!
	goto _err)
if not "%_format%" == "1" goto _install
echo.
echo *******************************************************************************
echo Drive %_target% will be formatted!!! All data on drive will be erased!
echo *******************************************************************************
echo.
set /p _answer=Type "YES" (uppercase) to continue:
if "%_answer%" == "YES" goto _format
echo You type "%_answer%", format aborted...
goto _err
:_format
echo Formating drive "%_target%"...
format %_target% /fs:fat /u /v:usb /backup
if errorlevel 1 (
	echo Error: Format %_target% failed!
	goto _err)
echo Installing bootsector from %_base%pe2usb.bin on drive %_target%
"%_base%plugin\peinst\mkbt.exe" -x -l=BartPE "%_base%pe2usb.bin" %_target%
if errorlevel 1 (
	echo Error: Installing bootsector failed!
	goto _err)
:_install
echo Checking bootsector from drive %_target%
"%_base%plugin\peinst\mkbt.exe" -x -i %_target%
if errorlevel 1 (
	echo Error: Boot sector inspection failed!
	goto _err)
echo Copying %_base%srsp1\ramdisk.sys to %_base%BartPE\i386\system32\drivers
copy /y "%_base%srsp1\ramdisk.sys" "%_base%BartPE\i386\system32\drivers"
if errorlevel 1 (
	echo Error: copy %_base%srsp1\ramdisk.sys to %_base%BartPE\i386\system32\drivers failed!
	goto _err)
echo Copying %_base%srsp1\setupldr.bin to %_target%\ntldr
copy /y "%_base%srsp1\setupldr.bin" %_target%\ntldr
if errorlevel 1 (
	echo Error: copy %_base%srsp1\setupldr.bin to %_target%\ntldr failed!
	goto _err)
echo Copying %_base%BartPE\i386\ntdetect.com to %_target%\
copy /y "%_base%BartPE\i386\ntdetect.com" %_target%\
if errorlevel 1 (
	echo Error: copy %_base%BartPE\i386\ntdetect.com to %_target%\ failed!
	goto _err)
echo Building %_target%\winnt.sif
echo [SetupData] > %_target%\winnt.sif
echo BootDevice = "ramdisk(0)" >> %_target%\winnt.sif
echo BootPath = "\I386\SYSTEM32\" >> %_target%\winnt.sif
echo OsLoadOptions = "/noguiboot /fastdetect /minint /rdexportascd /rdpath=bartpe.iso" >> %_target%\winnt.sif
echo Generating ISO image %_target%\bartpe.iso
"%_base%mkisofs.exe" -iso-level 4 -force-uppercase -volid "BartPE" -b bootsect.bin -no-emul-boot -boot-load-size 4 -hide bootsect.bin -hide boot.catalog -o %_target%\bartpe.iso "%_base%bartpe"
if errorlevel 1 (
	echo Error: mkisofs failed!
	goto _err)
echo.
echo Ready!
echo.
set _size=0
for %%i in (%_target%\bartpe.iso) do set _size=%%~zi
set /a _size=%_size%/1048576
echo ISO image size is %_size%MB
set /a _size=%_size%+64
echo *******************************************************************************
echo You should be able to boot this on systems with at least %_size%MB of memory!
echo *******************************************************************************
goto _end
:_err
echo.
echo Aborted...
echo There was an error, script aborted!!!
rem set errorlevel to 1 by (mis)using color
color 00 
:_end
endlocal
echo.
echo Done (program will be closed)
pause

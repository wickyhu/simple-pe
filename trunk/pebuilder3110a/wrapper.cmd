@echo off
:settings
rem ------------------ SETTINGS -----------------
rem set _volid=BartPE
set _volid=WindowsXPE
set _sortfile=sort.txt

set _mkisofsexe=mymkisofs.exe

set _duponce=-duplicates-once
rem set _duponce=

rem low | normal | high | realtime | abovenormal | belownormal
rem set _mkisofspriority=belownormal
set _mkisofspriority=normal

rem Actions
set _runinfcache=yes
set _copyhives=yes
set _setupisolinux=no
set _mkisofs=yes
rem ------------------ SETTINGS -----------------
:copyright
echo _
echo *******************************
echo Build Script for BartPE v1.1
echo Copyright (c) 2005 Sherpya
echo *******************************

:getparams
for %%i in (%1) do set iso=%%~i
for %%i in (%2) do set pedir=%%~i

echo _
echo [Active Actions for %_volid%]
if "%_runinfcache%" == "yes" ( echo : InfCacheBuilder and FileCase : )
if "%_copyhives%" == "yes" ( echo : Copy Hives for HD Install : )
if "%_setupisolinux%" == "yes" ( echo : Isolinux Setup : )
if "%_mkisofs%" == "yes" ( echo : Iso Creation : )
echo _
echo Source directory: %pedir%
echo Destination iso file: %iso%

:main
if not "%_runinfcache%" == "yes" goto copyhives
echo _ 
echo [Calling InfCacheBuild]
if not exist InfCacheBuild.exe (
    echo  *** Missing InfCacheBuild.exe executable, skipping...
    goto copyhives
)

InfCacheBuild.exe "%pedir%"

if %errorlevel% == 2 (
    rem set _caseopt=-U -duplicates-once
    set _caseopt=-U
    echo filecase.ini found and processed correctly, adding -U option
)
    
:copyhives
if not "%_copyhives%" == "yes" goto isolinux
if exist "%pedir%\Programs\peinst\" (
    echo _
    echo [Copying registry hives for hdinstall]
    ( copy /y "%pedir%\i386\system32\config\default" "%pedir%\Programs\peinst" >NUL: )
    ( copy /y "%pedir%\i386\system32\config\software" "%pedir%\Programs\peinst" >NUL: )
    echo Done
)

:isolinux
set _bootopt=-b bootsect.bin -boot-load-size 4 -no-emul-boot -hide bootsect.bin -hide boot.catalog
if not "%_setupisolinux%" == "yes" goto mkisofs
echo _
echo [Setup IsoLinux]
if not exist isolinux\ (
    echo  *** Missing isolinux directory, skipping...
    goto mkisofs
)
rem set _bootfile=isolinux/isolinux-debug.bin
set _bootfile=isolinux/isolinux.bin
set _bootopt=-b %_bootfile% -boot-load-size 4 -no-emul-boot -hide %_bootfile% -hide boot.catalog -boot-info-table

if not exist "%pedir%\isolinux\" ( md "%pedir%\isolinux" )
copy /y isolinux "%pedir%\isolinux"
echo Done

:mkisofs
echo _
echo [Iso Image]
if exist %_sortfile% (
    echo Detected sort file %_sortfile%, it will be used.
    set _sort=-sort %_sortfile%
)
set _imageinfo=-volid "%_volid%"
set _mkisofsopt=%_duponce% %_sort% %_caseopt% -iso-level 4 %_imageinfo% %_bootopt%
echo cmdline: %_mkisofsexe% %_mkisofsopt% -o "%iso%" "%pedir%"
if not "%_mkisofs%" == "yes" goto noiso
if not exist %_mkisofsexe% (
    echo  *** I don't like this game... where is %_mkisofsexe%?
    goto end
)
echo Launching mkisofs...
start /b /i /wait /%_mkisofspriority% %_mkisofsexe% %_mkisofsopt% -o "%iso%" "%pedir%"
goto end
:noiso
echo *** Iso was not created as requested ***
:end
echo _

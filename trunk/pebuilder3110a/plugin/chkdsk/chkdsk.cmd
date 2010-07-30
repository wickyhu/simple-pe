@echo off
rem chkdsk.cmd
rem Created by Bart Lagerweij
setlocal
echo CHKDSK.CMD: Starting...
echo.
set _drive=
set _r=
set _f=
echo Please enter the drive, mount point or volume name to check (for example "c:")...
set /p _drive=Enter drive:
if "%_drive%" == "" goto _end
echo.
echo Do you want to fix errors on the disk *and*
echo locate bad sectors and recover readable information (Yes/No)...
:_recinp
set /p _r=Enter "y" or "n":
if "%_r%" == "" goto _recinp
if /I "%_r%" == "y" goto _go
if /I "%_r%" == "n" goto _fix
goto _recinp
:_fix
echo.
echo Do you want to fix errors on the disk (Yes/No)...
:_fixinp
set /p _f=Enter "y" or "n":
if /I "%_f%" == "" goto _fixinp
if /I "%_f%" == "y" goto _go
if /I "%_f%" == "n" goto _go
goto _recinp
:_go
echo.
echo ----------------------------------------------------------------
echo You have specified to check drive/volume %_drive%
echo.
echo With the following options:
if /I "%_r%" == "y" goto _pfix
if /I "%_f%" == "y" goto _pfix
goto _nofix
:_pfix
echo - Fix errors on the disk
:_nofix
if /I "%_r%" == "y" echo - Locate bad sectors and recover readable information (slow!)
echo ----------------------------------------------------------------
echo.
echo Start check disk? (Yes/No)...
:_startinp
set /p _s=Enter "y" or "n":
if /I "%_s%" == "" goto _startinp
if /I "%_s%" == "y" goto _run
if /I "%_s%" == "n" goto _abort
goto _startinp
:_run
if /I "%_f%" == "y" set _param=/f
if /I "%_r%" == "y" set _param=/r
set _param=%_drive% %_param%
echo Running: chkdsk.exe %_param%
chkdsk.exe %_param%
echo.
echo CHKDSK.CMD: Check disk done...
goto _end
:_abort
echo.
echo CHKDSK.CMD: Aborted...
:_end
pause
endlocal

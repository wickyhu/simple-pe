@echo off
if "%*" == "" (
	echo Argument "%*" not found!
	goto _err)
call %*
goto _end
:_err
echo.
echo BARTPE: There was an error, script aborted!!!
rem set errorlevel to 1 by (mis)using color
color 00 
:_end
echo.
pause

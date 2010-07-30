@echo off
call msclient.cmd
if errorlevel 1 goto _err
call msserver.cmd
if errorlevel 1 goto _err
:_err

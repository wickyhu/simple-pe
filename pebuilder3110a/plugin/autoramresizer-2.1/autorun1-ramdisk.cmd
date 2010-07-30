@echo off
Title Auto Ramdisk Resizer
start /wait AutoRamResizer.exe -h 64 -f 64
rem format %ramdrv% /FS:NTFS /V:RAMDisk /Q /C /x /FORCE
exit

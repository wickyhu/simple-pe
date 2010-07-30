-- Build Scripts for PEBuilder --

Copyright (c) 2005 Gianluigi Tiesi <sherpya@netfarm.it>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.
 
(c) Gianluigi Tiesi <sherpya@netfarm.it>

Rename mkisofs.exe to mymkisofs.exe, then unpack the content of this archive into pebuilder directory.

Edit wrapper.cmd to change your options:

_volid is the title of the Image.
_sortfile to pass to mkisofs for sorting order of files, I've tracked down a possible order (xpe optimized), but you can use your own.
_duponce if you want to add -duplicates-once to mkisofs (if supported)

_mkisofspriority can be low | normal | high | realtime | abovenormal | belownormal, the priority for mkisofs process.

_runinfcache if yes the script will call InfCacheBuild, it will remove CopyFiles, RenFiles and DelFiles sections from inf files,
             then it will build INFCACHE.1 to speedup pnp detection, also if filecase.ini is included it uppercases files from
             this file and it will add -U option to mkisofs so you will not get all files on Image in uppercase but only needed.
             
_copyhives if yes the script will copy registry hives for hdinstall, you should also edit plugin\peinst\peinst.cmd and add:
           copy /y %_source%\programs\peinst\default %_target%\minint\system32\config >NUL:
           copy /y %_source%\programs\peinst\software %_target%\minint\system32\config >NUL:
           before line saying "PEINST: Installation completed...".
               
_setupisolinux if yes it will copy isolinux directory in the Image, also will setup needed mkisofs options, a sample config
               togheter with base files is included.
               
_mkisofs set this to no only for debug, it will prevent mkisofs call.

NOTES:
 - don't press stop button while real mkisofs is running or you will need to kill it by hand (taskmanager) or wait its end.
 - if sortfile doesn't exists -sort option will not be used
 - if filecase.ini is processed and no errors (except not found) occur, then -U option is added to mkisofs

Sources (GPL) for InfCacheBuild program can be found on my winpe page: http://winpe.sourceforge.net/

HISTORY:
20050305:
 - removed lain image, made a small menu using syslinux menu api (sources included)
20050321
 - Update fakemkisofs to call wrapper.cmd with CreateProcess instead of using system() call
20050322
 - Call wrapper.cmd using cmd.exe, also set the current directory where is located the executable
 - Update InfCacheBuilder.exe executable with the one versioned 1.7.0.0, no changes
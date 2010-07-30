XPE Plugin (c) 2005-2007 Sherpya [Gianluigi Tiesi]

LICENSE:
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Library General Public License for more details.

You should have received a copy of the GNU General Public License
along with this software; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

This license applies to all program used, sources are "shipped" in a separate file
also applies to all inf stuff, most of the "code" in inf files is taken from others.

NOTE:
Permission is also granted to distribuite this plugin in any form also without adding sources, but
only if this file and xpe.htm are present and only if compiled programs are unchanged.
If you modify my programs, you must add modified sources to the distribution to respect GPL license.
So if you want to include this plugin in a magazine, cdrom or similar, you can safely do it.
I would prefer to be informed, just to known that my job is usefull :)
Changing resources of executable is also permitted (except for copyright notices), so you can safely
replace the XPELogon splash bitmap if you want.

Known Issues:
- You must not have a non writable Registration directory in windows directory or most of dll registration will fail
- Registry changes are not saved (WinPE limitation)
- Dns service doesn't work in RIS/PXE mode (WinPE limitation)

TODO:
- Apply, File Properties are not localized
- msdxm.ocx does not register correctly
- Fix default mixer settings
- Fix eject on w2k3 (postponed until new infos)
- Set IE home page in w2k3, ie4uinit.exe resets it to the admin page
- Fix "first time" osvc - usb storage hotplug without patching usbhub.sys
- Add appdata variable at runtime, it's only possible if issued by xpeinit and with xpelogon -e enabled
- USB Storage no more working? XPE bug or something changed in vmware 5? - !!!Regression!!!

History:
version 1.0.7:
 - Added mfcsubs.dll, maybe needed for com stuff
 - Fixed fonts in IE search bar, thanks to d4vr0s
 - Moved psbase.dll and pstorec.dll to main inf, prevents ie freeze when filling a form (closes #1602972)
 - Disabled IE PopUp when submitting a form, thanks to TheHive
 - Fixed build on win2k3 SP2
 - Added Partition Manager registry keys, as suggested by mustang
 - Added -x option to XPEinit to fix all wmp path issues
 - Removed explicit calls to unregmp2.exe to avoid creation of bad links
 - Removed nu2menu and autorun plugin stuff, I think not used by anyone
 - Added msxml2 and msxml3 to support new ajax technologies like gmail portal

version 1.0.6
 - Bug fix only
 - Fix crash in xpeinit -w, spotted in vs2005 build (I was writing to a read-only memory area)

version 1.0.5
 - Build binaries with vs 2005
 - Corrected grammar of xpe.htm, thx to Ross Smith II
 - Added ddraw.dll to xpe-directx as suggested by FeReNGi
 - Look for emptyregdb.dat in host Windows installation, tip from cdob
 - Removed association for jar to Compressed folder, tip from ceroni

version 1.0.4
 - Added a distribution grant notice in the readme (for cdroms/magazines)
 - XPELogon: added -x option to avoid integrity checks (Registration dir / shell32 locale mismatch)
 - Moved crazy copy bug workaround in z_xpe-custom.inf and added an info in the help
 - Added udfs support (untested) - cdob
 - Removed Help Support menu, replaced with favorites, users like much more this :)
 - XpeShutdown doesn't overwrite anymore PostBootReminder key, anyway PostBootReminder key is deleted by XPEinit
 - XpeShutdown: fixed W2k3 SP1 problem by adding a fake DllGetClassObject
 - W2k3 SP1 doesn't freezes explorer anymore when right click on desktop/taskbar (microsoft fixed the bug)
 - Disable by default tray eject stuff on W2k3 since it doesn't work, also xpelogon
   crashes when ok button of the Eject Media error is pressed
 - Fixed syntax errors by using Shadrach tool
 - Added a check in pegina (to be sure) as suggested by paraglider
 - XPELogon: added NoProcessKill and NoStopServices keys to skip stop of process/services
 - XPELogon: added password lock, call XPELogon -5 your_password, and the md5 hash will be generated and copied
   into your clipboard, you must add the value in the correspective z_xpe-custom.inf setting
 - XPELogon: Really kill processes after sending WM_CLOSE and WM_DESTROY
   (skipping winlogon.exe, smss.exe, csrss.exe, lsass.exe, services.exe, svchost.exe)
 - Fixed rpc service on W2k3 SP1 - thx to goldfinger
 - Added a note in xpe.htm explaining to avoid entries like %FILE_FOLDER% in explorer using W2k3 SP1 (pebuilder bug)
 - Added laptop battery files, I couldn't test it, so send me feedbacks
 - WMI Support for W2k3, the pre-made Repository directory should be named Repository-w2k3
 - Added Context Services menu to My Computer
 - Fixed chinese locale it was traditional not simplified also added missing translations strings - thx to BrianLee
 - XPELogon: added different handling for password lock, now it's possible to lock xpe depending on media that starts xpe
   look in z_xpe-custom.inf
 - Included some settings from reatogo
 - Removed some themes related files, until themes are not working they are only wasting space

History:
version 1.0.3
 - Re-enabled default profilesdir in xpe-defaults.inf
 - Added a switch to enable environment reload in XPELogon (disabled by default)
 - XPELogon: Changed the dialog now includes a bitmap, also removed the hide on click "feature"
 - Fix nu2xpe RunOnceEx clash be sure to use updated entry taken from template 1.0.3 of z_xpe-custom.inf.sample
 - Corrected wrong setting in xpe-default/z_xpe-custom that prevents xpe to access windows shares:
   ControlSet001\Control\ComputerName\ComputerName should be DIFFERENT than the one specified by
   barte.exe -pnp -cn XXX command (or penetcfg one), be sure to correct your z_xpe-custom.inf according
 - Fix to nestat.exe, it only needs inetmib1.dll and not wmi - Malice
 - User selection dialog in Permissions - aavroniev
 - XPELogon: fix potential crash when reloading env, patch by Bruce <bonehead_coder@yahoo.com>
 - Added Dutch translation, from: Ruud van den Hout <ruud.vd.hout@planet.nl>
 - Don't complain if net start eventlog fails
 - XPELogon: fixed dialog centering routine
 - Added an option to enable Winlogon shell registry setting (-h)
 - Added locale check between shell32.dll and windows source, using a different localized shell32 will cause empty start menu
   i.e. don't use modified english shell32.dll on a different locale
 - Added a reg fix for windows xp sp2 share problem: winpe-xpsp2-fix.reg
 - XPEInit: Use control instead of shift to skip xpeinit actions

History:
version 1.0.2
 - Fixed usb storage hotplug, you need to add your device id to the custom list in xpe-custom, see help
   Thx to Yurkesha for pointing me to the problem
 - Remove some stuff from wmi, my hope is to solve the crazy cdrom access
 - Added Computername to custom settings, you should take the key from the current template, this should solve rpc problems
 - XPELogon and XPEinit have localized messages (make sure to fix Locale in your custom file)
 - XPEinit: fix execution in RunOnceEx part, it should not be always hide the window
 - XPEinit: added -9 option to remove resource limit, courtesy of Pierre Mounir (TheTruth),
   look for update line in z_xpe-custom.inf.sample
 - XPELogon: added an option to disable prompt after ejecting media, look at EjectPrompt in z_xpe-custom.inf.sample
 - XPEinit: added following options -0 for shutdown and -6 for reboot (0 and 6 remind you something?), please note
   this is not handled directly by XPEinit, it only sends the message to XPELogon
 - z_xpe-custom.inf.sample: added /UseProfile to penetcfg line, update your z_xpe-custom.inf according
 - XPELogon: Set Winlogon Shell value according user selected shell, so if you use nu2menu as shell explorer will start as filemanager
 - XPELogon: added WM_SETTINGCHANGE support and runtime profilesdir selection
 - Fixed systray volume icon for w2k3
 - XPELogon: added shutdown.cmd callback, when xpe reboots or shutdowns calls %SystemRoot%\system32\shutdown.cmd before stopping
   services

version 1.0.1
- Fixed typo in xpe-pnp.inf to disable driver signing
- Fixed directx (dxdiags is happy now)
- Fixed name clash with swenum (thx to aec)
- File backward compatibility with xp sp1 (only avoids errors on build), xpe will not work in sp1
- Added hta support
- Fixed shortcut creation when file doesn't exists, also moved to a standalone stuff: xpeinit.exe -l, moved to RunOnceEx 999/999
- Added a new options to XPELogon.exe, -w that disable desktop switching (this implies winlogon resource limit)
- xpe.inf: removed app compatibility stuff, it prevents to run older versions of winnt32.exe, also it should display a message
  saying this, but I only get messages of ahui.exe if I patch it
- Updated and restyled xpe.htm
- Splitted xpe-pnp in xpe-directx and xpe-wmp (windows media player 9 plugin plus ActiveX stuff)
- Working Windows Media Player 9
- Rewritten from scratch audio drivers infrastructure to better handle "upstream" upgrades
- Added more options for setting ie proxy, NOTE: the meaning of ProxyEnable is changed, previous default now will mean no proxy,
  you must take a look at changes is z_xpe-custom.inf.sample
- Removed some dynamic registrations from RunOnceEx and made it static, this should speed-up a bit
- Removing testing plugin
- Added upgrade section, I can develop an automatic updater someday
- Removed small start menu icons setting, doesn't work anymore :(
- Fixed some font stuff
- Working WMI!!! (xponly) Read xpe.htm - many thx to vaibhav

version 1.0.0
- SP2 Compatibility, SP1 is not supported anymore
- Removed some Italian localized strings
- Fixed RpcSS + DComLaunch Services
- xpe-pnp.inf: added Bluetooth classes and files (not sure if it works)
- xpe-pnp.inf: added a workaround to avoid firefox (and other apps) freezing when using audio without an audio card/drivers
- added com, wbem and setup subdirs to path (removed some duplicates files from wmi)
- Added some missing javascript entries thx to azure
- Removed AppData env var, since it's localized -> TODO create it in xpeinit
- xpe-crypto.inf: updated to sp2
- xpe-helpsys.inf: updated to sp2, moved binaries to the right location, added helpsys binaries to Path variable
  Missing Help Resource files... where I can find these files?
- xpe-mmc.inf: updated to sp2
- xpe-pnp.inf: updated to sp2
- xpe-wmi.inf: updated to sp2, but disabled... it does something different in sp2, but no clue for now,
  winpe opk will have wmi layer, then wmi in winpe now should be possible. Repository directory moved to %temp%.
- xpe-custom.inf moved to xpe-defaults.inf, created a z_xpe-custom.inf to handle user customizations across release,
  this file will be distribuited as z_xpe-custom.inf.sample and it needs to be renamed to z_xpe-custom.inf
- XPEinit.exe: added -y option to fix ignore on driver signing
- XPELogon.exe: added -n option to hide progress bar
- XPELogon.exe: added a check for existance and writability of Registration directory, if it exists and is not writable, it
  will warn the user
- Added some stuff of themes support (not working)
- Fix for the "crazy copy" bug (pebuilder bug or windows xp eng sp2 inf bug??)
- System locale cannot be set at runtime so I've added locale settings to z_xpe-custom.inf

version 0.9.9
- Changed system32\*.*=2,,4 in system\*.*=2,,4 since it causes problems if there is no system32 dir inside xpe plugin directory
- Added a registry option (in xpe-custom.inf) to hide Eject Media Tray Icon, modified XPEShutdown
- Added some dx stuff from sala, most of them has been reworked to fix into xp sp1 directx version (8.1) and w2k3 version
- XPEInit: -s if used as proxy returns always 0, even if the command fails (this is used by net start tcpip when booted from pxe)
- XPELogon/XPEShutdown: disable tray and eject function if %SystemDrive% is not REMOVABLE or CDROM (booting using pxe)
- xpe.inf: added slayerxp.dll that enables app compatibilty tab
- xpe.inf: added netid.dll that enables network domain/workgroup tab
- XPEinit/SetRes: added XPELogon window message while fixing resolution, also added CDS_UPDATEREGISTRY so it should update
  also registry. This should prevent dxdiag from setting resolution to 640x480
- Added -f to xpeinit bartpe.exe -pnp (without this some stuff will freeze like services snapin)
- XPEinit/RunOnceEx: rewrite of runonceex using stl, since RegEnumValues keys are not sorted, changed the msg to XPE Processing...
- XPEinit: Fixed proxy settings for Internet Explorer, just modify values in xpe-custom.inf and XPEinit will setup proxy settings
- Removed My Documents from Desktop since it's bugged (autorefresh)
- XPELogon: workaround for winlogon resource limit (not memory patch), you don't need anymore patched winlogon.exe
- xpe-custom.inf: Added workgroup to bartpe.exe -pnp so xpe can browse the net
- xpe.htm: updated a bit some references to old stuff
- xpe-mmc.inf: Added working NtBackup and Service, catalogs are stored in %temp%\NtmsData (it's raises an error at startup but it works)
  Disable volume shadow copy
- Accepted some fixes/addons from Ortega, fafot and JamesB, also moved some stuff in xpe-custom.inf (Note I've not tested all the customizations)
- Fixed systray applet for w2k3
- Proposed a solution based by a cdob's suggestion about font with some locales, all fonts are now copied and font settings are added
  in xpe-custom.inf, just select your case

version 0.9.8
- Added some missing dll registrations in xpe-pnp.inf (thx to sala)
- Removed %SystemRoot%\System32 path from all references xpe-pnp.inf
- Removed some entries in direct show tree that are without corresponding dll in xp sp1
- All infs fixed ImagePath keys
- Rewrite of all DirectX/DirectShow stuff
- Added some media files for base events
- Fixed potential deadlock in shutdown/reboot procedure
- Added XPEinit -d = RunOnceDel.exe (Removed RunOnceDel.exe executable)
- Added XPEinit -z -> select the best refresh rate for current resolution, read note and uncomment it in xpe-custom.inf
- Better integration with w2k3:
  + There are now xponly and w2k3only sections
  + Fixed wallpaper settings
  + Fixed quicklaunch and Disk manager on win2k3 - Thx to Jan Schunk
  + Fixed directshow
- By default unknown devices are hidden, you can display it selection show all devices in device manager snapin
- By default my own drivers in inf files are disabled to avoid overwriting files from other plugins
- Added CleanMgr & CharMap, also added some other customizable settings to xpe-custom.inf as suggested by Eiffel
- Added Eject Media support (xponly) before shutdown/reboot, the default can be configured in xpe-custom.inf, but it also can be changed by the tray icon I've added
- Moved some stuff from xpe-custom.inf to xpe.inf (SourceDisksFiles) and moved PageFile settings to xpe-custom.inf (may be usefull to set swapfile to ramdisk?)
- Added oem bitmap: HP -> Horse Power ;)
- Added new plugin XPE Testing, mainly for testing new stuff, you shouldn't enable it
- XPE Testing: Preliminary Theme service support (it starts but changing a theme has no effect)
- XPE Testing: Added Msi Installer Service and stuff, I'm not sure it's really usefull anyway it adds only few kb
- XPE PnP: dll\* path changed to system32\* since it has also exe files
- Removed gdiplus.dll workaround, I think is not needed anymore
- Added categories to start menu and added also new items
- XPELogon: added window position to put his windows in a different place (look in xpe-custom.inf)
- XPEInit sets AdvpackLogFile to %temp%\Logs\Advpack.log (expanded)
- XPE HelpSys some minor tweaks, help service starts

version 0.9.7
- Fixed crypto support thanks to Dilbert
- Internal Rewrite of RunOnceEx (xpeinit -r) - this speeds up only 1 sec  (on a virtual machine) ;(
- XPELogon: added -r option to call internal RunOnceEx and -p to profile boot time, it will display a msgbox with the time elapsed
- Added pnp support by using internal RunOnceEx then calling explorer
- Setupapi now logs in %temp%\Logs, this can tell some usefull info about driver installation
- Audio/Video/DirectX/MediaPlayer/Partial Usb - needs a different procedure see xpe.htm
- PeNetCfg works as normal just uncomment the corresponding line in xpe-custom.inf
- Cleaned up all the code, thx to Squale for the help
- XPELogon now can execute a different shell rather then explorer, just uncomment the corresponding line in xpe-custom.inf (in [Software.AddReg])
- Updated infs to use new flash plugin (requires additional download)
- Added additional help in xpe-custom.inf

version 0.9.6
- Now I use buildnr to copy files only if building winxp
- XPE on hd should work, a bit tricky see html help
- Added Trax patch to fix Admin Tools in control panel
- Corrected wrong dest dir in xpe-wmi.inf
- Added download link for latest flash plugin (look into xpe.htm)
- XPEinit syntax change: now as a proxy application now accept -f (to force load also with shift key pressed) and -m to change
  title of XPELogon window, update your plugins
- Updated XPEinit/XPELogon
- XPEinit: Added expansion to params and icon location in shortcut creation
- Updated xpe.htm docs

version 0.9.5
- Changelog of 0.9.4 said XPEshudown fails silent, but updated xpeshutdown.dll was not in the package
- Added a check to xpelogon so if explorer dies before starting it will popup a MessageBox
- Fixed Desk.cpl stuff, thanks to 2ch.332 and team
- Made This file ;)
- Added StartMenu key for xpeinit to put shortcuts on the root of start menu
- Added Net Shares (it works as service and in mmc but I'm not sure it really works, anyway thx to Trax for the tip)
- Thx to PEBuilder >= 3.0.24, now there is no need to disable, comment out stuff using it with w2k3
- gdiplus.dll is taken from @SourcePath@\i386\ASMS\1000\ and @SourcePath@\i386\ASMS\10100\ this should
  copy first gdiplus.dll from 1000 (old version) and then if exists 10100 (new version) will overwrite the old one
- Fixed XPELogon caption weirdness - it was fighting to use unicode or not
- Added info to setup XPE + nu2menu + n2parser + autoramresizer in xpe.htm, also updated xpe.htm
- Added examples to adding custom help files on desktop as FlukserCDS suggested
- Added "Fonts addons" from winnydows

version 0.9.4
- Added Ctrl_alt_del to XPELogon, it brings task manager, thx trax for the tip
  you can also customize the program launched, look in xpe-custom.inf
- Fixed shortcut names with dots in XPEinit.exe
- Nls registry values should be automatically filled by xpeinit, tell me if it fills with wrong values
- TaskbarSizeMove and TaskbarGlomming moved to xpe-custom.inf
- XPEshudown dll fails silent now if XPELogon window is not found
- XPELogon has now a nice progress bar, also removed timeout for hiding window, just click on it to hide
- Added a note in html help file to "fix" incompatibilities with msado and other plugin that create Registration dir in system32
- Re-enabled autorun0xpe.cmd to launch xpe and nu2menu all together

version 0.9.3b
- No XPE plugin changes
- Changed shutdown system, it should be more compatible (added pegina.dll, a proxy dll)
- Rewritten Shutdown "Emulation" in XPELogon
- Public Sources of all the used stuffs

version 0.9.3:
- Moved winlogon background color to xpe-custom.inf
- Added control panel to My Computer, thx trax for the tip
- HelpSys is now compatible with w2k3
- Added Screen Resolution (default 1024x768 16bpp) and mouse whell stuff in xpe-custom.inf
- Added Memory Management stuff
- Moved StartMenuAdminTools=YES to xpe-mmc.inf so it won't show if mmc is disabled
- Fixed XPEinit startmenu with nested directories
- Added Register/Unregister Server context menu for dll/ax/ocx
- Modified RunOnceEx option for penetcfg 2.0
- Removed some redundant directories since they are in layout.inf
- Moved w2k3 exclusion files in xpe-custom.inf so the user can disable it at once, also updaded xpe.htm
- gdiplus.dll is now automatically copied to %SystemRoot%\System32, this works only for winxp, since w2k3 stores
  it in a different location. gdiplus.dll in system32 is not needed for w2k3 (winxp bug?)
- Made XPELogon a process that restarts explorer if die, also XPEShutDown.dll intercepts shutdown dialog
  and signals XPELogon to shutdown/restart. It uses PostBootReminder "placeholder"
  (Yes XPELogon window is ugly... I'll make a nicer one later)
  at least standard windows shutdown panel works... (reboot/shutdown are not handled by windows but by XPELogon)
  Also NOTE: on some locales it can crash explorer I cannot test all windows versions, and it's not compatible
  with w2k3 (i.e. if u select shutdown explorer will crash and xpelogon will reload it)

version 0.9.2:
- added command prompt here shell extension, as winnydows suggested, it says only "Command Prompt" since
  is localized and I've no localized "Command Prompt here" string
- Moved MMC to Administration Tools folder (localized)
- Removed timeout in xpeinit proxy mode it can hang but at least it doesn't kill netpecfg.exe
- Added -force option to xpeinit proxy to avoid bypassing needed actions like autoramresizer etc:
  e.g. 0x1,"Microsoft\Windows\CurrentVersion\RunOnceEx\500","103","||xpeinit.exe -force net.exe start EventLog",
  will execute even if shift key is pressed
- Updated xpe.htm to explain gdiplus problem/solution
- Added options to customize Desktop items name (look xpe-custom.inf)
- Recycle bin feature and desktop icon disabled by default, you can re-enable it editing xpe-custom.inf
- XPE now defaults to standalone mode, if you want to use it called by nu2menu comment this line in xpe-custom.inf:
  0x1,"Setup","CmdLine","Explorer.exe"
  Also note autorun stuff will be handled using RunOnceEx and wrapping it with xpeinit, look in xpe-custom,
  Autoramresizer is "preconfigured", but if it's not enabled, xpeinit will just ignore it, for network settings,
  I'm using netpecfg.exe 1.5.1 so I pass -noask -nogui options, if you are using different network startup, you need
  to tweak it. Holding shift key while loading will skip network autoload procedure
- Moved loaderprompt to xpe-custom.inf
- XPEinit now checks for HKLM\Software\Sherpya\Safe before starting, this prevents xpeinit from running over
  a normal windows installation (My windows was using Start Menu as StartUp folder.... ;)),
  obiviously don't add the key on you windows installation nor removed it from xpe-custom.inf

version 0.9.1:
- xpeinit supports environment expansion when used as launcher
- when using xpeinit as "proxy" to launch applications it will just exit if SHIFT key is pressed
- when used not standalone (called by nu2menu), it deletes RunOnceEx keys non in range 400-600 so putting stuff in keys < 400 and > 500
  will be executed only in standalone mode
- Added QuickLaunch and SendTo sections to Xpeinit "shortcut-er" ;)
- working .hlp support also with search
- Fixed images in internet explorer (dunno how, as a side effect of some other stuff)
- Problem with image files associations can be resolved for now putting gdiplus.dll into xpe plugin folder - it seams an asm sys problem, I've no clue right now
  you can find the file into C:\WINDOWS\WinSxS directory, You must also uncomment the corresponding file line: gdiplus.dll=2,,1

version 0.9:
- Localized "Documents And Settings", this plugin now requires pebuilder >= 3.0.20
- Moved nls to right place
- changed xpeinit, moved all stuff to registry, now supports strings table lookup, use @mydll.dll,-1234 as format,
  also it make dir hierarchies
- Splitted: another plugin to make "Visual & Cosmetic changes"
- Splitted: mmc
- Splitted: HelpSystem
- Fixed Double icons on desktop, see xpe-custom.inf for details
- Removed some files since they are not in all windows versions
- Moved "services" stuff to mmc plugin
- Made html help file to explain some possibile customizations/integrations
- Removed Internet Explorer Nu2Menu entry, since isn't needed
- XPEinit.exe contains icons for blank and small arrow shortcuts, also added a nice main icon
- XPEinit.exe with cmdline parameter can be used as "silent" runner, like "xpeinit.exe net start EventLog"
- XPE is now working as standalone shell (i.e. without nu2menu/autorun) - Look into customization plugin to find more
- Fixed problem with autoramdiskresizer plugin, if loaded in RunOnceEx, you need my autoramdiskresizer plugin v1.1 for this (then look in customization plugin)
- XPE is almost compatible with w2k3, you must disable XPE WMI plugin and comment out swflash.ocx=2, disk manager hangs - still investigating

version 0.8:
- Added Flash plugin for ie
- Added Help System hlp/chm support (.hlp files don't work)
- Moved "movable" MMC registrations to "static" == speed improvement
- Removed some redundant stuff
- Cosmetical/Bug Fixes
- Fixed Font Smoothing, TaskBar autohide
- https/certs stuff moved to XPE Crypto Plugin, not yet working ;(
- Removed (until they are working) non working stuff in Start Menu, boyz happy?
- (Shutdown button still required to make explorer write settings, and track them)
- Removed PostBootReminder Ballon
- My Documents points now to %temp%
- WMI moved to XPE WMI Plugin
- Working EventLog, partial WMI
- Renamed all %RamDrv% with %temp%, this will make easy to use a r/w media
PE Network Configurator v2.20
A network configuration tool for WinPE (Win2K/XP/2K3)
Copyright © 2003-2004 by Pierre Mounir (TheTruth)
All rights reserved.


Changes:
v2.20:
+ Redesigned the "File Sharing" Dialog.
Now,
   * You can open the "File Sharing" dialog at any time regardless of the "File Sharing" service state (installed/uninstalled/started/stopped).
   * You can start/stop the "File Sharing" service at any time.
   * You can share/unshare all drive's roots while you're starting "File Sharing".
   * You can select an administrative account (to set/reset its password) from a list of existing administrative accounts on the local machine or create a new one. This fixes a bug that prevented users of some localized versions of Windows to set a password for the built-in administrative account, and in the same time, allows you to achieve a "Single Logon" on your network through creating a new administrative account that has the credentials of an existing network account.
   * You can predefine an adminstrative account in a network profile through the newly added key "AdminAccount" in the "FileSharing" section, refer to the documentation below for more info.

+ Added a new section to the network profile called "PostNetAutRun", this section will allow you to run as many programs as you want after network support has been started, refer to the documentation below for more info.

+ Made major changes to the routine responsible for restarting a network adapter's LAN connection to apply TCP/IP settings.
I hope this will solve the occasional probelm of some users who reported losing the connection to one of their NICs upon applying TCP/IP settings on machines with two or more NICs.

+ Made some registry related changes to syncronize the TCP/IP parameters under a network adapter's driver service key with those under the TCP/IP driver service key (not required, but to match Windows shell operations and be in the safe side just in case there is a program that depends on those keys instead of using the IP Helper APIs).


v2.12:
+ Added toolbar button for refreshing (reloading) network settings.
+ Added some more check routines for important network parameters.
+ Made some improvements to the network drives mapping functionality.
Now, if no complete user credentials are provided, the default user credentials (primary logon credentials or cached logon credentials) will be used first for authentication before popping up the logon dialog. This reduces the number of logon dialogs shown when mapping more than one network drive through a network profile in interactive mode.


v2.11 build-1:
+ Fixed a bug that required the user to click "Cancel" too many times before it was able to cancel the dialog prompting for user credentials that was shown when mapping network drives through a network profile in interactive mode. 


v2.11:
+ Added support for using "bartpe.exe" to start network support.

Note: To start network support you must have either 
{"factory.exe", "netcfg.exe"} 
or 
{"bartpe.exe"}
under the "System32" folder.
if both sets of files exist, PENetCfg will use "factory.exe" & "netcfg.exe".


v2.1:
+ Added support for starting File Sharing service (Server service) either throuh the GUI or a network profile with ability to set the Adminisrator's password and share all drives' root folders. (this can be handy in situations when you're infected with a virus in a machine and have a powerfull virus scanner with the latest virus signatures on another machine).

+ Added support for automating mapping network drives through a network profile.

+ Added support for presetting the Link Speed/Duplex Mode throuth a network profile.

+ Added support for setting the Primary DNS Suffix (DNS domain name) throuh the GUI or through a network profile.

+ Added section to the network profile to allow you to provide notes about any profile that will be shown in the "Network Profiles" dialog for each selected profile.

+ Redesigned the GUI to fit on monitors with screen resolution of 640x480 pixels.

+ Now "PE Network Configurator" is fully functional under the Win2K/WinXP/Win2K3 environments.

v...
.
.
.

v1.0:
+ The first public release.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The syntax of PENetCfg at the command line is as follows:

PENetCfg [/UseProfile:[profile_name]]

- If no parameters were passed, PENetCfg will run as usual without using any network profiles.

- /UseProfile:[profile_name]        loads the network profile with the name "profile_name" to use in automating network settings.
If the network profile is located in the same folder as PENetCfg, you can provide only the file name without any path, otherwise you must provide the full path and put it in quotes if it contains spaces.

if no profile name is provided, PENetCfg will search in the same folder for a file with same name as PENetCfg but with the extension ".ini" and use it as the network profile if found. So if the executable file that started PENetCfg is named "PENetCfg.exe", PENetCfg will search for "PENetCfg.ini" in the same folder to use as the network profile.

Examples:
PENetCfg /UseProfile
PENetCfg /UseProfile:Work.ini
PENetCfg -UseProfile:"C:\Net Profiles\Work.ini"
PENetCfg -UseProfile:%SystemRoot%\System32\Work.ini

Very Important note:
Network profiles will be used only when PENetCfg is going to start network support. If network support is already started, no network profiles are used even if you explicitly provide it via the command line parameter.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Here is a sample network profile that configures network settings for the first two network adapters detected:

--------- start of profile --------------
; This is a comment.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[General]
AutoStartNet     = No
PromptForProfile = Yes
ShowGUI          = Yes
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[NetProfiles]
Home Profile = Home.ini
Work Profile = "%SystemDrive%\Net Profiles\Work.ini"
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[NetID]
ComputerName     = WinPE
Workgroup        = MCSE
PrimaryDNSSuffix = microsoft.com
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[FileSharing]
StartFileSharingService = Yes
AdminAccount            = Pierre
; AdminPassword         = 123456
; AdminPassword         = * (to be prompted for a password)
AdminPassword           = *
ShareDriveRoots         = Yes
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[NetAdapter1]
; SpeedAndDuplex = {10|100|1000},{Half|Full}
; SpeedAndDuplex = Default (for default settings)
SpeedAndDuplex   = 100,Full

EnableDHCP       = No
UseStaticGateway = No
UseStaticDNS     = No
UseStaticWINS    = No

IPAddress        = 192.168.75.2,192.168.75.3
SubnetMask       = 255.255.255.0,255.255.255.0
DefaultGateway   = 192.168.75.230
DNSServer        = 192.168.75.200,192.168.75.201,192.168.75.202
WINSServer       = 192.168.75.150

[NetAdapter2]
SpeedAndDuplex   = Default

EnableDHCP       = Yes
UseStaticDNS     = Yes
DNSServer        = 192.168.1.100
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; You can map up to 10 network drives: [NetDrive1] ... [NetDrive10];
[NetDrive1]
; Drive     = X:
; Drive     = * (to use the first available drive letter)
Drive       = X:
NetworkPath = \\WinXP\Software
UserName    = Pierre
; Password  =  (leave it empty to be prompted for a password)
Password    =

[NetDrive2]
Drive       = *
NetworkPath = \\Win2KDC\D$
UserName    = Pierre
Password    = 123456
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[PostNetAutoRun]
; StarupFlag = CommandLine

; StartupFlag is a bit field that can take the following values:
; 0 = run hidden and wait 	    (00 00 00 00)
; 1 = run normal and wait 	    (00 00 00 01)
; 2 = run hidden and don't wait (00 00 00 10)
; 3 = run normal and don't wait (00 00 00 11)

3 = %SystemDrive%\Programs\BGInfo\bginfo.exe %SystemDrive%\Programs\BGInfo\bginfo.bgi /timer:0
0 = %SystemDrive%\Programs\Ghost\Ghost.cmd
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[Notes]
Computer Name      : WinPE
Workgroup          : MCSE
Primary DNS Suffix : microsoft.com
SpeedAndDuplex     : 100 Full
IP Address         : 192.168.75.2
Subnet Mask        : 255.255.255.0
DNS Servers        : 192.168.75.200,192.168.75.201 
Start File Sharing : Yes
Create new account : Pierre
Map drive X: to \\WinXP\Software
Map the first available drive to \\Win2KDC\D$
This profile configures network settings for use with VMware Workstation.
--------- end of profile ----------------

As you can see, the network profile consists of sections and each section contains entries in the form "Key = Value" pairs.
All entries are optional, hence all sections are.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Here is an attempt to document the sections and their entries in a complete network profile:

Note: The "Default" value means the value that PENetCfg will use in case the whole entry is missing or the "Value" portion of the "Key = Value" pair is not provided.

+++ Section: [General]
This section controls the unattended behavior of PENetCfg.

++ Entry: AutoStartNet
This entry gives you the option to confirm starting network support or not.
+ Value: {Yes|No}
- Yes: Starts network support without confirmation.
- No: Confirms starting network support.
+ Default: No

++ Entry: PromptForProfile
This entry gives you the chance to select another network profile at startup instead of using the current profile.
+ Value: {Yes|No}
- Yes: makes PENetCfg process the list of network profiles provided in the section [NetProfiles] and prompt you at startup to select one of them or browse for another on any storage medium.
- No: makes PENetCfg use the current network profile without prompting you to select another one.
+ Default: No
Note: If you select another network profile at startup, PENetCfg will not process the [General] section again in this new profile. The [General] section is processed only in the first network profile passed through the command line parameter.
If you cancel the network profiles dialog (not selecting any profile), PENetCfg will use the current network profile.
 
+ Entry: ShowGUI
This entry gives you the option to show the main window of PENEtCfg or not.
+ Value: {Yes|No}
- Yes: makes PENetCfg show its main window after starting network support.
- No: makes PENetCfg quit after starting network support.
+ Default: Yes


+++ Section: [NetProfiles]
This section allows you to provide a list of network profiles to select one of them at startup and will be processed only if the "PromptForProfile" key is set to "Yes".

Each entry in this section has the form: profile_display_name = profile_path
- profile_display_name: is the name that'll be shown when PENetCfg provides you with the list of network profiles to choose among them.

- profile_path: is the file name and path to your network profile. If the profile is located in the same folder as PENetCfg, you can provide only the file name without any path, otherwise you must provide the full path and put it in quotes if it contains spaces.


+++ Section: [NetID]
This section allows you to set the computer name ,join a workgroup, and set primary DNS suffix.

++ Entry: ComputerName
this entry gives you the option to set the computer name.
If this entry is missing or the computer name is not provided, PENetCfg will ignore it and let WinPE set it to a random name.
Note:
If the value for the computer name is more than 15 characters, PENetCfg will truncate it to 15 characters.
If the computer name contains any invalid characters, PENetCfg will remove those characters.

++ Entry: Workgroup
This entry gives you the option to join a workgroup.
If this entry is missing or the workgroup name is not provided, PENetCfg will ignore it and let WinPE set it to the default workgroup (WORKGROUP).
Note:
If the value for the workgroup name is more than 15 characters, PENetCfg will truncate it to 15 characters.
If the workgroup name contains any invalid characters, PENetCfg will remove those characters.

++ Entry: PrimaryDNSSuffix
this entry gives you the option to set the primary DNS suffix (DNS domain name) for the computer.
If this entry is missing or the DNS suffix is not provided, PENetCfg will ignore it and let WinPE set it to the default value.


+++ Section: [FileSharing]
This section allows you to enable File Sharing (Server service).

++ Entry: StartFileSharingService
This entry gives you the option to enable File Sharing or not.
+ Value: {Yes|No}
- Yes: Installs and starts File Sharing service.
- No: doesn't enable File Sharing.
+ Default: No


++ Entry: AdminAccount
This entry allows you to provide the name of an administrative account, if this name doesn't match an existing administrative account on the local machine, PENetcfg will create a new administrative account. Otherwise, it'll just set/reset the password provided by the "AdminPassword" key.
Default: if no name was provided, PENetCfg will display the "File Sharing" dialog.
Note 1: If the name provided matches an existing account but this account is NOT a member of an administrative group, PENetCfg will show an error, and no accounts will be created.
Note 2: Because of the default security policy, at least, one administrative account must have a non-blank password. Otherwise, you won't be able to access any created shares.

++ Entry: AdminPassword
This entry gives you the option to set/reset a password for the administrative account provided by the "AdminAccount" key.
+ Value: {*|password}
- *: prompts you to provide a password.
- password: sets a password without prompting.
+ Default: *

++ Entry: ShareDriveRoots
This entry gives you the option to share all drives' root folders or not.
Note: this entry has nothing to do with the "Administrative/Hidden Shares" started with "$", they are created automatically upon starting Server service.
+ Value: {Yes|No}
- Yes: shares drives' root folders of the following drive types:
       * Fixed disk drives.
	   * RAMD disk drives.
	   * CD-ROM drives.
	   * Removable disk drives.
	   and gives them the share names of their drive letters, e.g drive C: is shared as "C" (without the quotes), so you can see them through any network browser.
- No: doesn't share drives' roots automatically.
+ Default: No


+++ Section: [NetAdapterX]
This section allows you to provide the TCP/IP properties of any number of network adapter and set the Link Speed/Duplex Mode.

Actually, this is not one section but a series of arbitrary sections with the header name "NetAdapter" followed by an index that refers to the Xth network adapter.

For example, the section [NetAdapter1] corresponds to the first detected network adapter, and the section [NetAdapter2] corresponds to the second detected network adapter, and so on.
You can add as many sections as you want according to the expected number of network adapters on the destination machine.

++ Entry: SpeedAndDuplex
This entry gives you the option to set the Link Speed/Duplex Mode of a network adapter.
+ Value: {10|100|1000},{Half|Full}
- 10|100|1000: represents the required "Link Speed".
Half|Full: represents the required "Duplex Mode".
Default: if you leave this key empty or set it to "Default" or use unsupported value, the default setting of your network adapter will be used. 
Example: 100,Half

++ Entry: EnableDHCP
This entry gives you the option to obtain IP address automatically from a DHCP server or use static IP address(es).
+ Value: {Yes|No}
- Yes: obtains IP address automatically from a DHCP server
- No: uses the IP addresses provided by the key "IPAddress"
+ Default: Yes

++ Entry: UseStaticGateway
This entry gives you the option to provide static default gateway addresses in case you enabled DHCP.
This entry is processed only if you enabled DHCP.
+ Value: {Yes|No}
- Yes: ignores the default gateway addresses received by a DHCP server and uses those provided by the key "DefaultGateway".
- No: uses the default gateway addresses received by a DHCP server.
+ Default: No

++ Entry: UseStaticDNS
This entry gives you the option to provide static DNS server addresses in case you enabled DHCP.
This entry is processed only if you enabled DHCP.
+ Value: {Yes|No}
- Yes: ignores the DNS server addresses received by a DHCP server and uses those provided by the key "DNSServer".
- No: uses the DNS server addresses received by a DHCP server.
+ Default: No

++ Entry: UseStaticWINS
This entry gives you the option to provide static WINS server addresses in case you enabled DHCP.
This entry is processed only if you enabled DHCP.
+ Value: {Yes|No}
- Yes: ignores the WINS server addresses received by a DHCP server and uses those provided by the key "WINSServer".
- No: uses the WINS server addresses received by a DHCP server.
+ Default: No

++ Entry: IPAddress
This entry allows you to provide static IP addresses to use in case you disabled DHCP.
+ Value: IP_Address1[,IP_Address2[,IP_Address3[,...]]]
- You can provide as many IP addresses as you want separated by a comma (,).
+ Default: If you don't provide any IP addresses, or all provided IP addresses are invalid, PENetCfg will revert to using DHCP.
Note: If any of the IP addresses contains invalid value for any of its octets, PENetCfg will correct this automatically.
For example: the IP address 192.168.258.1 will be corrected to 192.168.255.1 (octet value can't be greater than 255)
and the IP address 127.10.10.1 will be corrected to 1.10.10.1 (the value 127 of the first octet is reserved for the loopback address)
But IP address like this 155.214.1 will be considered as invalid IP address and will be removed (the last octet is missing).

++ Entry: SubnetMask
This entry allows you to provide the subnet masks for the IP addresses provided by the key "IPAddress".
+ Value: Subnet_Mask1[,Subnet_Mask2[,Subnet_Mask3[,...]]]
- You should provide as many subnet masks as those provided by the key "IPAddress" separated by a comma (,).
+ Default: If you don't provide any subnet masks, or all provided subnet masks are invalid, or the number of subnet masks is less than the corresponding IP addresses, PENetCfg will add the missing subnet masks to the end of the subnet masks list. Those subnet masks added by PENetCfg will be the default subnet masks for the network class of the corresponding IP addresses.

++ Entry: DNSServer
This entry allows you to provide static DNS server addresses.
+ Value: DNS_Server1[,DNS_Server2[,DNS_Server3[,...]]]
- You can provide as many DNS server addresses as you want separated by a comma (,).
+ Default: If you don't provide any DNS server addresses, or all provided DNS server addresses are invalid, and DHCP is enabled, PENetCfg will use those received by a DHCP server even if you explicitly set the key "UseStaticDNS" to "Yes".

++ Entry: WINSServer
This entry allows you to provide static WINS server addresses.
+ Value: WINS_Server1[,WINS_Server2[,WINS_Server3[,...]]]
- You can provide as many WINS server addresses as you want separated by a comma (,).
+ Default: If you don't provide any WINS server addresses, or all provided WINS server addresses are invalid, and DHCP is enabled, PENetCfg will use those received by a DHCP server even if you explicitly set the key "UseStaticWINS" to "Yes".


+++ Section: [NetDriveX]
This section allows you to map network drives.

Actually, this is not one section but a series of up to 10 sections: [NetDrive1] ... [NetDrive10], each section allows you to map a single network drive.

++ Entry: Drive
This entry gives you the option to select the network drive letter.
+ Value: {*|drive_letter}
- *: makes PENetCfg selects the first available drive letter.
- drive_letter: is the required network drive letter, e.g. "x:" (without the quotes).
+ Default: *

++ Entry: NetworkPath
This entry gives you the option to set the network path you want to map a drive to.
if this entry is missing or the network path is not provided, no network drive will be mapped and no errors will be shown.
Example: \\WinXP\D$

++ Entry: UserName
This entry gives you the option to provide the user name of the account used for network authenticatation.
if this entry is missing or the user name is not provided, you'll be prompted to provide it.

++ Entry: Password
This entry gives you the option to provide the password of the account used for network authenticatation.
if this entry is missing or the password is not provided, you'll be prompted to provide it.

+++ Section: [PostNetAutoRun]
This section allows you to run as many programs as you want after network support has been started, each entry represents a program to run in the form:

StarupFlag = CommandLine

; StartupFlag is a bit field that can take the following values:
; 0 = run hidden and wait 	    (00 00 00 00)
; 1 = run normal and wait 	    (00 00 00 01)
; 2 = run hidden and don't wait (00 00 00 10)
; 3 = run normal and don't wait (00 00 00 11)

Examples:
1 = %SystemRoot%\system32\Notepad.exe "%SystemDrive%\Help Files\Help.txt"
2 = "%SystemDrive%\My Scripts\Script.cmd"

+++ Section: [Notes]
This section allows you to provide notes about any profile that will be shown in the "Network Profiles" dialog for each selected profile.
You can add as many lines as you want, up to 32 KB in size.


Any constructive criticism, suggestions, comments are welcome.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Note:
bartpe.exe is Copyright (c) 2003 Bart Lagerweij. All rights reserved.


Regards,
Pierre Mounir (aka TheTruth)
E-Mail:	pierremounir@yahoo.com
WWW: http://www.geocities.com/pierremounir/

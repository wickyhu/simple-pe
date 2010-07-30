; ----------------------------------------------------------------------------
; Screen Lock Plugin Setup
;
; AutoIt Version: 3.2.1.3 (beta)
; Author: CWorks
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <GuiList.au3>
#include <string.au3>
#Include <GuiCombo.au3>

;Hash.dll needs to be in \Files| folder
#compiler_plugin_funcs = StringHash

Dim $count = "0"
Dim $Lock
Global $listbox, $ret
Opt("WinTitleMatchMode", 4)
$Skewed = "0"
#Region ### START Koda GUI section ###
If $Skewed = "1" Then
	$Main = GUICreate("Create ScreenLock Plugin", 396, 546, -1, -1, $WS_SYSMENU, $WS_DLGFRAME + $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST + $WS_EX_WINDOWEDGE + $WS_EX_CLIENTEDGE)
Else
	$Main = GUICreate("Create ScreenLock Plugin", 390, 524, -1, -1, $WS_CAPTION + $WS_SYSMENU, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST + $WS_EX_CLIENTEDGE)
EndIf
GUICtrlCreateGroup("Screen Savers", 8, 8, 377, 346)
GUICtrlCreateGroup("Local", 20, 28, 201, 142)
$listbox = GUICtrlCreateList("", 30, 46, 181, 131, $LBS_STANDARD + $LBS_DISABLENOSCROLL + $LBS_MULTIPLESEL, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
_GUICtrlListAddDir($listbox, "A,D,H,RO,RW", @SystemDir & "\*.scr")
GUICtrlSetTip(-1, "Copies files to ScreenSaver Folder")
GUICtrlCreateGroup("XP && 2k3", 228, 28, 145, 89)
$Blank = GUICtrlCreateCheckbox("Blank Screen Saver", 236, 44, 121, 25)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$XP = GUICtrlCreateCheckbox("Windows XP", 236, 70, 97, 17)
GUICtrlSetTip(-1, "Adds logon.scr from XP or 2k3 source at build time")
$Marquee = GUICtrlCreateCheckbox("Marquee", 236, 92, 97, 17)
GUICtrlSetTip(-1, "Adds ssmarque.scr from XP or 2k3 source at build time")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("XP only", 228, 124, 145, 217)
$FlowerBox = GUICtrlCreateCheckbox("3D FlowerBox", 236, 148, 97, 17)
GUICtrlSetTip(-1, "Adds ssflwbox.scr from XP source at build time")
$Objects = GUICtrlCreateCheckbox("3D Flying Objects", 236, 172, 97, 17)
GUICtrlSetTip(-1, "Adds ss3dfo.scr from XP source at build time")
$Pipes = GUICtrlCreateCheckbox("3D Pipes", 236, 196, 97, 17)
GUICtrlSetTip(-1, "Adds sspipes.scr from XP source at build time")
$Text = GUICtrlCreateCheckbox("3D Text", 236, 220, 97, 17)
GUICtrlSetTip(-1, "Adds sstext3d.scr from XP source at build time")
$Beziers = GUICtrlCreateCheckbox("Beziers", 236, 244, 97, 17)
GUICtrlSetTip(-1, "Adds ssbezier.scr from XP source at build time")
$Slideshow = GUICtrlCreateCheckbox("My Pictures Slideshow", 236, 268, 129, 17)
GUICtrlSetTip(-1, "Adds ssmypics.scr from XP source at build time")
$Mystify = GUICtrlCreateCheckbox("Mystify", 236, 292, 97, 17)
GUICtrlSetTip(-1, "Adds ssmyst.scr from XP source at build time")
$Starfield = GUICtrlCreateCheckbox("Starfield", 236, 316, 97, 17)
GUICtrlSetTip(-1, "Adds ssstars.scr from XP source at build time")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Default Settings", 20, 170, 201, 170)
$add = GUICtrlCreateButton("Refresh combobox below", 44, 190, 152, 25, 0, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetTip(-1, "Adds selected Screen Savers from above and to the right to combobox below")
$DSCombo = GUICtrlCreateCombo("scrnsave.scr", 48, 237, 145, 25, $CBS_SORT + $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL)
GUICtrlSetTip(-1, "Sets the default Screen Saver to use")
GUICtrlCreateLabel("Wait:", 62, 274, 29, 17)
GUICtrlCreateLabel("minutes", 144, 274, 40, 17)
GUICtrlCreateLabel("Sets the default Screen Saver", 47, 218, 149, 17)
GUICtrlSetColor(-1, 0xff0000)
$Wait = GUICtrlCreateInput("1", 94, 272, 42, 21, $ES_RIGHT + $ES_NUMBER, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
$updown = GUICtrlCreateUpdown($Wait)
GUICtrlSetLimit(-1, 100, 1)
$Startup = GUICtrlCreateCheckbox("Run at startup", 72, 305, 97, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetTip(-1, "Adds ScreenLock to Startup folder")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Password Options", 188, 360, 198, 153)
$UsePass = GUICtrlCreateCheckbox("Include Lock", 247, 380, 81, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetTip(-1, "If Lock is not included locking feature will be disabled")
GUICtrlCreateLabel("Enter Password (optional)", 198, 408, 124, 17)
$Passinput = GUICtrlCreateInput("", 198, 426, 177, 21, -1, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "No need to set password now unless you want to")
GUICtrlCreateLabel("Choose encrytion to use for Password", 196, 454, 182, 17)
$RC = GUICtrlCreateRadio("RC4", 198, 476, 48, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Default, uses no external files")
$SHA = GUICtrlCreateRadio("SHA-1", 263, 476, 48, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Uses hash.dll for encryption")
$MD = GUICtrlCreateRadio("MD5", 328, 476, 48, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Uses hash.dll for encryption")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$OK = GUICtrlCreateButton("OK", 8, 478, 75, 25, $BS_DEFPUSHBUTTON, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
$Cancel = GUICtrlCreateButton("Cancel", 102, 478, 75, 25, 0, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
GUICtrlCreateLabel("     ScreenLock is a program for" & @CRLF & "  running Screen Saver after a set" & @CRLF & "   time of inactivity and optionally" & @CRLF & "      password protecting system", 8, 366, 170, 57, $SS_SUNKEN)
GUICtrlCreateLabel("             Product of" & @CRLF & "  ©Half-Baked Software", 32, 432, 120, 30)
GUICtrlSetColor(-1, 0xff0000)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Cancel
			ExitLoop
		Case $msg = $add
			_GUICtrlComboResetContent($DSCombo)
			_GUICtrlComboAddString($DSCombo, "scrnsave.scr")
			CDSOURCE()
			$ret = _GUICtrlListGetSelItemsText($listbox)
			If (Not IsArray($ret)) Then
			Else
				For $i = 1 To $ret[0]
					_GUICtrlComboAddString($DSCombo, $ret[$i])
				Next
			EndIf
		Case $msg = $UsePass
			If GUICtrlRead($UsePass) = $GUI_CHECKED Then
				GUICtrlSetState($RC, $GUI_ENABLE)
				GUICtrlSetState($MD, $GUI_ENABLE)
				GUICtrlSetState($SHA, $GUI_ENABLE)
				GUICtrlSetState($Passinput, $GUI_ENABLE)
			Else
				GUICtrlSetState($RC, $GUI_DISABLE)
				GUICtrlSetState($RC, $GUI_CHECKED)
				GUICtrlSetState($MD, $GUI_DISABLE)
				GUICtrlSetState($SHA, $GUI_DISABLE)
				GUICtrlSetState($Passinput, $GUI_DISABLE)
			EndIf
		Case $msg = $OK
			$ret = _GUICtrlListGetSelItemsText($listbox)
			If (Not IsArray($ret)) Then
			Else
				For $i = 1 To $ret[0]
					$count = _GUICtrlListGetSelCount($listbox)
					DirCreate(@ScriptDir & "\ScreenSavers\")
					FileCopy(@SystemDir & "\" & $ret[$i], @ScriptDir & "\ScreenSavers\")
				Next
			EndIf
			$Waitout = GUICtrlRead($Wait)
			$PassWord = GUICtrlRead($Passinput)
			$scrsave = GUICtrlRead($DSCombo)
			If $scrsave = "" Then $scrsave = "scrnsave.scr"
			FileDelete(@ScriptDir & "\ScreenLock.inf")
			$file = FileOpen(@ScriptDir & "\ScreenLock.inf", 1)
			FileWrite($file, "; PE Builder v3 plug-in INF file" & @CRLF)
			FileWrite($file, "; ScreenLock.inf" & @CRLF)
			FileWrite($file, "; Created by CWorks" & @CRLF)
			FileWrite($file, "; Last Revision 9/22/06" & @CRLF & @CRLF)
			FileWrite($file, "; History of ScreenLock:  http://www.911cd.net/forums//index.php?showtopic=18154" & @CRLF & @CRLF)
			FileWrite($file, "; HotKeys" & @CRLF)
			FileWrite($file, "; F9 = Close program" & @CRLF)
			FileWrite($file, "; F10 = Change password" & @CRLF)
			FileWrite($file, "; F11 = Enable ScreenLock" & @CRLF & @CRLF)
			FileWrite($file, "[Version]" & @CRLF)
			$Software_AddReg = 'Signature= "$Windows NT$"'
			FileWrite($file, $Software_AddReg & @CRLF & @CRLF)
			FileWrite($file, "[PEBuilder]" & @CRLF)
			$Software_AddReg = 'Name="{CWorks} Screen Lock"'
			FileWrite($file, $Software_AddReg & @CRLF)
			FileWrite($file, "Enable=1" & @CRLF)
			$Software_AddReg = 'help="\"'
			FileWrite($file, $Software_AddReg & @CRLF)
			FileWrite($file, "Config=SL_Setup.exe" & @CRLF & @CRLF)
			FileWrite($file, "[WinntDirectories]" & @CRLF)
			$Software_AddReg = 'a="Programs\ScreenLock",2"'
			FileWrite($file, $Software_AddReg & @CRLF & @CRLF)
			FileWrite($file, "[SourceDisksFiles]" & @CRLF)
			FileWrite($file, "ScreenSavers\*.scr=2,,4" & @CRLF)
			FileWrite($file, "Files\ScreenLock.exe=a,,1" & @CRLF)
			If GUICtrlRead($UsePass) = $GUI_CHECKED Then
				$Lock = "1"
				FileWrite($file, "Files\SLock.exe=a,,1" & @CRLF)
				FileWrite($file, "Files\hash.dll=a,,1" & @CRLF)
			EndIf
			FileWrite($file, "scrnsave.scr=2,,4" & @CRLF)
			If GUICtrlRead($XP) = $GUI_CHECKED Then
				FileWrite($file, "logon.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Marquee) = $GUI_CHECKED Then
				FileWrite($file, "ssmarque.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($FlowerBox) = $GUI_CHECKED Then
				FileWrite($file, "ssflwbox.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Objects) = $GUI_CHECKED Then
				FileWrite($file, "ss3dfo.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Pipes) = $GUI_CHECKED Then
				FileWrite($file, "sspipes.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Text) = $GUI_CHECKED Then
				FileWrite($file, "sstext3d.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Beziers) = $GUI_CHECKED Then
				FileWrite($file, "ssbezier.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Slideshow) = $GUI_CHECKED Then
				FileWrite($file, "ssmypics.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Mystify) = $GUI_CHECKED Then
				FileWrite($file, "ssmyst.scr=2,,4" & @CRLF)
			EndIf
			If GUICtrlRead($Starfield) = $GUI_CHECKED Then
				FileWrite($file, "ssstars.scr=2,,4" & @CRLF)
			EndIf
			FileWrite($file, @CRLF & "[Software.AddReg]" & @CRLF)
			$Software_AddReg = '0x2,"Sherpya\XPEinit\Desktop","ScreenLock","%SystemDrive%\Programs\ScreenLock\ScreenLock.exe"'
			FileWrite($file, $Software_AddReg & @CRLF)
			If GUICtrlRead($Startup) = $GUI_CHECKED Then
				$Software_AddReg = '0x2,"Sherpya\XPEinit\Startup","ScreenLock","%SystemDrive%\Programs\ScreenLock\ScreenLock.exe"'
				FileWrite($file, $Software_AddReg & @CRLF)
			EndIf
			$Software_AddReg = '0x1,"CWorks\ScreenLock","screensavetimeout","'
			FileWrite($file, $Software_AddReg & $Waitout & Chr(34) & @CRLF)
			$Software_AddReg = '0x1,"CWorks\ScreenLock","SCRNSAVE.EXE","'
			FileWrite($file, $Software_AddReg & $scrsave & Chr(34) & @CRLF)
			If $Lock = "1" And $PassWord <> "" Then
				$Software_AddReg = '0x1,"CWorks\ScreenLock","ScreenSaverIsSecure","1"'
				FileWrite($file, $Software_AddReg & @CRLF)
				If GUICtrlRead($RC) = $GUI_CHECKED Then
					$PassWord = _StringEncrypt(1, $PassWord, "4471")
					$Software_AddReg = '0x1,"CWorks\ScreenLock","Password","'
					FileWrite($file, $Software_AddReg & $PassWord & Chr(34) & @CRLF)
					$Software_AddReg = '0x1,"CWorks\ScreenLock","Hash","RC4"'
					FileWrite($file, $Software_AddReg & @CRLF)
				ElseIf GUICtrlRead($SHA) = $GUI_CHECKED Then
					PluginOpen(@ScriptDir & "\Files\Hash.dll")
					$PassWord = StringHash ($PassWord, 2, True)
					PluginClose(@ScriptDir & "\Files\Hash.dll")
					$Software_AddReg = '0x1,"CWorks\ScreenLock","Password","'
					FileWrite($file, $Software_AddReg & $PassWord & Chr(34) & @CRLF)
					$Software_AddReg = '0x1,"CWorks\ScreenLock","Hash","SHA"'
					FileWrite($file, $Software_AddReg & @CRLF)
				ElseIf GUICtrlRead($MD) = $GUI_CHECKED Then
					PluginOpen(@ScriptDir & "\Files\Hash.dll")
					$PassWord = StringHash ($PassWord, 1, True)
					PluginClose(@ScriptDir & "\Files\Hash.dll")
					$Software_AddReg = '0x1,"CWorks\ScreenLock","Password","'
					FileWrite($file, $Software_AddReg & $PassWord & Chr(34) & @CRLF)
					$Software_AddReg = '0x1,"CWorks\ScreenLock","Hash","MD5"'
					FileWrite($file, $Software_AddReg & @CRLF)
				EndIf
			EndIf
			FileClose($file)
			GUIDelete($Main)
			MsgBox(0, "ScreenLock for XPE", $count & " Files Copied To ScreenSaver Folder" & @CRLF & @CRLF & @TAB & "Plugin is Complete.", 10)
			Run("notepad " & @ScriptDir & "\ScreenLock.inf", "", @SW_SHOW)
			Exit
	EndSelect
WEnd
Func CDSOURCE()
	If GUICtrlRead($XP) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "logon.scr")
	If GUICtrlRead($Marquee) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ssmarque.scr")
	If GUICtrlRead($FlowerBox) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ssflwbox.scr")
	If GUICtrlRead($Objects) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ss3dfo.scr")
	If GUICtrlRead($Pipes) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "sspipes.scr")
	If GUICtrlRead($Text) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "sstext3d.scr")
	If GUICtrlRead($Beziers) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ssbezier.scr")
	If GUICtrlRead($Slideshow) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ssmypics.scr")
	If GUICtrlRead($Mystify) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ssmyst.scr")
	If GUICtrlRead($Starfield) = $GUI_CHECKED Then _GUICtrlComboAddString($DSCombo, "ssstars.scr")
EndFunc
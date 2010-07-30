; ----------------------------------------------------------------------------
; Screen Lock
;
; REQUIRES SLOCK.EXE IN SAME FOLDER OR ELSE PASSWORD PROTECTION IS DISABLED
;
; AutoIt Version: 3.2.1.3 (beta)
; Author: CWorks
;
; HotKeys
; F9 = Close program
; F10 = Settings
; F11 = Enable ScreenLock / Settings
;
; ----------------------------------------------------------------------------


#compiler_plugin_funcs = StringHash

#include <GUIConstants.au3>
#include <Misc.au3>
#include <string.au3>
#Include <Array.au3>
#include <GuiCombo.au3>

Opt("TrayMenuMode", 1)
TraySetToolTip('ScreenLock')
If UBound(ProcessList(@ScriptName)) > 2 Then
	MsgBox(16, "Hey dumbass", "ScreenLock is already running.")
	Exit
EndIf

Dim $Wait, $RC, $SHA, $MD, $passinput2
Dim $Waiter
Dim $PassInput = ""
Dim $PassWord = ""
Dim $scrsave = ""
Dim $Secure = "0"
Dim $GO = "0"
Dim $Skewed = "0"
Dim $Hash = "RC4"

$prefsitem = TrayCreateItem("Preferences")
$Lk = TrayCreateItem("Lock")
$aboutitem = TrayCreateItem("About")
$exititem = TrayCreateItem("Exit")

Pass()

Func timer()
	If $Secure = "1" Then
		HotKeySet("{F9}")
	Else
		HotKeySet("{F9}", "close")
	EndIf
	Global $start
	Dim $oldpos[2]
	Dim $pos[2]
	Dim $s_keys[117] = [116, "01", "02", "04", "05", "06", "08", "09", "0C", "0D", "10", "11", "12", "13", "14", "1B", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "2A", "2B", "2C", "2D", "2E", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "41", "42", "44", "45", "46", "47", "48", "49", "4A", "4B", "4C", "4D", "4E", "4F", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "5A", "5B", "5C", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "6A", "6B", "6C", "6D", "6E", "6F", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "7A", "7B", "7C", "7D", "7E", "7F", "80H", "81H", "82H", "83H", "84H", "85H", "86H", "87H", "90", "91", "A0", "A1", "A2", "A3", "A4", "A5"]
	$dll = DllOpen("user32.dll")
	$start = TimerInit()
	$pos = MouseGetPos()
	While 1
		If ProcessExists("SLock.exe") Then
			HotKeySet("{F10}")
			HotKeySet("{F11}")
		Else
			HotKeySet("{F10}", "GUI")
			If $Secure = "1" Then
				HotKeySet("{F11}", "Lock")
			Else
				HotKeySet("{F11}", "GUI")
			EndIf
		EndIf
		For $y = 1 To $s_keys[0]
			If _IsPressed($s_keys[$y], $dll) Then
				$start = TimerInit()
			EndIf
			$TMsg = TrayGetMsg()
			If $TMsg = $prefsitem Then GUI()
			If $TMsg = $Lk Then
				If FileExists("SLock.exe") And $Secure = "1" Then
					Lock()
				Else
					MsgBox(262144 + 16, "Lock Error", "SLock.exe not found or not enabled", 10)
					$Secure = "0"
				EndIf
			EndIf
			If $TMsg = $aboutitem Then MsgBox(262144, "About ScreenLock", "This program was created for use in XPE" & @CRLF & "      But can also be used in windows", 10)
			If $TMsg = $exititem Then
				If FileExists("SLock.exe") And $Secure = "1" Then
					MsgBox(262144 + 16, "ScreenLock Error", "ScreenLock can't be shutdown while password is enabled", 10)
				Else
					Exit
				EndIf
			EndIf
		Next
		$oldpos[0] = $pos[0]
		$oldpos[1] = $pos[1]
		$pos2 = MouseGetPos()
		$Mouse3 = $oldpos[0] + $oldpos[1]
		$Mouse4 = $pos2[0] + $pos2[1]
		If $Mouse3 <> $Mouse4 Then
			$start = TimerInit()
		EndIf
		$pos3 = MouseGetPos()
		$pos[0] = $pos3[0]
		$pos[1] = $pos3[1]
		If TimerDiff($start) > $Waiter Then
			If $Secure = "1" Then
				Lock()
			Else
				RunWait(@SystemDir & "\" & $scrsave & " -s")
			EndIf
		EndIf
		Sleep(800)
	WEnd
	Pass()
EndFunc   ;==>timer
Func Pass()
	Global $scrsave = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "SCRNSAVE.EXE")
	Global $Wait = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "screensavetimeout")
	Global $Secure = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "ScreenSaverIsSecure")
	Global $Skewed = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Skewed")
	Global $Hash = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash")
	If $Skewed = "" Then
		$Skewed = "0"
	EndIf
	If $Wait = "" Then
		$Wait = "1"
	EndIf
	Global $Waiter = ($Wait * 60000)
	$PassWord = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Password")
	If $PassWord <> "" Then
		If $Hash = "RC4" Then $PassWord = _StringEncrypt(0, $PassWord, "4471")
	EndIf
	If $scrsave = "" Then
		If FileExists(@SystemDir & "\scrnsave.scr") Then
			$scrsave = "scrnsave.scr"
		Else
			MsgBox(262144, "error", "default Screen Saver not found and none has been set" & @CRLF & @TAB & "Choose one now or hit F9 to close", 10)
			$GO = "1"
		EndIf
	EndIf
	If $GO = "1" Then
		Main()
	Else
		timer()
	EndIf
EndFunc   ;==>Pass
Func GUI()
	$GO = "1"
	Pass()
EndFunc   ;==>GUI


Func Main()
	$GO = "0"
	Dim $Main
	GUIDelete($Main)
	If $Skewed = "1" Then
		$Main = GUICreate("Screen Lock Settings", 366, 272, -1, -1, $WS_SYSMENU, $WS_DLGFRAME + $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST + $WS_EX_WINDOWEDGE + $WS_EX_CLIENTEDGE)
	Else
		$Main = GUICreate("Screen Lock Settings", 360, 250, -1, -1, $WS_CAPTION + $WS_SYSMENU, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST + $WS_EX_CLIENTEDGE)
	EndIf
	GUICtrlCreateGroup("Screen Saver", 8, 1, 345, 81)
	$SSCombo = GUICtrlCreateCombo($scrsave, 18, 17, 165, 140, $CBS_SORT + $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL)
	_GUICtrlComboAddDir($SSCombo, "A,D,H,RO,RW", @SystemDir & "\*.scr")
	GUICtrlCreateLabel("Wait:", 20, 55, 26, 17)
	$Wait = GUICtrlCreateInput($Wait, 48, 51, 42, 22, $ES_RIGHT + $ES_NUMBER)
	$updown = GUICtrlCreateUpdown($Wait)
	GUICtrlSetLimit(-1, 100, 1)
	$Checkbox1 = GUICtrlCreateCheckbox("On resume, password protect", 190, 50, 155, 24, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("minutes", 96, 55, 40, 17)
	$Settings = GUICtrlCreateButton("Settings", 190, 17, 75, 22, -1, $WS_EX_CLIENTEDGE)
	$Preview = GUICtrlCreateButton("Preview", 270, 17, 75, 22, -1, $WS_EX_CLIENTEDGE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Password", 8, 84, 345, 126)
	$PassInput = GUICtrlCreateInput($PassWord, 28, 128, 137, 21, $ES_PASSWORD)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Newpassbox = GUICtrlCreateCheckbox("Change Password", 200, 99, 105, 24, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$passinput2 = GUICtrlCreateInput("New Password", 192, 128, 137, 21, $ES_PASSWORD)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Passlabel = GUICtrlCreateLabel("Enter Password", 32, 105, 98, 17)
	GUICtrlCreateLabel("Choose encrytion to use for Password", 94, 155, 182, 17)
	$RC = GUICtrlCreateRadio("RC4", 79, 175, 48, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Default, uses no external files")
	$SHA = GUICtrlCreateRadio("SHA-1", 159, 175, 48, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Uses hash.dll for encrypt/decrypt")
	$MD = GUICtrlCreateRadio("MD5", 239, 175, 48, 25, $BS_PUSHLIKE, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Uses hash.dll for encrypt/decrypt")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateLabel("Product of", 156, 215, 50, 17)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlCreateLabel("©Half-Baked Software", 126, 230, 150, 17)
	GUICtrlSetColor(-1, 0xff0000)
	$OK = GUICtrlCreateButton("OK", 36, 218, 75, 22, $BS_DEFPUSHBUTTON, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	$Cancel = GUICtrlCreateButton("Cancel", 246, 218, 75, 22, -1, $WS_EX_CLIENTEDGE + $WS_EX_STATICEDGE)
	If FileExists("SLock.exe") Then
	Else
		GUICtrlSetState($Checkbox1, $GUI_DISABLE)
		GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
		$Secure = "0"
	EndIf
	If $Secure = "1" Then
		GUICtrlSetState($Checkbox1, $GUI_CHECKED)
		GUICtrlSetState($PassInput, $GUI_DISABLE)
		GUICtrlSetState($Newpassbox, $GUI_ENABLE)
		GUICtrlSetData($Passlabel, "Current Password")
	EndIf
	If $Hash = "RC4" Then GUICtrlSetState($RC, $GUI_CHECKED)
	If $Hash = "SHA" Then GUICtrlSetState($SHA, $GUI_CHECKED)
	If $Hash = "MD5" Then GUICtrlSetState($MD, $GUI_CHECKED)
	GUISetState(@SW_SHOW)
	
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $Cancel
				If $scrsave = "" Then
					GUIDelete($Main)
					MsgBox(16, "error", "No Screen Saver chosen")
					Pass()
				EndIf
				Global $Waiter = $Wait * 60000
				ExitLoop
			Case $msg = $Checkbox1
				If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
					If $PassWord = "" Then
						GUICtrlSetState($PassInput, $GUI_ENABLE)
						EHASH()
					Else
						GUICtrlSetState($PassInput, $GUI_DISABLE)
						GUICtrlSetState($Newpassbox, $GUI_ENABLE)
						DHASH()
					EndIf
				ElseIf GUICtrlRead($Checkbox1) = $GUI_UNCHECKED Then
					GUICtrlSetState($Newpassbox, $GUI_DISABLE)
					GUICtrlSetState($Newpassbox, $GUI_UNCHECKED)
					DPASS()
				EndIf
			Case $msg = $Newpassbox
				If GUICtrlRead($Newpassbox) = $GUI_CHECKED Then
					GUICtrlSetData($PassInput, "")
					GUICtrlSetData($passinput2, "")
					GUICtrlSetData($Passlabel, "Old Password")
					EPASS()
					EHASH()
				Else
					If GUICtrlRead($Newpassbox) = $GUI_UNCHECKED Then
						GUICtrlSetData($PassInput, $PassWord)
						GUICtrlSetData($passinput2, "New Password")
						GUICtrlSetData($Passlabel, "Current Password")
						DPASS()
						DHASH()
					EndIf
				EndIf
			Case $msg = $PassInput
				$PassWord = GUICtrlRead($PassInput)
				If $PassWord = "" Then
					MsgBox(16, "error", "Invalid password.")
				EndIf
			Case $msg = $OK
				Global $scrsave = GUICtrlRead($SSCombo)
				If $scrsave = "" Then
					GUIDelete($Main)
					MsgBox(16, "error", "No Screen Saver chosen")
					Pass()
				EndIf
				$Waitout = GUICtrlRead($Wait)
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "SCRNSAVE.EXE", "REG_SZ", $scrsave)
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "screensavetimeout", "REG_SZ", $Waitout)
				If GUICtrlRead($Checkbox1) = $GUI_CHECKED And $PassWord <> "" Then
					Global $Secure = "1"
					TraySetIcon("SLock.exe", 0)
					If GUICtrlRead($Newpassbox) = $GUI_CHECKED Then
						$Shit = GUICtrlRead($PassInput)
						$PassWord2 = GUICtrlRead($passinput2)
						PassCheck()
						If $Hash = "SHA" Then
							PluginOpen("Hash.dll")
							$Shit = GUICtrlRead($PassInput)
							$Shit = StringHash ($Shit, 2, True)
							PluginClose("Hash.dll")
						EndIf
						If $Hash = "MD5" Then
							PluginOpen("Hash.dll")
							$Shit = GUICtrlRead($PassInput)
							$Shit = StringHash ($Shit, 1, True)
							PluginClose("Hash.dll")
						EndIf
						If $Shit == $PassWord And $PassWord2 <> "" Then
							$PassWord = $PassWord2
						Else
							GUIDelete($Main)
							MsgBox(16, "error", "Wrong Password Entered")
							Pass()
						EndIf
					EndIf
					If GUICtrlRead($RC) = $GUI_CHECKED Then
						$PassWord = _StringEncrypt(1, $PassWord, "4471")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash", "REG_SZ", "RC4")
					EndIf
					
					$check = GUICtrlRead($PassInput)
					$check = StringLen($check)

					;MsgBox(16, "String Length", $check)
					IF $check > 30 Then
						;;; go fuck yourself
					Else	
					PluginOpen("Hash.dll")					
					If GUICtrlRead($SHA) = $GUI_CHECKED Then
						$PassWord = StringHash ($PassWord, 2, True)
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash", "REG_SZ", "SHA")
					EndIf

					If GUICtrlRead($MD) = $GUI_CHECKED Then
						$PassWord = StringHash ($PassWord, 1, True)
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash", "REG_SZ", "MD5")
					EndIf
				EndIf
					;MsgBox(16, "Set Password", $PassWord)
					PluginClose("Hash.dll")
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Password", "REG_SZ", $PassWord)
				Else
					Global $Secure = "0"
					TraySetIcon("ScreenLock.exe", 0)
				EndIf
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "ScreenSaverIsSecure", "REG_SZ", $Secure)
				Global $Waiter = (GUICtrlRead($Wait) * 60000)
				If $Waiter < 0 Then ContinueLoop
				ExitLoop
			Case $msg = $Settings
				$scrsave = GUICtrlRead($SSCombo)
				GUISetState(@SW_HIDE, $Main)
				RunWait(@SystemDir & "\" & $scrsave & " -c")
				GUISetState(@SW_SHOW, $Main)
			Case $msg = $Preview
				GUISetState(@SW_HIDE, $Main)
				$scrsave = GUICtrlRead($SSCombo)
				RunWait(@SystemDir & "\" & $scrsave & " -s")
				GUISetState(@SW_SHOW, $Main)
		EndSelect
	WEnd
	GUIDelete($Main)
	timer()
EndFunc   ;==>Main
Func PassCheck()
	$Hash = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash")
	$PassWord = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Password")
	If $PassWord <> "" Then
		If $Hash = "RC4" Then $PassWord = _StringEncrypt(0, $PassWord, "4471")
	Else
		GUI()
	EndIf
EndFunc   ;==>PassCheck
Func Lock()
	HotKeySet("{F11}")
	If ProcessExists("SLock.exe") Then
		ProcessClose("SLock.exe")
		RunWait(@SystemDir & "\" & $scrsave & " -s")
		Run("SLock.exe")
	Else
		RunWait(@SystemDir & "\" & $scrsave & " -s")
		Run("SLock.exe")
	EndIf
EndFunc   ;==>Lock
Func EHASH()
	GUICtrlSetState($RC, $GUI_ENABLE)
	GUICtrlSetState($SHA, $GUI_ENABLE)
	GUICtrlSetState($MD, $GUI_ENABLE)
EndFunc   ;==>EHASH
Func DHASH()
	GUICtrlSetState($RC, $GUI_DISABLE)
	GUICtrlSetState($SHA, $GUI_DISABLE)
	GUICtrlSetState($MD, $GUI_DISABLE)
EndFunc   ;==>DHASH
Func EPASS()
	GUICtrlSetState($passinput2, $GUI_ENABLE)
	GUICtrlSetState($PassInput, $GUI_ENABLE)
EndFunc   ;==>EPASS
Func DPASS()
	GUICtrlSetState($passinput2, $GUI_DISABLE)
	GUICtrlSetState($PassInput, $GUI_DISABLE)
EndFunc   ;==>DPASS
Func close()
	Exit
EndFunc   ;==>close
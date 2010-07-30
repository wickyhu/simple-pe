; ----------------------------------------------------------------------------
; Screen Lock
;
; Can be used alone if password is in registry
;
; AutoIt Version: 3.2.1.3 (beta)
; Author: Valuater \ CWorks
;
; HotKeys
; F11 = Password Box
;
; ----------------------------------------------------------------------------

#include <GuiConstants.au3>
#include <misc.au3>
#include <string.au3>
#notrayicon

;Hash.dll needs to be in same folder
#compiler_plugin_funcs = StringHash

If UBound(ProcessList(@ScriptName)) > 2 Then
	Exit
EndIf
$Hash = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash")
If $Hash = "" Then Exit
$PassWord = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Password")
If $PassWord <> "" Then
	If $Hash = "RC4" Then $PassWord = _StringEncrypt(0, $PassWord, "4471")
Else
	Exit
EndIf
$VER = "1.0.0"
Opt("WinTitleMatchMode", 4)
Dim $Attempts = 0, $COMBO
HotKeySet("!{TAB}", "BREAKIN")
HotKeySet("{ESC}", "BREAKIN")
HotKeySet("{F11}", "ENTRY")
$SAFE = GUICreate('')
GUISetState($WS_EX_TRANSPARENT, $SAFE)
$VAULT = GUICreate(" *ScreenLock*", @DesktopWidth + 50, @DesktopHeight + 50, -1, -1, -1, -1, $SAFE)
ToolTip("Protected by,   *ScreenLock*   v" & $VER, 55, 35)
WinSetOnTop(" *ScreenLock*", "", 1)
WinSetTrans(" *ScreenLock*", "", 1)
GUISetState()
$LOCK = DllOpen("user32.dll")
SECURE()
While 1
	For $TRY = 1 To 91
		If _IsPressed($TRY, $LOCK) Or _IsPressed("0D", $LOCK) Then
			BREAKIN()
		EndIf
	Next
	WinMinimizeAll()
	_MouseTrap(127, 48, 127, 48)
	WinSetOnTop(" *ScreenLock*", "", 1)
	Sleep(1)
WEnd
Func ENTRY()
	$Hash = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Hash")
	$PassWord = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\CWorks\ScreenLock", "Password")
	If $Hash = "RC4" Then $PassWord = _StringEncrypt(0, $PassWord, "4471")
	WinSetOnTop(" *ScreenLock*", "", 0)
	$PassInput = InputBox(" *ScreenLock*", "Please Type in Your Password", "", "*", 150, 100, -1, -1, 15)
	If $Hash = "SHA" Then
		PluginOpen("Hash.dll")
		$PassInput = StringHash ($PassInput, 2, True)
		PluginClose("Hash.dll")
	EndIf
	If $Hash = "MD5" Then
		PluginOpen("Hash.dll")
		$PassInput = StringHash ($PassInput, 1, True)
		PluginClose("Hash.dll")
	EndIf
	If $PassInput = "" Then Return
	If $PassInput = $PassWord Then
		DllClose($LOCK)
		WinMinimizeAllUndo()
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", 00000000)
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation", "REG_DWORD", 00000000)
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableChangePassword", "REG_DWORD", 00000000)
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoLogoff", "REG_DWORD", 00000000)
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoClose", "REG_DWORD", 00000000)
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
		ControlEnable("classname=Shell_TrayWnd", "", "Button1")
		WinSetState("classname=Progman", "", @SW_ENABLE)
		WinSetState("Classname=Shell_TrayWnd", "", @SW_SHOW)
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("DV2ControlHost", "", @SW_SHOW)
		_MouseTrap()
		GUIDelete($VAULT)
		MsgBox(0, "Attempts", "An incorrect password was entered " & $Attempts & " time(s).", 3)
		Exit
	Else
		$Attempts += 1
		BREAKIN()
		Return
	EndIf
EndFunc   ;==>ENTRY
Func BREAKIN()
	WinSetState("Program Manager", "", @SW_HIDE)
	WinMinimizeAll()
	WinSetOnTop(" *ScreenLock*", "", 1)
EndFunc   ;==>BREAKIN
Func SECURE()
	If WinExists("classname=#32770") Then
		WinClose("classname=#32770")
		WinKill("classname=#32770")
	EndIf
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", 00000001)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation", "REG_DWORD", 00000001)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableChangePassword", "REG_DWORD", 00000001)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoLogoff", "REG_DWORD", 00000001)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoClose", "REG_DWORD", 00000001)
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
	ControlDisable("classname=Shell_TrayWnd", "", "Button1")
	WinSetState("Program Manager", "", @SW_HIDE)
	WinSetState("classname=Progman", "", @SW_DISABLE)
	WinSetState("DV2ControlHost", "", @SW_HIDE)
	WinMinimizeAll()
	WinSetState("Classname=Shell_TrayWnd", "", @SW_HIDE)
EndFunc   ;==>SECURE
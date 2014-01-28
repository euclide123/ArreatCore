#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#_Log('@@ Debug('       & @ScriptLineNumber & ') : #Region = ' & #Region & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
#AutoIt3Wrapper_Icon=lib\ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $checkx64 = @AutoItX64
If $checkx64 = 1 Then
	WinSetOnTop("Diablo III", "", 0)
	MsgBox(0, "Erreur : ", "Script lancé en x64, merci de lancer en x86 ")
	Terminate()
EndIf

$icon = @ScriptDir & "\lib\ico\icon.ico"
TraySetIcon($icon)

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <WinAPI.au3>

#include "../variables.au3"
#include "../lib/settings.au3"
#include "../lib/sequence.au3"
#include "../lib/SkillsConstants.au3"
#include "../toolkit.au3"
#include "../lib/game.au3"
#include "../lib/player.au3"
#include "../lib/stats.au3"
#include "../lib/UsePath.au3"
#include "../lib/utils.au3"
#include "../lib/GestionChat.au3"
#include "../lib/GestionMenu.au3"
#include "../lib/GestionPause.au3"


Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=
Global $debugForm = GUICreate("DebugTool", 801, 416, 232, 138)
Global $tCommandBloc = GUICtrlCreateEdit("", 8, 8, 577, 185)
Global $bExecCommand = GUICtrlCreateButton("<====== Execute commands", 600, 8, 193, 33)
Global $tResultCommand = GUICtrlCreateEdit("", 8, 200, 577, 209, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))

GUISetOnEvent($GUI_EVENT_CLOSE, "CloseForm")
GUICtrlSetOnEvent($bExecCommand, "ExecFunc")

GUICtrlSetState($tResultCommand, $GUI_DISABLE)
GUISetState(@SW_SHOW, $debugForm)
#EndRegion ### END Koda GUI section ###

#inits
OffsetList()
LoadingSNOExtended()

While 1
	Sleep(100)
WEnd

Func CloseForm()
	Exit
EndFunc   ;==>CloseForm


Func ExecFunc()
	Local $cmd = GUICtrlRead($tCommandBloc)
	GUICtrlSetData($tResultCommand, "")

	If StringLen($cmd) > 0 Then
		$return = Execute($cmd)

		If @error <> 0 Then
			GUICtrlSetData($tResultCommand, "Error")
		Else
			GUICtrlSetData($tResultCommand, $return)
		EndIf
	EndIf
EndFunc   ;==>ExecFunc

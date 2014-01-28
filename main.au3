#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#_Log('@@ Debug('       & @ScriptLineNumber & ') : #Region = ' & #Region & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
#AutoIt3Wrapper_Icon=lib\ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
$checkx64 = @AutoItX64
If $checkx64 = 1 Then
	WinSetOnTop("Diablo III", "", 0)
	MsgBox(0, "Erreur : ", "Script lancé en x64, merci de lancer en x86 ")
	Terminate()
EndIf


$icon = @ScriptDir & "\lib\ico\icon.ico"
TraySetIcon($icon)



;;--------------------------------------------------------------------------------
;;      Initialize MouseCoords
;;--------------------------------------------------------------------------------"
Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client



; --------------------------------------------------------------------------------
;   Include
; --------------------------------------------------------------------------------
;; non related bot includes
#include <File.au3>
#include <WinAPI.au3>

;; file with variables
#include "variables.au3"
#include "lib\settings.au3"
#include "lib\utils.au3"
#include "lib\SkillsConstants.au3"
#include "lib\sequence.au3"

; toolkit
#include "toolkit.au3"

; libs
#include "lib/game.au3"
#include "lib/player.au3"
#include "lib/stats.au3"
#include "lib/UsePath.au3"

; TChat
#include "lib\GestionChat.au3"

; Automatisation des séquences
#include "lib\GestionMenu.au3"
#include "lib\GestionPause.au3"

CheckWindowD3()



;;================================================================================
;; Set Some Hotkey
;;================================================================================
HotKeySet("{F2}", "Terminate")
HotKeySet("{F3}", "TogglePause")

;;--------------------------------------------------------------------------------
;;      Initialize the offsets
;;--------------------------------------------------------------------------------
AdlibRegister("DieTooFast", 1200000)
OffsetList()
LoadingSNOExtended()
InitSettings()
Func _dorun()
	_Log("======== new run ==========")
    Local $hTimer = TimerInit()
    While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
            Sleep(40)
    WEnd

    If TimerDiff($hTimer) >= 30000 Then
            Return False
    EndIf

	If $Totalruns = 1 And ($PartieSolo = 'false') Then SetConfigPartieSolo(); TChat configuration du settings

	If $GameFailed = 0 Then
		$success += 1
	EndIf
	$successratio = $success / $Totalruns


	$GameFailed = 0
	$SkippedMove = 0
	$IgnoreItemList = ""

	StatsDisplay()

	If $hotkeycheck = 0 Then
		CheckHotkeys()
		AutoModeInitSpells()
		ManageSpellInit()
		LoadAttributeGlobalStuff()
		$maxhp = GetAttribute($_MyGuid, $Atrib_Hitpoints_Max_Total) ; dirty placement
		_Log("Max HP : " & $maxhp)
		GetMaxResource($_MyGuid, $namecharacter)
		Send("t")
		Sleep(500)
		DetectStrInventoryFull()
	EndIf

	If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_WELCOME) ; TChat

	GetAct()
	$CheckTakeShrinebanlist = ""
	EmergencyStopCheck()

	If IsItemDamaged() Then
		TpRepairAndBack()
	Else
		$NeedRepairCount = 0
	EndIf

	Sleep(100)

	CheckEnoughPotions()

	InitSequence()
	Sequence()

	$CheckTakeShrinebanlist = ""
	_Log("End Run" & " gamefailled: " & $GameFailed)
	Return True
EndFunc   ;==>_dorun

Func _botting()
	_Log("Start Botting")
	$bottingtime = TimerInit()
	While 1
		_Log("new main loop")
		OffsetList()

		If IsOnLoginScreen() Then
			_Log("LOGIN")
			LoginD3()
			Sleep(Random(60000, 120000))
		EndIf

		;Lancement de la partie

		; Si Choix_Act_Run <> 0 le bot passe en mode automatique
		If $Choix_Act_Run <> 0 Then
			If IsInGame() = true and $TypedeBot < 2 Then;si en jeu lors du lancement auto
				WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
				MsgBox(0, "ERREUR", "Vous devez être dans le menu pour lancer une run en auto ! ")
				Terminate()
			EndIf
			SelectQuest()
		EndIf

		If IsInMenu() And IsOnLoginScreen() = False Then
		   If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_RESART_GAME) ; TChat
			RandSleep()
			$DeathCountToggle = True
			ResumeGame()
		EndIf

		While IsOnLoginScreen() = False And IsInGame() = False
			_Log("Ingame False")
			If IsDisconnected() Then
				$disconnectcount += 1
				_Log("Disconnected dc4")
				Sleep(1000)
				RandomMouseClick(398, 349)
				Sleep(1000)
				While Not (IsOnLoginScreen() Or IsInMenu())
					Sleep(Random(10000, 15000))
				WEnd
				ContinueLoop 2
			EndIf

			ResumeGame()
		WEnd

		If IsOnLoginScreen() = False And IsPlayerDead() = False And IsInGame() = True Then
			Global $timermaxgamelength = TimerInit()
			Global $CheckGameLength = False
			If _dorun() = True Then
				$HandleBanList1 = ""
				$HandleBanList2 = ""
				$HandleBanListdef = ""
				$TryResumeGame = 0
				$TryLoginD3 = 0
				$BreakCounter += 1;on ce met a compter les games avant la pause
				$games += 1
				$gamecounter += 1
			EndIf
		EndIf


		If IsOnLoginScreen() = False And IsInTown() = False And IsPlayerDead() = False Then
			GoToTown()
		EndIf

		_Log("start GoToTown from main 2")
		If IsInTown() Or IsPlayerDead() And IsOnLoginScreen() = False Then
			If IsPlayerDead() = False And $games >= ($repairafterxxgames + Random(-2, 2, 1)) Then
				StashAndRepair()
				$games = 0
			EndIf

			If Not IsDisconnected() Then
				LeaveGame()
			Else
				_Log("Disconnected dc2")
				$disconnectcount += 1
				Sleep(1000)
				RandomMouseClick(398, 349)
				RandomMouseClick(398, 349)
			EndIf

			If IsPlayerDead() Then
				Sleep(Random(11000, 13000))
			EndIf
		EndIf

		Sleep(1000)
		_Log('loop IsInMenu() = False And IsOnLoginScreen()')

		While IsInMenu() = False And IsOnLoginScreen() = False
			Sleep(10)
		WEnd

	WEnd
EndFunc   ;==>_botting

;;--------------------------------------------------------------------------------
;;     Check KeyTo avoid sell of equiped stuff
;;--------------------------------------------------------------------------------
Func CheckHotkeys()
	Sleep(2000)
	Send("i")
	Sleep(500)
	If IsInventoryOpened() = False Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour ouvrir l'inventaire doit être i" & @CRLF)
		Terminate()
	EndIf
	Sleep(185)
	Send("{SPACE}") ; make sure we close everything
	Sleep(170)
	If IsInventoryOpened() = True Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour fermer les fenêtres doit être ESPACE" & @CRLF)
		Terminate()
	EndIf
	_Log("Check des touches OK" & @CRLF)
	$hotkeycheck = 1
EndFunc   ;==>CheckHotkeys


_botting()
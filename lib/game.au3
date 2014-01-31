#include-once
 ; ------------------------------------------------------------
; Ce fichier contient toutes les fonctions relatives au
; jeu dans sa globalitÃ© (etat, localisation ...).
; -------------------------------------------------------------

Func CheckWindowD3()
	If WinExists("[CLASS:D3 Main Window Class]") Then
		WinActivate("[CLASS:D3 Main Window Class]")
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 1)
		Sleep(300)
	Else
		MsgBox(0, Default, "FenÃªtre Diablo III absente.")
		Terminate()
	EndIf
	Global $sized3 = WinGetClientSize("[CLASS:D3 Main Window Class]")
	If $sized3[0] <> 800 Or $sized3[1] <> 600 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(0, Default, "Erreur Dimension : Il faut Ãªtre en 800 x 600 et non pas en " & $sized3[0] & " x " & $sized3[1] & ".")
		Terminate()
	Else
		_Log("Setting Window Diablo III OK")
	EndIf
	$posd3 = WinGetPos("Diablo III")
	$DebugX = $posd3[0] + $posd3[2] + 10
	$DebugY = $posd3[1]
EndFunc   ;==>CheckWindowD3

Func CheckWindowD3Size()
	Global $sized3 = WinGetClientSize("[CLASS:D3 Main Window Class]")
	If $sized3[0] <> 800 Or $sized3[1] <> 600 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(0, Default, "Erreur Dimension : Il faut Ãªtre en 800 x 600 et non pas en " & $sized3[0] & " x " & $sized3[1] & ".")
		Terminate()

	EndIf
EndFunc   ;==>CheckWindowD3Size

Func IsInMenu()
	Local $uiLobby = "Menu.PlayGameButton"
	Return FastCheckUiItemVisible($uiLobby, 1, 654)
EndFunc   ;==>IsInMenu

Func IsDisconnected()
	Local $uiDisconnect = "Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList.OkButton"
	Return FastCheckUiItemVisible($uiDisconnect, 1, 1073)
EndFunc   ;==>IsDisconnected

Func IsItemDamaged()
	Local $uiRepair = "Root.NormalLayer.DurabilityIndicator"
	Return FastCheckUiItemVisible($uiRepair, 1, 239)
EndFunc   ;==>IsItemDamaged

Func IsOnLoginScreen()
	Local $uiLogin = "Root.NormalLayer.BattleNetLogin_main.LayoutRoot"
	Return FastCheckUiItemVisible($uiLogin, 1, 174)
EndFunc   ;==>IsOnLoginScreen

Func IsEscapeMenuOpened()
	Local $uiEscapeMenu = "Root.TopLayer.gamemenu_dialog.gamemenu_bkgrnd.ButtonStackContainer.button_leaveGame"
	Return FastCheckUiItemVisible($uiEscapeMenu, 1, 1447)
EndFunc   ;==>IsEscapeMenuOpened

Func IsInGame()
	Local $uiInGame = "Root.NormalLayer.minimap_dialog_backgroundScreen.minimap_dialog_pve.area_name"
	Return FastCheckUiItemVisible($uiInGame, 1, 1403)
EndFunc   ;==>IsInGame

Func IsWaypointSelectionOpened()
	Local $uiWaypointSelection = "Root.NormalLayer.waypoints_dialog_mainPage"
	Return FastCheckUiItemVisible($uiWaypointSelection, 1, 1398)
EndFunc   ;==>IsWaypointSelectionOpened

Func IsVendorOpened()
	Local $uiVendorWindow = "Root.NormalLayer.shop_dialog_mainPage"
	Return FastCheckUiItemVisible($uiVendorWindow, 1, 1814)
EndFunc   ;==>IsVendorOpened

Func IsStashOpened()
	Local $uiStashWindow = "Root.NormalLayer.stash_dialog_mainPage"
	Return FastCheckUiItemVisible($uiStashWindow, 1, 1291)
EndFunc   ;==>IsStashOpened

Func IsInventoryOpened()
	Local $uiInventoryWindow = "Root.NormalLayer.inventory_dialog_mainPage"
	Return FastCheckUiItemVisible($uiInventoryWindow, 1, 1622)
EndFunc   ;==>IsInventoryOpened

;;--------------------------------------------------------------------------------
; Function:			TownStateCheck()
; Description:		Check if we are in town or not by comparing distance from stash
;
;;--------------------------------------------------------------------------------
Func IsInTown()
	If $_debug Then _Log("-----Checking if In Town------")
	$town = FindActor($actorStash, 448)
	If $town = 1 Then
		_Log("We are in town ")
		Return True
	Else
		_Log("We are NOT in town ")
		Return False
	EndIf
EndFunc   ;==>IsInTown

Func IsQuestChangeUiOpened()
        Local $uiQuestChange = "Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList.OkButton"
        Return FastCheckUiItemVisible($uiQuestChange, 1, 1073)
EndFunc  ;==> _checkLoadNewGame

Func IsShrine($item)
	If StringInStr($item[1], "shrine") And $item[9] < 35 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsShrine

Func IsMonster($item)
	If CheckFromList($BanmonsterList, $item[1]) = 0 And CheckFromList($monsterList, $item[1]) And $item[6] <> -1 And $item[9] < $a_range Or CheckFromList($SpecialmonsterList, $item[1]) And $item[9] < $a_range Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsMonster

Func IsDecorBreakable($item)
	If CheckFromList($bandecorlist, $item[1]) = 0 And CheckFromList($decorlist, $item[1]) And $item[6] <> -1 And $item[9] < 18 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsDecorBreakable

Func IsLoot($item)

	If ($item[5] = 2 And $item[6] = -1) Or (StringInStr($item[1], "orb") And StringInStr($item[1], "unique")) Or (StringInStr($item[1], "Spear") And StringInStr($item[1], "unique")) Then
		;_Log("IsLoot de l'item -> " & $item[0] & "-" & $item[1] & "-" & $item[2] & " - " & $item[3] & " - " & $item[4] & " - " & $item[5] & " - " & $item[6] & " - " & $item[8] & " - " & $item[9])
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsLoot

Func IsInteractable($item, $IgnoreList)
	If $item[0] <> "" And $item[0] <> 0xFFFFFFFF And ($item[9] < $g_range Or $item[9] < $a_range) And StringInStr($IgnoreList, $item[8]) == 0 And StringInStr($HandleBanListdef, $item[2] & "-" & $item[3] & "-" & $item[4]) == 0 And StringInStr($IgnoreItemList, $item[1]) = 0 And CheckFromList($CheckTakeShrinebanlist, $item[8]) = 0 And Abs($Current_Hero_Z - $item[4]) <= $Hero_Axe_Z Then
		If Not CheckStartListRegex($Ban_startstrItemList, $item[1]) And Not CheckEndListRegex("_projectile", $item[1]) Then
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf
EndFunc   ;==>IsInteractable

;;--------------------------------------------------------------------------------
;;     Find which Act we are in
;;--------------------------------------------------------------------------------
Func GetAct()
	If $Act = 0 Then
		$arealist = FileRead("lib\memory\area.txt")
		$area = GetLevelAreaId()

		_Log(" We are in map : " & $area)
		Local $pattern = "([\w'-]{5,80})\t\W\t" & $area
		$asResult = StringRegExp($arealist, $pattern, 1)
		If @error == 0 Then
			Global $MyArea = $asResult[0]

			If StringInStr($MyArea, "a1") Then
				$Act = 1
			ElseIf StringInStr($MyArea, "a2") Then
				$Act = 2
			ElseIf StringInStr($MyArea, "a3") Then
				$Act = 3
			ElseIf StringInStr($MyArea, "a4") Then
				$Act = 4

			EndIf
			;  _Log("We are in map : " & $area &" " & $asResult[0])


			;set our vendor aaccording to the act we are in as we know it.
			Switch $Act
				Case 1
					Global $RepairVendor = "UniqueVendor_miner_InTown"

				Case 2
					Global $RepairVendor = "UniqueVendor_Peddler_InTown" ; act 2 fillette

				Case 3
					Global $RepairVendor = "UniqueVendor_Collector_InTown" ; act 3

				Case 4
					Global $RepairVendor = "UniqueVendor_Collector_InTown" ; act 3

			EndSwitch
			_Log("Our Current Act is : " & $Act & " ---> So our vendor is : " & $RepairVendor)

		EndIf
	EndIf
EndFunc   ;==>GetAct

;;--------------------------------------------------------------------------------
;;     Find MonsterPower
;;	   Get it Via UI element
;;
;;--------------------------------------------------------------------------------
Func GetMonsterPow()

	$GetMonsterPow = FastCheckUiValue('Root.NormalLayer.minimap_dialog_backgroundScreen.minimap_dialog_pve.clock', 1, 28)
	$asMpResult = StringRegExp($GetMonsterPow, '(\()([0-9]{1,2})(\))', 1)
	If @error == 0 Then
		$MP = Number($asMpResult[1])
	Else
		$MP = 0
	EndIf
	_Log("Power monster : " & $MP)
	;_Log("Power monster : " & $GetMonsterPow)
EndFunc   ;==>GetMonsterPow

;;--------------------------------------------------------------------------------
;;     Find Difficulty from vendor
;;	   Get vendor Level and deduce game difficulty from it
;;		$GameDifficulty = not yet determined, 1 = Norm, 2 = Nm, 3 = Hell, 4 = Inferno
;;--------------------------------------------------------------------------------
Func GetDifficulty()
	If $GameDifficulty = 0 Then

		Local $index, $offset, $count, $item[4]
		StartIterateLocalActor($index, $offset, $count)
		While IterateLocalActorList($index, $offset, $count, $item)
			If StringInStr($item[1], $RepairVendor) Then
				Global $npclevel = IterateActorAttributes($item[0], $Atrib_Level)

				Switch $npclevel
					Case 1 To 59
						Global $GameDifficulty = 1
					Case 60 To 70
						Global $GameDifficulty = 4
				EndSwitch

				ExitLoop
			EndIf
		WEnd
		_Log("Game Difficulty is : " & $GameDifficulty)
	EndIf
EndFunc   ;==>GetDifficulty

;;--------------------------------------------------------------------------------
;;     Adapt repair tab aaccording to MP act and diff
;;--------------------------------------------------------------------------------
Func GetRepairTab()
	GetMonsterPow()
	GetDifficulty()
	GetAct()

	If $MP > 0 And $GameDifficulty = 4 Then
		Switch $Act
			Case 1
				Global $RepairTab = 2
			Case 2 To 4
				Global $RepairTab = 3
		EndSwitch
	Else
		Switch $Act
			Case 1
				Global $RepairTab = 2
			Case 2 To 4
				Global $RepairTab = 3
		EndSwitch

	EndIf
	_Log("RepairTab : " & $RepairTab & " ---> MP : " & $MP & " GameDiff : " & $GameDifficulty)

EndFunc   ;==>GetRepairTab

;;--------------------------------------------------------------------------------
;;      UiRatio()
;;--------------------------------------------------------------------------------
Func UiRatio($_x, $_y)
	Dim $return[2]
	$size = WinGetClientSize("[CLASS:D3 Main Window Class]")
	$return[0] = $size[1] * ($_x / 600)
	$return[1] = $size[1] * ($_y / 600)
	Return $return
EndFunc   ;==>UiRatio

;;--------------------------------------------------------------------------------
;;      FromD3ToScreenCoords()
;;--------------------------------------------------------------------------------
Func FromD3ToScreenCoords($_x, $_y, $_z)
	Dim $return[2]
	$size = WinGetClientSize("[CLASS:D3 Main Window Class]")
	$resolutionX = $size[0]
	$resolutionY = $size[1]
	$aspectChange = ($resolutionX / $resolutionY) / (800 / 600)
	$CurrentLoc = GetCurrentPos()
	$xd = $_x - $CurrentLoc[0]
	$yd = $_y - $CurrentLoc[1]
	$zd = $_z - $CurrentLoc[2]
	$w = -0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.985
	$x = (-1.682 * $xd + 1.683 * $yd + 0 * $zd + 7.045E-3) / $w
	$y = (-1.54 * $xd + -1.539 * $yd + 2.307 * $zd + 6.161) / $w
	$Z = (-0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.002) / $w
	$x /= $aspectChange
	While Abs($x) >= 1 Or Abs($y) >= 0.7 Or $Z <= 0
		; specified point is not on screen
		$xd = $xd / 2
		$yd = $yd / 2
		$zd = $zd / 2
		$w = -0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.985
		$x = (-1.682 * $xd + 1.683 * $yd + 0 * $zd + 7.045E-3) / $w
		$y = (-1.54 * $xd + -1.539 * $yd + 2.307 * $zd + 6.161) / $w
		$Z = (-0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.002) / $w
		$x /= $aspectChange
	WEnd
	$return[0] = ($x + 1) / 2 * $resolutionX
	$return[1] = (1 - $y) / 2 * $resolutionY
	If $return[0] > 790 Then
		$return[0] = 790
	ElseIf $return[0] < 40 Then ;car on a pas l'envie de cliquer dans les icone du chat
		$return[0] = 40
	EndIf
	If $return[1] > 540 Then ;car on a pas l'envie de cliquer dans la bare des skills
		$return[1] = 540
	ElseIf $return[1] < 10 Then
		$return[1] = 10
	EndIf
	Return $return
EndFunc   ;==>FromD3ToScreenCoords


;;--------------------------------------------------------------------------------
;;      ResumeGame()
;;--------------------------------------------------------------------------------
Func ResumeGame()
	_Log("Resume Game")
	Sleep(Random(500, 1000, 1))
	If $TryResumeGame > 2 Then
		Local $wait_aftertoomanytry = Random(($TryResumeGame * 2) * 60000, ($TryResumeGame * 2) * 120000, 1)
		_Log("Sleep after too many ResumeGame -> " & $wait_aftertoomanytry)
		Sleep($wait_aftertoomanytry)
	EndIf
	If $TryResumeGame = 0 And $BreakCounter >= ($Breakafterxxgames + Random(-2, 2, 1)) And $TakeABreak = "true" Then;$TryResumeGame = 0 car on veut pas faire une pause en plein jeu
		Local $wait_BreakTimeafterxxgames = (($BreakTime * 1000) + Random(60000, 180000, 1))
		_Log("Break Time after xx games -> Sleep " & (FormatTime($wait_BreakTimeafterxxgames)))
		Sleep($wait_BreakTimeafterxxgames)
		$BreakCounter = 0;on remet le compteur a 0
		$BreakTimeCounter += 1;on compte les pause effectuer
		$tempsPauseGame += $wait_BreakTimeafterxxgames;on rÃ©cupÃ¨re le temps de pause game
	EndIf
	If $TryResumeGame = 0 And $PauseRepas = "true" Then; $TryResumeGame = 0 car on veut pas faire une pause en plein jeu
		PauseRepas($Totalruns)
	EndIf
	RandomMouseClick(106, 233)
	$TryResumeGame += 1
	Sleep(4000)
EndFunc   ;==>ResumeGame

Func LoginD3()

	If $TryLoginD3 > 2 Then
		Local $wait_aftertoomanytry = Random(($TryLoginD3 * 2) * 60000, ($TryLoginD3 * 2) * 120000, 1)
		_Log("Sleep after too many LoginD3 -> " & $wait_aftertoomanytry)
		Sleep($wait_aftertoomanytry)
	EndIf

	WinActivate("[CLASS:D3 Main Window Class]")
	
	If Not IsDisconnected() Then ; le bot ne fait pas la différence entre IsDisconnected() et déconnecter du serveur
		_Log("Login")
		Sleep(1000)
		Send($d3pass)
		Sleep(2000)
		Send("{ENTER}")
		Sleep(Random(5000, 6000, 1))

		$TryLoginD3 += 1
	Else
		_Log("Disconnected to server")
		sleep(2000)
		RandomMouseClick(398, 349)
		sleep(2000)
		Send("{ENTER}") ; enter, si jamais on a rentré le mot passe avant que la fenêtre apparaisse
		sleep(2000)
	EndIf
	 
EndFunc   ;==>LoginD3

;;--------------------------------------------------------------------------------
;;      LeaveGame()
;;--------------------------------------------------------------------------------
Func LeaveGame()
	If IsInGame() Then
		_Log("Leave Game")
		Send("{SPACE}") ; to make sure everything is closed
		Send("{ESCAPE}")
		Sleep(Random(200, 300, 1))
		While IsEscapeMenuOpened() = False
			Send("{ESCAPE}")
			Sleep(Random(200, 300, 1))
		WEnd

		If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_QUITE) ; TChat
		 
		RandomMouseClick(420, 323)
		Sleep(Random(500, 1000, 1))
		_Log("Leave Game Done")
	EndIf

	If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_TAKE_BREAK_MENU) ; TChat

EndFunc   ;==>LeaveGame

Func TogglePause()
	$Paused = Not $Paused
	If $Paused Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		While $Paused
			Sleep(100)
			TrayTip("", 'Script is "Paused"', 5)
		WEnd
	EndIf
	CheckWindowD3()
EndFunc   ;==>TogglePause

;;--------------------------------------------------------------------------------
; Function:                     EmergencyStopCheck()
; Description:          Check for dangerous behavior and stop bot if needed to prevent problems
;
; Note(s):
;;--------------------------------------------------------------------------------
Func EmergencyStopCheck()

	If $DieTooFastCount > 6 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(4096, "Arret d'urgence", "Nombre de mort : " & $Death)
		Terminate()
	EndIf

	If $NeedRepairCount > 4 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(4096, "Arret d'urgence", "Nombre de tentatives de repair a la suite : " & $NeedRepairCount)
		Terminate()
	EndIf

EndFunc   ;==>EmergencyStopCheck

;;--------------------------------------------------------------------------------
; Function:                     CheckEnoughPotions()
; Description:    Read amount of pot in inv. Compare with Potionstock and set takepot to true of false.
;
;
;;--------------------------------------------------------------------------------
Func CheckEnoughPotions()
	Local $potinstock = Number(FastCheckUiValue('Root.NormalLayer.game_dialog_backgroundScreenPC.game_potion.text', 1, 875))
	If $potinstock > $PotionStock Then
		_Log("I have more than " & $PotionStock & " potions. I will not take more until next check " & "(" & $potinstock & ")")
		$takepot = False
	Else
		_Log("I have less than " & $PotionStock & " potions. I will grab them until next check " & "pot:" & "(" & $potinstock & ")")
		$takepot = True
	EndIf
EndFunc   ;==>CheckEnoughPotions

;;--------------------------------------------------------------------------------
; Function:                     DieTooFast()
; Description:    Cette fonction est appelÃ©e toute les 20 min.
;
; Note(s): Permet de detecter un nombre de mort a la suite trop important
;;--------------------------------------------------------------------------------
Func DieTooFast()
	$DieTooFastCount = 0
EndFunc   ;==>DieTooFast

Func CheckIgnoreAffixe($_x_verif, $_y_verif)
	For $a = 0 To UBound($ignore_affix) - 1
		If $_x_verif = $ignore_affix[$a][0] And $_y_verif = $ignore_affix[$a][1] Then
			Return False
			$a = UBound($ignore_affix) - 1
		Else
			Return True
		EndIf
	Next

EndFunc   ;==>CheckIgnoreAffixe

Func IsSafeZone($x_perso, $y_perso, $z_test, $item_safe)
	$condition_affixe = 0
	For $aa = 0 To UBound($item_safe) - 1

		$distance_centre_affixe = Sqrt(($item_safe[$aa][2] - $x_perso) ^ 2 + ($item_safe[$aa][3] - $y_perso) ^ 2)
		If $distance_centre_affixe < $item_safe[$aa][10] Then
			$condition_affixe = $condition_affixe + 1
;~ 					$aa=ubound($item_safe)-1
		EndIf

	Next

	If $condition_affixe = 0 Then

		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>IsSafeZone

Func FindSafeZone($x_perso, $y_perso, $item_verif, $z_test, $x_mob, $y_mob)
	Dim $safe_array[1][3]
	$bb = -1
	If $x_mob - $x_perso > 0 Then
		$ord = 1
	Else
		$ord = -1
	EndIf

	If $y_mob - $y_perso > 0 Then
		$abs = 1
	Else
		$abs = -1
	EndIf

	For $B = 0 To UBound($tab_aff2) - 1
		$x_test = $x_perso + $ord * $tab_aff2[$B][0]
		$y_test = $y_perso + $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
;~ 			$safe_array[$bb+1][1]=$x_test
;~ 			$safe_array[$bb+1][2]=$y_test
;~ 			$safe_array[$bb+1][0]=$distance_safe
;~ 		   $b= ubound($tab_aff2)-1
		EndIf

		$x_test = $x_perso - $ord * $tab_aff2[$B][0]
		$y_test = $y_perso - $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
;~ 			$safe_array[$bb+1][1]=$x_test
;~ 			$safe_array[$bb+1][2]=$y_test
;~ 			$safe_array[$bb+1][0]=$distance_safe
;~ 		   $b= ubound($tab_aff2)-1
		EndIf

		$x_test = $x_perso + $ord * $tab_aff2[$B][0]
		$y_test = $y_perso - $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
;~ 			$safe_array[$bb+1][1]=$x_test
;~ 			$safe_array[$bb+1][2]=$y_test
;~ 			$safe_array[$bb+1][0]=$distance_safe
;~ 		   $b= ubound($tab_aff2)-1
		EndIf

		$x_test = $x_perso - $ord * $tab_aff2[$B][0]
		$y_test = $y_perso + $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
		EndIf
	Next
	If $safe_array[0][0] <> 0 Then
		_ArraySort($safe_array)
		Dim $move_aff[2]
		$move_aff[0] = $safe_array[0][1]
		$move_aff[1] = $safe_array[0][2]

	Else
		$move_aff[0] = $x_test
		$move_aff[1] = $y_test

	EndIf
	Return $move_aff

EndFunc   ;==>FindSafeZone

Func IsAffix($item, $pv = 0)
	If $item[9] < 50 Then
		If ((StringInStr($item[1], "bomb_buildup") And $pv <= $Life_explo / 100) Or _
				(StringInStr($item[1], "Corpulent_") And $pv<=$Life_explo/100 ) Or _
				(StringInStr($item[1], "demonmine_C") And $pv <= $Life_mine / 100) Or _
				(StringInStr($item[1], "creepMobArm") And $pv <= $Life_arm / 100) Or _
				(StringInStr($item[1], "woodWraith_explosion") And $pv <= $Life_spore / 100) Or _
				(StringInStr($item[1], "WoodWraith_sporeCloud_emitter") And $pv <= $Life_spore / 100) Or _
				(StringInStr($item[1], "sandwasp_projectile") And $pv <= $Life_proj / 100) Or _
				(StringInStr($item[1], "Crater_DemonClawBomb") And $pv <= $Life_mine / 100) Or _
				(StringInStr($item[1], "Molten_deathExplosion") And $pv <= $Life_explo / 100) Or _
				(StringInStr($item[1], "Molten_deathStart") And $pv <= $Life_explo / 100) Or _
				(StringInStr($item[1], "icecluster") And $pv <= $Life_ice / 100) Or _
				(StringInStr($item[1], "spore") And $pv <= $Life_spore / 100) Or _
				(StringInStr($item[1], "ArcaneEnchanted_petsweep") And $pv <= $Life_arcane / 100) Or _
				(StringInStr($item[1], "desecrator") And $pv <= $Life_profa / 100) Or _
				(StringInStr($item[1], "Plagued_endCloud") And $pv <= $Life_peste / 100) Or _
				(StringInStr($item[1], "poison") And $pv <= $Life_poison / 100) Or _
				(StringInStr($item[1], "molten_trail") And $pv <= $Life_lave / 100)) _
				And CheckFromList($BanAffixList, $item[1]) = 0 Then
			Return True
		Else
			Return False
		EndIf
	EndIf

EndFunc   ;==>IsAffix

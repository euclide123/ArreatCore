#include-once
; ------------------------------------------------------------
; Ce fichier contient toutes les fonctions relatives aux
; personnages dans le jeu
; ------------------------------------------------------------

Func IsPlayerDead()
	$return = FastCheckUiItemVisible($uiPlayerDead, 1, 969)
	If ($return And $DeathCountToggle) Then
		$Death += 1
		$DieTooFastCount += 1
		$DeathCountToggle = False
	EndIf
	Return $return
EndFunc   ;==>IsPlayerDead

;;--------------------------------------------------------------------------------
;;      Interact()
;;--------------------------------------------------------------------------------
Func Interact($_x, $_y, $_z)
	$Coords = FromD3ToScreenCoords($_x, $_y, $_z)
	MouseClick("left", $Coords[0], $Coords[1], 1, 2)
EndFunc   ;==>Interact

;;--------------------------------------------------------------------------------
;;      GetLifeLeftPercent()
;;--------------------------------------------------------------------------------
Func GetLifeLeftPercent()
	$curhp = GetAttribute($_MyGuid, $Atrib_Hitpoints_Cur)
	Return ($curhp / $maxhp)
EndFunc   ;==>GetLifeLeftPercent

;;--------------------------------------------------------------------------------
;;      Attack()
;;--------------------------------------------------------------------------------
Func Attack()
	If RevivePlayerDead() Then
		Return
	EndIf

	If IsPlayerDead() Or ($GameFailed = 1) Then
		$GameFailed = 1
		_Log("Return Cuz : If IsPlayerDead or gamefailed ")
		Return
	EndIf
	Local $IgnoreList = ""
	Local $item[10]
	Dim $test_iterateallobjectslist = IterateFilterAttack($IgnoreList)
	If IsArray($test_iterateallobjectslist) Then
		While IsArray($test_iterateallobjectslist)
			If RevivePlayerDead() Then
				ExitLoop
			EndIf
			If IsPlayerDead() Or ($GameFailed = 1) Then
				$GameFailed = 1
				_Log("Return Cuz : If IsPlayerDead or gamefailed ")
				ExitLoop
			EndIf
			For $i = 0 To 9
				$item[$i] = $test_iterateallobjectslist[0][$i]
			Next

			Select
				Case IsLoot($item)
					HandleLoot($item, $IgnoreList, $test_iterateallobjectslist)
				Case IsMonster($item)
					HandleMonster($item, $IgnoreList, $test_iterateallobjectslist)
				Case IsShrine($item)
					HandleCheckTakeShrine($item)
				Case IsDecorBreakable($item)
					HandleMonster($item, $IgnoreList, $test_iterateallobjectslist)
			EndSelect

			Dim $buff_array = UpdateArrayAttack($test_iterateallobjectslist, $IgnoreList)
			Dim $test_iterateallobjectslist = $buff_array

		WEnd

	EndIf
EndFunc   ;==>Attack

;;--------------------------------------------------------------------------------
;;      KillMob()
;;--------------------------------------------------------------------------------
Func KillMob($name, $offset, $Guid, $test_iterateallobjectslist2)
	$return = True
	$begin = TimerInit()


	Dim $pos = UpdateObjectsPos($offset)


	$Coords = FromD3ToScreenCoords($pos[0], $pos[1], $pos[2])
	MouseMove($Coords[0], $Coords[1], 3)

	$elite = DetectElite($Guid)
	;loop the attack until the mob is dead
	If $elite Then
		$CptElite += 1;on compte les √©lites
	EndIf

	_Log("Attacking : " & $name & "; Type : " & $elite);
	While IterateActorAttributes($Guid, $Atrib_Hitpoints_Cur) > 0
		$myposs_aff = GetCurrentPos()

		If RevivePlayerDead() Then
			$return = False
			ExitLoop
		EndIf
		Dim $pos = UpdateObjectsPos($offset)

		If $gestion_affixe = "true" Then MaffMove($myposs_aff[0], $myposs_aff[1], $myposs_aff[2], $pos[0], $pos[1])
		For $a = 0 To UBound($test_iterateallobjectslist2) - 1
			$CurrentACD = GetACDOffsetByACDGUID($test_iterateallobjectslist2[$a][0]); ###########
			$CurrentIdAttrib = _memoryread($CurrentACD + 0x120, $d3, "ptr"); ###########
			If GetAttribute($CurrentIdAttrib, $Atrib_Hitpoints_Cur) > 0 Then
				Dim $dist_maj = UpdateObjectsPos($test_iterateallobjectslist2[$a][8])
				$test_iterateallobjectslist2[$a][9] = $dist_maj[3]
			Else
				$test_iterateallobjectslist2[$a][9] = 10000
			EndIf
		Next
		_ArraySort($test_iterateallobjectslist2, 0, 0, 0, 9)
		$dist_verif = GetDistance($test_iterateallobjectslist2[0][2], $test_iterateallobjectslist2[0][3], $test_iterateallobjectslist2[0][4])
		Dim $pos = UpdateObjectsPos($offset)
		If $pos[3] > $dist_verif + 5 Then ExitLoop

		;if getDistance($pos[0], $pos[1], $pos[2])>20 and IterateFilterZone(30,1) then exitloop


		$Coords = FromD3ToScreenCoords($pos[0], $pos[1], $pos[2])
		MouseMove($Coords[0], $Coords[1], 3)
		ManageSpellCasting($pos[3], 1, $elite, $Guid, $offset)
		If TimerDiff($begin) > $a_time Then
			$killtimeout += 1
			; after this time, the mob should be dead, otherwise he is probly unkillable
			$return = False
			ExitLoop
		EndIf
	WEnd
	Return $return
EndFunc   ;==>KillMob

Func InventoryMove($col = 0, $row = 0)
	$Coords = UiRatio(530 + ($col * 27), 338 + ($row * 27))
	MouseMove($Coords[0], $Coords[1], 2)
EndFunc   ;==>InventoryMove

;;--------------------------------------------------------------------------------
;;      CheckDrinkPotion()
;;--------------------------------------------------------------------------------
Func CheckDrinkPotion()

	$life = GetLifeLeftPercent()
	$diff = TimerDiff($timeforpotion)
	If $life < $LifeForPotion / 100 And $diff > 1500 Then
		Send("q")
		$timeforpotion = TimerInit()
	EndIf

EndFunc   ;==>CheckDrinkPotion

Func OpenWp(ByRef $item)
	Local $maxtry = 0
	If IsPlayerDead() = False Then
		_Log($item[1] & " distance : " & $item[9])
		While GetDistance($item[2], $item[3], $item[4]) > 40 And $maxtry <= 15
			$Coords = FromD3ToScreenCoords($item[2], $item[3], $item[4])
			MouseClick("middle", $Coords[0], $Coords[1], 1, 10)
			$maxtry += 1
			_Log('interactbyactor: click x : ' & $Coords[0] & " y : " & $Coords[1])
			Sleep(500)
		WEnd
		;Sleep(500)
		Interact($item[2], $item[3], $item[4])
		Sleep(100)
	EndIf

EndFunc   ;==>OpenWp


;;--------------------------------------------------------------------------------
;;   TakeWP()
;;--------------------------------------------------------------------------------
Func TakeWP($tarChapter, $tarNum, $curChapter, $curNum)
	If $GameFailed = 0 Then
		Local $Waypoint = ""


		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - TakeWP')
			Return False
		EndIf



		;*******************************************************
		Local $index, $offset, $count, $item[10], $maxRange = 80
		StartIterateObjectsList($index, $offset, $count)
		While IterateObjectsList($index, $offset, $count, $item)
			If (StringInStr($item[1], "waypoint_arrival_ribbonGeo") And $item[9] < $maxRange) Or (StringInStr($item[1], "waypoint_neutral_ringGlow") And $item[9] < $maxRange) Or (StringInStr($item[1], "waypoint_neutral_ringGlow") And $item[9] < $maxRange) Then
				If StringInStr($item[1], "waypoint_arrival_ribbonGeo") Then
					$Waypoint = "waypoint_arrival_ribbonGeo"
				ElseIf StringInStr($item[1], "waypoint_neutral_ringGlow") Then
					$Waypoint = "waypoint_neutral_ringGlow"
				Else
					$Waypoint = "Waypoint_Town"
				EndIf
				ExitLoop
			EndIf
		WEnd

		If $Waypoint = "" Then
			$Waypoint = "waypoint"
		EndIf

		;******************************************************

		If $Waypoint = "waypoint" Then ;WAYPOINT PAR DEFAUT ON a PAS TROUVER ITEM
			_Log("enclenchement Old waypoint")
			InteractByActorName($Waypoint)
			Sleep(350)
			Local $wptry = 0
			While IsWaypointSelectionOpened() = False And IsPlayerDead() = False
				If $wptry <= 6 Then
					_Log('Fail to open wp')
					$wptry = $wptry + 1
					InteractByActorName($Waypoint)
				EndIf
				If $wptry > 6 Then
					$GameFailed = 1
					_Log('Failed to open wp after 6 try')
					ExitLoop
				EndIf
			WEnd

		Else ;WAYPOINT DEFINIT, ON A ITEM
			_Log("enclechement new waypoint")
			OpenWp($item)
			Sleep(350)
			Local $wptry = 0
			While IsWaypointSelectionOpened() = False And IsPlayerDead() = False
				If $wptry <= 6 Then
					_Log('Fail to open wp')
					$wptry = $wptry + 1
					OpenWp($item)
				EndIf
				If $wptry > 6 Then
					$GameFailed = 1
					_Log('Failed to open wp after 6 try')
					ExitLoop
				EndIf
			WEnd

		EndIf

		If $tarChapter <> $curChapter Or ($tarChapter = $curChapter And $tarChapter < $curChapter) Then
			For $i = 0 To $tarChapter - 1
				$coord = UiRatio(35, 100 + ($i * 12.5))
				MouseClick("left", $coord[0], $coord[1], 1, 3) ; Close chapters
			Next
			$coord = UiRatio(145, 100 + ($tarChapter * 12.5) + 23 + ($tarNum * 32))
			MouseClick("left", $coord[0], $coord[1], 1, 3) ; Click wp
		EndIf
		If $tarChapter = $curChapter And $tarChapter > $curChapter Then
			For $i = 0 To $tarChapter - 1
				$coord = UiRatio(35, 100 + ($i * 12.5))
				MouseClick("left", $coord[0], $coord[1], 1, 3) ; Close chapters
			Next
			$coord = UiRatio(145, 100 + ($tarChapter * 12.5) + 23 + 12 + ($tarNum * 32))
			MouseClick("left", $coord[0], $coord[1], 1, 3) ; Click wp
		EndIf
		Sleep(1500)

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - TakeWP')
			Return False
		EndIf
		$SkippedMove = 0 ;reset ouur skipped move count cuz we should be in brand new area
	EndIf
EndFunc   ;==>TakeWP

;;--------------------------------------------------------------------------------
;;      Repair()
;;--------------------------------------------------------------------------------
Func Repair()
	InteractByActorName($RepairVendor)
	Sleep(700)
	Local $vendortry = 0
	While IsVendorOpened() = False
		If $vendortry <= 4 Then
			_Log('Fail to open vendor')
			$vendortry = $vendortry + 1
			InteractByActorName($RepairVendor)
		EndIf
		If $vendortry > 4 Then
			_Log('Failed to open Vendor after 4 try')
			$GameFailed = 1
			Return False ; on ne termine plus, on sort de la fonction
			ExitLoop
		EndIf
	WEnd
	GetRepairTab()

	$coord = UiRatio(290, 130 + ($RepairTab * 70))
	MouseClick("left", $coord[0], $coord[1], 1, 3) ; Repair tab
	Sleep(100)
	$coord = UiRatio(150, 330)
	MouseClick("left", $coord[0], $coord[1], 1, 3) ; Repair Button
	Sleep(100)
	Send("{SPACE}")
EndFunc   ;==>Repair

Func CastSpell($i)

	Dim $buff_table[11]
	Switch $i

		Case 0
			$buff_table = $Skill1
		Case 1
			$buff_table = $Skill2
		Case 2
			$buff_table = $Skill3
		Case 3
			$buff_table = $Skill4
		Case 4
			$buff_table = $Skill5
		Case 5
			$buff_table = $Skill6
	EndSwitch

	If $buff_table[1] = False Then
		Switch $buff_table[6]
			Case "right"
				MouseClick("right")
			Case "left"
				MouseClick("left")
			Case Else
				Send($buff_table[6])
		EndSwitch
		Sleep(10)

	ElseIf $buff_table[1] And IsPowerReady($_MyGuid, $buff_table[9]) Then
		Switch $buff_table[6]
			Case "right"
				MouseClick("right")
			Case "left"
				MouseClick("left")
			Case Else

				Send($buff_table[6])

		EndSwitch
;~ 		Sleep(10)

	EndIf

EndFunc   ;==>CastSpell

; TODO : check si c'est le bon fichier
Func ManageSpellCasting($Distance, $action_spell, $elite, $Guid = 0, $offset = 0)

	; $action_spell = 0 -> movetopos
	; $action_spell = 1 -> attack
	; $action_spell = 2 -> grab

	CheckDrinkPotion()

	For $i = 0 To 5

		Dim $buff_table[11]

		Switch $i

			Case 0
				$buff_table = $Skill1
			Case 1
				$buff_table = $Skill2
			Case 2
				$buff_table = $Skill3
			Case 3
				$buff_table = $Skill4
			Case 4
				$buff_table = $Skill5
			Case 5
				$buff_table = $Skill6
		EndSwitch



		Switch $buff_table[5]
			Case "spirit"
;~ 				$source = 0x3000
				$MaximumSource = $MaximumSpirit
			Case "fury"
;~ 				$source = 0x2000
				$MaximumSource = $MaximumFury
			Case "arcane"
;~ 				$source = 0x1000
				$MaximumSource = $MaximumArcane
			Case "mana"
;~ 				$source = 0
				$MaximumSource = $MaximumMana
			Case "hatred"
;~ 				$source = 0x5000
				$MaximumSource = $MaximumHatred
			Case "discipline"
				$MaximumSource = $MaximumDiscipline
;~ 				$source = 0x6000
			Case Else
				$MaximumSource = 15000
;~ 				$source = 5000
		EndSwitch

		$source = GetResource($_MyGuid, $buff_table[5])

		If $buff_table[0] And ($source > $buff_table[4] / $MaximumSource Or $buff_table[5] = "") And (TimerDiff($buff_table[10]) > $buff_table[2] Or $buff_table[2] = "") Then ;skill Activ√©

			Switch $action_spell

				Case 0
					Switch $buff_table[3]
						Case 0
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 7
							If Not IsBuffActive($_MyGuid, $buff_table[9]) Then
;~ 					$timer_buff = TimerInit()
								If $nameCharacter = "DemonHunter" Then
									If IsBuffActive($_MyGuid, $DemonHunter_Chakram) = False Then

										Send("1")

									EndIf
								EndIf
								CastSpell($i)

								$buff_table[10] = TimerInit()
							EndIf


						Case 9
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Or ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 10
							If ($Distance <= $buff_table[8] Or $buff_table[8] = "") Or $action_spell <> 1 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 11
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 12
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 16
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Or $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 22
							CastSpell($i)
							$buff_table[10] = TimerInit()


					EndSwitch

				Case 1


					Switch $buff_table[3]
						Case 0
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 1
							If $Distance <= $buff_table[8] Or $buff_table[8] = "" Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 2
							CastSpell($i)

						Case 3
							If $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()

							EndIf

						Case 4
							If Not IsBuffActive($_MyGuid, $buff_table[9]) And $action_spell = 1 Then

								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 5
;~ 			    local $IgnoreList=""
							;Not IsBuffActive($_MyGuid, $buff_table[9]) And
							If $buff_table[8] = "" Then
								$dist = 20
							Else
								$dist = $buff_table[8]
							EndIf

							If $action_spell = 1 And IterateFilterZone($dist) Then
								_Log("mauvais click droit")
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 6
;~ 			    local $IgnoreList=""
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Then
								If $buff_table[8] = "" Then
									$dist = 20
								Else
									$dist = $buff_table[8]
								EndIf
								If IterateFilterZone($dist) Then
									CastSpell($i)
									$buff_table[10] = TimerInit()
								EndIf
							EndIf


						Case 8
							If GetLifeLeftPercent() <= $buff_table[7] / 100 And ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf
						Case 11
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 13
							If IsBuffActive($_MyGuid, $buff_table[9]) = False And GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 14
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 15
							If IsBuffActive($_MyGuid, $buff_table[9]) = False And ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 17
							If GetLifeLeftPercent() <= $buff_table[7] / 100 And $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 18
							If ($Distance <= $buff_table[8] Or $buff_table[8] = "") Or $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 19
							If ($Distance <= $buff_table[8] Or $buff_table[8] = "") And $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 20
							If IsBuffActive($_MyGuid, $buff_table[9]) = False And $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 21
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 22
							CastSpell($i)
							$buff_table[10] = TimerInit()

					EndSwitch

				Case 2
					Switch $buff_table[3]
						Case 0
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf
						Case 22
							CastSpell($i)
							$buff_table[10] = TimerInit()

						Case 7
							If Not IsBuffActive($_MyGuid, $buff_table[9]) Then
								$timer_buff = TimerInit()
								If IsBuffActive($_MyGuid, $DemonHunter_Chakram) = False Then

									If $nameCharacter = "DemonHunter" Then Send("1")

								EndIf
								CastSpell($i)

;~ 					Send("{" & $buff_table[6] & " down}")
;~ 					While Not IsBuffActive($_MyGuid, $buff_table[9])
;~ 						If TimerDiff($timer_buff) > 350 Then ExitLoop
;~ 						Sleep(50)
;~ 					WEnd
;~ 					Send("{" & $buff_table[6] & " up}")
								$buff_table[10] = TimerInit()
							EndIf

					EndSwitch
			EndSwitch


		EndIf

		If $i = 0 Then
			$Skill1 = $buff_table
		ElseIf $i = 1 Then
			$Skill2 = $buff_table
		ElseIf $i = 2 Then
			$Skill3 = $buff_table
		ElseIf $i = 3 Then
			$Skill4 = $buff_table
		ElseIf $i = 4 Then
			$Skill5 = $buff_table
		ElseIf $i = 5 Then
			$Skill6 = $buff_table
		EndIf

	Next

EndFunc   ;==>ManageSpellCasting

; TODO : check si c'est le bon fichier
Func ManageSpellInit()

	For $i = 0 To 5

		Dim $buff_table[11]
		Dim $buff_conf_table[6]

		If $i = 0 Then
			$buff_conf_table = $Skill_conf1
			$buff_table = $Skill1
		ElseIf $i = 1 Then
			$buff_conf_table = $Skill_conf2
			$buff_table = $Skill2
		ElseIf $i = 2 Then
			$buff_conf_table = $Skill_conf3
			$buff_table = $Skill3
		ElseIf $i = 3 Then
			$buff_conf_table = $Skill_conf4
			$buff_table = $Skill4
		ElseIf $i = 4 Then
			$buff_conf_table = $Skill_conf5
			$buff_table = $Skill5
		ElseIf $i = 5 Then
			$buff_conf_table = $Skill_conf6
			$buff_table = $Skill6
		EndIf


		If Not $buff_conf_table[0] Or $buff_conf_table[0] = "false" Then
			$buff_table[0] = False
		Else
			$buff_table[0] = True
		EndIf

		If $buff_table[0] Then ;Si skill actived

			If Not trim($buff_conf_table[1]) = "" Then ;Delay
				$buff_table[2] = $buff_conf_table[1]
			EndIf

			If Not trim($buff_conf_table[2]) = "" Then ;Type
				$buff_table[3] = $buff_conf_table[2]
			EndIf

			If Not trim($buff_conf_table[3]) = "" Then ;EnergyNeeds
				$buff_table[4] = $buff_conf_table[3]
			EndIf

			If Not trim($buff_conf_table[4]) = "" Then ;Trigger Life
				$buff_table[7] = $buff_conf_table[4]
			EndIf

			If Not trim($buff_conf_table[5]) = "" Then ;Trigger Distance
				$buff_table[8] = $buff_conf_table[5]
			EndIf

		EndIf

		Select

			Case $buff_table[3] = "life"
				$Type = 0

			Case $buff_table[3] = "attack"
				$Type = 1


			Case $buff_table[3] = "physical"
				$Type = 2

			Case $buff_table[3] = "elite"
				$Type = 3



			Case $buff_table[3] = "buff"
				$Type = 4


			Case $buff_table[3] = "zone"
				$Type = 5


			Case StringInStr($buff_table[3], "zone") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 6

			Case $buff_table[3] = "move"
				$Type = 7

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "attack")
				$Type = 8

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "attack")
				$Type = 9

			Case StringInStr($buff_table[3], "move") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "attack")
				$Type = 10

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "buff")
				$Type = 11

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "move")
				$Type = 12

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 13

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "buff")
				$Type = 14

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 15

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "elite")
				$Type = 16

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "elite")
				$Type = 17

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "elite")
				$Type = 18

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "elite")
				$Type = 19

			Case StringInStr($buff_table[3], "elite") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 20

			Case StringInStr($buff_table[3], "elite") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "buff")
				$Type = 21

			Case $buff_table[3] = "buff_permanent"
				$Type = 22

			Case $buff_table[3] = "canalisation"
				$Type = 23

		EndSelect

		$buff_table[3] = $Type

		If $i = 0 Then
			$Skill1 = $buff_table
		ElseIf $i = 1 Then
			$Skill2 = $buff_table
		ElseIf $i = 2 Then
			$Skill3 = $buff_table
		ElseIf $i = 3 Then
			$Skill4 = $buff_table
		ElseIf $i = 4 Then
			$Skill5 = $buff_table
		ElseIf $i = 5 Then
			$Skill6 = $buff_table
		EndIf
		_Log($buff_table[3])
	Next

EndFunc   ;==>ManageSpellInit

Func GoToTown()

	_Log("start loop IsOnLoginScreen() = False And IsInTown() = False And IsPlayerDead() = False")

	Local $nbTriesTownPortal = 0
	While (IsInTown() = False And IsInMenu() = False)
		$nbTriesTownPortal += 1

		If $nbTriesTownPortal < 3 Then
			If Not UseTownPortal(10) Then
				$nbTriesTownPortal = 3
			EndIf
		Else
			; On attack, au cas o√π il y aurait des mobs apr√®s les fail tp
			Attack()
			LeaveGame()
			$nbTriesTownPortal = 0
			Sleep(10000)
			While IsInMenu() = False
				Sleep(100)
			WEnd
			ExitLoop
		EndIf

		If IsDisconnected() Then
			_Log("Disconnected dc1")
			$disconnectcount += 1
			Sleep(1000)
			RandomMouseClick(398, 349)
			RandomMouseClick(398, 349)
			Sleep(1000)
			While Not (IsOnLoginScreen() Or IsInMenu())
				Sleep(Random(80000, 15000))
			WEnd
			ExitLoop
		EndIf
	WEnd

	RandSleep()
EndFunc   ;==>GoToTown

Func TpRepairAndBack()

	$PortBack = False

	If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_INVENTORY_FULL) ; TChat

	While Not IsInTown()
		If Not UseTownPortal() Then
			$GameFailed = 1
			Return False
		EndIf

	WEnd

	$PortBack = True


	StashAndRepair()

	If $PortBack Then

		If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_BACK_REPAIR) ; TChat
		SafePortBack()

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - TpRepairAndBack')
		EndIf
	EndIf

	$games = 0

EndFunc   ;==>TpRepairAndBack

Func StashAndRepair()

	_Log("Func StashAndRepair")
	$RepairORsell += 1
	$item_to_stash = 0
	$FailOpen_BookOfCain = 0

	If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_SALE) ; TChat

	If trim(StringLower($Unidentified)) = "true" Or (trim(StringLower($Unidentified) = "false") And trim(StringLower($Identified)) = "false") Then ; swicht unidentifier
		_Log("Unidentified")

		While IsInventoryOpened() = False
			Send("i")
			Sleep(Random(200, 300))
		WEnd

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - StashAndRepair')
			Return False
		EndIf

		Sleep(Random(500, 1000))

		_Log('Filter Backpack2')
		$items = FilterBackpack2()
		$ToStash = _ArrayFindAll($items, "Stash", 0, 0, 0, 1, 2)

		If $FailOpen_BookOfCain = 1 Then
			$GameFailed = 1
			Return False
		EndIf
		
		If $ToStash <> -1 Then
			Send("{SPACE}")
			Sleep(500)
			InteractByActorName($actorStash)
			Sleep(700)
			Local $stashtry = 0

			While IsStashOpened() = False
				If $stashtry <= 4 Then
					_Log('Fail to open Stash')
					$stashtry += 1
					InteractByActorName($actorStash)
					Sleep(Random(100, 200))

				Else
					_Log('Failed to open Stash after 4 try')
					$GameFailed = 1
					Return False ; on ne termine plus, on sort de la fonction

				EndIf
			WEnd
			$tabfull = 0
			CheckWindowD3Size()

			For $i = 0 To UBound($ToStash) - 1
				_Log($items[$ToStash[$i]][0] & " stash : " & $items[$ToStash[$i]][1])

				Sleep(Random(100, 200))
				InventoryMove($items[$ToStash[$i]][0], $items[$ToStash[$i]][1])
				Sleep(Random(100, 500))

				MouseClick('Right')
				Sleep(Random(50, 200))
				If DetectUiError($MODE_STASH_FULL) Then
					_Log('Tab is full : Switching tab')
					CheckWindowD3Size()
					$i = $i - 1
					If $tabfull = 0 Then
						MouseClick('left', 286, 194, 5)
						$tabfull = 1
					ElseIf $tabfull = 1 Then
						MouseClick('left', 282, 266, 5)
						$tabfull = 2
					ElseIf $tabfull = 2 Then
						_Log('Stash is full : Botting stopped')
						Terminate()
					EndIf

					Sleep(5000)

				Else
					$ItemToStash = $ItemToStash + 1
				EndIf
			Next

			Sleep(Random(50, 100))
			Send("{SPACE}")
			Sleep(Random(100, 150))

			;****************************************************************
			If Not VerifAttributeGlobalStuff() Then
				_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - Stash)!!!!!")
				AntiIdle()
			EndIf
			;****************************************************************

		EndIf

	EndIf ; fin swicht Unidentier

	If trim(StringLower($Identified)) = "true" Then ;swicht identifier

		_Log("Identified")

		While IsInventoryOpened() = False
			Send("i")
			Sleep(Random(200, 300))
		WEnd

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - StashAndRepairs')
			Return False
		EndIf

		Sleep(Random(500, 1000))

		_Log('Filter Backpack')
		$items = FilterBackpack()
		$ToStash = _ArrayFindAll($items, "Stash", 0, 0, 0, 1, 2)
		
		If $FailOpen_BookOfCain = 1 Then
			$GameFailed = 1
			Return False
		EndIf

		If $ToStash <> -1 Then
			Send("{SPACE}")
			Sleep(500)
			InteractByActorName($actorStash)
			Sleep(700)
			Local $stashtry = 0

			While IsStashOpened() = False
				If $stashtry <= 4 Then
					_Log('Fail to open Stash')
					$stashtry += 1
					InteractByActorName($actorStash)
					Sleep(Random(100, 200))

				Else
					_Log('Failed to open Stash after 4 try')
					$GameFailed = 1
					Return False ; on ne termine plus, on sort de la fonction

				EndIf
			WEnd
			$tabfull = 0
			CheckWindowD3Size()

			For $i = 0 To UBound($ToStash) - 1
				_Log($items[$ToStash[$i]][0] & " stash : " & $items[$ToStash[$i]][1])

				Sleep(Random(100, 200))
				InventoryMove($items[$ToStash[$i]][0], $items[$ToStash[$i]][1])
				Sleep(Random(100, 500))

				MouseClick('Right')
				Sleep(Random(50, 200))
				If DetectUiError($MODE_STASH_FULL) Then
					_Log('Tab is full : Switching tab')
					CheckWindowD3Size()
					$i = $i - 1
					If $tabfull = 0 Then
						MouseClick('left', 286, 194, 5)
						$tabfull = 1
					ElseIf $tabfull = 1 Then
						MouseClick('left', 282, 266, 5)
						$tabfull = 2
					ElseIf $tabfull = 2 Then
						_Log('Stash is full : Botting stopped')
						Terminate()
					EndIf

					Sleep(5000)

				Else
					$ItemToStash = $ItemToStash + 1
				EndIf
			Next

			Sleep(Random(50, 100))
			Send("{SPACE}")
			Sleep(Random(100, 150))

			;****************************************************************
			If Not VerifAttributeGlobalStuff() Then
				_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - Stash)!!!!!")
				AntiIdle()
			EndIf
			;****************************************************************

		EndIf ; fin swicht Indentifier

	EndIf

	Sleep(Random(100, 200))
	Send("{SPACE}")
	Sleep(Random(100, 200))
	Sleep(Random(500, 1000))
	
	If (trim(StringLower($Unidentified)) = "true" And trim(StringLower($Identified)) = "false") Then
		UseBookOfCain()
		Sleep(Random(100, 200))
		Send("{SPACE}")
		Sleep(Random(100, 200))
	EndIf
	
	If $FailOpen_BookOfCain = 1 Then
		$GameFailed = 1
		Return False
	EndIf  

	; <<<<<<<<<<<<<<<<<<<<<<<<<        Test pour le recyclage ITEM  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	$ToRecycle = _ArrayFindAll($items, "Recycle", 0, 0, 0, 1, 2)

	If $ToRecycle <> -1 Then
		Send("{SPACE}")
		Sleep(500)
		InteractByActorName('Blacksmith_RepairShortcut')
		Sleep(700)
		Local $stashtry = 0

		$tabfull = 0
		CheckWindowD3Size()
		MouseMove(150, 150, 2) ; clic sur dez
		MouseClick('Left')

		For $i = 0 To UBound($ToRecycle) - 1

			_Log($items[$ToRecycle[$i]][0] & " stash : " & $items[$ToRecycle[$i]][1])
			Sleep(Random(100, 200))
			InventoryMove($items[$ToRecycle[$i]][0], $items[$ToRecycle[$i]][1]);dez l'objet
			Sleep(Random(100, 500))

			MouseClick('Left')
			Sleep(Random(40, 250))
			$ItemToRecycle += 1 ;on compste les objets recycl√©s
			If $items[$ToRecycle[$i]][3] > 8 Then ; si leg ou plus, clique sur OK
				MouseMove(300, 210, 2)
				Sleep(Random(100, 500))
				MouseClick('Left')
			EndIf

		Next

		Sleep(Random(50, 100))
		Send("{SPACE}")
		Sleep(Random(100, 150))

		;****************************************************************
		If Not VerifAttributeGlobalStuff() Then
			_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - Stash)!!!!!")
			AntiIdle()
		EndIf
		;****************************************************************

	EndIf

	; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<          Fin de test recyclage ITEM          >>>>>>>>>>>>>>>>>>>>>>

	;on mesure l'or avant la r√©paration
	Local $GoldBeforeRepaire = GetGold()

	Repair()
	Sleep(Random(100, 200))
	Send("{SPACE}")
	Sleep(Random(100, 200))

	;on mesure l'or apr√®s
	Local $GoldAfterRepaire = GetGold()
	$GoldByRepaire += $GoldAfterRepaire - $GoldBeforeRepaire;on compte le cout de la r√©paration

	;Trash
	$ToTrash = _ArrayFindAll($items, "Trash", 0, 0, 0, 1, 2)
	If $ToTrash <> -1 Then
		Sleep(Random(100, 200))
		Send("{SPACE}")
		Sleep(500)

		;on mesure l'or avant la vente d'objets
		Local $GoldBeforeSell = GetGold()
		InteractByActorName($RepairVendor)
		Sleep(600)
		Local $vendortry = 0
		While Not IsVendorOpened()
			If $vendortry < 6 Then
				_Log('Fail to open vendor')
				$vendortry += 1
				InteractByActorName($RepairVendor)
			Else
				_Log('Failed to open Vendor after 5 try')
				$GameFailed = 1
				Return False ; on ne termine plus, on sort de la fonction 
				ExitLoop
			EndIf
		WEnd
		CheckWindowD3Size()
		For $i = 0 To UBound($ToTrash) - 1
			InventoryMove($items[$ToTrash[$i]][0], $items[$ToTrash[$i]][1])
			Sleep(Random(100, 350))
			$ItemToSell += 1
			MouseClick('Right')
			Sleep(Random(100, 200))
		Next
		Sleep(Random(100, 200))
		Send("{SPACE}")
		Sleep(Random(100, 200))
		; on mesure l'or apr√®s
		Local $GoldAfterSell = GetGold()
		$GoldBySale += $GoldAfterSell - $GoldBeforeSell;on compte l'or par vente

		;****************************************************************
		If Not VerifAttributeGlobalStuff() Then
			_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - vendeur)!!!!!")
			AntiIdle()
		EndIf
		;****************************************************************

	EndIf
EndFunc   ;==>StashAndRepair

Func UseTownPortal($mode = 0)

	If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_TP) ; TChat

	Local $compt = 0

	While Not IsInTown() And IsInGame()
		
		Local $try = 0
		Local $TPtimer = 0
		Local $compt_while = 0
		Local $Attacktimer = 0
		
		$compt += 1

		_Log("tour de boucle IsInTown " & $compt & " tentative de TP")
		
		If $mode <> 0 And $compt > $mode Then
			_Log("Too Much TP try !!!")
			ExitLoop
		EndIf

		_Log("enclenche attack")
		$grabskip = 1
		Attack()
		$grabskip = 0

		Sleep(100)

		If IsPlayerDead() = False Then

			Sleep(250)
			_Log("on enclenche le TP")
			Send("t")
			Sleep(250)

			If $Choix_Act_Run < 100 And DetectUiError($MODE_BOSS_TP_DENIED) And Not IsInTown() Then
				_Log('Detection Asmo room')
				Return False
			EndIf

			$Current_area = GetLevelAreaId()

			_Log("enclenchement fastCheckui de la barre de loading")

			If DetectUiError($MODE_INVENTORY_FULL) = False And $GameFailed = 0 Then
				_Log("enclenchement fastCheckui de la barre de loading")

			    While FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter.progressBar", 1, 996) ; dÈtection la barre de TP
				    If $compt_while = 0 Then
					   _Log("enclenchement du timer")
					   $TPtimer = TimerInit() ; temp total de la boucle
					EndIf
					$compt_while += 1

					CheckDrinkPotion() ; si dans la lave, spore... ect prendre une potion pour la survie

					$Attacktimer = TimerInit()
					Attack() ; si mob on attaque
					Sleep(100)
					TimerDiff($Attacktimer) ; temps de la durÈe du combat
					
					If IsPlayerDead() = True Or $GameFailed = 1 Then
						ExitLoop
					EndIf
			    WEnd
			Else ; si inventaire plein
				_Log("enclenchement fastCheckui de la barre de loading, MODE_INVENTORY_FULL")

				While FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter.progressBar", 1, 996) ; dÈtection la barre de TP
					If $compt_while = 0 Then
					  _Log("enclenchement du timer")
					  $TPtimer = Timerinit() ; temp total de la boucle
				    EndIF
				    $compt_while += 1

				    $Attacktimer = TimerInit()
				    Sleep(100)
				    TimerDiff($Attacktimer) ; temps des sleep
				WEnd	
			EndIf			

			If $compt_while = 0 Then ; si pas de dÈtection de la barre de TP
			    $CurrentLoc = GetCurrentPos()
				MoveToPos($CurrentLoc[0] + 5, $CurrentLoc[1] + 5, $CurrentLoc[2], 0, 6); on se dÈplace
				_Log("On se dÈplace, pas de dÈtection de la barre de TP")
			Else
			    _Log("compare time to tp -> " & (TimerDiff($TPtimer) - TimerDiff($Attacktimer)) & "> 3700 ") ; valeur test de 3600 a 4000
			EndIf
			 
			If (TimerDiff($TPtimer) - TimerDiff($Attacktimer)) > 3700 And $compt_while > 0 Then
				While Not IsInTown() And $try < 6
					 _Log("on a peut etre reussi a tp, on reste inerte pendant 6sec voir si on arrive en ville, tentative -> " & $try)
					 $try += 1
					 Sleep(1000)
				WEnd
			EndIf

			Sleep(500)


			If $Current_area <> GetLevelAreaId() Then
				_Log("Changement d'arreat, on quite la boucle")
				ExitLoop
			EndIf

		Else
			_Log("Vous etes morts lors d'une tentative de teleporte !!!")
			Return False
		EndIf

		Sleep(100)
		$PortBack = True
	WEnd

	Local $hTimer = TimerInit()
	While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
		Sleep(40)
	WEnd

	If TimerDiff($hTimer) >= 30000 Then
		_Log('Fail to use OffsetList - TakeWP')
		Return False
	EndIf

	_Log("on a renvoyer true, quite bien la fonction")

	Return True
EndFunc   ;==>UseTownPortal

Func UseTownPortal2()
	Do ;execute au moins 1 fois de tp avant de faire le test du until
		If IsPlayerDead() = False Then
			_Log("enclenche attack")
			$grabskip = 1
			Attack()
			$grabskip = 0
			Sleep(250)
			_Log("on enclenche TP")
			Send("t")
			Sleep(250)
			While (FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter.progressBar", 1, 996)) ; on attend que la barre du tp disparaise pour tester si on est en ville
			WEnd
		Else
			_Log("Vous etes morts lors d'une tentative de teleporte !!!")
			Return False
		EndIf
	Until IsInTown() ;Tant qu'on est pas en ville
	Return True
EndFunc   ;==>UseTownPortal2

;;--------------------------------------------------------------------------------
;;      MoveToPos()
;;--------------------------------------------------------------------------------
Func MoveToPos($_x, $_y, $_z, $_a, $m_range)
	Local $TimeOut = TimerInit()
	$grabtimeout = 0
	$killtimeout = 0
	If IsPlayerDead() Or $CheckGameLength = True Or $GameFailed = 1 Or $SkippedMove > 6 Then
		$GameFailed = 1
		Return
	EndIf
	Local $toggletry = 0
	Global $lastwp_x = $_x
	Global $lastwp_y = $_y
	Global $lastwp_z = $_z
	If $_a = 1 Then Attack()
	$Coords = FromD3ToScreenCoords($_x, $_y, $_z)
	MouseMove($Coords[0], $Coords[1], 3)
	$LastCP = GetCurrentPos()
	MouseDown("middle")
	Sleep(10)
	While 1

		CheckGameLength()
		If $CheckGameLength = True Then
			ExitLoop
		EndIf

		ManageSpellCasting(0, 0, 0)

		$CurrentLoc = GetCurrentPos()
		$xd = $lastwp_x - $CurrentLoc[0]
		$yd = $lastwp_y - $CurrentLoc[1]
		$zd = $lastwp_z - $CurrentLoc[2]
		$Distance = Sqrt($xd * $xd + $yd * $yd + $zd * $zd)
		If $Distance < $m_range Then ExitLoop
		Local $angle = 1
		Local $Radius = 25


		While Not IsPlayerMoving()
			;_Log("Togglemove : " & _MemoryRead($ClickToMoveToggle, $d3, 'float'))
			$Coords = FromD3ToScreenCoords($_x, $_y, $_z)
			$angle += $Step
			$Radius += 45


			; ci desssous du dirty code pour eviter de cliquer n'importe ou hos de la fenetre du jeu
			$Coords[0] = $Coords[0] - (Cos($angle) * $Radius)
			$Coords[1] = $Coords[1] - (Sin($angle) * $Radius)

			Switch $Coords[0] ;car on a pas l'envie de cliquer dans les icone du chat
				Case 791 To 800
					$Coords[0] = 790
				Case 0 To 39
					$Coords[0] = 40
			EndSwitch
			Switch $Coords[1] ;car on a pas l'envie de cliquer dans la bare des skills
				Case 541 To 600
					$Coords[1] = 540
				Case 0 To 9
					$Coords[1] = 10
			EndSwitch

			MouseMove($Coords[0], $Coords[1], 3)
			$toggletry += 1
			;_Log("Tryin move :" & " x:" & $_x & " y:" & $_y & "coords: " & $Coords[0] & "-" & $Coords[1] & " angle: " & $angle & " Toggle try: " & $toggletry)

			If RevivePlayerDead() Then
				ExitLoop 2
			EndIf

			If $angle >= 2.0 * $PI Or $toggletry > 9 Or IsPlayerDead() Then
				$SkippedMove += 1
				_Log("Toggle try: " & $toggletry & " Movement Skipped : " & $SkippedMove)
				ExitLoop 2 ; le 2 signifie que l'on quitte 2 loop
			EndIf
			Sleep(10)
		WEnd
		Sleep(10)
		$Coords = FromD3ToScreenCoords($lastwp_x, $lastwp_y, $lastwp_z)
		;_Log("currentloc: " & $_Myoffset & " - "&$CurrentLoc[0] & " : " & $CurrentLoc[1] & " : " & $CurrentLoc[2] &@CRLF)
		;_Log("distance/m range: " & $Distance & " : " & $m_range & @CRLF)
		If $_a = 1 And GetDistance($LastCP[0], $LastCP[1], $LastCP[2]) >= $a_range / 2 Then
			MouseUp("middle")
			$LastCP = GetCurrentPos()
			If $_a = 1 Then Attack()
			;_Log("Last check: " & $Distance & @CRLF)

			$Coords_RndX = $Coords[0] + Random(-17, 17)
			$Coords_RndY = $Coords[1] + Random(-17, 17)

			If $Coords_RndX < 40 Then
				$Coords_RndX = 40
			ElseIf $Coords_RndX > 790 Then
				$Coords_RndX = 790
			EndIf

			If $Coords_RndY < 10 Then
				$Coords_RndY = 10
			ElseIf $Coords_RndY > 540 Then
				$Coords_RndY = 540
			EndIf


			MouseMove($Coords_RndX, $Coords_RndY, 3) ;little randomisation
			MouseDown("middle")
		EndIf
		MouseMove($Coords[0], $Coords[1], 3)
		If TimerDiff($TimeOut) > 75000 Then
			_Log("MoveToPos Timed out ! ! ! ")
			If IsDisconnected() Then
				$GameFailed = 1
			EndIf

			ExitLoop
		EndIf
	WEnd
	MouseUp("middle")
	;;
	;Sleep(100)
EndFunc   ;==>MoveToPos

Func MaffMove($_x_aff, $_y_aff, $_z_aff, $x_mob, $y_mob)
	ResetTimerIgnore()
	If TimerDiff($maff_timer) > 500 Then
		Dim $item_maff_move = IterateFilterAffix()
		If IsArray($item_maff_move) Then
			$a = 0
			While $a <= UBound($item_maff_move) - 1
				CheckDrinkPotion()
				MouseUp('left')
;~ 			   $dist_aff=sqrt(($_x_aff-$item_maff_move[$a][2])*($_x_aff-$item_maff_move[$a][2]) + ($_y_aff-$item_maff_move[$a][3])*($_y_aff-$item_maff_move[$a][3]) + ($_z_aff-$item_maff_move[$a][4])*($_z_aff-$item_maff_move[$a][4]))
				If $item_maff_move[$a][9] < $item_maff_move[$a][10] And IsPlayerDead() = False Then
					Dim $move_coords[2]
					$move_coords = FindSafeZone($_x_aff, $_y_aff, $item_maff_move, $_z_aff, $x_mob, $y_mob)
					$Coords_affixe = FromD3ToScreenCoords($move_coords[0], $move_coords[1], $_z_aff)
					MouseMove($Coords_affixe[0], $Coords_affixe[1], 3)
					ManageSpellCasting(0, 0, 0)
					MouseClick("middle")
					$ignore_timer = TimerInit()

					While IsPlayerMoving()

;~ 					 ManageSpellCasting(0, 2, 0)
						If TimerDiff($ignore_timer) > 10000 Then ExitLoop
						Sleep(10)

					WEnd
					If TimerDiff($ignore_timer) < 30 Then
						$nbr_ignore = UBound($ignore_affix)
						ReDim $ignore_affix[$nbr_ignore + 1][2]
						$ignore_affix[$nbr_ignore][0] = $move_coords[0]
						$ignore_affix[$nbr_ignore][1] = $move_coords[1]
					EndIf

					$maff_timer = TimerInit()
					ExitLoop

				EndIf
				$a += 1
			WEnd
		EndIf

	EndIf
EndFunc   ;==>MaffMove

Func UseBookOfCain()

	If IsInventoryOpened() = True Then
		Send("i")
		Sleep(150)
	EndIf

	Switch $Act
		Case 1
			InteractByActorName("Waypoint_Town");ajouter pour ne pas blocqu√© au coffre
			MoveToPos(2955.8681640625, 2803.51489257813, 24.0453319549561, 0, 20)
		Case 2
			;do nothing act 2
		Case 3 To 4
			MoveToPos(395.930847167969, 390.577362060547, 0.408410131931305, 0, 20)
	EndSwitch

	InteractByActorName("All_Book_Of_Cain")
	While Not FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512) And Not DetectUiError($MODE_NO_IDENTIFIED_ITEM)
		;_Log("Ui : " & FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512) & " Error : " &  FastCheckUiItemVisible("Root.TopLayer.error_notify.error_text", 1, 1185))
		_Log("tour boucle")
		If Not FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512) Then
			If Not IsDisconnected() Then
			    InteractByActorName("All_Book_Of_Cain")
			Else
			    _Log("Failed to open Book Of Cain")
			    $FailOpen_BookOfCain = 1
			    Return False
			EndIf
		EndIf
	WEnd
	While FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512)
		Sleep(50)
	WEnd
EndFunc   ;==>UseBookOfCain

Func MoveToPointZero();function qui a pour bu de le placer au point voulu dans chaque act

	If IsInventoryOpened() = True Then
		Send("i")
		Sleep(150)
	EndIf

	Switch $Act
		Case 1
			MoveToPos(2955.8681640625, 2803.51489257813, 24.0453319549561, 0, 20)
		Case 2
			;do nothing act 2
		Case 3 To 4
			;do nothing act 3 and 4
	EndSwitch

	Sleep(50)
EndFunc   ;==>MoveToPointZero

Func GetGold()
	IterateLocalActor()
	$foundobject = 0
	For $i = 0 To UBound($__ACTOR, 1) - 1
		If StringInStr($__ACTOR[$i][2], "GoldCoin-") Then
			Return IterateActorAttributes($__ACTOR[$i][1], $Atrib_ItemStackQuantityLo)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc   ;==>GetGold

;;--------------------------------------------------------------------------------
;;     Initialise Buffs while in training Area
;;--------------------------------------------------------------------------------
Func Buffinit()
	If $delaiBuff1 Then
		AdlibRegister("buff1", $delaiBuff1 * Random(1, 1.2))

	EndIf
	If $PreBuff1 = "true" Then
		buff1()
		Sleep(400)
	EndIf
	If $delaiBuff2 Then
		AdlibRegister("buff2", $delaiBuff2 * Random(1, 1.2))

	EndIf
	If $PreBuff2 = "true" Then
		buff2()
		Sleep(400)
	EndIf
	If $delaiBuff3 Then
		AdlibRegister("buff3", $delaiBuff3 * Random(1, 1.2))

	EndIf
	If $PreBuff3 = "true" Then
		buff3()
		Sleep(400)
	EndIf
	If $delaiBuff4 Then
		AdlibRegister("buff4", $delaiBuff4 * Random(1, 1.2))

	EndIf
	If $PreBuff4 = "true" Then
		buff4()
		Sleep(400)
	EndIf
EndFunc   ;==>Buffinit

;;--------------------------------------------------------------------------------
;;     Stop All buff timers
;;--------------------------------------------------------------------------------
Func UnBuff()
	If $delaiBuff1 Then
		AdlibUnRegister("buff1")
	EndIf
	If $delaiBuff2 Then
		AdlibUnRegister("buff2")
	EndIf
	If $delaiBuff3 Then
		AdlibUnRegister("buff3")
	EndIf
	If $delaiBuff4 Then
		AdlibUnRegister("buff4")
	EndIf
EndFunc   ;==>UnBuff
Func buff1()
	Send($ToucheBuff1)
EndFunc   ;==>buff1
Func buff2()
	Send($ToucheBuff2)
EndFunc   ;==>buff2
Func buff3()
	Send($ToucheBuff3)
EndFunc   ;==>buff3
Func buff4()
	Send($ToucheBuff4)
EndFunc   ;==>buff4

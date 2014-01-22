#include <Maths.au3>

;;--------------------------------------------------------------------------------
; Function:                     UsePath(ByRef $path)
; Description:
;;--------------------------------------------------------------------------------
Func UsePath(ByRef $path)

	Local $posIndex = GetNextIndex($path, 0)

	Local $lastIndexPos = 0
	For $i = 0 To UBound($path, 1) - 1
		If $path[$i][0] = 2 Then $lastIndexPos = $i
	Next

	Local $TimeOut = TimerInit()
	Local $toggletry = 0
	$grabtimeout = 0
	$killtimeout = 0

	$Coords = FromD3ToScreenCoords($path[$posIndex][1], $path[$posIndex][2], $path[$posIndex][3])
	MouseMove($Coords[0], $Coords[1], 3)
	$LastCP = GetCurrentPos()
	MouseDown("middle")
	Sleep(10)
	While 1

		If Revive($path) Then
			Return
		EndIf

		ManageSpellCasting(0, 0, 0)

		If IsPlayerDead() Or $CheckGameLength = True Or $GameFailed = 1 Or $SkippedMove > 6 Then
			$GameFailed = 1
			ExitLoop
		EndIf
		If TimerDiff($TimeOut) > 175000 Then
			_Log("UsePath Timed out ! ! ! ")
			$GameFailed = 1
			ExitLoop
		EndIf

		CheckGameLength()

		If $CheckGameLength = True Then
			ExitLoop
		EndIf

		$Distance = GetDistance($path[$posIndex][1], $path[$posIndex][2], $path[$posIndex][3])
		If $Distance < $path[$posIndex][5] Then
			If ($posIndex = $lastIndexPos) Then ExitLoop
			$posIndex = GetNextIndex($path, $posIndex + 1)
			$TimeOut = TimerInit()
			$toggletry = 0
			$grabtimeout = 0
			$killtimeout = 0
		EndIf

		Local $angle = 1
		Local $Radius = 25
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		While _MemoryRead($ClickToMoveToggle, $d3, 'float') = 0
			;_Log("Togglemove : " & _MemoryRead($ClickToMoveToggle, $d3, 'float'))

			MouseUp("middle")
			Attack()
			MouseDown("middle")

			$Coords = FromD3ToScreenCoords($path[$posIndex][1], $path[$posIndex][2], $path[$posIndex][3])
			$angle += $Step
			$Radius += 45

			;MouseMove($Coords[0] - (Cos($angle) * $Radius), $Coords[1] - (Sin($angle) * $Radius), 3)
			; ci desssous du dirty code pour eviter de cliquer n'importe ou hos de la fenetre du jeu
			$Coords[0] = $Coords[0] - (Cos($angle) * $Radius)
			$Coords[1] = $Coords[1] - (Sin($angle) * $Radius)
			$Coords[0] = _Min($Coords[0], 790)
			$Coords[0] = _Max($Coords[0], 40) ;car on a pas l'envie de cliquer dans les icone du chat
			$Coords[1] = _Min($Coords[1], 540);car on a pas l'envie de cliquer dans la bare des skills
			$Coords[1] = _Max($Coords[1], 10)

			$Coords_RndX = Random($Coords[0] - 20, $Coords[0] + 20)
			$Coords_RndY = Random($Coords[1] - 20, $Coords[1] + 20)

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

			$toggletry += 1
			;_Log("Tryin move :" & " x:" & $_x & " y:" & $_y & "coords: " & $Coords[0] & "-" & $Coords[1] & " angle: " & $angle & " Toggle try: " & $toggletry)
			If $angle >= 2.0 * $PI Or $toggletry > 9 Or IsPlayerDead() Then
				$SkippedMove += 1
				_Log("Toggle try: " & $toggletry & " Movement Skipped : " & $SkippedMove & " Pos Skipped : " & $posIndex)

				If ($posIndex = $lastIndexPos) Then ExitLoop 2
				$newIndex = GetNextPosIndex($path, $posIndex + 1)
				If ($newIndex <> $posIndex) Then
					_Log("MoveToPos pos " & $posIndex & " to pos " & $newIndex)
					$posIndex = $newIndex
					$TimeOut = TimerInit()
					$toggletry = 0
					$grabtimeout = 0
					$killtimeout = 0
				EndIf

				ExitLoop
			EndIf
			Sleep(10)
		WEnd

		Sleep(10)


		;_Log("currentloc: " & $_Myoffset & " - "&$CurrentLoc[0] & " : " & $CurrentLoc[1] & " : " & $CurrentLoc[2] &@CRLF)
		;_Log("distance/m range: " & $Distance & " : " & $pos[4] & @CRLF)
		If $path[$posIndex][4] = 1 And GetDistance($LastCP[0], $LastCP[1], $LastCP[2]) >= $a_range / 2 Then
			MouseUp("middle")
			$LastCP = GetCurrentPos()
			Attack()
			MouseDown("middle")
			;_Log("Last check: " & $Distance & @CRLF)
		EndIf
		$newIndex = GetNextIndex($path, $posIndex)
		If ($newIndex <> $posIndex) Then
			_Log("MoveToPos pos " & $posIndex & " to pos " & $newIndex)
			$posIndex = $newIndex
			$TimeOut = TimerInit()
			$toggletry = 0
			$grabtimeout = 0
			$killtimeout = 0
		EndIf
		$Coords = FromD3ToScreenCoords($path[$posIndex][1], $path[$posIndex][2], $path[$posIndex][3])

		$Coords_RndX = Random($Coords[0] - 20, $Coords[0] + 20)
		$Coords_RndY = Random($Coords[1] - 20, $Coords[1] + 20)

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

	WEnd

	For $i = $posIndex To UBound($path, 1) - 1
		TraitementSequence($path, $i)
	Next
	MouseUp("middle")
EndFunc   ;==>UsePath


Func GetNextIndex(ByRef $arr, $index)
	Local $resultIndexPoint = GetNextPosIndex($arr, $index)
	For $i = $index To $resultIndexPoint
		TraitementSequence($arr, $i)
	Next
	Return $resultIndexPoint
EndFunc   ;==>GetNextIndex

;;--------------------------------------------------------------------------------
; Function:                     GetNextPosIndex(ByRef $arr, $index)
; Description:          Return the nearest point with the good direction
;
; Note(s):              http://www.exaflop.org/docs/cgafaq/cga1.html
;;--------------------------------------------------------------------------------
Func GetNextPosIndex(ByRef $arr, $index)
	Local $size = UBound($arr, 1)
	If $index >= $size - 1 Then Return $index
	While ($index < $size And $arr[$index][0] <> 2)
		$index += 1
		If $index = $size - 1 Then Return $index
	WEnd

	Local $indexPoint = $index + 1
	If ($indexPoint > $size - 1) Then Return $index

	Local $resultIndexPoint = $index
	Local $DistanceMin = getDistance($arr[$resultIndexPoint][1], $arr[$resultIndexPoint][2], $arr[$resultIndexPoint][3])
	Local $CurrentLoc = GetCurrentPos()

	While $indexPoint < $size
		If $arr[$indexPoint][0] = 2 Then
			$Distance = getDistance($arr[$indexPoint][1], $arr[$indexPoint][2], $arr[$indexPoint][3])

			If $Distance > $DistanceMin Then
				Local $Ax = $arr[$resultIndexPoint][1]
				Local $Ay = $arr[$resultIndexPoint][2]
				Local $Bx = $arr[$indexPoint][1]
				Local $By = $arr[$indexPoint][2]
				Local $T = ($Ay - $CurrentLoc[1]) * ($Ay - $By) - ($Ax - $CurrentLoc[0]) * ($Bx - $Ax)
				Local $L = Sqrt(($Bx - $Ax) * ($Bx - $Ax) + ($By - $Ay) * ($By - $Ay))

				Local $R = $T / ($L * $L);
				If ($R > 0 And $R < 1) Then
					$resultIndexPoint = $indexPoint
				EndIf
				ExitLoop
			EndIf
			$DistanceMin = $Distance
			$resultIndexPoint = $indexPoint
		EndIf
		$indexPoint += 1
	WEnd
	Return $resultIndexPoint
EndFunc   ;==>GetNextPosIndex

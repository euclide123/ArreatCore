#include-once

 ; ------------------------------------------------------------
; Ce fichier contient toutes les fonctions diverse
; utilisée partout, non lié au bot ni au jeu
; -------------------------------------------------------------

Func Trim($String)
	Return StringReplace($String, " ", "", 0, 2)
EndFunc   ;==>Trim

Func AntiIdle()
	$CheckTakeShrinebanlist = 0
	$warnloc = GetCurrentPos()
	$warnarea = GetLevelAreaId()
	_Log("Lost detected at : " & $warnloc[0] & ", " & $warnloc[1] & ", " & $warnloc[2], 1);
	_Log("Lost area : " & $warnarea, 1);


	If IsInventoryOpened() = False Then
		Send("i")
		Sleep(150)
	EndIf

	Send("{PRINTSCREEN}")
	Sleep(150)
	Send("{SPACE}")

	ToolTip("Detection de stuff modifié !" & @CRLF & "Zone : " & $warnarea & @CRLF & "Position : " & $warnloc[0] & ", " & $warnloc[1] & ", " & $warnloc[2] & @CRLF & "Un screenshot a été pris, il se situe dans document/diablo 3", 15, 15)


	While Not IsInTown() And IsInGame()
		UseTownPortal()
		Sleep(100)
	WEnd

	;idleing
	While 1
		MouseClick("middle", Random(100, 200), Random(100, 200), 1, 6)
		Sleep(Random(40000, 180000))
		MouseClick("middle", Random(600, 700), Random(100, 200), 1, 6)
		Sleep(Random(40000, 180000))
		MouseClick("middle", Random(600, 700), Random(400, 500), 1, 6)
		Sleep(Random(40000, 180000))
		MouseClick("middle", Random(100, 200), Random(400, 500), 1, 6)
		Sleep(Random(40000, 180000))
	WEnd

EndFunc   ;==>AntiIdle

;----------------------------------------------------------------------------------------------------------------------
;   Fuction         _Array2DDelete(ByRef $ARRAY, $iDEL, $bCOL=False)
;
;   Description     Delete one row on a given index in an 1D/2D -Array
;
;   Parameter       $ARRAY      the array, where one row will deleted
;                   $iDEL       Row(Column)-Index to delete
;                   $bCOL       If True, delete column instead of row (default False)
;
;   Return          Succes      0   ByRef $ARRAY
;                   Failure     1   set @error = 1; given array are not array
;                                   set @error = 2; want delete column, but not 2D-array
;                                   set @error = 3; index is out of range
;
; Author            BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DDelete(ByRef $ARRAY, $iDEL, $bCOL = False)
	If (Not IsArray($ARRAY)) Then Return SetError(1, 0, 1)
	Local $UBound2nd = UBound($ARRAY, 2), $k
	If $bCOL Then
		If $UBound2nd = 0 Then Return SetError(2, 0, 1)
		If ($iDEL < 0) Or ($iDEL > $UBound2nd - 1) Then Return SetError(3, 0, 1)
	Else
		If ($iDEL < 0) Or ($iDEL > UBound($ARRAY) - 1) Then Return SetError(3, 0, 1)
	EndIf
	If $UBound2nd = 0 Then
		Local $arTmp[UBound($ARRAY) - 1]
		$k = 0
		For $i = 0 To UBound($ARRAY) - 1
			If $i <> $iDEL Then
				$arTmp[$k] = $ARRAY[$i]
				$k += 1
			EndIf
		Next
	Else
		If $bCOL Then
			Local $arTmp[UBound($ARRAY)][$UBound2nd - 1]
			For $i = 0 To UBound($ARRAY) - 1
				$k = 0
				For $l = 0 To $UBound2nd - 1
					If $l <> $iDEL Then
						$arTmp[$i][$k] = $ARRAY[$i][$l]
						$k += 1
					EndIf
				Next
			Next
		Else
			Local $arTmp[UBound($ARRAY) - 1][$UBound2nd]
			$k = 0
			For $i = 0 To UBound($ARRAY) - 1
				If $i <> $iDEL Then
					For $l = 0 To $UBound2nd - 1
						$arTmp[$k][$l] = $ARRAY[$i][$l]
					Next
					$k += 1
				EndIf
			Next
		EndIf
	EndIf
	$ARRAY = $arTmp
	Return $ARRAY
EndFunc   ;==>_Array2DDelete

; #FUNCTION# =====================================================================
; Name...........: __ArrayConcatenate
; Description ...: Concatenate two 1D or 2D arrays
; Syntax.........: __ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
; Parameters ....: $avArrayTarget - The array to concatenate onto
;				  $avArraySource - The array to concatenate from - Must be 1D or 2D to match $avArrayTarget,
;								   and if 2D, then Ubound($avArraySource, 2) <= Ubound($avArrayTarget, 2).
; Return values .: Success - Index of last added item
;				  Failure - -1, sets @error to 1 and @extended per failure (see code below)
; Author ........: Ultima
; Modified.......: PsaltyDS - 1D/2D version, changed return value and @error/@extended to be consistent with __ArrayAdd()
; Remarks .......:
; Related .......: __ArrayAdd, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================
Func __ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
	If Not IsArray($avArrayTarget) Then Return SetError(1, 1, -1); $avArrayTarget is not an array
	If Not IsArray($avArraySource) Then Return SetError(1, 2, -1); $avArraySource is not an array

	Local $iUBoundTarget0 = UBound($avArrayTarget, 0), $iUBoundSource0 = UBound($avArraySource, 0)
	If $iUBoundTarget0 <> $iUBoundSource0 Then Return SetError(1, 3, -1); 1D/2D dimensionality did not match
	If $iUBoundTarget0 > 2 Then Return SetError(1, 4, -1); At least one array was 3D or more

	Local $iUBoundTarget1 = UBound($avArrayTarget, 1), $iUBoundSource1 = UBound($avArraySource, 1)

	Local $iNewSize = $iUBoundTarget1 + $iUBoundSource1
	If $iUBoundTarget0 = 1 Then
		; 1D arrays
		ReDim $avArrayTarget[$iNewSize]
		For $i = 0 To $iUBoundSource1 - 1
			$avArrayTarget[$iUBoundTarget1 + $i] = $avArraySource[$i]
		Next
	Else
		; 2D arrays
		Local $iUBoundTarget2 = UBound($avArrayTarget, 2), $iUBoundSource2 = UBound($avArraySource, 2)
		If $iUBoundSource2 > $iUBoundTarget2 Then Return SetError(1, 5, -1); 2D boundry of source too large for target
		ReDim $avArrayTarget[$iNewSize][$iUBoundTarget2]
		For $r = 0 To $iUBoundSource1 - 1
			For $c = 0 To $iUBoundSource2 - 1
				$avArrayTarget[$iUBoundTarget1 + $r][$c] = $avArraySource[$r][$c]
			Next
		Next
	EndIf

	Return $iNewSize - 1
EndFunc   ;==>__ArrayConcatenate

;;--------------------------------------------------------------------------------
;;      CheckFromList()
;;--------------------------------------------------------------------------------
Func CheckFromList($list, $compare, $delimiter = '|')
	Local $arrayList = StringSplit($list, $delimiter)
	For $i = 1 To $arrayList[0]
		If StringInStr($compare, $arrayList[$i]) Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>CheckFromList


Func CheckStartListRegex($compare, $_NAME)
	Dim $tab_temp = StringSplit($compare, "|", 2)
	$count = UBound($tab_temp)
	For $i = 0 To $count - 1
		If StringRegExp($_NAME, "(?i)^" & $tab_temp[$i] & "") = 1 Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>CheckStartListRegex

Func CheckEndListRegex($compare, $_NAME)
	Dim $tab_temp = StringSplit($compare, "|", 2)
	$count = UBound($tab_temp)
	For $i = 0 To $count - 1
		If StringRegExp($_NAME, "(?i)" & $tab_temp[$i] & "$") = 1 Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>CheckEndListRegex

Func CheckFromTable($table, $compare, $quality)
	For $i = 0 To UBound($table) - 1
		If StringRegExp($compare, "(?i)^" & $table[$i][0] & "") = 1 And $quality >= $table[$i][2] Then
			;If StringInStr($compare, $table[$i][0]) And $quality >= $table[$i][2] Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>CheckFromTable

Func CheckILvlFromTable($table, $ACD, $compare)
	For $i = 0 To UBound($table) - 1
		If StringRegExp($compare, "(?i)^" & $table[$i][0] & "") = 1 Then
			;If StringInStr($compare, $table[$i][0]) Then
			If $table[$i][1] > 0 Then
				$ilvl = GetILvlFromACD($ACD)
				If $ilvl >= $table[$i][1] Then
					Return 1
				EndIf
			Else
				Return 1
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>CheckILvlFromTable

Func CheckFilterFromTable($table, $name, $CurrentIdAttrib)
	For $i = 0 To UBound($table) - 1
		If StringRegExp($name, "(?i)^" & $table[$i][0] & "") = 1 Then
			If Not $table[$i][3] = 0 Then
				$filtre_buff = $table[$i][3]
				$tab_filter = StringSplit($table[$i][4], "|", 2)
				_Log("filtre avant : " & $filtre_buff, 1)
				For $y = 0 To UBound($tab_filter) - 1
					$const_result = FilterToAttribute($CurrentIdAttrib, $tab_filter[$y])
					$filtre_buff = StringReplace($filtre_buff, $tab_filter[$y], $const_result, 0, 2)
					$filtre_buff = StringReplace($filtre_buff, ":", ">=", 0, 2)
				Next
				_Log("filtre apres : " & $filtre_buff, 1)
				If Execute($filtre_buff) Then
					_Log("execute donne true")
					Return True
				Else
					_Log("execute donne false")
					Return False
				EndIf
			EndIf
		EndIf
	Next

EndFunc   ;==>CheckFilterFromTable

;;================================================================================
; Function:			GetDistance($_x,$_y,$_z)
; Description:		Check distance between you and a desired position.
; Parameter(s):		$_x,$_y and $_z - the target position
;
; Note(s):			Returns a distance in float
;==================================================================================
Func GetDistance($_x, $_y, $_z)
	$CurrentLoc = GetCurrentPos()
	$xd = $_x - $CurrentLoc[0]
	$yd = $_y - $CurrentLoc[1]
	$zd = $_z - $CurrentLoc[2]
	$Distance = Sqrt($xd * $xd + $yd * $yd + $zd * $zd)
	Return $Distance
EndFunc   ;==>GetDistance

Func CheckGameLength()
	Global $timedifmaxgamelength = TimerDiff($timermaxgamelength)
	If $timedifmaxgamelength > $maxgamelength Then
		_Log('game over time !')
		Global $CheckGameLength = True
	EndIf
EndFunc   ;==>CheckGameLength

Func _Log($text, $write = 0)

	$texte_write = @MDAY & "/" & @MON & "/" & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & " | " & $text

	If $write == 1 Then
		$file = FileOpen(@ScriptDir & "\log\" & $fichierlog, 1 + 8) ;1 write/append + 8 : create path
		If $file = -1 Then
			ConsoleWrite("Log file error, cant be open")
		Else
			FileWrite($file, $texte_write & @CRLF)
		EndIf
		FileClose($file)
	EndIf

	ConsoleWrite(@MDAY & "/" & @MON & "/" & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & " | " & $text & @CRLF)
EndFunc   ;==>_Log

;;--------------------------------------------------------------------------------
;;############# Stats by YoPens
;;--------------------------------------------------------------------------------
; modif pour simplifier avec un string replace.
Func FormatNumber($StringToFormat)
	Return StringRegExpReplace($StringToFormat, '(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))', '\1 ')
EndFunc   ;==>FormatNumber

;;--------------------------------------------------------------------------------
; Function:             FormatTime()
; Description:          Format time by length
;
; Note(s): faster than YoPens : 100% if < 1mn, 150% if < 1h, 30% if more
;;--------------------------------------------------------------------------------
Func FormatTime($MS)
	Switch $MS
		Case 0 To 59999 ; less than 1 mn
			Return Round(($MS / 1000), 2) & " s"
		Case 60000 To 359999 ; 1 mn to 1 hour
			Return Int($MS / 60000) & " mn " & Round(($MS / 1000) - Int(Int($MS / 60000) * 60)) & " s"
		Case Else ; more than 1 hour
			Return Int($MS / 3600000) & "h " & Int((Int($MS / 60000) - Int(Int($MS / 3600000) * 3600) / 60)) & "mn " & Round(($MS / 1000) - Int($MS / 3600000) * 3600 - Int(Int($MS / 60000) - Int(Int($MS / 3600000) * 3600) / 60) * 60) & "s"
	EndSwitch
	Return $MS
EndFunc   ;==>FormatTime


Func RandSleep($min = 5, $max = 45, $chance = 3)
	$randNum = Round(Random(1, 100))
	If $randNum <= $chance Then
		$sleepTime = Random($min * 1000, $max * 1000)
		_Log("Sleeping " & $sleepTime & "ms")
		For $c = 0 To 10
			Sleep($sleepTime / 10)
		Next
	EndIf
EndFunc   ;==>RandSleep

Func RandomMouseClick($x, $y, $button = "left")
	$coord = UiRatio($x, $y)
	MouseClick($button, Random($coord[0] - 3, $coord[0] + 3), Random($coord[1] - 3, $coord[1] + 3))
EndFunc   ;==>RandomMouseClick

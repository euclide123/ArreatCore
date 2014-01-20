#cs ----------------------------------------------------------------------------
	Extension permettant de gerer les temps de pause avec déconnection
#ce ----------------------------------------------------------------------------

Func _pauseRepas($nbRun)

	Local $petitDejeuner = "08:00"
	Local $dejeuner = "12:20"
	Local $gouter = "16:30"
	Local $diner = "19:30"
	Local $collation = "23:00"

	; temps de pause en minute
	;Local $tempsPause=20
	$tempsPause = 20

	;Recuperation de l'heure et minute
	Local $Heure = @HOUR & ':' & @MIN

	;calcul en milliseconde du temps de pause
	$tempsPause = $tempsPause * 60000

	;Initialisation des variables à la mise en route du BOT
	If ($nbRun = 1) Then
		ConsoleWrite('Initialisation au lancement du bot' & @CRLF)
		If $Heure > $petitDejeuner Then
			$petitDejeunerOK = 1
		EndIf
		If $Heure > $dejeuner Then
			$dejeunerOK = 1
		EndIf
		If $Heure > $gouter Then
			$gouterOK = 1
		EndIf
		If $Heure > $diner Then
			$dinerOK = 1
		EndIf
		If $Heure > $collation Then
			$collationOK = 1
		EndIf
	EndIf

	;Initialisation des variable entre 00:00 et 01:00 du matin
	If ($nbRun > 1) And ($heure > "00:00" And $heure < "01:00") Then
		ConsoleWrite('Initialisation entre 00:00 et 01:00' & @CRLF)
		$petitDejeunerOK = 0
		$dejeunerOK = 0
		$gouterOK = 0
		$dinerOK = 0
		$collationOK = 0
	EndIf

	If $Heure > $petitDejeuner And $petitDejeunerOK = 0 Then
		$petitDejeunerOK = 1
		ConsoleWrite('Pause à ' & $Heure & ' --> petit dejeuner' & @CRLF)
		_deconnection()
		Sleep($tempsPause)
		_connection()
	EndIf

	If $Heure > $dejeuner And $dejeunerOK = 0 Then
		ConsoleWrite('Pause à ' & $Heure & ' --> dejeuner' & @CRLF)
		$dejeunerOK = 1
		_deconnection()
		Sleep($tempsPause)
		_connection()
	EndIf

	If $Heure > $gouter And $gouterOK = 0 Then
		ConsoleWrite('Pause à ' & $Heure & ' --> gouter' & @CRLF)
		$gouterOK = 1
		_deconnection()
		Sleep($tempsPause)
		_connection()
	EndIf

	If $Heure > $diner And $dinerOK = 0 Then
		ConsoleWrite('Pause à ' & $Heure & ' --> diner' & @CRLF)
		$dinerOK = 1
		_deconnection()
		Sleep($tempsPause)
		_connection()
	EndIf

	If $Heure > $collation And $collationOK = 0 Then
		ConsoleWrite('Pause à ' & $Heure & ' --> collation' & @CRLF)
		$collationOK = 1
		_deconnection()
		Sleep($tempsPause)
		_connection()
	EndIf

EndFunc   ;==>_pauseRepas

Func _deconnection()
	Send("{ESCAPE}")
	MouseMove(Random(315, 478, 1), Random(348, 362, 1), Random(12, 14, 1))
	MouseClick("left")
EndFunc   ;==>_deconnection

Func _connection()
	If _onloginscreen() Then
		_log("LOGIN")
		_logind3()
		Local $Random = Random(60000, 120000, 1)
		Sleep($Random)
		$PauseRepasCounter += 1;on compte les pause repas effectuer
		$tempsPauserepas += ($tempsPause + $Random);on compte le temps de pause repas
		$Try_Logind3 = 0
	EndIf
EndFunc   ;==>_connection



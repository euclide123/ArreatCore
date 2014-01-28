#include-once
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include "usePath.au3"

Global $sequence_save = 0
Global $autobuff = False
Global $reverse = 0


Func TraitementSequence(ByRef $arr_sequence, $index, $mvtp = 0)
	If $arr_sequence[$index][0] = 2 And $mvtp = 1 Then


		movetopos($arr_sequence[$index][1], $arr_sequence[$index][2], $arr_sequence[$index][3], $arr_sequence[$index][4], $arr_sequence[$index][5])


	Else
		If $arr_sequence[$index][1] = "sleep" Then
			Sleep($arr_sequence[$index][2])
		ElseIf $arr_sequence[$index][1] = "interactbyactorname" Then
			InteractByActorName($arr_sequence[$index][2])
		ElseIf $arr_sequence[$index][1] = "buffinit" Then
			BuffInit()
		ElseIf $arr_sequence[$index][1] = "unbuff" Then
			Unbuff()
		ElseIf $arr_sequence[$index][1] = "send" Then
			Send($arr_sequence[$index][2])


		ElseIf $arr_sequence[$index][1] = "takewp" Then
			TakeWp($arr_sequence[$index][2], $arr_sequence[$index][3], $arr_sequence[$index][4], $arr_sequence[$index][5])
		ElseIf $arr_sequence[$index][1] = "_townportal" Then
			If Not UseTownPortal() Then
				$GameFailed = 1
				Return False
			EndIf
		ElseIf $arr_sequence[$index][1] = "OffsetList" Then
			Local $hTimer = TimerInit()
			While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
					Sleep(40)
			WEnd
		EndIf
	EndIf
EndFunc   ;==>TraitementSequence

Func RevivePlayerDead()
	If ($ResActivated) Then
		If $nb_die_t > $rdn_die_t Then ;Si on a deja depassé le nombre de revive autorisé, on renvoie forcement false, pour donner la main au reste du code
			Return False
		EndIf
		Return FastCheckUiItemVisible($uiPlayerDead, 1, 969)
	EndIf
	Return False
EndFunc   ;==>RevivePlayerDead

Func InitSequence()
	$nb_die_t = 0
	$rdn_die_t = $ResLife + Random(-1, 1, 1)
	_Log("New sequence, max death allowed :" & $rdn_die_t)
EndFunc   ;==>InitSequence

Func Revive(ByRef $path)
	If RevivePlayerDead() Then
		MouseUp("middle")
		$nb_die_t = $nb_die_t + 1
		$Res_compt = $Res_compt + 1
		_Log("You are dead, max :" & $rdn_die_t - $nb_die_t & " more death allowed")
		
		If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_DEATH) ; TChat

		If $nb_die_t <= $rdn_die_t Then
			Sleep(Random(5000, 6000))
			MouseClick("left", 400, 470, 1, 6)
			Sleep(Random(750, 1000))
			BlockSequence($path, 1)
			Return True ;on res
		Else
			_Log("You have reached the max number of revive : " & $rdn_die_t)
		EndIf
	EndIf
	Return False
EndFunc   ;==>Revive

Func ReverseArray(ByRef $arr_MTP)
	_Log("taille de l'array reverse : " & UBound($arr_MTP))
	Dim $arr_reverse[UBound($arr_MTP)][6]
	Local $compt_x = 0
	Local $compt_i = 0


	If $reverse = 1 Then


		Local $reverse_rnd = Random(0, 1, 1)


		If ($reverse_rnd = 1) Then
			_Log("reverse array")
			For $i = UBound($arr_MTP) To 1 Step -1
				For $x = 0 To 5
					$arr_reverse[$compt_i][$compt_x] = $arr_MTP[$i - 1][$x]
					$compt_x += 1
				Next
				$compt_x = 0
				$compt_i += 1
			Next
			$reverse = 0
			Return $arr_reverse
		Else
			$reverse = 0
			Return $arr_MTP
		EndIf


	Else
		$reverse = 0
		Return $arr_MTP
	EndIf
EndFunc   ;==>ReverseArray

Func BlockSequence(ByRef $arr_MTP, $revive = 0)
	If IsItemDamaged() Then

		unbuff()
		TpRepairAndBack()
		buffinit()
	EndIf


	If $revive = 1 Then
		Sleep(Random(2500, 3500))
		buffinit()
	EndIf

	If IsArray($arr_MTP) Then

		If $UsePath Then

			UsePath($arr_MTP)

		Else

			For $i = 0 To UBound($arr_MTP, 1) - 1
				If $arr_MTP[$i][0] <> 0 Then
					TraitementSequence($arr_MTP, $i, 1)
					If Revive($arr_MTP) Then
						Return
					EndIf
				EndIf
			Next

		EndIf


	Else
		_Log("Invalid sequence array argument")
	EndIf
EndFunc   ;==>BlockSequence

Func SendSequence(ByRef $arr_sequence)
	If $sequence_save = 1 Then
		; ON ENVOIT ICI L'ARRAY A LA FONCTION DE DEPLACEMENT

		If $autobuff Then
			Sleep(500)
			buffinit()
			_Log("enclenchement auto du buffinit()")
		EndIf


		$arr_sequence = ReverseArray($arr_sequence)
		;**TEMPORAIRE**
		BlockSequence($arr_sequence)
		;**TEMPORAIRE**


		If $autobuff Then
			Sleep(500)
			unbuff()
			_Log("enclenchement auto du unbuff()")
		EndIf
	EndIf


	$sequence_save = 0
EndFunc   ;==>SendSequence

Func ArrayUp(ByRef $array_sequence)
	If Not $sequence_save = 0 Then
		ReDim $array_sequence[UBound($array_sequence) + 1][6]
	EndIf
	$sequence_save = 1
	Return $array_sequence
EndFunc   ;==>ArrayUp

Func ArrayInit(ByRef $array_sequence)
	Dim $array_sequence[1][6]
	$sequence_save = 0
	Return $array_sequence
EndFunc   ;==>ArrayInit

;<<<<<<<<<<<<<<<<<<<<<<<< Début function ajouter >>>>>>>>>>>>>>>>>>>>>>>>>>>
Func SetHeroAxeZ($String)
	If Not $String = "" Then
		$Hero_Axe_Z = Number($String)
		_Log("Modification de la valeur Z du heros : " & $Hero_Axe_Z)
	EndIf
EndFunc   ;==>SetHeroAxeZ

Func AttackRange($String)
	If Not $String = "" Then
		$a_range = Round($String)
		_Log("Modification de la valeur attackRange : " & $a_range)
	EndIf
EndFunc   ;==>AttackRange

Func SpecialMonsterList($String)
	If Not $String = "" Then
		$SpecialmonsterList = $String
		_Log("Ajout d'une nouvelle SpecialMonsterlist : " & $SpecialmonsterList)
	EndIf
EndFunc   ;==>SpecialMonsterList
;<<<<<<<<<<<<<<<<<<<<<<<< Fin function ajouter >>>>>>>>>>>>>>>>>>>>>>>>>>>
Func MonsterList($String)
	If Not $String = "" Then
		$monsterList = $String
		_Log("Ajout d'une nouvelle MonsterList : " & $monsterList)
	EndIf
EndFunc   ;==>MonsterList

Func BanList($String)
	If Not $String = "" Then
		$BanmonsterList = $BanmonsterList & "|" & $String
		_Log("Ajout d'une nouvelle BanList : " & $BanmonsterList)
	EndIf
EndFunc   ;==>BanList

Func MaxGameLength($String)
	If Not $String = "" Then
		$maxgamelength = $String
		_Log("Ajout d'un nouveau MaxGameLength : " & $maxgamelength)
	EndIf
EndFunc   ;==>MaxGameLength

Func IsComment($String)
	If StringInStr($String, "//", 2) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsComment

Func ParseSequenceFile($txt)
	Dim $txt_arr[1]
	Dim $txt_arr_final[1]
	Local $compt = 0


	If (StringInStr($txt, "|", 2)) Then
		ReDim $txt_arr[UBound(StringSplit($txt, "|", 2))]
		$txt_arr = StringSplit($txt, "|", 2)

		For $i = 0 To UBound($txt_arr) - 1

			If StringRegExp($txt_arr[$i], '\[([0-9]{1,3})/([0-9]{1,3})\]') = 1 Then ;patern random chance
				$arr_traitement_random_inclut = StringRegExp($txt_arr[$i], '\[([0-9]{1,3})/([0-9]{1,3})\]', 2)
				$num = Random(1, $arr_traitement_random_inclut[2], 1)
				If $num <= $arr_traitement_random_inclut[1] Then
					$txt_arr[$i] = StringReplace($txt_arr[$i], $arr_traitement_random_inclut[0], "", 0, 2)
				Else
					$txt_arr[$i] = ""
				EndIf
			EndIf

			If StringRegExp($txt_arr[$i], '\[([0-9]{1,3})-([0-9]{1,3})\]') = 1 Then ;patern random number
				$arr_traitement_num = StringRegExp($txt_arr[$i], '\[([0-9]{1,3})-([0-9]{1,3})\]', 2)
				$num = Random($arr_traitement_num[1], $arr_traitement_num[2], 1)
				$txt_arr[$i] = StringReplace($txt_arr[$i], $arr_traitement_num[0], "", 0, 2) & $num
			EndIf

			If Not $txt_arr[$i] = "" Then
				$compt += 1
				ReDim $txt_arr_final[$compt]
				$txt_arr_final[$compt - 1] = $txt_arr[$i]
			EndIf

		Next

	Else
		$txt_arr_final[0] = $txt
	EndIf

	Return $txt_arr_final
EndFunc   ;==>ParseSequenceFile


Func Sequence()

	Dim $filetoarray[1]
	Local $load_file = ""

	;	if( StringInStr($File_Sequence, "|", 2) ) Then
	;		ReDim $filetoarray[UBound( StringSplit($File_Sequence, "|", 2) )]
	;		$filetoarray = StringSplit($File_Sequence, "|", 2)
	;	Else
	;		$filetoarray[1] = $File_Sequence
	;	EndIf

	$filetoarray = ParseSequenceFile($File_Sequence)

	For $z = 0 To UBound($filetoarray) - 1

		Local $noblocline = 0
		Local $old_ResActivated = $ResActivated
		Local $old_UsePath = $UsePath
		Local $old_TakeCheckTakeShrines = $takeShrines

		Local $compt_line = 0
		Dim $txttoarray[1]

		If StringInStr($filetoarray[$z], "[CMD]", 2) = 1 Then ;Detection d'une commande
			$txttoarray[0] = Trim(StringLower(StringReplace($filetoarray[$z], "[CMD]", "", 0, 2)))
		Else

			$load_file = "sequence\" & $filetoarray[$z] & ".txt"
			_Log("fichier load : " & $load_file)

			Local $file = FileOpen($load_file, 0)
			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open file : " & $load_file)
				Exit
			EndIf


			While 1 ;Boucle de traitement de lecture du fichier txt
				$line = FileReadLine($file)
				If @error = -1 Then ExitLoop

				If $line <> "" Then
					$line = Trim(StringLower($line))
					ReDim $txttoarray[$compt_line + 1]
					$txttoarray[$compt_line] = $line
					$compt_line += 1
				EndIf
			WEnd

			FileClose($file)

		EndIf

		Dim $array_sequence[1][6]





		For $i = 0 To UBound($txttoarray) - 1


			If $GameFailed = 1 Then
				ExitLoop

			EndIf


			$error = 0
			$definition = 0
			$block = 0

			$line = $txttoarray[$i]

			If Not IsComment($line) And Not $line = "" Then



				;***************************************CMD BLOQUANTE*****************************************
				If StringInStr($line, "takewp=", 2) Then; TakeWP detected

					If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_TAKE_WP) ; TChat
					 
					$line = StringReplace($line, "takewp=", "", 0, 2)
					$table_wp = StringSplit($line, ",", 2)


					If UBound($table_wp) = 4 Then
						If $noblocline = 0 Then ;Pas de Detection precedente de nobloc() on met donc dans l'array la cmd suivante
							SendSequence($array_sequence)
							$array_sequence = ArrayInit($array_sequence)
							_Log("Enclenchement d'un TakeWP(" & $table_wp[0] & ", " & $table_wp[1] & ", " & $table_wp[2] & ", " & $table_wp[3] & ") line : " & $i + 1)
							TakeWP($table_wp[0], $table_wp[1], $table_wp[2], $table_wp[3])
							$line = ""
						Else
							_Log("Mise en array d'un TakeWP(" & $table_wp[0] & ", " & $table_wp[1] & ", " & $table_wp[2] & ", " & $table_wp[3] & ") line : " & $i + 1)
							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][1] = "takewp"
							$array_sequence[UBound($array_sequence) - 1][2] = $table_wp[0]
							$array_sequence[UBound($array_sequence) - 1][3] = $table_wp[1]
							$array_sequence[UBound($array_sequence) - 1][4] = $table_wp[2]
							$array_sequence[UBound($array_sequence) - 1][5] = $table_wp[3]
							$noblocline = 0
							$line = ""
						EndIf

					Else
						$error = 1
						_Log("Wp invalid argument or number, Line : " & $i + 1, 1)
					EndIf

				ElseIf StringInStr($line, "_townportal()", 2) Then; _townportal() detected
					If $noblocline = 0 Then ;Pas de Detection precedente de nobloc() on met donc dans l'array la cmd suivante
						SendSequence($array_sequence)
						$array_sequence = ArrayInit($array_sequence)
						_Log("Enclenchement d'un _townportal() line : " & $i + 1)
						If Not UseTownPortal() Then
							$GameFailed = 1
							Return False
						EndIf

						$line = ""
					Else
						_Log("mise en array d'un _townportal() line : " & $i + 1)
						$array_sequence = ArrayUp($array_sequence)
						$array_sequence[UBound($array_sequence) - 1][0] = 1
						$array_sequence[UBound($array_sequence) - 1][1] = "_townportal"
						$noblocline = 0
						$line = ""
					EndIf






				ElseIf StringInStr($line, "endsave()", 2) Then; endsave() detected
					SendSequence($array_sequence)
					$array_sequence = ArrayInit($array_sequence)
					$line = ""
					_Log("Enclenchement d'un endsave() line : " & $i + 1)
				EndIf
				;*********************************************************************************************


				;******************************CMD DE DEFINITION**********************************************
				If StringInStr($line, "monsterlist=", 2) Then; MonsterList detected
					$line = StringReplace($line, "monsterlist=", "", 0, 2)
					_Log("Enclenchement d'un monsterlist line : " & $i + 1)
					MonsterList($line)
					$line = ""
					$definition = 1
					;<<<<<<<<<<<<<<<<<<<<<<<< Début CMD DE DEFINITION ajouter >>>>>>>>>>>>>>>>>>>>>>>>>>>
				ElseIf StringInStr($line, "specialml=", 2) Then; SpecialMonsterList detected
					$line = StringReplace($line, "specialml=", "", 0, 2)
					_Log("Enclenchement d'un SpecialMonsterList line : " & $i + 1)
					SpecialMonsterList($line)
					$line = ""
					$definition = 1
				ElseIf StringInStr($line, "setherosaxez=", 2) Then; Définition l'axe Z détecté
					$line = StringReplace($line, "setherosaxez=", "", 0, 2)
					_Log("Detection de la modification de l'axe Z du heros" & $i + 1)
					SetHeroAxeZ($line)
					$line = ""
					$definition = 1
				ElseIf StringInStr($line, "attackrange=", 2) Then; Définition l'attackRange
					$line = StringReplace($line, "attackrange=", "", 0, 2)
					_Log("Detection de la modification de attackRange line : " & $i + 1)
					AttackRange($line)
					$line = ""
					$definition = 1
					;<<<<<<<<<<<<<<<<<<<<<<<< FIN CMD DE DEFINITION ajouter >>>>>>>>>>>>>>>>>>>>>>>>>>>
				ElseIf StringInStr($line, "banlist=", 2) Then; BanList detected
					$line = StringReplace($line, "banlist=", "", 0, 2)
					_Log("Enclenchement d'un Banlist() line : " & $i + 1)
					BanList($line)
					$line = ""
					$definition = 1
				ElseIf StringInStr($line, "maxgamelength=", 2) Then
					$line = StringReplace($line, "maxgamelength=", "", 0, 2)
					MaxGameLength($line)
					_Log("Enclenchemen d'un MaxGameLengt() Line : " & $i + 1)
					$line = ""
					$definition = 1
				ElseIf StringInStr($line, "autobuff=", 2) Then
					$line = StringReplace($line, "autobuff=", "", 0, 2)
					If $line = "true" Then
						$autobuff = True
						_Log("autobuff definit sur true line : " & $i + 1)
					Else
						$autobuff = False
						_Log("autobuff definit sur false line : " & $i + 1)
					EndIf
					$line = ""
					$definition = 1
				ElseIf StringInStr($line, "reverse=", 2) Then
					$line = StringReplace($line, "reverse=", "", 0, 2)
					If $line = "true" Then
						$reverse = 1
						_Log("Reverse mod line : " & $i + 1)
					EndIf
					$line = ""
					$definition = 1
				ElseIf StringInStr($line, "revive=", 2) Then
					$line = StringReplace($line, "revive=", "", 0, 2)
					If $old_ResActivated Then
						If $line = "true" Then
							$ResActivated = True
							_Log("Turn revive mod to On line : " & $i + 1)
						Else
							$ResActivated = False
							_Log("Turn revive mod to Off line")
						EndIf
						$line = ""
						$definition = 1
					EndIf
				ElseIf StringInStr($line, "usepath=", 2) Then
					$line = StringReplace($line, "usepath=", "", 0, 2)
					If $old_UsePath Then
						If $line = "true" Then
							$UsePath = True
							_Log("Turn UsePath mod to On line : " & $i + 1)
						Else
							$UsePath = False
							_Log("Turn UsePath mod to Off line")
						EndIf
						$line = ""
						$definition = 1
					EndIf
				ElseIf StringInStr($line, "takeCheckTakeShrines=", 2) Then

					$line = StringReplace($line, "takeCheckTakeShrines=", "", 0, 2)
					If $old_TakeCheckTakeShrines Then
						If $line = "true" Then
							$takeShrines = True
							_Log("Turn TakeCheckTakeShrines mod to On line : " & $i + 1)
						Else
							$takeShrines = False
							_Log("Turn TakeCheckTakeShrines mod to Off line")
						EndIf
						$line = ""
						$definition = 1
					EndIf
				EndIf
				;*********************************************************************************************

				If Not $error = 1 Or $definition = 1 Or $line = "" Then
					If StringInStr($line, "sleep=", 2) Then ;sleep detected
						$line = StringReplace($line, "sleep=", "", 0, 2)
						If $sequence_save = 0 Then
							Sleep($line)
							_Log("Enclenchement d'un sleep direct line : " & $i + 1)
						Else
							_Log("mise en array d'un sleep line : " & $i + 1)
							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][1] = "sleep"
							$array_sequence[UBound($array_sequence) - 1][2] = $line
						EndIf
					ElseIf StringInStr($line, "OffsetList()", 2) Then; _townportal() detected
						If $sequence_save = 0 Then
							While Not OffsetList()
								Sleep(40)
							WEnd

							_Log("Enclecnhement d'un OffsetList line : " & $i + 1)
						Else
							_Log("mise en array d'un OffsetList line : " & $i + 1)
							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][2] = $line
							$array_sequence[UBound($array_sequence) - 1][1] = "OffsetList"

						EndIf

					ElseIf StringInStr($line, "safeportback()", 2) Then; safeportback() detected
						SafePortBack()
					ElseIf StringInStr($line, "safeportstart()", 2) Then; safeportback() detected
						SafePortStart()
					ElseIf StringInStr($line, "nobloc()", 2) Then ;InteractByActorName detected

						$noblocline = 1

					ElseIf StringInStr($line, "interactbyactorname=", 2) Then ;InteractByActorName detected
						$line = StringReplace($line, "interactbyactorname=", "", 0, 2)

						If $sequence_save = 0 Then
							InteractByActorName($line)

							_Log("Enclenchement d'un interact direct line : " & $i + 1)
						Else
							_Log("mise en array d'un interact() line : " & $i + 1)
							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][1] = "interactbyactorname"
							$array_sequence[UBound($array_sequence) - 1][2] = $line
						EndIf



					ElseIf StringInStr($line, "buffinit()", 2) Then ;buffinit detected


						If $sequence_save = 0 Then
							buffinit()

							_Log("Enclenchement d'un buffinit() line : " & $i + 1)
						Else
							_Log("mise en array dun buffinit() line : " & $i + 1)
							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][1] = "buffinit"
						EndIf

					ElseIf StringInStr($line, "unbuff()", 2) Then ;unbuff detected

						If $sequence_save = 0 Then
							unbuff()
							_Log("Enclenchement d'un unbuf() line : " & $i + 1)
						Else
							_Log("mise en array d'un unbuf() line : " & $i + 1)








							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][1] = "unbuff"
						EndIf

					ElseIf StringInStr($line, "send=", 2) Then ;send detected
						$line = StringReplace($line, "send=", "", 0, 2)
						If $sequence_save = 0 Then
							Send($line)
							_Log("Enclenchement d'un send direct line : " & $i + 1)




						Else
							_Log("mise en array d'un send() line : " & $i + 1)
							$array_sequence = ArrayUp($array_sequence)
							$array_sequence[UBound($array_sequence) - 1][0] = 1
							$array_sequence[UBound($array_sequence) - 1][1] = "send"
							$array_sequence[UBound($array_sequence) - 1][2] = $line
						EndIf

					Else ;no specific command detected, so we guess movetopos

						If Not $line = "" Then ;Si ligne PAS vide
							$table_mtp = StringSplit($line, ",", 2)
							If UBound($table_mtp, 1) = 5 Then
								$array_sequence = ArrayUp($array_sequence)
								$array_sequence[UBound($array_sequence) - 1][0] = 2
								$array_sequence[UBound($array_sequence) - 1][1] = $table_mtp[0]
								$array_sequence[UBound($array_sequence) - 1][2] = $table_mtp[1]
								$array_sequence[UBound($array_sequence) - 1][3] = $table_mtp[2]
								$array_sequence[UBound($array_sequence) - 1][4] = $table_mtp[3]
								$array_sequence[UBound($array_sequence) - 1][5] = $table_mtp[4]
							Else
								_Log("Unknow or invalide cmd on line : " & $i + 1 & " -> " & $line)
							EndIf

						EndIf


					EndIf

				EndIf
			EndIf

			If UBound($txttoarray) = $i + 1 Then
				SendSequence($array_sequence)
			EndIf

		Next

		$reverse = 0
		$sequence_save = 0
		$autobuff = False
		$ResActivated = $old_ResActivated
		$UsePath = $old_UsePath
		$takeShrines = $old_TakeCheckTakeShrines
		unbuff()






	Next








EndFunc   ;==>Sequence


Func SafePortStart()
	$Curentarea = GetLevelAreaId()
	;fix offset list
	While $Curentarea = -1
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - SafePortStart')
			Return False
		EndIf

		$Curentarea = GetLevelAreaId()

	WEnd
	_Log('cur area :' & $Curentarea)

	$tptry = 0
	$tpcheck = 0

	While $tpcheck = 0 And $tptry <= 1
		_Log("try n°" & $tptry + 1 & " hearthPortal")
		InteractByActorName('hearthPortal')
		$Newarea = GetLevelAreaId()

		Local $areatry = 0

		While $Newarea = $Curentarea And $areatry <= 10
			$Newarea = GetLevelAreaId()
			Sleep(500)
			$areatry = $areatry + 1
		WEnd

		If $Newarea <> $Curentarea Then
			$tpcheck = 1
		Else
			$tptry += 1
		EndIf

	WEnd

	If $Newarea <> $Curentarea Then
		_Log('succesfully teleported back : ' & $Curentarea & ":" & $Newarea)
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - SafePortStart')
		EndIf

	Else
		$GameFailed = 1
	EndIf

EndFunc   ;==>SafePortStart

Func SafePortBack()
	$Curentarea = GetLevelAreaId()
	_Log('cur area :' & $Curentarea)
	;Go to center according to act
	Switch $Act
		Case 1 ; act 1
			MoveToPos(2922.02783203125, 2791.189453125, 24.0453262329102, 0, 25)
			MoveToPos(2945.61547851563, 2800.7109375, 24.0453319549561, 0, 25)
			MoveToPos(2973.68774414063, 2800.90869140625, 24.0453262329102, 0, 25)

		Case 2 ; act 2
			;mtp a definir


		Case 3 ; act 3
			MoveToPos(427.152893066406, 345.048858642578, 0.10000141710043, 0, 25)
			MoveToPos(400.490386962891, 380.362884521484, 0.332595944404602, 0, 25)
			MoveToPos(390.630401611328, 399.380554199219, 0.55376011133194, 0, 25)

		Case 4 ; act 4
			MoveToPos(427.152893066406, 345.048858642578, 0.10000141710043, 0, 25)
			MoveToPos(400.490386962891, 380.362884521484, 0.332595944404602, 0, 25)
			MoveToPos(390.630401611328, 399.380554199219, 0.55376011133194, 0, 25)

	EndSwitch

	InteractByActorName('hearthPortal')
	$Newarea = GetLevelAreaId()

	Local $areatry = 0
	While $Newarea = $Curentarea And $areatry <= 10
		$Newarea = GetLevelAreaId()
		Sleep(500)
		$areatry = $areatry + 1
	WEnd

	If $Newarea <> $Curentarea Then
		_Log('succesfully teleported back : ' & $Curentarea & ":" & $Newarea)
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - SafePortBack')
		EndIf

	Else
		_Log('We failed to teleport back')
	EndIf
EndFunc   ;==>SafePortBack


;***************** CMD ************
;
;
; Toute ligne contenant // est desactivé, les lignes vierge sont detecté parfois comme étant des lignes erronée et donc reporté dans les logs !
;
;
; CMD BLOQUANTE                 (les cmd dite bloquante, force l'envoie de l'array, elles definissent donc un point de sauvegarde pour le code si revive on)
; -> _townportal()              (force un tp en ville, commande bloquante, si pas précédé de nobloc(), cette commande force l'envoie de l'array)
; -> takewp=a,b,c,d             (prend un teleporteur, commande bloquante, si pas précédé de nobloc(), cette commande force l'envoie de l'array)
; -> endsave()                  (force l'envoie de l'array, et donc definit un point de sauvegarde si revive on)

; CMD DEFINITION
; -> monsterlist=               (definition des monstres à tuer)
; -> banlist=                   (banlist)
; -> autobuff=true/false        (active ou desactive la gestion des buffs automatiquement lors du passage d'un array)
; -> revive=true/false          (active ou desactive la fonction revive, si ResActivated est definit sur false dans le setting.ini, la command n'a aucun effet)
; -> usepath=true/false         (active ou desactive la fonction usepath, si UsePath est definit sur false dans le setting.ini, la command n'a aucun effet)
;
; CMD PASSIVE
; -> sleep=                     (definition d'un sleep)
; -> OffsetList()               (rafraichissement de la memoire)
; -> nobloc()                   (Rend la prochaine commande bloquante passive, cette fonction n'est a appelé uniquement au dessus d'un takewp ou d'un _townportal())
; -> interactbyactorname=       (Interagie avec un npc)
; -> buffinit()                 (Force l'initialisation des buffs)
; -> unbuff()                   (force l'unbuff)
; -> send=                      (Envoie une Key)
; -> x, y, z, w, y              (movetopos, composé de 5 argument)

;
; L'array renvoyé par la fonction SendSequence() (array[X][6])
;
;
; array[x][0] -> 1 ou 2 (Si 1, l'enregistrement suivant contient une commande, si 2, les autres "case" contiennent )
; array[x][1] -> Si commande, contient le nom de la commande, les cases suivante contiennent la/les valeurs associé

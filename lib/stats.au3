#include-once
 ; ------------------------------------------------------------
; Ce fichier contient toutes les fonctions liées auxs stats
; -------------------------------------------------------------


Func WriteStatsInHtml()
	If $Totalruns >= 15 Then

		$sessionstats = "data.addRow([new Date(" & @YEAR & "," & @MON & "," & @MDAY & "," & @HOUR & "," & @MIN & ")," & ($dif_timer_stat / ($Totalruns) / 1000) & "," & $GOLDMOYbyH / 1000 & "," & ($Xp_Moy_Hrs / 100000) & "," & (($Death * 3 + $Res_compt) / $Totalruns) * 100 & "," & $successratio * 1000 & "]);"
		$szFile = "statscontrol.html"
		$szText = FileRead($szFile)
		$szText = StringReplace($szText, "//GoGoAu3End", $sessionstats & @CRLF & "//GoGoAu3End")
		FileDelete($szFile)
		FileWrite($szFile, $szText)
	EndIf
EndFunc   ;==>WriteStatsInHtml

Func StatsDisplay()

	Local $index, $offset, $count, $item[4]
	Local $time_Xp_Full_Paragon = 0;ajouté pour la stat paragon 100 dans
	Local $Xp_Moy_HrsPerte_Ratio = 0
	Local $LossGoldMoyH = 0
	Local $GoldBySaleRatio = 0
	Local $GoldByColectRatio = 0
	Local $GoldByRepaireRatio = 0
	Local $dif_timer_stat_game_Ratio = 0
	Local $dif_timer_stat_pause_Ratio = 0

	StartIterateLocalActor($index, $offset, $count)
	While IterateLocalActorList($index, $offset, $count, $item)
		If StringInStr($item[1], "GoldCoin-") Then
			$GOLD = IterateActorAttributes($item[0], $Atrib_ItemStackQuantityLo)
			ExitLoop
		EndIf
	WEnd

	If $Totalruns = 1 Then
		$GOLDINI = $GOLD
		$begin_timer_stat = TimerInit()
		$GF = Ceiling(GetAttribute($_MyGuid, $Atrib_Gold_Find) * 100)
		$MF = Ceiling(GetAttribute($_MyGuid, $Atrib_Magic_Find) * 100)
		$PR = GetAttribute($_MyGuid, $Atrib_Gold_PickUp_Radius)
		$MS = (GetAttribute($_MyGuid, $Atrib_Movement_Scalar_Capped_Total) - 1) * 100
		$EBP = Ceiling(GetAttribute($_MyGuid, $Atrib_Experience_Bonus_Percent) * 100);% xp équipement
		$LV = GetAttribute($_MyGuid, $Atrib_Level);level personnage
	Else
        $GOLDInthepocket = $GOLD - $GOLDINI
        $GOLDMOY = $GOLDInthepocket / ($Totalruns - 1)
        $GoldBySaleRatio = ($GoldBySale / $GOLDInthepocket * 100);ratio des ventes
        $GoldByColectRatio = (($GOLDInthepocket - $GoldBySale - $GoldByRepaire) / $GOLDInthepocket * 100);ratio de l'or collecté
        $GoldByRepaireRatio = ($GoldByRepaire / $GOLDInthepocket * 100);ratio du coût des réparation
        $dif_timer_stat = TimerDiff($begin_timer_stat);temps total
        $dif_timer_stat_pause = ($tempsPauseGame + $tempsPauserepas);calcule du temps de pause (game + repas)=total pause
        $dif_timer_stat_game = ($dif_timer_stat - $dif_timer_stat_pause);calcule (temps totale - temps total pause)=Temps de jeu
        $dif_timer_stat_game_Ratio = ($dif_timer_stat_game / $dif_timer_stat * 100);ratio temps total jeu
        $dif_timer_stat_pause_Ratio = ($dif_timer_stat_pause / $dif_timer_stat * 100);ration temps de pause total
        $GOLDMOYbyH = $GOLDInthepocket * 3600000 / $dif_timer_stat;calcule du gold à l'heure temps total
        $GOLDMOYbyHgame = $GOLDInthepocket * 3600000 / $dif_timer_stat_game;calcule du gold à l'heure temp de jeu
        $LossGoldMoyH = (($GOLDMOYbyHgame - $GOLDMOYbyH) / $GOLDMOYbyHgame * 100);ratio de la perte d'or due à la pause
	EndIf

	;stat XP

	;Xp nécessaire pour passer un niveau de paragon

	If $Totalruns = 1 Then
		Global $level[102]
		$level[1] = 7200000
		$level[2] = 8640000
		$level[3] = 10080000
		$level[4] = 11520000
		$level[5] = 12960000
		$level[6] = 14400000
		$level[7] = 15840000
		$level[8] = 17280000
		$level[9] = 18720000
		$level[10] = 20160000
		$level[11] = 21600000
		$level[12] = 23040000
		$level[13] = 24480000
		$level[14] = 25920000
		$level[15] = 27360000
		$level[16] = 28800000
		$level[17] = 30240000
		$level[18] = 31680000
		$level[19] = 33120000
		$level[20] = 34560000
		$level[21] = 36000000
		$level[22] = 37440000
		$level[23] = 38880000
		$level[24] = 40320000
		$level[25] = 41760000
		$level[26] = 43200000
		$level[27] = 44640000
		$level[28] = 46080000
		$level[29] = 47520000
		$level[30] = 48960000
		$level[31] = 50400000
		$level[32] = 51840000
		$level[33] = 53280000
		$level[34] = 54720000
		$level[35] = 56160000
		$level[36] = 57600000
		$level[37] = 59040000
		$level[38] = 60480000
		$level[39] = 61920000
		$level[40] = 63360000
		$level[41] = 64800000
		$level[42] = 66240000
		$level[43] = 67680000
		$level[44] = 69120000
		$level[45] = 70560000
		$level[46] = 72000000
		$level[47] = 73440000
		$level[48] = 74880000
		$level[49] = 76320000
		$level[50] = 77760000
		$level[51] = 79200000
		$level[52] = 80640000
		$level[53] = 82080000
		$level[54] = 83520000
		$level[55] = 84960000
		$level[56] = 86400000
		$level[57] = 87840000
		$level[58] = 89280000
		$level[59] = 90720000
		$level[60] = 92160000
		$level[61] = 95040000
		$level[62] = 97920000
		$level[63] = 100800000
		$level[64] = 103680000
		$level[65] = 106560000
		$level[66] = 109440000
		$level[67] = 112320000
		$level[68] = 115200000
		$level[69] = 118080000
		$level[70] = 120960000
		$level[71] = 126000000
		$level[72] = 131040000
		$level[73] = 136080000
		$level[74] = 141120000
		$level[75] = 146160000
		$level[76] = 151200000
		$level[77] = 156240000
		$level[78] = 161280000
		$level[79] = 166320000
		$level[80] = 171360000
		$level[81] = 177840000
		$level[82] = 184320000
		$level[83] = 190800000
		$level[84] = 197280000
		$level[85] = 203760000
		$level[86] = 210240000
		$level[87] = 216720000
		$level[88] = 223200000
		$level[89] = 229680000
		$level[90] = 236160000
		$level[91] = 244800000
		$level[92] = 253440000
		$level[93] = 262080000
		$level[94] = 270720000
		$level[95] = 279360000
		$level[96] = 288000000
		$level[97] = 296640000
		$level[98] = 305280000
		$level[99] = 313920000
		$level[100] = 322560000
		$level[101] = 0

		$NiveauParagon = GetAttribute($_MyGuid, $Atrib_Alt_Level)
		$ExperienceNextLevel = GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)
		$Expencours = $level[$NiveauParagon + 1] - $ExperienceNextLevel
		$Xp_Run = 0
		$Xp_Total = 0
		$Xp_Moy_Run = 0
		$Xp_Moy_Hrs = 0
		$time_Xp = 0
		$time_Xp = FormatTime($time_Xp)

	Else
		;calcul de l'xp du run
		If $NiveauParagon = GetAttribute($_MyGuid, $Atrib_Alt_Level) Then; vérification de level up (égalité => pas de level up

			$Xp_Run = ($level[GetAttribute($_MyGuid, $Atrib_Alt_Level) + 1] - GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)) - $Expencours;expérience run n - expérience run n-1

		EndIf

		$Expencours = $level[GetAttribute($_MyGuid, $Atrib_Alt_Level) + 1] - GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)

		If $NiveauParagon <> GetAttribute($_MyGuid, $Atrib_Alt_Level) Then

			$Xp_Run = $ExperienceNextLevel + $Expencours

		EndIf


		$Xp_Total = $Xp_Total + $Xp_Run
		$Xp_Moy_Run = $Xp_Total / ($Totalruns - 1)
		$Xp_Moy_Hrs = $Xp_Total * 3600000 / $dif_timer_stat;on calcule l'xp/heure en temps total
		$Xp_Moy_Hrsgame = $Xp_Total * 3600000 / $dif_timer_stat_game;on calcule l'xp/heure en temps de jeu
		$Xp_Moy_HrsPerte = ($Xp_Moy_Hrsgame - $Xp_Moy_Hrs);on calcule la perte due aux pauses
		$Xp_Moy_HrsPerte_Ratio = ($Xp_Moy_HrsPerte / $Xp_Moy_Hrsgame * 100);ratio de la perte xp/heure due aux pauses
		$NiveauParagon = GetAttribute($_MyGuid, $Atrib_Alt_Level)
		$ExperienceNextLevel = GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)

		;calcul temps avant prochain niveau
		$Xp_Moy_Sec = $Xp_Total * 1000 / $dif_timer_stat
		$time_Xp = Int($ExperienceNextLevel / $Xp_Moy_Sec) * 1000
		$time_Xp = FormatTime($time_Xp)

		If $NiveauParagon = 100 Then;ici on devra changer la valeur à 1000 pour Ros
			$Xp_Moy_HrsPerte_Ratio = 0
		Endif

		;<<<<<<<<<<<<<<<<<<<<<<<<< début ajouté pour paragon 100 dans  >>>>>>>>>>>>>>>>>>>>>>>>>>>>
		;; calcul de l'expérience totale puis temps nécessaire pour atteindre le paragon 100
		;; et 99 exclu c'est le dernier level
		If $NiveauParagon < 99 Then
			;; xp restant à faire pour le level paragon en cours
			$ExperienceFullParagon = $ExperienceNextLevel
			;; on ajoute les n+1 levels paragons restants
			$current_paragon_level = $NiveauParagon + 1
			While $current_paragon_level <> 101
				$ExperienceFullParagon += $level[$current_paragon_level]
				$current_paragon_level += 1
			WEnd
			; calcul temps avant paragon 100
			$time_Xp_Full_Paragon = Int($ExperienceFullParagon / $Xp_Moy_Sec) * 1000
			$time_Xp_Full_Paragon = FormatTime($time_Xp_Full_Paragon)
		Else
			;; cas du dernier level 99 ou alors paragon 100 deja atteint
			If $NiveauParagon = 99 Then
				;; on utilise le calcul existant
				$time_Xp_Full_Paragon = $time_Xp
			Else
				$time_Xp_Full_Paragon = "ALREADY 100 !!!"
			EndIf
		EndIf
		;<<<<<<<<<<<<<<<<<<<<<<<<< fin ajouté pour paragon 100 dans  >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	EndIf
	;########

	$timer_stat_total = FormatTime($dif_timer_stat);temps Total

	If $Totalruns = 1 Then
		$timer_stat_run_moyen = 0
		;Lv_stat=lv
		;Xp_next_stat=Xp_next
		;Xprun=0
		;Xptotal=0
		;Xpmoyen=0
	Else
		;;;$dif_timer_stat_moyen = $dif_timer_stat / ($Totalruns - 1)
		$dif_timer_stat_moyen = $dif_timer_stat_game / ($Totalruns - 1);on recalcule le temps moyen d'un run par rapport au temps de jeu
		$timer_stat_run_moyen = FormatTime($dif_timer_stat_moyen)
	EndIf

	GetAct()
	GetMonsterPow()
	$DebugMessage = "                                 INFOS RUN ACTE " & $Act & @CRLF
	$DebugMessage = $DebugMessage & "PM " & $MP & @CRLF
	$DebugMessage = $DebugMessage & "Runs : " & $Totalruns & @CRLF
	$DebugMessage = $DebugMessage & "Morts : " & $Death & @CRLF
	$DebugMessage = $DebugMessage & "Résurrections : " & $Res_compt & @CRLF
	$DebugMessage = $DebugMessage & "Déconnexions  : " & $disconnectcount & @CRLF
	$DebugMessage = $DebugMessage & "Sanctuaires Pris : " & $CheckTakeShrineTaken & @CRLF
	$DebugMessage = $DebugMessage & "Elites Rencontrés : " & $CptElite & @CRLF
	$DebugMessage = $DebugMessage & "Success Runs : " & Round($successratio * 100) & "%   ( " & ($Totalruns - $success) & " Avortés )" & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                 INFOS COFFRE" & @CRLF
	$DebugMessage = $DebugMessage & "Nombre Objets Recyclés : " & $ItemToRecycle & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Legs au Coffre : " & $nbLegs & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Rares ID au Coffre : " & $nbRares & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Rares Unid au Coffre : " & $nbRaresUnid & @CRLF
	$DebugMessage = $DebugMessage & "Objets Stockés Dans le Coffre : " & $ItemToStash & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                 INFOS GOLD" & @CRLF
	$DebugMessage = $DebugMessage & "Gold au Coffre : " & FormatNumber(Ceiling($GOLD)) & @CRLF
	$DebugMessage = $DebugMessage & "Gold Total Obtenu  : " & FormatNumber(Ceiling($GOLDInthepocket)) & @CRLF
	$DebugMessage = $DebugMessage & "Gold Moyen/Run : " & FormatNumber(Ceiling($GOLDMOY)) & @CRLF
	$DebugMessage = $DebugMessage & "Gold Moyen/Heure : " & FormatNumber(Ceiling($GOLDMOYbyH)) & @CRLF
	;$DebugMessage = $DebugMessage & "Gold Moyen/Heure Jeu : " & formatNumber(Ceiling($GOLDMOYbyHgame)) & @CRLF ;====> gold de temps de jeu
	$DebugMessage = $DebugMessage & "Perte Moyenne/Heure : " & FormatNumber(Ceiling($GOLDMOYbyH - $GOLDMOYbyHgame)) & "   (" & Round($LossGoldMoyH) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Nombre d'Objets Vendus :  " & $ItemToSell & "  /  " & FormatNumber(Ceiling($GoldBySale)) & "   (" & Round($GoldBySaleRatio) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Gold Obtenu par Collecte  :    " & FormatNumber(Ceiling($GOLDInthepocket - $GoldBySale - $GoldByRepaire)) & "   (" & Round($GoldByColectRatio) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Réparations : " & $RepairORsell & " / " & FormatNumber(Ceiling($GoldByRepaire)) & "   (" & Round($GoldByRepaireRatio) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                 INFOS TEMPS " & @CRLF
	;$DebugMessage = $DebugMessage & "Débuté à  :  " & @HOUR & ":" & @MIN & @CRLF
	$DebugMessage = $DebugMessage & "Durée Moyenne/Run : " & $timer_stat_run_moyen & @CRLF
	$DebugMessage = $DebugMessage & "Temps Total De Bot:   " & $timer_stat_total & @CRLF
	$DebugMessage = $DebugMessage & "Temps Total En Jeu :   " & FormatTime($dif_timer_stat_game) & " (" & Round($dif_timer_stat_game_Ratio) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Pauses Effectuées : " & ($BreakTimeCounter + $PauseRepasCounter) & "  /  " & FormatTime($dif_timer_stat_pause) & " (" & Round($dif_timer_stat_pause_Ratio) & "%)" & @CRLF
	;stats XP
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                 INFOS XP" & @CRLF

	If $NiveauParagon < 100 Then
		$DebugMessage = $DebugMessage & "Bonus d'XP : " & $EBP & " %" & @CRLF

		If ($Xp_Total < 1000000) Then ;affiché en "K"
			$DebugMessage = $DebugMessage & "XP Obtenue : " & Int($Xp_Total / 1000) & " K" & @CRLF
		EndIf
		If ($Xp_Total > 999999) Then ;affiché en "M"
			$DebugMessage = $DebugMessage & "XP Obtenue : " & Int($Xp_Total / 1000) / 1000 & " M" & @CRLF
		EndIf

		If ($Xp_Moy_Run < 1000000) Then ;affiché en "K"
			$DebugMessage = $DebugMessage & "XP Moyenne/Run : " & Int($Xp_Moy_Run / 1000) & " K" & @CRLF
		EndIf
		If ($Xp_Moy_Run > 999999) Then ;affiché en "M"
			$DebugMessage = $DebugMessage & "XP Moyenne/Run : " & Int($Xp_Moy_Run / 1000) / 1000 & " M" & @CRLF
		EndIf

		If ($Xp_Moy_Hrs < 1000000) Then ;affiché en "K"
			$DebugMessage = $DebugMessage & "XP Moyenne/Heure : " & Int($Xp_Moy_Hrs / 1000) & " K" & @CRLF
		EndIf
		If ($Xp_Moy_Hrs > 999999) Then ;affiché en "M"
			$DebugMessage = $DebugMessage & "XP Moyenne/Heure : " & Int($Xp_Moy_Hrs / 1000) / 1000 & " M" & @CRLF
		EndIf

		If ($Xp_Moy_HrsPerte < 1000000) Then ;affiché en "K"
			$DebugMessage = $DebugMessage & "Perte Moyenne/Heure : -" & Int($Xp_Moy_HrsPerte / 1000) & " K (" & Round($Xp_Moy_HrsPerte_Ratio) & "%)" & @CRLF
		EndIf
		If ($Xp_Moy_HrsPerte > 999999) Then ;affiché en "M"
			$DebugMessage = $DebugMessage & "Perte Moyenne/Heure : -" & Int($Xp_Moy_HrsPerte / 1000) / 1000 & " M (" & Round($Xp_Moy_HrsPerte_Ratio) & "%)" & @CRLF
		EndIf

		$DebugMessage = $DebugMessage & "Temps Avant Prochain LVL : " & $time_Xp & @CRLF
		$DebugMessage = $DebugMessage & "Temps Avant Parangon 100 : " & $time_Xp_Full_Paragon & @CRLF
	Else
		$DebugMessage = $DebugMessage & "Paragon 100 atteint"  & @CRLF
	EndIf

	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF

	;#########


	$DebugMessage = $DebugMessage & "                                 INFOS PERSO " & @CRLF
	$DebugMessage = $DebugMessage & $nameCharacter & "  " & $LV & " [ " & $NiveauParagon & " ] " & @CRLF
	$DebugMessage = $DebugMessage & "PickUp Radius  : " & $PR & @CRLF
	$DebugMessage = $DebugMessage & "Movement Speed : " & Round($MS) & " %" & @CRLF
	$DebugMessage = $DebugMessage & "Gold Find Total      : " & ($GF + ($NiveauParagon * 3) + ($MP * 25)) & " %" & @CRLF
	$DebugMessage = $DebugMessage & "      Equipement : " & $GF & " %" & @CRLF
	$DebugMessage = $DebugMessage & "Magic Find Total     : " & ($MF + ($NiveauParagon * 3) + ($MP * 25)) & " %" & @CRLF
	$DebugMessage = $DebugMessage & "      Equipement : " & $MF & " %" & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	Switch $Choix_Act_Run
		Case -1
			$file = FileOpen($fileLog, 0)
			$line = FileReadLine($file, 1)
			$DebugMessage = $DebugMessage & $line & @CRLF
			$line = FileReadLine($file, $numLigneFichier)
			$DebugMessage = $DebugMessage & $line & @CRLF
			FileClose($file)
		Case 0
			$DebugMessage = $DebugMessage & "Mode normal" & @CRLF
		Case 1
			$DebugMessage = $DebugMessage & "Acte 1 en automatique" & @CRLF
		Case 2
			$DebugMessage = $DebugMessage & "Acte 2 en automatique" & @CRLF
		Case 3
			$DebugMessage = $DebugMessage & "Acte 3 en automatique" & @CRLF
	EndSwitch



	$MESSAGE = $DebugMessage
	ToolTip($MESSAGE, $DebugX, $DebugY)

	$Totalruns = $Totalruns + 1 ;compte le nombre de run

EndFunc   ;==>StatsDisplay